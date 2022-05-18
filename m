Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D2852B850
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 13:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbiERLHm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 07:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbiERLHm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 07:07:42 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE493326E8;
        Wed, 18 May 2022 04:07:39 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9A4C721B1B;
        Wed, 18 May 2022 11:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652872058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zUhGSWHrx3rv3bkENTxaxo+kofIAuLzNYt4JWZORYTI=;
        b=wPGdnJ3i6B24PR6rXuHlz7QzMjcNc/o73fJY7uEcqClYV0RUByexQlmPJwMoXu9oRGeBlf
        PTGfWxMrSffnvr9X1LJFEUrW3rXR7KFwR5yR1iXn1Zkd8Sy60liiozsToG+OsZEq8YRLS2
        W3SZ13fxQBi9QYlQRppZNwNo0jir8nw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652872058;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zUhGSWHrx3rv3bkENTxaxo+kofIAuLzNYt4JWZORYTI=;
        b=cfRGmTOr1NgJshgz2O/1UuytuG8elRcLxUCNzHM4pWny+1GqkXrMPF86No4/KUDZJS4jZc
        qlzXOHtYYtZAHkBg==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 66D2F2C141;
        Wed, 18 May 2022 11:07:38 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 17EF8A062F; Wed, 18 May 2022 13:07:37 +0200 (CEST)
Date:   Wed, 18 May 2022 13:07:37 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v2 12/16] mm: factor out _balance_dirty_pages() from
 balance_dirty_pages()
Message-ID: <20220518110737.4fzi45htbwbtouve@quack3.lan>
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-13-shr@fb.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yxcv2ebdm4lqdefo"
Content-Disposition: inline
In-Reply-To: <20220516164718.2419891-13-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--yxcv2ebdm4lqdefo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 16-05-22 09:47:14, Stefan Roesch wrote:
> This factors out the for loop in balance_dirty_pages() into a new
> function called _balance_dirty_pages(). By factoring out this function
> the async write code can determine if it has to wait to throttle writes
> or not. The function _balance_dirty_pages() returns the sleep time.
> If the sleep time is greater 0, then the async write code needs to throttle.
> 
> To maintain the context for consecutive calls of _balance_dirty_pages()
> and maintain the current behavior a new data structure called bdp_ctx
> has been introduced.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>

...

> ---
>  mm/page-writeback.c | 452 +++++++++++++++++++++++---------------------
>  1 file changed, 239 insertions(+), 213 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 7e2da284e427..cbb74c0666c6 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -140,6 +140,29 @@ struct dirty_throttle_control {
>  	unsigned long		pos_ratio;
>  };
>  
> +/* context for consecutive calls to _balance_dirty_pages() */
> +struct bdp_ctx {
> +	long			pause;
> +	unsigned long		now;
> +	unsigned long		start_time;
> +	unsigned long		task_ratelimit;
> +	unsigned long		dirty_ratelimit;
> +	unsigned long		nr_reclaimable;
> +	int			nr_dirtied_pause;
> +	bool			dirty_exceeded;
> +
> +	struct dirty_throttle_control gdtc_stor;
> +	struct dirty_throttle_control mdtc_stor;
> +	struct dirty_throttle_control *sdtc;
> +} bdp_ctx;

Looking at how much context you propagate into _balance_dirty_pages() I
don't think this suggestion was as great as I've hoped. I'm sorry for that.
We could actually significantly reduce the amount of context passed in/out
but some things would be difficult to get rid of and some interactions of
code in _balance_dirty_pages() and the caller are actually pretty subtle.

I think something like attached three patches should make things NOWAIT
support in balance_dirty_pages() reasonably readable.

								Honza

