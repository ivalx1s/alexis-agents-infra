# Visual Styles

styles {
  # People
  element "Person" {
    shape person
    background #08427b
    color #ffffff
  }

  # Software Systems
  element "Software System" {
    background #1168bd
    color #ffffff
  }

  element "External" {
    background #999999
    color #ffffff
  }

  # Containers
  element "Container" {
    background #438dd5
    color #ffffff
  }

  element "Database" {
    shape cylinder
  }

  element "Queue" {
    shape pipe
  }

  element "WebApp" {
    shape WebBrowser
  }

  element "Mobile" {
    shape MobileDeviceLandscape
  }

  element "API" {
    shape RoundedBox
  }

  # Components
  element "Component" {
    background #85bbf0
    color #000000
  }

  # Relationships
  relationship "Relationship" {
    thickness 2
    color #707070
  }

  relationship "Async" {
    style dotted
  }
}
