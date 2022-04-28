Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538E0513B16
	for <lists+io-uring@lfdr.de>; Thu, 28 Apr 2022 19:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350592AbiD1Ru4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Apr 2022 13:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350582AbiD1Ru4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Apr 2022 13:50:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F8CBAB86;
        Thu, 28 Apr 2022 10:47:40 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 898BE1F745;
        Thu, 28 Apr 2022 17:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651168059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KrT9OotE4Hcl4npj66dN3ozvEYqDadpB3sUAPal3Wsw=;
        b=n0gUX2+qpTxrBCCCko5bBy/VU1s0TBecEI93zE4o71YRCGtl5+ZLlRCsmUcwCwCvm3+kAd
        CPhrFmF+ULlqczgfWbAy+GTeFElZT1S4ePHR+dosfCp2QHlfIrULfWqeRIjNzlCu32bfMn
        W+ZVcYqvT3JriR4Bha0A+XRmYQ/ydfI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651168059;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KrT9OotE4Hcl4npj66dN3ozvEYqDadpB3sUAPal3Wsw=;
        b=KbiTI7IP5HpOQP/8EwL12R8D8PbfrETF8o2utoE0CAAfiTkmRVLtV0UDqo5TMWBOGbY7h7
        d+Q/nK/NzMAh35DA==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 553E52C141;
        Thu, 28 Apr 2022 17:47:39 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 149B7A061A; Thu, 28 Apr 2022 19:47:36 +0200 (CEST)
Date:   Thu, 28 Apr 2022 19:47:36 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [RFC PATCH v1 15/18] mm: support write throttling for async
 buffered writes
Message-ID: <20220428174736.mgadsxfuiwmoxrzx@quack3.lan>
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-16-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426174335.4004987-16-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue 26-04-22 10:43:32, Stefan Roesch wrote:
> This change adds support for async write throttling in the function
> balance_dirty_pages(). So far if throttling was required, the code was
> waiting synchronously as long as the writes were throttled. This change
> introduces asynchronous throttling. Instead of waiting in the function
> balance_dirty_pages(), the timeout is set in the task_struct field
> bdp_pause. Once the timeout has expired, the writes are no longer
> throttled.
> 
> - Add a new parameter to the balance_dirty_pages() function
>   - This allows the caller to pass in the nowait flag
>   - When the nowait flag is specified, the code does not wait in
>     balance_dirty_pages(), but instead stores the wait expiration in the
>     new task_struct field bdp_pause.
> 
> - The function balance_dirty_pages_ratelimited() resets the new values
>   in the task_struct, once the timeout has expired
> 
> This change is required to support write throttling for the async
> buffered writes. While the writes are throttled, io_uring still can make
> progress with processing other requests.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>

Maybe I miss something but I don't think this will throttle writers enough.
For three reasons:

1) The calculated throttling pauses should accumulate for the task so that
if we compute that say it takes 0.1s to write 100 pages and the task writes
300 pages, the delay adds up to 0.3s properly. Otherwise the task would not
be throttled as long as we expect the writeback to take.

2) We must not allow the amount of dirty pages to exceed the dirty limit.
That can easily lead to page reclaim getting into trouble reclaiming pages
and thus machine stalls, oom kills etc. So if we are coming close to dirty
limit and we cannot sleep, we must just fail the nowait write.

3) Even with above two problems fixed I suspect results will be suboptimal
because balance_dirty_pages() heuristics assume they get called reasonably
often and throttle writes so if amount of dirty pages is coming close to
dirty limit, they think we are overestimating writeback speed and update
throttling parameters accordingly. So if io_uring code does not throttle
writers often enough, I think dirty throttling parameters will be jumping
wildly resulting in poor behavior.

So what I'd probably suggest is that if balance_dirty_pages() is called in
"async" mode, we'd give tasks a pass until dirty_freerun_ceiling(). If
balance_dirty_pages() decides the task needs to wait, we store the pause
and bail all the way up into the place where we can sleep (io_uring code I
assume), sleep there, and then continue doing write.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
