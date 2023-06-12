Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187C872C65D
	for <lists+io-uring@lfdr.de>; Mon, 12 Jun 2023 15:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236659AbjFLNsA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jun 2023 09:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236646AbjFLNrw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jun 2023 09:47:52 -0400
Received: from out-50.mta0.migadu.com (out-50.mta0.migadu.com [IPv6:2001:41d0:1004:224b::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B74199C
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 06:47:46 -0700 (PDT)
Message-ID: <85a0bfd6-5e7b-0599-0f7f-96604bfce160@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686577664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uL6XwpQ3XgfJMzir+1WHSrYFYcgtPiHvXWJTPW9MYrU=;
        b=NBeGcysWRmuFgFnbqWG9Zv+R+8/TnPW13gGlhvKccq3OZPH07gioDxYxXkOUXsfa4xZh7l
        tnUFaEP0QHFo+zlKyg8T+NGSklSBuhj59VdrD9pL9TzhTn3NLpsxNisH2htPdfcnxaWp20
        LxKGvPfMQWSCaujeQtyieIbCA2JZrpI=
Date:   Mon, 12 Jun 2023 21:47:40 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 07/11] io_uring: add new api to register fixed workers
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Linux Fsdevel Mailing List <linux-fsdevel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20230609122031.183730-1-hao.xu@linux.dev>
 <20230609122031.183730-8-hao.xu@linux.dev>
 <ZIMvKkZZzAfVLGbj@biznet-home.integral.gnuweeb.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZIMvKkZZzAfVLGbj@biznet-home.integral.gnuweeb.org>
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

On 6/9/23 21:54, Ammar Faizi wrote:
> On Fri, Jun 09, 2023 at 08:20:27PM +0800, Hao Xu wrote:
>> +static __cold int io_register_iowq_fixed_workers(struct io_ring_ctx *ctx,
>> +					       void __user *arg, int nr_args)
>> +	__must_hold(&ctx->uring_lock)
>> +{
>> +	struct io_uring_task *tctx = NULL;
>> +	struct io_sq_data *sqd = NULL;
>> +	struct io_uring_fixed_worker_arg *res;
>> +	size_t size;
>> +	int i, ret;
>> +	bool zero = true;
>> +
>> +	size = array_size(nr_args, sizeof(*res));
>> +	if (size == SIZE_MAX)
>> +		return -EOVERFLOW;
>> +
>> +	res = memdup_user(arg, size);
>> +	if (IS_ERR(res))
>> +		return PTR_ERR(res);
>> +
>> +	for (i = 0; i < nr_args; i++) {
>> +		if (res[i].nr_workers) {
>> +			zero = false;
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (zero)
>> +		return 0;
> 
> You have a memory leak bug here. The memdup_user() needs clean up.
> kfree(res);
> 

True, I'll fix it in v2, thanks.
