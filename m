Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1B5390457
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 16:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbhEYOzJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 May 2021 10:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbhEYOzJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 May 2021 10:55:09 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DE8C061574
        for <io-uring@vger.kernel.org>; Tue, 25 May 2021 07:53:38 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id lg14so47750311ejb.9
        for <io-uring@vger.kernel.org>; Tue, 25 May 2021 07:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nu/GHBpjSZqFLQJdrv2WofUEakGX52odyE7jVmGTpWQ=;
        b=c9QvKR2OT26IxxSxa+atw/d+xpWLPFbnoeKFXH3K8Mvfcxt8tUMbT+2tqs8VSSKs7F
         TSSS7PHKhLLCrHf99UhSXPd9mlJvVBoOz41qNw86HnB+nMjXTB6gRyYXVLA8I9Ycs5a7
         ynoYKi/4jkHvqrGSY9M5+xwm9F+P7f2XMOomNXrBQ+F4j3Uz58OKkfEDB+6Yl4nZbd7q
         RNsaWvawcuTrVPiIN/N7KdKK7GnkySLs/LpDurc67rCdJQDjs2RlVJQEy/QIrMYlM3OB
         Gx7QXYRlryExwLR3xXf/5rsLQvDO6CkT/FlSE1YDGXPKcS3VmEcNc1wGgrzntFqzwH70
         ZoAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nu/GHBpjSZqFLQJdrv2WofUEakGX52odyE7jVmGTpWQ=;
        b=n8wBl5L2ENdCDKi0gba3csnK26TiBRYR6iEWj0N0oFSzKu7S22SZg+cMhWS0O+8NC1
         wjFRfpc6+LJ01jwEykgMIwIB5JUZj6bW8FRQpsASDEFC8arghXwLP7j7Cfbz7/0LD3mr
         bIf+jcBuygh6CWEgxOhQnfbYfTMnyJJM0mbSFXhOi6+J8/glHzfkbJB8YlpFhtHcoPDA
         ALfDe48msCPUFM9uppE7VtqwHemGiPq3jQiXtaBjzDpIYcnGN6t9Q2VA2CaewBOP0jrb
         7Kwgka99hBTbRftugstgCG5F3BU4tuMoZKJ0S7vxTZteAhPp5UVsRaBi2kXDooWZXhWt
         /M9w==
X-Gm-Message-State: AOAM531UPsaTPm4SLiANi1rb0tEaglElLaiiwUSzn4fqn4NtT6luJGen
        AxTFxaV6yKl0/BFmbQP19IsIx0ZVQBfDQcgHCNx5
X-Google-Smtp-Source: ABdhPJwkXErdYWtLRoRdThvmdvfiliPdTp4bhmfacT9ChcVlEWEvajLzbaqcInOamF9r7J4ax4pk/cUClWjqd9xalWw=
X-Received: by 2002:a17:907:10d8:: with SMTP id rv24mr28861448ejb.542.1621954416913;
 Tue, 25 May 2021 07:53:36 -0700 (PDT)
