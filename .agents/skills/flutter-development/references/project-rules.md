# Project Rules for Assinaturas Ninja

## Scope

- Build a Flutter MVP for recurring subscription tracking.
- Keep the app offline.
- Do not add backend, Firebase, login, remote sync, or real payment integration.

## Business Rules

- Only active subscriptions count toward monthly total, active count, and most-expensive summary.
- Paused and canceled subscriptions do not count toward monthly totals.
- A subscription is due soon when its next charge is within 5 days.
- Due today deserves strong visual emphasis.
- The due day must stay between 1 and 31.
- The price must be greater than zero.

## UI Rules

- Use a dark theme.
- Prefer rounded cards and clean spacing.
- Highlight with green, cyan, or purple accents.
- Keep the interface readable on a phone screen.
- Use Portuguese Brazilian text for all user-visible copy.

## Data and State

- Use English names in code.
- Prefer a simple provider-based state flow.
- Persist locally with the smallest practical dependency footprint.
- Start new users with an empty subscription list.
- Load sample data only after an explicit user action in onboarding or settings.

## Dashboard Expectations

- Show total monthly active spending.
- Show the number of active subscriptions.
- Show the most expensive active subscription.
- Show upcoming charges and highlight those that are close.
