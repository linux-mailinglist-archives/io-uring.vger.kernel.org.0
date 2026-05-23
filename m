Return-Path: <io-uring+bounces-13494-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6D+DJ2sDEmqntQYAu9opvQ
	(envelope-from <io-uring+bounces-13494-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 21:43:39 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BBB15C07CB
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 21:43:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B6C32301C16C
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 19:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10D6133A03F;
	Sat, 23 May 2026 19:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N1W7libw"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C892D30C606;
	Sat, 23 May 2026 19:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779565389; cv=none; b=rubHpQB+2r/SRLmCleTOplK/txevwF3folcK+Lra66WIWxDSaNY4gPG/dVGIsT9CVuQDdABoshARVlsYHzrht/6kYGlD7aQxS/fAwDW9kk0sQ8zP0e7ZFIhQpZVM27moBpTI/BL6QHPn5JoMtUqAqSmL7Rri2SpHGyzQsgHEleI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779565389; c=relaxed/simple;
	bh=D3zxq48jpNb8NeX8OBIi5fswzSbQEgmlY+KRsUrVG/o=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=asEtAFrckqqDcFDg6itGW9DzD0bHrX4SUHx4AuL9f8nGiXDWzQyQqmdX6ndj7xM6/8gRIJRM+XC8Au6sChjyUmC+Tbt/QaYMnut3iCOWYsnUXKY6/4Wa0wrebWHyB/n1GoF1PYnKvBM4ERuq7O0VvBN5zmnxq20F38hQlRPWGa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N1W7libw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 636C6C2BCB0;
	Sat, 23 May 2026 19:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779565389;
	bh=D3zxq48jpNb8NeX8OBIi5fswzSbQEgmlY+KRsUrVG/o=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=N1W7libwE4pGw34rdpUaYygrGuVgH4XFm8AxUcVSxmj6nqnanNSxFh/uEz+Xvxfab
	 /ouAj5rlypPe3VJNhi/k8FHRELxD35Rs/PapDF35s/pIK2yOBQlEDa9uej9bHhZASA
	 yGObZxnEwTxKrBuQu+MUpt3Bml7vRUG1zDQJSOTnuR9eim9WFj9X2xz/cDIdXzHdp3
	 ndtRItrgtK24O4qaxecV1luOdQvmAYr3jpFIekM+AyEhjsNUf5B+FYAQtiSHaqeyPB
	 ok3SQGNyuZEOdRhuQJxm8jVWcC8jKtG1wgb/GzbIzMJM+tnokdV7FPiwj+hyNQOVvt
	 dGJYiO73DRmBQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B0DCD5BC6;
	Sat, 23 May 2026 19:43:09 +0000 (UTC)
From: Demi Marie Obenour via B4 Relay <devnull+demiobenour.gmail.com@kernel.org>
Subject: [PATCH 0/3] AF_ALG: Remove support for AIO and old-style drivers
Date: Sat, 23 May 2026 15:43:01 -0400
Message-Id: <20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDUwMj3cQ03cScdN2MxKKU1DxdSwMDCxNLE1NDM1NjJaCegqLUtMwKsHn
 RsbW1AAl0ZOpfAAAA
X-Change-ID: 20260502-af-alg-harden-900849451653
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779565388; l=1545;
 i=demiobenour@gmail.com; s=20250731; h=from:subject:message-id;
 bh=D3zxq48jpNb8NeX8OBIi5fswzSbQEgmlY+KRsUrVG/o=;
 b=UWO/qocMd43s589G/tauUvyAgol1bxSgtpx423ChGfzN9f//3VW16eJhzkctofOPU6zoYSfaG
 lOI3O1+/rnwA0dZf4yBziamZeyECAINgeTNroGcSZIlvhNlXeYFNVWc
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13494-lists,io-uring=lfdr.de,demiobenour.gmail.com];
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
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 2BBB15C07CB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

AF_ALG is a deprecated API only useful for compatibility with existing
userspace.  It has had a lot of vulnerabilities, including the infamous
CopyFail.

Rip out support for offload drivers, which tend to be buggy.  Also rip
out support for AIO, which actually bloats the entire socket subsystem.

Only compile-tested.

Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
---
Demi Marie Obenour (3):
      net: Remove support for AIO on sockets
      AF_ALG: Drop support for off-CPU cryptography
      AF_ALG: Document that it is *always* slower

 Documentation/crypto/userspace-if.rst          | 26 ++++++++--
 crypto/af_alg.c                                | 35 ++------------
 crypto/algif_aead.c                            | 43 ++++-------------
 crypto/algif_hash.c                            |  4 +-
 crypto/algif_rng.c                             |  4 +-
 crypto/algif_skcipher.c                        | 66 ++++++--------------------
 include/crypto/if_alg.h                        | 19 ++++++--
 include/linux/socket.h                         |  1 -
 io_uring/net.c                                 |  1 -
 net/compat.c                                   |  1 -
 net/socket.c                                   |  7 +--
 tools/perf/trace/beauty/include/linux/socket.h |  1 -
 12 files changed, 70 insertions(+), 138 deletions(-)
---
base-commit: 49e05bb00f2e8168695f7af4d694c39e1423e8a2
change-id: 20260502-af-alg-harden-900849451653

Best regards,
-- 
Demi Marie Obenour <demiobenour@gmail.com>



