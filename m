Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886F62F5663
	for <lists+io-uring@lfdr.de>; Thu, 14 Jan 2021 02:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbhANBrK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jan 2021 20:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbhANAz4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jan 2021 19:55:56 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2741C061786
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 16:46:58 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id u26so8019596iof.3
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 16:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ThG+uv+Ej7dlUVIcu5elWmEJNPdSnTVoL95ixvk7jM8=;
        b=XDwYNZaG7A73XvsCrHKZJq/G5Gi0lAr6zjxdJCtI2thRrjPdMH86OA7UWWjC/QDCmw
         Xm2ZKwplfWq8jsyT6dwbsSZftlesIRlQryu4x8KPtk8xAxHleJttRcrBbc6pi/0dLjx9
         +3FybrG7ErKgai0JLx3Kiq2TTDGWwfq5+4/JtbIfKjHGXtOcuu2t65ENSuBfx204uaac
         q/eu8Z9s3v6Y1gT7C79t8LDN/jgA8klMFe6lWDxPddsyvtTUqT9COcXakj7FkTusWRwS
         +Fp1na4xqBPGMCYUFCvCE3/+6OLN2PTZ4mWspafLkuzd+TitebGvS2c3UWaHv/3ypcLS
         /DpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ThG+uv+Ej7dlUVIcu5elWmEJNPdSnTVoL95ixvk7jM8=;
        b=jnSFO9OP/+On5bfgF3VkUNCwXNpjbOFWG/XhiiAbhFd3UTxqW57BcVLelvf/aVJ+lK
         9EstrJSGgfhbeN6iM62F2LHQmd88nFaJxZx/ECK/puLMR69AVo/4pidzEXoLA1Mtmsm7
         Jpk4IzKVOJDKcIZfEeSM4cHGYozNcC8sS7SZ6WBV2JN+kql9cc14b2ytXnKHe9TvvZOl
         7u7gMeEe/29ahBjZvWA8kHIZHJfDYBXfgVuEAW06ZI4Dm+9sQV3h1sMS3OSVsENPvQDj
         r8r1TfL3ZxHM0YK/vvg3xIc5IneYnwM4LXgydW035JbBDG+bJpgFgVZJYVn/aOyJvve6
         W9UQ==
X-Gm-Message-State: AOAM532iwTgggywoMVnM0yQkGrKgvT5l5EEnZL5Q2pwcznvGc/bYYKZg
        GSSNSJvx4ynbO0J/1VMuSFKbTs2SCfQ=
X-Google-Smtp-Source: ABdhPJwpFbwmGJ0rsmifqlPv9yJmYhkcfSoue9EBSx1PF2/e0cwlzqgnceqlmBTZIqeWho46t7/tNw==
X-Received: by 2002:a92:a1da:: with SMTP id b87mr4589524ill.111.1610585218225;
        Wed, 13 Jan 2021 16:46:58 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id g6sm2410412ilf.3.2021.01.13.16.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 16:46:57 -0800 (PST)
Date:   Wed, 13 Jan 2021 19:46:55 -0500
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] io_uring: flush timeouts that should already have
 expired
Message-ID: <20210114004655.GA115522@marcelo-debian.domain>
References: <20201219191521.82029-1-marcelo827@gmail.com>
 <20201219191521.82029-3-marcelo827@gmail.com>
 <d3feb2bc-b456-d057-e553-af024b234d31@gmail.com>
 <c0cde7df-f19f-92fd-e0f6-855396d126ab@gmail.com>
 <20210108155726.GA8655@marcelo-debian.domain>
 <257c0977-2546-adeb-5e04-6b41ced792c7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <257c0977-2546-adeb-5e04-6b41ced792c7@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jan 12, 2021 at 08:47:11PM +0000, Pavel Begunkov wrote:
