Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8BB3A33B9
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 21:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhFJTMj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 15:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhFJTMj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 15:12:39 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B689C061574
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 12:10:42 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id f30so4905139lfj.1
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 12:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SMdGbg5qY7Xril8PIwC2aCilKl3gyih4vJXN13qnRQs=;
        b=cqfvjt39dMqE03b8Qk8T6nxGqG5CE1oOqhjvJmr5822PMJQr4Sbq2nJYsWDStaAAwb
         iZ8tDefBwOO4B7DqY2HZw7POkKfUguqqt97g4qUSfGrtUCu0Qk1R3Aww0cBYlsV+BMuQ
         btfcXVmLIGGv1LLx4UfLfPNWQHDLhab4yvwWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SMdGbg5qY7Xril8PIwC2aCilKl3gyih4vJXN13qnRQs=;
        b=RwBttih09uuUdY30VegUF/HpPHx39jrJ1XNtn0JDs3O/Frs5xvhXGOrGwdvFPdoMaX
         IkQVkPa9pnuv9MVlFEL7PlTjO4UXNe9o/jWryJBCufTiu6XQJlvniA+jcE9OYghy9FUg
         qEDockSmPGxVkP0IT+M8Md49Z4gERPjDYzYqnbTMkCjPWnUZ4a5k78/HVqCJm02ycMbK
         eyxaYdyArUPZxs5TyTfo2RIqa054sdrmBKU0AaY5TzTyRKevfQDXEu/X/q2m4D5TtFqh
         +1C1bs1g+rKI2OZCy32PTTMcOJw6+4dtBTDm2G7fGlPdfF3i4l+qI6RwhK90qn8d6j3g
         T4fA==
X-Gm-Message-State: AOAM532HHvJ+PtLLOR2HYDGPeeAkhWTvnd6dYezJlqT1tTO/NqAQmtME
        jYfL78uvCgkCIzqYTH9vQFe0Eb93fsIwhJGcs2Q=
X-Google-Smtp-Source: ABdhPJza6egX6thgB+0fyYME96Q+IgQDQVH30JJzZw7eGhcRkuqe6u2OCHggyQxWOuKfwrTqXGpBlQ==
X-Received: by 2002:a05:6512:159c:: with SMTP id bp28mr206725lfb.155.1623352240494;
        Thu, 10 Jun 2021 12:10:40 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id v2sm457209ljv.63.2021.06.10.12.10.37
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 12:10:38 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id d2so6336738ljj.11
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 12:10:37 -0700 (PDT)
X-Received: by 2002:a2e:9644:: with SMTP id z4mr50548ljh.507.1623352236538;
 Thu, 10 Jun 2021 12:10:36 -0700 (PDT)
MIME-Version: 1.0
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
 <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
 <87h7i694ij.fsf_-_@disp2133> <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
 <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
 <87eeda7nqe.fsf@disp2133> <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
 <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
In-Reply-To: <87czst5yxh.fsf_-_@disp2133>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 10 Jun 2021 12:10:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
Message-ID: <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
Subject: Re: [CFT}[PATCH] coredump: Limit what can interrupt coredumps
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 10, 2021 at 12:01 PM Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index f7c6ffcbd044..83d534deeb76 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -943,8 +943,6 @@ static bool prepare_signal(int sig, struct task_struct *p, bool force)
>         sigset_t flush;
>
>         if (signal->flags & (SIGNAL_GROUP_EXIT | SIGNAL_GROUP_COREDUMP)) {
> -               if (!(signal->flags & SIGNAL_GROUP_EXIT))
> -                       return sig == SIGKILL;
>                 /*
>                  * The process is in the middle of dying, nothing to do.
>                  */

I do think this part of the patch is correct, but I'd like to know
what triggered this change?

It seems fairly harmless - SIGKILL used to be the only signal that was
passed through in the coredump case, now you pass through all
non-ignored signals.

But since SIGKILL is the only signal that is relevant for the
fatal_signal_pending() case, this change seems irrelevant for the
coredump issue. Any other signals passed through won't matter.

End result: I think removing those two lines is likely a good idea,
but I also suspect it could/should just be a separate patch with a
separate explanation for it.

Hmm?

              Linus
