Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2E82DD01E
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 12:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgLQLLG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Dec 2020 06:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbgLQLLF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Dec 2020 06:11:05 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43052C061794
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 03:10:25 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id r17so25425908ilo.11
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 03:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6+zbV7IGDNVa3mY6qMkQ+nLVVpAnmrKvbxoAwLD6k3E=;
        b=ntvft9KjEfp2UcB0VKuQFb7Htr1tRELhv5KxLQuNvmexlA6xu1qBHFzezCVDtaDKyh
         tMHpA8aWYhwzmZcSZAEaY6Axa/jzAMnhO5/DqXhI7SDaQgn/fdgn5I+mH5kEF81C32aC
         siWSCCjgbgAVO5FftAXw7geFh9KKvznT7kaaZwC/TifOpTZh66tJgufNlgHjLPfttH7+
         nGEifErnLj+9EjMcwh3wpRB+pCbyX9qfXeVw0XnQ+yvPnQO1SrwjYrChtdbgdLg5nx6Q
         UYcIhA89INpwA+8JXgDjYFcDcUNxJmlQ/CC2Cs9JUniwGE0dPzd45uUJ+lYDld0mvLja
         jdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6+zbV7IGDNVa3mY6qMkQ+nLVVpAnmrKvbxoAwLD6k3E=;
        b=i74W3lnMk4dCIZz+WbYESwEzMVZ/KJ7yomhtUNz1zEhPMHhOMNz0Vcz31nu98yIofX
         AfEg1cSbsrcloC8NrKH7s5kzWXtZuAKh//q87xWa4zM+i0V4s6EbrASjJc/5KWdCL3l8
         uRp0OY7RKbYjYsAemTcnh1uts0UB+zhgaqgDLQPtB9O5Q/OQsM5U8mfLFu34sugcJ71L
         pJe7D9fDjpH/qckld1owRc0EsZeqX9uOamCqMkVGb+/4veHSzf1Ui4Aybbl0LS6gOXYQ
         tiSMBYR5VqNnlLZ4zyRjcPuTej3BnF2GTwEizAvy+KY5yZQKsHnb9LoQbRnagBkyouZ9
         IKHg==
X-Gm-Message-State: AOAM532aweqRd+Np928u1jjUUNy4EFGHx+/dF897P25IX3Lu6HDVCR4T
        0Rw8sAZMmjeG3ZGNAI6wNoiQTJJ9vElgn4B69nA=
X-Google-Smtp-Source: ABdhPJx+RJCsQPB71zAGLwr472ohNuFfrU6fTFbs0bBSB+iGW2lrdS1FpxqXGud1HXZ4b195idNhYCcAyRq1D1dAujU=
X-Received: by 2002:a05:6e02:c2a:: with SMTP id q10mr48636902ilg.92.1608203424517;
 Thu, 17 Dec 2020 03:10:24 -0800 (PST)
MIME-Version: 1.0
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
 <8910B0D3-6C84-448E-8295-3F87CFFB2E77@googlemail.com> <CAOKbgA4V5aGLbotXz4Zn-7z8yOP5Jy_gTkpwk3jDSNyVTRCtkg@mail.gmail.com>
 <CAOKbgA5X7WWQ4LWN4hXt8Rc5qQOOG24tTyxsKos7KO1ybOeC1w@mail.gmail.com> <CAAss7+owve47-D9SzLpzeCiPAOjKxhc5D2ZY-aQw5WOCvQA5wA@mail.gmail.com>
In-Reply-To: <CAAss7+owve47-D9SzLpzeCiPAOjKxhc5D2ZY-aQw5WOCvQA5wA@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 17 Dec 2020 18:10:13 +0700
Message-ID: <CAOKbgA7ojpGPMEc0vSGhhbyP3nE84pXUf=1E0OY4AQYsm+qgwA@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Josef <josef.grieb@gmail.com>
Cc:     Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 17, 2020 at 5:38 PM Josef <josef.grieb@gmail.com> wrote:
>
> > > That is curious. This ticket mentions Shmem though, and in our case it does
>  > not look suspicious at all. E.g. on a box that has the problem at the moment:
>  > Shmem:  41856 kB. The box has 256GB of RAM.
>  >
>  > But I'd (given my lack of knowledge) expect the issues to be related anyway.
>
> what about mapped? mapped is pretty high 1GB on my machine, I'm still
> reproduce that in C...however the user process is killed but not the
> io_wq_worker kernel processes, that's also the reason why the server
> socket still listening(even if the user process is killed), the bug
> only occurs(in netty) with a high number of operations and using
> eventfd_write to unblock io_uring_enter(IORING_ENTER_GETEVENTS)
>
> (tested on kernel 5.9 and 5.10)

Stats from another box with this problem (still 256G of RAM):

Mlocked:           17096 kB
Mapped:           171480 kB
Shmem:             41880 kB

Does not look suspicious at a glance. Number of io_wq* processes is 23-31.

Uptime is 27 days, 24 rings per process, process was restarted 4 times, 3 out of
these four the old instance was killed with SIGKILL. On the last process start
18 rings failed to initialize, but after that 6 more were initialized
successfully. It was before the old instance was killed. Maybe it's related to
the load and number of io-wq processes, e.g. some of them exited and a few more
rings were initialized successfully.

-- 
Dmitry Kadashev
