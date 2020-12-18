Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDD92DE7D1
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 18:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732308AbgLRRFm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 12:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732307AbgLRRFm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 12:05:42 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F80AC0617A7
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 09:05:02 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id y19so7068974lfa.13
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 09:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iB3gVM462Icu+lo92lARIG9lYJkSEOB2CWgHUOfEzzE=;
        b=Tkvt1qpYA2gextNdNSM17DsUxLLYphRStZm+54GxoRZNNctdbt1/uNCHcAU3cytnEQ
         8oQiGL0chU4pUo9mQ9pyMaRY+xz0CIC28tk3FOYa4+KGQFDFA5+BbiWvsAI0TxUA5tYi
         P1qYGXNM80Ir8VJmgjJMFpuJITQKIX02hYGixKlS9f1hAVBhaocFtSEw72iBtMf+25DZ
         VZFwRxvEe0ScJKJkf6FUj47oawnSvyeokRzuBx/OIy7wgGSdWxI9IW+LMkjUNoPPEJNK
         Mtx07ctcZGMcR+0GhvnUSrtNiFZssy35gzchU++P5jT+zqvFqSne0Vj5Z3ZQt3pI94BH
         7I6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iB3gVM462Icu+lo92lARIG9lYJkSEOB2CWgHUOfEzzE=;
        b=qUT4376lp3Oy7PJChXHkeOEXEsFThqOWHnDPUGCI8Ic7oAmNdEov5IQGmobLo5TsAQ
         5fCw1s0hY9lwaRWR/CCVK0ovJCH5540PcFhzsAVBptuLhyxPxW7ChR0OaT71f4OdMIWJ
         AyhSQLkUZVFME7YW/JFo1uN3MsNzrViiy88csTFOltJcWpxjXav1mVQDuNZ64B5s97Hn
         Tw6if693wHWHZyvuc976NjaVPNPB+VZSGNaQ6ORYY4jClTb4cJnUGOBca4z+cOx5YPA4
         mWEkC6Fc0Nf6Ny5+lk2vBVfvpi8jc36NApLOM6l/x5m3/1J0LWsWXX8sWhlyeZo449VE
         P4/A==
X-Gm-Message-State: AOAM531VOl7jxvt6aB5rdD/cHLb3TMDaqhLHdeFWrZjsdo6Wvyjs3Q7s
        SgspfQlzWlrtXJ0f0+4BejlIcAvOI5pB1XsC0yk=
X-Google-Smtp-Source: ABdhPJxcur7aNC//xvtUubB6G8DaT9QmIgHHCZ6/yJxoeSImjR1QLAsm46fmwITN3qXMFu/ziIBgGa3LpmvkQ2y34BY=
X-Received: by 2002:a05:6512:3102:: with SMTP id n2mr1901311lfb.493.1608311100639;
 Fri, 18 Dec 2020 09:05:00 -0800 (PST)
MIME-Version: 1.0
References: <20201218162404.45567-1-marcelo827@gmail.com> <8c9448aa-5bd3-88a5-a830-3c1229db3fe2@gmail.com>
In-Reply-To: <8c9448aa-5bd3-88a5-a830-3c1229db3fe2@gmail.com>
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Date:   Fri, 18 Dec 2020 12:04:49 -0500
Message-ID: <CA+saATVXfbrX3JM-omq9g8MVXAKFksACVgJJ_g61Y00DCTB+FQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: flush timeouts that should already have expired
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Dec 18, 2020 at 11:49 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 18/12/2020 16:24, Marcelo Diop-Gonzalez wrote:
> > Right now io_flush_timeouts() checks if the current number of events
> > is equal to ->timeout.target_seq, but this will miss some timeouts if
> > there have been more than 1 event added since the last time they were
> > flushed (possible in io_submit_flush_completions(), for example). The
> > test below hangs before this change (unless you run with
> > $ ./a.out ~/somefile 1)
> >
> [...]
> >
> > Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
> > ---
> >  fs/io_uring.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index b74957856e68..ae7244f8e842 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -1639,7 +1639,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
> >
> >               if (io_is_timeout_noseq(req))
> >                       break;
> > -             if (req->timeout.target_seq != ctx->cached_cq_tail
> > +             if (req->timeout.target_seq > ctx->cached_cq_tail
>
> There was an pretty old patch for probably that problem, which got
> lost... Please consider that target_seq and others are u32 and may
> easily overflow, you can't do comparisons as freely. It would be
> great to finally fix it, but that can be a bit harder to do.

Ahh whoops! Good point, didn't think of that.

-Marcelo
>
> >                                       - atomic_read(&ctx->cq_timeouts))
> >                       break;
> >
> >
>
> --
> Pavel Begunkov
