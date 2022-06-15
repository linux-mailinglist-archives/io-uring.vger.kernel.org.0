Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA9E54C729
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 13:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346162AbiFOLI7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 07:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352756AbiFOLI6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 07:08:58 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E12336B7A
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:08:57 -0700 (PDT)
Message-ID: <fffe70f2-9e60-0f7e-dd00-8b62823a9527@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655291335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BGgb6pMmpXNcJapRHNVVeo5evfaV37VmfeZbEyPJidk=;
        b=WTeo1xCXurN9H58TFot0YucUok+fTtycApiWzYu5BiEYk2zXK7+vkUqHVbY6b/Wg4sIwwp
        AGgg/hgTjaYowx5e59/0rQERVhsjIsBeUicIszhLVNjKHgSgxAXesLwGhz/QSSoBMgbY84
        DGz8RRh7hNLYzuRsVPxXjGCEFFnFWCY=
Date:   Wed, 15 Jun 2022 19:08:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next v2 21/25] io_uring: add
 IORING_SETUP_SINGLE_ISSUER
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <d6235e12830a225584b90cf3b29f09a0681acc95.1655213915.git.asml.silence@gmail.com>
 <40197f84-35e3-4e37-fe73-3c7f4c21d513@linux.dev>
 <e156bf54-3bdf-b03b-2737-7e02b2762111@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <e156bf54-3bdf-b03b-2737-7e02b2762111@gmail.com>
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

On 6/15/22 18:26, Pavel Begunkov wrote:
> On 6/15/22 10:41, Hao Xu wrote:
>> On 6/14/22 22:37, Pavel Begunkov wrote:
>>> Add a new IORING_SETUP_SINGLE_ISSUER flag and the userspace visible part
>>> of it, i.e. put limitations of submitters. Also, don't allow it together
>>> with IOPOLL as we're not going to put it to good use.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   include/uapi/linux/io_uring.h |  5 ++++-
>>>   io_uring/io_uring.c           |  7 +++++--
>>>   io_uring/io_uring_types.h     |  1 +
>>>   io_uring/tctx.c               | 27 ++++++++++++++++++++++++---
>>>   io_uring/tctx.h               |  4 ++--
>>>   5 files changed, 36 insertions(+), 8 deletions(-)
>>>
> [...]
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 15d209f334eb..4b90439808e3 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -3020,6 +3020,8 @@ static __cold void io_ring_ctx_free(struct 
>>> io_ring_ctx *ctx)
>>>       io_destroy_buffers(ctx);
>>>       if (ctx->sq_creds)
>>>           put_cred(ctx->sq_creds);
>>> +    if (ctx->submitter_task)
>>> +        put_task_struct(ctx->submitter_task);
>>>       /* there are no registered resources left, nobody uses it */
>>>       if (ctx->rsrc_node)
>>> @@ -3752,7 +3754,7 @@ static int io_uring_install_fd(struct 
>>> io_ring_ctx *ctx, struct file *file)
>>>       if (fd < 0)
>>>           return fd;
>>> -    ret = io_uring_add_tctx_node(ctx);
>>> +    ret = __io_uring_add_tctx_node(ctx, false);
> 
>                                              ^^^^^^
> 
> Note this one

My bad, I read it wrong...
