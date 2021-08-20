Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4C53F2909
	for <lists+io-uring@lfdr.de>; Fri, 20 Aug 2021 11:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhHTJWP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 05:22:15 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:55022 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232380AbhHTJWP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 05:22:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UkJN2Zf_1629451295;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UkJN2Zf_1629451295)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 20 Aug 2021 17:21:36 +0800
Subject: Re: [PATCH 1/3] io_uring: flush completions for fallbacks
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1629286357.git.asml.silence@gmail.com>
 <8b941516921f72e1a64d58932d671736892d7fff.1629286357.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <a02fcefe-3a55-51fb-9184-6a49596226cf@linux.alibaba.com>
Date:   Fri, 20 Aug 2021 17:21:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <8b941516921f72e1a64d58932d671736892d7fff.1629286357.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/18 下午7:42, Pavel Begunkov 写道:
> io_fallback_req_func() doesn't expect anyone creating inline
> completions, and no one currently does that. Teach the function to flush
> completions preparing for further changes.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 3da9f1374612..ba087f395507 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1197,6 +1197,11 @@ static void io_fallback_req_func(struct work_struct *work)
>   	percpu_ref_get(&ctx->refs);
>   	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
>   		req->io_task_work.func(req);
> +
> +	mutex_lock(&ctx->uring_lock);
> +	if (ctx->submit_state.compl_nr)
> +		io_submit_flush_completions(ctx);
> +	mutex_unlock(&ctx->uring_lock);
why do we protect io_submit_flush_completions() with uring_lock,
regarding that it is called in original context. Btw, why not
use ctx_flush_and_put()
>   	percpu_ref_put(&ctx->refs);
>   }
>   
> 

