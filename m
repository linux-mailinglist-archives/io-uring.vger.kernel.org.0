Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C407E33A076
	for <lists+io-uring@lfdr.de>; Sat, 13 Mar 2021 20:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhCMTao (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Mar 2021 14:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbhCMTaR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Mar 2021 14:30:17 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C02C061574
        for <io-uring@vger.kernel.org>; Sat, 13 Mar 2021 11:30:17 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id o10so1253032plg.11
        for <io-uring@vger.kernel.org>; Sat, 13 Mar 2021 11:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pSn1zwgRt3l7Q0UWAuT89s6Wb4TE33tBDFA42U713b0=;
        b=vwVfdB4tmm/fTbDuiN6prwL58ApeYDagh/DfS6pADeylpMUv9vgcPAGicWl9NyTV36
         kzeq/1EpyN1Egkc0I/U2g8IeUlPbrolMjgKXV2uQVJyVVtY4iLtZZPqdFc5iirURCL+A
         NxLG6D+nvL7GMCNKOtwW+PXl6BJ6FcpcDA2Kcu02MhENi89M+3ELZ+4M4VVyeLx0nVb0
         7Qvln5BEu6Zm9eufsO9N7vvWuF2TZLrlL0RGI7oj6tgVB19OAiLt8Ue95c2eQaUUTwdE
         FtJbRawteaKo+qCDAPYcBoviDjaFT3pCfGSwr4bkVBfobmc8vWJ0q/ZEX58xnnWLOF/Y
         JPVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pSn1zwgRt3l7Q0UWAuT89s6Wb4TE33tBDFA42U713b0=;
        b=esbh96EFczV8WiHApL9WttKLpQc7RjXux82D2azGjDc5rAW9grT3TmcsUUed2s5W5I
         KlaJZuBui01OHVYQNPBTiWHUef/RtZHqnoIlRdHXxiWp5Z2OYnLq5W0Bro0/XLbAa9eL
         n+bChoaBun+EhMg+jyNFMg3JrP6Bgdr3n+0b6C9dXaq3+SmPhCg9I3ZP1MzpsnkMj1Me
         9CVeseJxyw/1QhArJU/dyiU4ih166hycfBdIB/zqVoZkS3b3Ic444vfO6zksO4n1pa+K
         5KOaGyNveBWMQPcCojRPBOskOPq5j1RyhRfLGAF0IKF/rTi+gTrvd4Xn5Qk+6LBFafwZ
         umsg==
X-Gm-Message-State: AOAM532oOb+85DZTkIw03nBQaYFEJVj359jIfGOtf31yzQV0G2gZC+gs
        zfNhIGoAaQFCOy2x8taQZH5b8g==
X-Google-Smtp-Source: ABdhPJwnjlusIfsKdhXc/wK/9+o9ZLdz58YD2p/d9JcmD/dS5zClzsOh7/WE2kCbbzbqVEcI2SeUog==
X-Received: by 2002:a17:90b:4b87:: with SMTP id lr7mr4671530pjb.5.1615663816746;
        Sat, 13 Mar 2021 11:30:16 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x2sm2935153pga.60.2021.03.13.11.30.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Mar 2021 11:30:16 -0800 (PST)
Subject: Re: [PATCH 5.12] io_uring: Convert personality_idr to XArray
From:   Jens Axboe <axboe@kernel.dk>
To:     yangerkun <yangerkun@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>, yi.zhang@huawei.com
References: <7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com>
 <803bad80-093a-5fbf-7677-754c9afad530@gmail.com>
 <8b553635-b3d9-cb36-34f0-83777bec94ab@huawei.com>
 <81464ae1-cac4-df4c-cd0e-1d518461d4c3@huawei.com>
 <7a905382-8598-f351-8a5b-423d7246200a@kernel.dk>
 <e6c9ed79-827b-7a45-3ad8-9ba5a21d5780@kernel.dk>
Message-ID: <d98051ba-0c85-7013-dd93-a76efc9196ad@kernel.dk>
Date:   Sat, 13 Mar 2021 12:30:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e6c9ed79-827b-7a45-3ad8-9ba5a21d5780@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/13/21 12:01 PM, Jens Axboe wrote:
> On 3/13/21 8:34 AM, Jens Axboe wrote:
>> On 3/13/21 1:02 AM, yangerkun wrote:
>>>
>>>
>>> 在 2021/3/9 19:23, yangerkun 写道:
>>>>
>>>>
>>>> 在 2021/3/8 22:22, Pavel Begunkov 写道:
>>>>> On 08/03/2021 14:16, Pavel Begunkov wrote:
>>>>>> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>>>>>>
>>>>>> You can't call idr_remove() from within a idr_for_each() callback,
>>>>>> but you can call xa_erase() from an xa_for_each() loop, so switch the
>>>>>> entire personality_idr from the IDR to the XArray.  This manifests as a
>>>>>> use-after-free as idr_for_each() attempts to walk the rest of the node
>>>>>> after removing the last entry from it.
>>>>>
>>>>> yangerkun, can you test it and similarly take care of buffer idr?
>>>>
>>>> Will try it latter :)
>>>
>>> Sorry for the latter reply. The patch pass the testcase.
>>>
>>> Besides, should we apply this patch first to deal with the same UAF for
>>> io_buffer_idr before convert to XArray?
>>>
>>> https://lore.kernel.org/io-uring/20210308065903.2228332-2-yangerkun@huawei.com/T/#u
>>
>> Agree, and then defer an xarray conversion to 5.13. I'll take a look at
>> your patch and get it applied.
> 
> That one is very broken, it both fails removal cases and it's got leak
> issues too.
> 
> I'm going to take a look at just doing xarray instead.

