Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A7F22183C
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 01:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgGOXHE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 19:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbgGOXHD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 19:07:03 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE75C08C5DD
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 16:07:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u5so2766346pfn.7
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 16:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Yvaq2P+PojMtEplE3YoxoQamecRP9sYA0XkAU4Baoko=;
        b=JMLQW1jfVYP22T1V+VNzJav9OTx0KTdcOe7OERKHlGpW8JELre7ySGePgiPZuFcyyN
         hv4f5DEkN3p2rSD2ZdUCUMFs5NE+FYj/t3vmPWXwa6hn6iIvulda5TgKB29T+wlP/DMw
         30zXLYPXJiTbbOUUjh1uOEqVp63wRsgeQ87Y0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Yvaq2P+PojMtEplE3YoxoQamecRP9sYA0XkAU4Baoko=;
        b=Be9YKVPaLycU+2sWib/A6WleRlZKbM+rzMQd6vHd4wpAXDSNDaU0YR3/2sON8M9LPm
         noAPvNw7+ZkuZ390vP2mP1h4EM1WeWC37wAn4A5BZ8CQs3wzvvGqanrWxwOL4FUVm/EE
         XOjh6l9+6R0C8WLNPBHiIXChcuTKSBSmCBHNVJDNjpv9ObzYLgK74PAQJ7Ioq5sN5e2w
         KzTBKrOhxfvTFM4qwEV2rQ6Agxc7s7DNBfX+ZjajJn09+D+VgnvA74TDSj+xvSssPwcp
         TXS3QhrsW46fz5OdQFiKf88EeVnpYw9Ji0hObwcxKBZ4ttO6dic9fWS9VOrdE/ipVuAU
         vNiw==
X-Gm-Message-State: AOAM531fL6AkVlFx3AaWFQm61DIEzEt9GQa+z9h6kKuHes/iNvz4vRW8
        HjjYjHfhrig7mgKt+rKRiKibqA==
X-Google-Smtp-Source: ABdhPJwECD3XSw3fWrn3S2RNcLITwnLnmJV2sTo8wYEzW0OORY57dF5Km8mckEsgMVSWW/0odG8ZvA==
X-Received: by 2002:a63:e80e:: with SMTP id s14mr1825227pgh.32.1594854422427;
        Wed, 15 Jul 2020 16:07:02 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 186sm2941627pfe.1.2020.07.15.16.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 16:07:01 -0700 (PDT)
Date:   Wed, 15 Jul 2020 16:07:00 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Matthew Wilcox <willy@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Jann Horn <jannh@google.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        strace-devel@lists.strace.io, io-uring@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: strace of io_uring events?
Message-ID: <202007151511.2AA7718@keescook>
References: <CAJfpegu3EwbBFTSJiPhm7eMyTK2MzijLUp1gcboOo3meMF_+Qg@mail.gmail.com>
 <D9FAB37B-D059-4137-A115-616237D78640@amacapital.net>
 <20200715171130.GG12769@casper.infradead.org>
 <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com>
 <CAJfpegt9=p4uo5U2GXqc-rwqOESzZCWAkGMRTY1r8H6fuXx96g@mail.gmail.com>
 <48cc7eea-5b28-a584-a66c-4eed3fac5e76@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48cc7eea-5b28-a584-a66c-4eed3fac5e76@gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Earlier Andy Lutomirski wrote:
> Let’s add some seccomp folks. We probably also want to be able to run
> seccomp-like filters on io_uring requests. So maybe io_uring should call into
> seccomp-and-tracing code for each action.

Okay, I'm finally able to spend time looking at this. And thank you to
the many people that CCed me into this and earlier discussions (at least
Jann, Christian, and Andy).

It *seems* like there is a really clean mapping of SQE OPs to syscalls.
To that end, yes, it should be trivial to add ptrace and seccomp support
(sort of). The trouble comes for doing _interception_, which is how both
ptrace and seccomp are designed.

In the basic case of seccomp, various syscalls are just being checked
for accept/reject. It seems like that would be easy to wire up. For the
more ptrace-y things (SECCOMP_RET_TRAP, SECCOMP_RET_USER_NOTIF, etc),
I think any such results would need to be "upgraded" to "reject". Things
are a bit complex in that seccomp's form of "reject" can be "return
errno" (easy) or it can be "kill thread (or thread_group)" which ...
becomes less clear. (More on this later.)

