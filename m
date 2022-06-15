Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501AC54C4B9
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 11:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347932AbiFOJeU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 05:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243446AbiFOJeT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 05:34:19 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A099344F9
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 02:34:18 -0700 (PDT)
Message-ID: <f08c10da-5dac-a704-6c61-395f290b2ef8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655285656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uVnWZg/HEs1fcOS2NJLSf+4ItQ6nfCE4Pu/051mFP2k=;
        b=xFkKgJKruO3QcQZZWJ51apstbVoi1Zbuqjqs1ZovcPKl+yg3/mhDumDwTeFqawSSDYUqQ5
        lyj5HKamxiKAN7DzqC32VLD7wkhhWT/qFyos7rnhie8Wr1a5GV01a+babVEH2NZ8RJc43Y
        J7bqw9Er9egJ2jQlIFKfHuqMafC30Ng=
Date:   Wed, 15 Jun 2022 17:34:03 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next v2 21/25] io_uring: add
 IORING_SETUP_SINGLE_ISSUER
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <d6235e12830a225584b90cf3b29f09a0681acc95.1655213915.git.asml.silence@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <d6235e12830a225584b90cf3b29f09a0681acc95.1655213915.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/22 22:37, Pavel Begunkov wrote:
> @@ -228,7 +249,7 @@ int io_ringfd_register(struct io_ring_ctx *ctx, void __user *__arg,
>   		return -EINVAL;
>   
>   	mutex_unlock(&ctx->uring_lock);
> -	ret = io_uring_add_tctx_node(ctx);
> +	ret = __io_uring_add_tctx_node(ctx, false);

An question unrelated with this patch: why do we need this, since anyway
we will do it in later io_uring_enter() this task really submits reqs.

>   	mutex_lock(&ctx->uring_lock);
>   	if (ret)
>   		return ret;
