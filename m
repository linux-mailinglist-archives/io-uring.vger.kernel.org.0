Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AABE5391F49
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 20:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhEZSkU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 14:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbhEZSkU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 14:40:20 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3B9C061760
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 11:38:48 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r11so2670307edt.13
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 11:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JT8Fqetgqyw+ipNDsAHuacTfJGheE97tZL8tcEa0PmQ=;
        b=YnNaTlOPY+mMsF//8jmbs83anFFdSxVWJqw8WJp6bO1ot5yhPGulGUGvY0X1kN21KA
         56of5JrnItJJL9slZ4SaNi2OxEZzM1x+2JV7AeG3w/zI1lvEpoZvOpwusoTGKBTKAxIv
         JjnyZSvsV3aRx93FZC7jHtsmhWAaZi1BuccJ2k9NFJC0BIPJ1Vqpnwdq+VHsCAyozi0r
         1Nqm0NyFUVLVI8YFIcwTKfsFVASEp0B4BAGwvqRBsqigRa92HYoXESHRyGIGD/tg0uhG
         WoSmiyzt13+j8XBOj/FI8WFDhLn0zeRV8H83S+mnS0Yj4MchyhFeJYysIw9PAtVq1Ngg
         u78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JT8Fqetgqyw+ipNDsAHuacTfJGheE97tZL8tcEa0PmQ=;
        b=aKVUwDv/sP7rZDV89diSCCWJJ6/pT2MZW7whxMtyukA7ZSJ3/FgZtI+s1uWu4R4xbA
         3gvgVPM9nh2Zzx3PFW8pga4tzU6dOc3stsQ+2GJ7mB+2XTZiIeMQHJhTjlE7zduKqhTB
         UmlSakEtSJyWIG0N9/zbTAT89Gx2PQgZyREOe5D7t9CRHKOfLAXwtJX8D2qmEUrLWqT2
         YyH/UQPeh8ODBKrTKBmOrTLoVE+rosMcNsfdAIbKcaHDwGp38I0d0wFlD8WcoMqpHfEi
         TZED/ccpwlYLfhfoOyV4C8CP12zYiGoXg0162G02iN+VpneV3Bg907CwAr3LPEU0qbKY
         pcdg==
X-Gm-Message-State: AOAM5306lZKYaXkG4Bm0AyyYuZvi2vf5s2LA2YOMAqAI3JhwoX1Gm0qw
        TaZm9qbA5EXYSHiu+CAnSzGnnTToDOpw4yc4i1uS
X-Google-Smtp-Source: ABdhPJyNjBPmgQgoTsZ8QtYyRyD8w6QmDCwng3q8iPdoe92YxcRxRmyWOMeJNTgXjePWKiXoQKXTacvvSFzlo7E3eUM=
X-Received: by 2002:aa7:cb48:: with SMTP id w8mr39360805edt.12.1622054326360;
 Wed, 26 May 2021 11:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl> <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com> <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk> <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <9e69e4b6-2b87-a688-d604-c7f70be894f5@kernel.dk> <3bef7c8a-ee70-d91d-74db-367ad0137d00@kernel.dk>
 <fa7bf4a5-5975-3e8c-99b4-c8d54c57da10@kernel.dk>
