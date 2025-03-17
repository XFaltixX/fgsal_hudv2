
var rgbStart = [139,195,74]
var rgbEnd = [183,28,28]

$(function(){
	window.addEventListener('message', function(event) {
		if (event.data.action == "setValue"){
			if (event.data.key == "job"){
				setJobIcon(event.data.icon)
			}
			setValue(event.data.key, event.data.value)
		}else if (event.data.action == "setValue2"){
			if (event.data.key == "job2"){
				setJob2Icon(event.data.icon2)
			}
			setValue(event.data.key, event.data.value)
		}else if (event.data.action == "updateStatus"){
			updateStatus(event.data.status);
		}else if (event.data.action == "setTalking"){

			setTalking(event.data.value)
		}else if (event.data.action == "setProximity"){
			setProximity(event.data.value)
		}else if (event.data.action == "toggle"){
			if (event.data.show){
				$('#ui').show();
			} else{
				$('#ui').hide();
			}
		} else if (event.data.action == "toggleCar"){
			if (event.data.show){
				//$('.carStats').show();
			} else{
				//$('.carStats').hide();
			}
		}else if (event.data.action == "updateCarStatus"){
			updateCarStatus(event.data.status)
		/*}else if (event.data.action == "updateWeight"){
			updateWeight(event.data.weight)*/
		}
	});

});

function updateWeight(weight){


	var bgcolor = colourGradient(weight/100, rgbEnd, rgbStart)
	$('#weight .bg').css('height', weight+'%')
	$('#weight .bg').css('background-color', 'rgb(' + bgcolor[0] +','+ bgcolor[1] +','+ bgcolor[2] +')')
}

function updateCarStatus(status){
	var gas = status[0]
	$('#gas .bg').css('height', gas.percent+'%')
	var bgcolor = colourGradient(gas.percent/100, rgbStart, rgbEnd)
	//var bgcolor = colourGradient(0.1, rgbStart, rgbEnd)
	//$('#gas .bg').css('height', '10%')
	$('#gas .bg').css('background-color', 'rgb(' + bgcolor[0] +','+ bgcolor[1] +','+ bgcolor[2] +')')
}

function setValue(key, value){
	$('#'+key+' span').html(value)

}

function setJobIcon(value){
	$('#job img').attr('src', 'img/jobs/'+value+'.png')
	//$('#job img').attr('src', 'img/jobs/'+value+'.png')
}

function setJob2Icon(value){
	$('#job2 img').attr('src', 'img/jobs/'+value+'.png')
}

function updateStatus(status){
	var hunger = status[1]
	var thirst = status[2]
	var drunk = status[3]
	$('#hunger .bg').css('height', hunger.percent+'%')
	$('#water .bg').css('height', thirst.percent+'%')
	// $('#drunk .bg').css('height', drunk.percent+'%');
	// if (drunk.percent > 0){
	// 	$('#drunk').show();
	// }else{
	// 	$('#drunk').show();
	// }

}

function setProximity(value){
	var color;
	var speaker;
	if (value == "whisper"){
		color = "#FFEB3B";
		speaker = 1;
	}else if (value == "normal"){
		color = "#81C784"
		speaker = 2;
	}else if (value == "shout"){
		color = "#e53935"
		speaker = 3;

	}
	$('#voice .bg').css('background-color', color);
	$('#voice img').attr('src', 'img/speaker'+speaker+'.png');
}	

function setTalking(value){
	if (value){
		//#64B5F6
		$('#voice').css('border', '3px solid rgb(255, 255, 255)')
	}else{
		//#81C784
		$('#voice').css('border', 'none')
	}
}

//API Shit
function colourGradient(p, rgb_beginning, rgb_end){
    var w = p * 2 - 1;

    var w1 = (w + 1) / 2.0;
    var w2 = 1 - w1;

    var rgb = [parseInt(rgb_beginning[0] * w1 + rgb_end[0] * w2),
        parseInt(rgb_beginning[1] * w1 + rgb_end[1] * w2),
            parseInt(rgb_beginning[2] * w1 + rgb_end[2] * w2)];
    return rgb;
};


window.addEventListener('message', function(event) {
    let data = event.data;

	var hungerpercent = data.hunger
	var thirstpercent = data.thirst
	$('#hunger .bg').css('height', hungerpercent+'%')
	$('#water .bg').css('height', thirstpercent+'%')

});





document.addEventListener('DOMContentLoaded', () => {
    const hud = document.querySelector('.playerStats');
    let isDragging = false;
    let isDragModeEnabled = false;
    let startX, startY, initialX, initialY;

    const savedPosition = JSON.parse(localStorage.getItem('hudPosition'));
    if (savedPosition) {
        hud.style.top = savedPosition.top;
        hud.style.left = savedPosition.left;
        hud.style.position = 'absolute';
    }

    hud.addEventListener('mousedown', (e) => {
        if (isDragModeEnabled) {
            isDragging = true;
            startX = e.clientX;
            startY = e.clientY;
            initialX = hud.offsetLeft;
            initialY = hud.offsetTop;
            e.preventDefault(); 
        }
    });

    document.addEventListener('mousemove', (e) => {
        if (isDragging) {
            const dx = e.clientX - startX;
            const dy = e.clientY - startY;
            hud.style.top = `${initialY + dy}px`;
            hud.style.left = `${initialX + dx}px`;
        }
    });

    document.addEventListener('mouseup', () => {
        if (isDragging) {
            isDragging = false;
            localStorage.setItem('hudPosition', JSON.stringify({
                top: hud.style.top,
                left: hud.style.left,
            }));
        }
    });

    window.addEventListener('message', (event) => {
        const data = event.data;

        if (data.action === 'enableDrag') {
            isDragModeEnabled = true;
            document.body.style.cursor = 'move'; 
        } else if (data.action === 'disableDrag') {
            isDragModeEnabled = false;
            document.body.style.cursor = 'default'; 
        } else if (data.action === 'resetHUD') {
			hud.style.top = 'unset'; 
			hud.style.left = '340px'; 
			hud.style.right = 'unset'; 
			hud.style.bottom = '28px'; 

			localStorage.removeItem('hudPosition');
		}
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' && isDragModeEnabled) {
            isDragModeEnabled = false; 
            document.body.style.cursor = 'default';

            fetch(`https://${GetParentResourceName()}/closeUI`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify({})
            }).then(resp => {
                console.log('HUD position saved and drag mode disabled');
                window.postMessage({ action: 'disableDrag' }, '*');
            }).catch(err => {
                console.error('Error closing NUI:', err);
            });
        }
    });
});
