Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F1F3993C9
	for <lists+io-uring@lfdr.de>; Wed,  2 Jun 2021 21:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhFBTsH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Jun 2021 15:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhFBTsF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Jun 2021 15:48:05 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AEFC061756
        for <io-uring@vger.kernel.org>; Wed,  2 Jun 2021 12:46:21 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b17so4394847ede.0
        for <io-uring@vger.kernel.org>; Wed, 02 Jun 2021 12:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LqoEKJiVAWZlSSI9JgAO1d0PhyXvjYnfYNG32/S+e5M=;
        b=EMhP/o1/rpuV//xhmlzEPw8/EVDK0SFQUUhcfioPAsN846CbLBW+OYC6S0TtOyA4DP
         FQoc7RIEZ5fySWPmQ+1x0gGHcjimL5ZMJKac/EcqA3Z4zueIvP59l+rPEnduGE10lKxF
         0TwDwwYXXAmxS0JZjdNetQ9YUHm1RQBkY3i1fRXYOEFIxB06Met+Ehp5v5bhM+QHKioD
         zs6XsYZyeieLi9zikaOnzNKOcV2ikrCtYtP+E+WHWsoCaTc0myMCTy+/5gaXyp+53GEy
         g4nmpHLHEX3KLyp98x0/yUgMVxjrGL/Xe3uDImW/N3q95rwaIQCgyF5hNXFbAzEoXYPt
         EQjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LqoEKJiVAWZlSSI9JgAO1d0PhyXvjYnfYNG32/S+e5M=;
        b=HxrhV2fQ4caYcX8uSP2d4PNPs9y0+wUK+mFGajmbkum4T+FXsrJhKXxu+bqpSu+xZv
         IRJuLPE+h9a06u2nlX+afFoC1uUJXx1XwCCWd/D4zUi5VBUeJcr5+5ANe1J5cA4JwaHj
         QyLzNsF00rtVV6OfkU4x360qpqyy61rOrcesWRVHVSTU5vb8LFPCYGmydmCNJXM/97Gk
         +Q/+HsWvsH6mguNqnTnKDpxJBa8qbltg/sXqz7AxuF2z3iPIeJcaVRj8K1JAtR4zyl7K
         QI9me0w6QL86hXQyd1OWd2ShUTtjHwgmF+jeJnOlcm9nyK7mitW8K7VLEx1/Ur+U+5Xj
         /kcA==
X-Gm-Message-State: AOAM530Bq8tMRhRyYfBKVjKRpuBWNhpGrS0IcSDBGVqcHLDxyVXR/eip
        00kSEhCJdPC5fXga4Vj4T4OVNs81FH0zvXlJ0Fwr
X-Google-Smtp-Source: ABdhPJyuLy2X/c63hvfm+x3eKVgUZz+1DStQP3zkb//f5hhY17s9fx1FxgbH/tqGdqyXbTZs3U+uNHV5N9KUTgXL4f8=
X-Received: by 2002:a05:6402:35d4:: with SMTP id z20mr40197715edc.164.1622663179644;
 Wed, 02 Jun 2021 12:46:19 -0700 (PDT)
MIME-Version: 1.0
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl> <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com> <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk> <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <9e69e4b6-2b87-a688-d604-c7f70be894f5@kernel.dk> <3bef7c8a-ee70-d91d-74db-367ad0137d00@kernel.dk>
 <fa7bf4a5-5975-3e8c-99b4-c8d54c57da10@kernel.dk> <a7669e4a-e7a7-7e94-f6ce-fa48311f7175@kernel.dk>
 <CAHC9VhSKPzADh=qcPp7r7ZVD2cpr2m8kQsui43LAwPr-9BNaxQ@mail.gmail.com>
 <b20f0373-d597-eb0e-5af3-6dcd8c6ba0dc@kernel.dk> <CAHC9VhRZEwtsxjhpZM1DXGNJ9yL59B7T_p2B60oLmC_YxCrOiw@mail.gmail.com>
 <CAHC9VhSK9PQdxvXuCA2NMC3UUEU=imCz_n7TbWgKj2xB2T=fOQ@mail.gmail.com> <94e50554-f71a-50ab-c468-418863d2b46f@gmail.com>
In-Reply-To: <94e50554-f71a-50ab-c468-418863d2b46f@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 2 Jun 2021 15:46:08 -0400
Message-ID: <CAHC9VhS7Vhby4YR94U2YOwMtva-rc=_ifRcZYi1YVPwfi+Xuzg@mail.gmail.com>
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

