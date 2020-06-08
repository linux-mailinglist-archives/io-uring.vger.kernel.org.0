Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307591F1896
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 14:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgFHMOi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Jun 2020 08:14:38 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:47633 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729665AbgFHMOh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Jun 2020 08:14:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01419;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U-zzX55_1591618474;
Received: from 30.225.32.164(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U-zzX55_1591618474)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Jun 2020 20:14:34 +0800
Subject: Re: [PATCH v5 2/2] io_uring: avoid unnecessary io_wq_work copy for
 fast poll feature
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
 <20200601045626.9291-1-xiaoguang.wang@linux.alibaba.com>
 <20200601045626.9291-2-xiaoguang.wang@linux.alibaba.com>
 <f7c648e7-f154-f4eb-586f-841f08b845fd@linux.alibaba.com>
 <8accdc46-53c9-cf89-1e61-51e7c269411c@gmail.com>
 <9f540577-0c13-fa4b-43c1-3c4d7cddcb8c@kernel.dk>
 <13c85adb-6502-f9c7-ed66-9a0adffa2dc8@gmail.com>
 <570f0f74-82a7-2f10-b186-582380200b15@gmail.com>
 <35bcf4cb-1985-74aa-5748-6ee4095acb20@kernel.dk>
 <820263b3-b5e5-bca9-eedb-4ee4e23be2b7@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <276f5b33-8adc-a664-2490-8d237b719d28@linux.alibaba.com>
Date:   Mon, 8 Jun 2020 20:14:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <820263b3-b5e5-bca9-eedb-4ee4e23be2b7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 08/06/2020 02:29, Jens Axboe wrote:
>> On 6/7/20 2:57 PM, Pavel Begunkov wrote:
>>> -#define INIT_IO_WORK(work, _func)				\
>>> +#define INIT_IO_WORK(work)					\
>>>   	do {							\
>>> -		*(work) = (struct io_wq_work){ .func = _func };	\
>>> +		*(work) = (struct io_wq_work){};		\
>>>   	} while (0)						\
>>>   
>>
>> Would be nice to optimize this one, it's a lot of clearing for something
>> we'll generally not use at all in the fast path. Or at least keep it
>> only for before when we submit the work for async execution.
> 
> Let's leave it to Xiaoguang and the series of the topic.
Yeah, I'd be glad to continue this job, thanks.

Regards,
Xiaoguang Wang
> 
>>
>>  From a quick look at this, otherwise looks great! Please do split and
>> submit this.
> 
> Sure. Have great time off!
> 
> 
