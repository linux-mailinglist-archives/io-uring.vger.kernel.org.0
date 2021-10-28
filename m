Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261B243E8FC
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 21:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhJ1Tb1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 15:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhJ1Tb0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 15:31:26 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF53C061570
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 12:28:57 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v127so6750183wme.5
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 12:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vyNg4tTDGRU/1RCQtNRBGsaPiTgIRjZb8xqLHQEmAYw=;
        b=dDDf/C6bRp7QIPuonhMJ/Ok7gnuYK3LjegJ8BEsDYO+uTg8uNxjKj2i8LbY7HVM57m
         l9e7uC4cIXcxxZna50RUyNM12OAEG1b3wvHttybti5kF/HYY+hIkJTLtSPWMtsblQCr9
         rlHq/pJB8x8OtkOxLy/n9vKH4ibmwwB5MaVeZ4QWDrKkTX1R9D1iL+1haU8+bTfzFnIk
         cdq0exeeX+U51mSsLwm6yTgqgln/Fe5r/aCvsyBnkI7t2z5gaOuLWnzUJuTFIWpM99Qp
         y3ZHQDYoHn0m97t+NMbMDeMKMtgeeB8Fn4m59uNOrGGN1HG9rYm1mjZloWOtzT+XKLwY
         mixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vyNg4tTDGRU/1RCQtNRBGsaPiTgIRjZb8xqLHQEmAYw=;
        b=VDwDzBctLovHjja3lPlhDXe2aIbQjpVWdY4tdZ5Q2m30aGEVJ7F+sDI+iTZdtTT7jk
         LGR7MMQY0sD7EryaKWjqEduN5CLKbxL1NXLTEngrnMolglcNLYhUJkWqoA6pKHdbLmG7
         ZBDkDhXQXmcfWY83EprUzXNUE1THvbPHXWLJ2aWVCa60zjHrF3Kyh5iVqLQZFSMyrCZI
         +88TcuGbJuxdiuJAyN3w/5Lq6m6kDhgHCXj09l+pawPVARLZk8HGqcQfcQ2lhuSh9AF/
         alOwZ1H5iNndjQdsMgW0qs0C0lGnpexbeLNEyFTv8Q4lEQLEXc1my1q2St4w/DhebQ8N
         ut6Q==
X-Gm-Message-State: AOAM530xHZTPSNRZXDzebLMgV8zRJrquaIAB4n/3lx5LHGxS19+xjBuc
        3RCSBs0Y2wiSd6QlIAXygjY=
X-Google-Smtp-Source: ABdhPJw0cMNZ01oIUZ4fDIck/JU6uCFG7WkhESRQdwWpCqhLxSNkrEGaKVSDGzbnCiYmT3L2g+WF3g==
X-Received: by 2002:a7b:cb12:: with SMTP id u18mr6523461wmj.109.1635449336219;
        Thu, 28 Oct 2021 12:28:56 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.16])
        by smtp.gmail.com with ESMTPSA id v191sm3397983wme.36.2021.10.28.12.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 12:28:55 -0700 (PDT)
Message-ID: <af6423ee-134c-007e-44bc-6f43a22e1e5d@gmail.com>
Date:   Thu, 28 Oct 2021 20:26:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 3/3] io_uring: don't get completion_lock in
 io_poll_rewait()
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
 <20211025053849.3139-4-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211025053849.3139-4-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/25/21 06:38, Xiaoguang Wang wrote:
> In current implementation, if there are not available events,
> io_poll_rewait() just gets completion_lock, and unlocks it in
> io_poll_task_func() or io_async_task_func(), which isn't necessary.
> 
> Change this logic to let io_poll_task_func() or io_async_task_func()
> get the completion_lock lock.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>   fs/io_uring.c | 58 ++++++++++++++++++++++++++--------------------------------
>   1 file changed, 26 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e4c779dac953..41ff8fdafe55 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5248,10 +5248,7 @@ static inline int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *pol
>   }
>   
>   static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
> -	__acquires(&req->ctx->completion_lock)
>   {
> -	struct io_ring_ctx *ctx = req->ctx;
> -
>   	/* req->task == current here, checking PF_EXITING is safe */
>   	if (unlikely(req->task->flags & PF_EXITING))
>   		WRITE_ONCE(poll->canceled, true);
> @@ -5262,7 +5259,6 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
>   		req->result = vfs_poll(req->file, &pt) & poll->events;
>   	}
>   
> -	spin_lock(&ctx->completion_lock);

Don't remember poll sync too well but this was synchronising with the
final section of __io_arm_poll_handler(), and I'm afraid it may go
completely loose with races.


>   	if (!req->result && !READ_ONCE(poll->canceled)) {
>   		if (req->opcode == IORING_OP_POLL_ADD)
>   			WRITE_ONCE(poll->active, true);
-- 
Pavel Begunkov
