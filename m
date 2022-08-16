Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8EC595FAC
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 17:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiHPPzp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 11:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236376AbiHPPz1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 11:55:27 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5BD1106
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 08:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=DRftvI0EUu7XTQnnfbjyAtqR7uZr9LCUYGHrqEUvaSc=; b=t1hX8DUPDRLyySX5ugfD7lHI08
        AXATQHFhRz2mplmjSEcrnIXWRDv+xr4CCTOcjZ+NJqLuuhLKy/0WfBB4cHPh+VOG+8Ig9UMGZKNi0
        +tatCw3h/PJgxNQwees2J42cMJCug9QnKZa2HocouztoHQhKlxHmG969k1SPcJe8HjCv0RVgDMh/A
        YcXYkQb8kG+wy/xYkWhN6K3LldszW7or5muNsWKTYWmvUe6nWdrKoWAtjQOG5KqV9euUqe2xFcEYl
        pQerHBSsseFEpbkhDZ0o9M0sAR2s9mudQP2DjLKnw0wrwPDxZY2B/1XSzKGXlBDoPtziEDpmNXzjS
        YhJkLiiOM07iGrpiUFL3LGTiuwoN0GmMQ7AFWqpD9Lc7ayJp5FrWFM/aT7NWMvLxTRGRyPtGnH86j
        i/WL4PfteBslUnN7dZIOKCnMv5mvOYluzHHL/DpwlCw7gTMSZO3Ze+K/5LYFlHc7f69FlswlWh1Nf
        3j6zdXOfgmkYJE9HXV31ApCH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oNysR-000Pci-Fj; Tue, 16 Aug 2022 15:53:11 +0000
Message-ID: <a05f7831-92c2-0eb6-0088-73bbdd4acb89@samba.org>
Date:   Tue, 16 Aug 2022 17:53:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
 <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk>
 <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk>
 <f6203da1-1bf4-c5f4-4d8e-c5d1e10bd7ea@kernel.dk>
 <20220326143049.671b463c@kernel.org>
 <78d9a5e2eaad11058f54b1392662099549aa925f.camel@trillion01.com>
 <CAHk-=wiTyisXBgKnVHAGYCNvkmjk=50agS2Uk6nr+n3ssLZg2w@mail.gmail.com>
 <32c3c699-3e3a-d85e-d717-05d1557c17b9@kernel.dk>
 <CAHk-=wiCjtDY0UW8p5c++u_DGkrzx6k91bpEc9SyEqNYYgxbOw@mail.gmail.com>
 <a59ba475-33fc-b91c-d006-b7d8cc6f964d@kernel.dk>
 <CAHk-=wg9jtV5JWxBudYgoL0GkiYPefuRu47d=L+7701kLWoQaA@mail.gmail.com>
 <ca0248b3-2080-3ea2-6a09-825d084ac005@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Deprecation of IORING_OP_EPOLL_CTL (Re: [GIT PULL] io_uring updates
 for 5.18-rc1)
In-Reply-To: <ca0248b3-2080-3ea2-6a09-825d084ac005@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Jens, hi Linus,

I just noticed this commit:

commit 61a2732af4b0337f7e36093612c846e9f5962965
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Jun 1 12:36:42 2022 -0600

     io_uring: deprecate epoll_ctl support

     As far as we know, nobody ever adopted the epoll_ctl management via
     io_uring. Deprecate it now with a warning, and plan on removing it in
     a later kernel version. When we do remove it, we can revert the following
     commits as well:

     39220e8d4a2a ("eventpoll: support non-blocking do_epoll_ctl() calls")
     58e41a44c488 ("eventpoll: abstract out epoll_ctl() handler")

     Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
     Link: https://lore.kernel.org/io-uring/CAHk-=wiTyisXBgKnVHAGYCNvkmjk=50agS2Uk6nr+n3ssLZg2w@mail.gmail.com/
     Signed-off-by: Jens Axboe <axboe@kernel.dk>

>> On Wed, Jun 1, 2022 at 11:34 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> But as a first step, let's just mark it deprecated with a pr_warn() for
>>> 5.20 and then plan to kill it off whenever a suitable amount of relases
>>> have passed since that addition.
>>
>> I'd love to, but it's not actually realistic as things stand now.
>> epoll() is used in a *lot* of random libraries. A "pr_warn()" would
>> just be senseless noise, I bet.
> 
> I mean only for the IORING_OP_EPOLL_CTL opcode, which is the only epoll
> connection we have in there.

+       pr_warn_once("%s: epoll_ctl support in io_uring is deprecated and will "
+                    "be removed in a future Linux kernel version.\n",
+                    current->comm);

I don't think application writer will ever notice such warning in log files.

