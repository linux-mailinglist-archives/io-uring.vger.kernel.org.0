Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DED054C2FF
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 09:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243779AbiFOH7U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 03:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243225AbiFOH7U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 03:59:20 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6E543497
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 00:59:17 -0700 (PDT)
Message-ID: <353c4c53-18c3-976c-b964-0bc47c9b2d86@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655279955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PBp+0RiWkDWOOvf7FmrRWI2RdhMfjUeETGfBUSsJAbI=;
        b=jdDSrLSLd8JSKUphuBOs+kyOF3RO3cFrGA0xcJ+KwlCk3vuWhHzPIRXvcaNmpmfbjMdPdv
        4rIsKOjvzga4IWWgy+dIG2W+f2Rbs+21c4DayZjfhZPRLIPWdFBDHSHHc4dnCzzquluB4L
        hiNwM7v3l1R+BZwbdGfONHBiQWxqNUg=
Date:   Wed, 15 Jun 2022 15:58:59 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next v2 04/25] io_uring: refactor ctx slow data
 placement
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <c600cc3615eeea7c876a7c0edd058b880519e175.1655213915.git.asml.silence@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <c600cc3615eeea7c876a7c0edd058b880519e175.1655213915.git.asml.silence@gmail.com>
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

On 6/14/22 22:36, Pavel Begunkov wrote:
> Shove all slow path data at the end of ctx and get rid of extra
> indention.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/io_uring_types.h | 81 +++++++++++++++++++--------------------
>   1 file changed, 39 insertions(+), 42 deletions(-)
> 
> diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
> index 4f52dcbbda56..ca8e25992ece 100644
> --- a/io_uring/io_uring_types.h
> +++ b/io_uring/io_uring_types.h
> @@ -183,7 +183,6 @@ struct io_ring_ctx {
>   		struct list_head	apoll_cache;
>   		struct xarray		personalities;
>   		u32			pers_next;
> -		unsigned		sq_thread_idle;

SQPOLL is seen as a slow path?
