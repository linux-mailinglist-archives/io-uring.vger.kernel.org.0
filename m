Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81AA404072
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 23:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbhIHVMi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 17:12:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54628 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbhIHVMi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 17:12:38 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631135489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fu5kMUZpxkX+s5Xzjbe5W/ZeaCin9i6TKC3Ug/LbFGk=;
        b=MKUkMumzzF+0be0JCG+ZKnKNNl6zmlRXBNuh6cepuXn6JRGI+UyG9/wPEJ0O5yfy46PErS
        NrTqfjMaPakQ9i5EiPzuW1Arnd+eoZb3rNCewboqj0zSrY4/cq9fimlSoidIn07LtalZbv
        XGD6uTfOOlv1i4AYHN+dndZmJ1lHBFjbMPhtKWmIDbohpwvcMVVR1ZgXPsizQtgDlXnMRv
        zoRLCepXaCINQPrcVYKkJCWwM3uR4vmQTTSnM3Kya7inLz0ivwZAtK1G7VuiOILjJTKE/I
        lg+IaBo81ekxAekilCNo6VWE/PRIcm22r+srMVxa5gfhaaj/qsYkW7wn5i95sA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631135489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fu5kMUZpxkX+s5Xzjbe5W/ZeaCin9i6TKC3Ug/LbFGk=;
        b=rBUyok1IbfCsd+RX7ktrzmcXUqVcHxSTUBBYRiXvhNoJ32El16eCShGxpHL6wLnN2TKlO+
        vlnQvmWy3PEBPkDw==
To:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+b935db3fe409625cca1b@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        io-uring@vger.kernel.org
Subject: Re: [syzbot] general protection fault in hrtimer_start_range_ns
In-Reply-To: <111a312d-ec11-be36-ac74-ef92c8896967@kernel.dk>
References: <0000000000009eeadd05cb511b60@google.com> <875yvbf23g.ffs@tglx>
 <8bbede01-4a97-bf22-92ad-c05a562c9799@kernel.dk>
 <111a312d-ec11-be36-ac74-ef92c8896967@kernel.dk>
Date:   Wed, 08 Sep 2021 23:11:28 +0200
Message-ID: <87tuiueprz.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 08 2021 at 11:20, Jens Axboe wrote:

> On 9/8/21 11:02 AM, Jens Axboe wrote:
>> On 9/8/21 10:45 AM, Thomas Gleixner wrote:
>>> On Mon, Sep 06 2021 at 03:28, syzbot wrote:
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    835d31d319d9 Merge tag 'media/v5.15-1' of git://git.kernel..
>>>> git tree:       upstream
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=14489886300000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=d793523866f2daea
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=b935db3fe409625cca1b
>>>> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
>>>>
>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+b935db3fe409625cca1b@syzkaller.appspotmail.com
>>>>
>>>> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
>>>> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>>>> CPU: 0 PID: 12936 Comm: iou-sqp-12929 Not tainted 5.14.0-syzkaller #0
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>> RIP: 0010:lock_hrtimer_base kernel/time/hrtimer.c:173 [inline]
>>>
>>> That's almost certainly deferencing hrtimer->base and as that is NULL
>>> this looks like a not initialized hrtimer.
>> 
>> Does certainly look like that, I'll take a look. And agree the next one
>> looks like the same thing.
>
> I think both are fallout from a regression that we had in linked
> requests, where we'd queue requests that weren't fully prepared. Current
> Linus -git should not have this problem:
>
> These were the two related fixes:
>
>       io_uring: fix queueing half-created requests
>       io_uring: don't submit half-prepared drain request

Makes sense and the backtraces in the changelogs point at the same class
of problem.

Thanks,

        tglx
