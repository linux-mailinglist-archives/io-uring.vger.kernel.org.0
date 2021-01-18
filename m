Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50F72FAA7D
	for <lists+io-uring@lfdr.de>; Mon, 18 Jan 2021 20:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394145AbhARTrK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jan 2021 14:47:10 -0500
Received: from raptor.unsafe.ru ([5.9.43.93]:56470 "EHLO raptor.unsafe.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394024AbhARTrD (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 18 Jan 2021 14:47:03 -0500
Received: from example.org (ip-89-103-122-167.net.upcbroadband.cz [89.103.122.167])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by raptor.unsafe.ru (Postfix) with ESMTPSA id 3C0D820479;
        Mon, 18 Jan 2021 19:45:56 +0000 (UTC)
Date:   Mon, 18 Jan 2021 20:45:51 +0100
From:   Alexey Gladkov <gladkov.alexey@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: [RFC PATCH v3 1/8] Use refcount_t for ucounts reference counting
Message-ID: <20210118194551.h2hrwof7b3q5vgoi@example.org>
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
 <116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
 <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Mon, 18 Jan 2021 19:46:07 +0000 (UTC)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 18, 2021 at 11:14:48AM -0800, Linus Torvalds wrote:
> On Fri, Jan 15, 2021 at 6:59 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
> >
> > @@ -152,10 +153,7 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
> >                         ucounts = new;
> >                 }
> >         }
> > -       if (ucounts->count == INT_MAX)
> > -               ucounts = NULL;
> > -       else
> > -               ucounts->count += 1;
> > +       refcount_inc(&ucounts->count);
> >         spin_unlock_irq(&ucounts_lock);
> >         return ucounts;
> >  }
> 
> This is wrong.
> 
> It used to return NULL when the count saturated.
> 
> Now it just silently saturates.
> 
> I'm not sure how many people care, but that NULL return ends up being
> returned quite widely (through "inc_uncount()" and friends).
> 
> The fact that this has no commit message at all to explain what it is
> doing and why is also a grounds for just NAK.

Sorry about that. I thought that this code is not needed when switching
from int to refcount_t. I was wrong. I'll think about how best to check
it.

-- 
Rgrds, legion