In-Reply-To: <fa7bf4a5-5975-3e8c-99b4-c8d54c57da10@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 26 May 2021 14:38:35 -0400
Message-ID: <CAHC9VhRiDJpf2UaTyDZgU_TOM5Fv5Vziq14uoJyKRBnWYOD0dw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 26, 2021 at 1:54 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 5/26/21 11:31 AM, Jens Axboe wrote:
> > On 5/26/21 11:15 AM, Jens Axboe wrote:
> >> On 5/25/21 8:04 PM, Paul Moore wrote:
> >>> On Tue, May 25, 2021 at 9:11 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> On 5/24/21 1:59 PM, Paul Moore wrote:
> >>>>> That said, audit is not for everyone, and we have build time and
> >>>>> runtime options to help make life easier.  Beyond simply disabling
> >>>>> audit at compile time a number of Linux distributions effectively
> >>>>> shortcut audit at runtime by adding a "never" rule to the audit
> >>>>> filter, for example:
> >>>>>
> >>>>>  % auditctl -a task,never
> >>>>
> >>>> As has been brought up, the issue we're facing is that distros have
> >>>> CONFIG_AUDIT=y and hence the above is the best real world case outside
> >>>> of people doing custom kernels. My question would then be how much
> >>>> overhead the above will add, considering it's an entry/exit call per op.
> >>>> If auditctl is turned off, what is the expectation in turns of overhead?
> >>>
> >>> I commented on that case in my last email to Pavel, but I'll try to go
> >>> over it again in a little more detail.
> >>>
> >>> As we discussed earlier in this thread, we can skip the req->opcode
> >>> check before both the _entry and _exit calls, so we are left with just
> >>> the bare audit calls in the io_uring code.  As the _entry and _exit
> >>> functions are small, I've copied them and their supporting functions
> >>> below and I'll try to explain what would happen in CONFIG_AUDIT=y,
> >>> "task,never" case.
> >>>
> >>> +  static inline struct audit_context *audit_context(void)
> >>> +  {
> >>> +    return current->audit_context;
> >>> +  }
> >>>
> >>> +  static inline bool audit_dummy_context(void)
> >>> +  {
> >>> +    void *p = audit_context();
> >>> +    return !p || *(int *)p;
> >>> +  }
> >>>
> >>> +  static inline void audit_uring_entry(u8 op)
> >>> +  {
> >>> +    if (unlikely(audit_enabled && audit_context()))
> >>> +      __audit_uring_entry(op);
> >>> +  }
> >>>
> >>> We have one if statement where the conditional checks on two
> >>> individual conditions.  The first (audit_enabled) is simply a check to
> >>> see if anyone has "turned on" auditing at runtime; historically this
> >>> worked rather well, and still does in a number of places, but ever
> >>> since systemd has taken to forcing audit on regardless of the admin's
> >>> audit configuration it is less useful.  The second (audit_context())
> >>> is a check to see if an audit_context has been allocated for the
> >>> current task.  In the case of "task,never" current->audit_context will
> >>> be NULL (see audit_alloc()) and the __audit_uring_entry() slowpath
> >>> will never be called.
> >>>
> >>> Worst case here is checking the value of audit_enabled and
> >>> current->audit_context.  Depending on which you think is more likely
> >>> we can change the order of the check so that the
> >>> current->audit_context check is first if you feel that is more likely
> >>> to be NULL than audit_enabled is to be false (it may be that way now).
> >>>
> >>> +  static inline void audit_uring_exit(int success, long code)
> >>> +  {
> >>> +    if (unlikely(!audit_dummy_context()))
> >>> +      __audit_uring_exit(success, code);
> >>> +  }
> >>>
> >>> The exit call is very similar to the entry call, but in the
> >>> "task,never" case it is very simple as the first check to be performed
> >>> is the current->audit_context check which we know to be NULL.  The
> >>> __audit_uring_exit() slowpath will never be called.
> >>
> >> I actually ran some numbers this morning. The test base is 5.13+, and
> >> CONFIG_AUDIT=y and CONFIG_AUDITSYSCALL=y is set for both the baseline
> >> test and the test with this series applied. I used your git branch as of
> >> this morning.
> >>
> >> The test case is my usual peak perf test, which is random reads at
> >> QD=128 and using polled IO. It's a single core test, not threaded. I ran
> >> two different tests - one was having a thread just do the IO, the other
> >> is using SQPOLL to do the IO for us. The device is capable than more
> >> IOPS than a single core can deliver, so we're CPU limited in this test.
> >> Hence it's a good test case as it does actual work, and shows software
> >> overhead quite nicely. Runs are very stable (less than 0.5% difference
> >> between runs on the same base), yet I did average 4 runs.
> >>
> >> Kernel               SQPOLL          IOPS            Perf diff
> >> ---------------------------------------------------------
> >> 5.13         0               3029872         0.0%
> >> 5.13         1               3031056         0.0%
> >> 5.13 + audit 0               2894160         -4.5%
> >> 5.13 + audit 1               2886168         -4.8%
> >>
> >> That's an immediate drop in perf of almost 5%. Looking at a quick
> >> profile of it (nothing fancy, just checking for 'audit' in the profile)
> >> shows this:
> >>
> >> +    2.17%  io_uring  [kernel.vmlinux]  [k] __audit_uring_entry
> >> +    0.71%  io_uring  [kernel.vmlinux]  [k] __audit_uring_exit
> >>      0.07%  io_uring  [kernel.vmlinux]  [k] __audit_syscall_entry
> >>      0.02%  io_uring  [kernel.vmlinux]  [k] __audit_syscall_exit
> >>
> >> Note that this is with _no_ rules!
> >
> > io_uring also supports a NOP command, which basically just measures
> > reqs/sec through the interface. Ran that as well:
> >
> > Kernel                SQPOLL          IOPS            Perf diff
> > ---------------------------------------------------------
> > 5.13          0               31.05M          0.0%
> > 5.13 + audit  0               25.31M          -18.5%
> >
> > and profile for the latter includes:
> >
> > +    5.19%  io_uring  [kernel.vmlinux]  [k] __audit_uring_entry
> > +    4.31%  io_uring  [kernel.vmlinux]  [k] __audit_uring_exit
> >      0.26%  io_uring  [kernel.vmlinux]  [k] __audit_syscall_entry
> >      0.08%  io_uring  [kernel.vmlinux]  [k] __audit_syscall_exit
>
> As Pavel correctly pointed it, looks like auditing is enabled. And
> indeed it was! Hence the above numbers is without having turned off
> auditing. Running the NOPs after having turned off audit, we get 30.6M
> IOPS, which is down about 1.5% from the baseline. The results for the
> polled random read test above did _not_ change from this, they are still
> down the same amount.
>
> Note, and I should have included this in the first email, this is not
> any kind of argument for or against audit logging. It's purely meant to
> be a set of numbers that show how the current series impacts
> performance.

