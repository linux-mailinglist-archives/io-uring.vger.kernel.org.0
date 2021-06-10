Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4EE3A2F26
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 17:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbhFJPTL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 11:19:11 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:59412 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbhFJPTK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 11:19:10 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:51970 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lrMQi-0002Ys-MC; Thu, 10 Jun 2021 11:17:12 -0400
Message-ID: <274c764afe34abdf06abc6a7eaf753a2911c967b.camel@trillion01.com>
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
Date:   Thu, 10 Jun 2021 11:17:11 -0400
In-Reply-To: <87pmwt6biw.fsf@disp2133>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
         <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
         <87h7i694ij.fsf_-_@disp2133>
         <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
         <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
         <87eeda7nqe.fsf@disp2133>
         <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
         <87pmwt6biw.fsf@disp2133>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.2 
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

On Thu, 2021-06-10 at 09:26 -0500, Eric W. Biederman wrote:
> Olivier Langlois <olivier@trillion01.com> writes:
> 
> > On Wed, 2021-06-09 at 16:05 -0500, Eric W. Biederman wrote:
> > > > 
> > > > So the TIF_NOTIFY_SIGNAL does get set WHILE the core dump is
> > > > written.
> > > 
> > > Did you mean?
> > > 
> > > So the TIF_NOTIFY_SIGNAL does _not_ get set WHILE the core dump
> > > is
> > > written.
> > > 
> > > 
> > Absolutely not. I did really mean what I have said. Bear with me
> > that,
> > I am not qualifying myself as an expert kernel dev yet so feel free
> > to
> > correct me if I say some heresy...
> 
> No.  I was just asking to make certain I understood what you said.
> 
> I thought you said you were getting a consistent 0 byte coredump,
> and that implied that TIF_NOTIFY_SIGNAL was coming in before
> the coredump even started.

due to the asynchronous nature of the problem, it is all random.

Sometimes, I do get 0 byte coredump.
Most of the times, I get a truncated one
and very rarely (this is why the issue was so annoying), I get a full
coredump.
> 
> So I will spin up a good version of my patch (based on your patch)
> so we can unbreak coredumps.
> 
That is super nice. I am looking forward it!

Greetings,
Olivier

