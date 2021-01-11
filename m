Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A5C2F19A2
	for <lists+io-uring@lfdr.de>; Mon, 11 Jan 2021 16:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbhAKP2o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jan 2021 10:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbhAKP2n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jan 2021 10:28:43 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6F9C061786
        for <io-uring@vger.kernel.org>; Mon, 11 Jan 2021 07:28:03 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id c14so11451567qtn.0
        for <io-uring@vger.kernel.org>; Mon, 11 Jan 2021 07:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vVvSSMRNW6dkLSIBB6sdcemTpoyKQFJyEllSoC482VU=;
        b=JtVN6n+8heXJn/Gcl4trgPCugM78yquKz3cDk1Eg92NcGk6YLzzBDo5pbaUO+r5Uy3
         blObGCt7Rh9npXDDcp42IpmAl8Q/CK9CPG/rtATx+2N57KB1URHaJmtNNoQ6diKkM0Gv
         ZPzv/nqEgxywvIGqXTrV5aSiNnFWOw4QwFrtmXiACJ/XxOi+v3KV8VCF7kie4C8IQzCa
         wtiOO8pp6iDKDFxf/GUS2dxiA+6nnB8mxWg5VLMv05yGFFU+JHb2oiy1wOlE5CaDZfws
         Ss/lTIqqq/mrJlgNVOrSIFg9df7Kc6vqRhanLiukiZ8S49tUOza/TAe6FuMV70M5v/9Q
         oELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vVvSSMRNW6dkLSIBB6sdcemTpoyKQFJyEllSoC482VU=;
        b=QZAkuOUcg+rT01J11fgILOK76L2PuuG1Xyo46fme9Kt4SOAym1tM4KDg7LtrC8heoL
         o3CVJbkcToAjBMeMTsDmLgQ1Edz1SnpP2ZZAfjBk2nGaNgOzoTZLV/HfNzas52vlYCe/
         sDr296WHoZg1Fz7OX6xNeuMKGYJ0Sjck9FNP35r5QhakFP619hME0YyPsAkO3kluIgm4
         RoNPTayZlqEG/dnG/vgyM5Sh1Fv1Q6ktD7/CByLXCj420G+7o5u2b5a+CtP6BbLw1MfY
         mqAKoPuyx6ym0PvAJ+xXkt8aIQ0+C4M57eT3uMLsbDzm1gKBmxhtEGSQNcT6Djxb/JyD
         Gzig==
X-Gm-Message-State: AOAM533DWS6PkZLhRu5nJSS091cMs7/YOIMK4bOS+2S0OEVf4FXP98OT
        qque4gSVoUQvk6omUFmRQIGFK/g+CeuOpA==
X-Google-Smtp-Source: ABdhPJytlTpkbp2ClL7NUC7zCvUnh4sw5QJYN78fokEt3224AHfdkCxoP9PuMODr9dYGUy2ugsj/Vw==
X-Received: by 2002:ac8:4553:: with SMTP id z19mr128856qtn.278.1610378882840;
        Mon, 11 Jan 2021 07:28:02 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id k42sm6339652qtk.17.2021.01.11.07.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 07:28:02 -0800 (PST)
Date:   Mon, 11 Jan 2021 10:28:00 -0500
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH v2 2/2] io_uring: flush timeouts that should already have
 expired
Message-ID: <20210111152800.GB2998@marcelo-debian.domain>
References: <20201219191521.82029-1-marcelo827@gmail.com>
 <20201219191521.82029-3-marcelo827@gmail.com>
 <d3feb2bc-b456-d057-e553-af024b234d31@gmail.com>
 <c0cde7df-f19f-92fd-e0f6-855396d126ab@gmail.com>
 <20210108155726.GA8655@marcelo-debian.domain>
 <2fc9e651-d786-7c2d-0d2c-47ed454f06be@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fc9e651-d786-7c2d-0d2c-47ed454f06be@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 11, 2021 at 04:57:21AM +0000, Pavel Begunkov wrote:
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
> 
> I'll take a look later, but IOPOLL doesn't support timeouts, see
> the first if in io_timeout_prep(), so that's not a problem, but would
> better to leave a comment.
>

Ah right! Nevermind about that then.

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
> >  		unsigned long		cq_check_overflow;
> >  		struct wait_queue_head	cq_wait;
> >  		struct fasync_struct	*cq_fasync;
> > @@ -1633,19 +1634,26 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
> >  
> >  static void io_flush_timeouts(struct io_ring_ctx *ctx)
> >  {
> > +	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
> > +
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
> > +		events_needed = req->timeout.target_seq - ctx->cq_last_tm_flush;
> > +		events_got = seq - ctx->cq_last_tm_flush;
> > +		if (events_got < events_needed)
> >  			break;
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
