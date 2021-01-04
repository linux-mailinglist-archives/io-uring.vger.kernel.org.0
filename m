Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7A32E9C6D
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 18:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbhADR5C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 12:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbhADR5B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 12:57:01 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C270C061574
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 09:56:21 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id h22so66475851lfu.2
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 09:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R4oo/nPrySz9lzliitt4wvXS3MHaIYIQ7oIYoE7E4E8=;
        b=clE6Zd2z2Hd8Pw+EyUJ2aXezXcgm9CDwCNHHLsYbBn6UrVNr0ZCHEjIAzQKgenzgyK
         tFTiAggtaUnpbugm+WSgsC9+lHJENQaG6O51icG6PJsttrtZMp7RkxPnt1bc7LaFLGzS
         v7B45yyn3rkZrMvm6XW7dWOBdvN7WadkiAVh2QBloLvxyEhrKFI4dwpAEX7AnpYb4Tsx
         +qZbzMKVa3maxyjuFegq3ncEPQHDPvAnaa3CFWc/wJ0s7P1FMPcJtyEADWeNMg16yrQ/
         9DHVzBLpGmjERoaGUEBpq1v9I5CC/yrSvblsGYAvG4ZAzOX45WCT9DUbk+HxmVs9zyMy
         r7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R4oo/nPrySz9lzliitt4wvXS3MHaIYIQ7oIYoE7E4E8=;
        b=T0YLbgy6YY63Nini0yfblqepVzTYxDi0wD5kBKrJiiNUEtOLSr4Wd6rF8VhveIKkZw
         lKrwBglslvXs/5gAoD0VF2wiCYKsKW+QazB9eDluipIXroqPna3qoPsieYI1PJ41h6j5
         sVzMzo6DXXFoNV2FpRRlH81QxCofyQeWNzx4zK/LUMFcEhRPY/UdOuu4FZFPEU3QBHmz
         3hzfMYtH1OilNYh7ofJ3uqwwXYWDcx0wnzVONHauDQhPv8KBjCSMhIAfVVo9MjR3XhRe
         o3B85iVzM/1kYKaX8F5CZKFsLPvZzTt4qys7VWCjBqHlpa/ZHI6e/GyjmnXnzrFprOtt
         kICg==
X-Gm-Message-State: AOAM533jPLEDa5eqPPCl0oOAa6rMySFejxE9A/7DEYLWduskQQ9IZkaR
        UeSt2cKd/ZxH2clQPiOC9I+PaAsMDZAl4/BNWiM=
X-Google-Smtp-Source: ABdhPJyPWlXUX9Pk/IoSju3WyVxfNHLre899DRcM8+oHMEUhDkj7u9ARMqfdrviwpScQyORJ67x1pHVizJKsx+dE4aY=
X-Received: by 2002:a2e:390d:: with SMTP id g13mr19176160lja.23.1609782979912;
 Mon, 04 Jan 2021 09:56:19 -0800 (PST)
MIME-Version: 1.0
References: <20201219191521.82029-1-marcelo827@gmail.com> <20201219191521.82029-3-marcelo827@gmail.com>
 <d3feb2bc-b456-d057-e553-af024b234d31@gmail.com>
