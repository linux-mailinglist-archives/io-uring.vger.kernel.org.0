Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981D672C649
	for <lists+io-uring@lfdr.de>; Mon, 12 Jun 2023 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbjFLNqu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jun 2023 09:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234891AbjFLNqn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jun 2023 09:46:43 -0400
Received: from out-52.mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9779312A
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 06:46:41 -0700 (PDT)
Message-ID: <f3bff638-ab76-328e-eb42-280ed42e0b27@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686577599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G+8ILE92w0iCoIGaVy3iacQBBXufXevmrNQESGOsCvw=;
        b=bGTS6Y3cBmxTcU2VsrNzNxPgEBJIoplDVMZySoCFLG7lANUk2aWTnXiiKY2bGrzTlkyuKo
        wr6dX4gqLK/PlTHxrl2m3+y4Ve0KVAg87BvlxtSLdBoVmg5vPbfnSjf7VBHllQokvKLwoR
        SwTVJ+dYB9UZMV/w9xhegfyxWsEZIjU=
Date:   Mon, 12 Jun 2023 21:46:33 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 07/11] io_uring: add new api to register fixed workers
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Linux Fsdevel Mailing List <linux-fsdevel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20230609122031.183730-1-hao.xu@linux.dev>
 <20230609122031.183730-8-hao.xu@linux.dev>
 <ZIMkGh3kI0tfoxxp@biznet-home.integral.gnuweeb.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZIMkGh3kI0tfoxxp@biznet-home.integral.gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Ammar,

On 6/9/23 21:07, Ammar Faizi wrote:
> On Fri, Jun 09, 2023 at 08:20:27PM +0800, Hao Xu wrote:
>> +	rcu_read_lock();
>> +
>> +	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
>> +		unsigned int nr = count[i].nr_workers;
>> +
>> +		acct = &wq->acct[i];
>> +		acct->fixed_nr = nr;
>> +		acct->fixed_workers = kcalloc(nr, sizeof(struct io_worker *),
>> +					      GFP_KERNEL);
>> +		if (!acct->fixed_workers) {
>> +			ret = -ENOMEM;
>> +			break;
>> +		}
>> +
>> +		for (j = 0; j < nr; j++) {
>> +			struct io_worker *worker =
>> +				io_wq_create_worker(wq, acct, true);
>> +			if (IS_ERR(worker)) {
>> +				ret = PTR_ERR(worker);
>> +				break;
>> +			}
>> +			acct->fixed_workers[j] = worker;
>> +		}
>> +		if (j < nr)
>> +			break;
>> +	}
>> +	rcu_read_unlock();
> 
> This looks wrong. kcalloc() with GFP_KERNEL may sleep. Note that you're
> not allowed to sleep inside the RCU read lock critical section.
> 
> Using GFP_KERNEL implies GFP_RECLAIM, which means that direct reclaim
> may be triggered under memory pressure; the calling context must be
> allowed to sleep.
> 

I think you are right, I'll fix it in v2.

Hi Jens, ask a question about this: I saw same rcu_read_lock() in 
io_wq_max_workers(), but what is it really protect?

Regards,
Hao
