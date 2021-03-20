Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1D6342EAE
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 18:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhCTRwb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 13:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhCTRwP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Mar 2021 13:52:15 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F3FC061574
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 10:52:05 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 16so15894251ljc.11
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 10:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5OmbSOuinhRQV6DrZgKqaOvl/t21cHvRtCQJ6j6X2Hw=;
        b=ZFx4qn9dLSHfxphxzAObtIks+QMPkezIxghoU5k6ExoUj72D25ds6qrDYkutGY47fI
         83Ye21WRurlmsbE7rpmWAclkedEVlxYXHaE5Ganw4hlzwsgxT47jff1h9cnq4r5+MgUQ
         wQXaeu1mjW2bScA8HotWZGWVMxGDdGEwOmugU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5OmbSOuinhRQV6DrZgKqaOvl/t21cHvRtCQJ6j6X2Hw=;
        b=ogfZY7SSDsZLSrSRkBSXdkrWIRNU4BLEjt3oqYkI9cJofh3QbW5mHkKl/g/ivFE0Hu
         ECk9/erImSgK1rUclXLgrzngyPEjEmQ3NJiPF98nQtGnYOuuRHjcsCNHuNGBLgJHXW+m
         KprDjux2aQuiAsRY0dJdMbQe1vRK5UM4n0xuURv1XcQ7hRmzrY2YqK3qrKobXn2cjNME
         z2gucCMv2giS5FsaNBmOi/l0ODTaWAPtVqVvn/0BO5lzIbO4fA5Owg4kf0jeEHc9Xg27
         t/9voyLboOGUGG5e2SktXfLpK8pyGasMEkE6VEYKEZA4n6/uDPJ4b3o922g8NTBU2dpO
         TvWg==
X-Gm-Message-State: AOAM530oOkt9zAL2IOe1gIvfBaAQN7H/oMBMd+0lwbqtUTbLhd6cb4IN
        z0bUOz6OjfwXYx4ZdJ2LtB1jCOGiEuyN4A==
X-Google-Smtp-Source: ABdhPJxmcN+yavgqur0QqsT1LqhlKR/+d3ZYkVPPnq7L7WJWP+P0tGNwddH21rD7T8HtogYwsIqyqg==
X-Received: by 2002:a2e:b4c8:: with SMTP id r8mr4460667ljm.57.1616262724103;
        Sat, 20 Mar 2021 10:52:04 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id z64sm983859lfa.92.2021.03.20.10.52.03
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 10:52:03 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id z8so15876769ljm.12
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 10:52:03 -0700 (PDT)
X-Received: by 2002:a2e:a306:: with SMTP id l6mr4255151lje.251.1616262723006;
 Sat, 20 Mar 2021 10:52:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210320153832.1033687-1-axboe@kernel.dk> <m14kh5aj0n.fsf@fess.ebiederm.org>
In-Reply-To: <m14kh5aj0n.fsf@fess.ebiederm.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 20 Mar 2021 10:51:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=whyL6prwWR0GdgxLZm_w-QWwo7jPw_DkEGYFbMeCdo8YQ@mail.gmail.com>
Message-ID: <CAHk-=whyL6prwWR0GdgxLZm_w-QWwo7jPw_DkEGYFbMeCdo8YQ@mail.gmail.com>
Subject: Re: [PATCHSET 0/2] PF_IO_WORKER signal tweaks
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Mar 20, 2021 at 9:27 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> That makes me uneasy.  Because especially the SIGSTOP changes feels like
> it is the wrong thing semantically.  The group_send_sig_info change
> simply feels like it is unnecessary.

SIGSTOP handling is fundamentally done at signal handling time, and
signal handling is fundamentally done at "return to user space" time.

End result: you cannot send kernel threads any signals at all, unless
it _explicitly_ handles them manually.  SIGSTOP isn't different from
user space delivery of an "actual" signal handler in this respect.

And practically speaking, the only signal a kernel thread generally
can handle is SIGKILL (and exit on it).

Now, to make matters actually more confusing for SIGSTOP, it's a
two-phase operation - initiated from that usual "about to return to
user space with signals pending" logic (which doesn't happen for
kernel threads, including IO threads), _and_ then it has that magic
accounting for when to notify the parent about stoppage (which has
some across-thread handling).

I really think IO threads need to not participate, because they simply
cannot handle signals in any sane manner.

You should think of the IO threads as fully kernel threads that just
share VM and fs with the user thing.

In fact, it might be a good idea to disassociate them from the thread
group entirely when they are created, so that none of
"for_each_thread()" or "next_thread()" logic ever finds them.

Maybe the right thing to do is to add a new case to that whole thread
group initialization code in copy_process() - something like this fake
and intentionally whitespace-damaged pseudo-patch:

  diff --git a/kernel/fork.c b/kernel/fork.c
  index 54cc905e5fe0..b87abe3a9ac6 100644
  --- a/kernel/fork.c
  +++ b/kernel/fork.c
  @@ -2296,7 +2296,7 @@ static __latent_entropy struct task_struct
*copy_process(
                attach_pid(p, PIDTYPE_PGID);
                attach_pid(p, PIDTYPE_SID);
                __this_cpu_inc(process_counts);
  -     } else {
  +     } else if (!IOTHREAD) {
                current->signal->nr_threads++;
                atomic_inc(&current->signal->live);
                refcount_inc(&current->signal->sigcnt);

so that the IO thread isn't considered "really" part of the existing
signal state. Alternatively, make it not use
CLONE_SIGHAND|CLONE_THREAD at all, but that would make it
unnecessarily allocate its own signal state, so that's "cleaner" but
not great either.

Hmm.

            Linus
