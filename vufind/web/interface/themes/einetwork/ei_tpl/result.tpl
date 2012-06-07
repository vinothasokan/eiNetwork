<div id="record{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="resultsList">
{*<div class="selectTitle">
  <input type="checkbox" class="titleSelect" name="selected[{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}]" id="selected{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" {if $enableBookCart}onclick="toggleInBag('{$summId|escape}', '{$summTitle|regex_replace:"/(\/|:)$/":""|escape:"javascript"}', this);"{/if} />&nbsp;
</div>*}
        
<div class="imageColumn">
    {if $user->disableCoverArt != 1}  
    <div id='descriptionPlaceholder{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}' style='display:none'></div>
    <a href="{$url}/Record/{$summId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" id="descriptionTrigger{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
    <img src="{$bookCoverUrl}" class="listResultImage" alt="{translate text='Cover Image'}"/>
    </a>
    {/if}
    {* Place hold link *}
    <div class='requestThisLink' id="placeHold{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" style="display:none">
      <a href="{$url}/Record/{$summId|escape:"url"}/Hold"><img src="{$path}/interface/themes/default/images/place_hold.png" alt="Place Hold"/></a>
    </div>
</div>

<div class="resultDetails">
  <div class="resultItemLine1">
  {if $summScore}({$summScore}) {/if}
	<a href="{$url}/Record/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="title">{if !$summTitle|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}{/if}</a>
	{if $summTitleStatement}
    <div class="searchResultSectionInfo">
      {$summTitleStatement|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}
    </div>
    {/if}
  </div>

  <div class="resultItemLine2">
    {if $summAuthor}
      {translate text='by'}
      {if is_array($summAuthor)}
        {foreach from=$summAuthor item=author}
          <a href="{$url}/Author/Home?author={$author|escape:"url"}">{$author|highlight:$lookfor}</a>
        {/foreach}
      {else}
        <a href="{$url}/Author/Home?author={$summAuthor|escape:"url"}">{$summAuthor|highlight:$lookfor}</a>
      {/if}
    {/if}
 
    {*{if $summDate}{translate text='Published'} {$summDate.0|escape}{/if} //szheng: commented*}
  </div>
  
  {* //szheng:commented
  <div class="resultItemLine3">
    {if !empty($summSnippetCaption)}<b>{translate text=$summSnippetCaption}:</b>{/if}
    {if !empty($summSnippet)}<span class="quotestart">&#8220;</span>...{$summSnippet|highlight}...<span class="quoteend">&#8221;</span><br />{/if}
  </div>
  *}
  {if is_array($summFormats)}
    {foreach from=$summFormats item=format}
      {if $format eq "Print Book"} 
      <img src="/interface/themes/einetwork/images/Art/Materialicons/Book.png"/ alt="Print Book">
      {/if}
      <span class="iconlabel" >{translate text=$format}</span>&nbsp;
    {/foreach}
  {else}
    <span class="iconlabel">{translate text=$summFormats}</span>
  {/if}
  <div id = "holdingsSummary{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="holdingsSummary">
    <div class="statusSummary" id="statusSummary{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
      <span class="unknown" style="font-size: 8pt;">{translate text='Loading'}...</span>
    </div>
  </div>
</div>

<div id ="searchStars{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="resultActions">
    <div class="view_details">
        <span><img alt="view_details" src="/interface/themes/einetwork/images/Art/ActionIcons/ViewDetails.png" class="view_details_img"></span>
        <span><a href="{$url}/Record/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="view_details_a">view details</a></span>
    </div>
    <div class="add_to_cart">
        <span><img alt="add_to_cart" src="/interface/themes/einetwork/images/Art/ActionIcons/AddToCart.png" class="add_to_cart_img"></span>
        <span class="add_to_cart_span" name="selected[{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}]" id="selected{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" {if $enableBookCart}onclick="sentToBag('{$summId|escape}', '{$summTitle|regex_replace:"/(\/|:)$/":""|escape:"javascript"}', this);"{/if}>add to cart</span>
    </div>
    <script type="text/javascript">
        addRatingId('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}');
        addIdToStatusList('{$summId|escape}');
        $(document).ready(function(){literal} { {/literal}
  	resultDescription('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}','{$summId}');
        {literal} }); {/literal}
    </script>
</div>
</div>
{*<div id ="searchStars{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="resultActions">
  <div class="rate{if $summShortId}{$summShortId}{else}{$summId|escape}{/if} stat">
	  <div class="statVal">
	    <span class="ui-rater">
	      <span class="ui-rater-starsOff" style="width:90px;"><span class="ui-rater-starsOn" style="width:0px"></span></span>
	      (<span class="ui-rater-rateCount-{if $summShortId}{$summShortId}{else}{$summId|escape}{/if} ui-rater-rateCount">0</span>)
	    </span>
	  </div>
    <div id="saveLink{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
      {if $user}
      	<div id="lists{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}"></div>
    		<script type="text/javascript">
    		  getSaveStatuses('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}');
    		</script>
      {/if}
      {if $showFavorites == 1} 
        <a href="{$url}/Resource/Save?id={$summId|escape:"url"}&amp;source=VuFind" style="padding-left:8px;" onclick="getSaveToListForm('{$summId}', 'VuFind'); return false;">{translate text='Add to'} <span class='myListLabel'>MyLIST</span></a>
      {/if}
    </div>
    {assign var=id value=$summId scope="global"}
    {assign var=shortId value=$summShortId scope="global"}
    {include file="Record/title-review.tpl"}
  </div>
  <script type="text/javascript">
    $(
       function() {literal} { {/literal}
           $('.rate{if $summShortId}{$summShortId|escape}{else}{$summId|escape}{/if}').rater({literal}{ {/literal}module: 'Record', recordId: '{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}',  rating:0.0, postHref: '{$url}/Record/{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}/AJAX?method=RateTitle'{literal} } {/literal});
       {literal} } {/literal}
    );
  </script>
    
</div>


<script type="text/javascript">
  addRatingId('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}');
  addIdToStatusList('{$summId|escape}');
  $(document).ready(function(){literal} { {/literal}
  	resultDescription('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}','{$summId}');
  {literal} }); {/literal}
  
</script>

</div>*}