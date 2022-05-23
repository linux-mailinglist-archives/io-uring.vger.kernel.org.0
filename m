Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B772A530E4E
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 12:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbiEWKlE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 06:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbiEWKlD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 06:41:03 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE76C218D;
        Mon, 23 May 2022 03:41:00 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 7321E1F8F8;
        Mon, 23 May 2022 10:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653302459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kgEfxB0bafp72pEF3bsPaBk5QKQf3h1LBgwkt9FtAcc=;
        b=of8zcOWsFHZDIqcStn6jk0L07eCAkj7Z8H0ki9kjc3DijS92ipNJ6iheI7CXC+eRY55dlp
        jfBJrpLFJA1MekBms+l+UXQKMg/e11EOmzROj8tK2vhzNechBjY3HNqFQo5MHrK3nvu4fJ
        M8TdLfti2noZ+rLDNYrcMYnZVeK9xvc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653302459;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kgEfxB0bafp72pEF3bsPaBk5QKQf3h1LBgwkt9FtAcc=;
        b=7veQnmTX/Pu0sB8DVD6EluIlW9tBmC3bod58EvRvMEQBkGqgbBteza1HQVPZN7rZPxSsod
        HWATcQrmHgWSoxAQ==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3A0F52C141;
        Mon, 23 May 2022 10:40:59 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id DDD8CA0632; Mon, 23 May 2022 12:40:58 +0200 (CEST)
Date:   Mon, 23 May 2022 12:40:58 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [RFC PATCH v4 04/17] mm: Add
 balance_dirty_pages_ratelimited_flags() function
Message-ID: <20220523104058.c727tj7tl2y43snu@quack3.lan>
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-5-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520183646.2002023-5-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri 20-05-22 11:36:33, Stefan Roesch wrote:
> This adds the helper function balance_dirty_pages_ratelimited_flags().
> It adds the parameter flags to balance_dirty_pages_ratelimited().
> The flags parameter is passed to balance_dirty_pages(). For async
> buffered writes the flag value will be BDP_ASYNC.
> 
> The new helper function is also used by balance_dirty_pages_ratelimited().
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>

Yeah, as Christoph says perhaps fold this into patch 3. Otherwise the
changes look good to me.

								Honza

> ---
>  include/linux/writeback.h |  3 +++
>  mm/page-writeback.c       | 38 +++++++++++++++++++++++---------------
>  2 files changed, 26 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index a9114c5090e9..1bddad86a4f6 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -377,6 +377,9 @@ void wb_update_bandwidth(struct bdi_writeback *wb);
>  #define BDP_ASYNC 0x0001
>  
>  void balance_dirty_pages_ratelimited(struct address_space *mapping);
> +int balance_dirty_pages_ratelimited_flags(struct address_space *mapping,
> +		unsigned int flags);
> +
>  bool wb_over_bg_thresh(struct bdi_writeback *wb);
>  
>  typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 7a320fd2ad33..3701e813d05f 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1851,28 +1851,18 @@ static DEFINE_PER_CPU(int, bdp_ratelimits);
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
> +int balance_dirty_pages_ratelimited_flags(struct address_space *mapping,
> +					unsigned int flags)
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
> @@ -1912,9 +1902,27 @@ void balance_dirty_pages_ratelimited(struct address_space *mapping)
>  	preempt_enable();
>  
>  	if (unlikely(current->nr_dirtied >= ratelimit))
> -		balance_dirty_pages(wb, current->nr_dirtied, 0);
> +		balance_dirty_pages(wb, current->nr_dirtied, flags);
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
> +	balance_dirty_pages_ratelimited_flags(mapping, 0);
>  }
>  EXPORT_SYMBOL(balance_dirty_pages_ratelimited);
>  
> -- 
> 2.30.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
