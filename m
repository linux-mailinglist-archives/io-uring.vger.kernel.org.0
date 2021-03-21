Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A128343473
	for <lists+io-uring@lfdr.de>; Sun, 21 Mar 2021 20:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhCUT6Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 15:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhCUT57 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 15:57:59 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CDEC061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 12:57:58 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 184so18472409ljf.9
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 12:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iFEaGtipHtB5ksp/gPeMOr+K0OZmJ87uSOi18F3mCyA=;
        b=I72KWcFfoSdYkhi0ePgAbmAQjZkBcOfPuuVt9tHelZl0w0AQBkFx18g2hAIWGrfwyD
         BC/zoYoo95x09q/MCf8QdqLRqZlYHqWMXcNAyoa/Hj1tN+7dda8iiUpS69u9202Blax4
         4Kq0diCQVk7Ek6880eA4nhMC+POKy40AZq4Jw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iFEaGtipHtB5ksp/gPeMOr+K0OZmJ87uSOi18F3mCyA=;
        b=UuRwQYP5fNhPruOtkcN+5jWyjGXuWKs3CSqhbCL117ensAmLq1ecyT7EdNd/0wJK8F
         P46tK0Tyf8rug+LAVHB0sqBTNqGtwlOMq7lvUjcKT9b+UsUKd85NSodgsQyA+rlztYVz
         cHDw2wldH9ov+3nm21qyJ7dPfrfjE5oTcl2PuqtRzzRUoN2CVCcoiRpyhCBJMCuvzajh
         KFBhN6OTJLQRUTey97ewQc7tPrhxCdVkLdgraZ/knLhnajc/pnqPjlh6j1D9XP66nr9N
         /x98MWPFYIT8zD5GFWV7Y69omIjDZJWlofp2Kko+zqTfuOV9iwpNcAvUa5lWkWV45jsi
         v3ZQ==
X-Gm-Message-State: AOAM530mIqW+irbdimHbqlpEsICYvsxhkGLsnZRiSoCKsW7z97hyHMVf
        An70tu6AYVDf35XSkrytSXhGDAhNscYaXg==
X-Google-Smtp-Source: ABdhPJwRKpKHhx4E9ZYwhO11eEMNyrENkcMX6vocV/dd6+av0oR5pDXj74Por0KbAJaOFbcpmqsQMw==
X-Received: by 2002:a2e:5804:: with SMTP id m4mr7416382ljb.419.1616356676712;
        Sun, 21 Mar 2021 12:57:56 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id j144sm1318728lfj.241.2021.03.21.12.57.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 12:57:56 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id x28so18016826lfu.6
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 12:57:56 -0700 (PDT)
X-Received: by 2002:ac2:4250:: with SMTP id m16mr6691566lfl.40.1616356676047;
 Sun, 21 Mar 2021 12:57:56 -0700 (PDT)
MIME-Version: 1.0
References: <ea7f768a-fd67-a265-9d90-27cd5aa26ac9@kernel.dk>
In-Reply-To: <ea7f768a-fd67-a265-9d90-27cd5aa26ac9@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 21 Mar 2021 12:57:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgYhNck33YHKZ14mFB5MzTTk8gqXHcfj=RWTAXKwgQJgg@mail.gmail.com>
Message-ID: <CAHk-=wgYhNck33YHKZ14mFB5MzTTk8gqXHcfj=RWTAXKwgQJgg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring followup fixes for 5.12-rc4
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Mar 21, 2021 at 9:38 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> - Catch and loop when needing to run task_work before a PF_IO_WORKER
>   threads goes to sleep.

Hmm. The patch looks fine, but it makes me wonder: why does that code
use test_tsk_thread_flag() and clear_tsk_thread_flag() on current?

It should just use test_thread_flag() and clear_thread_flag().

Now it looks up "current" - which goes through the thread info - and
then looks up the thread from that. It's all kinds of stupid.

It should just have used the thread_info from the beginning, which is
what test_thread_flag() and clear_thread_flag() do.

I see the same broken pattern in both fs/io-wq.c (which is where I
noticed it when looking at the patch) and in fs/io-uring.c.

Please don't do "*_tsk_thread_flag(current, x)", when just
"*_thread_flag(x)" is simpler, and more efficient.

In fact, you should avoid *_tsk_thread_flag() as much as possible in general.

Thread flags should be considered mostly private to that thread - the
exceptions are generally some very low-level system stuff, ie core
signal handling and things like that.

So please change things like

        if (test_tsk_thread_flag(current, TIF_NOTIFY_SIGNAL))

to

        if (test_thread_flag(TIF_NOTIFY_SIGNAL))

etc.

And yes, we have a design mistake in a closely related area:
"signal_pending()" should *not* take the task pointer either, and we
should have the "current thread" separate from "another thread".

Maybe the "signal_pending(current)" makes people think it's a good
idea to pass in "current" to the thread flag checkers. We would have
been better off with "{fatal_,}signal_pending(void)" for the current
task, and "tsk_(fatal_,}signal_pending(tsk)" for the (very few) cases
of checking another task.

Because it really is all kinds of stupid (yes, often historical -
going all the way back to when 'current' was the main model - but now
stupid) to look up "current" to then look up thread data, when these
days, when the basic pattern is

  #define current get_current()
  #define get_current() (current_thread_info()->task)

ioe, the *thread_info* is the primary and quick thing, and "current"
is the indirection, and so if you see code that basically does
"task_thread_info()" on "current", it is literally going back and
forth between the two.

And yes, on architectures that use "THREAD_INFO_IN_TASK" (which does
include x86), the back-and-forth ends up being a non-issue (because
it's just offsets into containing structs) and it doesn't really
matter. But conceptually, patterns like "test_tsk_thread_flag(current,
x)" really are wrong, and on some architectures it generates
potentially *much* worse code.

           Linus
