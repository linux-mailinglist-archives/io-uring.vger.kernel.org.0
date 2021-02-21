Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4011832094E
	for <lists+io-uring@lfdr.de>; Sun, 21 Feb 2021 10:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBUJRf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Feb 2021 04:17:35 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:54148 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229502AbhBUJRc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Feb 2021 04:17:32 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UP5xtde_1613899008;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UP5xtde_1613899008)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 21 Feb 2021 17:16:48 +0800
Subject: Re: [PATCH 05/18] io_uring: tie async worker side to the task context
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-6-axboe@kernel.dk>
 <45d8a997-7a1a-7d07-9039-6970acece61b@linux.alibaba.com>
 <fe6810fe-7828-a4d2-a92e-5f3c4172b94f@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <32907bb7-9a73-0b02-8951-3a0bb4555c14@linux.alibaba.com>
Date:   Sun, 21 Feb 2021 17:16:48 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <fe6810fe-7828-a4d2-a92e-5f3c4172b94f@kernel.dk>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ÔÚ 2021/2/20 ÏÂÎç10:38, Jens Axboe Ð´µÀ:
> On 2/20/21 1:11 AM, Hao Xu wrote:
>>> @@ -8167,6 +8153,14 @@ static int io_uring_alloc_task_context(struct task_struct *task)
>>>    		return ret;
>>>    	}
>>>    
>>> +	tctx->io_wq = io_init_wq_offload(ctx);
>>> +	if (IS_ERR(tctx->io_wq)) {
>>> +		ret = PTR_ERR(tctx->io_wq);
>>> +		percpu_counter_destroy(&tctx->inflight);
>>> +		kfree(tctx);
>>> +		return ret;
>>> +	}
>>> +
>> How about putting this before initing tctx->inflight so that
>> we don't need to destroy tctx->inflight in the error path?
> 
> Sure, but then we'd need to destroy the workqueue in the error path if
> percpu_counter_init() fails instead.
> 
> Can you elaborate on why you think that'd be an improvement to the error
> path?
> 
You're right. I didn't realize it..
