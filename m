Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA0848594D
	for <lists+io-uring@lfdr.de>; Wed,  5 Jan 2022 20:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243627AbiAETjO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jan 2022 14:39:14 -0500
Received: from cloud48395.mywhc.ca ([173.209.37.211]:49804 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243596AbiAETjN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jan 2022 14:39:13 -0500
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:43070 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1n5C7r-0007nD-6h; Wed, 05 Jan 2022 14:39:11 -0500
Message-ID: <8b6f2ce48c4097a23f5d03d631ed9363ecd45ddf.camel@trillion01.com>
Subject: Re: [RFC] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 05 Jan 2022 14:39:09 -0500
In-Reply-To: <13250a8d-1a59-4b7b-92e4-1231d73cbdda@gmail.com>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
         <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
         <87h7i694ij.fsf_-_@disp2133>
         <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
         <b3e43e07c68696b83a5bf25664a3fa912ba747e2.camel@trillion01.com>
         <13250a8d-1a59-4b7b-92e4-1231d73cbdda@gmail.com>
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

On Fri, 2021-12-24 at 10:37 +0000, Pavel Begunkov wrote:
> On 12/24/21 01:34, Olivier Langlois wrote:
> > On Fri, 2021-10-22 at 15:13 +0100, Pavel Begunkov wrote:
> > > On 6/9/21 21:17, Eric W. Biederman wrote:
> > > In short, a task creates an io_uring worker thread, then the
> > > worker
> > > submits a task_work item to the creator task and won't die until
> > > the item is executed/cancelled. And I found that the creator task
> > > is
> > > sleeping in do_coredump() -> wait_for_completion()
> > > 
> [...]
> > > A hack executing tws there helps (see diff below).
> > > Any chance anyone knows what this is and how to fix it?
> > > 
> [...]
> > Pavel,
> > 
> > I cannot comment on the merit of the proposed hack but my proposed
> > patch to fix the coredump truncation issue when a process using
> > io_uring core dumps that I submitted back in August is still
> > unreviewed!
> 
> That's unfortunate. Not like I can help in any case, but I assumed
> it was dealt with by
> 
> commit 06af8679449d4ed282df13191fc52d5ba28ec536
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Thu Jun 10 15:11:11 2021 -0500
> 
>      coredump: Limit what can interrupt coredumps
>      
>      Olivier Langlois has been struggling with coredumps being
> incompletely written in
>      processes using io_uring.
>      ...
> 
It was a partial fix only. Oleg Nesterov pointed out that the fix was
not good if if the core dump was written into a pipe.

https://lore.kernel.org/io-uring/20210614141032.GA13677@redhat.com/

> > https://lore.kernel.org/lkml/1625bc89782bf83d9d8c7c63e8ffcb651ccb15
> > fa.1629655338.git.olivier@trillion01.com/
> > 
> > I have been using it since then I must have generated many dozens
> > of
> > perfect core dump files with it and I have not seen a single
> > truncated
> > core dump files like I used to have prior to the patch.
> > 
> > I am bringing back my patch to your attention because one nice side
> > effect of it is that it would have avoided totally the problem that
> > you
> > have encountered in coredump_wait() since it does cancel io_uring
> > resources before calling coredump_wait()!
> 
> FWIW, I worked it around in io_uring back then by breaking the
> dependency.
> 
Yes I have seen your work to fix the problem.

It just seems to me that there is no good reason to keep io_uring
process requests once you are generating a core dump and simply
cancelling io_uring before generating the core dump would have avoided
the problem that you have encountered plus any other similar issues yet
to come...

Greetings,

