Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3709D419217
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 12:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhI0KTB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 06:19:01 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:42132 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233778AbhI0KTB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 06:19:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpmM9j2_1632737841;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpmM9j2_1632737841)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 18:17:22 +0800
Subject: Re: [PATCH 2/8] io-wq: add helper to merge two wq_lists
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210927061721.180806-1-haoxu@linux.alibaba.com>
 <20210927061721.180806-3-haoxu@linux.alibaba.com>
Message-ID: <5dd03213-7239-0b5d-1ea4-3169bc1a9877@linux.alibaba.com>
Date:   Mon, 27 Sep 2021 18:17:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210927061721.180806-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/27 下午2:17, Hao Xu 写道:
> add a helper to merge two wq_lists, it will be useful in the next
> patches.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io-wq.h | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
> 
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index 8369a51b65c0..7510b05d4a86 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -39,6 +39,26 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
>   		list->last = node;
>   }
>   
> +/**
> + * wq_list_merge - merge the second list to the first one.
> + * @list0: the first list
> + * @list1: the second list
> + * after merge, list0 contains the merged list.
> + */
> +static inline void wq_list_merge(struct io_wq_work_list *list0,
> +				     struct io_wq_work_list *list1)
> +{
> +	if (!list1)
> +		return;
> +
> +	if (!list0) {
> +		list0 = list1;
> +		return;
> +	}
> +	list0->last->next = list1->first;
> +	list0->last = list1->last;
> +}
This needs some tweak, will send v2 soon.
> +
>   static inline void wq_list_add_tail(struct io_wq_work_node *node,
>   				    struct io_wq_work_list *list)
>   {
> 

