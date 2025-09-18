Return-Path: <io-uring+bounces-9835-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28BC7B86D24
	for <lists+io-uring@lfdr.de>; Thu, 18 Sep 2025 22:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB82016F807
	for <lists+io-uring@lfdr.de>; Thu, 18 Sep 2025 20:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE944257458;
	Thu, 18 Sep 2025 20:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Uvmw4zUY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152D415442C
	for <io-uring@vger.kernel.org>; Thu, 18 Sep 2025 20:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758225859; cv=none; b=twBxaRnXSH4B96KugKwnPi9fPCT2Zpo0uIbEfn4QYi7szP+6Y8b89lIqq4X30f+4aNijXHZ4BCwhGpT7ydDAi8t1ViKTXAUGQssnibQtcPvYHPErXzyGITqcX+ekWsQUUwmy2lt1Ctcxtt1Aqy8zSOzaH/odrNywSPgIR3ch+YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758225859; c=relaxed/simple;
	bh=0TcyOPNx+jDlhcWxrGb4x8/ncR26Jl+teEHC3jTmqZE=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=cBDcQYI6M22BcuebnvbTSBFB7m8lt+R20Zoias5KqnwI+wsIlWf9GVObbialvEjkHE0g+6idVWw9iy7ZwvLX2ghlFNqZBMH4yTczfSvw5sDCgX21RSSU2jxQAEGTbhcqOViCpKGCXiVEKe9LXhKGn6/E6yNIi0fRVPgoi6tOwsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Uvmw4zUY; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-772301f8ae2so1372871b3a.0
        for <io-uring@vger.kernel.org>; Thu, 18 Sep 2025 13:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758225855; x=1758830655; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E+LXH3UyrKDiNC9dO2AM5bpS4k3cEOb2f0aizK4pfJw=;
        b=Uvmw4zUYmYQL+xJIOUBZqq61MwsIOjbgL5NwOVC0jcMQ/W+SqalYis64fL9kANhQPN
         ruHpjORgB3yyEvmLMDVjhcvmioHjOlMJvwJxn3RsbDA5abRAZ+Iv2f1wTdL3DFFFkYMc
         5wSmMso7lyjXm38pbPLZTSLrfm27VCV9dzUTkgJgBTloTtRrcx3BTSNobf3NNsGZymiG
         sbRE/+0/WV6JT+q3qINahTkYzyjxplNfIMPewau5Owgrh/vOjAEDnK7luiPElJqQGdQy
         6WGxAI6QTehjD4/0rdXSLSoX4xl12duFx5iRQ73DIMj+31tj6vNSwH+a1zK2vmWnegsZ
         R/DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758225855; x=1758830655;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E+LXH3UyrKDiNC9dO2AM5bpS4k3cEOb2f0aizK4pfJw=;
        b=tgL9pLosp105D44zav3o+vPPFz1955afS42Stzb41HJptiRcJlFhO3Vjd9xC2O7KwD
         4AQlPuOqLC9E2L4gYxxj9sRUbreecRrFglKzocrnehVyV8LkHCSHFQ41gpyFJ2wVZmvO
         3GpwdQKlQBgHUkCqFdsseGcsK0gS+lpcwhiKoCwT6mayrtcwAhHXwYfZq1+o4I1gMoEh
         1ZfPP4i7/Jnurisb7RDUEHR0RwsOc5Df9tG1jG8hwM46ITlg6l5fXUS2vVYuzIw6KQZ9
         fwDjlM0TW2hQO75cW3EGpIEOkyUCUXToqRGkisqagyRnWJgG+Hs1scm6JUMWxIH1vn3J
         fEsw==
X-Gm-Message-State: AOJu0YykhbTrx0AmR9CPFvx4/jJbGZUDwsK1HI2s2lcfxxpisOphl8ys
	ZAoDGD+zS1dvNwoSaHmrGVwVMwTJDnKIy2Y18n4LMk6APG76umxRbiARI30k0+0ArUVE9/tSzLM
	m4KbX
X-Gm-Gg: ASbGncuKEf3uY0SVabBrkmOMCloDN+NtKUIK/h3I9f5AZa5jgKh+nWwU5wINpGJaDuZ
	uS8gn3h+6q9iQL6QmeNTkxTiqqhrURo+oCtLcbKUD3AeOKhuO8kXuXb2Lvr60MpwdwjcqZGGwLX
	7ok+OTxbEsrcprP07d2uO/20dGLgL5dbfAgX4NaA08a8lmFEfTR63SvNe1tYFGtSm8GM8QTC6NZ
	FjiKcsaTRi2Cv2/1jPr+CuZBt6zHa1BcpejBDzqJv2mtgyzyKScA08EyuMmKKy6VsBuMoP81nAL
	fcgrAs+vgnWE9NN8vUkzu1Z8PMVkqevwzIlYQJ56LMu+Vwd+n4oMoK7/xezflAlqQxs0GmSSGIe
	l/V+6sHp14gRVmicDpHUQQsTTk0Z1NqawdPAUn2C6eDRWTjUvAP7dJRhKkw12MK7NnhrXs8zxTf
	sJX3qLFICH
