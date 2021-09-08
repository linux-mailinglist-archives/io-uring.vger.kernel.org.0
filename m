Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF15403A8E
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 15:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348873AbhIHN0J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 09:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235294AbhIHN0J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 09:26:09 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2497BC061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 06:25:01 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id g74so1715800wmg.5
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 06:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3Hjt0kY6WoUbuOhlZ/VohgZkHMXJebDPaDwfdab7VBc=;
        b=AxPPVTU93gUq97Ex/5Q6s/4WECoEzCbH5qI8D4ci/64peiRET0IsllmJA6ZZ+OwPhc
         J6afv4LubuyH5EVVTR83O3fmy9cHw0bzFt3VA3VrfxlqDkrthOZ5YUvqeDXaSFSYVIIV
         JAjrEIUe4IWFobbQytE51p0cPEWgQU39orCYrnu2qblK0kOIH8SX1f98Cob57DtKFDAY
         OmvW1iejz6auQu+kkiISwMm14KH7SADKlptXA8KLx3ImpqtBJ6rYmqCnnSwr0HIFxnlH
         5h6iI/Ao7DxK+D4VyYI0PTjL8DHS4Ss63BDI4gfJK9czqj3VSFBl78Wogm2nJivVKg7p
         koMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Hjt0kY6WoUbuOhlZ/VohgZkHMXJebDPaDwfdab7VBc=;
        b=I8eGB2N4Ieoo2U/4Cewo3iwuddCufkMaQJphG3V6/3VMB8qAfHH84i65QrCAxiTr+t
         kb3S/cGd3zMx1ohNCWZOg3mGFaLZWK0NGlfAAXPPLmC19H33LGHBRcZeNeTSvGTtRVQE
         cjVd53OqD0AfzRkcZcH49RGDfq8WQ/lvxYHoMqd9zbzh9yXhSO1P7hvw2Iqti5IwxfKw
         PYKECwzrtLY7DR3J6xDayhIfwhuEdytux81bW4Op5K97k8aUA1eg8DdDZcqbiEVRQ9B9
         PqPqgwbkWvt/7rM05OYJ7bR98A53v+YzqP2EDpmgbUuE45Wh3bUIJlHGlVCnFI3XYsOC
         V47A==
X-Gm-Message-State: AOAM531XTuxWaQxjr/lQsy4TRc7UQ6viCrJQ1s2FE/Vib/mvpJPlqthr
        tQgf69N7aYzcr1FNusN1kJ7rD5GlPJc=
X-Google-Smtp-Source: ABdhPJx/w5GXJ5flP1tSz0/tXv39x/oC6z7PfLJzDa4Rm6qsR6e6yj0bHl7VEEANAhoT4uOMpKvcXQ==
X-Received: by 2002:a1c:a747:: with SMTP id q68mr2553755wme.180.1631107499418;
        Wed, 08 Sep 2021 06:24:59 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id a6sm2166629wmb.7.2021.09.08.06.24.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 06:24:58 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <e65f822b-419d-4555-21e8-54e11bf294b2@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: Question about async_wake
Message-ID: <dd547d1e-2132-ebc6-dd36-7cce4e870675@gmail.com>
Date:   Wed, 8 Sep 2021 14:24:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e65f822b-419d-4555-21e8-54e11bf294b2@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 12:18 PM, Hao Xu wrote:
> Hi Jens, Pavel,
> I have a question about _async_wake(), would there be cases like
> this:
>    async_cancel/poll_remove           interrupt
>      spin_lock_irq()
> list del poll->wait_entry         event happens but irq disabled
>                                   so interrupt delays
>     spin_unlock_irq()
>       generate cqe
>                                   async_wake() called and
>                                   generate cqe

wake_up*() looks for queued callbacks under that same spin, so it
won't find that cancelled entry and so won't call io_async_wake().

There might be other similar (or not) problematic cases, though.

> If it exists, there may be multiple -ECANCELED cqes for one req,
> we may do something like this to avoid it:
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 30d959416eba..7822b2f9e890 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5023,9 +5023,12 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
>         if (mask && !(mask & poll->events))
>                 return 0;
> 
> -       trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
> +       if (list_empty(&poll->wait.entry))
> +               return 0;
> +       else
> +               list_del_init(&poll->wait.entry);
> 
> -       list_del_init(&poll->wait.entry);
> +       trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
> 
>         req->result = mask;
>         req->io_task_work.func = func;

-- 
Pavel Begunkov