> On 08/01/2021 15:57, Marcelo Diop-Gonzalez wrote:
> > On Sat, Jan 02, 2021 at 08:26:26PM +0000, Pavel Begunkov wrote:
> >> On 02/01/2021 19:54, Pavel Begunkov wrote:
> >>> On 19/12/2020 19:15, Marcelo Diop-Gonzalez wrote:
> >>>> Right now io_flush_timeouts() checks if the current number of events
> >>>> is equal to ->timeout.target_seq, but this will miss some timeouts if
> >>>> there have been more than 1 event added since the last time they were
> >>>> flushed (possible in io_submit_flush_completions(), for example). Fix
> >>>> it by recording the starting value of ->cached_cq_overflow -
> >>>> ->cq_timeouts instead of the target value, so that we can safely
> >>>> (without overflow problems) compare the number of events that have
> >>>> happened with the number of events needed to trigger the timeout.
> >>
> >> https://www.spinics.net/lists/kernel/msg3475160.html
> >>
> >> The idea was to replace u32 cached_cq_tail with u64 while keeping
> >> timeout offsets u32. Assuming that we won't ever hit ~2^62 inflight
> >> requests, complete all requests falling into some large enough window
> >> behind that u64 cached_cq_tail.
> >>
> >> simplifying:
> >>
> >> i64 d = target_off - ctx->u64_cq_tail
> >> if (d <= 0 && d > -2^32)
> >> 	complete_it()
> >>
> >> Not fond  of it, but at least worked at that time. You can try out
> >> this approach if you want, but would be perfect if you would find
> >> something more elegant :)
> >>
> > 
> > What do you think about something like this? I think it's not totally
> > correct because it relies on having ->completion_lock in io_timeout() so
> > that ->cq_last_tm_flushed is updated, but in case of IORING_SETUP_IOPOLL,
> > io_iopoll_complete() doesn't take that lock, and ->uring_lock will not
> > be held if io_timeout() is called from io_wq_submit_work(), but maybe
> > could still be worth it since that was already possibly a problem?
> > 
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index cb57e0360fcb..50984709879c 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -353,6 +353,7 @@ struct io_ring_ctx {
> >  		unsigned		cq_entries;
> >  		unsigned		cq_mask;
> >  		atomic_t		cq_timeouts;
> > +		unsigned		cq_last_tm_flush;
> 
> It looks like that "last flush" is a good direction.
> I think there can be problems at extremes like completing 2^32
> requests at once, but should be ok in practice. Anyway better
> than it's now.
> 
> What about the first patch about overflows and cq_timeouts? I
> assume that problem is still there, isn't it?
> 
> See comments below, but if it passes liburing tests, please send
> a patch.
> 
> >  		unsigned long		cq_check_overflow;
> >  		struct wait_queue_head	cq_wait;
> >  		struct fasync_struct	*cq_fasync;
> > @@ -1633,19 +1634,26 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
> >  
> >  static void io_flush_timeouts(struct io_ring_ctx *ctx)
> >  {
> > +	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
> > +
> 
> a nit,
> 
> if (list_empty()) return; + do {} while();

Ah btw, so then we would have to add ->last_flush = seq in
io_timeout() too? I think that should be correct but just wanna make
sure that's what you meant.  Because otherwise if list_empty() is true
for a while without updating ->last_flush then there could be
problems. Like for example if there are no timeouts for a while, and
seq == 2^32-2, then we add a timeout with off == 4. If last_flush is
still 0 then target-last_flush == 2, but seq - last_flush == 2^32-2

> 
> timeouts can be rare enough
> 
> >  	while (!list_empty(&ctx->timeout_list)) {
> > +		u32 events_needed, events_got;
> >  		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
> >  						struct io_kiocb, timeout.list);
> >  
> >  		if (io_is_timeout_noseq(req))
> >  			break;
> > -		if (req->timeout.target_seq != ctx->cached_cq_tail
> > -					- atomic_read(&ctx->cq_timeouts))
> > +
> 
> extra new line
> 
> > +		events_needed = req->timeout.target_seq - ctx->cq_last_tm_flush;
> > +		events_got = seq - ctx->cq_last_tm_flush;
> > +		if (events_got < events_needed) 
> 
> probably <=
> 
> >  			break;
> 
> basically it checks that @target is in [last_flush, cur_seq],
> it can use such a comment + a note about underflows and using
> the modulus arithmetic, like with algebraic rings
> 
> >  
> >  		list_del_init(&req->timeout.list);
> >  		io_kill_timeout(req);
> >  	}
> > +
> > +	ctx->cq_last_tm_flush = seq;
> >  }
> >  
> >  static void io_commit_cqring(struct io_ring_ctx *ctx)
> > 
> 
> -- 
> Pavel Begunkov
