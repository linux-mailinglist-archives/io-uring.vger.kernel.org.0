Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5305152116F
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 11:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237151AbiEJJyi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 May 2022 05:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239337AbiEJJyh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 May 2022 05:54:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5742A1FC1;
        Tue, 10 May 2022 02:50:39 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BF1D11F899;
        Tue, 10 May 2022 09:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652176237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FkNQam+4bY7+4TTyO2rhGRct8sQLSP/3aWBGHFr5d54=;
        b=YPTq0qAotzL1GJKkhsZaxp5WlGxa1pfk0MkqzNWPFZk45jA5EEb2Kt/rS2uwyEfWcNO27E
        7Ey+MwsFRr2NZ7Xxqs1CQM7OS66OUBBq8qosO/ctPtWDIFZAgycnhKIHpqlH8qXxYlJLFy
        sqgH+VBrC5hVtxh50sKNN4UzC+2OeL8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652176237;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FkNQam+4bY7+4TTyO2rhGRct8sQLSP/3aWBGHFr5d54=;
        b=TQFSCygu9q/Ghf7JPEL3tM/sBcOLFTRtMgwp3apqWJZAC1V0O7SefCe7RQ2Xy6BeZhxWEY
        ZXAy1sB9AEbKS0Cg==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8A0E92C141;
        Tue, 10 May 2022 09:50:37 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 46F3BA062A; Tue, 10 May 2022 11:50:36 +0200 (CEST)
Date:   Tue, 10 May 2022 11:50:36 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     Jan Kara <jack@suse.cz>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com
Subject: Re: [RFC PATCH v1 15/18] mm: support write throttling for async
 buffered writes
Message-ID: <20220510095036.6tbbwwf5hxcevzkh@quack3.lan>
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-16-shr@fb.com>
 <20220428174736.mgadsxfuiwmoxrzx@quack3.lan>
 <88879649-57db-5102-1bed-66f610d13317@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88879649-57db-5102-1bed-66f610d13317@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sorry for delayed reply. This has fallen through the cracks...

On Thu 28-04-22 13:16:19, Stefan Roesch wrote:
> On 4/28/22 10:47 AM, Jan Kara wrote:
> > On Tue 26-04-22 10:43:32, Stefan Roesch wrote:
> >> This change adds support for async write throttling in the function
> >> balance_dirty_pages(). So far if throttling was required, the code was
> >> waiting synchronously as long as the writes were throttled. This change
> >> introduces asynchronous throttling. Instead of waiting in the function
> >> balance_dirty_pages(), the timeout is set in the task_struct field
> >> bdp_pause. Once the timeout has expired, the writes are no longer
> >> throttled.
> >>
> >> - Add a new parameter to the balance_dirty_pages() function
> >>   - This allows the caller to pass in the nowait flag
> >>   - When the nowait flag is specified, the code does not wait in
> >>     balance_dirty_pages(), but instead stores the wait expiration in the
> >>     new task_struct field bdp_pause.
> >>
> >> - The function balance_dirty_pages_ratelimited() resets the new values
> >>   in the task_struct, once the timeout has expired
> >>
> >> This change is required to support write throttling for the async
> >> buffered writes. While the writes are throttled, io_uring still can make
> >> progress with processing other requests.
> >>
> >> Signed-off-by: Stefan Roesch <shr@fb.com>
> > 
> > Maybe I miss something but I don't think this will throttle writers enough.
> > For three reasons:
> > 
> > 1) The calculated throttling pauses should accumulate for the task so that
> > if we compute that say it takes 0.1s to write 100 pages and the task writes
> > 300 pages, the delay adds up to 0.3s properly. Otherwise the task would not
> > be throttled as long as we expect the writeback to take.
> > 
> > 2) We must not allow the amount of dirty pages to exceed the dirty limit.
> > That can easily lead to page reclaim getting into trouble reclaiming pages
> > and thus machine stalls, oom kills etc. So if we are coming close to dirty
> > limit and we cannot sleep, we must just fail the nowait write.
> > 
> > 3) Even with above two problems fixed I suspect results will be suboptimal
> > because balance_dirty_pages() heuristics assume they get called reasonably
> > often and throttle writes so if amount of dirty pages is coming close to
> > dirty limit, they think we are overestimating writeback speed and update
> > throttling parameters accordingly. So if io_uring code does not throttle
> > writers often enough, I think dirty throttling parameters will be jumping
> > wildly resulting in poor behavior.
> > 
> > So what I'd probably suggest is that if balance_dirty_pages() is called in
> > "async" mode, we'd give tasks a pass until dirty_freerun_ceiling(). If
> > balance_dirty_pages() decides the task needs to wait, we store the pause
> > and bail all the way up into the place where we can sleep (io_uring code I
> > assume), sleep there, and then continue doing write.
> > 
> 
> Jan, thanks for the feedback. Are you suggesting to change the following
> check in the function balance_dirty_pages():
> 
>                 /*
>                  * Throttle it only when the background writeback cannot
>                  * catch-up. This avoids (excessively) small writeouts
>                  * when the wb limits are ramping up in case of !strictlimit.
>                  *
>                  * In strictlimit case make decision based on the wb counters
>                  * and limits. Small writeouts when the wb limits are ramping
>                  * up are the price we consciously pay for strictlimit-ing.
>                  *
>                  * If memcg domain is in effect, @dirty should be under
>                  * both global and memcg freerun ceilings.
>                  */
>                 if (dirty <= dirty_freerun_ceiling(thresh, bg_thresh) &&
>                     (!mdtc ||
>                      m_dirty <= dirty_freerun_ceiling(m_thresh, m_bg_thresh))) {
>                         unsigned long intv;
>                         unsigned long m_intv;
> 
> to include if we are in async mode?

Actually no. This condition is the one that gives any task a free pass
until dirty_freerun_ceiling(). So there's no need to do any modification
for that. Sorry, I've probably formulated my suggestion in a bit confusing
way.

> There is no direct way to return that the process should sleep. Instead
> two new fields are introduced in the proc structure. These two fields are
> then used in io_uring to determine if the writes for a task need to be
> throttled.
> 
> In case the writes need to be throttled, the writes are not issued, but
> instead inserted on a wait queue. We cannot sleep in the general io_uring
> code path as we still want to process other requests which are affected
> by the throttling.

Probably you wanted to say "are not affected by the throttling" in the
above.

I know that you're using fields in task_struct to propagate the delay info.
But IMHO that is unnecessary (although I don't care too much). Instead we
could factor out a variant of balance_dirty_pages() that returns 'pause' to
sleep, 0 if no sleeping needed. Normal balance_dirty_pages() would use this
for pause calculation, places wanting async throttling would only get the
pause to sleep. So e.g. iomap_write_iter() would then check and if returned
pause is > 0, it would abort the loop similary as we'd abort it for any
other reason when NOWAIT write is aborted because we need to sleep. Iouring
code then detects short write / EAGAIN and offloads the write to the
workqueue where normal balance_dirty_pages() can sleep as needed.

This will make sure dirty limits are properly observed and we don't need
that much special handling for it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
