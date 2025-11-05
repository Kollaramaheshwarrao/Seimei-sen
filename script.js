class LifeCountdownWidget {
    constructor() {
        this.birthDate = null;
        this.lifeExpectancy = 80;
        this.showingLived = false;
        this.currentQuoteIndex = 0;
        
        this.quotes = [
            "Make every second legendary.",
            "Time is your most valuable asset.",
            "Be the story you want remembered.",
            "1% better than yesterday.",
            "Every moment is a fresh beginning.",
            "Your time is limited, make it count.",
            "Life is what happens while you're making plans.",
            "The best time to plant a tree was 20 years ago. The second best time is now."
        ];
        
        this.init();
    }
    
    init() {
        this.loadSettings();
        this.bindEvents();
        this.updateDateTime();
        this.startCountdown();
        this.rotateQuotes();
        
        // Set initial quote
        document.getElementById('motivationQuote').textContent = this.quotes[0];
    }
    
    bindEvents() {
        document.getElementById('themeToggle').addEventListener('click', this.toggleTheme.bind(this));
        document.getElementById('toggleMode').addEventListener('click', this.toggleMode.bind(this));
        document.getElementById('widget').addEventListener('click', this.openMotivationScreen.bind(this));
        document.getElementById('closeScreen').addEventListener('click', this.closeMotivationScreen.bind(this));
        document.getElementById('settingsBtn').addEventListener('click', this.openSettings.bind(this));
        document.getElementById('saveSettings').addEventListener('click', this.saveSettings.bind(this));
        document.getElementById('startSomething').addEventListener('click', this.startSomething.bind(this));
        
        // Prevent widget click when clicking buttons
        document.querySelectorAll('button').forEach(btn => {
            btn.addEventListener('click', (e) => e.stopPropagation());
        });
    }
    
    loadSettings() {
        const savedBirthDate = localStorage.getItem('birthDate');
        const savedLifeExpectancy = localStorage.getItem('lifeExpectancy');
        const savedTheme = localStorage.getItem('theme');
        
        if (savedBirthDate) {
            this.birthDate = new Date(savedBirthDate);
            document.getElementById('birthDate').value = savedBirthDate;
        } else {
            // Default to 25 years ago for demo
            this.birthDate = new Date();
            this.birthDate.setFullYear(this.birthDate.getFullYear() - 25);
        }
        
        if (savedLifeExpectancy) {
            this.lifeExpectancy = parseInt(savedLifeExpectancy);
            document.getElementById('lifeExpectancy').value = this.lifeExpectancy;
        }
        
        if (savedTheme) {
            document.body.setAttribute('data-theme', savedTheme);
            document.getElementById('themeToggle').textContent = savedTheme === 'light' ? '🌙' : '☀️';
        }
    }
    
    saveSettings() {
        const birthDate = document.getElementById('birthDate').value;
        const lifeExpectancy = document.getElementById('lifeExpectancy').value;
        
        if (birthDate) {
            this.birthDate = new Date(birthDate);
            localStorage.setItem('birthDate', birthDate);
        }
        
        if (lifeExpectancy) {
            this.lifeExpectancy = parseInt(lifeExpectancy);
            localStorage.setItem('lifeExpectancy', lifeExpectancy);
        }
        
        document.getElementById('settingsPanel').style.display = 'none';
        this.updateCountdown();
    }
    
    toggleTheme() {
        const currentTheme = document.body.getAttribute('data-theme');
        const newTheme = currentTheme === 'light' ? 'dark' : 'light';
        
        document.body.setAttribute('data-theme', newTheme);
        document.getElementById('themeToggle').textContent = newTheme === 'light' ? '🌙' : '☀️';
        localStorage.setItem('theme', newTheme);
    }
    
    toggleMode() {
        this.showingLived = !this.showingLived;
        const btn = document.getElementById('toggleMode');
        btn.textContent = this.showingLived ? 'Show Time Remaining' : 'Show Time Lived';
        this.updateCountdown();
    }
    
    calculateTime() {
        if (!this.birthDate) return null;
        
        const now = new Date();
        const birth = new Date(this.birthDate);
        const expectedDeath = new Date(birth);
        expectedDeath.setFullYear(birth.getFullYear() + this.lifeExpectancy);
        
        const totalLifeMs = expectedDeath - birth;
        const livedMs = now - birth;
        const remainingMs = expectedDeath - now;
        
        const livedPercent = Math.min((livedMs / totalLifeMs) * 100, 100);
        
        if (this.showingLived) {
            return {
                ms: livedMs,
                percent: livedPercent,
                isLived: true
            };
        } else {
            return {
                ms: Math.max(remainingMs, 0),
                percent: livedPercent,
                isLived: false
            };
        }
    }
    
    msToTimeUnits(ms) {
        const seconds = Math.floor(ms / 1000);
        const minutes = Math.floor(seconds / 60);
        const hours = Math.floor(minutes / 60);
        const days = Math.floor(hours / 24);
        const weeks = Math.floor(days / 7);
        const months = Math.floor(days / 30.44);
        const years = Math.floor(days / 365.25);
        
        return {
            years: years,
            months: months % 12,
            weeks: weeks % 4,
            days: days % 7,
            hours: hours % 24,
            minutes: minutes % 60,
            seconds: seconds % 60
        };
    }
    
    updateCountdown() {
        const timeData = this.calculateTime();
        if (!timeData) return;
        
        const timeUnits = this.msToTimeUnits(timeData.ms);
        
        document.getElementById('years').textContent = timeUnits.years;
        document.getElementById('months').textContent = timeUnits.months;
        document.getElementById('days').textContent = timeUnits.days;
        document.getElementById('hours').textContent = timeUnits.hours;
        document.getElementById('minutes').textContent = timeUnits.minutes;
        document.getElementById('seconds').textContent = timeUnits.seconds;
        
        // Update progress circle
        const circle = document.querySelector('.progress-ring-circle');
        const circumference = 2 * Math.PI * 54;
        const offset = circumference - (timeData.percent / 100) * circumference;
        circle.style.strokeDashoffset = offset;
        
        document.getElementById('progressPercent').textContent = `${Math.round(timeData.percent)}%`;
        
        // Update life summary
        const totalYears = Math.floor(timeData.ms / (365.25 * 24 * 60 * 60 * 1000));
        const totalDays = Math.floor(timeData.ms / (24 * 60 * 60 * 1000));
        const totalHours = Math.floor(timeData.ms / (60 * 60 * 1000));
        
        if (timeData.isLived) {
            document.getElementById('lifeSummary').textContent = 
                `You have lived ${totalYears} years, ${totalDays % 365} days, ${totalHours % 24} hours of your precious life.`;
        } else {
            document.getElementById('lifeSummary').textContent = 
                `You have approximately ${totalYears} years, ${totalDays % 365} days, ${totalHours % 24} hours remaining.`;
        }
    }
    
    updateDateTime() {
        const now = new Date();
        const options = {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        };
        
        document.getElementById('currentDateTime').textContent = now.toLocaleDateString('en-US', options);
    }
    
    startCountdown() {
        this.updateCountdown();
        setInterval(() => {
            this.updateCountdown();
            this.updateDateTime();
        }, 1000);
    }
    
    rotateQuotes() {
        setInterval(() => {
            this.currentQuoteIndex = (this.currentQuoteIndex + 1) % this.quotes.length;
            document.getElementById('motivationQuote').textContent = this.quotes[this.currentQuoteIndex];
            
            // Also update daily quote
            const dailyQuoteIndex = (this.currentQuoteIndex + 3) % this.quotes.length;
            document.getElementById('dailyQuote').textContent = this.quotes[dailyQuoteIndex];
        }, 10000); // Change every 10 seconds for demo (change to 3600000 for hourly)
    }
    
    openMotivationScreen() {
        document.getElementById('motivationScreen').style.display = 'flex';
        this.updateDateTime();
    }
    
    closeMotivationScreen() {
        document.getElementById('motivationScreen').style.display = 'none';
    }
    
    openSettings() {
        document.getElementById('settingsPanel').style.display = 'block';
    }
    
    startSomething() {
        const actions = [
            "Write in a journal for 5 minutes",
            "Call someone you care about",
            "Take a 10-minute walk outside",
            "Learn something new for 15 minutes",
            "Practice gratitude - list 3 things you're thankful for",
            "Do 10 push-ups or stretches",
            "Read one page of a book",
            "Organize one small area of your space"
        ];
        
        const randomAction = actions[Math.floor(Math.random() * actions.length)];
        alert(`Today's suggestion: ${randomAction}`);
    }
}

// Initialize the widget when the page loads
document.addEventListener('DOMContentLoaded', () => {
    new LifeCountdownWidget();
});

// Add some visual effects
document.addEventListener('DOMContentLoaded', () => {
    // Add glow effect to progress circle
    const progressRing = document.querySelector('.progress-ring-circle');
    if (progressRing) {
        progressRing.classList.add('glow');
    }
    
    // Add subtle animations to time units
    const timeUnits = document.querySelectorAll('.time-unit');
    timeUnits.forEach((unit, index) => {
        unit.style.animationDelay = `${index * 0.1}s`;
    });
});