Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4199654F2E9
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 10:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381016AbiFQI2Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 04:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381015AbiFQI2Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 04:28:16 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160DE3207B
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:28:10 -0700 (PDT)
Message-ID: <1b7434f0-f06b-e659-33b8-f1cc4ab60dcc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655454488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+rrzVerWeDaVHj/Gynik+tgvokY7+Ghde/q2De0hfZs=;
        b=Ymve5Y8DW/j0EY1WqTJBTlJII1cMIxSFe+lFjQ6OHFxSNaVVm0QDhzSnyVM5EK/kzZlMyg
        2hI9h9+aqISYLegYyFJLuytEhT//1CMyVEjv456tSNSzofl1spgElsU79eEdpt+IGpfYDa
        rmesgL4U9wmKkt3164YCJJrFxuxlipw=
Date:   Fri, 17 Jun 2022 16:28:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH liburing] Fix incorrect close in test for multishot accept
Content-Language: en-US
To:     Donald Hunter <donald.hunter@gmail.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <20220616162245.6225-1-donald.hunter@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <20220616162245.6225-1-donald.hunter@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/17/22 00:22, Donald Hunter wrote:
> This fixes a bug in accept_conn handling in the accept tests that caused it
> to incorrectly skip the multishot tests and also lose the warning message
> to a closed stdout. This can be seen in the strace output below.
> 
> close(1)                                = 0
> io_uring_setup(32, { ...
> ...
> write(1, "Fixed Multishot Accept not suppo"..., 47) = -1 EINVAL
> 
> Unfortunately this exposes a a bug with gcc -O2 where multishot_mask logic
> gets optimized incorrectly and "Fixed Multishot Accept misses events" is
> wrongly reported. I am investigating this separately.
> 

Super thanks, Donald. you are right, we skipped the fixed multishot test
by mistake, the exposed issue after your fix is caused by
multishot_mask |= (1 << (s_fd[i] - 1))
which should be
multishot_mask |= (1U << s_fd[i])

Would you mind me to take this one to my patch series which is to fix
this and do some cleaning?

> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
> ---
>   test/accept.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/test/accept.c b/test/accept.c
> index 7bc6226..fb87a1d 100644
> --- a/test/accept.c
> +++ b/test/accept.c
> @@ -103,7 +103,7 @@ static void queue_accept_conn(struct io_uring *ring, int fd,
>   	}
>   }
>   
> -static int accept_conn(struct io_uring *ring, int fixed_idx)
> +static int accept_conn(struct io_uring *ring, int fixed_idx, bool multishot)
>   {
>   	struct io_uring_cqe *cqe;
>   	int ret;
> @@ -115,8 +115,10 @@ static int accept_conn(struct io_uring *ring, int fixed_idx)
>   
>   	if (fixed_idx >= 0) {
>   		if (ret > 0) {
> -			close(ret);
> -			return -EINVAL;
> +			if (!multishot) {
> +				close(ret);
> +				return -EINVAL;
> +			}
>   		} else if (!ret) {
>   			ret = fixed_idx;
>   		}
> @@ -208,7 +210,7 @@ static int test_loop(struct io_uring *ring,
>   		queue_accept_conn(ring, recv_s0, args);
>   
>   	for (i = 0; i < MAX_FDS; i++) {
> -		s_fd[i] = accept_conn(ring, args.fixed ? 0 : -1);
> +		s_fd[i] = accept_conn(ring, args.fixed ? 0 : -1, multishot);
>   		if (s_fd[i] == -EINVAL) {
>   			if (args.accept_should_error)
>   				goto out;

