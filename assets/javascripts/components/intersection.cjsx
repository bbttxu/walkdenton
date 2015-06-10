# street.cjsx


define ['react'], (React)->
  Intersection = React.createClass
    render: ()->
      street = this.props.street
      <li>{street.street1} &amp; {street.street2}</li>
