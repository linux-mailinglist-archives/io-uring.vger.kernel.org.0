Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF6965FE1E
	for <lists+io-uring@lfdr.de>; Fri,  6 Jan 2023 10:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjAFJlG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Jan 2023 04:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbjAFJkj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Jan 2023 04:40:39 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED776DB81;
        Fri,  6 Jan 2023 01:35:46 -0800 (PST)
Received: from integral2 (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 9B6B07E4BC;
        Fri,  6 Jan 2023 09:35:43 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1672997746;
        bh=PSwF0Q2QKh+quczjcUBNpheJtkPkO8EGIsVhqAP+3sg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S6T3M0LDK5pKwF2CrZL7QN+nnoHPhrZqJIgxGFjOk8tEq7jNryY5I1a/RSWcMP580
         E+URXp9bY0sS71Hv1G0QADQfdBtOyqC+8P8rHBM3bgUzdwLpIqqMCw7WJpP1km+TH7
         wFhm4033n0SQRqT7S3QJLcQSPs4PylnlzsSolkePuafCtIYKpWIAd8E488rgjbDnp1
         Sey8H6FHhW/l2vRQYbFf3v7X2om4WaXLDcjQpxqknuvuT3qbyMJvWkwAEpVR3BayuA
         f7S9f/kkN3VAapCg9ccJxPzfeEQrtQh5W1UVE3XSFh2JCHbwkcJ47Yex/kk27S/+1Y
         zdY4Fgdt/62mg==
Date:   Fri, 6 Jan 2023 16:35:39 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Yu Zhe <yuzhe@nfschina.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, liqiong@nfschina.com
Subject: Re: [PATCH] io_uring: fix some spelling mistakes in comment
Message-ID: <Y7fra/JE003tcpQq@integral2>
References: <20230106091242.20288-1-yuzhe@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106091242.20288-1-yuzhe@nfschina.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 06, 2023 at 05:12:42PM +0800, Yu Zhe wrote:
> @@ -2822,7 +2822,7 @@ static __cold void io_tctx_exit_cb(struct callback_head *cb)
>  	 * When @in_idle, we're in cancellation and it's racy to remove the
>  	 * node. It'll be removed by the end of cancellation, just ignore it.
>  	 * tctx can be NULL if the queueing of this task_work raced with
> -	 * work cancelation off the exec path.
> +	 * work cancellation off the exec path.
>  	 */
>  	if (tctx && !atomic_read(&tctx->in_idle))
>  		io_uring_del_tctx_node((unsigned long)work->ctx);
> @@ -3095,7 +3095,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
>  		bool loop = false;
>  
>  		io_uring_drop_tctx_refs(current);
> -		/* read completions before cancelations */
> +		/* read completions before cancellations */

"cancelations" is not a typo.

"cancelations" and "cancellations" are both valid spellings. The former
is predominantly used in the US, while the latter is predominantly used
in the UK.

-- 
Ammar Faizi

