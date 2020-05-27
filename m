Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6101E4A8B
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2020 18:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbgE0Qlj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 May 2020 12:41:39 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:35077 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729134AbgE0Qli (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 May 2020 12:41:38 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TzpPrAH_1590597666;
Received: from 30.39.180.53(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TzpPrAH_1590597666)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 May 2020 00:41:06 +0800
Subject: Re: [PATCH 1/3] io_uring: don't use req->work.creds for inline
 requests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200526064330.9322-1-xiaoguang.wang@linux.alibaba.com>
 <fe4196c6-a069-a029-6a98-68801d088798@gmail.com>
 <06081761-4aef-6423-ac70-97c62a7c0e5c@linux.alibaba.com>
 <dc2f20fd-dd81-bc21-cd02-747b523dd915@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <52fbb449-39f7-e46a-422a-1c4d5e0ba737@linux.alibaba.com>
Date:   Thu, 28 May 2020 00:41:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <dc2f20fd-dd81-bc21-cd02-747b523dd915@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi Pavel,

> On 26/05/2020 17:59, Xiaoguang Wang wrote:
>> hi,
>>
>>> On 26/05/2020 09:43, Xiaoguang Wang wrote:
>>>> In io_init_req(), if uers requires a new credentials, currently we'll
>>>> save it in req->work.creds, but indeed io_wq_work is designed to describe
>>>> needed running environment for requests that will go to io-wq, if one
>>>> request is going to be submitted inline, we'd better not touch io_wq_work.
>>>> Here add a new 'const struct cred *creds' in io_kiocb, if uers requires a
>>>> new credentials, inline requests can use it.
>>>>
>>>> This patch is also a preparation for later patch.
>>>
>>> What's the difference from keeping only one creds field in io_kiocb (i.e.
>>> req->work.creds), but handling it specially (i.e. always initialising)? It will
>>> be a lot easier than tossing it around.
>>>
>>> Also, the patch doubles {get,put}_creds() for sqe->personality case, and that's
>>> extra atomics without a good reason.
>> You're right, thanks.
>> The original motivation for this patch is that it's just a preparation later patch
>> "io_uring: avoid whole io_wq_work copy for inline requests", I can use
>> io_wq_work.func
>> to determine whether to drop io_wq_work in io_req_work_drop_env(), so if
>> io_wq_work.func
>> is NULL, I don't want io_wq_work has a valid creds.
>> I'll look into whether we can just assign req->creds's pointer to
>> io_wq_work.creds to
>> reduce the atomic operations.
> 
> See a comment for the [2/3], can spark some ideas.
> 
> It's a bit messy and makes it more difficult to keep in mind -- all that extra
> state (i.e. initialised or not) + caring whether func was already set. IMHO, the
> nop-test do not really justifies extra complexity, unless the whole stuff is
> pretty and clear. Can you benchmark something more realistic? at least
> reads/writes to null_blk (completion_nsec=0).
Indeed for this patch set, I also don't expect any obvious performance improvement,
just think current codes are not good, so try to improve it.
I will send a v2 version later, in which I'll use null_blk to evaluate performance,
please have a check.

Regards,
Xiaoguang Wang


> 