In-Reply-To: <d3feb2bc-b456-d057-e553-af024b234d31@gmail.com>
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Date:   Mon, 4 Jan 2021 12:56:08 -0500
Message-ID: <CA+saATUJ=CYpN59PiivA95i4U=Dia8fZ4n1YLObZbkVi+bjy7Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] io_uring: flush timeouts that should already have expired
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 2, 2021 at 2:57 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 19/12/2020 19:15, Marcelo Diop-Gonzalez wrote:
> > Right now io_flush_timeouts() checks if the current number of events
> > is equal to ->timeout.target_seq, but this will miss some timeouts if
> > there have been more than 1 event added since the last time they were
> > flushed (possible in io_submit_flush_completions(), for example). Fix
> > it by recording the starting value of ->cached_cq_overflow -
> > ->cq_timeouts instead of the target value, so that we can safely
> > (without overflow problems) compare the number of events that have
> > happened with the number of events needed to trigger the timeout.
> >
> > Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
> > ---
> >  fs/io_uring.c | 30 +++++++++++++++++++++++-------
> >  1 file changed, 23 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index f394bf358022..f62de0cb5fc4 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -444,7 +444,7 @@ struct io_cancel {
> >  struct io_timeout {
> >       struct file                     *file;
> >       u32                             off;
> > -     u32                             target_seq;
> > +     u32                             start_seq;
> >       struct list_head                list;
> >       /* head of the link, used by linked timeouts only */
> >       struct io_kiocb                 *head;
> > @@ -1629,6 +1629,24 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
> >       } while (!list_empty(&ctx->defer_list));
> >  }
> >
> > +static inline u32 io_timeout_events_left(struct io_kiocb *req)
> > +{
> > +     struct io_ring_ctx *ctx = req->ctx;
> > +     u32 events;
> > +
> > +     /*
> > +      * events -= req->timeout.start_seq and the comparison between
> > +      * ->timeout.off and events will not overflow because each time
> > +      * ->cq_timeouts is incremented, ->cached_cq_tail is incremented too.
> > +      */
> > +
> > +     events = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
> > +     events -= req->timeout.start_seq;
>
> It looks to me that events before the start_seq subtraction can have got wrapped
> around start_seq.
>
> e.g.
> 1) you submit a timeout with off=0xff...ff (start_seq=0 for convenience)
>
> 2) some time has passed, let @events = 0xff..ff - 1
> so the timeout still waits
>
> 3) we commit 5 requests at once and call io_commit_cqring() only once for
> them, so we get @events == 0xff..ff - 1 + 5, i.e. 4
>
> @events == 4 < off == 0xff...ff,

Oof, good catch... I'll try to think about it some more. Feels like
there ought to
be a nice way to do it but maybe it's quite tricky :/

-Marcelo

> so we didn't trigger out timeout even though should have
>
> > +     if (req->timeout.off > events)
> > +             return req->timeout.off - events;
> > +     return 0;
> > +}
> > +
> >  static void io_flush_timeouts(struct io_ring_ctx *ctx)
> >  {
> >       while (!list_empty(&ctx->timeout_list)) {
> > @@ -1637,8 +1655,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
> >
> >               if (io_is_timeout_noseq(req))
> >                       break;
> > -             if (req->timeout.target_seq != ctx->cached_cq_tail
> > -                                     - atomic_read(&ctx->cq_timeouts))
> > +             if (io_timeout_events_left(req) > 0)
> >                       break;
> >
> >               list_del_init(&req->timeout.list);
> > @@ -5785,7 +5802,6 @@ static int io_timeout(struct io_kiocb *req)
> >       struct io_ring_ctx *ctx = req->ctx;
> >       struct io_timeout_data *data = req->async_data;
> >       struct list_head *entry;
> > -     u32 tail, off = req->timeout.off;
> >
> >       spin_lock_irq(&ctx->completion_lock);
> >
> > @@ -5799,8 +5815,8 @@ static int io_timeout(struct io_kiocb *req)
> >               goto add;
> >       }
> >
> > -     tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
> > -     req->timeout.target_seq = tail + off;
> > +     req->timeout.start_seq = ctx->cached_cq_tail -
> > +             atomic_read(&ctx->cq_timeouts);
> >
> >       /*
> >        * Insertion sort, ensuring the first entry in the list is always
> > @@ -5813,7 +5829,7 @@ static int io_timeout(struct io_kiocb *req)
> >               if (io_is_timeout_noseq(nxt))
> >                       continue;
> >               /* nxt.seq is behind @tail, otherwise would've been completed */
> > -             if (off >= nxt->timeout.target_seq - tail)
> > +             if (req->timeout.off >= io_timeout_events_left(nxt))
> >                       break;
> >       }
> >  add:
> >
>
> --
> Pavel Begunkov