Wouldn't it be better to rename IORING_OP_EPOLL_CTL to IORING_OP_EPOLL_CTL_DEPRECATED,
so that developers notice the problem and can complain, because their application
doesn't compile.

As we don't know about any application using it, most likely nobody will ever notice that rename.

If I haven't noticed that commit, by reading
https://lwn.net/SubscriberLink/903487/5fddc7bb8e3bdcdd/
I may have started to use it in future within Samba's libtevent.

While researching on it I also noticed that
.prep = io_eopnotsupp_prep, is not paired with .not_supported = 1;
so that io_probe() will still report IO_URING_OP_SUPPORTED.
I think io_uring_optable_init() should assert that both are in sync.

>> No, there's a reason that EPOLL is still there, still 'default y',
>> even though I dislike it and think it was a mistake, and we've had
>> several nasty bugs related to it over the years.
>>
>> It really can be a very useful system call, it's just that it really
>> doesn't work the way the actual ->poll() interface was designed, and
>> it kind of hijacks it in ways that mostly work, but the have subtle
>> lifetime issues that you don't see with a regular select/poll because
>> those will always tear down the wait queues.
>>
>> Realistically, the proper fix to epoll is likely to make it explicit,
>> and make files and drivers that want to support it have to actually
>> opt in. Because a lot of the problems have been due to epoll() looking
>> *exactly* like a regular poll/select to a driver or a filesystem, but
>> having those very subtle extended requirements.
>>
>> (And no, the extended requirements aren't generally onerous, and
>> regular ->poll() works fine for 99% of all cases. It's just that
>> occasionally, special users are then fooled about special contexts).

Currently we're using epoll_wait() as central blocking syscall,
we use it with level triggering and only ask for a single
struct epoll_event at a time. And we use the raw memory pointer
values as epoll_event.data.ptr in order to find the related
in memory structure belonging to the event.

This works very nicely because if more than one file descriptor
is ready, calling epoll_wait() seems traverse through the ready list,
which generated fair results.

We avoid asking for more events in a single epoll_wait() calls,
because we often have multiple file descriptor belonging together
to a high level application request. And the event handler for
one file descriptor may close another file descriptor of changes it
in some other way, which means the information of a 2nd epoll_event
from a single epoll_wait(), is not unlikely be stale.

So for userspace epoll seems to be a very useful interface
(at least with level based triggering, I never understood edge-triggering).

Are the epoll problems you were discussion mostly about edge-triggering
and/or only kernel internals are also about the userspace intercace?

I'm now wondering how we would be able to move to
io_uring_enter() as central blocking syscall.

Over time we'll try to use native calls like, IORING_OP_SENDMSG
and others. But we'll ever have to support poll based notifications
in order to try wait for file descriptor state changes.

So I looked at IORING_OP_POLL_ADD/REMOVE and noticed the recent
addition of IORING_POLL_ADD_LEVEL.

But I'm having a hard time understanding how this will work
at runtime.

I'm seeing some interaction with task work and vfs_poll() but I'm
not really sure what it means in the end.

Taskwork (without IORING_SETUP_DEFER_TASKRUN) seems to run after each syscall.

In case I did 10.000 IORING_OP_POLL_ADD calls to monitor 10.000 file descriptor,
does it means after each syscall there's a loop of 10.000 vfs_poll() calls?

What is the event that lets IORING_POLL_ADD_LEVEL trigger the next cqe?

And with IORING_POLL_ADD_LEVEL does it means that each loop will try to post
10.000 cqes (over and over again), if all 10.000 file descriptors are ready and would state that way.

This would likely overflow the cqe array without a chance to recover itself.
Also the information in the already posted cqes might be already out of date
when they arrive in the application. While with epoll_wait(maxevents=1) I'm sure
the information of the single event I'm extracting is recent.

Dealing with cqe overflows it seems to be very nasty.
And from userspace it seems to be easier to take single fd from epoll_create()
and monitor that with IORING_OP_POLL_ADD and use IORING_OP_EPOLL_CTL to do
modification while still calling epoll_wait(maxevents=1, timwout=0) to get just
one event.

You see that I'm very likely (hopefully) have the wrong picture in mind how
epoll_wait could be avoided, so it would very nice if someone could explain
it to me.

I need to make the transition io_uring_enter() as central syscall first
without any native IORING_OP_* calls, as there's no way I can convert all Samba
code at once, and I also don't intend to try it at all for most parts, as we need
to stay portable to platforms like freebsd and aix where we only have plain poll().
So any hints how to do that plain replacement would be nice.

When that's done I can start to convert performance critical in the fileserver
to native IORING_OP_* calls.

Sorry for the long mail and thanks for any comments in advance!
metze
