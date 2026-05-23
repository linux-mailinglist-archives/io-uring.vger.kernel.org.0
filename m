Return-Path: <io-uring+bounces-13491-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4AdPKFUDEmqntQYAu9opvQ
	(envelope-from <io-uring+bounces-13491-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 21:43:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC335C079B
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 21:43:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 677A73009380
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 19:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED30932B11C;
	Sat, 23 May 2026 19:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J3DuJEtx"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88312D3EC7;
	Sat, 23 May 2026 19:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779565389; cv=none; b=NDAv0se93hvBdmakv75t4PralmPnwH9S6E3qM8+3Kpo/MzFOOmiaAwDRQ9uRDuE/84E7Y7cl76AyWdTzVtrjtFCiRk+FQYqi/oOtqRpdKtYVNW9mF4aNLslLRCgUFvuncpSI9G6kgv+xH02qvPzHe86kaI/FOw5kGeWeLXsfGDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779565389; c=relaxed/simple;
	bh=DIqx3AgEaekumcir7z4dd96izRL4ntx2FIL2t/OUE5E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aEP2+XNlgVfamXVPuoFttppAywCHRe29LLF/UUCH5zShH5R8ZaVFNocl2oF5+c7Tp1bZjUQnjsCiNLeV6KgPcdahRfkYzhS9Y+Frm59JrbsNDCeC2UoI0KNQsc4TTkFJf2u/QurfRAN2BSl5YgDTyHeHfxwag8IZJgnyAHsv6og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J3DuJEtx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EA40C2BCB8;
	Sat, 23 May 2026 19:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779565389;
	bh=DIqx3AgEaekumcir7z4dd96izRL4ntx2FIL2t/OUE5E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=J3DuJEtxIXXpFTZFQjzaAjJ5zgn8UQpRrk3PWGoAszcTes5rQHxlw09TcFrVa/NKV
	 3GUMCy/GjwP+MK52USEqXxM+44et3pZ1+D47P5oTGVhetlgprv+nYBra5gEVoY6pbI
	 qBELdNBR1uluDuXzT20tf27EHoYHLSQbfmxCFZO4YcB8JEfsmUP/wDow9VffgfzBXt
	 jdDQOE7tor58AHh4KOPQMEPO4mYB3ibkHeLp/r+gNC7Pa1m7iAbH0g3NkTO4l22x5n
	 MyjJqnPetj2dEz+AT6dy+qsrcQ8HNzoh2c4m2YI7PJY84B/hCrtaprU00i4VNQnI9g
	 YsyvvmAkdLNYA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D3FCD5BB1;
	Sat, 23 May 2026 19:43:09 +0000 (UTC)
From: Demi Marie Obenour via B4 Relay <devnull+demiobenour.gmail.com@kernel.org>
Date: Sat, 23 May 2026 15:43:02 -0400
Subject: [PATCH 1/3] net: Remove support for AIO on sockets
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-af-alg-harden-v1-1-c76755c3a5c5@gmail.com>
References: <20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com>
In-Reply-To: <20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, 
 Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 Demi Marie Obenour <demiobenour@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779565388; l=11844;
 i=demiobenour@gmail.com; s=20250731; h=from:subject:message-id;
 bh=X4VpiwrEjiilqzmO26Lw8ocnY8n8PVtOcMW3zv/PW5M=;
 b=6qKjn9u6wn2u2hWtWsysheyBTd7UHG7kVKQYGIioKUJEsOegRhNcWJ72Cy0OEOte+9lRHK87v
 VdyS6TDXuZTC3+VOVpU6lzm4DVDbHFqXMnPDORctVqwON1KrrE4pf1H
X-Developer-Key: i=demiobenour@gmail.com; a=ed25519;
 pk=4iGY+ynEKxIfs+fIUK9EzsvZ44yGE0GvXLeLTPKKPhI=
X-Endpoint-Received: by B4 Relay for demiobenour@gmail.com/20250731 with
 auth_id=473
X-Original-From: Demi Marie Obenour <demiobenour@gmail.com>
Reply-To: demiobenour@gmail.com
X-Spamd-Result: default: False [-0.16 / 15.00];
	FREEMAIL_REPLYTO_NEQ_FROM(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13491-lists,io-uring=lfdr.de,demiobenour.gmail.com];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_REPLYTO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[30];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	DKIM_TRACE(0.00)[kernel.org:+];
	HAS_REPLYTO(0.00)[demiobenour@gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[devnull@kernel.org,io-uring@vger.kernel.org];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 7FC335C079B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Demi Marie Obenour <demiobenour@gmail.com>

The only user of msg->msg_iocb was AF_ALG, but that's deprecated.
It can be removed entirely at the cost of only supporting synchronous
operations.  This doesn't break userspace, which will silently block
(for a bounded amount of time) in io_submit instead of operating
asynchronously.

This also makes struct msghdr smaller, helping every other caller of
sendmsg().

Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
---
 crypto/af_alg.c                                | 33 +-------------
 crypto/algif_aead.c                            | 39 ++++------------
 crypto/algif_skcipher.c                        | 62 +++++---------------------
 include/crypto/if_alg.h                        |  5 +--
 include/linux/socket.h                         |  1 -
 io_uring/net.c                                 |  1 -
 net/compat.c                                   |  1 -
 net/socket.c                                   |  7 +--
 tools/perf/trace/beauty/include/linux/socket.h |  1 -
 9 files changed, 25 insertions(+), 125 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 48c53f488e0fd30818e72439fe0c0d7e4cee1432..8ccf7a737cd6ca9a5d5bf47050c9afea0dfd61bf 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1085,35 +1085,6 @@ void af_alg_free_resources(struct af_alg_async_req *areq)
 }
 EXPORT_SYMBOL_GPL(af_alg_free_resources);
 
-/**
- * af_alg_async_cb - AIO callback handler
- * @data: async request completion data
- * @err: if non-zero, error result to be returned via ki_complete();
- *       otherwise return the AIO output length via ki_complete().
- *
- * This handler cleans up the struct af_alg_async_req upon completion of the
- * AIO operation.
- *
- * The number of bytes to be generated with the AIO operation must be set
- * in areq->outlen before the AIO callback handler is invoked.
- */
-void af_alg_async_cb(void *data, int err)
-{
-	struct af_alg_async_req *areq = data;
-	struct sock *sk = areq->sk;
-	struct kiocb *iocb = areq->iocb;
-	unsigned int resultlen;
-
-	/* Buffer size written by crypto operation. */
-	resultlen = areq->outlen;
-
-	af_alg_free_resources(areq);
-	sock_put(sk);
-
-	iocb->ki_complete(iocb, err ? err : (int)resultlen);
-}
-EXPORT_SYMBOL_GPL(af_alg_async_cb);
-
 /**
  * af_alg_poll - poll system call handler
  * @file: file pointer
@@ -1154,8 +1125,8 @@ struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
 	struct af_alg_ctx *ctx = alg_sk(sk)->private;
 	struct af_alg_async_req *areq;
 
-	/* Only one AIO request can be in flight. */
-	if (ctx->inflight)
+	/* Only one request can be in flight. */
+	if (WARN_ON_ONCE(ctx->inflight))
 		return ERR_PTR(-EBUSY);
 
 	areq = sock_kmalloc(sk, areqlen, GFP_KERNEL);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index c6c2ce21895dd7df51dc825ed886ba7e1aa37130..60f06597cb0b13036bc975641a0b02ea8a41ad03 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -197,37 +197,14 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	aead_request_set_ad(&areq->cra_u.aead_req, ctx->aead_assoclen);
 	aead_request_set_tfm(&areq->cra_u.aead_req, tfm);
 
-	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
-		/* AIO operation */
-		sock_hold(sk);
-		areq->iocb = msg->msg_iocb;
-
-		/* Remember output size that will be generated. */
-		areq->outlen = outlen;
-
-		aead_request_set_callback(&areq->cra_u.aead_req,
-					  CRYPTO_TFM_REQ_MAY_SLEEP,
-					  af_alg_async_cb, areq);
-		err = ctx->enc ? crypto_aead_encrypt(&areq->cra_u.aead_req) :
-				 crypto_aead_decrypt(&areq->cra_u.aead_req);
-
-		/* AIO operation in progress */
-		if (err == -EINPROGRESS)
-			return -EIOCBQUEUED;
-
-		sock_put(sk);
-	} else {
-		/* Synchronous operation */
-		aead_request_set_callback(&areq->cra_u.aead_req,
-					  CRYPTO_TFM_REQ_MAY_SLEEP |
-					  CRYPTO_TFM_REQ_MAY_BACKLOG,
-					  crypto_req_done, &ctx->wait);
-		err = crypto_wait_req(ctx->enc ?
-				crypto_aead_encrypt(&areq->cra_u.aead_req) :
-				crypto_aead_decrypt(&areq->cra_u.aead_req),
-				&ctx->wait);
-	}
-
+	aead_request_set_callback(&areq->cra_u.aead_req,
+				  CRYPTO_TFM_REQ_MAY_SLEEP |
+				  CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  crypto_req_done, &ctx->wait);
+	err = crypto_wait_req(ctx->enc ?
+			crypto_aead_encrypt(&areq->cra_u.aead_req) :
+			crypto_aead_decrypt(&areq->cra_u.aead_req),
+			&ctx->wait);
 
 free:
 	af_alg_free_resources(areq);
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ba0a17fd95aca22aa58ebf510c7d9b5f0cea2c2e..9dbccabd87b13920c27aff5a450a235cc6a27d59 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -79,20 +79,6 @@ static int algif_skcipher_export(struct sock *sk, struct skcipher_request *req)
 	return err;
 }
 
