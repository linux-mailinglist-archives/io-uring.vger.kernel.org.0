Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3FA218B1A6
	for <lists+io-uring@lfdr.de>; Thu, 19 Mar 2020 11:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgCSKlv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Mar 2020 06:41:51 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39744 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgCSKlu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Mar 2020 06:41:50 -0400
Received: by mail-lj1-f195.google.com with SMTP id a2so1870641ljk.6
        for <io-uring@vger.kernel.org>; Thu, 19 Mar 2020 03:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Mxo6LoS99YtEeUPHE9LapDhTXS6jLlRyhbksXfLAMCI=;
        b=YBt1MvNSIo3u+dymgDaX5+uO60o3t/I9hgf/WV7ZZM4yb8nXeoaxThtwUHNQy/NIKi
         tQA3/vzfx2ujThurrUKixGdld2w9+NOHmhLCGDc/kGPvWI2Edpz7kmbA1kMVj5Wtatlm
         5pggdJLkaAv7/pZSMGcCR8Hac1/qHC8ZnoECtOGHlnYWinPJIbbuylZCjogF9flfyj/E
         /9Ku7iqnLdXYKyc7TSPfpQBCnV4IvkOIjhpQmCD47it2+BQn8ArUNlCSUVgeG+ij+6YW
         lPfQ/r5RXk74uwU0F6xzIKdGRt3wWNHVW06xnweEibiNaQSqLxtyJFXItNhgsoBT3Vq1
         qJRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mxo6LoS99YtEeUPHE9LapDhTXS6jLlRyhbksXfLAMCI=;
        b=oCfL4weOvwtfaIhibk8Yzx4HJf5F0QKHOxTy44W/7e6Ep/4hEbLygyWde4zpMQKadj
         td3EwGTM9A4dGCUqgKH2UMsng5URBpwLV6kenhlkAeryixxdzhPhuSLsALXFfIlxDbSU
         uuXL3jWg8DzsXhgDBbi0J+4xe8UDiDDUN7ujEkZLAvyrO4k0XvPmRBi+Wi6Ppz97AiRI
         sIqBM1Qx3TtD+/VSgKLNvmvNoK74tjeg/jsDPI9DMutqeOJBXV1ng8hEDm6umX+fCbEd
         iHjOI0KcPYHFAr0CWXt/62ChrsPurbHgs2uHpXl6CeKOQJOCc9p1msS+xuVglTymWIEk
         nVFw==
X-Gm-Message-State: ANhLgQ0bFp3xJDzMXf5nJXMkLh1zqv+57Fkq9JIgahpjAz+UlkG1GauS
        wqpsdvfzStmNvlhHl7S05/c4tj/N
X-Google-Smtp-Source: ADFU+vvjBafGfTo7S3cEW3Pml3b8sUvBDo/f18JfAYo2IxdU39Flz3e2V8kaZa7PMfXxEfzONm9xTA==
X-Received: by 2002:a05:651c:103b:: with SMTP id w27mr1773409ljm.245.1584614506946;
        Thu, 19 Mar 2020 03:41:46 -0700 (PDT)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id q2sm1429025lfh.36.2020.03.19.03.41.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 03:41:46 -0700 (PDT)
Subject: Re: [PATCH] io_uring: REQ_F_FORCE_ASYNC prep done too late
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <d9c7608a-a5c5-8082-1b74-90ce690288b4@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <aa52134d-5e0c-6de2-ebdd-f77119fb7b00@gmail.com>
Date:   Thu, 19 Mar 2020 13:41:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <d9c7608a-a5c5-8082-1b74-90ce690288b4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/19/2020 6:51 AM, Jens Axboe wrote:
> A previous patch ensured that we always prepped requests that are
> forced async, but it did so too late in the process. This can result
> in 'sqe' already being NULL by the time we get to it:

