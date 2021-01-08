Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B352EF540
	for <lists+io-uring@lfdr.de>; Fri,  8 Jan 2021 16:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbhAHP6K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jan 2021 10:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbhAHP6K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jan 2021 10:58:10 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC79C0612EA
        for <io-uring@vger.kernel.org>; Fri,  8 Jan 2021 07:57:30 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id b9so6815137qtr.2
        for <io-uring@vger.kernel.org>; Fri, 08 Jan 2021 07:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8RUtQGKl6vE11Edebomn0UWiEJSLkq3oF+84OjvL7CI=;
        b=ZJRT6zOIQq1za9PbQr0Hfpw6ANB1FkRTt8t1zBV0K5Z4R0+fSAKghALau2ymB4i2Xy
         gy3LdygWcS29sYbm/u3NMUmW0jqoYRm36R1ftfcVLTDTUFP2KLXEqFg3IDUfjkrCToS2
         eFsToAFnaULU8OcB28TR9JWNk5PgkBFvakIW5ORnZ7lwh2miUDjMt+27UI5bpLZoDr2c
         xG39A/s/3nBbOmv9AF+vRDvTkkpJM2tIH4Scl4pR22NiYpWvErKTQuY9viV7RKsLOK2O
         V7jGJWoI1mf5T/WuoNDpuuSu4E9GOCSERyF9DD/eAyVpXbqt8FInHoed34tNzok6OXWy
         ULCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8RUtQGKl6vE11Edebomn0UWiEJSLkq3oF+84OjvL7CI=;
        b=O8XuiKCxUzP+ddDyh8Vn2vDRHMJhGKpdJcZOfqpnxRVh/2EAAPTxtz+DQHxslCSZ7p
         6jUkrm6DppabeHDemIc/xBuasjJ3knwxszokBShu+groRuPjHH92Wyg+0f7QyIo3LaZ2
         lJixu9SIYOwNTX7z4FNCsWA+ckLhwXyRLVT072zU1heiorhnhbBezq+Jmk7A5AEBnVwJ
         QY6zOgvRUh1ftF8dNPQc7VP5IrjSAV4wbZIqX5QXahT4Dntxv26XAV8xBPVr2S1eQcro
         FjHqphHXt++VedqS0YkUW2UG2rBn4OaHjcCJKsmd/G8eF6vmq/qa0NgKUnIdkIPs3AaH
         EJbg==
X-Gm-Message-State: AOAM533Kq1ZW4T2auwX13SfxdURNwCPtlbjvQuXBScAUwFkOnwfiLZOk
        RpMWvfBuoivHXzD1sXzKpWC3eUdG7OG3wA==
X-Google-Smtp-Source: ABdhPJwiqhJPZ90Oj8pcXXekOa+U5NsB5TCdxpx3x27wNNDa4/chxud0Ha6cbslftkDlyLnD51RsYg==
X-Received: by 2002:ac8:130d:: with SMTP id e13mr4045002qtj.228.1610121449311;
        Fri, 08 Jan 2021 07:57:29 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id r10sm4220587qtw.66.2021.01.08.07.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 07:57:28 -0800 (PST)
Date:   Fri, 8 Jan 2021 10:57:26 -0500
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH v2 2/2] io_uring: flush timeouts that should already have
 expired
Message-ID: <20210108155726.GA8655@marcelo-debian.domain>
References: <20201219191521.82029-1-marcelo827@gmail.com>
 <20201219191521.82029-3-marcelo827@gmail.com>
 <d3feb2bc-b456-d057-e553-af024b234d31@gmail.com>
 <c0cde7df-f19f-92fd-e0f6-855396d126ab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0cde7df-f19f-92fd-e0f6-855396d126ab@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 02, 2021 at 08:26:26PM +0000, Pavel Begunkov wrote:
> On 02/01/2021 19:54, Pavel Begunkov wrote:
> > On 19/12/2020 19:15, Marcelo Diop-Gonzalez wrote:
> >> Right now io_flush_timeouts() checks if the current number of events
> >> is equal to ->timeout.target_seq, but this will miss some timeouts if
> >> there have been more than 1 event added since the last time they were
> >> flushed (possible in io_submit_flush_completions(), for example). Fix
> >> it by recording the starting value of ->cached_cq_overflow -
> >> ->cq_timeouts instead of the target value, so that we can safely
> >> (without overflow problems) compare the number of events that have
> >> happened with the number of events needed to trigger the timeout.
> 
> https://www.spinics.net/lists/kernel/msg3475160.html
> 
> The idea was to replace u32 cached_cq_tail with u64 while keeping
> timeout offsets u32. Assuming that we won't ever hit ~2^62 inflight
> requests, complete all requests falling into some large enough window
> behind that u64 cached_cq_tail.
> 
> simplifying:
> 
> i64 d = target_off - ctx->u64_cq_tail
> if (d <= 0 && d > -2^32)
> 	complete_it()
> 
> Not fond  of it, but at least worked at that time. You can try out
> this approach if you want, but would be perfect if you would find
> something more elegant :)
>

