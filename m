Return-Path: <io-uring+bounces-13493-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qKs6F1YDEmqntQYAu9opvQ
	(envelope-from <io-uring+bounces-13493-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 21:43:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B4125C079D
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 21:43:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CD07230095D4
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 19:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A13333987F;
	Sat, 23 May 2026 19:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJbsgTWu"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C889B2F83A2;
	Sat, 23 May 2026 19:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779565389; cv=none; b=Ek19lvAXk20tiGJxE1ckEWadga5bvAI2LlSRpGXin6UZqoaQddwouJcRfmuXYR7EA/OKln5aOEDGsM1SafLbwfR+9QXyuIZJ8tE2+C1DoQtITc0Z0zifE3hU3L2SUpspuC0elU6uDYz359xAogz7w5IKxw9sM/nS5w0EjxzXWpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779565389; c=relaxed/simple;
	bh=4x+kkur+itTL+nDNhRSO2XwvgLTLFONJnU89392Z2Vs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aLBt6c9CT6uyVUSO2EAd0C9BsBDqJGWLX/1TnDJBL+R43wjZRRDxvueQi3+DQ8NQa0K+3N7pVFNlvvMCCJyZ6ynkXbM/4GCYzzCk02Py7wYW3zGMUsulEijswBlGU0o0CTwT6l8V7AZ99UuHW9QfeFqLMiUiHwUZzzlTsfKgESo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJbsgTWu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86A34C4AF09;
	Sat, 23 May 2026 19:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779565389;
	bh=4x+kkur+itTL+nDNhRSO2XwvgLTLFONJnU89392Z2Vs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rJbsgTWuJl+X3OY5erMcPNBSa/w9leRseYmrl6tN4cngzWrEKZpIVOsmTkvM76t9c
	 Eds0RYlp4LU05ENmBSeZPJP348BDz4cOXEqNkVB+lk/bcJGHg0MFVj5ZjKodf3cZmT
	 Kvh8fdd8gbmlluKv6UCMLlbf0qHaXW4AlAXrI9zBTmWkejL497VUNuHuXlRTDVBdk5
	 o0cULeKnfVS/96+TBXCbS9JL3bBHLtG30uyR+i2JPZMFaDrghQOYUps0WjyQWWqW/v
	 FP5rnWsRp8RJ0af/Cbygi8GlZXvqvZ+n8Y3CX9bpKAlEkhbqsUp6ynEt8btimH1nDN
	 BAwYWpfQwGgOQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766E9CD5BC7;
	Sat, 23 May 2026 19:43:09 +0000 (UTC)
From: Demi Marie Obenour via B4 Relay <devnull+demiobenour.gmail.com@kernel.org>
Date: Sat, 23 May 2026 15:43:03 -0400
Subject: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779565388; l=6842;
 i=demiobenour@gmail.com; s=20250731; h=from:subject:message-id;
 bh=WvOsgYHUhof7lfEUPLefwcNPmpsYzNcw3EP4UmhJBvQ=;
 b=tOimiiGZzW9nPiZOY/pmr9YuzEsYZH6qY4xlblpCOVSlHm1Vxy18eK4FnE3vInfagtRspluWZ
 HbAqXq5Uw+4CheXH8HBI0vPX9cDE0K9IUMBEo9fknx5MbHnW7mQmmIe
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13493-lists,io-uring=lfdr.de,demiobenour.gmail.com];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 4B4125C079D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Demi Marie Obenour <demiobenour@gmail.com>

AF_ALG is deprecated and exposed to unprivileged userspace.  Only
use the least buggy algorithm implementations: the pure software ones.

This removes one of the main advantages of AF_ALG, which is the
ability to use it with off-CPU accelerators.  However, using off-CPU
accelerators has huge overheads, both in performance and attack surface.
I have yet to see real-world, performance-critical workloads where using
an accelerator via AF_ALG is actually a win over doing cryptography in
userspace.

If using an off-CPU accelerator really does turn out to be a win, a new
API should be developed that is actually a good fit for it.

Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
---
 Documentation/crypto/userspace-if.rst |  7 ++++++-
 crypto/af_alg.c                       |  2 +-
 crypto/algif_aead.c                   |  4 ++--
 crypto/algif_hash.c                   |  4 ++--
 crypto/algif_rng.c                    |  4 ++--
 crypto/algif_skcipher.c               |  4 ++--
 include/crypto/if_alg.h               | 14 +++++++++++++-
 7 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
index ea1b1b3f4049fd4673528dc2a6234f6376a3489f..b31117d4415dda6ad6ca36275e615bec7df9552e 100644
--- a/Documentation/crypto/userspace-if.rst
+++ b/Documentation/crypto/userspace-if.rst
@@ -9,7 +9,8 @@ symmetric cipher, AEAD, and RNG algorithms that are implemented in kernel-mode
 code.
 
 AF_ALG is insecure and is deprecated. Originally added to the kernel in 2010,
-most kernel developers now consider it to be a mistake.
+most kernel developers now consider it to be a mistake. Support for hardware
+accelerators, which was the original purpose of AF_ALG, has been removed.
 
 AF_ALG continues to be supported only for backwards compatibility. On systems
 where no programs using AF_ALG remain, the support for it should be disabled by
