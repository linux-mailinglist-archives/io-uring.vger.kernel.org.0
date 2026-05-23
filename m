Return-Path: <io-uring+bounces-13492-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KECGFlIDEmqntQYAu9opvQ
	(envelope-from <io-uring+bounces-13492-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 21:43:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D9A6C5C078D
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 21:43:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B79673006477
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 19:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F31FE333429;
	Sat, 23 May 2026 19:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="knl2A0RY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C879D269CE6;
	Sat, 23 May 2026 19:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779565389; cv=none; b=LNXWOv+2nIb0bbyTO3hkmwjN75vxnIeno42/2NwF5kcSIQO1lioYelZx7dafcuSdgVqHhKgfNY74A/yF+1Eg/4ri0NmNzUui1218q89V2uTutScboiiOkdVzuI1Rp82hsYqumXCPjdCMxzBn923CIJp8nR0Vj2hvDMxMglKuYfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779565389; c=relaxed/simple;
	bh=OzRx4Jea/gQowRgqur1LzxDMUuIgE+6OcV41//cfvS0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GF7eyF4KHev8Jh/H8pn2trWcA05mA/B8/oLM5T2g/KeIhr1s9w/xIc52rslRv31CQIBj8w8ny13ufJg21QDlDkV0oO0MpfCzoVnliTEuMEtmOXcFAJk0TCyRVc3i+3J3zvrrvhYzvydwTo10QCTkwxg+KzCYjxtdIvO4t7a2rP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=knl2A0RY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90CD5C2BCF5;
	Sat, 23 May 2026 19:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779565389;
	bh=OzRx4Jea/gQowRgqur1LzxDMUuIgE+6OcV41//cfvS0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=knl2A0RYLu6aIFzU87tH3SBjrcf/u7kNd4FpOXmXiV3CP6UPAMrjie9ToMOyUVABc
	 6Zp3WIo3C1rmkisFUl9G4PQIvA2qrvIOfjDetWjGr5jMYALEwEY2vZxrWyhh0kGN+5
	 XFVllvQeLK/B7h1hTWLC+eYRJiwLQZG/0LSzv7c5jxYCnwwZDl9zEjcdchJyFWHNEh
	 sZu5huo7RIlEPyFpD1qaj+hbo0Aiwyx3gAGy4d9BBq2yVm4WoVxsg1H38HHRD8elhF
	 qMOzFbZmPkDlkE31JOGdUhC1vepCKl4iSFTaPGhi6OnD2nUrkIXHrEZfE+lZ8rdpXb
	 U5jVdMt9Yk46A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85334CD5BB8;
	Sat, 23 May 2026 19:43:09 +0000 (UTC)
From: Demi Marie Obenour via B4 Relay <devnull+demiobenour.gmail.com@kernel.org>
Date: Sat, 23 May 2026 15:43:04 -0400
Subject: [PATCH 3/3] AF_ALG: Document that it is *always* slower
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-af-alg-harden-v1-3-c76755c3a5c5@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779565388; l=2773;
 i=demiobenour@gmail.com; s=20250731; h=from:subject:message-id;
 bh=cCZclUN91iyFrsr3PZ6oslmjWDYG7uvJ1BorPBKSILk=;
 b=tMvuqZQCtqZsAaMqHEV39cBc/++4hmxFbFBMdRmtHQtjclb/Ws8rPWSMTsw9+kwtC7mX2BxyO
 lWvyv8MjokkBQ9W7YuISmmpzpSoOKpUxcuzWE1mfMgEZmwyHZtvfm6N
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13492-lists,io-uring=lfdr.de,demiobenour.gmail.com];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: D9A6C5C078D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Demi Marie Obenour <demiobenour@gmail.com>

Without support for zero-copy or off-CPU offloads, AF_ALG is always
slower than software cryptography. Its only advantage is that it might
save code size. However, this is largely mitigated by lightweight
userspace cryptographic libraries.

Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
---
 Documentation/crypto/userspace-if.rst | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
index b31117d4415dda6ad6ca36275e615bec7df9552e..ab93300c8e04524469f284704c7c5ed582fdcbc0 100644
--- a/Documentation/crypto/userspace-if.rst
+++ b/Documentation/crypto/userspace-if.rst
@@ -28,8 +28,8 @@ functionality than that. It actually provides access to all software algorithms.
 
 This includes arbitrary compositions of different algorithms created via a
 complex template system, as well as algorithms that only make sense as internal
-implementation details of other algorithms. It also includes full zero-copy
-support, which is difficult for the kernel to implement securely.
+implementation details of other algorithms. In the past, it also included full
+zero-copy support, which was difficult for the kernel to implement securely.
 
 Ultimately, these algorithms are just math computations. They use the same
 instructions that userspace programs already have access to, just accessed in a
@@ -38,6 +38,21 @@ much more convoluted and less efficient way.
 Indeed, userspace code is nearly always what is being used anyway. These same
 algorithms are widely implemented in userspace crypto libraries.
 
+Even when zero-copy and off-CPU accelerators were supported, AF_ALG was usually
+much slower than optimized software cryptography in userspace. This was
+especially true for the small message sizes usually seen in performance-critical
+workloads. While it was possible to demonstrate performance wins for hashing
+large files on embedded devices, it is hard to imagine a situation where this
+would be performance-critical.
+
+Nowadays, AF_ALG no longer supports zero-copy or off-CPU accelerators.
+Therefore, it is *always* slower than an optimized userspace implementation,
+even for large messages. The only possible advantage left is that it avoids
+duplicating code between kernel and userspace. However, userspace
+implementations, especially hardware-accelerated ones, do not need to be large.
+Just because OpenSSL is huge does not mean that all userspace cryptography
+libraries are.
+
 Meanwhile, AF_ALG hasn't been withstanding modern vulnerability discovery tools
 such as syzbot and large language models. It receives a steady stream of CVEs.
 Some of the examples include:

-- 
2.54.0



