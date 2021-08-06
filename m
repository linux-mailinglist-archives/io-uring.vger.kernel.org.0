Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CE93E2C7A
	for <lists+io-uring@lfdr.de>; Fri,  6 Aug 2021 16:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238639AbhHFO1j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Aug 2021 10:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238446AbhHFO1i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Aug 2021 10:27:38 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23244C0613CF
        for <io-uring@vger.kernel.org>; Fri,  6 Aug 2021 07:27:22 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so14110350pjn.4
        for <io-uring@vger.kernel.org>; Fri, 06 Aug 2021 07:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y0jLyBzMb1NStHjvm1oD8pMgC3m6NvmMcoN2cYom1cA=;
        b=xQxKViY6R+Q646WAdf7fWmfxfQvbxtLU8J9hecKak5ZnNfqDoH/TWG26aUegL+Crcb
         Lp00/XlEr+vRJsZ9QHsRbyyumIlNE+Ew12pk2Ld5UNvPGnxqql2WmFIGplqjgNWCC7Dq
         bFFuspxoU2dQYLUurMZpNJyxoqF7nIeJu/hRlZPnTRilQPmXuEsAjc/06Y00vNkrlj1o
         HcEHSKta38S4h8pIUYuhz/1J07+Al4zdSZdKUyD8hVqTvegLEgV39TDnC2gEbAyfoFMq
         ySrjvivTyMRzw1Q2uEIJ+IuCy0fti1+sR335GKD3gj5q1s1SsUjwRtMxZb3Z6Et+PAA4
         CASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y0jLyBzMb1NStHjvm1oD8pMgC3m6NvmMcoN2cYom1cA=;
        b=Cr7IghHoG+Alk6n33wFIvLszOogSX0FGxNcGruEDQIwgQacg7MgvIELK8i6sfo5eOJ
         7xAUYo90KPJeI+XjDMwL6SkBBTXGG2lXtjtFAJMiEcNYu8fDlUahbirOw3lLGTvWFR1S
         2x6EEkGi9PHKaJ8q1xMg11H9E6tvuxOyutMSBVYGyGzEUd8UR8D5Lw3Pr9a3Gq+Tgsj2
         fV9Nr1oZmVkz/HHaEDov5YI1ZVGhrUd6hsK0y+eQeMaUDum5NgdUvNKxhMY+HrJRsNJv
         jhlmovXpfpsPt2FDPAaZ4o6wuBcDB+wOwq2u/fBFWQmURQPIeremJ+QaMQlI+WpzzQ9K
         /uDA==
X-Gm-Message-State: AOAM531pnoMk/RQN5CP1sbYZ6YQniw4sDOcsLN47rocMo5aapB76emQ0
        OUZq6owEzloklXvirUGkniZ68aNRSYbY4WLS
X-Google-Smtp-Source: ABdhPJy5koeG8YAIA0j5BlJf3J1LrOa4OwbVAbDr3CyXMQLQiqKkIEQrjDpSjBYnp2/ZT2KdWtIFHQ==
X-Received: by 2002:a65:450c:: with SMTP id n12mr950874pgq.316.1628260041667;
        Fri, 06 Aug 2021 07:27:21 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id 17sm12626706pjd.3.2021.08.06.07.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 07:27:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/3] io-wq: fix no lock protection of acct->nr_worker
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210805100538.127891-1-haoxu@linux.alibaba.com>
 <20210805100538.127891-3-haoxu@linux.alibaba.com>
Message-ID: <cc9e61da-6591-c257-6899-d2afa037b2ad@kernel.dk>
Date:   Fri, 6 Aug 2021 08:27:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210805100538.127891-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 5, 2021 at 4:05 AM Hao Xu <haoxu@linux.alibaba.com> wrote:
>
> There is an acct->nr_worker visit without lock protection. Think about
> the case: two callers call io_wqe_wake_worker(), one is the original
> context and the other one is an io-worker(by calling
> io_wqe_enqueue(wqe, linked)), on two cpus paralelly, this may cause
> nr_worker to be larger than max_worker.
> Let's fix it by adding lock for it, and let's do nr_workers++ before
> create_io_worker. There may be a edge cause that the first caller fails
> to create an io-worker, but the second caller doesn't know it and then
> quit creating io-worker as well:
>
> say nr_worker = max_worker - 1
>         cpu 0                        cpu 1
>    io_wqe_wake_worker()          io_wqe_wake_worker()
>       nr_worker < max_worker
>       nr_worker++
>       create_io_worker()         nr_worker == max_worker
>          failed                  return
>       return
>
> But the chance of this case is very slim.
>
> Fixes: 685fe7feedb9 ("io-wq: eliminate the need for a manager thread")
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io-wq.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index cd4fd4d6268f..88d0ba7be1fb 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -247,9 +247,14 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
>         ret = io_wqe_activate_free_worker(wqe);
>         rcu_read_unlock();
>
> -       if (!ret && acct->nr_workers < acct->max_workers) {
> -               atomic_inc(&acct->nr_running);
> -               atomic_inc(&wqe->wq->worker_refs);
> +       if (!ret) {
> +               raw_spin_lock_irq(&wqe->lock);
> +               if (acct->nr_workers < acct->max_workers) {
> +                       atomic_inc(&acct->nr_running);
> +                       atomic_inc(&wqe->wq->worker_refs);
> +                       acct->nr_workers++;
> +               }
> +               raw_spin_unlock_irq(&wqe->lock);
>                 create_io_worker(wqe->wq, wqe, acct->index);
>         }
>  }

There's a pretty grave bug in this patch, in that you no call
create_io_worker() unconditionally. This causes obvious problems with
misaccounting, and stalls that hit the idle timeout...

-- 
Jens Axboe