> +
> +/* initialize _balance_dirty_pages() context */
> +#define BDP_CTX_INIT(ctx, wb)				\
> +	.gdtc_stor = { GDTC_INIT(wb) },			\
> +	.mdtc_stor = { MDTC_INIT(wb, &ctx.gdtc_stor) },	\
> +	.start_time = jiffies,				\
> +	.dirty_exceeded = false
> +
>  /*
>   * Length of period for aging writeout fractions of bdis. This is an
>   * arbitrarily chosen number. The longer the period, the slower fractions will
> @@ -1538,261 +1561,264 @@ static inline void wb_dirty_limits(struct dirty_throttle_control *dtc)
>  	}
>  }
>  
> -/*
> - * balance_dirty_pages() must be called by processes which are generating dirty
> - * data.  It looks at the number of dirty pages in the machine and will force
> - * the caller to wait once crossing the (background_thresh + dirty_thresh) / 2.
> - * If we're over `background_thresh' then the writeback threads are woken to
> - * perform some writeout.
> - */
> -static void balance_dirty_pages(struct bdi_writeback *wb,
> -				unsigned long pages_dirtied)
> +static inline int _balance_dirty_pages(struct bdi_writeback *wb,
> +					unsigned long pages_dirtied, struct bdp_ctx *ctx)
>  {
> -	struct dirty_throttle_control gdtc_stor = { GDTC_INIT(wb) };
> -	struct dirty_throttle_control mdtc_stor = { MDTC_INIT(wb, &gdtc_stor) };
> -	struct dirty_throttle_control * const gdtc = &gdtc_stor;
> -	struct dirty_throttle_control * const mdtc = mdtc_valid(&mdtc_stor) ?
> -						     &mdtc_stor : NULL;
> -	struct dirty_throttle_control *sdtc;
> -	unsigned long nr_reclaimable;	/* = file_dirty */
> +	struct dirty_throttle_control * const gdtc = &ctx->gdtc_stor;
> +	struct dirty_throttle_control * const mdtc = mdtc_valid(&ctx->mdtc_stor) ?
> +						     &ctx->mdtc_stor : NULL;
>  	long period;
> -	long pause;
>  	long max_pause;
>  	long min_pause;
> -	int nr_dirtied_pause;
> -	bool dirty_exceeded = false;
> -	unsigned long task_ratelimit;
> -	unsigned long dirty_ratelimit;
>  	struct backing_dev_info *bdi = wb->bdi;
>  	bool strictlimit = bdi->capabilities & BDI_CAP_STRICTLIMIT;
> -	unsigned long start_time = jiffies;
>  
> -	for (;;) {
> -		unsigned long now = jiffies;
> -		unsigned long dirty, thresh, bg_thresh;
> -		unsigned long m_dirty = 0;	/* stop bogus uninit warnings */
> -		unsigned long m_thresh = 0;
> -		unsigned long m_bg_thresh = 0;
> -
> -		nr_reclaimable = global_node_page_state(NR_FILE_DIRTY);
> -		gdtc->avail = global_dirtyable_memory();
> -		gdtc->dirty = nr_reclaimable + global_node_page_state(NR_WRITEBACK);
> +	unsigned long dirty, thresh, bg_thresh;
> +	unsigned long m_dirty = 0;	/* stop bogus uninit warnings */
> +	unsigned long m_thresh = 0;
> +	unsigned long m_bg_thresh = 0;
>  
> -		domain_dirty_limits(gdtc);
> +	ctx->now = jiffies;
> +	ctx->nr_reclaimable = global_node_page_state(NR_FILE_DIRTY);
> +	gdtc->avail = global_dirtyable_memory();
> +	gdtc->dirty = ctx->nr_reclaimable + global_node_page_state(NR_WRITEBACK);
>  
> -		if (unlikely(strictlimit)) {
> -			wb_dirty_limits(gdtc);
> +	domain_dirty_limits(gdtc);
>  
> -			dirty = gdtc->wb_dirty;
> -			thresh = gdtc->wb_thresh;
> -			bg_thresh = gdtc->wb_bg_thresh;
> -		} else {
> -			dirty = gdtc->dirty;
> -			thresh = gdtc->thresh;
> -			bg_thresh = gdtc->bg_thresh;
> -		}
> +	if (unlikely(strictlimit)) {
> +		wb_dirty_limits(gdtc);
>  
> -		if (mdtc) {
> -			unsigned long filepages, headroom, writeback;
> +		dirty = gdtc->wb_dirty;
> +		thresh = gdtc->wb_thresh;
> +		bg_thresh = gdtc->wb_bg_thresh;
> +	} else {
> +		dirty = gdtc->dirty;
> +		thresh = gdtc->thresh;
> +		bg_thresh = gdtc->bg_thresh;
> +	}
>  
> -			/*
> -			 * If @wb belongs to !root memcg, repeat the same
> -			 * basic calculations for the memcg domain.
> -			 */
> -			mem_cgroup_wb_stats(wb, &filepages, &headroom,
> -					    &mdtc->dirty, &writeback);
> -			mdtc->dirty += writeback;
> -			mdtc_calc_avail(mdtc, filepages, headroom);
> -
> -			domain_dirty_limits(mdtc);
> -
> -			if (unlikely(strictlimit)) {
> -				wb_dirty_limits(mdtc);
> -				m_dirty = mdtc->wb_dirty;
> -				m_thresh = mdtc->wb_thresh;
> -				m_bg_thresh = mdtc->wb_bg_thresh;
> -			} else {
> -				m_dirty = mdtc->dirty;
> -				m_thresh = mdtc->thresh;
> -				m_bg_thresh = mdtc->bg_thresh;
> -			}
> -		}
> +	if (mdtc) {
> +		unsigned long filepages, headroom, writeback;
>  
>  		/*
> -		 * Throttle it only when the background writeback cannot
> -		 * catch-up. This avoids (excessively) small writeouts
> -		 * when the wb limits are ramping up in case of !strictlimit.
> -		 *
> -		 * In strictlimit case make decision based on the wb counters
> -		 * and limits. Small writeouts when the wb limits are ramping
> -		 * up are the price we consciously pay for strictlimit-ing.
> -		 *
> -		 * If memcg domain is in effect, @dirty should be under
> -		 * both global and memcg freerun ceilings.
> +		 * If @wb belongs to !root memcg, repeat the same
> +		 * basic calculations for the memcg domain.
>  		 */
> -		if (dirty <= dirty_freerun_ceiling(thresh, bg_thresh) &&
> -		    (!mdtc ||
> -		     m_dirty <= dirty_freerun_ceiling(m_thresh, m_bg_thresh))) {
> -			unsigned long intv;
> -			unsigned long m_intv;
> +		mem_cgroup_wb_stats(wb, &filepages, &headroom,
> +				    &mdtc->dirty, &writeback);
> +		mdtc->dirty += writeback;
> +		mdtc_calc_avail(mdtc, filepages, headroom);
>  
> -free_running:
> -			intv = dirty_poll_interval(dirty, thresh);
> -			m_intv = ULONG_MAX;
> +		domain_dirty_limits(mdtc);
>  
> -			current->dirty_paused_when = now;
> -			current->nr_dirtied = 0;
> -			if (mdtc)
> -				m_intv = dirty_poll_interval(m_dirty, m_thresh);
> -			current->nr_dirtied_pause = min(intv, m_intv);
> -			break;
> +		if (unlikely(strictlimit)) {
> +			wb_dirty_limits(mdtc);
> +			m_dirty = mdtc->wb_dirty;
> +			m_thresh = mdtc->wb_thresh;
> +			m_bg_thresh = mdtc->wb_bg_thresh;
> +		} else {
> +			m_dirty = mdtc->dirty;
> +			m_thresh = mdtc->thresh;
> +			m_bg_thresh = mdtc->bg_thresh;
>  		}
> +	}
>  
> -		if (unlikely(!writeback_in_progress(wb)))
> -			wb_start_background_writeback(wb);
> +	/*
> +	 * Throttle it only when the background writeback cannot
> +	 * catch-up. This avoids (excessively) small writeouts
> +	 * when the wb limits are ramping up in case of !strictlimit.
> +	 *
> +	 * In strictlimit case make decision based on the wb counters
> +	 * and limits. Small writeouts when the wb limits are ramping
> +	 * up are the price we consciously pay for strictlimit-ing.
> +	 *
> +	 * If memcg domain is in effect, @dirty should be under
> +	 * both global and memcg freerun ceilings.
> +	 */
> +	if (dirty <= dirty_freerun_ceiling(thresh, bg_thresh) &&
> +	    (!mdtc ||
> +	     m_dirty <= dirty_freerun_ceiling(m_thresh, m_bg_thresh))) {
> +		unsigned long intv;
> +		unsigned long m_intv;
>  
> -		mem_cgroup_flush_foreign(wb);
> +free_running:
> +		intv = dirty_poll_interval(dirty, thresh);
> +		m_intv = ULONG_MAX;
> +
> +		current->dirty_paused_when = ctx->now;
> +		current->nr_dirtied = 0;
> +		if (mdtc)
> +			m_intv = dirty_poll_interval(m_dirty, m_thresh);
> +		current->nr_dirtied_pause = min(intv, m_intv);
> +		return 0;
> +	}
> +
> +	if (unlikely(!writeback_in_progress(wb)))
> +		wb_start_background_writeback(wb);
>  
> +	mem_cgroup_flush_foreign(wb);
> +
> +	/*
> +	 * Calculate global domain's pos_ratio and select the
> +	 * global dtc by default.
> +	 */
> +	if (!strictlimit) {
> +		wb_dirty_limits(gdtc);
> +
> +		if ((current->flags & PF_LOCAL_THROTTLE) &&
> +		    gdtc->wb_dirty <
> +		    dirty_freerun_ceiling(gdtc->wb_thresh,
> +					  gdtc->wb_bg_thresh))
> +			/*
> +			 * LOCAL_THROTTLE tasks must not be throttled
> +			 * when below the per-wb freerun ceiling.
> +			 */
> +			goto free_running;
> +	}
> +
> +	ctx->dirty_exceeded = (gdtc->wb_dirty > gdtc->wb_thresh) &&
> +		((gdtc->dirty > gdtc->thresh) || strictlimit);
> +
> +	wb_position_ratio(gdtc);
> +	ctx->sdtc = gdtc;
> +
> +	if (mdtc) {
>  		/*
> -		 * Calculate global domain's pos_ratio and select the
> -		 * global dtc by default.
> +		 * If memcg domain is in effect, calculate its
> +		 * pos_ratio.  @wb should satisfy constraints from
> +		 * both global and memcg domains.  Choose the one
> +		 * w/ lower pos_ratio.
>  		 */
>  		if (!strictlimit) {
> -			wb_dirty_limits(gdtc);
> +			wb_dirty_limits(mdtc);
>  
>  			if ((current->flags & PF_LOCAL_THROTTLE) &&
> -			    gdtc->wb_dirty <
> -			    dirty_freerun_ceiling(gdtc->wb_thresh,
> -						  gdtc->wb_bg_thresh))
> +			    mdtc->wb_dirty <
> +			    dirty_freerun_ceiling(mdtc->wb_thresh,
> +						  mdtc->wb_bg_thresh))
>  				/*
> -				 * LOCAL_THROTTLE tasks must not be throttled
> -				 * when below the per-wb freerun ceiling.
> +				 * LOCAL_THROTTLE tasks must not be
> +				 * throttled when below the per-wb
> +				 * freerun ceiling.
>  				 */
>  				goto free_running;
>  		}
> +		ctx->dirty_exceeded |= (mdtc->wb_dirty > mdtc->wb_thresh) &&
> +			((mdtc->dirty > mdtc->thresh) || strictlimit);
>  
> -		dirty_exceeded = (gdtc->wb_dirty > gdtc->wb_thresh) &&
> -			((gdtc->dirty > gdtc->thresh) || strictlimit);
> +		wb_position_ratio(mdtc);
> +		if (mdtc->pos_ratio < gdtc->pos_ratio)
> +			ctx->sdtc = mdtc;
> +	}
>  
> -		wb_position_ratio(gdtc);
> -		sdtc = gdtc;
> +	if (ctx->dirty_exceeded && !wb->dirty_exceeded)
> +		wb->dirty_exceeded = 1;
>  
> -		if (mdtc) {
> -			/*
> -			 * If memcg domain is in effect, calculate its
> -			 * pos_ratio.  @wb should satisfy constraints from
> -			 * both global and memcg domains.  Choose the one
> -			 * w/ lower pos_ratio.
> -			 */
> -			if (!strictlimit) {
> -				wb_dirty_limits(mdtc);
> -
> -				if ((current->flags & PF_LOCAL_THROTTLE) &&
> -				    mdtc->wb_dirty <
> -				    dirty_freerun_ceiling(mdtc->wb_thresh,
> -							  mdtc->wb_bg_thresh))
> -					/*
> -					 * LOCAL_THROTTLE tasks must not be
> -					 * throttled when below the per-wb
> -					 * freerun ceiling.
> -					 */
> -					goto free_running;
> -			}
> -			dirty_exceeded |= (mdtc->wb_dirty > mdtc->wb_thresh) &&
> -				((mdtc->dirty > mdtc->thresh) || strictlimit);
> +	if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
> +				   BANDWIDTH_INTERVAL))
> +		__wb_update_bandwidth(gdtc, mdtc, true);
> +
> +	/* throttle according to the chosen dtc */
> +	ctx->dirty_ratelimit = READ_ONCE(wb->dirty_ratelimit);
> +	ctx->task_ratelimit = ((u64)ctx->dirty_ratelimit * ctx->sdtc->pos_ratio) >>
> +						RATELIMIT_CALC_SHIFT;
> +	max_pause = wb_max_pause(wb, ctx->sdtc->wb_dirty);
> +	min_pause = wb_min_pause(wb, max_pause,
> +				 ctx->task_ratelimit, ctx->dirty_ratelimit,
> +				 &ctx->nr_dirtied_pause);
> +
> +	if (unlikely(ctx->task_ratelimit == 0)) {
> +		period = max_pause;
> +		ctx->pause = max_pause;
> +		goto pause;
> +	}
> +	period = HZ * pages_dirtied / ctx->task_ratelimit;
> +	ctx->pause = period;
> +	if (current->dirty_paused_when)
> +		ctx->pause -= ctx->now - current->dirty_paused_when;
> +	/*
> +	 * For less than 1s think time (ext3/4 may block the dirtier
> +	 * for up to 800ms from time to time on 1-HDD; so does xfs,
> +	 * however at much less frequency), try to compensate it in
> +	 * future periods by updating the virtual time; otherwise just
> +	 * do a reset, as it may be a light dirtier.
> +	 */
> +	if (ctx->pause < min_pause) {
> +		trace_balance_dirty_pages(wb,
> +					  ctx->sdtc->thresh,
> +					  ctx->sdtc->bg_thresh,
> +					  ctx->sdtc->dirty,
> +					  ctx->sdtc->wb_thresh,
> +					  ctx->sdtc->wb_dirty,
> +					  ctx->dirty_ratelimit,
> +					  ctx->task_ratelimit,
> +					  pages_dirtied,
> +					  period,
> +					  min(ctx->pause, 0L),
> +					  ctx->start_time);
> +		if (ctx->pause < -HZ) {
> +			current->dirty_paused_when = ctx->now;
> +			current->nr_dirtied = 0;
> +		} else if (period) {
> +			current->dirty_paused_when += period;
> +			current->nr_dirtied = 0;
> +		} else if (current->nr_dirtied_pause <= pages_dirtied)
> +			current->nr_dirtied_pause += pages_dirtied;
> +		return 0;
> +	}
> +	if (unlikely(ctx->pause > max_pause)) {
> +		/* for occasional dropped task_ratelimit */
> +		ctx->now += min(ctx->pause - max_pause, max_pause);
> +		ctx->pause = max_pause;
> +	}
>  
> -			wb_position_ratio(mdtc);
> -			if (mdtc->pos_ratio < gdtc->pos_ratio)
> -				sdtc = mdtc;
> -		}
> +pause:
> +	trace_balance_dirty_pages(wb,
> +				  ctx->sdtc->thresh,
> +				  ctx->sdtc->bg_thresh,
> +				  ctx->sdtc->dirty,
> +				  ctx->sdtc->wb_thresh,
> +				  ctx->sdtc->wb_dirty,
> +				  ctx->dirty_ratelimit,
> +				  ctx->task_ratelimit,
> +				  pages_dirtied,
> +				  period,
> +				  ctx->pause,
> +				  ctx->start_time);
> +
> +	return ctx->pause;
> +}
>  
> -		if (dirty_exceeded && !wb->dirty_exceeded)
> -			wb->dirty_exceeded = 1;
> -
> -		if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
> -					   BANDWIDTH_INTERVAL))
> -			__wb_update_bandwidth(gdtc, mdtc, true);
> -
> -		/* throttle according to the chosen dtc */
> -		dirty_ratelimit = READ_ONCE(wb->dirty_ratelimit);
> -		task_ratelimit = ((u64)dirty_ratelimit * sdtc->pos_ratio) >>
> -							RATELIMIT_CALC_SHIFT;
> -		max_pause = wb_max_pause(wb, sdtc->wb_dirty);
> -		min_pause = wb_min_pause(wb, max_pause,
> -					 task_ratelimit, dirty_ratelimit,
> -					 &nr_dirtied_pause);
> -
> -		if (unlikely(task_ratelimit == 0)) {
> -			period = max_pause;
> -			pause = max_pause;
> -			goto pause;
> -		}
> -		period = HZ * pages_dirtied / task_ratelimit;
> -		pause = period;
> -		if (current->dirty_paused_when)
> -			pause -= now - current->dirty_paused_when;
> -		/*
> -		 * For less than 1s think time (ext3/4 may block the dirtier
> -		 * for up to 800ms from time to time on 1-HDD; so does xfs,
> -		 * however at much less frequency), try to compensate it in
> -		 * future periods by updating the virtual time; otherwise just
> -		 * do a reset, as it may be a light dirtier.
> -		 */
> -		if (pause < min_pause) {
> -			trace_balance_dirty_pages(wb,
> -						  sdtc->thresh,
> -						  sdtc->bg_thresh,
> -						  sdtc->dirty,
> -						  sdtc->wb_thresh,
> -						  sdtc->wb_dirty,
> -						  dirty_ratelimit,
> -						  task_ratelimit,
> -						  pages_dirtied,
> -						  period,
> -						  min(pause, 0L),
> -						  start_time);
> -			if (pause < -HZ) {
> -				current->dirty_paused_when = now;
> -				current->nr_dirtied = 0;
> -			} else if (period) {
> -				current->dirty_paused_when += period;
> -				current->nr_dirtied = 0;
> -			} else if (current->nr_dirtied_pause <= pages_dirtied)
> -				current->nr_dirtied_pause += pages_dirtied;
> +/*
> + * balance_dirty_pages() must be called by processes which are generating dirty
> + * data.  It looks at the number of dirty pages in the machine and will force
> + * the caller to wait once crossing the (background_thresh + dirty_thresh) / 2.
> + * If we're over `background_thresh' then the writeback threads are woken to
> + * perform some writeout.
> + */
> +static void balance_dirty_pages(struct bdi_writeback *wb, unsigned long pages_dirtied)
> +{
> +	int ret;
> +	struct bdp_ctx ctx = { BDP_CTX_INIT(ctx, wb) };
> +
> +	for (;;) {
> +		ret = _balance_dirty_pages(wb, current->nr_dirtied, &ctx);
> +		if (!ret)
>  			break;
> -		}
> -		if (unlikely(pause > max_pause)) {
> -			/* for occasional dropped task_ratelimit */
> -			now += min(pause - max_pause, max_pause);
> -			pause = max_pause;
> -		}
>  
> -pause:
> -		trace_balance_dirty_pages(wb,
> -					  sdtc->thresh,
> -					  sdtc->bg_thresh,
> -					  sdtc->dirty,
> -					  sdtc->wb_thresh,
> -					  sdtc->wb_dirty,
> -					  dirty_ratelimit,
> -					  task_ratelimit,
> -					  pages_dirtied,
> -					  period,
> -					  pause,
> -					  start_time);
>  		__set_current_state(TASK_KILLABLE);
> -		wb->dirty_sleep = now;
> -		io_schedule_timeout(pause);
> +		wb->dirty_sleep = ctx.now;
> +		io_schedule_timeout(ctx.pause);
>  
> -		current->dirty_paused_when = now + pause;
> +		current->dirty_paused_when = ctx.now + ctx.pause;
>  		current->nr_dirtied = 0;
> -		current->nr_dirtied_pause = nr_dirtied_pause;
> +		current->nr_dirtied_pause = ctx.nr_dirtied_pause;
>  
>  		/*
>  		 * This is typically equal to (dirty < thresh) and can also
>  		 * keep "1000+ dd on a slow USB stick" under control.
>  		 */
> -		if (task_ratelimit)
> +		if (ctx.task_ratelimit)
>  			break;
>  
>  		/*
> @@ -1805,14 +1831,14 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
>  		 * more page. However wb_dirty has accounting errors.  So use
>  		 * the larger and more IO friendly wb_stat_error.
>  		 */
> -		if (sdtc->wb_dirty <= wb_stat_error())
> +		if (ctx.sdtc->wb_dirty <= wb_stat_error())
>  			break;
>  
>  		if (fatal_signal_pending(current))
>  			break;
>  	}
>  
> -	if (!dirty_exceeded && wb->dirty_exceeded)
> +	if (!ctx.dirty_exceeded && wb->dirty_exceeded)
>  		wb->dirty_exceeded = 0;
>  
>  	if (writeback_in_progress(wb))
> @@ -1829,7 +1855,7 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
>  	if (laptop_mode)
>  		return;
>  
> -	if (nr_reclaimable > gdtc->bg_thresh)
> +	if (ctx.nr_reclaimable > ctx.gdtc_stor.bg_thresh)
>  		wb_start_background_writeback(wb);
>  }
>  
> -- 
> 2.30.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--yxcv2ebdm4lqdefo
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-mm-Move-starting-of-background-writeback-into-the-ma.patch"

