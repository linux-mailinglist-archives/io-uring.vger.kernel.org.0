Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F265561F3E9
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 14:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiKGNEJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 08:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiKGNEH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 08:04:07 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F86F1C426
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 05:04:06 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.88.229])
        by gnuweeb.org (Postfix) with ESMTPSA id 1DA0D81405;
        Mon,  7 Nov 2022 13:04:03 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1667826245;
        bh=Kns+7QHi56eQYOVt0BQqcHRnAYNU5Ml5Apy+lnFqv10=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=sjsbdGd4tIdnLfE6feqmbAAsuvNrJ35pHCEQaoqKIRRG49qeQApqi2vN0PtBD601H
         sDLWqf5WOohgpgfIsQhY6TA0Y7LKj6Vm2KNbSN4Fcd2JIlEWP2mrREmq5zgbDKuOPP
         zJgTE66VX35DdtAeaxR95YTv5zTzIVudjwoaKcHajn6udpPBy0Xc4BkAK1XjWdRGeK
         cgAeRFKYhCxTSpnvwzdzr13fewpt0h2YB7ckvwzY51yRzd8iIiDnEwdo4AGcpm+goW
         tvQpF4fuglEnWHFp7SEgonTv3olU5IjLQl0gB18TDBBIYbgNSOk86cWZkEYs+X3GLn
         LgGqUNl7MytxA==
Message-ID: <e6406e00-6b3f-02a4-7dab-f7e5cd07b82d@gnuweeb.org>
Date:   Mon, 7 Nov 2022 20:04:01 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
To:     Dylan Yudaken <dylany@meta.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Facebook Kernel Team <kernel-team@fb.com>
References: <20221107123515.4117456-1-dylany@meta.com>
Content-Language: en-US
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing] test that unregister_files processes task work
In-Reply-To: <20221107123515.4117456-1-dylany@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/7/22 7:35 PM, Dylan Yudaken wrote:
> +static int test_defer_taskrun(void)
> +{
> +	struct io_uring_sqe *sqe;
> +	struct io_uring ring;
> +	int ret, fds[2];
> +	char buff = 'x';
> +
> +	ret = io_uring_queue_init(8, &ring,
> +				  IORING_SETUP_DEFER_TASKRUN | IORING_SETUP_SINGLE_ISSUER);
> +	if (ret)
> +		return T_EXIT_SKIP;

You return T_EXIT_SKIP from test_defer_taskrun(). But the
call site is:

> +	if (t_probe_defer_taskrun()) {
> +		ret = test_defer_taskrun();
> +		if (ret) {
> +			fprintf(stderr, "test_defer failed\n");
> +			return T_EXIT_FAIL;
> +		}
> +	}

T_EXIT_SKIP is 77. So the block inside the "if" is taken.
End result you get T_EXIT_FAIL.

T_EXIT_SKIP in your code doesn't really mean skip.

-- 
Ammar Faizi

