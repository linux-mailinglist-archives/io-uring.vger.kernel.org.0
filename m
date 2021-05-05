Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8CC374AF7
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 00:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhEEWIl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 18:08:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34752 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhEEWIl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 18:08:41 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620252463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UMR0l2eOxbZlG3eP2GKSR1qj/t2c7J2/JGyBVU+eog8=;
        b=cQHZmYHC6OYkUivvmP5eyqSEXFNg16rNN1F3SKS5vPsTkpvWp85BMTQMA1rYCrgvy6JpKF
        ngLJOlo35ELIF+UdKXvgw7f0Ub0fPxaXkV/jVTdp6MO63zkNZnP/SAEg+wJjUbOtoAqOsK
        +fEuB+qlfVvTYTODzHwYTfeEe9OP8oSGROYkXHZOQwLZNMVHECOoELLMrv8/8wErAxEL6O
        rWPAjg/sshQJXTCEyOhDsWx5Y83In6keIYekwWCMZWQkm4Sh4xoDJXRsgavKJCvpdcnnZ8
        WjG9NC+skOS55MavRrKp4h32zRK6mL4ToC/tN84T5PuDsSGaGfhq2ZgCsA9F2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620252463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UMR0l2eOxbZlG3eP2GKSR1qj/t2c7J2/JGyBVU+eog8=;
        b=1EBA3+V804rt47qlprd0RUNtZvDTp3gX9e+JSaQkFYVvO9my28iAerpC6JKqTLv3aXw/9Q
        WnPrz1E9oDgXBwBg==
To:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2] io_thread/x86: setup io_threads more like normal user space threads
In-Reply-To: <878s4soncx.ffs@nanos.tec.linutronix.de>
References: <20210411152705.2448053-1-metze@samba.org> <20210505110310.237537-1-metze@samba.org> <df4b116a-3324-87b7-ff40-67d134b4e55c@kernel.dk> <878s4soncx.ffs@nanos.tec.linutronix.de>
Date:   Thu, 06 May 2021 00:07:43 +0200
Message-ID: <875yzwomvk.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 05 2021 at 23:57, Thomas Gleixner wrote:
> On Wed, May 05 2021 at 15:24, Jens Axboe wrote:
>> On 5/5/21 5:03 AM, Stefan Metzmacher wrote:
>>> As io_threads are fully set up USER threads it's clearer to
>>> separate the code path from the KTHREAD logic.
>>> 
>>> The only remaining difference to user space threads is that
>>> io_threads never return to user space again.
>>> Instead they loop within the given worker function.
>>> 
>>> The fact that they never return to user space means they
>>> don't have an user space thread stack. In order to
>>> indicate that to tools like gdb we reset the stack and instruction
>>> pointers to 0.
>>> 
>>> This allows gdb attach to user space processes using io-uring,
>>> which like means that they have io_threads, without printing worrying
>>> message like this:
>>> 
>>>   warning: Selected architecture i386:x86-64 is not compatible with reported target architecture i386
>>> 
>>>   warning: Architecture rejected target-supplied description
>>> 
>>> The output will be something like this:
>>> 
>>>   (gdb) info threads
>>>     Id   Target Id                  Frame
>>>   * 1    LWP 4863 "io_uring-cp-for" syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
>>>     2    LWP 4864 "iou-mgr-4863"    0x0000000000000000 in ?? ()
>>>     3    LWP 4865 "iou-wrk-4863"    0x0000000000000000 in ?? ()
>>>   (gdb) thread 3
>>>   [Switching to thread 3 (LWP 4865)]
>>>   #0  0x0000000000000000 in ?? ()
>>>   (gdb) bt
>>>   #0  0x0000000000000000 in ?? ()
>>>   Backtrace stopped: Cannot access memory at address 0x0
>>
>> I have queued this one up in the io_uring branch, also happy to drop it if
>> the x86 folks want to take it instead. Let me know!
>
> I have no objections, but heck what's the rush here?
>
> Waiting a day for the x86 people to respond it not too much asked for
> right?

That said, the proper subject line would be:

  x86/process: Setup io_threads ....

Aside of that:

      Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
