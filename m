Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBB12FEFE9
	for <lists+io-uring@lfdr.de>; Thu, 21 Jan 2021 17:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbhAUQOS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jan 2021 11:14:18 -0500
Received: from raptor.unsafe.ru ([5.9.43.93]:52832 "EHLO raptor.unsafe.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732178AbhAUQIq (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 21 Jan 2021 11:08:46 -0500
Received: from example.org (ip-94-112-41-137.net.upcbroadband.cz [94.112.41.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by raptor.unsafe.ru (Postfix) with ESMTPSA id D51E2209D4;
        Thu, 21 Jan 2021 16:07:46 +0000 (UTC)
Date:   Thu, 21 Jan 2021 17:07:42 +0100
From:   Alexey Gladkov <gladkov.alexey@gmail.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH v3 1/8] Use refcount_t for ucounts reference counting
Message-ID: <20210121160742.evd3632lepfytlxb@example.org>
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
 <116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
 <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
 <20210118194551.h2hrwof7b3q5vgoi@example.org>
 <CAHk-=wiNpc5BS2BfZhdDqofJx1G=uasBa2Q1eY4cr8O59Rev2A@mail.gmail.com>
 <20210118205629.zro2qkd3ut42bpyq@example.org>
 <87eeig74kv.fsf@x220.int.ebiederm.org>
 <20210121120427.iiggfmw3tpsmyzeb@example.org>
 <87ft2u2ss5.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ft2u2ss5.fsf@x220.int.ebiederm.org>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Thu, 21 Jan 2021 16:08:00 +0000 (UTC)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jan 21, 2021 at 09:50:34AM -0600, Eric W. Biederman wrote:
> >> The current ucount code does check for overflow and fails the increment
> >> in every case.
> >> 
> >> So arguably it will be a regression and inferior error handling behavior
> >> if the code switches to the ``better'' refcount_t data structure.
> >> 
> >> I originally didn't use refcount_t because silently saturating and not
> >> bothering to handle the error makes me uncomfortable.
> >> 
> >> Not having to acquire the ucounts_lock every time seems nice.  Perhaps
> >> the path forward would be to start with stupid/correct code that always
> >> takes the ucounts_lock for every increment of ucounts->count, that is
> >> later replaced with something more optimal.
> >> 
> >> Not impacting performance in the non-namespace cases and having good
> >> performance in the other cases is a fundamental requirement of merging
> >> code like this.
> >
> > Did I understand your suggestion correctly that you suggest to use
> > spin_lock for atomic_read and atomic_inc ?
> >
> > If so, then we are already incrementing the counter under ucounts_lock.
> >
> > 	...
> > 	if (atomic_read(&ucounts->count) == INT_MAX)
> > 		ucounts = NULL;
> > 	else
> > 		atomic_inc(&ucounts->count);
> > 	spin_unlock_irq(&ucounts_lock);
> > 	return ucounts;
> >
> > something like this ?
> 
> Yes.  But without atomics.  Something a bit more like:
> > 	...
> > 	if (ucounts->count == INT_MAX)
> > 		ucounts = NULL;
> > 	else
> > 		ucounts->count++;
> > 	spin_unlock_irq(&ucounts_lock);
> > 	return ucounts;

This is the original code.

> I do believe at some point we will want to say using the spin_lock for
> ucounts->count is cumbersome, and suboptimal and we want to change it to
> get a better performing implementation.
> 
> Just for getting the semantics correct we should be able to use just
> ucounts_lock for locking.  Then when everything is working we can
> profile and optimize the code.
> 
> I just don't want figuring out what is needed to get hung up over little
> details that we can change later.

OK. So I will drop this my change for now.

-- 
Rgrds, legion

