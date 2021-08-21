Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07ED53F3B7B
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 18:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhHUQsI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 12:48:08 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:54514 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhHUQsI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Aug 2021 12:48:08 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:43192 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1mHU9V-0006l1-GN; Sat, 21 Aug 2021 12:47:25 -0400
Message-ID: <9dfb14c1a9ab686df0eeea553b39246bc5b51ede.camel@trillion01.com>
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Tony Battersby <tonyb@cybernetics.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>
Date:   Sat, 21 Aug 2021 12:47:23 -0400
In-Reply-To: <70526737949ab3ad2d8fc551531d286e0f3d88f4.camel@trillion01.com>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
         <87eeda7nqe.fsf@disp2133>
         <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
         <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
         <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
         <87y2bh4jg5.fsf@disp2133>
         <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
         <87sg1p4h0g.fsf_-_@disp2133> <20210614141032.GA13677@redhat.com>
         <87pmwmn5m0.fsf@disp2133>
         <4d93d0600e4a9590a48d320c5a7dd4c54d66f095.camel@trillion01.com>
         <8af373ec-9609-35a4-f185-f9bdc63d39b7@cybernetics.com>
         <9d194813-ecb1-2fe4-70aa-75faf4e144ad@kernel.dk>
         <b36eb4a26b6aff564c6ef850a3508c5b40141d46.camel@trillion01.com>
         <0bc38b13-5a7e-8620-6dce-18731f15467e@kernel.dk>
         <24c795c6-4ec4-518e-bf9b-860207eee8c7@kernel.dk>
         <05c0cadc-029e-78af-795d-e09cf3e80087@cybernetics.com>
         <b5ab8ca0-cef5-c9b7-e47f-21c0d395f82e@kernel.dk>
         <84640f18-79ee-d8e4-5204-41a2c2330ed8@kernel.dk>
         <c4578bef-a21a-2435-e75a-d11d13d42923@kernel.dk>
         <70526737949ab3ad2d8fc551531d286e0f3d88f4.camel@trillion01.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4 
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

On Sat, 2021-08-21 at 06:08 -0400, Olivier Langlois wrote:
> On Tue, 2021-08-17 at 20:57 -0600, Jens Axboe wrote:
> > 
> > Olivier, I sent a 5.10 version for Nathan, any chance you can test
> > this
> > one for the current kernels? Basically this one should work for
> > 5.11+,
> > and the later 5.10 version is just for 5.10. I'm going to send it
> > out
> > separately for review.
> > 
> > I do think this is the right solution, barring a tweak maybe on
> > testing
> > notify == TWA_SIGNAL first before digging into the task struct. But
> > the
> > principle is sound, and it'll work for other users of TWA_SIGNAL as
> > well. None right now as far as I can tell, but the live patching is
> > switching to TIF_NOTIFY_SIGNAL as well which will also cause issues
> > with
> > coredumps potentially.
> > 
> Ok, I am going to give it a shot. This solution is probably superior
> to
> the previous attempt as it does not inject io_uring dependency into
> the
> coredump module.
> 
> The small extra change that I alluded to in my previous reply will
> still be relevant even if we go with your patch...
> 
> I'll come back soon with your patch testing result and my small extra
> change that I keep teasing about.
> 
> Greetings,
> 
Jens,

your patch doesn't compile with 5.12+. AFAIK, the reason is that
JOBCTL_TASK_WORK is gone.

Wouldn't just a call to tracehook_notify_signal from do_coredump be
enough and backward compatible with every possible stable branches?

Greetings,