X-Google-Smtp-Source: AGHT+IHwa2KJksANcyHLQePw5YTiUE9RrZafKieVnJt1aO7d9JeTV1lk98qHn5clTvwehMNMcYdIvA==
X-Received: by 2002:a05:6a00:4b14:b0:770:4ede:a2e8 with SMTP id d2e1a72fcca58-77e4e9b289dmr678091b3a.16.1758225854613;
        Thu, 18 Sep 2025 13:04:14 -0700 (PDT)
Received: from ?IPV6:2600:380:4977:dad0:96cc:9042:9440:484d? ([2600:380:4977:dad0:96cc:9042:9440:484d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77e5566f92dsm279615b3a.23.2025.09.18.13.04.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 13:04:14 -0700 (PDT)
Message-ID: <0ee30a2f-4e36-4c0a-8e84-7da568da08d3@kernel.dk>
Date: Thu, 18 Sep 2025 14:04:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/msg_ring: kill alloc_cache for io_kiocb allocations
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A recent commit:

fc582cd26e88 ("io_uring/msg_ring: ensure io_kiocb freeing is deferred for RCU")

fixed an issue with not deferring freeing of io_kiocb structs that
msg_ring allocates to after the current RCU grace period. But this only
covers requests that don't end up in the allocation cache. If a request
goes into the alloc cache, it can get reused before it is sane to do so.
A recent syzbot report would seem to indicate that there's something
there, however it may very well just be because of the KASAN poisoning
that the alloc_cache handles manually.

Rather than attempt to make the alloc_cache sane for that use case, just
drop the usage of the alloc_cache for msg_ring request payload data.

Fixes: 50cf5f3842af ("io_uring/msg_ring: add an alloc cache for io_kiocb entries")
Link: https://lore.kernel.org/io-uring/68cc2687.050a0220.139b6.0005.GAE@google.com/
Reported-by: syzbot+baa2e0f4e02df602583e@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 80a178f3d896..12f5ee43850e 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -420,9 +420,6 @@ struct io_ring_ctx {
 	struct list_head		defer_list;
 	unsigned			nr_drained;
 
-	struct io_alloc_cache		msg_cache;
-	spinlock_t			msg_lock;
-
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	struct list_head	napi_list;	/* track busy poll napi_id */
 	spinlock_t		napi_lock;	/* napi_list lock */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bcec12256f34..93665cebe9bd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -290,7 +290,6 @@ static void io_free_alloc_caches(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
 	io_alloc_cache_free(&ctx->cmd_cache, io_cmd_cache_free);
-	io_alloc_cache_free(&ctx->msg_cache, kfree);
 	io_futex_cache_free(ctx);
 	io_rsrc_cache_free(ctx);
 }
@@ -337,9 +336,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	ret |= io_alloc_cache_init(&ctx->cmd_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_async_cmd),
 			    sizeof(struct io_async_cmd));
-	spin_lock_init(&ctx->msg_lock);
-	ret |= io_alloc_cache_init(&ctx->msg_cache, IO_ALLOC_CACHE_MAX,
-			    sizeof(struct io_kiocb), 0);
 	ret |= io_futex_cache_init(ctx);
 	ret |= io_rsrc_cache_init(ctx);
 	if (ret)
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 4c2578f2efcb..5e5b94236d72 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -11,7 +11,6 @@
 #include "io_uring.h"
 #include "rsrc.h"
 #include "filetable.h"
-#include "alloc_cache.h"
 #include "msg_ring.h"
 
 /* All valid masks for MSG_RING */
@@ -76,13 +75,7 @@ static void io_msg_tw_complete(struct io_kiocb *req, io_tw_token_t tw)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_add_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, req->cqe.flags);
-	if (spin_trylock(&ctx->msg_lock)) {
-		if (io_alloc_cache_put(&ctx->msg_cache, req))
-			req = NULL;
-		spin_unlock(&ctx->msg_lock);
-	}
-	if (req)
-		kfree_rcu(req, rcu_head);
+	kfree_rcu(req, rcu_head);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -104,26 +97,13 @@ static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	return 0;
 }
 
-static struct io_kiocb *io_msg_get_kiocb(struct io_ring_ctx *ctx)
-{
-	struct io_kiocb *req = NULL;
-
-	if (spin_trylock(&ctx->msg_lock)) {
-		req = io_alloc_cache_get(&ctx->msg_cache);
-		spin_unlock(&ctx->msg_lock);
-		if (req)
-			return req;
-	}
-	return kmem_cache_alloc(req_cachep, GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO);
-}
-
 static int io_msg_data_remote(struct io_ring_ctx *target_ctx,
 			      struct io_msg *msg)
 {
 	struct io_kiocb *target;
 	u32 flags = 0;
 
-	target = io_msg_get_kiocb(target_ctx);
+	target = kmem_cache_alloc(req_cachep, GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO)  ;
 	if (unlikely(!target))
 		return -ENOMEM;
 
-- 
Jens Axboe


