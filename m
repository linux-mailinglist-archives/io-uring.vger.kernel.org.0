Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB2D547208
	for <lists+io-uring@lfdr.de>; Sat, 11 Jun 2022 06:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346465AbiFKEe2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jun 2022 00:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiFKEe2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jun 2022 00:34:28 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678031EF
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 21:34:26 -0700 (PDT)
Message-ID: <8d60fad9-6445-8a6b-d051-947f8ea04582@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654922063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2XZFTICWJQ9Wh3Q5lqfvqS9/AOuj27OXoL4Y0dvuo7c=;
        b=qHVkrVm0RfIejceRi32lLhJSAUciKDI+cfrnaJdtsFkIhfm0h1ZpcJ/jNuWD1wmW2f0Lzg
        iFlWftKSA2QZNMQk+O4DaRsfiKQSInNPxTxJbI570iz14ZQCbM40mTJ4cIkl5Sb/dg69UY
        CcE1m3ip6/yGEVG4f+0WE8qpL01nUAA=
Date:   Sat, 11 Jun 2022 12:34:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] io_uring: switch cancel_hash to use per entry spinlock
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220608111259.659536-1-hao.xu@linux.dev>
 <37d73555-197b-29e1-d2cc-b7313501a394@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <37d73555-197b-29e1-d2cc-b7313501a394@gmail.com>
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

On 6/10/22 18:21, Pavel Begunkov wrote:
> On 6/8/22 12:12, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> Add a new io_hash_bucket structure so that each bucket in cancel_hash
>> has separate spinlock. Use per entry lock for cancel_hash, this removes
>> some completion lock invocation and remove contension between different
>> cancel_hash entries.
>>
>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>> ---
>>
>> v1->v2:
>>   - Add per entry lock for poll/apoll task work code which was missed
>>     in v1
>>   - add an member in io_kiocb to track req's indice in cancel_hash
>>
>> v2->v3:
>>   - make struct io_hash_bucket align with cacheline to avoid cacheline
>>     false sharing.
>>   - re-calculate hash value when deleting an entry from cancel_hash.
>>     (cannot leverage struct io_poll to store the indice since it's
>>      already 64 Bytes)
>>
>>   io_uring/cancel.c         | 14 +++++++--
>>   io_uring/cancel.h         |  6 ++++
>>   io_uring/fdinfo.c         |  9 ++++--
>>   io_uring/io_uring.c       |  8 +++--
>>   io_uring/io_uring_types.h |  2 +-
>>   io_uring/poll.c           | 64 +++++++++++++++++++++------------------
>>   6 files changed, 65 insertions(+), 38 deletions(-)
>>
>> diff --git a/io_uring/cancel.c b/io_uring/cancel.c
>> index 83cceb52d82d..bced5d6b9294 100644
>> --- a/io_uring/cancel.c
>> +++ b/io_uring/cancel.c
>> @@ -93,14 +93,14 @@ int io_try_cancel(struct io_kiocb *req, struct 
>> io_cancel_data *cd)
>>       if (!ret)
>>           return 0;
>> -    spin_lock(&ctx->completion_lock);
>>       ret = io_poll_cancel(ctx, cd);
>>       if (ret != -ENOENT)
>>           goto out;
>> +    spin_lock(&ctx->completion_lock);
>>       if (!(cd->flags & IORING_ASYNC_CANCEL_FD))
>>           ret = io_timeout_cancel(ctx, cd);
>> -out:
>>       spin_unlock(&ctx->completion_lock);
>> +out:
>>       return ret;
>>   }
>> @@ -192,3 +192,13 @@ int io_async_cancel(struct io_kiocb *req, 
>> unsigned int issue_flags)
>>       io_req_set_res(req, ret, 0);
>>       return IOU_OK;
>>   }
>> +
>> +inline void init_hash_table(struct io_hash_bucket *hash_table, 
>> unsigned size)
> 
> Not inline, it can break builds
> 

What do you mean? It's compiled well.
