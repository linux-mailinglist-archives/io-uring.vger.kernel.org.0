Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF93C377A19
	for <lists+io-uring@lfdr.de>; Mon, 10 May 2021 04:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhEJCXV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 May 2021 22:23:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2544 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhEJCXV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 May 2021 22:23:21 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FdlB14ykLzkYG2;
        Mon, 10 May 2021 10:19:37 +0800 (CST)
Received: from [10.174.177.210] (10.174.177.210) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 10:22:10 +0800
Subject: Re: [PATCH 16/16] io_uring: return back safer resurrect
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, <io-uring@vger.kernel.org>
References: <cover.1618101759.git.asml.silence@gmail.com>
 <7a080c20f686d026efade810b116b72f88abaff9.1618101759.git.asml.silence@gmail.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <2ac2c145-5e08-d1e3-ea13-83284a0f477a@huawei.com>
Date:   Mon, 10 May 2021 10:22:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <7a080c20f686d026efade810b116b72f88abaff9.1618101759.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.210]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



ÔÚ 2021/4/11 8:46, Pavel Begunkov Ð´µÀ:
> Revert of revert of "io_uring: wait potential ->release() on resurrect",
> which adds a helper for resurrect not racing completion reinit, as was
> removed because of a strange bug with no clear root or link to the
> patch.
> 
> Was improved, instead of rcu_synchronize(), just wait_for_completion()
> because we're at 0 refs and it will happen very shortly. Specifically
> use non-interruptible version to ignore all pending signals that may
> have ended prior interruptible wait.
> 
> This reverts commit cb5e1b81304e089ee3ca948db4d29f71902eb575.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 18 ++++++++++++++----
>   1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2a465b6e90a4..257eddd4cd82 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1083,6 +1083,18 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req)
>   	}
>   }
>   
> +static void io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
> +{
> +	bool got = percpu_ref_tryget(ref);
> +
> +	/* already at zero, wait for ->release() */
> +	if (!got)
> +		wait_for_completion(compl);
> +	percpu_ref_resurrect(ref);
> +	if (got)
> +		percpu_ref_put(ref);
> +}
> +
>   static bool io_match_task(struct io_kiocb *head,
>   			  struct task_struct *task,
>   			  struct files_struct *files)
> @@ -9798,12 +9810,11 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>   			if (ret < 0)
>   				break;
>   		} while (1);
> -
>   		mutex_lock(&ctx->uring_lock);
>   
>   		if (ret) {
> -			percpu_ref_resurrect(&ctx->refs);
> -			goto out_quiesce;
> +			io_refs_resurrect(&ctx->refs, &ctx->ref_comp);
> +			return ret;

Hi,

I have a question. Compare with the logical before this patch. We need 
call reinit_completion(&ctx->ref_comp) to make sure the effective use of 
the ref_comp.

Does we forget to do this? Or I miss something?

Thanks,
Kun.

>   		}
>   	}
>   
> @@ -9896,7 +9907,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>   	if (io_register_op_must_quiesce(opcode)) {
>   		/* bring the ctx back to life */
>   		percpu_ref_reinit(&ctx->refs);
> -out_quiesce:
>   		reinit_completion(&ctx->ref_comp);
>   	}
>   	return ret;
> 