Something like the below - tested as working for me, and has no leaks.


From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: convert io_buffer_idr to XArray

Like we did for the personality idr, convert the IO buffer idr to use
XArray. This avoids a use-after-free on removal of entries, since idr
doesn't like doing so from inside an iterator.

Fixes: 5a2e745d4d43 ("io_uring: buffer registration infrastructure")
Cc: stable@vger.kernel.org
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 49 ++++++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 05adc4887ef3..3d259a120f0d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -402,7 +402,8 @@ struct io_ring_ctx {
 	struct socket		*ring_sock;
 #endif
 
-	struct idr		io_buffer_idr;
+	struct xarray		io_buffer;
+	u32			io_buffer_next;
 
 	struct xarray		personalities;
 	u32			pers_next;
@@ -1135,7 +1136,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->cq_wait);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->ref_comp);
-	idr_init(&ctx->io_buffer_idr);
+	xa_init_flags(&ctx->io_buffer, XA_FLAGS_ALLOC1);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
@@ -2843,7 +2844,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	head = idr_find(&req->ctx->io_buffer_idr, bgid);
+	head = xa_load(&req->ctx->io_buffer, bgid);
 	if (head) {
 		if (!list_empty(&head->list)) {
 			kbuf = list_last_entry(&head->list, struct io_buffer,
@@ -2851,7 +2852,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 			list_del(&kbuf->list);
 		} else {
 			kbuf = head;
-			idr_remove(&req->ctx->io_buffer_idr, bgid);
+			__xa_erase(&req->ctx->io_buffer, bgid);
 		}
 		if (*len > kbuf->len)
 			*len = kbuf->len;
@@ -3892,7 +3893,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
 	}
 	i++;
 	kfree(buf);
-	idr_remove(&ctx->io_buffer_idr, bgid);
+	__xa_erase(&ctx->io_buffer, bgid);
 
 	return i;
 }
@@ -3910,7 +3911,7 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	lockdep_assert_held(&ctx->uring_lock);
 
 	ret = -ENOENT;
-	head = idr_find(&ctx->io_buffer_idr, p->bgid);
+	head = xa_load(&ctx->io_buffer, p->bgid);
 	if (head)
 		ret = __io_remove_buffers(ctx, head, p->bgid, p->nbufs);
 	if (ret < 0)
@@ -3993,21 +3994,20 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	lockdep_assert_held(&ctx->uring_lock);
 
-	list = head = idr_find(&ctx->io_buffer_idr, p->bgid);
+	list = head = xa_load(&ctx->io_buffer, p->bgid);
 
 	ret = io_add_buffers(p, &head);
-	if (ret < 0)
-		goto out;
+	if (ret >= 0 && !list) {
+		u32 id = -1U;
 
-	if (!list) {
-		ret = idr_alloc(&ctx->io_buffer_idr, head, p->bgid, p->bgid + 1,
-					GFP_KERNEL);
-		if (ret < 0) {
+		ret = __xa_alloc_cyclic(&ctx->io_buffer, &id, head,
+					XA_LIMIT(0, USHRT_MAX),
+					&ctx->io_buffer_next, GFP_KERNEL);
+		if (ret < 0)
 			__io_remove_buffers(ctx, head, p->bgid, -1U);
-			goto out;
-		}
+		else
+			ret = id;
 	}
-out:
 	if (ret < 0)
 		req_set_fail_links(req);
 
@@ -8333,19 +8333,14 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
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
+	xa_destroy(&ctx->io_buffer);
 }
 
 static void io_req_cache_free(struct list_head *list, struct task_struct *tsk)
-- 
2.30.2


-- 
Jens Axboe