From e0ea549f8853275acc958b50381d3d6443711e20 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 17 May 2022 22:23:40 +0200
Subject: [PATCH 1/3] mm: Move starting of background writeback into the main
 balancing loop

We start background writeback if we are over background threshold after
exiting the main loop in balance_dirty_pages(). This may result in
basing the decision on already stale values (we may have slept for
significant amount of time) and it is also inconvenient for refactoring
needed for async dirty throttling. Move the check into the main waiting
loop.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/page-writeback.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7e2da284e427..8e5e003f0093 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1618,6 +1618,19 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
 			}
 		}
 
+		/*
+		 * In laptop mode, we wait until hitting the higher threshold
+		 * before starting background writeout, and then write out all
+		 * the way down to the lower threshold.  So slow writers cause
+		 * minimal disk activity.
+		 *
+		 * In normal mode, we start background writeout at the lower
+		 * background_thresh, to keep the amount of dirty memory low.
+		 */
+		if (!laptop_mode && nr_reclaimable > gdtc->bg_thresh &&
+		    !writeback_in_progress(wb))
+			wb_start_background_writeback(wb);
+
 		/*
 		 * Throttle it only when the background writeback cannot
 		 * catch-up. This avoids (excessively) small writeouts
@@ -1648,6 +1661,7 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
 			break;
 		}
 
+		/* Start writeback even when in laptop mode */
 		if (unlikely(!writeback_in_progress(wb)))
 			wb_start_background_writeback(wb);
 
