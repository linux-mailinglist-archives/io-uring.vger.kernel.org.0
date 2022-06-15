Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC7454C3EC
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 10:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243453AbiFOIrX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 04:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346392AbiFOIqX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 04:46:23 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885FA4C403
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 01:46:21 -0700 (PDT)
Message-ID: <ac7caacc-4099-5f92-3254-520c4d2da3ec@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655282780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KM0Wu115rxLGmy81sZ8BZGUn+xzo5/Bo7BrZWcdjoVc=;
        b=oYI5QVsQ5Kv1gI8LX3BcXKOmj5C0pPj4Bn6gfeAKhd3tgSAsoEIED0DHXsP72aCMp2e49U
        0S/xOrGgknbyseUmXI8LCvlMYU10zczOTypy3ZBbbcBwQxr4ES5yYALfbs07FbJOJ2RFXT
        GGcbIzxdXaaXWm63YYXjxn9KMhAeC18=
Date:   Wed, 15 Jun 2022 16:46:15 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next v2 19/25] io_uring: clean up io_ring_ctx_alloc
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <3d6a3659fcb7d777530b5cc67aac3e036a212dda.1655213915.git.asml.silence@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <3d6a3659fcb7d777530b5cc67aac3e036a212dda.1655213915.git.asml.silence@gmail.com>
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
> Add a variable for the number of hash buckets in io_ring_ctx_alloc(),
> makes it more readable.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/io_uring.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 2a7a5db12a0e..15d209f334eb 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -700,6 +700,8 @@ static __cold void io_fallback_req_func(struct work_struct *work)
>   static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   {
>   	struct io_ring_ctx *ctx;
> +	unsigned hash_buckets;

personally prefer nr_something like nr_buckets or nr_hash_buckets

