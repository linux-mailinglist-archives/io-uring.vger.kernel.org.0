Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E8941B46E
	for <lists+io-uring@lfdr.de>; Tue, 28 Sep 2021 18:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241837AbhI1Quq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Sep 2021 12:50:46 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:63297 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229795AbhI1Qup (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Sep 2021 12:50:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpxczWk_1632847733;
Received: from 192.168.31.215(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpxczWk_1632847733)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 29 Sep 2021 00:48:53 +0800
Subject: Re: [PATCH 2/8] io-wq: add helper to merge two wq_lists
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210927061721.180806-1-haoxu@linux.alibaba.com>
 <20210927061721.180806-3-haoxu@linux.alibaba.com>
 <e01e512d-2666-ae0d-2e26-ca5368f58aae@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <2fcd4b88-af21-53e0-0f5a-e15f87182df6@linux.alibaba.com>
Date:   Wed, 29 Sep 2021 00:48:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e01e512d-2666-ae0d-2e26-ca5368f58aae@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/28 下午7:10, Pavel Begunkov 写道:
> On 9/27/21 7:17 AM, Hao Xu wrote:
>> add a helper to merge two wq_lists, it will be useful in the next
>> patches.
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io-wq.h | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/fs/io-wq.h b/fs/io-wq.h
>> index 8369a51b65c0..7510b05d4a86 100644
>> --- a/fs/io-wq.h
>> +++ b/fs/io-wq.h
>> @@ -39,6 +39,26 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
>>   		list->last = node;
>>   }
>>   
>> +/**
>> + * wq_list_merge - merge the second list to the first one.
>> + * @list0: the first list
>> + * @list1: the second list
>> + * after merge, list0 contains the merged list.
>> + */
>> +static inline void wq_list_merge(struct io_wq_work_list *list0,
>> +				     struct io_wq_work_list *list1)
>> +{
>> +	if (!list1)
>> +		return;
>> +
>> +	if (!list0) {
>> +		list0 = list1;
> 
> It assigns a local var and returns, the assignment will be compiled
> out, something is wrong
True, I've corrected it in v2.
> 
>> +		return;
>> +	}
>> +	list0->last->next = list1->first;
>> +	list0->last = list1->last;
>> +}
>> +
>>   static inline void wq_list_add_tail(struct io_wq_work_node *node,
>>   				    struct io_wq_work_list *list)
>>   {
>>
> 