@@ -1814,23 +1828,6 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
 
 	if (!dirty_exceeded && wb->dirty_exceeded)
 		wb->dirty_exceeded = 0;
-
-	if (writeback_in_progress(wb))
-		return;
-
-	/*
-	 * In laptop mode, we wait until hitting the higher threshold before
-	 * starting background writeout, and then write out all the way down
-	 * to the lower threshold.  So slow writers cause minimal disk activity.
-	 *
-	 * In normal mode, we start background writeout at the lower
-	 * background_thresh, to keep the amount of dirty memory low.
-	 */
-	if (laptop_mode)
-		return;
-
-	if (nr_reclaimable > gdtc->bg_thresh)
-		wb_start_background_writeback(wb);
 }
 
 static DEFINE_PER_CPU(int, bdp_ratelimits);
-- 
2.35.3


--yxcv2ebdm4lqdefo
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-mm-Move-updates-of-dirty_exceeded-into-one-place.patch"

From 239985ba7e36a0c7a5c741ba990f74a9fed1a877 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 17 May 2022 22:34:50 +0200
Subject: [PATCH 2/3] mm: Move updates of dirty_exceeded into one place

Transition of wb->dirty_exceeded from 0 to 1 happens before we go to
sleep in balance_dirty_pages() while transition from 1 to 0 happens when
exiting from balance_dirty_pages(), possibly based on old values. This
does not make a lot of sense since wb->dirty_exceeded should simply
reflect whether wb is over dirty limit and so we should ratelimit
entering to balance_dirty_pages() less. Move the two updates together.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/page-writeback.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 8e5e003f0093..89dcc7d8395a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1720,8 +1720,8 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
 				sdtc = mdtc;
 		}
 
