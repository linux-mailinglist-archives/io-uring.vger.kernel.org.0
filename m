Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E54D2FB0F7
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 06:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732825AbhASFjx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 00:39:53 -0500
Received: from sg2plout10-02.prod.sin2.secureserver.net ([182.50.145.5]:41327
        "EHLO sg2plout10-02.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732118AbhASEpP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jan 2021 23:45:15 -0500
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jan 2021 23:45:13 EST
Received: from mail-ot1-f41.google.com ([209.85.210.41])
        by :SMTPAUTH: with ESMTPSA
        id 1ijglAmDNxz4B1ijjlUIX6; Mon, 18 Jan 2021 21:35:24 -0700
X-CMAE-Analysis: v=2.4 cv=SbAyytdu c=1 sm=1 tr=0 ts=6006618d
 a=PTypr3n1IRLBnQ3yzyqIcw==:117 a=IkcTkHD0fZMA:10 a=EmqxpYm9HcoA:10
 a=pGLkceISAAAA:8 a=9vr8BnzVG96gFNSbxsUA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: kaiwan@kaiwantech.com
Received: by mail-ot1-f41.google.com with SMTP id n42so18564091ota.12;
        Mon, 18 Jan 2021 20:35:23 -0800 (PST)
X-Gm-Message-State: AOAM5311zvsh950bILj656SOwg57D71NMDhnIjyUQwbSTDs458NjoB1H
        Yff/96XxcNLwEpvrJX3afd/ebhzlW0ihOWr+w54=
X-Google-Smtp-Source: ABdhPJz0r7vrYUw3z7gsYPwKEPEVuiSgalGCOodz7zAs+w8wsmDs5ru5RxydNPiwFhVZ8XJd00vziAdKjyYOqXKV72E=
X-Received: by 2002:a9d:2c43:: with SMTP id f61mr2091626otb.329.1611030919638;
 Mon, 18 Jan 2021 20:35:19 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
 <116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
 <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
 <20210118194551.h2hrwof7b3q5vgoi@example.org> <CAHk-=wiNpc5BS2BfZhdDqofJx1G=uasBa2Q1eY4cr8O59Rev2A@mail.gmail.com>
 <20210118205629.zro2qkd3ut42bpyq@example.org>
In-Reply-To: <20210118205629.zro2qkd3ut42bpyq@example.org>
From:   Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Date:   Tue, 19 Jan 2021 10:05:03 +0530
X-Gmail-Original-Message-ID: <CAPDLWs-fefTqAe+z-7BeALFpinanfPPd-9rmjKwUQ6WRP3_1Tg@mail.gmail.com>
Message-ID: <CAPDLWs-fefTqAe+z-7BeALFpinanfPPd-9rmjKwUQ6WRP3_1Tg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/8] Use refcount_t for ucounts reference counting
To:     Alexey Gladkov <gladkov.alexey@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-CMAE-Envelope: MS4xfBuCjVuUNzQ9MWUWLlb8iVSUpyoTLrRRPg51VIhbGaS7/r/JfQ4EeCJYJwI3C5A/3IGr0RrIOw/WjTnlGS70S+7fv4X0Xrk+mW7YC7iAJT50eyS+qwic
 JpjBaPm1nVA/UnSgdWar1vNFccMXyBSgHTghu7QmpGrKaXma+Nky59gOwDd9elXAgfw53u8nNqRUBKG4Qg+U/6BDfsBku39FmGkMXdC+8nj42UGYhK1DmD7I
 iWpBynvllxUgGzYNkx3+2Q==
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

(Sorry for the gmail client)
My 0.2, HTH:
a) AFAIK, refcount_inc() (and similar friends) don't return any value
b) they're designed to just WARN() if they saturate or if you're
attempting to increment the value 0 (as it's possibly a UAF bug)
c) refcount_inc_checked() is documented as "Similar to atomic_inc(),
but will saturate at UINT_MAX and WARN"
d) we should avoid using the __foo() when foo() 's present as far as
is sanely possible...

So is one expected to just fix things when they break? - as signalled
by the WARN firing?

--
Regards, kaiwan.


On Tue, Jan 19, 2021 at 2:26 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> On Mon, Jan 18, 2021 at 12:34:29PM -0800, Linus Torvalds wrote:
> > On Mon, Jan 18, 2021 at 11:46 AM Alexey Gladkov
> > <gladkov.alexey@gmail.com> wrote:
> > >
> > > Sorry about that. I thought that this code is not needed when switching
> > > from int to refcount_t. I was wrong.
> >
> > Well, you _may_ be right. I personally didn't check how the return
> > value is used.
> >
> > I only reacted to "it certainly _may_ be used, and there is absolutely
> > no comment anywhere about why it wouldn't matter".
>
> I have not found examples where checked the overflow after calling
> refcount_inc/refcount_add.
>
> For example in kernel/fork.c:2298 :
>
>    current->signal->nr_threads++;
>    atomic_inc(&current->signal->live);
>    refcount_inc(&current->signal->sigcnt);
>
> $ semind search signal_struct.sigcnt
> def include/linux/sched/signal.h:83             refcount_t              sigcnt;
> m-- kernel/fork.c:723 put_signal_struct                 if (refcount_dec_and_test(&sig->sigcnt))
> m-- kernel/fork.c:1571 copy_signal              refcount_set(&sig->sigcnt, 1);
> m-- kernel/fork.c:2298 copy_process                             refcount_inc(&current->signal->sigcnt);
>
> It seems to me that the only way is to use __refcount_inc and then compare
> the old value with REFCOUNT_MAX
>
> Since I have not seen examples of such checks, I thought that this is
> acceptable. Sorry once again. I have not tried to hide these changes.
>
> --
> Rgrds, legion
>
>
