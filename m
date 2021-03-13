Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EB833A0F8
	for <lists+io-uring@lfdr.de>; Sat, 13 Mar 2021 21:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhCMUWi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Mar 2021 15:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234165AbhCMUW1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Mar 2021 15:22:27 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADF1C061574
        for <io-uring@vger.kernel.org>; Sat, 13 Mar 2021 12:22:27 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id s21so4156420pfm.1
        for <io-uring@vger.kernel.org>; Sat, 13 Mar 2021 12:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QpZF4y/C2N+6nZlSX9ukAUnODLa6EQyxk/D75K9e8nQ=;
        b=A9CKN7TPHCGnUZcwFwmC8w85rVMDMDqa1oT8YpFFci9ooxCWEMgqX+rKgn4seOQ+rh
         I9LIp6WSsuqyPwjOH7FsCcZFEicVcH0ieDJma9xXpqhY/cwBDXd2CNOWweaoUKrpS7Tk
         BIvmK8EiJev3AcjwwMcTzElpHw8rVMm2xp2/YFexrN+EWvV1iJQcqPme1IfNJH2ld4oy
         2znqXEy9GIai/XUaCwUilxIwPo0AMryeFK8CoHuRKEMQTZ81wLqtzqv0SmeHQpZqwSbO
         NfWr/I6tS7MIQlFpqbvBfsgH9b+K+B7pj3YFm5W44WcUVID2GWcy1v5cTWYISvTe794l
         oF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QpZF4y/C2N+6nZlSX9ukAUnODLa6EQyxk/D75K9e8nQ=;
        b=uOPqYdcjF0ehjhKde7tNgbwAeKudA26KQuy8bLFiinez10Txq7veruGKOnbWTqavQv
         aKNEsVHrA5rHsW6/dZ+ZDK3+m2XO2YIv4HsFf8drhrO/a48d7kpSyz8JMBZKO+Hvb25A
         mGIr5OZ620SzWaB3TIK1z/CiYZW7Kz57vQfp4xGbIODbn/FnmuPyxhAbx0jQuAeNztCQ
         fVwqjHpgu7at3eb1bsb+kQUHy34Eli1Hqco7YNS/aon5957NCq04zoSu+8s8nmeYyFQJ
         C9UKnFxzkelQ65fT4iCuWbso6uO2Z5xndOXhe9OLvBvaTfYg1f2Q6DS5erUCqdgjaLLV
         rYEQ==
X-Gm-Message-State: AOAM530qjQ2HXsDdDny6gppHuOyKMXD3sj6GpOuJNRfkN79FjlVsxNcG
        AUG6mioLHSOwEAxNII163RkjWZeI0GZzMw==
X-Google-Smtp-Source: ABdhPJzVVvu1A7XolGUsjYicn6d4mELNGlE/bP/vXnUnzvqc7a90bCYMpJAprl1yOFTZwjSOdq8qUA==
X-Received: by 2002:a62:5cc3:0:b029:203:54be:e4c9 with SMTP id q186-20020a625cc30000b029020354bee4c9mr3976117pfb.80.1615666946934;
        Sat, 13 Mar 2021 12:22:26 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t6sm8690175pgp.57.2021.03.13.12.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Mar 2021 12:22:26 -0800 (PST)
Subject: Re: [PATCH 5.12] io_uring: Convert personality_idr to XArray
From:   Jens Axboe <axboe@kernel.dk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     yangerkun <yangerkun@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        yi.zhang@huawei.com
References: <7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com>
 <803bad80-093a-5fbf-7677-754c9afad530@gmail.com>
 <8b553635-b3d9-cb36-34f0-83777bec94ab@huawei.com>
 <81464ae1-cac4-df4c-cd0e-1d518461d4c3@huawei.com>
 <7a905382-8598-f351-8a5b-423d7246200a@kernel.dk>
 <e6c9ed79-827b-7a45-3ad8-9ba5a21d5780@kernel.dk>
 <d98051ba-0c85-7013-dd93-a76efc9196ad@kernel.dk>
 <20210313195402.GK2577561@casper.infradead.org>
 <91b46511-48c9-394b-bf32-ac5f7e0951c8@kernel.dk>