-		if (dirty_exceeded && !wb->dirty_exceeded)
-			wb->dirty_exceeded = 1;
+		if (dirty_exceeded != wb->dirty_exceeded)
+			wb->dirty_exceeded = dirty_exceeded;
 
 		if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
 					   BANDWIDTH_INTERVAL))
@@ -1825,9 +1825,6 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
 		if (fatal_signal_pending(current))
 			break;
 	}
-
-	if (!dirty_exceeded && wb->dirty_exceeded)
-		wb->dirty_exceeded = 0;
 }
 
 static DEFINE_PER_CPU(int, bdp_ratelimits);
-- 
2.35.3


--yxcv2ebdm4lqdefo
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-mm-Prepare-balance_dirty_pages-for-async-buffered-wr.patch"

From 5489321cbd92385c3786c6ece86add9817abb015 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 18 May 2022 12:02:33 +0200
Subject: [PATCH 3/3] mm: Prepare balance_dirty_pages() for async buffered
 writes

If balance_dirty_pages() gets called for async buffered write, we don't
want to wait. Instead we need to indicate to the caller that throttling
is needed so that it can stop writing and offload the rest of the write
to a context that can block.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/page-writeback.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 89dcc7d8395a..fc3b79acd90b 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1545,8 +1545,8 @@ static inline void wb_dirty_limits(struct dirty_throttle_control *dtc)
  * If we're over `background_thresh' then the writeback threads are woken to
  * perform some writeout.
  */
