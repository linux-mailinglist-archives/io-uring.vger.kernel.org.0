Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A575635182B
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbhDARoO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234574AbhDARiF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:38:05 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB4CC02FE94;
        Thu,  1 Apr 2021 09:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=m/fhQBoIS2Ry4FN35jTMDrpVXQElvBfJuR2zw8YjBR8=; b=rjM/JiaSCTDtwzRn1bvABQ1ETe
        ESRd9Axo3R60B+iHazD05eaRpyJagq1NfzDf1+A3kZJBP7tDY33G9L0KtQz78lnyfCeVWizBZk0Y+
        L1GPrVCHtHWPRJOi6+7pGZdCQhlBgYdDq9Z7BuVwIBOMK7GkLZiznxtR2G4aPPCwHzrhTmRrxujWO
        XMhmTpPC2LKD8FnU8Q1jn6BkU8qjTyYqdNFLLk0fD7nwXUdDQ8qTZrfBpKVxXaRY7fSRJiNAUFA0S
        eSJCmLldPegdfFcRVYBQYOYmH9n0khNekPsLqstFxpxohWyj+hEGDBm6QQ10JGCtAtZ/opQGojC5N
        UXssgbHlMBR4T7I7fy68avXlhlHnyArnMuOee3LQKmjCo6SSDnHvoogfVCjxXY/+1stFrcN/dvBb6
        TGhq6M9viPslWohIqtZpsEnu9zUaI2/wX6IpDa95Q9quzetuDIgNL1o22rC6iz1+mzu1UmxoUEBqj
        o7I+cLYX+oSeRdjLQmV3LSdU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lRzkW-00080B-18; Thu, 01 Apr 2021 16:00:48 +0000
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
 <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
 <358c5225-c23f-de08-65cb-ca3349793c0e@samba.org>
 <5bb47c3a-2990-e4c4-69c6-1b5d1749a241@samba.org>
 <CAHk-=whEObPkZBe4766DmR46-=5QTUiatWbSOaD468eTgYc1tg@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 0/6] Allow signals for IO threads
Message-ID: <2d8a73ef-2f18-6872-bad1-a34deb20f641@samba.org>
Date:   Thu, 1 Apr 2021 18:00:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAHk-=whEObPkZBe4766DmR46-=5QTUiatWbSOaD468eTgYc1tg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 01.04.21 um 17:39 schrieb Linus Torvalds:
> On Thu, Apr 1, 2021 at 7:58 AM Stefan Metzmacher <metze@samba.org> wrote:
>>
>>>
>>> Ok, the following makes gdb happy again:
>>>
>>> --- a/arch/x86/kernel/process.c
>>> +++ b/arch/x86/kernel/process.c
>>> @@ -163,6 +163,8 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
>>>         /* Kernel thread ? */
>>>         if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>>>                 memset(childregs, 0, sizeof(struct pt_regs));
>>> +               if (p->flags & PF_IO_WORKER)
>>> +                       childregs->cs = current_pt_regs()->cs;
>>>                 kthread_frame_init(frame, sp, arg);
>>>                 return 0;
>>>         }
>>
>> Would it be possible to fix this remaining problem before 5.12 final?
> 
> Please not that way.
> 
> But doing something like
> 
>         childregs->cs = __USER_CS;
>         childregs->ss = __USER_DS;
>         childregs->ds = __USER_DS;
>         childregs->es = __USER_DS;
> 
> might make sense (just do it unconditionally, rather than making it
> special to PF_IO_WORKER).
> 
> Does that make gdb happy too?

I haven't tried it, but it seems gdb tries to use PTRACE_PEEKUSR
against the last thread tid listed under /proc/<pid>/tasks/ in order to
get the architecture for the userspace application, so my naive assumption
would be that it wouldn't allow the detection of a 32-bit application
using a 64-bit kernel.

metze
