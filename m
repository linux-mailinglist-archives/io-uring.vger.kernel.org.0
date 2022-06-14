Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF0154B7E7
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 19:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbiFNRqK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 13:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiFNRqJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 13:46:09 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2A03BA75
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 10:46:06 -0700 (PDT)
Message-ID: <4673dd1b-69ce-8028-6bbb-0120f73445ff@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655228764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IgicqsgwtDRyw9iZ7bL2xZ/VIrsk3XaXgHlqK5qrjGo=;
        b=oJjL4HOxPzKkfVk2FFA0di4BZ5wIr4odWWMPbmtJN/jU4VZ9DKpBkbJF4T7W75GEeolSS1
        a04yg/yjEQXs84GlJSSKUb7p1s0BAdgYTHC3go+7T1DqyO8ECBFBv1BcWbEluZMmQ9IL/Q
        m+YKbtDQdM+TbeHMATWai+qGtp/lUnQ=
Date:   Wed, 15 Jun 2022 01:45:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next v2 11/25] io_uring: refactor
 io_req_task_complete()
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <60f4b51e219d1be0a390d53aae2e5a19b775ab69.1655213915.git.asml.silence@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <60f4b51e219d1be0a390d53aae2e5a19b775ab69.1655213915.git.asml.silence@gmail.com>
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
> Clean up io_req_task_complete() and deduplicate io_put_kbuf() calls.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/io_uring.c | 16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index fcee58c6c35e..0f6edf82f262 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1857,15 +1857,19 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
>   
>   	return ret;
>   }
> -inline void io_req_task_complete(struct io_kiocb *req, bool *locked)
> +
> +void io_req_task_complete(struct io_kiocb *req, bool *locked)
>   {
> -	if (*locked) {
> -		req->cqe.flags |= io_put_kbuf(req, 0);
> +	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
> +		unsigned issue_flags = *locked ? IO_URING_F_UNLOCKED : 0;

should be *locked ? 0 : IO_URING_F_UNLOCKED; I think?. I haven't look
into the whole series carefully, will do that tomorrow.



> +
> +		req->cqe.flags |= io_put_kbuf(req, issue_flags);
> +	}
> +
> +	if (*locked)
>   		io_req_add_compl_list(req);
> -	} else {
> -		req->cqe.flags |= io_put_kbuf(req, IO_URING_F_UNLOCKED);
> +	else
>   		io_req_complete_post(req);
> -	}
>   }
>   
>   /*

