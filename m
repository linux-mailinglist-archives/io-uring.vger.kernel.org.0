Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F99054D935
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 06:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiFPEUD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 00:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiFPEUC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 00:20:02 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6F658E7C
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 21:20:00 -0700 (PDT)
Message-ID: <0207113a-0b15-1d2a-57db-54062175cf2b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655353198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kO0JFCppEoxYtss/wyKD2OpBfOqELEBXLEI3QHEvQIY=;
        b=S3tLEKTrsXhDNCrI/1CMNo50lWsZK3plve3ChMa/9iPeyrdIPrLv7R0y5oh80ebut7Bod/
        Tnf0q5mKtlB+XWJmPmsMbOm+SbcXNsLAmF+iIkN4A5w7nq/mT0oIP6XxZFET6tfig5BNU6
        SItKB0BWq3KJKvBwnzeShPRh4wX/TXU=
Date:   Thu, 16 Jun 2022 12:19:50 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] io_uring: kbuf: add comments for some tricky code
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20220614120108.1134773-1-hao.xu@linux.dev>
In-Reply-To: <20220614120108.1134773-1-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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

Ping this one..
On 6/14/22 20:01, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add comments to explain why it is always under uring lock when
> incrementing head in __io_kbuf_recycle. And rectify one comemnt about
> kbuf consuming in iowq case.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   io_uring/kbuf.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 9cdbc018fd64..37f06456bf30 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -50,6 +50,13 @@ void __io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
>   	if (req->flags & REQ_F_BUFFER_RING) {
>   		if (req->buf_list) {
>   			if (req->flags & REQ_F_PARTIAL_IO) {
> +				/*
> +				 * if we reach here, uring_lock has been
> +				¦* holden. Because in iowq, we already
> +				¦* cleared req->buf_list to NULL when got
> +				¦* the buffer from the ring, which means
> +				¦* we cannot be here in that case.
> +				 */
>   				req->buf_list->head++;
>   				req->buf_list = NULL;
>   			} else {
> @@ -128,12 +135,13 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
>   	if (issue_flags & IO_URING_F_UNLOCKED) {
>   		/*
>   		 * If we came in unlocked, we have no choice but to consume the
> -		 * buffer here. This does mean it'll be pinned until the IO
> -		 * completes. But coming in unlocked means we're in io-wq
> -		 * context, hence there should be no further retry. For the
> -		 * locked case, the caller must ensure to call the commit when
> -		 * the transfer completes (or if we get -EAGAIN and must poll
> -		 * or retry).
> +		 * buffer here otherwise nothing ensures the buffer not being
> +		 * used by others. This does mean it'll be pinned until the IO
> +		 * completes though coming in unlocked means we're in io-wq
> +		 * context and there may be further retries in async hybrid mode.
> +		 * For the locked case, the caller must ensure to call the commit
> +		 * when the transfer completes (or if we get -EAGAIN and must
> +		 * poll or retry).
>   		 */
>   		req->buf_list = NULL;
>   		bl->head++;

