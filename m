Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B68393865
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 23:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhE0Vt4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 17:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhE0Vtz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 17:49:55 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33922C061574
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 14:48:21 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id lr4-20020a17090b4b84b02901600455effdso2086703pjb.5
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 14:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UdO9x8orQw0pn2f/sTTr9fkeidNnPo1TfIW/Yark4ng=;
        b=uYVrb1L3DMTx9NVDYqx8FAo+ElrSX0InJJtcwn0sQ5FAt6CfuKGsinsR1287Ihpw5/
         wzkfci/43a4fmeLX1yqdKnKwyspXzIkUDBRL6V35IbJzajzfiFCA8Jb1LHBwXPNnCGnh
         boxEcS5N0Sgrsfjs3emk4xTCf2JUX8K1lIZ47F+UxaZnsM2LYw0RTVd7eudHXxJ8FTVa
         RO5UwyTHBbyMFDJyDy9HtMH359SPeYgFTTCuTtt1mNka6EYEfuWDzABZ8YSvrG1D/qAt
         KrWcPGDqB9+ay7TWZa7HSjt6teKIxBGCNsyDCfYsg0VU+GpMI9XLZCUgw0NTIilQwyTJ
         5DLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UdO9x8orQw0pn2f/sTTr9fkeidNnPo1TfIW/Yark4ng=;
        b=IokWRgn51VEpEj0NfkQB6LBiA8jA3rJtA+XtFkgDEjkpdHInBwAHdg0hJiXQ4iU2Ij
         9T6vx2umxSLOEJUhI70GrvGwnBMQmrrcT4WaJs0JCH7fI0dhgVU4z3+BceAf5oEpM5Hj
         jtA5Z1YDb1ELncRvNos4ekPsoe0y/BLa3uuR2XScJGxW3Hjr3NqaOrBOyqGnTbSEimXG
         O+WwLUW7bqe8mLdhnkCHODTBDSJGtPfJjkC8YehTduSZD/FbUSvKExEmN3heuvFBAU1r
         7nM+rCXwFd9HLj6awLhHgjuKBsHfdNW/lk7TVAq2xeLyQud8Gc3aqDIyHjhLhdFysUvS
         gd/Q==
X-Gm-Message-State: AOAM5330/PZfWCjkS1/5Y/FilPdtSQlIjNv2BkA9M4x032hZCRVS+OoS
        cgYfjnOXTTtS7COEZpMHxR1nPiXAG6SppekRek8=
X-Google-Smtp-Source: ABdhPJzkdWanSl/mAtVYLHgZ3NvwzBhiLntM7rjsnqo9xhaf4pDbfIbKt8d9ve/Gece96BAUuzdAITB95jMezO6RBnk=
X-Received: by 2002:a17:902:aa04:b029:ec:f779:3a2b with SMTP id
 be4-20020a170902aa04b02900ecf7793a2bmr5077925plb.44.1622152100744; Thu, 27
 May 2021 14:48:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1621899872.git.asml.silence@gmail.com> <031ec5e0189daa5b21bf89117bdf30b1889c3f72.1621899872.git.asml.silence@gmail.com>
In-Reply-To: <031ec5e0189daa5b21bf89117bdf30b1889c3f72.1621899872.git.asml.silence@gmail.com>
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Date:   Thu, 27 May 2021 17:48:10 -0400
Message-ID: <CAFUsyf+9f=w5WTZ65rMmYMOuSz7xLQ81rzAgEK=uG_a7gF_FWw@mail.gmail.com>
Subject: Re: [PATCH 05/13] io-wq: replace goto while
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "open list:IO_URING" <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 24, 2021 at 7:51 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> If for/while is simple enough it's more prefered over goto with labels
> as the former one is more explicit and easier to read. So, replace a
> trivial goto-based loop in io_wqe_worker() with a while.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io-wq.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index a0e43d1b94af..712eb062f822 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -538,12 +538,13 @@ static int io_wqe_worker(void *data)
>                 long ret;
>
>                 set_current_state(TASK_INTERRUPTIBLE);
> -loop:
> -               raw_spin_lock_irq(&wqe->lock);
> -               if (io_wqe_run_queue(wqe)) {
> +               while (1) {
> +                       raw_spin_lock_irq(&wqe->lock);
Can acquiring the spinlock be hoisted from the loop?
> +                       if (!io_wqe_run_queue(wqe))
> +                               break;
>                         io_worker_handle_work(worker);
> -                       goto loop;
>                 }
> +
>                 __io_worker_idle(wqe, worker);
>                 raw_spin_unlock_irq(&wqe->lock);
>                 if (io_flush_signals())
> --
> 2.31.1
>
