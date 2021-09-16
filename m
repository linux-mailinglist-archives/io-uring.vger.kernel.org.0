Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFF340D341
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 08:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbhIPGbH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Sep 2021 02:31:07 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:37882 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234579AbhIPGbH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Sep 2021 02:31:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UoYh8xZ_1631773785;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UoYh8xZ_1631773785)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 16 Sep 2021 14:29:45 +0800
Subject: Re: [PATCH] io_uring: add more uring info to fdinfo for debug
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210913130854.38542-1-haoxu@linux.alibaba.com>
 <3ecf6b05-e92d-7d74-8f72-983ec0d790fc@kernel.dk>
 <c5161c85-6e01-c949-e233-7adca5a63c46@gmail.com>
 <655da9c2-1926-370b-06f8-8e744111f3a7@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <60bfddf8-d19a-102e-21dc-bf4ea7bf9724@linux.alibaba.com>
Date:   Thu, 16 Sep 2021 14:29:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <655da9c2-1926-370b-06f8-8e744111f3a7@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/15 下午11:32, Jens Axboe 写道:
> On 9/15/21 9:31 AM, Pavel Begunkov wrote:
>> On 9/15/21 4:26 PM, Jens Axboe wrote:
>>> On 9/13/21 7:08 AM, Hao Xu wrote:
>>>> Developers may need some uring info to help themselves debug and address
>>>> issues, these info includes sqring/cqring head/tail and the detail
>>>> sqe/cqe info, which is very useful when it stucks.
>>>
>>> I think this is a good addition, more info to help you debug a stuck case
>>> is always good. I'll queue this up for 5.16.
>>
>> Are there limits how much we can print? I remember people were couldn't
>> even show a list of CPUs (was it proc?). The overflow list may be huge.
> 
> It's using seq_file, so I _think_ we should be fine here. Not sure when/if
> it truncates.
> 
It seems the default buf size of seq_file is PAGE_SIZE.

