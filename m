Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512343ED483
	for <lists+io-uring@lfdr.de>; Mon, 16 Aug 2021 15:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbhHPNDm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Aug 2021 09:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235519AbhHPNDl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Aug 2021 09:03:41 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB386C061764;
        Mon, 16 Aug 2021 06:03:09 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id f5so23452107wrm.13;
        Mon, 16 Aug 2021 06:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4ey74r9h5B4FsleU6ivv3WvBZFvF09kXQTJf5FkLGKg=;
        b=kiowXfPOnvNLxiobCImqWlbPdEaYpfeeS7uTkrbVyfLPq2Ww2H2+rjHOU4oKlIBEH2
         gMX7ddNGCAbi2fRmWxquoAxbIJwq/cewfhkyBpQ5e0tACbl1YU/oWO1v6E4kWZFLQxI2
         jJbLXt3KRjTjjhgDCHGH/xL1ArHmtZAXvpKlkeiPDqdHd6rjjThMz9sGpDsZUuYrOCdg
         rZZTI6Mm4ogmvEK1oi3Om9S4bK8WJGqt7wA5sFiGMPWvb91tQ8xRg4tHbPPpoFngBbfq
         jva28tvoUANUIDGuQg1j2PB+5dFLRSi1BxgL0XvMozIh2KjWUJ+vH4J0nP/2eBRNznta
         rkVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ey74r9h5B4FsleU6ivv3WvBZFvF09kXQTJf5FkLGKg=;
        b=gcq2Cjir1Z9q68JJaUQO9At7WTeUpqin7mw7Z/J3ctwN3EgNDVt2aHuwOKE3MxIFv2
         dynWKmnF68yqdzKNW5oxGxKr5cpi2OP9Lyoh51XvlTFsy0PUh+bU0PKV32nnfH0zAfYe
         LW8dBWc1VhHq5hH6gMWHGZc7sXTOsemoQ8cq3xDyuBMMigAUYcMfDk9Rpm2S1aRyzK+o
         qFo3IWfTXyG6GLzBCi0HCexklKhkgQJcmhuu8iWjPMDOsk+fHE9MShEesEQ6TFR82ilO
         EWB8FLSIGCYTvQT8jJI+H66jO7cFHsMwKjWM1GRLeVN7lHRcdopwMyeBdU4iplDi76aG
         e7aA==
X-Gm-Message-State: AOAM530Yxr5VV2R+ejR66zVjgtYTDggGqJurg91/FynLDSzk+ye0KzDz
        AwqzAZY+GKzLMqmDrjN+P/w=
X-Google-Smtp-Source: ABdhPJzFHwwFH6z6Bs4J55RWCb/F7PeZ8LNy8QhQCco09FhXUf52kwHWLCmhkL7pQSLENuUV93k4Gw==
X-Received: by 2002:a5d:574d:: with SMTP id q13mr18764483wrw.425.1629118988423;
        Mon, 16 Aug 2021 06:03:08 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.12])
        by smtp.gmail.com with ESMTPSA id q75sm11125774wme.40.2021.08.16.06.03.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 06:03:01 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        Tony Battersby <tonyb@cybernetics.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
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
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
Message-ID: <b9f92bf3-77aa-8cdd-6db7-95c86e5a6946@gmail.com>
Date:   Mon, 16 Aug 2021 14:02:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <b36eb4a26b6aff564c6ef850a3508c5b40141d46.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/21 9:42 PM, Olivier Langlois wrote:
[...]
> When I have first encountered the issue, the very first thing that I
> did try was to create a simple test program that would synthetize the
> problem.
> 
> After few time consumming failed attempts, I just gave up the idea and
> simply settle to my prod program that showcase systematically the
> problem every time that I kill the process with a SEGV signal.
> 
> In a nutshell, all the program does is to issue read operations with
> io_uring on a TCP socket on which there is a constant data stream.
> 
> Now that I have a better understanding of what is going on, I think
> that one way that could reproduce the problem consistently could be
> along those lines:
> 
> 1. Create a pipe
> 2. fork a child
> 3. Initiate a read operation on the pipe with io_uring from the child
> 4. Let the parent kill its child with a core dump generating signal.
> 5. Write something in the pipe from the parent so that the io_uring
> read operation completes while the core dump is generated.
> 
> I guess that I'll end up doing that if I cannot fix the issue with my
> current setup but here is what I have attempted so far:
> 
> 1. Call io_uring_files_cancel from do_coredump
> 2. Same as #1 but also make sure that TIF_NOTIFY_SIGNAL is cleared on
> returning from io_uring_files_cancel
> 
> Those attempts didn't work but lurking in the io_uring dev mailing list
> is starting to pay off. I thought that I did reach the bottom of the
> rabbit hole in my journey of understanding io_uring but the recent
> patch set sent by Hao Xu
> 
> https://lore.kernel.org/io-uring/90fce498-968e-6812-7b6a-fdf8520ea8d9@kernel.dk/T/#t
> 
> made me realize that I still haven't assimilated all the small io_uring
> nuances...
> 
> Here is my feedback. From my casual io_uring code reader point of view,
> it is not 100% obvious what the difference is between
> io_uring_files_cancel and io_uring_task_cancel

As you mentioned, io_uring_task_cancel() cancels and waits for all
requests submitted by current task, used in exec() and SQPOLL because
of potential races.

io_uring_task_cancel() cancels only selected ones and


io_uring_files_cancel()
cancels and waits only some specific requests that we absolutely have
to, e.g. in 5.15 it'll be only requests referencing the ring itself.
It's used on normal task exit.

io_uring_task_cancel() cancels and waits all requests submitted by
current task, used on exec() because of races.



As you mentioned 

> 
> It seems like io_uring_files_cancel is cancelling polls only if they
> have the REQ_F_INFLIGHT flag set.
> 
> I have no idea what an inflight request means and why someone would
> want to call io_uring_files_cancel over io_uring_task_cancel.
> 
> I guess that if I was to meditate on the question for few hours, I
> would at some point get some illumination strike me but I believe that
> it could be a good idea to document in the code those concepts for
> helping casual readers...
> 
> Bottomline, I now understand that io_uring_files_cancel does not cancel
> all the requests. Therefore, without fully understanding what I am
> doing, I am going to replace my call to io_uring_files_cancel from
> do_coredump with io_uring_task_cancel and see if this finally fix the
> issue for good.
> 
> What I am trying to do is to cancel pending io_uring requests to make
> sure that TIF_NOTIFY_SIGNAL isn't set while core dump is generated.
> 
> Maybe another solution would simply be to modify __dump_emit to make it
> resilient to TIF_NOTIFY_SIGNAL as Eric W. Biederman originally
> suggested.
> 
> or maybe do both...
> 
> Not sure which approach is best. If someone has an opinion, I would be
> curious to hear it.
> 
> Greetings,
> 
> 

-- 
Pavel Begunkov
