Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51C046C688
	for <lists+io-uring@lfdr.de>; Tue,  7 Dec 2021 22:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbhLGVUP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Dec 2021 16:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241698AbhLGVUP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Dec 2021 16:20:15 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D9DC061574
        for <io-uring@vger.kernel.org>; Tue,  7 Dec 2021 13:16:44 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a9so384779wrr.8
        for <io-uring@vger.kernel.org>; Tue, 07 Dec 2021 13:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=lbUr+usg5OxGd8WjzCf23sIAleEdDsKiGJNS2ZkmxTs=;
        b=HByia991QNGM1g9kPdxOY15AikAMO4uZX1g8s4xyWFXjvsq6XgVw2YTgU/q738JQ2R
         wIIq2fsWdzSvmlxoCkshpaFChTWeKm5wmWHHiSRSm65vFWkCiPb/oRkaMGSes5hbgHB+
         41hPifTJaOZ8yy93nijC/GmbL9DX6pz2A6ZP892725RM758bzxi404S0Qkf8nEOWA2Oa
         YQajAnF65x1kxJwXHBl34Nv7kAiTSDgDUWyMfaMSTI8GC3tt9TvGmA/IWivHbuiJQYFE
         HN4SidWY6Ctwd7OpCIC1uAUqa1oyGow/KW7kQclHaqL73o1t3vCDA5C/HtRNWMimHagv
         ZvGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=lbUr+usg5OxGd8WjzCf23sIAleEdDsKiGJNS2ZkmxTs=;
        b=cuPf5SYT7OHPjKoSQ5lCK2s5PWZYClD19TRXDOv092X524WrUmhQAnt60yzZExCHOA
         fSHeL0goWsxuAaGG/ALB3Te54XECdsPy5OI8NBhsQxaFPAMDFcwQwpV8RPH92bpxiCjX
         mIIpo5kAAx0sDjNFLtH+rYzBf6v9UepPFWKorPbl9zKzDARX5CRC4z6otyS5ksOapa09
         LLgwL/S4WuSo5BLjyfxfWO8L0XbGqFUnqBT/dGkFf4OAGIMiBfLViTMa4assaRXfonW6
         AbxLK4PF+U34MAjZAn+/ayGU3JxnsE4F6h+mjzekkWsUus2aljsdFAalg00X3pnF/lpi
         dXcA==
X-Gm-Message-State: AOAM531B/CTWJ2u+V/JiLFicp+P7hSlyM7iIxyz51+mx1WZjPWBLX9qA
        R+cnE3+1Yo47Iy+QHLuu/5943GRHDKU=
X-Google-Smtp-Source: ABdhPJzBoPgfEiP4Ve7rsdKwERAklVjmzm2JLCjLy6zob7XzO9Jg98n727jHfeY4kg4jwxpFmr5+Kg==
X-Received: by 2002:adf:b35d:: with SMTP id k29mr51832671wrd.466.1638911803044;
        Tue, 07 Dec 2021 13:16:43 -0800 (PST)
Received: from [192.168.8.198] ([148.252.132.245])
        by smtp.gmail.com with ESMTPSA id u13sm4266865wmq.14.2021.12.07.13.16.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 13:16:42 -0800 (PST)
Message-ID: <4612f227-e313-b84a-40c7-8ff7320b830a@gmail.com>
Date:   Tue, 7 Dec 2021 21:16:43 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 5/5] io_uring: batch completion in prior_task_list
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211207093951.247840-1-haoxu@linux.alibaba.com>
 <20211207093951.247840-6-haoxu@linux.alibaba.com>
 <fc9a8ac2-f339-a5c4-a85d-19d8c324a311@gmail.com>
In-Reply-To: <fc9a8ac2-f339-a5c4-a85d-19d8c324a311@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/7/21 21:01, Pavel Begunkov wrote:
> On 12/7/21 09:39, Hao Xu wrote:
>> In previous patches, we have already gathered some tw with
>> io_req_task_complete() as callback in prior_task_list, let's complete
>> them in batch while we cannot grab uring lock. In this way, we batch
>> the req_complete_post path.
[...]
>> +        if (likely(*uring_locked))
>> +            req->io_task_work.func(req, uring_locked);
>> +        else
>> +            __io_req_complete_post(req, req->result, io_put_kbuf(req));
> 
> I think there is the same issue as last time, first iteration of tctx_task_work()
> sets ctx but doesn't get uring_lock. Then you go here, find a request with the
> same ctx and end up here with locking.

Maybe something like below on top? Totally untested. We basically always
want *uring_locked != *compl_locked, so we don't even need to to store
both vars.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index f224f8df77a1..dfa226bf2c53 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2233,27 +2233,28 @@ static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
  }
  
  static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx,
-				 bool *uring_locked, bool *compl_locked)
+				 bool *uring_locked)
  {
+	if (*ctx && !*uring_locked)
+		spin_lock(&(*ctx)->completion_lock);
+
  	do {
  		struct io_wq_work_node *next = node->next;
  		struct io_kiocb *req = container_of(node, struct io_kiocb,
  						    io_task_work.node);
  
  		if (req->ctx != *ctx) {
-			if (unlikely(*compl_locked)) {
+			if (unlikely(!*uring_locked && *ctx))
  				ctx_commit_and_unlock(*ctx);
-				*compl_locked = false;
-			}
+
  			ctx_flush_and_put(*ctx, uring_locked);
  			*ctx = req->ctx;
  			/* if not contended, grab and improve batching */
  			*uring_locked = mutex_trylock(&(*ctx)->uring_lock);
-			percpu_ref_get(&(*ctx)->refs);
-			if (unlikely(!*uring_locked)) {
+			if (unlikely(!*uring_locked))
  				spin_lock(&(*ctx)->completion_lock);
-				*compl_locked = true;
-			}
+
+			percpu_ref_get(&(*ctx)->refs);
  		}
  		if (likely(*uring_locked))
  			req->io_task_work.func(req, uring_locked);
@@ -2262,10 +2263,8 @@ static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ct
  		node = next;
  	} while (node);
  
-	if (unlikely(*compl_locked)) {
+	if (unlikely(!*uring_locked))
  		ctx_commit_and_unlock(*ctx);
-		*compl_locked = false;
-	}
  }
  
  static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx, bool *locked)
@@ -2289,7 +2288,7 @@ static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ct
  
  static void tctx_task_work(struct callback_head *cb)
  {
-	bool uring_locked = false, compl_locked = false;
+	bool uring_locked = false;
  	struct io_ring_ctx *ctx = NULL;
  	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
  						  task_work);
@@ -2313,7 +2312,7 @@ static void tctx_task_work(struct callback_head *cb)
  			break;
  
  		if (node1)
-			handle_prior_tw_list(node1, &ctx, &uring_locked, &compl_locked);
+			handle_prior_tw_list(node1, &ctx, &uring_locked);
  
  		if (node2)
  			handle_tw_list(node2, &ctx, &uring_locked);
