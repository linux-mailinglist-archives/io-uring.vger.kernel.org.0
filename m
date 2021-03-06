Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD6532FD5E
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 22:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhCFVOr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Mar 2021 16:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhCFVOe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Mar 2021 16:14:34 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8510DC06174A
        for <io-uring@vger.kernel.org>; Sat,  6 Mar 2021 13:14:33 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id q25so12597323lfc.8
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 13:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ORBrQNy5kjP0Pe5zAjF0UubYRFyPtYQvCKHWObFuRW0=;
        b=MFJdcJ1d6UBxWre6bF9jVjjzJTzE0dh63RllsjUW4LSOCZmZexe5+oxB8UzZkN5u59
         Ph2/QGGhLRHw1hpOPGSY9WvDJFpWd3/1lKZ7EfPQXjmY4Mi+rYFPA4hqkGKVfFZ+4IVS
         elZnRO4A3rM9cliWmquxNvIPiiTgw2FFt2Pfg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ORBrQNy5kjP0Pe5zAjF0UubYRFyPtYQvCKHWObFuRW0=;
        b=patqLP9P7H/Z1KEMqhmiE9oCHCCF9QOMUuusqvHHktgbYneLafn+L88A7ot4NzKH9I
         p560xuSqAkhRc1EVuAqzBbwqMT9SlwQ2wJac62eYoDK0I2YLv8t6YglLpHacCwBbGzKn
         XTy4WQXJhIOoHP3Up/tBzPDAD4ozB5yphqkvRsTvYPA/2993J9nRlxQyevG/4l896MGz
         v7RiFJs3YNuwxAQXY6pHpZIuHSnxoYz3j0+Git1baAwJs5vKHKch1viorgsVpp/fRAZ5
         jvDWDWtwRTkrq507ywZaU0qCMXzQyuDOxutvDG28He2mzmZ+SsOjmVZPOEjGfz/fLxUw
         3yuw==
X-Gm-Message-State: AOAM532gcMlWZGG4rIVbU1scxsmY7MWRj3ZAsz4xMb+G5KumRomhR6+f
        vxiNBr9YMbyShlVXvHTAKJ7D86votgAuUQ==
X-Google-Smtp-Source: ABdhPJwjAbKILxXt9zGSbFIbTD0DHlyef9aEbJUz80tfP13fIAufb4/FVIazj8GQ1OLdeCgHJMxNmA==
X-Received: by 2002:a05:6512:108c:: with SMTP id j12mr10066878lfg.431.1615065271679;
        Sat, 06 Mar 2021 13:14:31 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id s22sm828238ljd.28.2021.03.06.13.14.30
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Mar 2021 13:14:30 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id e7so12660395lft.2
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 13:14:30 -0800 (PST)
X-Received: by 2002:a05:6512:398d:: with SMTP id j13mr9396162lfu.41.1615065270366;
 Sat, 06 Mar 2021 13:14:30 -0800 (PST)
MIME-Version: 1.0
References: <88ef6732-3800-a563-868d-8c1e5545c8fa@kernel.dk>
 <CAHk-=wjAASE-FhpGqrDoa-u5gktgW0=4q2V9+i7B93HTEf3cbg@mail.gmail.com>
 <7018071c-6f63-1e8c-3874-8ad643bad155@kernel.dk> <CAHk-=whjh_cow+gCQMCnS0NdxTqumtCgEDth+QLTjpYpOaOETQ@mail.gmail.com>
 <31785b03-93dd-d204-dcf6-dd6b6546cbb6@kernel.dk>
In-Reply-To: <31785b03-93dd-d204-dcf6-dd6b6546cbb6@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 6 Mar 2021 13:14:14 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg_D4Mobaj9mff2PEy+Qm67kGTP3kxo2=Aoa_UTc1k-_A@mail.gmail.com>
Message-ID: <CAHk-=wg_D4Mobaj9mff2PEy+Qm67kGTP3kxo2=Aoa_UTc1k-_A@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc2
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Mar 6, 2021 at 8:25 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> You're not, but creds is just one part of it. But I think we're OK
> saying "If you do unshare(CLONE_FILES) or CLONE_FS, then it's not
> going to impact async offload for your io_uring". IOW, you really
> should do that before setting up your ring(s).

Yeah, I think that one is solidly in a "don't do that then" thing.

Changing credentials is "normal use" - if you are a server process,
you may want to just make sure that you use different credentials for
different client requests etc.

But doing something like "I set up an io_uring for async work, and
then I dis-associated from my existing FS state entirely", that's not
normal. That's just a "you did something crazy, and you'll get crazy
results back, because the async part is fundamentally different from
the synchronous part".

It might be an option to just tear down the IO uring state entirely if
somebody does a "unshare(CLONE_FILES)", the same way unsharing the VM
(ie execve) does. But then it shouldn't even try to keep the state in
sync, it would just be "ok, your old io_uring is now simply gone".

I'm not sure it's even worth worrying about. Because at some point,
it's just "garbage in, garbage out".

               Linus
