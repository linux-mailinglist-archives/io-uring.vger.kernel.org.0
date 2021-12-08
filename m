Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCC846CCD3
	for <lists+io-uring@lfdr.de>; Wed,  8 Dec 2021 06:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhLHFMB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Dec 2021 00:12:01 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:55759 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230316AbhLHFMA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Dec 2021 00:12:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UzquLr0_1638940107;
Received: from 30.226.12.31(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UzquLr0_1638940107)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Dec 2021 13:08:27 +0800
Subject: Re: [PATCH 5/5] io_uring: batch completion in prior_task_list
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211207093951.247840-1-haoxu@linux.alibaba.com>
 <20211207093951.247840-6-haoxu@linux.alibaba.com>
 <fc9a8ac2-f339-a5c4-a85d-19d8c324a311@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <afedeffa-85c1-58ba-7ff7-6abed73baadc@linux.alibaba.com>
Date:   Wed, 8 Dec 2021 13:08:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <fc9a8ac2-f339-a5c4-a85d-19d8c324a311@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

在 2021/12/8 上午5:01, Pavel Begunkov 写道:
> On 12/7/21 09:39, Hao Xu wrote:
>> In previous patches, we have already gathered some tw with
>> io_req_task_complete() as callback in prior_task_list, let's complete
>> them in batch while we cannot grab uring lock. In this way, we batch
>> the req_complete_post path.
>>
>> Tested-by: Pavel Begunkov <asml.silence@gmail.com>
>
> Hao, please never add tags for other people unless they confirmed
> that it's fine. I asked Jens to kill this one and my signed-off
> from 4/5 from io_uring branches.
>
Apologize for that, I'll remember this rule.


Regards,
Hao