@@ -59,6 +60,10 @@ Some of the examples include:
 - CVE-2013-7421
 - CVE-2011-4081
 
+Hardware accelerator drivers are frequently buggy. To reduce attack surface,
+AF_ALG now only provides access to algorithms implemented in software. This
+means that AF_ALG no longer fulfills its original purpose.
+
 It is recommended that, whenever possible, userspace programs be migrated to
 userspace crypto code (which again, is what is normally used anyway) and
 ``CONFIG_CRYPTO_USER_API_*`` be disabled.  On systems that use SELinux, SELinux
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 8ccf7a737cd6ca9a5d5bf47050c9afea0dfd61bf..cce000e8590e469927b5a5a0ceccfdf0ef54633d 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -181,7 +181,7 @@ static int alg_bind(struct socket *sock, struct sockaddr_unsized *uaddr, int add
 	if (IS_ERR(type))
 		return PTR_ERR(type);
 
-	private = type->bind(sa->salg_name, sa->salg_feat, sa->salg_mask);
+	private = type->bind(sa->salg_name);
 	if (IS_ERR(private)) {
 		module_put(type->owner);
 		return PTR_ERR(private);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 60f06597cb0b13036bc975641a0b02ea8a41ad03..787aac8aeb24eed128f08345ba730478113919b3 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -342,9 +342,9 @@ static struct proto_ops algif_aead_ops_nokey = {
 	.poll		=	af_alg_poll,
 };
 
-static void *aead_bind(const char *name, u32 type, u32 mask)
+static void *aead_bind(const char *name)
 {
-	return crypto_alloc_aead(name, type, mask);
+	return crypto_alloc_aead(name, 0, AF_ALG_CRYPTOAPI_MASK);
 }
 
 static void aead_release(void *private)
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 4d3dfc60a16a6d8b677d903d209df18d67202c98..5452ad6c15069c3cb0ff78fe58868fe7ce4b0fc3 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -380,9 +380,9 @@ static struct proto_ops algif_hash_ops_nokey = {
 	.accept		=	hash_accept_nokey,
 };
 
-static void *hash_bind(const char *name, u32 type, u32 mask)
+static void *hash_bind(const char *name)
 {
-	return crypto_alloc_ahash(name, type, mask);
+	return crypto_alloc_ahash(name, 0, AF_ALG_CRYPTOAPI_MASK);
 }
 
 static void hash_release(void *private)
diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index a9fb492e929a70c94476f296f5f5e7c42f0313b7..4dfe7899f8fa4ce82d5f2236297230fb44bc35d6 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -197,7 +197,7 @@ static struct proto_ops __maybe_unused algif_rng_test_ops = {
 	.sendmsg	=	rng_test_sendmsg,
 };
 
-static void *rng_bind(const char *name, u32 type, u32 mask)
+static void *rng_bind(const char *name)
 {
 	struct rng_parent_ctx *pctx;
 	struct crypto_rng *rng;
@@ -206,7 +206,7 @@ static void *rng_bind(const char *name, u32 type, u32 mask)
 	if (!pctx)
 		return ERR_PTR(-ENOMEM);
 
-	rng = crypto_alloc_rng(name, type, mask);
+	rng = crypto_alloc_rng(name, 0, AF_ALG_CRYPTOAPI_MASK);
 	if (IS_ERR(rng)) {
 		kfree(pctx);
 		return ERR_CAST(rng);
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 9dbccabd87b13920c27aff5a450a235cc6a27d59..df20bdfe1f1f4e453782dee3b743dd1939ab4c6c 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -307,9 +307,9 @@ static struct proto_ops algif_skcipher_ops_nokey = {
 	.poll		=	af_alg_poll,
 };
 
-static void *skcipher_bind(const char *name, u32 type, u32 mask)
+static void *skcipher_bind(const char *name)
 {
-	return crypto_alloc_skcipher(name, type, mask);
+	return crypto_alloc_skcipher(name, 0, AF_ALG_CRYPTOAPI_MASK);
 }
 
 static void skcipher_release(void *private)
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 62867daca47d76c9ea1a7ed233188788c5f6c3c0..7643ba954125aba0c06aaf19de087985325885ad 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -41,7 +41,7 @@ struct af_alg_control {
 };
 
 struct af_alg_type {
-	void *(*bind)(const char *name, u32 type, u32 mask);
+	void *(*bind)(const char *name);
 	void (*release)(void *private);
 	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
 	int (*setentropy)(void *private, sockptr_t entropy, unsigned int len);
@@ -243,4 +243,16 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 		    struct af_alg_async_req *areq, size_t maxsize,
 		    size_t *outlen);
 
+/*
+ * Mask used to disable unsupported algorithm implementations.
+ *
+ * This is the same as FSCRYPT_CRYPTOAPI_MASK in fs/crypto/fscrypt_private.h.
+ * In additions to the motivations there, this API is exposed to userspace
+ * that might not be fully trusted.
+ */
+#define AF_ALG_CRYPTOAPI_MASK                             \
+	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | \
+	 CRYPTO_ALG_KERN_DRIVER_ONLY)
+
+
 #endif	/* _CRYPTO_IF_ALG_H */

-- 
2.54.0



