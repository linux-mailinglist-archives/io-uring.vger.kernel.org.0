Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F3647EA58
	for <lists+io-uring@lfdr.de>; Fri, 24 Dec 2021 02:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245325AbhLXBfB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 20:35:01 -0500
Received: from cloud48395.mywhc.ca ([173.209.37.211]:52876 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245122AbhLXBe7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 20:34:59 -0500
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:42768 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1n0ZU0-0002N8-9d; Thu, 23 Dec 2021 20:34:56 -0500
Message-ID: <b3e43e07c68696b83a5bf25664a3fa912ba747e2.camel@trillion01.com>
Subject: Re: [RFC] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 23 Dec 2021 20:34:54 -0500
In-Reply-To: <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
         <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
         <87h7i694ij.fsf_-_@disp2133>
         <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.42.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 2021-10-22 at 15:13 +0100, Pavel Begunkov wrote:
> On 6/9/21 21:17, Eric W. Biederman wrote:
> > 
> > Folks,
> > 
> > Olivier Langlois has been struggling with coredumps getting
> > truncated in
> > tasks using io_uring.  He has also apparently been struggling with
> > the some of his email messages not making it to the lists.
> 
> Looks syzbot hit something relevant, see
> https://lore.kernel.org/io-
> uring/0000000000000012fb05cee99477@google.com/
> 
> In short, a task creates an io_uring worker thread, then the worker
> submits a task_work item to the creator task and won't die until
> the item is executed/cancelled. And I found that the creator task is
> sleeping in do_coredump() -> wait_for_completion()
> 
> 0xffffffff81343ccb is in do_coredump (fs/coredump.c:469).
> 464
> 465             if (core_waiters > 0) {
> 466                     struct core_thread *ptr;
> 467
> 468                     freezer_do_not_count();
> 469                     wait_for_completion(&core_state->startup);
> 470                     freezer_count();
> 
> 
> A hack executing tws there helps (see diff below).
> Any chance anyone knows what this is and how to fix it?
> 
> 
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 3224dee44d30..f6f9dfb02296 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -466,7 +466,8 @@ static int coredump_wait(int exit_code, struct
> core_state *core_state)
>           struct core_thread *ptr;
>   
>           freezer_do_not_count();
> -        wait_for_completion(&core_state->startup);
> +        while (wait_for_completion_interruptible(&core_state-
> >startup))
> +            tracehook_notify_signal();
>           freezer_count();
>           /*
>            * Wait for all the threads to become inactive, so that
> 
> 
> 
> 
Pavel,

I cannot comment on the merit of the proposed hack but my proposed
patch to fix the coredump truncation issue when a process using
io_uring core dumps that I submitted back in August is still
unreviewed!

https://lore.kernel.org/lkml/1625bc89782bf83d9d8c7c63e8ffcb651ccb15fa.1629655338.git.olivier@trillion01.com/

I have been using it since then I must have generated many dozens of
perfect core dump files with it and I have not seen a single truncated
core dump files like I used to have prior to the patch.

I am bringing back my patch to your attention because one nice side
effect of it is that it would have avoided totally the problem that you
have encountered in coredump_wait() since it does cancel io_uring
resources before calling coredump_wait()!

Greetings,
Olivier

