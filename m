Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70BF3213E6
	for <lists+io-uring@lfdr.de>; Mon, 22 Feb 2021 11:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhBVKNf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 05:13:35 -0500
Received: from raptor.unsafe.ru ([5.9.43.93]:58216 "EHLO raptor.unsafe.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230375AbhBVKMa (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 22 Feb 2021 05:12:30 -0500
Received: from example.org (ip-94-113-225-162.net.upcbroadband.cz [94.113.225.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by raptor.unsafe.ru (Postfix) with ESMTPSA id 3E86D209FA;
        Mon, 22 Feb 2021 10:11:46 +0000 (UTC)
Date:   Mon, 22 Feb 2021 11:11:41 +0100
From:   Alexey Gladkov <gladkov.alexey@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v6 3/7] Reimplement RLIMIT_NPROC on top of ucounts
Message-ID: <20210222101141.uve6hnftsakf4u7n@example.org>
References: <cover.1613392826.git.gladkov.alexey@gmail.com>
 <72fdcd154bec7e0dfad090f1af65ddac1e767451.1613392826.git.gladkov.alexey@gmail.com>
 <72214339-57fc-e47f-bb57-d1b39c69e38e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72214339-57fc-e47f-bb57-d1b39c69e38e@kernel.dk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Mon, 22 Feb 2021 10:11:46 +0000 (UTC)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Feb 21, 2021 at 04:38:10PM -0700, Jens Axboe wrote:
> On 2/15/21 5:41 AM, Alexey Gladkov wrote:
> > diff --git a/fs/io-wq.c b/fs/io-wq.c
> > index a564f36e260c..5b6940c90c61 100644
> > --- a/fs/io-wq.c
> > +++ b/fs/io-wq.c
> > @@ -1090,10 +1091,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
> >  		wqe->node = alloc_node;
> >  		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
> >  		atomic_set(&wqe->acct[IO_WQ_ACCT_BOUND].nr_running, 0);
> > -		if (wq->user) {
> > -			wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
> > -					task_rlimit(current, RLIMIT_NPROC);
> > -		}
> > +		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers = task_rlimit(current, RLIMIT_NPROC);
> 
> This doesn't look like an equivalent transformation. But that may be
> moot if we merge the io_uring-worker.v3 series, as then you would not
> have to touch io-wq at all.

In the current code the wq->user is always set to current_user():

io_uring_create [1]
`- io_sq_offload_create
   `- io_init_wq_offload [2]
      `-io_wq_create [3]

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/io_uring.c#n9752
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/io_uring.c#n8107
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/io-wq.c#n1070

So, specifying max_workers always happens.

-- 
Rgrds, legion

