# TC Nomad - Interactive Prototype

A fully connected, clickable prototype for the TC Nomad travel packing application.

## 🚀 Getting Started

**Open [index.html](index.html) in your browser** to access the master navigation page.

## 📱 Navigation Features

### Master Index Page
- **Visual sitemap** with all 14 wireframes organized by category
- **Quick stats** showing prototype scope
- **Color-coded cards** (Admin/Mobile) for easy identification
- Click any card to jump directly to that wireframe

### Global Navigation
All wireframes include:
- **"Back to Index" button** - Always accessible (top-left or top-right)
- **Keyboard shortcuts**:
  - Press `ESC` to return to index from any screen
  - Press `←` / `→` arrow keys to navigate between sequential screens (on flow screens)

### Flow-Based Navigation
Sequential screens have additional navigation:
- **Previous/Next buttons** in navigation overlay
- **Connected user journeys** that guide through complete flows

## 🗺️ User Flows

### Admin Dashboard Flow
1. [Admin Panel v1](tc_nomad_admin_panel1.html) - Main dashboard with 5 sections
2. [Enhanced Admin Panel v2](tc_nomad_enhanced_admin_panel2.html) - Improved version
3. [Trip Types Admin](trip_types_admin_page.html) - Manage trip configurations
4. [Settings Module](tc_nomad_settings_wireframe.html) - System settings

### Mobile Packing Flow (Sequential)
1. **[Step 1: Smart Packing List](tc-nomad-step1-wireframe.html)** → Generate AI-powered packing list
   - Next: Step 2A
2. **[Step 2A: Compartment View](tc-nomad-step2a-compartments.html)** → Organize items by compartment
   - Previous: Step 1 | Next: Step 2B
3. **[Step 2B: Visual Guide](tc-nomad-step2b-visual-guide.html)** → Interactive packing visualization
   - Previous: Step 2A | Next: Mode & Ready
4. **[Mode & Ready](tc-nomad-mode-and-ready.html)** → Final preparation and completion
   - Previous: Step 2B

### Supporting Screens
- [Main App Screens](tc_nomad_main_wireframes.html) - Home, trips, profile
- [Base Wireframes](tc_nomad_wireframe.html) - Core mobile layouts
- [Enhanced Trip Flow](tc_nomad_enhanced_trip_flow.html) - Trip creation wizard
- [Luggage Selection](tc_nomad_luggage_flow_enhanced.html) - Luggage configuration
- [Add Item Modal](tc-nomad-add-item-modal.html) - Quick item creation
- [Premium Paywall](tc_nomad_paywall_screen.html) - Subscription screen

## 🎨 Features

### Interactive Elements
- ✅ Clickable buttons and navigation
- ✅ Screen transitions within multi-screen wireframes
- ✅ Sequential flow navigation with prev/next
- ✅ Keyboard shortcuts for power users
- ✅ Responsive overlay navigation

### Design System
- **Admin screens**: Desktop-first layout with sidebar navigation
- **Mobile screens**: iPhone container with bottom navigation
- **Consistent styling**: Apple-inspired design language
- **Color coding**: Blue (primary actions), gradient accents

## 📊 Prototype Stats

- **Total Wireframes**: 14
- **Admin Screens**: 4 (5 including enhanced version)
- **Mobile Screens**: 9
- **User Flows**: 3+ complete journeys
- **Navigation Points**: 50+ interactive connections

## 💡 Tips

1. **Start with index.html** - Get an overview of all screens
2. **Follow the flows** - Use the sequential navigation to experience complete user journeys
3. **Try keyboard shortcuts** - Press ESC or arrow keys for quick navigation
4. **Click everything** - Buttons, cards, and nav items are interactive
5. **Share the URL** - Send index.html to stakeholders for review

## 🔄 Flow Diagrams

### Main Packing Journey
```
Main App → Enhanced Trip Flow → Step 1: Packing List
                                      ↓
                                 Step 2A: Compartments
                                      ↓
                                 Step 2B: Visual Guide
                                      ↓
                                Mode & Ready → Save to History
```

### Admin Management
```
Admin Dashboard → Users / Luggage / Airlines / Settings
                ↓
         Enhanced Admin Panel
                ↓
         Trip Types Management
```

## 🎯 Next Steps

This prototype is ready for:
- ✅ Stakeholder presentations
- ✅ User testing sessions
- ✅ Design reviews
- ✅ Developer handoff
- ✅ Investor demos

---

**Built with**: Pure HTML/CSS/JavaScript
**Browser**: Works in all modern browsers
**No dependencies**: Self-contained prototype