In the basic case of "I want to run strace", this is really just a
creative use of ptrace in that interception is being used only for
reporting. Does ptrace need to grow a way to create/attach an io_uring
eventfd? Or should there be an entirely different tool for
administrative analysis of io_uring events (kind of how disk IO can be
monitored)?

For io_uring generally, I have a few comments/questions:

- Why did a new syscall get added that couldn't be extended? All new
  syscalls should be using Extended Arguments. :(

- Why aren't the io_uring syscalls in the man-page git? (It seems like
  they're in liburing, but that's should document the _library_ not the
  syscalls, yes?)

Speaking to Stefano's proposal[1]:

- There appear to be three classes of desired restrictions:
  - opcodes for io_uring_register() (which can be enforced entirely with
    seccomp right now).
  - opcodes from SQEs (this _could_ be intercepted by seccomp, but is
    not currently written)
  - opcodes of the types of restrictions to restrict... for making sure
    things can't be changed after being set? seccomp already enforces
    that kind of "can only be made stricter"

- Credentials vs no_new_privs needs examination (more on this later)

So, I think, at least for restrictions, seccomp should absolutely be
the place to get this work done. It already covers 2 of the 3 points in
the proposal.

Solving the mapping of seccomp interception types into CQEs (or anything
more severe) will likely inform what it would mean to map ptrace events
to CQEs. So, I think they're related, and we should get seccomp hooked
up right away, and that might help us see how (if) ptrace should be
attached.

Specifically for seccomp, I see at least the following design questions:

- How does no_new_privs play a role in the existing io_uring credential
  management? Using _any_ kind of syscall-effective filtering, whether
  it's seccomp or Stefano's existing proposal, needs to address the
  potential inheritable restrictions across privilege boundaries (which is
  what no_new_privs tries to eliminate). In regular syscall land, this is
  an issue when a filter follows a process through setuid via execve()
  and it gains privileges that now the filter-creator can trick into
  doing weird stuff -- io_uring has a concept of alternative credentials
  so I have to ask about it. (I don't *think* there would be a path to
  install a filter before gaining privilege, but I likely just
  need to do my homework on the io_uring internals. Regardless,
  use of seccomp by io_uring would need to have this issue "solved"
  in the sense that it must be "safe" to filter io_uring OPs, from a
  privilege-boundary-crossing perspective.

- From which task perspective should filters be applied? It seems like it
  needs to follow the io_uring personalities, as that contains the
  credentials. (This email is a brain-dump so far -- I haven't gone to
  look to see if that means io_uring is literally getting a reference to
  struct cred; I assume so.) Seccomp filters are attached to task_struct.
  However, for v5.9, seccomp will gain a more generalized get/put system
  for having filters attached to the SECCOMP_RET_USER_NOTIF fd. Adding
  more get/put-ers for some part of the io_uring context shouldn't
  be hard.

- How should seccomp return values be applied? Three seem okay:
	SECCOMP_RET_ALLOW: do SQE action normally
	SECCOMP_RET_LOG: do SQE action, log via seccomp
	SECCOMP_RET_ERRNO: skip actions in SQE and pass errno to CQE
  The rest not so much:
	SECCOMP_RET_TRAP: can't send SIGSYS anywhere sane?
	SECCOMP_RET_TRACE: no tracer, can't send SIGSYS?
	SECCOMP_RET_USER_NOTIF: can't do user_notif rewrites?
	SECCOMP_RET_KILL_THREAD: kill which thread?
	SECCOMP_RET_KILL_PROCESS: kill which thread group?
  If TRAP, TRACE, and USER_NOTIF need to be "upgraded" to KILL_THREAD,
  what does KILL_THREAD mean? Does it really mean "shut down the entire
  SQ?" Does it mean kill the worker thread? Does KILL_PROCESS mean kill
  all the tasks with an open mapping for the SQ?

Anyway, I'd love to hear what folks think, but given the very direct
mapping from SQE OPs to syscalls, I really think seccomp needs to be
inserted in here somewhere to maintain any kind of sensible reasoning
about syscall filtering.

-Kees

[1] https://lore.kernel.org/lkml/20200710141945.129329-3-sgarzare@redhat.com/

-- 
Kees Cook
