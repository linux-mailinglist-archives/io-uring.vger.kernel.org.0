Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23ADA3A1E29
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 22:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhFIUfx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 16:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhFIUfw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 16:35:52 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80906C061760
        for <io-uring@vger.kernel.org>; Wed,  9 Jun 2021 13:33:57 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id r5so40149364lfr.5
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 13:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HKOE8BadJeo+YL8tRU0iYJhaHWhLziwYQepJorZ98hY=;
        b=UBP8J6oYchq2ROBkKb/OBl2yhXz9+41fIVP2jys4OwQsSgcG7GA3wC9CyITc1BANel
         6pUPf1o7H/jAprU3hJI9Orap/rRnTmgpIpJfaXDu+lmLVs+eno55vuWfJKvk061XOrqM
         lIKlhsHcRIejWytT4LUfn+BysOlyh7R4deQ6Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HKOE8BadJeo+YL8tRU0iYJhaHWhLziwYQepJorZ98hY=;
        b=LGkDntGrDquOcpEZ2GK8ZdogyLub9MQ7MSlcjo1+UTs+LpqaMvv+T/V/9Mx4Ks2aOC
         vZzLpnp9ScTK/EdzL7v49FI/jWlgzAylb/nDg/6wTeEPDg6JdBjlB69yQyY92Y1nsRHn
         VFXWwdnKehLm+p7q/85YsfqYNhptjQNkUL70DpmuBuamEzwn5YPwL7KjGg6nDrmxNVFz
         O5Nd6uwkXi1UHkocNxwPxDifWE5GhQvvRTZwt4ldYw1rTejoCngtoarWRfc0zw4fcxvr
         LBdPlJAp3/cgDN8qMB9eEGjm9jYMSboXkFbMaMZfK62c0vB86ZQwBk1JdoGORvd7zZfJ
         /ZrA==
X-Gm-Message-State: AOAM530XnNJ0eTgkKYwEHpP91/LxrkGpTQnekjbITzRAiA8Se6h2jADA
        XUyCZVNPFsdFXC4uWzEE11NE6TDNt45i/ChSBqk=
X-Google-Smtp-Source: ABdhPJxFbvRY9BR/rPwRly5SJkvkawBKs1a81A7nuGkZl7uU3QlWYH8yz2kcLeXquaqDmm6OGDTaNA==
X-Received: by 2002:a19:389:: with SMTP id 131mr761941lfd.55.1623270835556;
        Wed, 09 Jun 2021 13:33:55 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id w10sm84219lfu.254.2021.06.09.13.33.52
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 13:33:53 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id s22so1551656ljg.5
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 13:33:52 -0700 (PDT)
X-Received: by 2002:a2e:9644:: with SMTP id z4mr1178053ljh.507.1623270832349;
 Wed, 09 Jun 2021 13:33:52 -0700 (PDT)
MIME-Version: 1.0
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
 <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com> <87h7i694ij.fsf_-_@disp2133>
In-Reply-To: <87h7i694ij.fsf_-_@disp2133>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 9 Jun 2021 13:33:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
Message-ID: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
Subject: Re: [RFC] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 9, 2021 at 1:17 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
> In short the coredump code deliberately supports being interrupted by
> SIGKILL, and depends upon prepare_signal to filter out all other
> signals.

Hmm.

I have to say, that looks like the core reason for the bug: if you
want to be interrupted by a fatal signal, you shouldn't use
signal_pending(), you should use fatal_signal_pending().

Now, the fact that we haven't cleared TIF_NOTIFY_SIGNAL for the first
signal is clearly the immediate cause of this, but at the same time I
really get the feeling that that coredump aborting code should always
had used fatal_signal_pending().

We do want to be able to abort core-dumps (stuck network filesystems
is the traditional reason), but the fact that it used signal_pending()
looks buggy.

In fact, the very comment in that dump_interrupted() function seems to
acknowledge that signal_pending() is all kinds of silly.

So regardless of the fact that io_uring does seem to have messed up
this part of signals, I think the fix is not to change
signal_pending() to task_sigpending(), but to just do what the comment
suggests we should do.

But also:

> With the io_uring code comes an extra test in signal_pending
> for TIF_NOTIFY_SIGNAL (which is something about asking a task to run
> task_work_run).

Jens, is this still relevant? Maybe we can revert that whole series
now, and make the confusing difference between signal_pending() and
task_sigpending() go away again?

               Linus