On Wed, Jun 2, 2021 at 4:27 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> On 5/28/21 5:02 PM, Paul Moore wrote:
> > On Wed, May 26, 2021 at 4:19 PM Paul Moore <paul@paul-moore.com> wrote:
> >> ... If we moved the _entry
> >> and _exit calls into the individual operation case blocks (quick
> >> openat example below) so that only certain operations were able to be
> >> audited would that be acceptable assuming the high frequency ops were
> >> untouched?  My initial gut feeling was that this would involve >50% of
> >> the ops, but Steve Grubb seems to think it would be less; it may be
> >> time to look at that a bit more seriously, but if it gets a NACK
> >> regardless it isn't worth the time - thoughts?
> >>
> >>   case IORING_OP_OPENAT:
> >>     audit_uring_entry(req->opcode);
> >>     ret = io_openat(req, issue_flags);
> >>     audit_uring_exit(!ret, ret);
> >>     break;
> >
> > I wanted to pose this question again in case it was lost in the
> > thread, I suspect this may be the last option before we have to "fix"
> > things at the Kconfig level.  I definitely don't want to have to go
> > that route, and I suspect most everyone on this thread feels the same,
> > so I'm hopeful we can find a solution that is begrudgingly acceptable
> > to both groups.
>
> May work for me, but have to ask how many, and what is the
> criteria? I'd think anything opening a file or manipulating fs:
>
> IORING_OP_ACCEPT, IORING_OP_CONNECT, IORING_OP_OPENAT[2],
> IORING_OP_RENAMEAT, IORING_OP_UNLINKAT, IORING_OP_SHUTDOWN,
> IORING_OP_FILES_UPDATE
> + coming mkdirat and others.
>
> IORING_OP_CLOSE? IORING_OP_SEND IORING_OP_RECV?
>
> What about?
> IORING_OP_FSYNC, IORING_OP_SYNC_FILE_RANGE,
> IORING_OP_FALLOCATE, IORING_OP_STATX,
> IORING_OP_FADVISE, IORING_OP_MADVISE,
> IORING_OP_EPOLL_CTL

Looking quickly at v5.13-rc4 the following seems like candidates for
auditing, there may be a small number of subtractions/additions to
this list as people take a closer look, but it should serve as a
starting point:

IORING_OP_SENDMSG
IORING_OP_RECVMSG
IORING_OP_ACCEPT
IORING_OP_CONNECT
IORING_OP_FALLOCATE
IORING_OP_OPENAT
IORING_OP_CLOSE
IORING_OP_MADVISE
IORING_OP_OPENAT2
IORING_OP_SHUTDOWN
IORING_OP_RENAMEAT
IORING_OP_UNLINKAT

... can you live with that list?

> Another question, io_uring may exercise asynchronous paths,
> i.e. io_issue_sqe() returns before requests completes.
> Shouldn't be the case for open/etc at the moment, but was that
> considered?

Yes, I noticed that when testing the code (and it makes sense when you
look at how io_uring handles things).  Depending on the state of the
system when the io_uring request is submitted I've seen both sync and
async io_uring operations with the associated different calling
contexts.  In the case where io_issue_sqe() needs to defer the
operation to a different context you will see an audit record
indicating that the operation failed and then another audit record
when it completes; it's actually pretty interesting to be able to see
how the system and io_uring are working.

We could always mask out these delayed attempts, but at this early
stage they are helpful, and they may be useful for admins.

> I don't see it happening, but would prefer to keep it open
> async reimplementation in a distant future. Does audit sleep?

The only place in the audit_uring_entry()/audit_uring_exit() code path
that could sleep at present is the call to audit_log_uring() which is
made when the rules dictate that an audit record be generated.  The
offending code is an allocation in audit_log_uring() which is
currently GFP_KERNEL but really should be GFP_ATOMIC, or similar.  It
was a copy-n-paste from the similar syscall function where GFP_KERNEL
is appropriate due to the calling context at the end of the syscall.
I'll change that as soon as I'm done with this email.

Of course if you are calling io_uring_enter(2), or something similar,
then audit may sleep as part of the normal syscall processing (as
mentioned above), but that is due to the fact that io_uring_enter(2)
is a syscall and not because of anything in io_issue_sqe().

-- 
paul moore
www.paul-moore.com