What do you think about something like this? I think it's not totally
correct because it relies on having ->completion_lock in io_timeout() so
that ->cq_last_tm_flushed is updated, but in case of IORING_SETUP_IOPOLL,
io_iopoll_complete() doesn't take that lock, and ->uring_lock will not
be held if io_timeout() is called from io_wq_submit_work(), but maybe
could still be worth it since that was already possibly a problem?

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cb57e0360fcb..50984709879c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -353,6 +353,7 @@ struct io_ring_ctx {
 		unsigned		cq_entries;
 		unsigned		cq_mask;
 		atomic_t		cq_timeouts;
+		unsigned		cq_last_tm_flush;
 		unsigned long		cq_check_overflow;
 		struct wait_queue_head	cq_wait;
 		struct fasync_struct	*cq_fasync;
@@ -1633,19 +1634,26 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 
 static void io_flush_timeouts(struct io_ring_ctx *ctx)
 {
+	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+
 	while (!list_empty(&ctx->timeout_list)) {
+		u32 events_needed, events_got;
 		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
 						struct io_kiocb, timeout.list);
 
 		if (io_is_timeout_noseq(req))
 			break;
-		if (req->timeout.target_seq != ctx->cached_cq_tail
-					- atomic_read(&ctx->cq_timeouts))
+
+		events_needed = req->timeout.target_seq - ctx->cq_last_tm_flush;
+		events_got = seq - ctx->cq_last_tm_flush;
+		if (events_got < events_needed)
 			break;
 
 		list_del_init(&req->timeout.list);
 		io_kill_timeout(req);
 	}
+
+	ctx->cq_last_tm_flush = seq;
 }
 
 static void io_commit_cqring(struct io_ring_ctx *ctx)
-- 
2.20.1

> >>
> >> Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
> >> ---
> >>  fs/io_uring.c | 30 +++++++++++++++++++++++-------
> >>  1 file changed, 23 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >> index f394bf358022..f62de0cb5fc4 100644
> >> --- a/fs/io_uring.c
> >> +++ b/fs/io_uring.c
> >> @@ -444,7 +444,7 @@ struct io_cancel {
> >>  struct io_timeout {
> >>  	struct file			*file;
> >>  	u32				off;
> >> -	u32				target_seq;
> >> +	u32				start_seq;
> >>  	struct list_head		list;
> >>  	/* head of the link, used by linked timeouts only */
> >>  	struct io_kiocb			*head;
> >> @@ -1629,6 +1629,24 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
> >>  	} while (!list_empty(&ctx->defer_list));
> >>  }
> >>  
> >> +static inline u32 io_timeout_events_left(struct io_kiocb *req)
> >> +{
> >> +	struct io_ring_ctx *ctx = req->ctx;
> >> +	u32 events;
> >> +
> >> +	/*
> >> +	 * events -= req->timeout.start_seq and the comparison between
> >> +	 * ->timeout.off and events will not overflow because each time
> >> +	 * ->cq_timeouts is incremented, ->cached_cq_tail is incremented too.
> >> +	 */
> >> +
> >> +	events = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
> >> +	events -= req->timeout.start_seq;
> > 
> > It looks to me that events before the start_seq subtraction can have got wrapped
> > around start_seq.
> > 
> > e.g.
> > 1) you submit a timeout with off=0xff...ff (start_seq=0 for convenience)
> > 
> > 2) some time has passed, let @events = 0xff..ff - 1
> > so the timeout still waits
> > 
> > 3) we commit 5 requests at once and call io_commit_cqring() only once for
> > them, so we get @events == 0xff..ff - 1 + 5, i.e. 4
> > 
> > @events == 4 < off == 0xff...ff,
> > so we didn't trigger out timeout even though should have
> > 
> >> +	if (req->timeout.off > events)
> >> +		return req->timeout.off - events;
> >> +	return 0;
> >> +}
> >> +
> >>  static void io_flush_timeouts(struct io_ring_ctx *ctx)
> >>  {
> >>  	while (!list_empty(&ctx->timeout_list)) {
> >> @@ -1637,8 +1655,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
> >>  
> >>  		if (io_is_timeout_noseq(req))
> >>  			break;
> >> -		if (req->timeout.target_seq != ctx->cached_cq_tail
> >> -					- atomic_read(&ctx->cq_timeouts))
> >> +		if (io_timeout_events_left(req) > 0)
> >>  			break;
> >>  
> >>  		list_del_init(&req->timeout.list);
> >> @@ -5785,7 +5802,6 @@ static int io_timeout(struct io_kiocb *req)
> >>  	struct io_ring_ctx *ctx = req->ctx;
> >>  	struct io_timeout_data *data = req->async_data;
> >>  	struct list_head *entry;
> >> -	u32 tail, off = req->timeout.off;
> >>  
> >>  	spin_lock_irq(&ctx->completion_lock);
> >>  
> >> @@ -5799,8 +5815,8 @@ static int io_timeout(struct io_kiocb *req)
> >>  		goto add;
> >>  	}
> >>  
> >> -	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
> >> -	req->timeout.target_seq = tail + off;
> >> +	req->timeout.start_seq = ctx->cached_cq_tail -
> >> +		atomic_read(&ctx->cq_timeouts);
> >>  
> >>  	/*
> >>  	 * Insertion sort, ensuring the first entry in the list is always
> >> @@ -5813,7 +5829,7 @@ static int io_timeout(struct io_kiocb *req)
> >>  		if (io_is_timeout_noseq(nxt))
> >>  			continue;
> >>  		/* nxt.seq is behind @tail, otherwise would've been completed */
> >> -		if (off >= nxt->timeout.target_seq - tail)
> >> +		if (req->timeout.off >= io_timeout_events_left(nxt))
> >>  			break;
> >>  	}
> >>  add:
> >>
> > 
> 
> -- 
> Pavel Begunkov
