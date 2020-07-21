Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452072283C2
	for <lists+io-uring@lfdr.de>; Tue, 21 Jul 2020 17:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgGUP1u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jul 2020 11:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbgGUP1t (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 21 Jul 2020 11:27:49 -0400
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3155206E9
        for <io-uring@vger.kernel.org>; Tue, 21 Jul 2020 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595345269;
        bh=dL7Jw9KmKIYfCmIThtzQuCIzVWDKDKywulNrdIg2buI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=j0qRLvgmYQ9iXUqJ4f4hiZXX+OC7ujiyWP5EZtQyEfF4iDeAt6CeXmdA0V1+otFGZ
         ePL1Enpmwdgg1XrlRvW3NTB4VJCiZ1CoYTXOS46oM3P/dYP/h46vNrhyvd6fFuYtck
         gxufNMXrr7yOktk0HDH9GFzFZXNYolk0wn50WmuA=
Received: by mail-wr1-f52.google.com with SMTP id r12so21522615wrj.13
        for <io-uring@vger.kernel.org>; Tue, 21 Jul 2020 08:27:48 -0700 (PDT)
X-Gm-Message-State: AOAM530BekQkmJnaEyTCJlh4o4BQJcccxWraew8YVnTAs7xtUkpkTyLj
        GWUi8n5Bm8zpeUxtrq4LU/8tGDbiKVSKmJ55ErSZ5g==
X-Google-Smtp-Source: ABdhPJzs/y1/L+ekPbxoouGPVxU+hlgPxvyWi1Ma7ez4YIIKHie9EHhNDAWjrb2H6ZhhYQES2PRhXXKktTgN8DqKT1Y=
X-Received: by 2002:a5d:5273:: with SMTP id l19mr17785233wrc.257.1595345267417;
 Tue, 21 Jul 2020 08:27:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegu3EwbBFTSJiPhm7eMyTK2MzijLUp1gcboOo3meMF_+Qg@mail.gmail.com>
 <D9FAB37B-D059-4137-A115-616237D78640@amacapital.net> <20200715171130.GG12769@casper.infradead.org>
 <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com> <CAJfpegt9=p4uo5U2GXqc-rwqOESzZCWAkGMRTY1r8H6fuXx96g@mail.gmail.com>
 <48cc7eea-5b28-a584-a66c-4eed3fac5e76@gmail.com> <202007151511.2AA7718@keescook>
 <20200716131404.bnzsaarooumrp3kx@steredhat> <202007160751.ED56C55@keescook> <20200717080157.ezxapv7pscbqykhl@steredhat.lan>
In-Reply-To: <20200717080157.ezxapv7pscbqykhl@steredhat.lan>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 21 Jul 2020 08:27:34 -0700
X-Gmail-Original-Message-ID: <CALCETrXSPdiVCgh3h=q7w9RyiKnp-=8jOHoFHX=an0cWqK7bzQ@mail.gmail.com>
Message-ID: <CALCETrXSPdiVCgh3h=q7w9RyiKnp-=8jOHoFHX=an0cWqK7bzQ@mail.gmail.com>
Subject: Re: strace of io_uring events?
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Matthew Wilcox <willy@infradead.org>,
        Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        strace-devel@lists.strace.io, io-uring@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 17, 2020 at 1:02 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Thu, Jul 16, 2020 at 08:12:35AM -0700, Kees Cook wrote:
> > On Thu, Jul 16, 2020 at 03:14:04PM +0200, Stefano Garzarella wrote:

> > access (IIUC) is possible without actually calling any of the io_uring
> > syscalls. Is that correct? A process would receive an fd (via SCM_RIGHTS,
> > pidfd_getfd, or soon seccomp addfd), and then call mmap() on it to gain
> > access to the SQ and CQ, and off it goes? (The only glitch I see is
> > waking up the worker thread?)
>
> It is true only if the io_uring istance is created with SQPOLL flag (not the
> default behaviour and it requires CAP_SYS_ADMIN). In this case the
> kthread is created and you can also set an higher idle time for it, so
> also the waking up syscall can be avoided.

I stared at the io_uring code for a while, and I'm wondering if we're
approaching this the wrong way. It seems to me that most of the
complications here come from the fact that io_uring SQEs don't clearly
belong to any particular security principle.  (We have struct creds,
but we don't really have a task or mm.)  But I'm also not convinced
that io_uring actually supports cross-mm submission except by accident
-- as it stands, unless a user is very careful to only submit SQEs
that don't use user pointers, the results will be unpredictable.
Perhaps we can get away with this:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 74bc4a04befa..92266f869174 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7660,6 +7660,20 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int,
fd, u32, to_submit,
     if (!percpu_ref_tryget(&ctx->refs))
         goto out_fput;

+    if (unlikely(current->mm != ctx->sqo_mm)) {
+        /*
+         * The mm used to process SQEs will be current->mm or
+         * ctx->sqo_mm depending on which submission path is used.
+         * It's also unclear who is responsible for an SQE submitted
+         * out-of-process from a security and auditing perspective.
+         *
+         * Until a real usecase emerges and there are clear semantics
+         * for out-of-process submission, disallow it.
+         */
+        ret = -EACCES;
+        goto out;
+    }
+
     /*
      * For SQ polling, the thread will do all submissions and completions.
      * Just return the requested submit count, and wake the thread if

If we can do that, then we could bind seccomp-like io_uring filters to
an mm, and we get obvious semantics that ought to cover most of the
bases.

Jens, Christoph?

Stefano, what's your intended usecase for your restriction patchset?
