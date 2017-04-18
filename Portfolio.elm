module ACM exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes as Attr
import Html.Lazy
import Material
import Material.Scheme
import Color as Color
import Material.Color as Colour
import Material.Button as Button
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Options exposing (when, css)
import Material.Options as Options
import Material.Layout as Layout
import Material.Footer as Footer
import Material.List as List
import Material.Grid exposing (..)
import FontAwesome as Fa

-- MODEL
      
type alias Model =
    { mdl : Mdl
    , raised : Int           
    }

type alias Mdl =
    Material.Model
    
    
model : Model
model =
    { mdl = Material.model
    , raised = -1     
    }
    
initmdl : (Model, Cmd Msg)
initmdl = (model, Material.init Mdl)
    
       
-- ACTION, UPDATE

type Msg
    = Mdl (Material.Msg Msg)
    | Raise Int  

      
update : Msg -> Model -> (Model, Cmd Msg)
update action model =
    case action of
        Mdl msg_ ->
            Material.update Mdl msg_ model
        Raise k ->
            { model | raised = k } ! []

-- VIEW

view : Model -> Html Msg
view = Html.Lazy.lazy view_
        
view_ : Model -> Html Msg
view_ model =
    Layout.render Mdl model.mdl
        [ Layout.fixedHeader
        ]
        { header = header model
        , drawer = []
        , main = [ viewBody model ]                   
        , tabs = ( [], [] )
        }

main : Program Never Model Msg 
main =
    program
        { init = initmdl
        , view = view
        , subscriptions = Material.subscriptions Mdl
        , update = update           
        }
        
               
button_twitter : Model -> Html Msg
button_twitter model =
    Button.render Mdl [0] model.mdl
  [ Button.icon
  , Button.ripple   
  , Button.link "https://twitter.com/flautinguy"    
  ]
  [ i [] [ Fa.twitter Color.white 25 ] ] 

button_twitter_share : Model -> Html Msg
button_twitter_share model =
    Button.render Mdl [9,0,0,2] model.mdl
  [ Button.icon      
  , Button.ripple   
  ]
  [ i [] [ Fa.twitter Color.lightBlue 25 ] ] 
      
      
button_facebook : Model -> Html Msg
button_facebook model =
    Button.render Mdl [0] model.mdl
  [ Button.icon
  , Button.ripple   
  , Button.link "https://www.facebook.com/k4migari"
  ]
  [ i [] [ Fa.facebook Color.white 25 ] ]

button_facebook_share : Model -> Html Msg
button_facebook_share model =
    Button.render Mdl [0] model.mdl
  [ Button.icon
  , Button.ripple   
  ]
  [ i [] [ Fa.facebook Color.darkBlue 25 ] ]
      

button_github : Model -> Html Msg
button_github model =
    Button.render Mdl [0] model.mdl
  [ Button.icon
  , Button.ripple   
  , Button.link "https://github.com/kamigari"    
  ]
  [ i [] [ Fa.github Color.white 25 ] ]      
        

header : Model -> List (Html Msg)
header model =
    [ Layout.row []
          [ Layout.title [] [
                 div []
                     [ text <| "Portfolio sketch" ]
                ]
          ]     
    ]        

black : Options.Property c m
black =
    Colour.text Colour.black           

dynamic : Int ->  Model -> Options.Style Msg
dynamic k model = 
  [ if model.raised == k then Elevation.e16 else Elevation.e3
  , Elevation.transition 300
  , Options.onMouseEnter (Raise k)
  , Options.onMouseLeave (Raise -1)
  ] |> Options.many        

lenguajes_c : Model -> Html Msg
lenguajes_c  model =
    List.ul []
        [ List.li []
              [ List.content [] 
                    [ List.avatarImage "images/c.jpg" []
                    , text "C"
                    ]
              ]
        ]

lenguajes_bash : Model -> Html Msg
lenguajes_bash  model =
    List.ul []
        [ List.li []
              [ List.content [] 
                    [ List.avatarImage "images/bash.jpg" []
                    , text "Bash"
                    ]
              ]
        ]

lenguajes_java : Model -> Html Msg
lenguajes_java  model =
    List.ul []
        [ List.li []
              [ List.content [] 
                    [ List.avatarImage "images/java.jpg" []
                    , text "Java"
                    ]
              ]
        ]

lenguajes_python : Model -> Html Msg
lenguajes_python  model =
    List.ul []
        [ List.li []
              [ List.content [] 
                    [ List.avatarImage "images/python.jpg" []
                    , text "Python"
                    ]
              ]
        ]        

