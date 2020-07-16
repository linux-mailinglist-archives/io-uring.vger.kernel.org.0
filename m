Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3D0222837
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 18:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgGPQZE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 12:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbgGPQZD (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 16 Jul 2020 12:25:03 -0400
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCEEB2074B
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 16:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594916703;
        bh=p0w3EEAD5X53cCqDFmoE6un1clNbYGiJ/DMa0RV+rfI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=yAj2KihHyUS0XU5c+XLdrccZniFtQURmn47hIVuaqVi7YwvUC5wy5/LPReb0zG2y8
         yTIznCUpNbfm02LXaUfrNi1/9wl1N4UBhZMLYNgTGx8avENMAwoHR9RFT0K8QqQ49h
         gVfqvEJ33BZMt5jmgooHcFZaPFk36MTqZP86z1JQ=
Received: by mail-wm1-f47.google.com with SMTP id q15so10856531wmj.2
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 09:25:02 -0700 (PDT)
X-Gm-Message-State: AOAM531OB8rdE03xuQWGy2JiN7v8qZU7Ya1aUCjXNEFt3+cWD2tIyp0Z
        1thOMDPiDPpI4qsEKAzz4253WjtUGs54qmKmIQ2qKg==
X-Google-Smtp-Source: ABdhPJx4aHgQedBYAiS/i+maR6+HLKjkrpnmZif6PsbomewsecKvhVh0PDhmC4WGpinWqQzmno1SRYT3WT0rxEG8RsY=
X-Received: by 2002:a7b:c09a:: with SMTP id r26mr4960600wmh.176.1594916701395;
 Thu, 16 Jul 2020 09:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegu3EwbBFTSJiPhm7eMyTK2MzijLUp1gcboOo3meMF_+Qg@mail.gmail.com>
 <D9FAB37B-D059-4137-A115-616237D78640@amacapital.net> <20200715171130.GG12769@casper.infradead.org>
 <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com> <CAJfpegt9=p4uo5U2GXqc-rwqOESzZCWAkGMRTY1r8H6fuXx96g@mail.gmail.com>
 <48cc7eea-5b28-a584-a66c-4eed3fac5e76@gmail.com> <202007151511.2AA7718@keescook>
In-Reply-To: <202007151511.2AA7718@keescook>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 16 Jul 2020 09:24:48 -0700
X-Gmail-Original-Message-ID: <CALCETrVD1hTc5QDL5=DNkLSS5Qu_AuEC-QZQAuZY0tCP1giMwQ@mail.gmail.com>
Message-ID: <CALCETrVD1hTc5QDL5=DNkLSS5Qu_AuEC-QZQAuZY0tCP1giMwQ@mail.gmail.com>
Subject: Re: strace of io_uring events?
To:     Kees Cook <keescook@chromium.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Matthew Wilcox <willy@infradead.org>,
        Jann Horn <jannh@google.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        strace-devel@lists.strace.io, io-uring@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On Jul 15, 2020, at 4:07 PM, Kees Cook <keescook@chromium.org> wrote:
>
> =EF=BB=BFEarlier Andy Lutomirski wrote:
>> Let=E2=80=99s add some seccomp folks. We probably also want to be able t=
o run
>> seccomp-like filters on io_uring requests. So maybe io_uring should call=
 into
>> seccomp-and-tracing code for each action.
>
> Okay, I'm finally able to spend time looking at this. And thank you to
> the many people that CCed me into this and earlier discussions (at least
> Jann, Christian, and Andy).
>
> It *seems* like there is a really clean mapping of SQE OPs to syscalls.
> To that end, yes, it should be trivial to add ptrace and seccomp support
> (sort of). The trouble comes for doing _interception_, which is how both
> ptrace and seccomp are designed.
>
> In the basic case of seccomp, various syscalls are just being checked
> for accept/reject. It seems like that would be easy to wire up. For the
> more ptrace-y things (SECCOMP_RET_TRAP, SECCOMP_RET_USER_NOTIF, etc),
> I think any such results would need to be "upgraded" to "reject". Things
> are a bit complex in that seccomp's form of "reject" can be "return
> errno" (easy) or it can be "kill thread (or thread_group)" which ...
> becomes less clear. (More on this later.)

My intuition is not to do this kind of creative reinterpretation of
return values. Instead let=E2=80=99s have a new type of seccomp filter
specifically for io_uring. So we can have SECCOMP_IO_URING_ACCEPT,
ERRNO, and eventually other things. We probably will want a user
notifier feature for io_uring, but I'd be a bit surprised if it ends
up ABI-compatible with current users of user notifiers.

> - There appear to be three classes of desired restrictions:
>  - opcodes for io_uring_register() (which can be enforced entirely with
>    seccomp right now).

Agreed.

>  - opcodes from SQEs (this _could_ be intercepted by seccomp, but is
>    not currently written)

As above, I think this should be intercepted by seccomp, but in a new
mode.  I think that existing seccomp filters should not intercept it.

>  - opcodes of the types of restrictions to restrict... for making sure
>    things can't be changed after being set? seccomp already enforces
>    that kind of "can only be made stricter"

Agreed.

>
> - How does no_new_privs play a role in the existing io_uring credential
>  management? Using _any_ kind of syscall-effective filtering, whether
>  it's seccomp or Stefano's existing proposal, needs to address the
>  potential inheritable restrictions across privilege boundaries (which is
>  what no_new_privs tries to eliminate). In regular syscall land, this is
>  an issue when a filter follows a process through setuid via execve()
>  and it gains privileges that now the filter-creator can trick into
>  doing weird stuff -- io_uring has a concept of alternative credentials
>  so I have to ask about it. (I don't *think* there would be a path to
>  install a filter before gaining privilege, but I likely just
>  need to do my homework on the io_uring internals. Regardless,
>  use of seccomp by io_uring would need to have this issue "solved"
>  in the sense that it must be "safe" to filter io_uring OPs, from a
>  privilege-boundary-crossing perspective.
>
> - From which task perspective should filters be applied? It seems like it
>  needs to follow the io_uring personalities, as that contains the
>  credentials. (This email is a brain-dump so far -- I haven't gone to
>  look to see if that means io_uring is literally getting a reference to
>  struct cred; I assume so.) Seccomp filters are attached to task_struct.
>  However, for v5.9, seccomp will gain a more generalized get/put system
>  for having filters attached to the SECCOMP_RET_USER_NOTIF fd. Adding
>  more get/put-ers for some part of the io_uring context shouldn't
>  be hard.

Let's ignore personalities for a moment (and see below).  Thinking
through the possibilities:

A: io_uring seccomp filters are attached to tasks.  When an io_uring
is created, it inherits an immutable copy of its creating task's
filter, and that's the filter set that applies to that io_uring
instance.  This could have somewhat bizarre consequences if the fd
gets passed around, but io_uring already has odd security effects if
fds are passed around.  It has the annoying property that, if a
library creates an io_uring and then a seccomp filter is loaded, the
io_uring bypasses the library.

B: The same, but the io_uring references the creating task so new
filters on the task apply to the io_uring, too.  This allows loading
and then sandboxing.  Is this too bizarre overall?

C: io_uring filters are attached directly to io_urings.  This has the
problem where an io_uring created before a task sandboxes itself isn't
sandboxed.  It also would require that a filter be able to hook
io_uring creation to sandbox it.

Does anyone actually pass io_urings around with SCM_RIGHTS?  It would
be really nice if we could make the default be that io_urings are
bound to their creating mm and can't be used outside it.  Then
creating an mm-crossing io_uring could, itself, be restricted.

In any case, my inclination is to go for choice B.  Choice C could
also be supported if there's a use case.
