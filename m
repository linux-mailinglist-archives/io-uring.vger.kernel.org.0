Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADB2392095
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 21:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhEZTLz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 15:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbhEZTLx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 15:11:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120B6C061760
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 12:10:20 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y7so2856963eda.2
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 12:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+eZ8wRfiyLlH3ilFo/PCrE+00rbBTnqHgmAoOKQiukI=;
        b=wfxDILfQbXUke1pK/1yMJqcB/GDZ4hVgpuKlzQDJe+tosiJqp9OqdD/0Y7qE1v5K0+
         Q+kuGokdWTSM5nC73vz9ZOHQNSY7svMAd2HL6L9uJ+GLRMWEtF8rnIRcideaqkuxIN4I
         OyWBPM0H0MPXuSEDXejoJG4sOmVHqklD2PdY4Xokzc0uDEV9rWEjtY90gW6a68p77HR6
         TMxQA9w0csQ/u8jSOZGW/ALtIc06FpF0wwSdKjTvlAM4cuRal0EK0sl3Yeomc5x68Nox
         wfcWx/ZydFHHJ3jNeAasY86qn5XX2orTRwFonF8DkW5U5Wa3iMgxpZSu0NOhG08fgx8k
         9R/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+eZ8wRfiyLlH3ilFo/PCrE+00rbBTnqHgmAoOKQiukI=;
        b=GNq/FqLDIf4UwUV0wVKbrwNkHxOf2W9552NlVOF1kSSi3lqSyH+qRplwgKNk4gDQDb
         PyKNPVdIn1YXhAuoLqgLS4hk/npTK7CUgPYmqE9AzPnIt3+VDYAf++56r707klcTGfrp
         +i6Ov3TcIQWIITVV6V0sohBhVLlsavYv8OBgIac5J5fW1s2jSeDsydn3l7WzVm/uC5AS
         oTPzW4kKXnNIWzcHbrXNNG57yd3CHJbNsvRwriAetklmiOkdeTjPAiQ14/2pYz7/jb28
         6dJqaYwXrb8LJApembKnYm0zNv36Cfnf3b0nbIwpFTg/GcXHDhMEtWKjIn3uUbnKfQFG
         xbog==
X-Gm-Message-State: AOAM530BlMN8cpbFFwXhIDJUKFueaIvqijP5ZoMEE4IsXWEBL8CF/aLS
        8VIQwskVUrXTnEABQlQUesw5vD36alHbheUUB6tl
X-Google-Smtp-Source: ABdhPJxcSpVv9HmHaO8wWnezfmJ5wJz+SLYtjyQCEVJTQuLOTM1DL3x23uy6+LsMdvC7TlQRfBqtJFiubAUvvxwVwvk=
X-Received: by 2002:a05:6402:430b:: with SMTP id m11mr21422243edc.31.1622056218965;
 Wed, 26 May 2021 12:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl> <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com> <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk> <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <9e69e4b6-2b87-a688-d604-c7f70be894f5@kernel.dk> <3bef7c8a-ee70-d91d-74db-367ad0137d00@kernel.dk>
 <fa7bf4a5-5975-3e8c-99b4-c8d54c57da10@kernel.dk> <a7669e4a-e7a7-7e94-f6ce-fa48311f7175@kernel.dk>
 <CAHC9VhSKPzADh=qcPp7r7ZVD2cpr2m8kQsui43LAwPr-9BNaxQ@mail.gmail.com> <45688a09-7489-f524-e5ac-e614437f08ea@gmail.com>
