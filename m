Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E613A1E7B
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 23:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhFIVED (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 17:04:03 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:49874 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhFIVED (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 17:04:03 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:51954 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lr5Kw-0000ci-Vc; Wed, 09 Jun 2021 17:02:07 -0400
Message-ID: <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
Subject: Re: [RFC] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
From:   Olivier Langlois <olivier@trillion01.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Date:   Wed, 09 Jun 2021 17:02:05 -0400
In-Reply-To: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
         <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
         <87h7i694ij.fsf_-_@disp2133>
         <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
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

On Wed, 2021-06-09 at 13:33 -0700, Linus Torvalds wrote:
> Now, the fact that we haven't cleared TIF_NOTIFY_SIGNAL for the first
> signal is clearly the immediate cause of this, but at the same time I
> really get the feeling that that coredump aborting code should always
> had used fatal_signal_pending().

I need clarify what does happen with the io_uring situation. If
somehow, TIF_NOTIFY_SIGNAL wasn't cleared, I would get all the time a 0
byte size core dump because do_coredump() does check if the dump is
interrupted before writing a single byte.

io_uring is quite a strange animal. AFAIK, the common pattern to use a
wait_queue is to insert a task into it and then put that task to sleep
until the waited event occur.

io_uring place tasks into wait queues and then let the the task return
to user space to do some other stuff (like core dumping). I would guess
that it is the main reason for it using the task_work feature.

So the TIF_NOTIFY_SIGNAL does get set WHILE the core dump is written.

Greetings,
Olivier


