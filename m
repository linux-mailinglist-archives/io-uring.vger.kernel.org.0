Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE9D52AC7F
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 22:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbiEQUM1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 16:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350965AbiEQUMZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 16:12:25 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2863ED3D;
        Tue, 17 May 2022 13:12:22 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6A66D1F895;
        Tue, 17 May 2022 20:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652818341; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wMAzSosFrjpyRNHwhTimMiNBTp0PkkatvGjrNxqNU48=;
        b=ciBGttDVnx396lqefuZvz7Jaz9e46oM1bffmaTeWnfaGG9gVqVF9ERwEgpeDU6R1TczXyO
        lxwngz++2bjaHQzSy/Qss77vOTGr3PXqIiOUs995jNSAKhdXw5HbNGZ9vBixKH20FEz8gT
        DAG94sGBCn5AK+gSXyKs9fLFn22r0+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652818341;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wMAzSosFrjpyRNHwhTimMiNBTp0PkkatvGjrNxqNU48=;
        b=JgFSfLg37D5cCZs4p9bObYfTEs+h+fQURBXHEKRMmgvZRFU969Yj4IyNx6/lRo9uGCx55h
        qSy7tyPZxj1KpiAA==
Received: from quack3.suse.cz (jack.udp.ovpn2.nue.suse.de [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3AC632C141;
        Tue, 17 May 2022 20:12:21 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id E8F10A0631; Tue, 17 May 2022 22:12:17 +0200 (CEST)
Date:   Tue, 17 May 2022 22:12:17 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v2 13/16] mm: add
 balance_dirty_pages_ratelimited_flags() function
Message-ID: <20220517201217.sr2sojdeas5k5cim@quack3.lan>
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-14-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516164718.2419891-14-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon 16-05-22 09:47:15, Stefan Roesch wrote:
> This adds the function balance_dirty_pages_ratelimited_flags(). It adds
> the parameter is_async to balance_dirty_pages_ratelimited(). In case
> this is an async write, it will call _balance_diirty_pages() to
> determine if write throttling needs to be enabled. If write throttling
> is enabled, it retuns -EAGAIN, so the write request can be punted to
> the io-uring worker.
> 
> The new function is changed to return the sleep time, so callers can
> observe if the write has been punted.
> 
> For non-async writes the current behavior is maintained.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  include/linux/writeback.h |  1 +
>  mm/page-writeback.c       | 48 ++++++++++++++++++++++++++-------------
>  2 files changed, 33 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index fec248ab1fec..d589804bb3be 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -373,6 +373,7 @@ unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thresh);
>  
>  void wb_update_bandwidth(struct bdi_writeback *wb);
>  void balance_dirty_pages_ratelimited(struct address_space *mapping);
> +int  balance_dirty_pages_ratelimited_flags(struct address_space *mapping, bool is_async);
>  bool wb_over_bg_thresh(struct bdi_writeback *wb);
>  
>  typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index cbb74c0666c6..78f1326f3f20 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1877,28 +1877,17 @@ static DEFINE_PER_CPU(int, bdp_ratelimits);
>   */
>  DEFINE_PER_CPU(int, dirty_throttle_leaks) = 0;
>  
> -/**
> - * balance_dirty_pages_ratelimited - balance dirty memory state
> - * @mapping: address_space which was dirtied
> - *
> - * Processes which are dirtying memory should call in here once for each page
> - * which was newly dirtied.  The function will periodically check the system's
> - * dirty state and will initiate writeback if needed.
> - *
> - * Once we're over the dirty memory limit we decrease the ratelimiting
> - * by a lot, to prevent individual processes from overshooting the limit
> - * by (ratelimit_pages) each.
> - */
> -void balance_dirty_pages_ratelimited(struct address_space *mapping)
> +int balance_dirty_pages_ratelimited_flags(struct address_space *mapping, bool is_async)

Perhaps I'd call the other function balance_dirty_pages_ratelimited_async()
and then keep balance_dirty_pages_ratelimited_flags() as an internal
function. It is then more obvious at the external call sites what the call
is about (unlike the true/false argument).

								Honza

>  {
>  	struct inode *inode = mapping->host;
>  	struct backing_dev_info *bdi = inode_to_bdi(inode);
>  	struct bdi_writeback *wb = NULL;
>  	int ratelimit;
> +	int ret = 0;
>  	int *p;
>  
>  	if (!(bdi->capabilities & BDI_CAP_WRITEBACK))
> -		return;
> +		return ret;
>  
>  	if (inode_cgwb_enabled(inode))
>  		wb = wb_get_create_current(bdi, GFP_KERNEL);
> @@ -1937,10 +1926,37 @@ void balance_dirty_pages_ratelimited(struct address_space *mapping)
>  	}
>  	preempt_enable();
>  
> -	if (unlikely(current->nr_dirtied >= ratelimit))
> -		balance_dirty_pages(wb, current->nr_dirtied);
> +	if (unlikely(current->nr_dirtied >= ratelimit)) {
> +		if (is_async) {
> +			struct bdp_ctx ctx = { BDP_CTX_INIT(ctx, wb) };
> +
> +			ret = _balance_dirty_pages(wb, current->nr_dirtied, &ctx);
> +			if (ret)
> +				ret = -EAGAIN;
> +		} else {
> +			balance_dirty_pages(wb, current->nr_dirtied);
> +		}
> +	}
>  
>  	wb_put(wb);
> +	return ret;
> +}
> +
> +/**
> + * balance_dirty_pages_ratelimited - balance dirty memory state
> + * @mapping: address_space which was dirtied
> + *
> + * Processes which are dirtying memory should call in here once for each page
> + * which was newly dirtied.  The function will periodically check the system's
> + * dirty state and will initiate writeback if needed.
> + *
> + * Once we're over the dirty memory limit we decrease the ratelimiting
> + * by a lot, to prevent individual processes from overshooting the limit
> + * by (ratelimit_pages) each.
> + */
> +void balance_dirty_pages_ratelimited(struct address_space *mapping)
> +{
> +	balance_dirty_pages_ratelimited_flags(mapping, false);
>  }
>  EXPORT_SYMBOL(balance_dirty_pages_ratelimited);
>  
> -- 
> 2.30.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