Isn't it fixed by f1d96a8fcbbbb ("io_uring: NULL-deref for
IOSQE_{ASYNC,DRAIN}")? BTW, the same can happen with draining in
io_req_defer() -> io_req_defer_prep().

Can't look through your patches/RFC properly, but I will try do that
this weekends.


> BUG: kernel NULL pointer dereference, address: 0000000000000008
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0 
> Oops: 0000 [#1] PREEMPT SMP
> CPU: 2 PID: 331 Comm: read-write Not tainted 5.6.0-rc5+ #5846
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> RIP: 0010:io_prep_rw+0x37/0x250
> Code: 41 89 d4 55 48 89 f5 53 48 8b 0f 48 89 fb 4c 8b 6f 50 48 8b 41 20 0f b7 00 66 25 00 f0 66 3d 00 80 75 07 81 4f 68 00 40 00 00 <48> 8b 45 08 48 83 f8 ff 48 89 43 08 0f 84 c6 01 00 00 8b 41 34 85
> RSP: 0018:ffffc900003ebce8 EFLAGS: 00010206
> RAX: 0000000000008000 RBX: ffff8881adf87b00 RCX: ffff8881b7db4f00
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8881adf87b00
> RBP: 0000000000000000 R08: ffff8881adf87b88 R09: ffff8881adf87b88
> R10: 0000000000001000 R11: ffffea0006ddee08 R12: 0000000000000001
> R13: ffff8881b325c000 R14: 0000000000000000 R15: ffff8881b325c000
> FS:  00007f642a59e540(0000) GS:ffff8881b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000008 CR3: 00000001b3674004 CR4: 00000000001606e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  io_write_prep+0x1c/0x100
>  io_queue_sqe+0x8f/0x2a0
>  io_submit_sqes+0x450/0xa10
>  __do_sys_io_uring_enter+0x272/0x610
>  ? ksys_mmap_pgoff+0x15d/0x1f0
>  do_syscall_64+0x42/0x100
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7f642a4d0f8d
> Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d3 4e 0c 00 f7 d8 64 89 01 48
> 
> Fix this by ensuring we do prep at io_submit_sqe() time, where we
> know we still have the original sqe.
> 
> Fixes: 1118591ab883 ("io_uring: prep req when do IOSQE_ASYNC")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e6049546e77c..ff35f5ac91ea 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5528,15 +5528,11 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	ret = io_req_defer(req, sqe);
>  	if (ret) {
>  		if (ret != -EIOCBQUEUED) {
> -fail_req:
>  			io_cqring_add_event(req, ret);
>  			req_set_fail_links(req);
>  			io_double_put_req(req);
>  		}
>  	} else if (req->flags & REQ_F_FORCE_ASYNC) {
> -		ret = io_req_defer_prep(req, sqe);
> -		if (unlikely(ret < 0))
> -			goto fail_req;
>  		/*
>  		 * Never try inline submit of IOSQE_ASYNC is set, go straight
>  		 * to async execution.
> @@ -5650,12 +5646,21 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  			req->flags |= REQ_F_IO_DRAIN;
>  			req->ctx->drain_next = 0;
>  		}
> +		if (sqe_flags & REQ_F_FORCE_ASYNC) {
> +			ret = io_req_defer_prep(req, sqe);
> +			if (ret < 0)
> +				goto err_req;
> +			/* prep done */
> +			sqe = NULL;
> +		}
>  		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>  			req->flags |= REQ_F_LINK;
>  			INIT_LIST_HEAD(&req->link_list);
> -			ret = io_req_defer_prep(req, sqe);
> -			if (ret)
> -				req->flags |= REQ_F_FAIL_LINK;
> +			if (sqe) {
> +				ret = io_req_defer_prep(req, sqe);
> +				if (ret)
> +					req->flags |= REQ_F_FAIL_LINK;
> +			}
>  			*link = req;
>  		} else {
>  			io_queue_sqe(req, sqe);
> 

-- 
Pavel Begunkov
