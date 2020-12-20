Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E942DF601
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 16:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727396AbgLTP5v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Dec 2020 10:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgLTP5u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Dec 2020 10:57:50 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E57C0617B0
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 07:57:10 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id j18so3388130qvu.3
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 07:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UN7U9KbvOzbzp39iw56ayl16T66Zxgw/Ao18GCS6LPI=;
        b=VpNQlZGm4v8fxl8obpZAdSxHhUB5lKmTW0HOhHSKjg1dC6xyVbC4/UN771uRmFHeFG
         JaCPUMtYNCU9ELicGTtp5cgcHGYV1ip9QmBYcgUJot9eepBlAt4jrTFK9wFawQxiTelY
         4wlUSizG6UdNVSSkuiDIvyVFjFkSIsqpu0WHgFFG/xiKdkIxPOyKO8Xe06ZndqeGDNVN
         R708Ujflgos7g0eYNn9hdX3QxiSopdn9sTy1EQRGLbhdZI1SJSwQiIrSJB19QkZBGOfy
         bQsw4dQi6BquuiZ6tk+nyD7gnEIPVVY41aAJJh4LyCvqG0VXLenNq8/Ua+JH2UftcgED
         VFbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UN7U9KbvOzbzp39iw56ayl16T66Zxgw/Ao18GCS6LPI=;
        b=dJLn2ZOxPfviuNHDatvu2gQV20IRzI86H2pqMmKK8QHRIWAmmdkGO/Vel8pwOATsEz
         U0px3j9qgWQZ4RGl9LhSoWqy7nsSkhjKKDl/OmpYOYgIVAQCtaP4x7ruGN/Hfg0hzaP5
         oYnpK/GmAajMojausSI0r7EbbIEXrdxPhAh+1PmxPnHthK3+o2WjSVqbJRkMx/C196NY
         Oh9ZumuniNuyuMg7ADocaSecJLSCybKKdIZ+6VsXRdlaJdqeD0pn+GOduQ9pwmVwx2j9
         D65/Hf5og/B/EGRV01g5A458WFr2YFX9oTiEuVqbkEV0dSqzAUH6BrxjPDYJYldvP7xJ
         LPyw==
X-Gm-Message-State: AOAM533Xhs9R1n/EyHem8humVEJwKdEAxQbBP/d5jxSTNTUu6GBIU/4+
        +CcUPNxcyuXKvABjyNDCSQILtCN5XfUgYBigBh0=
X-Google-Smtp-Source: ABdhPJxqGGjye9ptmELr3GKK+MsQ6JYTnlxwZCaDfSv3uJhf0Qg5pybK5UvFd1yhqgY5Trt017OI2zSZBbuKtfR4kgA=
X-Received: by 2002:ad4:4a72:: with SMTP id cn18mr13751070qvb.50.1608479829655;
 Sun, 20 Dec 2020 07:57:09 -0800 (PST)
MIME-Version: 1.0
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com> <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk> <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com> <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <df79018a-0926-093f-b112-3ed3756f6363@gmail.com> <CAAss7+peDoeEf8PL_REiU6s_wZ+Z=ZPMcWNdYt0i-C8jUwtc4Q@mail.gmail.com>
 <0fb27d06-af82-2e1b-f8c5-3a6712162178@gmail.com> <6361f713-2c90-0828-6a8f-72d277320591@gmail.com>
In-Reply-To: <6361f713-2c90-0828-6a8f-72d277320591@gmail.com>
From:   Josef <josef.grieb@gmail.com>
Date:   Sun, 20 Dec 2020 16:56:58 +0100
Message-ID: <CAAss7+oFAS9rs-6Wkz3=FQX4x0TpFY1WiMZpK66MofFgMhTaqw@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Norman Maurer <norman.maurer@googlemail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> I'd really appreciate if you can try one more. I want to know why
> the final cleanup doesn't cope  with it.

yeah sure, which kernel version? it seems to be that this patch
doesn't match io_uring-5.11 and io_uring-5.10

On Sun, 20 Dec 2020 at 15:22, Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 20/12/2020 13:00, Pavel Begunkov wrote:
> > On 20/12/2020 07:13, Josef wrote:
> >>> Guys, do you share rings between processes? Explicitly like sending
> >>> io_uring fd over a socket, or implicitly e.g. sharing fd tables
> >>> (threads), or cloning with copying fd tables (and so taking a ref
> >>> to a ring).
> >>
> >> no in netty we don't share ring between processes
> >>
> >>> In other words, if you kill all your io_uring applications, does it
> >>> go back to normal?
> >>
> >> no at all, the io-wq worker thread is still running, I literally have
> >> to restart the vm to go back to normal(as far as I know is not
> >> possible to kill kernel threads right?)
> >>
> >>> Josef, can you test the patch below instead? Following Jens' idea it
> >>> cancels more aggressively when a task is killed or exits. It's based
> >>> on [1] but would probably apply fine to for-next.
> >>
> >> it works, I run several tests with eventfd read op async flag enabled,
> >> thanks a lot :) you are awesome guys :)
> >
> > Thanks for testing and confirming! Either we forgot something in
> > io_ring_ctx_wait_and_kill() and it just can't cancel some requests,
> > or we have a dependency that prevents release from happening.
> >
> > BTW, apparently that patch causes hangs for unrelated but known
> > reasons, so better to not use it, we'll merge something more stable.
>
> I'd really appreciate if you can try one more. I want to know why
> the final cleanup doesn't cope  with it.
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 941fe9b64fd9..d38fc819648e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8614,6 +8614,10 @@ static int io_remove_personalities(int id, void *p, void *data)
>         return 0;
>  }
>
> +static void io_cancel_defer_files(struct io_ring_ctx *ctx,
> +                                 struct task_struct *task,
> +                                 struct files_struct *files);
> +
>  static void io_ring_exit_work(struct work_struct *work)
>  {
>         struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
> @@ -8627,6 +8631,8 @@ static void io_ring_exit_work(struct work_struct *work)
>          */
>         do {
>                 io_iopoll_try_reap_events(ctx);
> +               io_poll_remove_all(ctx, NULL, NULL);
> +               io_kill_timeouts(ctx, NULL, NULL);
>         } while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
>         io_ring_ctx_free(ctx);
>  }
> @@ -8641,6 +8647,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
>                 io_cqring_overflow_flush(ctx, true, NULL, NULL);
>         mutex_unlock(&ctx->uring_lock);
>
> +       io_cancel_defer_files(ctx, NULL, NULL);
>         io_kill_timeouts(ctx, NULL, NULL);
>         io_poll_remove_all(ctx, NULL, NULL);
>
> --
> Pavel Begunkov



-- 
Josef