MIME-Version: 1.0
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl> <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com> <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <e701511f-520d-4a94-9931-d218b14a80fe@gmail.com>
In-Reply-To: <e701511f-520d-4a94-9931-d218b14a80fe@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 25 May 2021 10:53:25 -0400
Message-ID: <CAHC9VhTS_Yt0PzG_WjsgUA04inHa=N8+OjWju9waefP==Di39A@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 25, 2021 at 4:27 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> On 5/24/21 8:59 PM, Paul Moore wrote:
> > On Sun, May 23, 2021 at 4:26 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >> On 5/22/21 3:36 AM, Paul Moore wrote:
> >>> On Fri, May 21, 2021 at 8:22 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>>> On 5/21/21 10:49 PM, Paul Moore wrote:
> >> [...]
> >>>>>
> >>>>> +     if (req->opcode < IORING_OP_LAST)
> >>>>
> >>>> always true at this point
> >>>
> >>> I placed the opcode check before the audit call because the switch
> >>> statement below which handles the operation dispatching has a 'ret =
> >>> -EINVAL' for the default case, implying that there are some paths
> >>> where an invalid opcode could be passed into the function.  Obviously
> >>> if that is not the case and you can guarantee that req->opcode will
> >>> always be valid we can easily drop the check prior to the audit call.
> >>
> >> It is always true at this point, would be completely broken
> >> otherwise
> >
> > Understood, I was just pointing out an oddity in the code.  I just
> > dropped the checks from my local tree, you'll see it in the next draft
> > of the patchset.
> >
> >>>> So, it adds two if's with memory loads (i.e. current->audit_context)
> >>>> per request in one of the hottest functions here... No way, nack
> >>>>
> >>>> Maybe, if it's dynamically compiled into like kprobes if it's
> >>>> _really_ used.
> >>>
> >>> I'm open to suggestions on how to tweak the io_uring/audit
> >>> integration, if you don't like what I've proposed in this patchset,
> >>> lets try to come up with a solution that is more palatable.  If you
> >>> were going to add audit support for these io_uring operations, how
> >>> would you propose we do it?  Not being able to properly audit io_uring
> >>> operations is going to be a significant issue for a chunk of users, if
> >>> it isn't already, we need to work to find a solution to this problem.
> >>
> >> Who knows. First of all, seems CONFIG_AUDIT is enabled by default
> >> for many popular distributions, so I assume that is not compiled out.
> >>
> >> What are use cases for audit? Always running I guess?
> >
> > Audit has been around for quite some time now, and it's goal is to
> > provide a mechanism for logging "security relevant" information in
> > such a way that it meets the needs of various security certification
> > efforts.  Traditional Linux event logging, e.g. syslog and the like,
> > does not meet these requirements and changing them would likely affect
> > the usability for those who are not required to be compliant with
> > these security certifications.  The Linux audit subsystem allows Linux
> > to be used in places it couldn't be used otherwise (or rather makes it
> > a *lot* easier).
> >
> > That said, audit is not for everyone, and we have build time and
> > runtime options to help make life easier.  Beyond simply disabling
> > audit at compile time a number of Linux distributions effectively
> > shortcut audit at runtime by adding a "never" rule to the audit
> > filter, for example:
> >
> >  % auditctl -a task,never
> >
> >> Putting aside compatibility problems, it sounds that with the amount of overhead
> >> it adds there is no much profit in using io_uring in the first place.
> >> Is that so?
> >
> > Well, if audit alone erased all of the io_uring advantages we should
> > just rip io_uring out of the kernel and people can just disable audit
> > instead ;)
>
> Hah, if we add a simple idle "feature" like
>
> for (i=0;i<1000000;i+) {;}
>
> and it would destroy all the performance, let's throw useless
> Linux kernel then!
>
> If seriously, it's more of an open question to me, how much overhead
> it adds if enabled (with typical filters/options/etc).

I am very hesitant to define a "typical" audit configuration as it
really is dependent on the user's security requirements as well as the
particular solution/environment.  Any configuration I pick will be
"wrong" for a lot of audit users :)

As I see it, users will likely find themselves in one of three
performance buckets:

* io_uring enabled, CONFIG_AUDIT=n

For those who are already trying to get that last 1% of performance
from their kernel and are willing to give up most everything else to
get it this is the obvious choice.  Needless to say there should not
be any audit related impact in this case (especially since we've
removed that req->opcode checks prior to the audit calls).

* io_uring enabled, CONFIG_AUDIT=y, audit "task,never" runtime config

[side note: I made some tweaks to audit_uring_entry() to move the
audit_enabled check there so we no longer need to call into
__audit_uring_entry() in this fastpath case.  Similarly
audit_uring_exit() now does an audit_dummy_context() check instead of
simply checking audit_context(), this should avoid calling into
__audit_uring_exit() when the io_uring op is not being audited.]

I'm guessing that most distro users will fall into this bucket.  Here
the task's audit_context should always be NULL, both in the syscall
context and sqpoll context, so io_uring would call into the inline
audit_uring_entry() function and return without calling into
__audit_uring_entry() (see the "side note" above).  The
audit_uring_exit() call would behave in a similar manner.

* io_uring enabled, CONFIG_AUDIT=y, some sort of runtime audit config

For obvious reasons this case has the most performance impact and as
mentioned above it can vary quite a bit.  In my opinion this is the
least important bucket from a performance perspective as the user
clearly has a need for the security information that audit provides
and enabling that functionality in io_uring is critical to allowing
the user to take advantage of io_uring.  The performance of io_uring
is impacted, but it should still be more performant than synchronous
I/O and it allows the user to run their existing io_uring
applications/code-paths.

> Btw, do you really need two hooks -- before and right after
> execution?

Yes, the entry/before hook does the setup for the io_uring op (very
similar to a syscall entry point) and the exit/after hook is what does
the audit record generation based on what took place during the
io_uring operation.

> > I believe there are people who would like to use io_uring and are also
> > required to use a kernel with audit, either due to the need to run a
> > distribution kernel or the need to capture security information in the
> > audit stream.  I'm hoping that we can find a solution for these users;
> > if we don't we are asking this group to choose either io_uring or
> > audit, and that is something I would like to avoid.

I'm leaving this old paragraph here because I really think this is
important to the discussion.  If we can't find a solution here we
would need to make io_uring and audit mutually exclusive and I don't
think that is in the best interests of the users, and would surely
create a headache for the distros.

-- 
paul moore
www.paul-moore.com
