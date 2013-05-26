
package DigEng is

function log2 (x : natural ) return natural;

end DigEng;

package body DigEng is

function log2 ( x : natural ) return natural is
        variable temp : natural := x ;
        variable n : natural := 0 ;
    begin
        while temp > 1 loop
            temp := temp / 2 ;
            n := n + 1 ;
        end loop ;
        return n ;
end function log2;

end DigEng;
