Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1B0729C0A
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 15:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjFINzF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 09:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240418AbjFINzE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 09:55:04 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7260F210D;
        Fri,  9 Jun 2023 06:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1686318901;
        bh=UngRapVyTmTrX3eSqSfnf/EGS5RqE7Xw+jcoVn2rgQE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=hYeH2pUQ+XlCSm3fEpl39n/LTqeW8ZvA+FmCNaW4D8ywPDT5ilReQ2x9A/B+R7oYy
         ZJ67SQAPnCVv8fI1RXIv2wPNXp0G9BEvjm3SLiuQcmnaPQiukyE8CWXQgbIFlPmrbX
         2yS7iAPre7xm+gaCANAbR3VhEkcE7MUPbZDBXFlBW6ExZXONOiiwbzSX8HsNo0I25l
         Pa6Ka9mQHqTxXToDWlLCkH4kReOWK3MVenfYL5/BNS3V4JWG5797XKae1yHhoS+REY
         mx2tox3xprSPXGWEHY2942jdpk/wbOauTYfT42WBolTowxRc1/XYQmaEFs00N13Afp
         YZOjZC0Xv0Jwg==
Received: from biznet-home.integral.gnuweeb.org (unknown [103.74.5.63])
        by gnuweeb.org (Postfix) with ESMTPSA id 03C0823EC4C;
        Fri,  9 Jun 2023 20:54:59 +0700 (WIB)
Date:   Fri, 9 Jun 2023 20:54:50 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Linux Fsdevel Mailing List <linux-fsdevel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: Re: [PATCH 07/11] io_uring: add new api to register fixed workers
Message-ID: <ZIMvKkZZzAfVLGbj@biznet-home.integral.gnuweeb.org>
References: <20230609122031.183730-1-hao.xu@linux.dev>
 <20230609122031.183730-8-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609122031.183730-8-hao.xu@linux.dev>
X-Bpl:  hUx9VaHkTWcLO7S8CQCslj6OzqBx2hfLChRz45nPESx5VSB/xuJQVOKOB1zSXE3yc9ntP27bV1M1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jun 09, 2023 at 08:20:27PM +0800, Hao Xu wrote:  
> +static __cold int io_register_iowq_fixed_workers(struct io_ring_ctx *ctx,
> +					       void __user *arg, int nr_args)
> +	__must_hold(&ctx->uring_lock)
> +{
> +	struct io_uring_task *tctx = NULL;
> +	struct io_sq_data *sqd = NULL;
> +	struct io_uring_fixed_worker_arg *res;
> +	size_t size;
> +	int i, ret;
> +	bool zero = true;
> +
> +	size = array_size(nr_args, sizeof(*res));
> +	if (size == SIZE_MAX)
> +		return -EOVERFLOW;
> +
> +	res = memdup_user(arg, size);
> +	if (IS_ERR(res))
> +		return PTR_ERR(res);
> +
> +	for (i = 0; i < nr_args; i++) {
> +		if (res[i].nr_workers) {
> +			zero = false;
> +			break;
> +		}
> +	}
> +
> +	if (zero)
> +		return 0;

You have a memory leak bug here. The memdup_user() needs clean up.
kfree(res);

-- 
Ammar Faizi

