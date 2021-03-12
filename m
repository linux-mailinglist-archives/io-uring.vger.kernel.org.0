Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10A433990D
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 22:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbhCLVYw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 16:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbhCLVY0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 16:24:26 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB1FC061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:24:25 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id y1so9060819ljm.10
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1F1UCgDhepcl+JNbfHiL3nuJuwfojivy8LOF1SVmXRU=;
        b=BvIm5a8QRYS8pdYxdl8JBl8XrgDay0vMkyIg6tUI62gVk1T1TFyC2gpN94K/gqBKS0
         mlJtlw0l1iRAcrZ5jkytUqjtkZOVWOntE3okHTkpYYgqhCNq6aEVJli4FjRgpfgD6WIn
         tKbS411Uhi6UeB5cMvWFdESOJPpbMXSIXf28w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1F1UCgDhepcl+JNbfHiL3nuJuwfojivy8LOF1SVmXRU=;
        b=WYZpXDgDD2esHhXxeSTNaWnErHPgtzblxtRx4eDq2faUNlRv/I9Jyry5LC6bNOBCy+
         gEpDmdD1m9ctU/GxppATDVl2XQt+9ZtNLB9DVZ9gF/2SBVLRbI1KTOyPlWXb7cQQAUE8
         8wEXrlwd2X7P33tCaAfSouroxIiKPLXs3f6mQh9zLsUgCDuZi7epY64xW2b20f5G/LH9
         U+lmKhYA94anV/f8x0fVIrjsHqym/Fc8lh4L7ePfK112GjK56bVxGOYqgq4uqS6H6vwH
         7+/GOUOv9IaelI2nqywMTWExvXgbtz5HqvXmfUU1tCsMoxa4PQSRW5m3F9GZ9hYShmTo
         ZAtQ==
X-Gm-Message-State: AOAM531r73h+mpuBydBGOEUMjIXK8/K7SxHmSvv7NoSj0DqpgpO+/rgf
        8K9W47FL9jacp65iRRCbaxjkNyU22KTABw==
X-Google-Smtp-Source: ABdhPJyEsvvyAOvgaxYT8ruT/NOpt02btHCJqPAgp2gdbW2QWOXPVPD5bWl+TOeS05w+tq1EVwuLYg==
X-Received: by 2002:a2e:a58d:: with SMTP id m13mr3484458ljp.347.1615584263852;
        Fri, 12 Mar 2021 13:24:23 -0800 (PST)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id o7sm1832388lfr.217.2021.03.12.13.24.23
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 13:24:23 -0800 (PST)
Received: by mail-lf1-f49.google.com with SMTP id k9so47457090lfo.12
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:24:23 -0800 (PST)
X-Received: by 2002:a19:ed03:: with SMTP id y3mr654020lfy.377.1615584262864;
 Fri, 12 Mar 2021 13:24:22 -0800 (PST)
MIME-Version: 1.0
References: <a5447498-4a4c-20b3-ed1a-68b61df8b26b@kernel.dk> <CAHk-=wjpS-kwozJQFNBestco=q5j3bcfXpVXc6uz=9_mmQ7oYg@mail.gmail.com>
In-Reply-To: <CAHk-=wjpS-kwozJQFNBestco=q5j3bcfXpVXc6uz=9_mmQ7oYg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Mar 2021 13:24:07 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj3gu-1djZ-YPGeUNwpsQzbCYGO2j1k_Hf1zO+z5VjSpA@mail.gmail.com>
Message-ID: <CAHk-=wj3gu-1djZ-YPGeUNwpsQzbCYGO2j1k_Hf1zO+z5VjSpA@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc3
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 12, 2021 at 1:17 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'm _guessing_ it's just that now those threads are user threads, and
> then the freezing logic expects them to freeze/thaw using a signal
> machinery or something like that. And that doesn't work when there is
> no signal handling for those threads.

IOW, I think it's this logic in freeze_task():

        if (!(p->flags & PF_KTHREAD))
                fake_signal_wake_up(p);
        else
                wake_up_state(p, TASK_INTERRUPTIBLE);

where that "not a PF_KTHREAD" test will trigger for the io_uring
threads, and it does that fake_signal_wake_up(), and then
signal_wake_up() does that

        set_tsk_thread_flag(t, TIF_SIGPENDING);

but the io_uring thread has no way to react to it.

So now the io_uring thread will see "I have pending signals" (even if
there is no actual pending signal - it's just a way to get normal
processes to get out of TASK_INTERRUPTIBLE and return to user space
handling).

And the pending fake signal will never go away, because there is no
"return to user space" handling.

So I think the fix is to simply make freeze_task() not do that fake
signal thing for IO-uring threads either.

            Linus