Thanks for running some tests Jens, unfortunately the git tree hadn't
been updated to reflect the improved audit_uring_entry() and
audit_uring_exit() functions as we were still discussing things and I
thought there still might be some changes.  I just now updated the
branch with the latest code so if you have the cycles (ha!) to run
another perf test I think those numbers would be more interesting.
For example, I don't believe you should see __audit_uring_entry() or
__audit_uring_exit() at all if you have the audit "task,never" rule
loaded; you will see audit_uring_entry() and audit_uring_exit() but as
we discussed previously those should just be a single
"current->audit_context != NULL" check.

Also, I want to pull back a bit as I think there is confusion about
how audit works and why these changes are necessary.  As everyone
likely knows, there are audit calls sprinkled throughout the kernel
code, e.g. audit_log_format() and similar.  In addition to these calls
that most are aware of, there are setup/teardown audit calls that run
at task creation and destruction as well as at syscall entry and exit.
It is these lesser known calls that are responsible for the filtering,
setup, and general management of the audit context state in the
system; they also handle generation of some audit records such as
SYSCALL, PATH, etc. based on information that is recorded by audit
calls inserted into other places in the kernel.  The
audit_alloc_kernel() and audit_free() calls we are adding to the
io_uring/io-wq code are intended to do similar things to the existing
audit task creation/destruction hooks, but for the io_uring/io-wq
kernel threads.  Similarly the audit_uring_entry() and
audit_uring_exit() calls are intended to act as replacements for the
syscall entry and exit code.  If we want the existing audit calls in
the kernel to work properly, we need these setup/teardown functions.

Hopefully that makes things a bit more clear regarding these calls in
the io_uring/io-wq code.

Another point I wanted to address is the "double audit" (!!!) that has
been mentioned recently in this thread.  Don't get too excited, this
isn't quite what you think it is, it is a side effect of how io_uring
can dispatch certain operations.  As I think the io_uring folks
already know, io_uring can process I/O ops in several different
contexts; one of which is after a syscall completes but before the
kernel returns to userspace.  In this particular case things can get
rather interesting from an audit perspective as we need to handle both
the syscall audit records *and* the io_uring operation records.  If
you look closer at the audit code in this patchset you'll see some of
the fun stuff we need to do to make sure this case is handled
correctly.  If you happen to see a code path that takes you through
audit_syscall_entry() + <syscall_stuff> + audit_uring_entry() +
<io_uring_stuff> + audit_uring_exit() + audit_syscall_exit() rest
assured that is correct :)

Of course there is the normal audit_uring_entry() and
audit_uring_exit() without the audit syscall hooks in other code
paths, e.g. SQPOLL, but those are less dramatic than the "OMG, double
audit!!!" ;)

-- 
paul moore
www.paul-moore.com
