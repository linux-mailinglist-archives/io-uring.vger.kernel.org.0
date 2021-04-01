Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F9C35181D
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhDARoC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbhDARhx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:37:53 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E230CC0225B2
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 08:39:44 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id g8so3450097lfv.12
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 08:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K4Yc9Fo8nH3qAbpV51g94tw6HmT4cWz0oodkJat7vyU=;
        b=PnRMEbvuuxIgoHz2A8hVDovCixxBMZDtl8IbeTG0bOFd0hithGVS/NKIT9zCRfigpP
         ZhaeGVhzMokB2fSjhktb5RZcFYv+z5OzyTdLl2flYiWVb2dGSZk5ZzfNTNxgshBcrMzG
         aSaYYF0nnY0xEBSzCpbpl5LJz4L72gcFX1rt0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K4Yc9Fo8nH3qAbpV51g94tw6HmT4cWz0oodkJat7vyU=;
        b=MiM4cXBYy5xbz2mZIKPzs2eU7o2WU8F7HGnlOmmaI4aKHRh0pwPvBea0x9BDQ1anTh
         hJ25UOi4jnYR1xlOQnNgIeC9LWGw2++hNVa+cYzgRgZFGjVSnJStO/d2Fptc3sWmL0cV
         yKp3bo2EqYfveySEuZRcw+xcNQWtPCkV/wFrlUOJxhpbbLk9KcnM8kUZ+UrGB9DvBM3l
         zlY6w8MLQUPTmo0pDcIJlOilebLjspoHgPQqoudh4Zjo5zFyuJaM+0evvytE2RwHsYcL
         oa1MuQkPLc473Vm3ilZwUl2v1UFN7zlhsw1kRuA7sseY0qeC1ItzsdMnnk18k8N9VBWF
         8NLQ==
X-Gm-Message-State: AOAM533nbwquuEn3/9qtdmlvU+qKQNYoc6smmqMUalg5TlRXUOyfw/gx
        PVDiDPJQiRL6/fl4pIJXfy46odhNFSOUUA==
X-Google-Smtp-Source: ABdhPJz2dHhMx+FaMGKc8NH2IDcisvxHhvTtikw3AC2nPq4ezq1y5n22Pj5GeBzqdEkHwGfSVucotA==
X-Received: by 2002:a19:ca54:: with SMTP id h20mr5986462lfj.292.1617291583030;
        Thu, 01 Apr 2021 08:39:43 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id z129sm575766lfa.127.2021.04.01.08.39.41
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 08:39:41 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id b14so3460993lfv.8
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 08:39:41 -0700 (PDT)
X-Received: by 2002:a05:6512:308b:: with SMTP id z11mr5648326lfd.487.1617291581178;
 Thu, 01 Apr 2021 08:39:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210326003928.978750-1-axboe@kernel.dk> <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk> <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
 <358c5225-c23f-de08-65cb-ca3349793c0e@samba.org> <5bb47c3a-2990-e4c4-69c6-1b5d1749a241@samba.org>
In-Reply-To: <5bb47c3a-2990-e4c4-69c6-1b5d1749a241@samba.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 1 Apr 2021 08:39:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=whEObPkZBe4766DmR46-=5QTUiatWbSOaD468eTgYc1tg@mail.gmail.com>
Message-ID: <CAHk-=whEObPkZBe4766DmR46-=5QTUiatWbSOaD468eTgYc1tg@mail.gmail.com>
Subject: Re: [PATCH 0/6] Allow signals for IO threads
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 1, 2021 at 7:58 AM Stefan Metzmacher <metze@samba.org> wrote:
>
> >
> > Ok, the following makes gdb happy again:
> >
> > --- a/arch/x86/kernel/process.c
> > +++ b/arch/x86/kernel/process.c
> > @@ -163,6 +163,8 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
> >         /* Kernel thread ? */
> >         if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
> >                 memset(childregs, 0, sizeof(struct pt_regs));
> > +               if (p->flags & PF_IO_WORKER)
> > +                       childregs->cs = current_pt_regs()->cs;
> >                 kthread_frame_init(frame, sp, arg);
> >                 return 0;
> >         }
>
> Would it be possible to fix this remaining problem before 5.12 final?

Please not that way.

But doing something like

        childregs->cs = __USER_CS;
        childregs->ss = __USER_DS;
        childregs->ds = __USER_DS;
        childregs->es = __USER_DS;

might make sense (just do it unconditionally, rather than making it
special to PF_IO_WORKER).

Does that make gdb happy too?

           Linus
