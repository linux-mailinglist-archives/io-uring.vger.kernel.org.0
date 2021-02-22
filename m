Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA59321427
	for <lists+io-uring@lfdr.de>; Mon, 22 Feb 2021 11:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBVK2o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 05:28:44 -0500
Received: from raptor.unsafe.ru ([5.9.43.93]:37334 "EHLO raptor.unsafe.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230117AbhBVK2n (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 22 Feb 2021 05:28:43 -0500
Received: from example.org (ip-94-113-225-162.net.upcbroadband.cz [94.113.225.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by raptor.unsafe.ru (Postfix) with ESMTPSA id E9233209FA;
        Mon, 22 Feb 2021 10:27:36 +0000 (UTC)
Date:   Mon, 22 Feb 2021 11:27:33 +0100
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
Subject: Re: [PATCH v6 0/7] Count rlimits in each user namespace
Message-ID: <20210222102733.gic3q7dniljlbosm@example.org>
References: <cover.1613392826.git.gladkov.alexey@gmail.com>
 <CAHk-=wjsmAXyYZs+QQFQtY=w-pOOSWoi-ukvoBVVjBnb+v3q7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjsmAXyYZs+QQFQtY=w-pOOSWoi-ukvoBVVjBnb+v3q7A@mail.gmail.com>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Mon, 22 Feb 2021 10:28:01 +0000 (UTC)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Feb 21, 2021 at 02:20:00PM -0800, Linus Torvalds wrote:
> On Mon, Feb 15, 2021 at 4:42 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
> >
> > These patches are for binding the rlimit counters to a user in user namespace.
> 
> So this is now version 6, but I think the kernel test robot keeps
> complaining about them causing KASAN issues.
> 
> The complaints seem to change, so I'm hoping they get fixed, but it
> does seem like every version there's a new one. Hmm?

First, KASAN found an unexpected bug in the second patch (Add a reference
to ucounts for each cred). Because I missed that creed_alloc_blank() is
used wider than I found.

Now KASAN has found problems in the RLIMIT_MEMLOCK which I believe I fixed
in v7.

-- 
Rgrds, legion

