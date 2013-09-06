package durian.display
{
    public interface IMultiStateAnimation extends IAnimation
    {
        function updateAnimationConfig( animationConfig:Vector.<Vector.<String>> ):void;
        function set stateIndex( value:uint ):void;
        function get stateIndex():uint;
    }
}