-static void balance_dirty_pages(struct bdi_writeback *wb,
-				unsigned long pages_dirtied)
+static int balance_dirty_pages(struct bdi_writeback *wb,
+			       unsigned long pages_dirtied, bool nowait)
 {
 	struct dirty_throttle_control gdtc_stor = { GDTC_INIT(wb) };
 	struct dirty_throttle_control mdtc_stor = { MDTC_INIT(wb, &gdtc_stor) };
@@ -1566,6 +1566,7 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
 	struct backing_dev_info *bdi = wb->bdi;
 	bool strictlimit = bdi->capabilities & BDI_CAP_STRICTLIMIT;
 	unsigned long start_time = jiffies;
+	int ret = 0;
 
 	for (;;) {
 		unsigned long now = jiffies;
@@ -1794,6 +1795,10 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
 					  period,
 					  pause,
 					  start_time);
+		if (nowait) {
+			ret = -EAGAIN;
+			break;
+		}
 		__set_current_state(TASK_KILLABLE);
 		wb->dirty_sleep = now;
 		io_schedule_timeout(pause);
@@ -1825,6 +1830,7 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
 		if (fatal_signal_pending(current))
 			break;
 	}
+	return ret;
 }
 
 static DEFINE_PER_CPU(int, bdp_ratelimits);
@@ -1906,7 +1912,7 @@ void balance_dirty_pages_ratelimited(struct address_space *mapping)
 	preempt_enable();
 
 	if (unlikely(current->nr_dirtied >= ratelimit))
-		balance_dirty_pages(wb, current->nr_dirtied);
+		balance_dirty_pages(wb, current->nr_dirtied, false);
 
 	wb_put(wb);
 }
-- 
2.35.3


--yxcv2ebdm4lqdefo--
