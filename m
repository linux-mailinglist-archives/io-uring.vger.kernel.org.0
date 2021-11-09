Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D5044A671
	for <lists+io-uring@lfdr.de>; Tue,  9 Nov 2021 06:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhKIFrz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Nov 2021 00:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbhKIFry (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Nov 2021 00:47:54 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA75AC061764
        for <io-uring@vger.kernel.org>; Mon,  8 Nov 2021 21:45:08 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id v11so69617314edc.9
        for <io-uring@vger.kernel.org>; Mon, 08 Nov 2021 21:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6+tELmWM9iOBqd3VL21YLcLYR1tRX2wq0JREpwlOgxU=;
        b=YR0d8B/7idBbztiIx63sWP3yW+TN66fKqwZWNwjhd70VxvrizB4wdorXEbcJ/h4Dfp
         H8cJn+xyUfbSllLjiQ5QDxGfheBdW4cYoEkww17HaFBg2kZRscDy0AwDgORHdTskDMbw
         Qz1+07whB1VRWvhSEDjSoeeXmTv/lVfwLg6yNgD4pPTw6JoY3aauNG9MEO0y+xA7eTKX
         LUaAQ/2XlnhNEM2FqItmyNOdQrsh2bTiNP3nycY3SFrEWqGHr/ykEvgww6fuCg3vmgKF
         jNl3hQANXm0JIcgE+vGZmRxDVCj3dAcx7sxS5hbQuY7wxgM+JA2aMm7R4U+wY3o/G3Ce
         x5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6+tELmWM9iOBqd3VL21YLcLYR1tRX2wq0JREpwlOgxU=;
        b=QU//J3OGH4n3VM7G6P3+eqaF9fLZufiP2dJ1kq/n7eA5Q88vNzjx6eWhiYe5HAddqW
         mWsEb28fS4RvdrD/Wthy4jPedkLynuMLxBIW99Bp2O5Rv1aM+9iwEtYjbH1HElQPOVhR
         59K5nzEGZcYkyN8I06JdWL18AiVyIu8bXUiqF/N0A3IdU6qQJ+aL0/NnvCo/NL+GGcTp
         U6Px8PjN+zuYpI819WJPijLXvEaTrhNx8bMp8z0xqTB3GRUvOxLLp0VfJjbrAza+fTAS
         4B3/5ltfD0rteT9xbfcHy4CyqkSA2IagYHAOoO3LKqmygJoxpoPegEVA+4G98qSxEVT3
         GJMA==
X-Gm-Message-State: AOAM532uxY7Z71juOh9XLkJGnGoyIyc73sbjQc2VAvgKh74U5G1b9Egj
        RdZvFXMEJmZK56d6x945k+zoZTeUnMslwd6ea2WrS16x+30=
X-Google-Smtp-Source: ABdhPJx6JFUt7rS9yN3M+/qQTVzGSDHzMSXma+5ul2gKcXDq4qahpU30kL3C47KjMHjbjbptVQNVPrSxtUmpQWAXeEE=
X-Received: by 2002:a05:6402:d59:: with SMTP id ec25mr6520709edb.214.1636436707363;
 Mon, 08 Nov 2021 21:45:07 -0800 (PST)
MIME-Version: 1.0
References: <20211106113506.457208-1-ammar.faizi@intel.com> <20211106114758.458535-1-ammar.faizi@intel.com>
In-Reply-To: <20211106114758.458535-1-ammar.faizi@intel.com>
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Date:   Tue, 9 Nov 2021 12:44:53 +0700
Message-ID: <CAGzmLMWsFYe3VJLonr7dc6Z3qe7YoB8b1meX6hyiHQdacpzBtw@mail.gmail.com>
Subject: Re: [PATCH v6 liburing] test: Add kworker-hang test
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Nov 6, 2021 at 6:49 PM Ammar Faizi wrote:
>
> This is the reproducer for the kworker hang bug.
>
> Reproduction Steps:
>   1) A user task calls io_uring_queue_exit().
>
>   2) Suspend the task with SIGSTOP / SIGTRAP before the ring exit is
>      finished (do it as soon as step (1) is done).
>
>   3) Wait for `/proc/sys/kernel/hung_task_timeout_secs` seconds
>      elapsed.
>
>   4) We get a complaint from the khungtaskd because the kworker is
>      stuck in an uninterruptible state (D).
>
> The kworkers waiting on ring exit are not progressing as the task
> cannot proceed. When the user task is continued (e.g. get SIGCONT
> after SIGSTOP, or continue after SIGTRAP breakpoint), the kworkers
> then can finish the ring exit.
>
> We need a special handling for this case to avoid khungtaskd
> complaint. Currently we don't have the fix for this.
[...]
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Link: https://github.com/axboe/liburing/issues/448
> Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
> ---
>
>  v6:
>    - Fix missing call to restore_hung_entries() when fork() fails.
>
>  .gitignore          |   1 +
>  test/Makefile       |   1 +
>  test/kworker-hang.c | 323 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 325 insertions(+)
>  create mode 100644 test/kworker-hang.c

It's ready for review.

-- 
Ammar Faizi
