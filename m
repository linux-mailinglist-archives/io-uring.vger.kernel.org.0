Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DD83F3A04
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 11:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbhHUJtZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 05:49:25 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:51814 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbhHUJtZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Aug 2021 05:49:25 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:43166 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1mHNcJ-0000xo-VU; Sat, 21 Aug 2021 05:48:44 -0400
Message-ID: <29171eb24018cb1237b3864bce5a2d4d92e16f46.camel@trillion01.com>
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
Date:   Sat, 21 Aug 2021 05:48:42 -0400
In-Reply-To: <0bc38b13-5a7e-8620-6dce-18731f15467e@kernel.dk>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
         <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
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

On Tue, 2021-08-17 at 12:15 -0600, Jens Axboe wrote:
> 
> It does indeed sound like it's TIF_NOTIFY_SIGNAL that will trigger
> some
> signal_pending() and cause an interruption of the core dump. Just out
> of
> curiosity, what is your /proc/sys/kernel/core_pattern set to? If it's
> set to some piped process, can you try and set it to 'core' and see
> if
> that eliminates the truncation of the core dumps for your case?
> 

/proc/sys/kernel/core_pattern is set to:
|/home/lano1106/bin/pipe_core.sh %e %p

It normally points to systemd coredump module. I have pointed to a
simpler program for debugging purposes.

when core_pattern points to a local file, core dump files are just
fine. That was the whole point of 

commit 06af8679449d ("coredump: Limit what can interrupt coredumps")

I have been distracted by other things this week but my last attempt to
fix this problem appears to be successful. I will send out a small
patch set shortly...