-static void algif_skcipher_done(void *data, int err)
-{
-	struct af_alg_async_req *areq = data;
-	struct sock *sk = areq->sk;
-
-	if (err)
-		goto out;
-
-	err = algif_skcipher_export(sk, &areq->cra_u.skcipher_req);
-
-out:
-	af_alg_async_cb(data, err);
-}
-
 static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 			     size_t ignored, int flags)
 {
@@ -171,43 +157,19 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		cflags |= CRYPTO_SKCIPHER_REQ_CONT;
 	}
 
-	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
-		/* AIO operation */
-		sock_hold(sk);
-		areq->iocb = msg->msg_iocb;
+	skcipher_request_set_callback(&areq->cra_u.skcipher_req,
+				      cflags |
+				      CRYPTO_TFM_REQ_MAY_SLEEP |
+				      CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      crypto_req_done, &ctx->wait);
+	err = crypto_wait_req(ctx->enc ?
+		crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
+		crypto_skcipher_decrypt(&areq->cra_u.skcipher_req),
+					 &ctx->wait);
 
-		/* Remember output size that will be generated. */
-		areq->outlen = len;
-
-		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
-					      cflags |
-					      CRYPTO_TFM_REQ_MAY_SLEEP,
-					      algif_skcipher_done, areq);
-		err = ctx->enc ?
-			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
-			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
-
-		/* AIO operation in progress */
-		if (err == -EINPROGRESS)
-			return -EIOCBQUEUED;
-
-		sock_put(sk);
-	} else {
-		/* Synchronous operation */
-		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
-					      cflags |
-					      CRYPTO_TFM_REQ_MAY_SLEEP |
-					      CRYPTO_TFM_REQ_MAY_BACKLOG,
-					      crypto_req_done, &ctx->wait);
-		err = crypto_wait_req(ctx->enc ?
-			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
-			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req),
-						 &ctx->wait);
-
-		if (!err)
-			err = algif_skcipher_export(
-				sk, &areq->cra_u.skcipher_req);
-	}
+	if (!err)
+		err = algif_skcipher_export(
+			sk, &areq->cra_u.skcipher_req);
 
 free:
 	af_alg_free_resources(areq);
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 0cc8fa749f68d2356789f72771c9e550b79e0b3d..62867daca47d76c9ea1a7ed233188788c5f6c3c0 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -80,7 +80,6 @@ struct af_alg_rsgl {
 
 /**
  * struct af_alg_async_req - definition of crypto request
- * @iocb:		IOCB for AIO operations
  * @sk:			Socket the request is associated with
  * @first_rsgl:		First RX SG
  * @last_rsgl:		Pointer to last RX SG
@@ -92,7 +91,6 @@ struct af_alg_rsgl {
  * @cra_u:		Cipher request
  */
 struct af_alg_async_req {
-	struct kiocb *iocb;
 	struct sock *sk;
 
 	struct af_alg_rsgl first_rsgl;
@@ -138,7 +136,7 @@ struct af_alg_async_req {
  * @write:		True if we are in the middle of a write.
  * @init:		True if metadata has been sent.
  * @len:		Length of memory allocated for this data structure.
- * @inflight:		Non-zero when AIO requests are in flight.
+ * @inflight:		Non-zero when requests are in flight, for debugging only.
  */
 struct af_alg_ctx {
 	struct list_head tsgl_list;
@@ -237,7 +235,6 @@ int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min);
 int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		   unsigned int ivsize);
 void af_alg_free_resources(struct af_alg_async_req *areq);
-void af_alg_async_cb(void *data, int err);
 __poll_t af_alg_poll(struct file *file, struct socket *sock,
 			 poll_table *wait);
 struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
diff --git a/include/linux/socket.h b/include/linux/socket.h
index ec4a0a0257939a5363c55bed3ccb20182965b2e3..3ffdfe184b23d0a739e095407e956885d116c299 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -89,7 +89,6 @@ struct msghdr {
 	bool		msg_get_inq : 1;/* return INQ after receive */
 	unsigned int	msg_flags;	/* flags on received message */
 	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
-	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
 	struct ubuf_info *msg_ubuf;
 	int (*sg_from_iter)(struct sk_buff *skb,
 			    struct iov_iter *from, size_t length);
diff --git a/io_uring/net.c b/io_uring/net.c
index 30cd22c0b934b97ce6e265756b24daca7d398361..22100933966af547dfe6a52e69fc6882b4197234 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -771,7 +771,6 @@ static int io_recvmsg_prep_setup(struct io_kiocb *req)
 		kmsg->msg.msg_control = NULL;
 		kmsg->msg.msg_get_inq = 1;
 		kmsg->msg.msg_controllen = 0;
-		kmsg->msg.msg_iocb = NULL;
 		kmsg->msg.msg_ubuf = NULL;
 
 		if (req->flags & REQ_F_BUFFER_SELECT)
diff --git a/net/compat.c b/net/compat.c
index 2c9bd0edac997bc8c6ebd1bc8b92d8437ff32ea4..d68cf9c3aad5f7f1de84edbfffcf99d71e89292a 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -75,7 +75,6 @@ int __get_compat_msghdr(struct msghdr *kmsg,
 	if (msg->msg_iovlen > UIO_MAXIOV)
 		return -EMSGSIZE;
 
-	kmsg->msg_iocb = NULL;
 	kmsg->msg_ubuf = NULL;
 	return 0;
 }
diff --git a/net/socket.c b/net/socket.c
index 22a412fdec079cf8fd829a15236de9daea09d2f2..9785363858cef0c4e6f0efc45b17c3d2add5a53c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1213,8 +1213,7 @@ static ssize_t sock_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
 	struct socket *sock = file->private_data;
-	struct msghdr msg = {.msg_iter = *to,
-			     .msg_iocb = iocb};
+	struct msghdr msg = {.msg_iter = *to};
 	ssize_t res;
 
 	if (file->f_flags & O_NONBLOCK || (iocb->ki_flags & IOCB_NOWAIT))
@@ -1235,8 +1234,7 @@ static ssize_t sock_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
 	struct socket *sock = file->private_data;
-	struct msghdr msg = {.msg_iter = *from,
-			     .msg_iocb = iocb};
+	struct msghdr msg = {.msg_iter = *from};
 	ssize_t res;
 
 	if (iocb->ki_pos != 0)
@@ -2612,7 +2610,6 @@ int __copy_msghdr(struct msghdr *kmsg,
 	if (msg->msg_iovlen > UIO_MAXIOV)
 		return -EMSGSIZE;
 
-	kmsg->msg_iocb = NULL;
 	kmsg->msg_ubuf = NULL;
 	return 0;
 }
diff --git a/tools/perf/trace/beauty/include/linux/socket.h b/tools/perf/trace/beauty/include/linux/socket.h
index ec715ad4bf25f5f759d2cab3c6b796fed84df932..2a0a50fd66f41589f2699f7288a143873ce1bba6 100644
--- a/tools/perf/trace/beauty/include/linux/socket.h
+++ b/tools/perf/trace/beauty/include/linux/socket.h
@@ -89,7 +89,6 @@ struct msghdr {
 	bool		msg_get_inq : 1;/* return INQ after receive */
 	unsigned int	msg_flags;	/* flags on received message */
 	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
-	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
 	struct ubuf_info *msg_ubuf;
 	int (*sg_from_iter)(struct sk_buff *skb,
 			    struct iov_iter *from, size_t length);

-- 
2.54.0