lenguajes_latex : Model -> Html Msg
lenguajes_latex  model =
    List.ul []
        [ List.li []
              [ List.content [] 
                    [ List.avatarImage "images/latex.png" []
                    , text "LaTeX"
                    ]
              ]
        ]

lenguajes_js_html5_css3 : Model -> Html Msg
lenguajes_js_html5_css3  model =
    List.ul []
        [ List.li []
              [ List.content [ css "text-align" "center" ] 
                    [ List.avatarImage "images/HTML5-CSS3-JS.jpg" []
                    , text "HTML5 + CSS3 + JS"
                    ]
              ]
        ]

lenguajes_elm : Model -> Html Msg
lenguajes_elm  model =
    List.ul []
        [ List.li []
              [ List.content [ css "text-align" "center" ] 
                    [ List.avatarImage "images/elm.png" []
                    , text "Elm"
                    ]
              ]
        ]        
        
cardInformacion1 : Model -> Html Msg
cardInformacion1 model =
    Card.view
        [ css "width" "80%"
        , css "margin" "auto auto 15px auto"
        , dynamic 0 model
        , Colour.background ( Colour.primaryContrast )    
        ]
    [ Card.title [ css "margin" "0px auto 0px auto" ] [ Card.head [ black ] [ text "About me" ] ]
    , Card.text [ black , css "text-align" "center" ] [ text "Hello! I'm Alberto Revuelta Arribas and I am a computer engineering student based in Alcorcón, Madrid. This is a practice using elm-lang in web development. It also includes material design components. This web is a port to HTML, thing really usefull if the site only forward HTML files." ]
    , Card.text [ Card.expand ] []
    , Card.actions [ Card.border ] []
    , Card.title [ css "margin" "0px auto 0px auto" ] [ Card.head [ black ] [ text "Programming languages known" ] ]    
    , Card.text [ css "margin" "0px auto 0px auto" ] [ lenguajes_c model ]
    , Card.text [ css "margin" "0px auto 0px auto" ] [ lenguajes_bash model ]
    , Card.text [ css "margin" "0px auto 0px auto" ] [ lenguajes_java model ]
    , Card.text [ css "margin" "0px auto 0px auto" ] [ lenguajes_python model ]
    , Card.text [ css "margin" "0px auto 0px auto" ] [ lenguajes_latex model ]
    , Card.text [ css "margin" "0px auto 0px auto" ] [ lenguajes_js_html5_css3 model ]
    , Card.text [ css "margin" "0px auto 0px auto" ] [ lenguajes_elm model ]        
    , Card.text [ Card.expand ] []    
    , Card.actions
      [ Card.border, css "vertical-align" "center", css "text-align" "right", black ]
      [ Button.render Mdl [8,1] model.mdl
          [ Button.icon, Button.ripple, Button.link "https://twitter.com/home?status=Loved%20this%20material%20desing%20practice%20by%20%40flautinguy.%0Ahttps%3A//kamigari.github.io/"     ]
          [ div [] [ button_twitter_share model ] ]
      , Button.render Mdl [8,2] model.mdl
          [ Button.icon, Button.ripple, Button.link "https://www.facebook.com/sharer/sharer.php?u=https%3A//kamigari.github.io/" ]
          [ div [] [ button_facebook_share model ] ]
      ]    
    ]    
    
footer : Model -> Html Msg
footer model =
    Footer.mini []
        { left =
              Footer.left []
              [ Footer.logo [] [ Footer.html <| text "Copyright © 2017, Alberto Revuelta Arribas" ]
              ]
        , right =
            Footer.right []
                [ Footer.html <| button_twitter model
                , Footer.html <| button_facebook model
                , Footer.html <| button_github model    
                ]
        }           

viewBody : Model -> Html Msg
viewBody model =
    
    Material.Scheme.topWithScheme Colour.Indigo Colour.Pink <|

    let        
        bodyModels =
            div []
                ( List.map (\( html ) -> html)      
                      [ cardInformacion1 model
                      ] )
                    
        bodyFooter =
            Html.footer [] [ footer model ] 

    in
        main_ [] 
            [ body [ style [ ("display", "flex")
                      ,("flex-direction", "column")
                      ,("min-height","100vh")
                      ,("margin", "0")
                      ,("background", "url('images/background.jpg')")           
                      ] ]
                  [
                   grid [ css "flex" "1"
                        , css "width" "100%"
                        ]
                       [ cell [ Material.Grid.size Tablet 6
                              , Material.Grid.size Desktop 12
                              , Material.Grid.size Phone 2 ]
                             [ bodyModels ]     
                       ]
                  , bodyFooter
                  ]
            ]                   
