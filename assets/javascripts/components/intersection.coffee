define ['react'], (React)->
  {li} = React.DOM

  class Intersection extends React.Component
    render: ()->
      street = this.props.street
      li {}, [street.street1, street.street2].join " & "
