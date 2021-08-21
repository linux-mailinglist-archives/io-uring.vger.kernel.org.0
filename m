Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4853F3BA4
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 19:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhHURVo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 13:21:44 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:52542 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhHURVo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Aug 2021 13:21:44 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:43200 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1mHUg2-0007kU-IO; Sat, 21 Aug 2021 13:21:02 -0400
Message-ID: <b6c70d996bcf9f4d5324e431f9a051e852e148ba.camel@trillion01.com>
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
Date:   Sat, 21 Aug 2021 13:21:00 -0400
In-Reply-To: <ff80f66c-c364-fad3-4bab-4d4793538702@kernel.dk>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
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
         <9dfb14c1a9ab686df0eeea553b39246bc5b51ede.camel@trillion01.com>
         <ff80f66c-c364-fad3-4bab-4d4793538702@kernel.dk>
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

On Sat, 2021-08-21 at 10:51 -0600, Jens Axboe wrote:
> On 8/21/21 10:47 AM, Olivier Langlois wrote:
> > Jens,
> > 
> > your patch doesn't compile with 5.12+. AFAIK, the reason is that
> > JOBCTL_TASK_WORK is gone.
> > 
> > Wouldn't just a call to tracehook_notify_signal from do_coredump be
> > enough and backward compatible with every possible stable branches?
> 
> That version is just for 5.10, the first I posted is applicable to
> 5.11+
> 
Ok, in that case, I can tell you that it partially works. There is a
small thing missing.

I have tested mine which I did share in
https://lore.kernel.org/io-uring/87pmwt6biw.fsf@disp2133/T/#m3b51d44c12e39a06b82aac1d372df05312cff833

and with another small patch added to it, it does work.

I will offer my patch later today.


