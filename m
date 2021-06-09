Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD003A1EFA
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 23:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhFIV2a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 17:28:30 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:58252 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhFIV2a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 17:28:30 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:51956 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lr5iZ-0001et-BU; Wed, 09 Jun 2021 17:26:31 -0400
Message-ID: <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
Subject: Re: [RFC] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
From:   Olivier Langlois <olivier@trillion01.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Date:   Wed, 09 Jun 2021 17:26:30 -0400
In-Reply-To: <87eeda7nqe.fsf@disp2133>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
         <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
         <87h7i694ij.fsf_-_@disp2133>
         <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
         <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
         <87eeda7nqe.fsf@disp2133>
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

On Wed, 2021-06-09 at 16:05 -0500, Eric W. Biederman wrote:
> > 
> > So the TIF_NOTIFY_SIGNAL does get set WHILE the core dump is
> > written.
> 
> Did you mean?
> 
> So the TIF_NOTIFY_SIGNAL does _not_ get set WHILE the core dump is
> written.
> 
> 
Absolutely not. I did really mean what I have said. Bear with me that,
I am not qualifying myself as an expert kernel dev yet so feel free to
correct me if I say some heresy...

io_uring is placing my task in my TCP socket wait queue because it
wants to read data from it.

The task returns to user space and core dump with a SEGV.

now my understanding is that the code that is waking up tasks, it is
the NIC driver interrupt handler which can occur while the core dump is
written.

does that make sense?

my testing is telling me that this is exactly what happens...


