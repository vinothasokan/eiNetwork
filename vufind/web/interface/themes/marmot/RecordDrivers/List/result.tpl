<div id="record{$summId|escape}">
<div class="selectTitle">
  <input type="checkbox" name="selected[{$summShortId|escape:"url"}]" id="selected{$summShortId|escape:"url"}" style="display:none" />&nbsp;
</div>
        
<div class="yui-u first resultsList">
  {* Include holdings summary of the list (we don't have one, but we need it as a placeholder for alignment) *}
  <div class="holdingsSummary"  style="width:200px;height:64px;border:none;background:none" >
  </div>
  <div class="yui-ge">
    
    <a href="{$url}/MyResearch/MyList/{$summShortId}">
    <img src="{$path}/interface/themes/marmot/images/list.png" class="alignleft listResultImage" alt="{translate text='No Cover Image'}"/><br />
    </a>
    
   
    <div class="resultitem">
      <div class="resultItemLine1">
	      <a href="{$url}/MyResearch/MyList/{$summShortId}" class="title">{if !$summTitle}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}{/if}</a>
	      {if $summTitleStatement}
          <div class="searchResultSectionInfo">
          {$summTitleStatement|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}
          </div>
        {/if}
      </div>

      <div class="resultItemLine2">
        {if $summDescription}
          {$summDescription|truncate:500:"..."|highlight:$lookfor}
        {/if}
      </div>
      <div class="resultItemLine3">
        {if $summNumTitles}
          {$summNumTitles} titles are in this list.
        {/if}
      </div>
      
    </div>
  </div>
     
</div>
{* Clear floats so the record displays as a block*}
<div class='clearer'></div>
</div>