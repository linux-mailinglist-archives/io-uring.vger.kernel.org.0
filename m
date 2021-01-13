Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA022F4D68
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 15:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbhAMOmT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jan 2021 09:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbhAMOmT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jan 2021 09:42:19 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E334DC0617A7
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 06:41:19 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id d13so1309079ioy.4
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 06:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I1G+65n8d7nq2jm26+uSQxL07nWpSYs2mo9wvGZZukE=;
        b=L1em1vyY2C1L7UaK6lOUy/SffP0u6fx7MKM8t0BEC4Jvjeu++WiR9Cw66s7cZwTrp5
         2tjv6XabmhhCPyT7Z9UmLDHG10zYAI2TXctSVF9T8Y/e/IL1l/e8X6ULnR+VrX1gD5ON
         0S7CcOU5AjXoIN5c/mhAzAzjKyh6v8eB+nXBKYBeKfYB+UKoWlRbsTS5rv5TFrMVrYKq
         2q2MbnTD7H4+lYSCNdLA0pHvpRWFOhpCkjlycm6TFiLredDLP4UL09ABZMbm4tU1MwhX
         pJTS2xNSuSswe7F7w2OiK16UlLdMxUHOT7zuOwEA501BgDJrYS7UKTpFk0+woNim3wXH
         thyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=I1G+65n8d7nq2jm26+uSQxL07nWpSYs2mo9wvGZZukE=;
        b=A8roIugYuxjaXDbPk4uQdN/W8hw8JEBKA/Js6a7qcwwkYxhNjOjs3/QI5DNi4Vx2Z3
         NeiHoeU+KsVCURVKSdv1P2mnyVQbCMtKf+aYQHeEAbkA9n1pDVB/Maayuq8Bm1B+rUZd
         ShzFL0Zyo4vPndZ8V3WmB6j/ChgR9QU6ZTNyFbgVGRGR/m0JgZV9rEeYEHHg658TvxdZ
         U2tYyPeEmy2NmiV1rGO7A4NdQKBSvux/skdqlH2TT6CWkKXDwoXe2VVEwGp+bKfvshgy
         qf2EyKJwnyYYuFgOVQ2ROKZDp5K6ZZy329cqMtotXo/p/ZPn32bGFjbnEljz1+QAoEBB
         jrxg==
X-Gm-Message-State: AOAM530kG+pV4VTY683yic+pyA8//1CJELc8rITlADxnljcROsvRPr7H
        ZKJf/WF8nbPdApJdY6FHbefQUukOBvk=
X-Google-Smtp-Source: ABdhPJyiXOA2vH2F6KZ2WJatZ+TzG+1Mii1yTvN1xdJfOv7EnJWyP9YO6aiVkk+dq0e+OfHyNvCYvg==
X-Received: by 2002:a05:6638:d0b:: with SMTP id q11mr1183637jaj.88.1610548879052;
        Wed, 13 Jan 2021 06:41:19 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id 12sm1747739ily.42.2021.01.13.06.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 06:41:17 -0800 (PST)
Date:   Wed, 13 Jan 2021 09:41:15 -0500
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] io_uring: flush timeouts that should already have
 expired
Message-ID: <20210113144114.GA64157@marcelo-debian.domain>
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

Yeah it's still there I think, I just couldn't think of a good way
to fix it. So I figured I would just send this one since at least
it doesn't make that problem worse. Maybe could send a fix for that
one later if I think of something

> 
> See comments below, but if it passes liburing tests, please send
> a patch.

will do!

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

Won't that make it break too early though? If you submit a timeout
with off = 1 when {seq == 0, last_flush == 0}, then target_seq ==
1. Then let's say there's 1 cqe added, so the timeout should trigger.
Then events_needed == 1 and events_got == 1, right?

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
