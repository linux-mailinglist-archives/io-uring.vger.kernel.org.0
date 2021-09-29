Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D151441C001
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 09:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244647AbhI2Hhn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 03:37:43 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:54920 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244650AbhI2Hhn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 03:37:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uq.YZUB_1632900960;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uq.YZUB_1632900960)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 29 Sep 2021 15:36:00 +0800
Subject: Re: [PATCH 1/8] io-wq: code clean for io_wq_add_work_after()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210927061721.180806-1-haoxu@linux.alibaba.com>
 <20210927061721.180806-2-haoxu@linux.alibaba.com>
 <ec45dd61-194b-3611-dcd6-2a5440099575@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <140f1e02-d400-b6c7-5c78-5eab6ac23f24@linux.alibaba.com>
Date:   Wed, 29 Sep 2021 15:36:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ec45dd61-194b-3611-dcd6-2a5440099575@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/28 下午7:08, Pavel Begunkov 写道:
> On 9/27/21 7:17 AM, Hao Xu wrote:
>> Remove a local variable.
> 
> It's there to help alias analysis, which usually can't do anything
> with pointer heavy logic. Compare ASMs below, before and after
> respectively:
> 	testq	%rax, %rax	# next
> 
> replaced with
> 	cmpq	$0, (%rdi)	#, node_2(D)->next
> 
> One extra memory dereference and a bigger binary
> 
> 
> =====================================================
> 
> wq_list_add_after:
> # fs/io_uring.c:271: 	struct io_wq_work_node *next = pos->next;
> 	movq	(%rsi), %rax	# pos_3(D)->next, next
> # fs/io_uring.c:273: 	pos->next = node;
> 	movq	%rdi, (%rsi)	# node, pos_3(D)->next
> # fs/io_uring.c:275: 	if (!next)
> 	testq	%rax, %rax	# next
> # fs/io_uring.c:274: 	node->next = next;
> 	movq	%rax, (%rdi)	# next, node_5(D)->next
> # fs/io_uring.c:275: 	if (!next)
> 	je	.L5927	#,
> 	ret	
> .L5927:
> # fs/io_uring.c:276: 		list->last = node;
> 	movq	%rdi, 8(%rdx)	# node, list_8(D)->last
> 	ret	
> 
> =====================================================
> 
> wq_list_add_after:
> # fs/io-wq.h:48: 	node->next = pos->next;
> 	movq	(%rsi), %rax	# pos_3(D)->next, _5
> # fs/io-wq.h:48: 	node->next = pos->next;
> 	movq	%rax, (%rdi)	# _5, node_2(D)->next
> # fs/io-wq.h:49: 	pos->next = node;
> 	movq	%rdi, (%rsi)	# node, pos_3(D)->next
> # fs/io-wq.h:50: 	if (!node->next)
> 	cmpq	$0, (%rdi)	#, node_2(D)->next
hmm, this is definitely not good, not sure why this is not optimised to
cmpq $0, %rax (haven't touched assembly for a long time..)
> 	je	.L5924	#,
> 	ret	
> .L5924:
> # fs/io-wq.h:51: 		list->last = node;
> 	movq	%rdi, 8(%rdx)	# node, list_4(D)->last
> 	ret	
> 
> 
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io-wq.h | 6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/io-wq.h b/fs/io-wq.h
>> index bf5c4c533760..8369a51b65c0 100644
>> --- a/fs/io-wq.h
>> +++ b/fs/io-wq.h
>> @@ -33,11 +33,9 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
>>   				     struct io_wq_work_node *pos,
>>   				     struct io_wq_work_list *list)
>>   {
>> -	struct io_wq_work_node *next = pos->next;
>> -
>> +	node->next = pos->next;
>>   	pos->next = node;
>> -	node->next = next;
>> -	if (!next)
>> +	if (!node->next)
>>   		list->last = node;
>>   }
>>   
>>
> 