In-Reply-To: <45688a09-7489-f524-e5ac-e614437f08ea@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 26 May 2021 15:10:07 -0400
Message-ID: <CAHC9VhSf8EpQQfSmO9CFdKdx7QC=r1bC+nXDQbru=ELwAKhnrQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 26, 2021 at 2:57 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> On 5/26/21 7:44 PM, Paul Moore wrote:
> > On Wed, May 26, 2021 at 2:01 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 5/26/21 11:54 AM, Jens Axboe wrote:
> >>> On 5/26/21 11:31 AM, Jens Axboe wrote:
> >>>> On 5/26/21 11:15 AM, Jens Axboe wrote:
> >>>>> On 5/25/21 8:04 PM, Paul Moore wrote:
> >>>>>> On Tue, May 25, 2021 at 9:11 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>>> On 5/24/21 1:59 PM, Paul Moore wrote:
> >>>>>>>> That said, audit is not for everyone, and we have build time and
> >>>>>>>> runtime options to help make life easier.  Beyond simply disabling
> >>>>>>>> audit at compile time a number of Linux distributions effectively
> >>>>>>>> shortcut audit at runtime by adding a "never" rule to the audit
> >>>>>>>> filter, for example:
> >>>>>>>>
> >>>>>>>>  % auditctl -a task,never
> >>>>>>>
> >>>>>>> As has been brought up, the issue we're facing is that distros have
> >>>>>>> CONFIG_AUDIT=y and hence the above is the best real world case outside
> >>>>>>> of people doing custom kernels. My question would then be how much
> >>>>>>> overhead the above will add, considering it's an entry/exit call per op.
> >>>>>>> If auditctl is turned off, what is the expectation in turns of overhead?
> >>>>>>
> >>>>>> I commented on that case in my last email to Pavel, but I'll try to go
> >>>>>> over it again in a little more detail.
> >>>>>>
> >>>>>> As we discussed earlier in this thread, we can skip the req->opcode
> >>>>>> check before both the _entry and _exit calls, so we are left with just
> >>>>>> the bare audit calls in the io_uring code.  As the _entry and _exit
> >>>>>> functions are small, I've copied them and their supporting functions
> >>>>>> below and I'll try to explain what would happen in CONFIG_AUDIT=y,
> >>>>>> "task,never" case.
> >>>>>>
> >>>>>> +  static inline struct audit_context *audit_context(void)
> >>>>>> +  {
> >>>>>> +    return current->audit_context;
> >>>>>> +  }
> >>>>>>
> >>>>>> +  static inline bool audit_dummy_context(void)
> >>>>>> +  {
> >>>>>> +    void *p = audit_context();
> >>>>>> +    return !p || *(int *)p;
> >>>>>> +  }
> >>>>>>
> >>>>>> +  static inline void audit_uring_entry(u8 op)
> >>>>>> +  {
> >>>>>> +    if (unlikely(audit_enabled && audit_context()))
> >>>>>> +      __audit_uring_entry(op);
> >>>>>> +  }
> >>>>>>
> >>>>>> We have one if statement where the conditional checks on two
> >>>>>> individual conditions.  The first (audit_enabled) is simply a check to
> >>>>>> see if anyone has "turned on" auditing at runtime; historically this
> >>>>>> worked rather well, and still does in a number of places, but ever
> >>>>>> since systemd has taken to forcing audit on regardless of the admin's
> >>>>>> audit configuration it is less useful.  The second (audit_context())
> >>>>>> is a check to see if an audit_context has been allocated for the
> >>>>>> current task.  In the case of "task,never" current->audit_context will
> >>>>>> be NULL (see audit_alloc()) and the __audit_uring_entry() slowpath
> >>>>>> will never be called.
> >>>>>>
> >>>>>> Worst case here is checking the value of audit_enabled and
> >>>>>> current->audit_context.  Depending on which you think is more likely
> >>>>>> we can change the order of the check so that the
> >>>>>> current->audit_context check is first if you feel that is more likely
> >>>>>> to be NULL than audit_enabled is to be false (it may be that way now).
> >>>>>>
> >>>>>> +  static inline void audit_uring_exit(int success, long code)
> >>>>>> +  {
> >>>>>> +    if (unlikely(!audit_dummy_context()))
> >>>>>> +      __audit_uring_exit(success, code);
> >>>>>> +  }
> >>>>>>
> >>>>>> The exit call is very similar to the entry call, but in the
> >>>>>> "task,never" case it is very simple as the first check to be performed
> >>>>>> is the current->audit_context check which we know to be NULL.  The
> >>>>>> __audit_uring_exit() slowpath will never be called.
> >>>>>
> >>>>> I actually ran some numbers this morning. The test base is 5.13+, and
> >>>>> CONFIG_AUDIT=y and CONFIG_AUDITSYSCALL=y is set for both the baseline
> >>>>> test and the test with this series applied. I used your git branch as of
> >>>>> this morning.
> >>>>>
> >>>>> The test case is my usual peak perf test, which is random reads at
> >>>>> QD=128 and using polled IO. It's a single core test, not threaded. I ran
> >>>>> two different tests - one was having a thread just do the IO, the other
> >>>>> is using SQPOLL to do the IO for us. The device is capable than more
> >>>>> IOPS than a single core can deliver, so we're CPU limited in this test.
> >>>>> Hence it's a good test case as it does actual work, and shows software
> >>>>> overhead quite nicely. Runs are very stable (less than 0.5% difference
> >>>>> between runs on the same base), yet I did average 4 runs.
> >>>>>
> >>>>> Kernel              SQPOLL          IOPS            Perf diff
> >>>>> ---------------------------------------------------------
> >>>>> 5.13                0               3029872         0.0%
> >>>>> 5.13                1               3031056         0.0%
> >>>>> 5.13 + audit        0               2894160         -4.5%
> >>>>> 5.13 + audit        1               2886168         -4.8%
> >>>>>
> >>>>> That's an immediate drop in perf of almost 5%. Looking at a quick
> >>>>> profile of it (nothing fancy, just checking for 'audit' in the profile)
> >>>>> shows this:
> >>>>>
> >>>>> +    2.17%  io_uring  [kernel.vmlinux]  [k] __audit_uring_entry
> >>>>> +    0.71%  io_uring  [kernel.vmlinux]  [k] __audit_uring_exit
> >>>>>      0.07%  io_uring  [kernel.vmlinux]  [k] __audit_syscall_entry
> >>>>>      0.02%  io_uring  [kernel.vmlinux]  [k] __audit_syscall_exit
> >>>>>
> >>>>> Note that this is with _no_ rules!
> >>>>
> >>>> io_uring also supports a NOP command, which basically just measures
> >>>> reqs/sec through the interface. Ran that as well:
> >>>>
> >>>> Kernel               SQPOLL          IOPS            Perf diff
> >>>> ---------------------------------------------------------
> >>>> 5.13         0               31.05M          0.0%
> >>>> 5.13 + audit 0               25.31M          -18.5%
> >>>>
> >>>> and profile for the latter includes:
> >>>>
> >>>> +    5.19%  io_uring  [kernel.vmlinux]  [k] __audit_uring_entry
> >>>> +    4.31%  io_uring  [kernel.vmlinux]  [k] __audit_uring_exit
> >>>>      0.26%  io_uring  [kernel.vmlinux]  [k] __audit_syscall_entry
> >>>>      0.08%  io_uring  [kernel.vmlinux]  [k] __audit_syscall_exit
> >>>
> >>> As Pavel correctly pointed it, looks like auditing is enabled. And
> >>> indeed it was! Hence the above numbers is without having turned off
> >>> auditing. Running the NOPs after having turned off audit, we get 30.6M
> >>> IOPS, which is down about 1.5% from the baseline. The results for the
> >>> polled random read test above did _not_ change from this, they are still
> >>> down the same amount.
> >>>
> >>> Note, and I should have included this in the first email, this is not
> >>> any kind of argument for or against audit logging. It's purely meant to
> >>> be a set of numbers that show how the current series impacts
> >>> performance.
> >>
> >> And finally, just checking if we make it optional per opcode if we see
> >> any real impact, and the answer is no. Using the below patch which
> >> effectively bypasses audit calls unless the opcode has flagged the need
> >> to do so, I cannot measure any difference in perf (as expected).
> >>
> >> To turn this into something useful, my suggestion as a viable path
> >> forward would be:
> >>
> >> 1) Use something like the below patch and flag request types that we
> >>    want to do audit logging for.
> >>
> >> 2) As Pavel suggested, eliminate the need for having both and entry/exit
> >>    hook, turning it into just one. That effectively cuts the number of
> >>    checks and calls in half.
> >
> > I suspect the updated working-io_uring branch with HEAD at
> > 1f25193a3f54 (updated a short time ago, see my last email in this
> > thread) will improve performance.  Also, as has been mention several
>
> See the email you replied to, ~1.5% was basically an overhead of
> two `if (io_op_defs[req->opcode].audit)` in case of nops, where at
> least once req->opcode is cached. But to be completely fair, misses
> unlikely

Maybe.  I remain skeptical that "io_op_defs[req->opcode].audit" has
the same cost as "unlikely(audit_context())".

-- 
paul moore
www.paul-moore.com
