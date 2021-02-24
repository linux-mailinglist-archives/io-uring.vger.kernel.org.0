Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1243323631
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 04:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbhBXDsT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 22:48:19 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:40963 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232147AbhBXDsR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 22:48:17 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UPQGkig_1614138454;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UPQGkig_1614138454)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Feb 2021 11:47:35 +0800
Subject: Re: [PATCH v2 1/1] io_uring: allocate memory for overflowed CQEs
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <a5e833abf8f7a55a38337e5c099f7d0f0aa8746d.1614083504.git.asml.silence@gmail.com>
 <f57545fb-a109-0881-ff14-f371d1a9d811@linux.alibaba.com>
 <fda005e8-d16d-6563-d526-440deb7737f6@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <1c7f2163-8355-4479-9842-a8a513b9855d@linux.alibaba.com>
Date:   Wed, 24 Feb 2021 11:47:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <fda005e8-d16d-6563-d526-440deb7737f6@kernel.dk>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/2/24 上午11:18, Jens Axboe 写道:
> On 2/23/21 8:06 PM, Hao Xu wrote:
>> 在 2021/2/23 下午8:40, Pavel Begunkov 写道:
>>> Instead of using a request itself for overflowed CQE stashing, allocate
>>> a separate entry. The disadvantage is that the allocation may fail and
>>> it will be accounted as lost (see rings->cq_overflow), so we lose
>>> reliability in case of memory pressure. However, it opens a way for for
>>> multiple CQEs per an SQE and even generating SQE-less CQEs >
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>> Hi Pavel,
>> Allow me to ask a stupid question, why do we need to support multiple
>> CQEs per SQE or even SQE-less CQEs in the future?
> 
> Not a stupid question at all, since it's not something we've done
> before. There's been discussion about this in the past, in the presence
> of the zero copy IO where we ideally want to post two CQEs for an SQE.
> Most recently I've been playing with multishot poll support, where a
> POLL_ADD will stay active after triggering. Hence you could be posting
> many CQEs for that SQE, over the life time of the request.
> 
I see, super thanks Jens.
