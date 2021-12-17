Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE83479507
	for <lists+io-uring@lfdr.de>; Fri, 17 Dec 2021 20:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbhLQTqK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Dec 2021 14:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240074AbhLQTqJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Dec 2021 14:46:09 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6BBC061574
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 11:46:09 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id g14so11890462edb.8
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 11:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JQhevuiq/CCVVqQiSaz73IS13LzmZvmVkuGO2Ug9oNo=;
        b=A8QMSklk0ibZ+W9fdcoqwbZZ4hu47ZLG2Fq0jw/zE1nrkbZiGsSM6KQGOi4WIh39QW
         PUlAWBL7iaVYjv2Gv4uyaV22hf2086lPjkWhaOiESJQarZkUgh/YhwvSDJrHhvLNnyFP
         nVyWtGC6vo8iA51V9GJ6NQjnqfsgU2wIdj/bA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JQhevuiq/CCVVqQiSaz73IS13LzmZvmVkuGO2Ug9oNo=;
        b=66AEt1iZES+KcgjH185Z5NSTPmq9HWzTryO90tgMXQuL/XYmnyvPj69m7x4glFDAwH
         Kxi6dOrEZPI2t9IRY/SLksgrkDq8j2xfT/BT5PzLnQna8iivedjYQxbjzYcWKBIU+Ims
         Wxr4GeElLekGZe3lzfOoUmpqIVl8TF/+Hag8m/swg2JMuBRryReiM1nW1BHB4x/bwNdi
         t+7IYU5NtsrYG77iVxKDLXEb/aJsw9opnQ7fy2P5sb/fcAlhxoX0r8gN/Cqw+0SGE5/+
         1Qrh2aPwSpv5hEzunVonARatBThDOWgQgKxzUQkl3oLJ+K/ZGPALHts4uY0yrcokc59X
         C6TA==
X-Gm-Message-State: AOAM530EFtxrxfF8G9TU+L2B4JPJRHGh+ueMTxWgpzZCYFVmztwqhktX
        r41AHzXg4iMYmsUB7uqbA8/yyl9nSlBV6KwRlEo=
X-Google-Smtp-Source: ABdhPJwk87WSd9b5YEmvoxTZ1dIJIuT2URFbpSwyEmsrCwCmRmSjHZC/ZywWs7zg57fDMZUoCxSJ7A==
X-Received: by 2002:a17:907:6d07:: with SMTP id sa7mr3545094ejc.339.1639770367809;
        Fri, 17 Dec 2021 11:46:07 -0800 (PST)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id r25sm3853172edt.21.2021.12.17.11.46.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Dec 2021 11:46:07 -0800 (PST)
Received: by mail-wr1-f46.google.com with SMTP id r17so5693367wrc.3
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 11:46:07 -0800 (PST)
X-Received: by 2002:adf:d1a6:: with SMTP id w6mr3622840wrc.274.1639770367130;
 Fri, 17 Dec 2021 11:46:07 -0800 (PST)
MIME-Version: 1.0
References: <1a6bc93c-df75-d47e-e90e-e90a87e48a56@kernel.dk>
In-Reply-To: <1a6bc93c-df75-d47e-e90e-e90a87e48a56@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 17 Dec 2021 11:45:50 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgFYF+W7QZ1KW3u-uFU=rC0jbyUFZBzCVX1-SH9-qe16w@mail.gmail.com>
Message-ID: <CAHk-=wgFYF+W7QZ1KW3u-uFU=rC0jbyUFZBzCVX1-SH9-qe16w@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 5.16-rc6
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Dec 17, 2021 at 9:00 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Just a single fix, fixing an issue with the worker creation change that
> was merged last week.

Hmm. I've pulled, but looking at the result, this is a classic no-no.

You can't just randomly drop and re-take a lock and sat it's "safe".

Because I don't think it's necessarily safe at all.

When you drop the wqe->lock in the middle of io_wqe_dec_running to
create a new worker, it means - for example - that "io_worker_exit()"
can now run immediately on the new worker as far as I can tell.

So one io_worker_exit() m,ay literally race with another one, where
both are inside that io_wqe_dec_running() at the same time. And then
they both end up doing

        worker->flags = 0;
        current->flags &= ~PF_IO_WORKER;

afterwards in the caller, and not necessarily in the original order.
And then they'll both possible do

        kfree_rcu(worker, rcu);

which sounds like a disaster.

Maybe this is all safe and things like the above cannot happen, but it
sure is *not* obviously so. Any time you release a lock in the middle
of holding it, basically *everything* you do afterwards when you
re-take it is suspect.

Don't perpetuate this broken pattern. Because even if it happens to be
safe in this situation, it's _alweays_ broken garbage unless you have
a big and exhaustive comment talking about why re-taking it suddenly
makes everything that follows ok.

The way to do this properly is to either

 (a) make the code you ran under the lock ok to run under the lock

 (b) make the locked region have a *return value* that the code then
uses to decide what to do after it has actually released the lock

But the whole "release and re-take" pattern is broken, broken, broken.

As mentioned, I've pulled this, but I seriously considered unpulling.
Because I think that fix is wrong.

                  Linus