Message-ID: <7ea5ddbc-16e2-9491-f0ee-73a991d3cf83@kernel.dk>
Date:   Sat, 13 Mar 2021 13:22:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <91b46511-48c9-394b-bf32-ac5f7e0951c8@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/13/21 1:13 PM, Jens Axboe wrote:
> On 3/13/21 12:54 PM, Matthew Wilcox wrote:
>> On Sat, Mar 13, 2021 at 12:30:14PM -0700, Jens Axboe wrote:
>>> @@ -2851,7 +2852,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
>>>  			list_del(&kbuf->list);
>>>  		} else {
>>>  			kbuf = head;
>>> -			idr_remove(&req->ctx->io_buffer_idr, bgid);
>>> +			__xa_erase(&req->ctx->io_buffer, bgid);
>>
>> Umm ... __xa_erase()?  Did you enable all the lockdep infrastructure?
>> This should have tripped some of the debugging code because I don't think
>> you're holding the xa_lock.
> 
> Not run with lockdep - and probably my misunderstanding, do we need xa_lock()
> if we provide our own locking?
> 
>>> @@ -3993,21 +3994,20 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
>>>  
>>>  	lockdep_assert_held(&ctx->uring_lock);
>>>  
>>> -	list = head = idr_find(&ctx->io_buffer_idr, p->bgid);
>>> +	list = head = xa_load(&ctx->io_buffer, p->bgid);
>>>  
>>>  	ret = io_add_buffers(p, &head);
>>> -	if (ret < 0)
>>> -		goto out;
>>> +	if (ret >= 0 && !list) {
>>> +		u32 id = -1U;
>>>  
>>> -	if (!list) {
>>> -		ret = idr_alloc(&ctx->io_buffer_idr, head, p->bgid, p->bgid + 1,
>>> -					GFP_KERNEL);
>>> -		if (ret < 0) {
>>> +		ret = __xa_alloc_cyclic(&ctx->io_buffer, &id, head,
>>> +					XA_LIMIT(0, USHRT_MAX),
>>> +					&ctx->io_buffer_next, GFP_KERNEL);
>>
>> I don't understand why this works.  The equivalent transformation here
>> would have been:
>>
>> 		ret = xa_insert(&ctx->io_buffers, p->bgid, head, GFP_KERNEL);
>>
>> with various options to handle it differently.
> 
> True, that does look kinda weird (and wrong). I'll fix that up.
> 
>>>  static void io_destroy_buffers(struct io_ring_ctx *ctx)
>>>  {
>>> -	idr_for_each(&ctx->io_buffer_idr, __io_destroy_buffers, ctx);
>>> -	idr_destroy(&ctx->io_buffer_idr);
>>> +	struct io_buffer *buf;
>>> +	unsigned long index;
>>> +
>>> +	xa_for_each(&ctx->io_buffer, index, buf)
>>> +		__io_remove_buffers(ctx, buf, index, -1U);
>>> +	xa_destroy(&ctx->io_buffer);
>>
>> Honestly, I'd do BUG_ON(!xa_empty(&ctx->io_buffers)) if anything.  If that
>> loop didn't empty the array, something is terribly wrong and we should
>> know about it somehow instead of making the memory leak harder to find.
> 
> Probably also my misunderstanding - do I not need to call xa_destroy()
> if I prune all the members? Assumed we needed it to free some internal
> state, but maybe that's not the case?

Here's a v2. Verified no leaks with the killed xa_destroy(), and that
lockdep is happy. BTW, much better API, which is evident from the fact
that a conversion like this ends up with the below diffstat:

 io_uring.c |   43 +++++++++++++++----------------------------
 1 file changed, 15 insertions(+), 28 deletions(-)


commit 51c681e3487d091b447175088bcf546f5ce1bf35
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sat Mar 13 12:29:43 2021 -0700

    io_uring: convert io_buffer_idr to XArray
    
    Like we did for the personality idr, convert the IO buffer idr to use
    XArray. This avoids a use-after-free on removal of entries, since idr
    doesn't like doing so from inside an iterator.
    
    Fixes: 5a2e745d4d43 ("io_uring: buffer registration infrastructure")
    Cc: stable@vger.kernel.org
    Reported-by: Hulk Robot <hulkci@huawei.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 05adc4887ef3..642ad08d8964 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -402,7 +402,7 @@ struct io_ring_ctx {
 	struct socket		*ring_sock;
 #endif
 
-	struct idr		io_buffer_idr;
+	struct xarray		io_buffer;
 
 	struct xarray		personalities;
 	u32			pers_next;
@@ -1135,7 +1135,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->cq_wait);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->ref_comp);
-	idr_init(&ctx->io_buffer_idr);
+	xa_init_flags(&ctx->io_buffer, XA_FLAGS_ALLOC1);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
@@ -2843,7 +2843,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	head = idr_find(&req->ctx->io_buffer_idr, bgid);
+	head = xa_load(&req->ctx->io_buffer, bgid);
 	if (head) {
 		if (!list_empty(&head->list)) {
 			kbuf = list_last_entry(&head->list, struct io_buffer,
@@ -2851,7 +2851,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 			list_del(&kbuf->list);
 		} else {
 			kbuf = head;
-			idr_remove(&req->ctx->io_buffer_idr, bgid);
+			xa_erase(&req->ctx->io_buffer, bgid);
 		}
 		if (*len > kbuf->len)
 			*len = kbuf->len;
@@ -3892,7 +3892,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
 	}
 	i++;
 	kfree(buf);
-	idr_remove(&ctx->io_buffer_idr, bgid);
+	xa_erase(&ctx->io_buffer, bgid);
 
 	return i;
 }
@@ -3910,7 +3910,7 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	lockdep_assert_held(&ctx->uring_lock);
 
 	ret = -ENOENT;
-	head = idr_find(&ctx->io_buffer_idr, p->bgid);
+	head = xa_load(&ctx->io_buffer, p->bgid);
 	if (head)
 		ret = __io_remove_buffers(ctx, head, p->bgid, p->nbufs);
 	if (ret < 0)
@@ -3993,21 +3993,14 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	lockdep_assert_held(&ctx->uring_lock);
 
-	list = head = idr_find(&ctx->io_buffer_idr, p->bgid);
+	list = head = xa_load(&ctx->io_buffer, p->bgid);
 
 	ret = io_add_buffers(p, &head);
-	if (ret < 0)
-		goto out;
-
-	if (!list) {
-		ret = idr_alloc(&ctx->io_buffer_idr, head, p->bgid, p->bgid + 1,
-					GFP_KERNEL);
-		if (ret < 0) {
+	if (ret >= 0 && !list) {
+		ret = xa_insert(&ctx->io_buffer, p->bgid, head, GFP_KERNEL);
+		if (ret < 0)
 			__io_remove_buffers(ctx, head, p->bgid, -1U);
-			goto out;
-		}
 	}
-out:
 	if (ret < 0)
 		req_set_fail_links(req);
 
@@ -8333,19 +8326,13 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 	return -ENXIO;
 }
 
-static int __io_destroy_buffers(int id, void *p, void *data)
-{
-	struct io_ring_ctx *ctx = data;
-	struct io_buffer *buf = p;
-
-	__io_remove_buffers(ctx, buf, id, -1U);
-	return 0;
-}
-
 static void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
-	idr_for_each(&ctx->io_buffer_idr, __io_destroy_buffers, ctx);
-	idr_destroy(&ctx->io_buffer_idr);
+	struct io_buffer *buf;
+	unsigned long index;
+
+	xa_for_each(&ctx->io_buffer, index, buf)
+		__io_remove_buffers(ctx, buf, index, -1U);
 }
 
 static void io_req_cache_free(struct list_head *list, struct task_struct *tsk)

-- 
Jens Axboe

