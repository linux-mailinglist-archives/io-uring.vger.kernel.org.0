Return-Path: <io-uring+bounces-13322-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eJWjMHqtBWrkZgIAu9opvQ
	(envelope-from <io-uring+bounces-13322-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 13:09:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 366DC540D1A
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 13:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4FA2A306C4DF
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 11:08:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063413AE6F5;
	Thu, 14 May 2026 11:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VSR7VXB3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B383C2B82
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 11:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778756887; cv=none; b=aB06RfNgz2yNVCbA7aqnWY544QpreHzdGAtKjQWCWOiULGdGbRuhWtsoaINML6cIMlwVFy+HwxXtOCNU4VzWfqZR6ps2p2imvwPPs26JDrAlpcNaW9YbSSxkDW9kQozIeNRdApMO1GvOCYp5i/4Pes5DYiaMWxge/Z20PQ+jJIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778756887; c=relaxed/simple;
	bh=8/PWbRCeO/sRlToHlGgz/mT0ec/JIbHMBe00Q2Ju67k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h86IgIfTOK4crJEvEIxZgqNTN3nlg8xYjpzHxCIsMlZfPGBiqLvH/z0uzgRR6LonlVltPgUGj7vN5fvH5aiK6X7oZBgbOE2NZPGEKuDXZk9jvmyXQrZpidbdSug75kAlVpXP1U+2x/GZU58mzBeq17hmfW1Gg2VxNv9vIJWGwP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VSR7VXB3; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-367cbac9c37so3923182a91.2
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 04:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778756878; x=1779361678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NA+mfcjnPsPVXMrSdkwMY5cAGi4uTsvmQrEylEodtUY=;
        b=VSR7VXB38KcW4OMLwJa2gUgDZxeELr4XGkpfPlTPWy1jP0rYmeTHr8/mGE6sns6+JM
         EBSHxlhaRbqBwumTd/d7/q+ARWcdM71hmbY7jdIfBXfxcykn7r0RPNRGgvOCx3KgTkxP
         1kLmUu81ZNMnigRKOURcVx9vD6acfQAsqj3k72IDwBfiFrnV+d0oqngSc6Q0Ozk8Nere
         OsQNzpT2bgeZ8Fq2uzrep4cLd7Gta9Wey9m14RRU56kcv41TnmgOmU7lbLk1O/puwhFd
         nkJMBVjHO7Rb5dTk4cuenv1bTmWDHNAUMIPq+SbJV3+DXXW//pI7qPCaRx7aD0+m2BrF
         cASg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778756878; x=1779361678;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NA+mfcjnPsPVXMrSdkwMY5cAGi4uTsvmQrEylEodtUY=;
        b=k7QPdAGxaW13xKbJwitwXfZmiDgS9NT0KBD/UIEgPgi0j1P3IYGiT0pI3yN8/jBqzx
         PRGhNMOy4GbimOXnZ40c26WYt3iSEX+gfJaQIC9Sw0erGQ7FQw74BZyb26AIvBzc211t
         4qYw7HKfhNhWvYe2qcDkkeSn01nWjRBqil0tt3B5ed0TBq2NxHlUFnuWMSay6/plsG68
         cSUqyWJjM+Maf28xvPb7U8eIPKLcUQ69I/fmij4h31NwW3bjrxrfM7d1CC1rIUQg1YuF
         sxPGyd7LqPBhlwk98ls/m9Ax7MWlL6eYmPVxWMmvMXDo4f57Woo9+6lhDLg/en25+YDv
         +x/A==
X-Gm-Message-State: AOJu0YxxM8CUZDAW+DDFG2ZjesZg821Acnz8JpOMl6gVZnBA5SxAlfWy
	uq/peAt1xOD4aDadgY9BdIEuXat59tsruQPwLYIAfkDUhvCAwELzvbr1Jt5RIA==
X-Gm-Gg: Acq92OGh/6yjVHWHSRfqBTRccwUlUFBMHbLztqCgVFQsPTH0UMIeVDm9wc3ocJaRuRM
	cnpp+985rSwwiD5zU/mm0etwUY5RS/Jk360kV2ftto6L4Nv+jwP/wjLrfFIzsXJHaAljvKTJpYC
	k+uThsEPSSb1hSgsf6lwTwkMUNi8pJIXVmbW6gPboIql9Kj7tfU8Fwgx8A0Yk02JDi6B2xD9KqV
	f5boeH/ppjc1+GCUvHBFqYPLRsvwjmqF8drhjeVu7TLjH2e9k2Vh0zi/6twFrrtV4q1AQVHli9T
	mlv51JyQXI2LBnmJBkCIdoITpwop4uJSzGm9EFuvhLKDRxERX1omJnjXo6X/uOWI1+4TFcivFb9
	d/+qNHabNJ0ISALuhUFbq1dgQtDtKQKaHRmH9a0u7mgjRsLuBQEHxUGbSRtX/ftvp2Q24vFBSuI
	ec0lfhb99gexcIgOTPKKqAy4R9TCIJtssBNnfNTFQE+QzkLlGzeCV3HX0esKtpkg==
X-Received: by 2002:a17:90b:4a:b0:35f:b572:ece9 with SMTP id 98e67ed59e1d1-368f3888ecfmr7371123a91.5.1778756877412;
        Thu, 14 May 2026 04:07:57 -0700 (PDT)
Received: from kali-linux-2025-2.localdomain ([106.219.120.163])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368ee32728fsm7805468a91.10.2026.05.14.04.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 04:07:56 -0700 (PDT)
From: Shouvik Kar <auxcorelabs@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Shouvik Kar <auxcorelabs@gmail.com>
Subject: [PATCH liburing v2] tests: add cBPF filter tests for IORING_OP_CONNECT
Date: Thu, 14 May 2026 16:37:51 +0530
Message-ID: <20260514110751.1927-1-auxcorelabs@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 366DC540D1A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,kernel.org];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13322-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[auxcorelabs@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Add subtests for IORING_OP_CONNECT to test/cbpf_filter.c, exercising
the io_connect_bpf_populate() helper added in the companion kernel
patch ("io_uring/net: allow filtering on IORING_OP_CONNECT").

Coverage spans both blacklist and whitelist filters for each
connect-specific data field (family, v4 address, v6 address, port),
plus v4 and v6 subnet matching, and a test for the addr_len guard
in io_connect_bpf_populate that prevents stale io_async_msghdr
cache from leaking through to the filter on short connects.

Signed-off-by: Shouvik Kar <auxcorelabs@gmail.com>
---
 test/cbpf_filter.c | 1591 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 1459 insertions(+), 132 deletions(-)

diff --git a/test/cbpf_filter.c b/test/cbpf_filter.c
index b80b1503..a7158b3a 100644
--- a/test/cbpf_filter.c
+++ b/test/cbpf_filter.c
@@ -15,6 +15,8 @@
 #include <sys/wait.h>
 #include <sys/prctl.h>
 #include <linux/filter.h>
+#include <netinet/in.h>
+#include <sys/un.h>
 
 #include "liburing.h"
 #include "liburing/io_uring/bpf_filter.h"
@@ -43,6 +45,61 @@
 #define CTX_OFF_OPEN_FLAGS	16	/* u64, use low 32 bits */
 #define CTX_OFF_OPEN_MODE	24	/* u64 */
 #define CTX_OFF_OPEN_RESOLVE	32	/* u64, use low 32 bits */
+/*
+ * connect: family @16 (u32), port @20 (__be16) + 2 pad,
+ *          v4_addr @24 (__be32) / v6_addr @24 (u8[16]).
+ * pdu_size = 24 (one __u32 + one __be16 + 2 pad + 16 bytes).
+ * v6_addr is 16 bytes, accessed as four 4-byte words at offsets 24,
+ * 28, 32, 36 via BPF_LD|BPF_W|BPF_ABS.
+ */
+#define CTX_OFF_CONNECT_FAMILY		16
+#define CTX_OFF_CONNECT_PORT		20
+#define CTX_OFF_CONNECT_V4_ADDR		24
+#define CTX_OFF_CONNECT_V6_ADDR_W0	24	/* v6 bytes  0-3 */
+#define CTX_OFF_CONNECT_V6_ADDR_W1	28	/* v6 bytes  4-7 */
+#define CTX_OFF_CONNECT_V6_ADDR_W2	32	/* v6 bytes  8-11 */
+#define CTX_OFF_CONNECT_V6_ADDR_W3	36	/* v6 bytes 12-15 */
+#define CONNECT_PDU_SIZE		24
+
+/*
+ * Compile-time __be16 swap. htons() is a function call and is not
+ * usable in static initializers like BPF_JUMP K constants.
+ */
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+# define CT_HTONS(x)	((__u16)(x))
+#else
+# define CT_HTONS(x)	((__u16)((((x) & 0xff) << 8) | (((x) >> 8) & 0xff)))
+#endif
+
+/*
+ * Compile-time K-constant for matching the __be16 port field via a
+ * BPF_LD|BPF_W|BPF_ABS load at CTX_OFF_CONNECT_PORT. The kernel
+ * populator writes port (__be16) at offset 20 with 2 zero pad bytes
+ * at offset 22-23, and bpf_prog_run reads in native host byte order.
+ * On LE the port lands in the low 16 bits; on BE the port lands in
+ * the high 16 bits. Pad bytes are guaranteed zero by the framework's
+ * memset, so no AND-mask is required.
+ */
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+# define CT_PORT_K(p)	((__u32)(p) << 16)
+#else
+# define CT_PORT_K(p)	((__u32)CT_HTONS(p))
+#endif
+
+/*
+ * Compile-time K-constant for matching a 4-byte address slice (one v4
+ * address, one dword of a v6 address, or a /N subnet mask/base) via a
+ * BPF_LD|BPF_W|BPF_ABS load. Pass the bytes in their on-the-wire
+ * (network byte order) order; the macro emits the host-order u32 that
+ * the BPF interpreter will see after loading those bytes.
+ */
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+# define CT_ADDR_K(a, b, c, d) \
+	(((__u32)(a) << 24) | ((__u32)(b) << 16) | ((__u32)(c) << 8) | (__u32)(d))
+#else
+# define CT_ADDR_K(a, b, c, d) \
+	(((__u32)(d) << 24) | ((__u32)(c) << 16) | ((__u32)(b) << 8) | (__u32)(a))
+#endif
 
 /*
  * Simple cBPF filter that allows all operations.
@@ -127,6 +184,193 @@ static struct sock_filter deny_resolve_in_root_filter[] = {
 	BPF_STMT(BPF_RET | BPF_K, 1),
 };
 
+/*
+ * cBPF filter that allows only AF_INET CONNECTs and denies everything
+ * else (a family-whitelist of AF_INET).
+ */
+static struct sock_filter connect_allow_family_filter[] = {
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_FAMILY),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET, 0, 1),
+	BPF_STMT(BPF_RET | BPF_K, 1),
+	BPF_STMT(BPF_RET | BPF_K, 0),
+};
+
+/*
+ * cBPF filter that denies AF_UNIX CONNECTs and allows everything else
+ * (a family-blacklist of AF_UNIX).
+ */
+static struct sock_filter connect_deny_family_filter[] = {
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_FAMILY),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_UNIX, 1, 0),
+	BPF_STMT(BPF_RET | BPF_K, 1),
+	BPF_STMT(BPF_RET | BPF_K, 0),
+};
+
+/*
+ * Deny AF_INET CONNECTs to 127.0.0.127 and allow the rest. The test
+ * address is byte-palindromic, so the K constant is endian-symmetric
+ * and CT_ADDR_K() is not needed here.
+ */
+static struct sock_filter connect_deny_v4_addr_filter[] = {
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_FAMILY),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET, 0, 2),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_V4_ADDR),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, 0x7f00007f, 1, 0),
+	BPF_STMT(BPF_RET | BPF_K, 1),
+	BPF_STMT(BPF_RET | BPF_K, 0),
+};
+
+/*
+ * Deny AF_INET CONNECTs to port 22 and allow the rest. Non-AF_INET
+ * traffic falls through to allow. Matches the port via CT_PORT_K().
+ */
+static struct sock_filter connect_deny_port_filter[] = {
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_FAMILY),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET, 0, 3),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_PORT),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, CT_PORT_K(22), 0, 1),
+	BPF_STMT(BPF_RET | BPF_K, 0),
+	BPF_STMT(BPF_RET | BPF_K, 1),
+};
+
+/*
+ * cBPF filter that denies AF_INET CONNECTs outright. Used by the
+ * stale-cache test: poisons the async msghdr with valid
+ * AF_INET state, then submits a short-len CONNECT and verifies the
+ * second one does NOT inherit AF_INET. When the framework zero-fill
+ * remains intact (the populator returns early via the addr_len
+ * guard), the filter sees family=0, falls through to allow, and the
+ * kernel net path returns -EINVAL for the short addr_len.
+ */
+static struct sock_filter connect_deny_inet_filter[] = {
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_FAMILY),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET, 0, 1),
+	BPF_STMT(BPF_RET | BPF_K, 0),
+	BPF_STMT(BPF_RET | BPF_K, 1),
+};
+
+/*
+ * cBPF filter that allows only AF_INET CONNECTs to 127.0.0.1 and
+ * denies everything else (a v4-address whitelist).
+ */
+static struct sock_filter connect_allow_v4_addr_filter[] = {
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_FAMILY),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET, 0, 3),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_V4_ADDR),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, CT_ADDR_K(127, 0, 0, 1), 0, 1),
+	BPF_STMT(BPF_RET | BPF_K, 1),
+	BPF_STMT(BPF_RET | BPF_K, 0),
+};
+
+/*
+ * Deny AF_INET6 CONNECTs to 2001:db8::dead and allow the rest.
+ * Walks the v6 address as four 4-byte word loads at offsets 24, 28,
+ * 32, 36.
+ */
+static struct sock_filter connect_deny_v6_addr_filter[] = {
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_FAMILY),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET6, 0, 8),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_V6_ADDR_W0),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, CT_ADDR_K(0x20, 0x01, 0x0d, 0xb8), 0, 6),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_V6_ADDR_W1),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, 0, 0, 4),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_V6_ADDR_W2),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, 0, 0, 2),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_V6_ADDR_W3),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, CT_ADDR_K(0, 0, 0xde, 0xad), 1, 0),
+	BPF_STMT(BPF_RET | BPF_K, 1),
+	BPF_STMT(BPF_RET | BPF_K, 0),
+};
+
+/*
+ * Allow only AF_INET6 CONNECTs to ::1 and deny everything else. Walks
+ * the v6 address as four 4-byte word loads at offsets 24, 28, 32, 36.
+ */
+static struct sock_filter connect_allow_v6_addr_filter[] = {
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_FAMILY),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET6, 0, 9),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_V6_ADDR_W0),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, 0, 0, 7),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_V6_ADDR_W1),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, 0, 0, 5),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_V6_ADDR_W2),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, 0, 0, 3),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_V6_ADDR_W3),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, CT_ADDR_K(0, 0, 0, 1), 0, 1),
+	BPF_STMT(BPF_RET | BPF_K, 1),
+	BPF_STMT(BPF_RET | BPF_K, 0),
+};
+
+/*
+ * cBPF filter that allows only AF_INET CONNECTs to port 80 and denies
+ * everything else (a port whitelist).
+ */
+static struct sock_filter connect_allow_port_filter[] = {
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_FAMILY),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET, 0, 3),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_PORT),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, CT_PORT_K(80), 0, 1),
+	BPF_STMT(BPF_RET | BPF_K, 1),
+	BPF_STMT(BPF_RET | BPF_K, 0),
+};
+
+/*
+ * Deny AF_INET CONNECTs in 127.42.0.0/24 and allow the rest. CIDR
+ * matching via load-mask-compare on the v4 address.
+ */
+static struct sock_filter connect_deny_v4_subnet_filter[] = {
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_FAMILY),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET, 0, 3),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_V4_ADDR),
+	BPF_STMT(BPF_ALU | BPF_AND | BPF_K, CT_ADDR_K(0xff, 0xff, 0xff, 0x00)),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, CT_ADDR_K(127, 42, 0, 0), 1, 0),
+	BPF_STMT(BPF_RET | BPF_K, 1),
+	BPF_STMT(BPF_RET | BPF_K, 0),
+};
+
+/*
+ * cBPF filter that allows only AF_INET CONNECTs in the 127.0.0.0/24
+ * subnet and denies everything else (a v4 subnet whitelist).
+ */
+static struct sock_filter connect_allow_v4_subnet_filter[] = {
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_FAMILY),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET, 0, 4),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_V4_ADDR),
+	BPF_STMT(BPF_ALU | BPF_AND | BPF_K, CT_ADDR_K(0xff, 0xff, 0xff, 0x00)),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, CT_ADDR_K(127, 0, 0, 0), 0, 1),
+	BPF_STMT(BPF_RET | BPF_K, 1),
+	BPF_STMT(BPF_RET | BPF_K, 0),
+};
+
+/*
+ * cBPF filter that denies AF_INET6 CONNECTs in the 2001:db8::/32
+ * subnet and allows everything else. /32 falls on a word boundary, so
+ * an exact-match JEQ on the first v6 word suffices.
+ */
+static struct sock_filter connect_deny_v6_subnet_filter[] = {
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_FAMILY),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET6, 0, 2),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_V6_ADDR_W0),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, CT_ADDR_K(0x20, 0x01, 0x0d, 0xb8), 1, 0),
+	BPF_STMT(BPF_RET | BPF_K, 1),
+	BPF_STMT(BPF_RET | BPF_K, 0),
+};
+
+/*
+ * cBPF filter that allows only AF_INET6 CONNECTs in the fe80::/16
+ * subnet (link-local) and denies everything else. /16 falls within
+ * the first v6 word, so we AND-mask the first 16 bits and compare.
+ */
+static struct sock_filter connect_allow_v6_subnet_filter[] = {
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_FAMILY),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET6, 0, 4),
+	BPF_STMT(BPF_LD  | BPF_W   | BPF_ABS, CTX_OFF_CONNECT_V6_ADDR_W0),
+	BPF_STMT(BPF_ALU | BPF_AND | BPF_K, CT_ADDR_K(0xff, 0xff, 0x00, 0x00)),
+	BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, CT_ADDR_K(0xfe, 0x80, 0x00, 0x00), 0, 1),
+	BPF_STMT(BPF_RET | BPF_K, 1),
+	BPF_STMT(BPF_RET | BPF_K, 0),
+};
+
 /* Register a BPF filter on a task */
 static int register_bpf_filter(struct sock_filter *filter, unsigned int len,
 			       __u32 opcode, __u8 pdu_size, int deny_rest)
@@ -369,20 +613,833 @@ static int test_openat2(struct io_uring *ring, const char *path,
 		}
 	}
 
-	if (ret)
-		fprintf(stderr, "%s: %s: failed\n", __FUNCTION__, desc);
-	io_uring_cqe_seen(ring, cqe);
-	return ret;
+	if (ret)
+		fprintf(stderr, "%s: %s: failed\n", __FUNCTION__, desc);
+	io_uring_cqe_seen(ring, cqe);
+	return ret;
+}
+
+/*
+ * Submit an IORING_OP_CONNECT to @sa/@slen. should_succeed == 1 means
+ * the filter must allow the op through (cqe->res != -EACCES); the
+ * connect itself may still fail, typically with -ECONNREFUSED on
+ * closed loopback ports. Any non--EACCES result means the kernel net
+ * path ran. should_succeed == 0 means the filter must deny
+ * (cqe->res == -EACCES). The socket fd is consumed.
+ */
+static int test_connect(struct io_uring *ring, const struct sockaddr *sa,
+			socklen_t slen, const char *desc, int should_succeed)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int fd, ret;
+
+	fd = socket(sa->sa_family, SOCK_STREAM, 0);
+	if (fd < 0) {
+		printf("FAIL (socket: %s)\n", strerror(errno));
+		return -1;
+	}
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_connect(sqe, fd, sa, slen);
+	sqe->user_data = 0x9abc;
+
+	ret = io_uring_submit(ring);
+	if (ret < 0) {
+		printf("FAIL (submit: %s)\n", strerror(-ret));
+		close(fd);
+		return ret;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		printf("FAIL (wait: %s)\n", strerror(-ret));
+		close(fd);
+		return ret;
+	}
+
+	ret = 0;
+	if (should_succeed && cqe->res == -EACCES) {
+		printf("FAIL (expected allow, got -EACCES)\n");
+		ret = -1;
+	} else if (!should_succeed && cqe->res != -EACCES) {
+		printf("FAIL (expected -EACCES, got %s)\n",
+		       strerror(cqe->res < 0 ? -cqe->res : 0));
+		ret = -1;
+	}
+	if (ret)
+		fprintf(stderr, "%s: %s: failed\n", __FUNCTION__, desc);
+	io_uring_cqe_seen(ring, cqe);
+	close(fd);
+	return ret;
+}
+
+static int test_deny_nop(void)
+{
+	struct io_uring ring;
+	int ret, failed = 0;
+	pid_t pid;
+	int status;
+
+	/* Fork to get fresh task restrictions */
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		/* Child process */
+		ret = register_bpf_filter(deny_all_filter,
+					  sizeof(deny_all_filter) / sizeof(deny_all_filter[0]),
+					  IORING_OP_NOP, 0, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: register failed\n");
+			exit(ret == -EINVAL ? 0 : 1);
+		}
+
+		ret = io_uring_queue_init(8, &ring, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: queue_init failed\n");
+			exit(1);
+		}
+
+		if (test_nop(&ring, "NOP should be denied", 0) != 0)
+			failed++;
+
+		io_uring_queue_exit(&ring);
+		exit(failed);
+	}
+
+	/* Parent waits for child */
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return 1;
+}
+
+static int test_allow_inet_only(void)
+{
+	struct io_uring ring;
+	int ret, failed = 0;
+	pid_t pid;
+	int status;
+
+	/* Fork to get fresh task restrictions */
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		/* Child process */
+		ret = register_bpf_filter(allow_inet_only_filter,
+					   sizeof(allow_inet_only_filter) / sizeof(allow_inet_only_filter[0]),
+					   IORING_OP_SOCKET, 12, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: register failed\n");
+			exit(ret == -EINVAL ? 0 : 1);
+		}
+
+		ret = io_uring_queue_init(8, &ring, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: queue_init failed\n");
+			exit(1);
+		}
+
+		if (test_socket(&ring, AF_INET, SOCK_STREAM,
+				"AF_INET TCP should succeed", 1) != 0)
+			failed++;
+
+		if (test_socket(&ring, AF_INET6, SOCK_STREAM,
+				"AF_INET6 TCP should be denied", 0) != 0)
+			failed++;
+
+		if (test_socket(&ring, AF_UNIX, SOCK_STREAM,
+				"AF_UNIX should be denied", 0) != 0)
+			failed++;
+
+		io_uring_queue_exit(&ring);
+		exit(failed);
+	}
+
+	/* Parent waits for child */
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return 1;
+}
+
+static int test_allow_tcp_only(void)
+{
+	struct io_uring ring;
+	int ret, failed = 0;
+	pid_t pid;
+	int status;
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		ret = register_bpf_filter(allow_tcp_only_filter,
+					   sizeof(allow_tcp_only_filter) / sizeof(allow_tcp_only_filter[0]),
+					   IORING_OP_SOCKET, 12, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: register failed\n");
+			exit(ret == -EINVAL ? 0 : 1);
+		}
+
+		ret = io_uring_queue_init(8, &ring, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: queue_init failed\n");
+			exit(1);
+		}
+
+		if (test_socket(&ring, AF_INET, SOCK_STREAM,
+				"TCP should succeed", 1) != 0)
+			failed++;
+
+		if (test_socket(&ring, AF_INET, SOCK_DGRAM,
+				"UDP should be denied", 0) != 0)
+			failed++;
+
+		if (test_socket(&ring, AF_INET6, SOCK_STREAM,
+				"IPv6 TCP should succeed", 1) != 0)
+			failed++;
+
+		io_uring_queue_exit(&ring);
+		exit(failed);
+	}
+
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return 1;
+}
+
+static int test_deny_rest(void)
+{
+	struct io_uring ring;
+	int ret, failed = 0;
+	pid_t pid;
+	int status;
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		/* Register allow filter for NOP with DENY_REST flag */
+		ret = register_bpf_filter(allow_all_filter,
+					   sizeof(allow_all_filter) / sizeof(allow_all_filter[0]),
+					   IORING_OP_NOP, 0,
+					   1);  /* deny_rest = true */
+		if (ret < 0) {
+			fprintf(stderr, "Child: register failed\n");
+			exit(ret == -EINVAL ? 0 : 1);
+		}
+
+		ret = io_uring_queue_init(8, &ring, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: queue_init failed\n");
+			exit(1);
+		}
+
+		if (test_nop(&ring, "NOP should succeed", 1) != 0)
+			failed++;
+
+		if (test_socket(&ring, AF_INET, SOCK_STREAM,
+				"Socket should be denied (DENY_REST)", 0) != 0)
+			failed++;
+
+		io_uring_queue_exit(&ring);
+		exit(failed);
+	}
+
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return 1;
+}
+
+/*
+ * Test denying O_CREAT flag for IORING_OP_OPENAT.
+ * Verifies the operation works before filter installation,
+ * then fails with -EACCES after.
+ */
+static int test_deny_openat_creat(void)
+{
+	struct io_uring ring;
+	int ret, failed = 0;
+	pid_t pid;
+	int status;
+	char tmpfile[] = "/tmp/cbpf_test_XXXXXX";
+	int tmpfd;
+
+	/* Create a temp file path we can use for testing */
+	tmpfd = mkstemp(tmpfile);
+	if (tmpfd < 0) {
+		perror("mkstemp");
+		return 1;
+	}
+	close(tmpfd);
+	unlink(tmpfile);
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		/* Test that O_CREAT works BEFORE installing filter */
+		ret = io_uring_queue_init(8, &ring, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: queue_init failed\n");
+			exit(1);
+		}
+
+		if (test_openat(&ring, tmpfile, O_CREAT | O_RDWR, 0644,
+				"O_CREAT should succeed before filter", 1) != 0)
+			failed++;
+
+		/* Clean up created file */
+		unlink(tmpfile);
+
+		/* Test that regular open (no O_CREAT) works */
+		if (test_openat(&ring, "/dev/null", O_RDONLY, 0,
+				"regular open should succeed before filter", 1) != 0)
+			failed++;
+
+		io_uring_queue_exit(&ring);
+
+		/* Now install the O_CREAT deny filter */
+		ret = register_bpf_filter(deny_o_creat_filter,
+					  sizeof(deny_o_creat_filter) / sizeof(deny_o_creat_filter[0]),
+					  IORING_OP_OPENAT, 24, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: register failed: %s\n",
+				strerror(-ret));
+			exit(ret == -EINVAL ? 0 : 1);
+		}
+
+		/* Create new ring after filter is installed */
+		ret = io_uring_queue_init(8, &ring, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: queue_init 2 failed\n");
+			exit(1);
+		}
+
+		/* Test that O_CREAT is now denied */
+		if (test_openat(&ring, tmpfile, O_CREAT | O_RDWR, 0644,
+				"O_CREAT should be denied after filter", 0) != 0)
+			failed++;
+
+		/* Test that regular open still works */
+		if (test_openat(&ring, "/dev/null", O_RDONLY, 0,
+				"regular open should still succeed", 1) != 0)
+			failed++;
+
+		io_uring_queue_exit(&ring);
+		exit(failed);
+	}
+
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return 1;
+}
+
+/*
+ * Test denying RESOLVE_IN_ROOT flag for IORING_OP_OPENAT2.
+ * Verifies the operation works before filter installation,
+ * then fails with -EACCES after.
+ *
+ * Note: RESOLVE_IN_ROOT requires a relative path since it treats dfd as root.
+ * We use "." with O_DIRECTORY to test this.
+ */
+static int test_deny_openat2_resolve_in_root(void)
+{
+	struct io_uring ring;
+	int ret, failed = 0;
+	pid_t pid;
+	int status;
+	struct open_how how_with_resolve = {
+		.flags = O_RDONLY | O_DIRECTORY,
+		.mode = 0,
+		.resolve = RESOLVE_IN_ROOT,
+	};
+	struct open_how how_normal = {
+		.flags = O_RDONLY | O_DIRECTORY,
+		.mode = 0,
+		.resolve = 0,
+	};
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		/* Test that RESOLVE_IN_ROOT works BEFORE installing filter */
+		ret = io_uring_queue_init(8, &ring, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: queue_init failed\n");
+			exit(1);
+		}
+
+		if (test_openat2(&ring, ".", &how_with_resolve,
+				 "RESOLVE_IN_ROOT should succeed before filter", 1) != 0)
+			failed++;
+
+		/* Test that normal openat2 works */
+		if (test_openat2(&ring, ".", &how_normal,
+				 "normal openat2 should succeed before filter", 1) != 0)
+			failed++;
+
+		io_uring_queue_exit(&ring);
+
+		/* Now install the RESOLVE_IN_ROOT deny filter */
+		ret = register_bpf_filter(deny_resolve_in_root_filter,
+					  sizeof(deny_resolve_in_root_filter) / sizeof(deny_resolve_in_root_filter[0]),
+					  IORING_OP_OPENAT2, 24, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: register failed: %s\n",
+				strerror(-ret));
+			exit(ret == -EINVAL ? 0 : 1);
+		}
+
+		/* Create new ring after filter is installed */
+		ret = io_uring_queue_init(8, &ring, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: queue_init 2 failed\n");
+			exit(1);
+		}
+
+		/* Test that RESOLVE_IN_ROOT is now denied */
+		if (test_openat2(&ring, ".", &how_with_resolve,
+				 "RESOLVE_IN_ROOT should be denied after filter", 0) != 0)
+			failed++;
+
+		/* Test that normal openat2 still works */
+		if (test_openat2(&ring, ".", &how_normal,
+				 "normal openat2 should still succeed", 1) != 0)
+			failed++;
+
+		io_uring_queue_exit(&ring);
+		exit(failed);
+	}
+
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return 1;
+}
+
+static int test_connect_allow_family(void)
+{
+	struct io_uring ring;
+	int ret, failed = 0;
+	pid_t pid;
+	int status;
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		struct sockaddr_in v4 = {
+			.sin_family = AF_INET,
+			.sin_port = htons(1),
+		};
+		struct sockaddr_in6 v6 = {
+			.sin6_family = AF_INET6,
+			.sin6_port = htons(1),
+		};
+		struct sockaddr_un un = { .sun_family = AF_UNIX };
+
+		v4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+		v6.sin6_addr = in6addr_loopback;
+		strncpy(un.sun_path, "/tmp/cbpf_filter_no_such_socket",
+			sizeof(un.sun_path) - 1);
+
+		ret = register_bpf_filter(connect_allow_family_filter,
+					  sizeof(connect_allow_family_filter) / sizeof(connect_allow_family_filter[0]),
+					  IORING_OP_CONNECT, CONNECT_PDU_SIZE, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: register failed: %s\n",
+				strerror(-ret));
+			exit(ret == -EINVAL ? 0 : 1);
+		}
+
+		ret = io_uring_queue_init(8, &ring, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: queue_init failed\n");
+			exit(1);
+		}
+
+		if (test_connect(&ring, (struct sockaddr *)&v4, sizeof(v4),
+				 "AF_INET should be allowed", 1) != 0)
+			failed++;
+		if (test_connect(&ring, (struct sockaddr *)&v6, sizeof(v6),
+				 "AF_INET6 should be denied", 0) != 0)
+			failed++;
+		if (test_connect(&ring, (struct sockaddr *)&un, sizeof(un),
+				 "AF_UNIX should be denied", 0) != 0)
+			failed++;
+
+		io_uring_queue_exit(&ring);
+		exit(failed);
+	}
+
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return 1;
+}
+
+static int test_connect_deny_v4_addr(void)
+{
+	struct io_uring ring;
+	int ret, failed = 0;
+	pid_t pid;
+	int status;
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		struct sockaddr_in banned = {
+			.sin_family = AF_INET,
+			.sin_port = htons(1),
+		};
+		struct sockaddr_in other = {
+			.sin_family = AF_INET,
+			.sin_port = htons(1),
+		};
+
+		banned.sin_addr.s_addr = htonl(0x7f00007f);
+		other.sin_addr.s_addr  = htonl(INADDR_LOOPBACK);
+
+		ret = register_bpf_filter(connect_deny_v4_addr_filter,
+					  sizeof(connect_deny_v4_addr_filter) / sizeof(connect_deny_v4_addr_filter[0]),
+					  IORING_OP_CONNECT, CONNECT_PDU_SIZE, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: register failed: %s\n",
+				strerror(-ret));
+			exit(ret == -EINVAL ? 0 : 1);
+		}
+
+		ret = io_uring_queue_init(8, &ring, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: queue_init failed\n");
+			exit(1);
+		}
+
+		if (test_connect(&ring, (struct sockaddr *)&banned, sizeof(banned),
+				 "127.0.0.127 should be denied", 0) != 0)
+			failed++;
+		if (test_connect(&ring, (struct sockaddr *)&other, sizeof(other),
+				 "127.0.0.1 should be allowed", 1) != 0)
+			failed++;
+
+		io_uring_queue_exit(&ring);
+		exit(failed);
+	}
+
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return 1;
+}
+
+static int test_connect_deny_port(void)
+{
+	struct io_uring ring;
+	int ret, failed = 0;
+	pid_t pid;
+	int status;
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		struct sockaddr_in ssh = {
+			.sin_family = AF_INET,
+			.sin_port = htons(22),
+		};
+		struct sockaddr_in http = {
+			.sin_family = AF_INET,
+			.sin_port = htons(80),
+		};
+
+		ssh.sin_addr.s_addr  = htonl(INADDR_LOOPBACK);
+		http.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+
+		ret = register_bpf_filter(connect_deny_port_filter,
+					  sizeof(connect_deny_port_filter) / sizeof(connect_deny_port_filter[0]),
+					  IORING_OP_CONNECT, CONNECT_PDU_SIZE, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: register failed: %s\n",
+				strerror(-ret));
+			exit(ret == -EINVAL ? 0 : 1);
+		}
+
+		ret = io_uring_queue_init(8, &ring, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: queue_init failed\n");
+			exit(1);
+		}
+
+		if (test_connect(&ring, (struct sockaddr *)&ssh, sizeof(ssh),
+				 "port 22 should be denied", 0) != 0)
+			failed++;
+		if (test_connect(&ring, (struct sockaddr *)&http, sizeof(http),
+				 "port 80 should be allowed", 1) != 0)
+			failed++;
+
+		io_uring_queue_exit(&ring);
+		exit(failed);
+	}
+
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return 1;
+}
+
+/*
+ * Test for io_connect_bpf_populate's addr_len handling.
+ * Two kernel-side mechanisms cooperate: the framework's caller-side
+ * memset in io_uring_populate_bpf_ctx() zero-fills bctx before the
+ * populator runs, and the populator returns early when addr_len does
+ * not cover the family discriminator (sizeof(sa_family_t)) so the
+ * zero-fill stays intact. Step 1 poisons iomsg->addr with a denied
+ * AF_INET CONNECT. Step 2 submits CONNECT with addr_len=1: the
+ * filter must see family=0 and fall through to the kernel net path,
+ * which returns -EINVAL for the sub-minimum addr_len. If the
+ * populator read the stale AF_INET cache instead, the filter would
+ * deny with -EACCES -- the failure mode this test catches.
+ */
+static int test_connect_stale_addr_len(void)
+{
+	struct io_uring ring;
+	int ret, failed = 0;
+	pid_t pid;
+	int status;
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		struct sockaddr_in sa = {
+			.sin_family = AF_INET,
+			.sin_port = htons(1),
+		};
+		struct io_uring_sqe *sqe;
+		struct io_uring_cqe *cqe;
+		int fd;
+
+		sa.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+
+		ret = register_bpf_filter(connect_deny_inet_filter,
+					  sizeof(connect_deny_inet_filter) / sizeof(connect_deny_inet_filter[0]),
+					  IORING_OP_CONNECT, CONNECT_PDU_SIZE, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: register failed: %s\n",
+				strerror(-ret));
+			exit(ret == -EINVAL ? 0 : 1);
+		}
+
+		ret = io_uring_queue_init(8, &ring, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: queue_init failed\n");
+			exit(1);
+		}
+
+		/*
+		 * Step 1: poison iomsg->addr by submitting a fully-formed
+		 * AF_INET CONNECT. The submit path's move_addr_to_kernel()
+		 * copies the user sockaddr into the async msghdr before the
+		 * filter runs; the filter then denies based on the populated
+		 * family, leaving the AF_INET state cached in iomsg->addr.
+		 */
+		fd = socket(AF_INET, SOCK_STREAM, 0);
+		if (fd < 0) {
+			perror("stale: socket step1");
+			exit(1);
+		}
+		sqe = io_uring_get_sqe(&ring);
+		if (!sqe) {
+			fprintf(stderr, "stale: get_sqe step1 failed\n");
+			close(fd);
+			exit(1);
+		}
+		io_uring_prep_connect(sqe, fd, (struct sockaddr *)&sa,
+				      sizeof(sa));
+		ret = io_uring_submit(&ring);
+		if (ret < 0) {
+			fprintf(stderr, "stale: submit step1: %s\n",
+				strerror(-ret));
+			close(fd);
+			exit(1);
+		}
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "stale: wait step1: %s\n",
+				strerror(-ret));
+			close(fd);
+			exit(1);
+		}
+		if (cqe->res != -EACCES) {
+			fprintf(stderr, "stale: poison expected -EACCES, got %d\n",
+				cqe->res);
+			failed++;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+		close(fd);
+
+		/*
+		 * Step 2: short-len CONNECT. Without the guard, this would
+		 * reuse stale AF_INET from step 1 and be denied with
+		 * -EACCES. With the guard, the filter sees family=0, allows
+		 * the op through, and the kernel net path rejects the
+		 * sub-minimum addr_len with -EINVAL -- which is the
+		 * specific result we assert.
+		 */
+		fd = socket(AF_INET, SOCK_STREAM, 0);
+		if (fd < 0) {
+			perror("stale: socket step2");
+			exit(1);
+		}
+		sqe = io_uring_get_sqe(&ring);
+		if (!sqe) {
+			fprintf(stderr, "stale: get_sqe step2 failed\n");
+			close(fd);
+			exit(1);
+		}
+		io_uring_prep_connect(sqe, fd, (struct sockaddr *)&sa, 1);
+		ret = io_uring_submit(&ring);
+		if (ret < 0) {
+			fprintf(stderr, "stale: submit step2: %s\n",
+				strerror(-ret));
+			close(fd);
+			exit(1);
+		}
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "stale: wait step2: %s\n",
+				strerror(-ret));
+			close(fd);
+			exit(1);
+		}
+		if (cqe->res != -EINVAL) {
+			fprintf(stderr, "stale: short-len expected -EINVAL, got %d\n",
+				cqe->res);
+			failed++;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+		close(fd);
+
+		io_uring_queue_exit(&ring);
+		exit(failed);
+	}
+
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return 1;
+}
+
+static int test_connect_deny_family(void)
+{
+	struct io_uring ring;
+	int ret, failed = 0;
+	pid_t pid;
+	int status;
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		struct sockaddr_in v4 = {
+			.sin_family = AF_INET,
+			.sin_port = htons(1),
+		};
+		struct sockaddr_in6 v6 = {
+			.sin6_family = AF_INET6,
+			.sin6_port = htons(1),
+		};
+		struct sockaddr_un un = { .sun_family = AF_UNIX };
+
+		v4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+		v6.sin6_addr = in6addr_loopback;
+		strncpy(un.sun_path, "/tmp/cbpf_filter_no_such_socket",
+			sizeof(un.sun_path) - 1);
+
+		ret = register_bpf_filter(connect_deny_family_filter,
+					  sizeof(connect_deny_family_filter) / sizeof(connect_deny_family_filter[0]),
+					  IORING_OP_CONNECT, CONNECT_PDU_SIZE, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: register failed: %s\n",
+				strerror(-ret));
+			exit(ret == -EINVAL ? 0 : 1);
+		}
+
+		ret = io_uring_queue_init(8, &ring, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: queue_init failed\n");
+			exit(1);
+		}
+
+		if (test_connect(&ring, (struct sockaddr *)&v4, sizeof(v4),
+				 "AF_INET should be allowed", 1) != 0)
+			failed++;
+		if (test_connect(&ring, (struct sockaddr *)&v6, sizeof(v6),
+				 "AF_INET6 should be allowed", 1) != 0)
+			failed++;
+		if (test_connect(&ring, (struct sockaddr *)&un, sizeof(un),
+				 "AF_UNIX should be denied", 0) != 0)
+			failed++;
+
+		io_uring_queue_exit(&ring);
+		exit(failed);
+	}
+
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return 1;
 }
 
-static int test_deny_nop(void)
+static int test_connect_allow_v4_addr(void)
 {
 	struct io_uring ring;
 	int ret, failed = 0;
 	pid_t pid;
 	int status;
 
-	/* Fork to get fresh task restrictions */
 	pid = fork();
 	if (pid < 0) {
 		perror("fork");
@@ -390,12 +1447,29 @@ static int test_deny_nop(void)
 	}
 
 	if (pid == 0) {
-		/* Child process */
-		ret = register_bpf_filter(deny_all_filter,
-					  sizeof(deny_all_filter) / sizeof(deny_all_filter[0]),
-					  IORING_OP_NOP, 0, 0);
+		struct sockaddr_in allowed = {
+			.sin_family = AF_INET,
+			.sin_port = htons(80),
+		};
+		struct sockaddr_in denied_a = {
+			.sin_family = AF_INET,
+			.sin_port = htons(80),
+		};
+		struct sockaddr_in denied_b = {
+			.sin_family = AF_INET,
+			.sin_port = htons(80),
+		};
+
+		allowed.sin_addr.s_addr  = htonl(INADDR_LOOPBACK);
+		denied_a.sin_addr.s_addr = htonl(0x7f00007f);
+		denied_b.sin_addr.s_addr = htonl(0x7f000002);
+
+		ret = register_bpf_filter(connect_allow_v4_addr_filter,
+					  sizeof(connect_allow_v4_addr_filter) / sizeof(connect_allow_v4_addr_filter[0]),
+					  IORING_OP_CONNECT, CONNECT_PDU_SIZE, 0);
 		if (ret < 0) {
-			fprintf(stderr, "Child: register failed\n");
+			fprintf(stderr, "Child: register failed: %s\n",
+				strerror(-ret));
 			exit(ret == -EINVAL ? 0 : 1);
 		}
 
@@ -405,28 +1479,40 @@ static int test_deny_nop(void)
 			exit(1);
 		}
 
-		if (test_nop(&ring, "NOP should be denied", 0) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&allowed, sizeof(allowed),
+				 "127.0.0.1 should be allowed", 1) != 0)
+			failed++;
+		if (test_connect(&ring, (struct sockaddr *)&denied_a, sizeof(denied_a),
+				 "127.0.0.127 should be denied", 0) != 0)
+			failed++;
+		if (test_connect(&ring, (struct sockaddr *)&denied_b, sizeof(denied_b),
+				 "127.0.0.2 should be denied", 0) != 0)
 			failed++;
 
 		io_uring_queue_exit(&ring);
 		exit(failed);
 	}
 
-	/* Parent waits for child */
 	waitpid(pid, &status, 0);
 	if (WIFEXITED(status))
 		return WEXITSTATUS(status);
 	return 1;
 }
 
-static int test_allow_inet_only(void)
+/*
+ * Test blacklisting the v6 address 2001:db8::dead for
+ * IORING_OP_CONNECT. Other v6 addresses (including those sharing the
+ * 2001:db8::/32 prefix) are allowed. Non-AF_INET6 sockaddrs fall
+ * through to allow as well, since this is purely a v6-address
+ * blacklist.
+ */
+static int test_connect_deny_v6_addr(void)
 {
 	struct io_uring ring;
 	int ret, failed = 0;
 	pid_t pid;
 	int status;
 
-	/* Fork to get fresh task restrictions */
 	pid = fork();
 	if (pid < 0) {
 		perror("fork");
@@ -434,12 +1520,41 @@ static int test_allow_inet_only(void)
 	}
 
 	if (pid == 0) {
-		/* Child process */
-		ret = register_bpf_filter(allow_inet_only_filter,
-					   sizeof(allow_inet_only_filter) / sizeof(allow_inet_only_filter[0]),
-					   IORING_OP_SOCKET, 12, 0);
+		struct sockaddr_in6 banned = {
+			.sin6_family = AF_INET6,
+			.sin6_port = htons(80),
+		};
+		struct sockaddr_in6 other_lo = {
+			.sin6_family = AF_INET6,
+			.sin6_port = htons(80),
+		};
+		struct sockaddr_in6 other_doc = {
+			.sin6_family = AF_INET6,
+			.sin6_port = htons(80),
+		};
+
+		/* 2001:db8::dead -- banned */
+		banned.sin6_addr.s6_addr[0]  = 0x20;
+		banned.sin6_addr.s6_addr[1]  = 0x01;
+		banned.sin6_addr.s6_addr[2]  = 0x0d;
+		banned.sin6_addr.s6_addr[3]  = 0xb8;
+		banned.sin6_addr.s6_addr[14] = 0xde;
+		banned.sin6_addr.s6_addr[15] = 0xad;
+		/* ::1 -- loopback, outside the banned exact address */
+		other_lo.sin6_addr = in6addr_loopback;
+		/* 2001:db8::1 -- same /32 prefix, different exact addr */
+		other_doc.sin6_addr.s6_addr[0]  = 0x20;
+		other_doc.sin6_addr.s6_addr[1]  = 0x01;
+		other_doc.sin6_addr.s6_addr[2]  = 0x0d;
+		other_doc.sin6_addr.s6_addr[3]  = 0xb8;
+		other_doc.sin6_addr.s6_addr[15] = 0x01;
+
+		ret = register_bpf_filter(connect_deny_v6_addr_filter,
+					  sizeof(connect_deny_v6_addr_filter) / sizeof(connect_deny_v6_addr_filter[0]),
+					  IORING_OP_CONNECT, CONNECT_PDU_SIZE, 0);
 		if (ret < 0) {
-			fprintf(stderr, "Child: register failed\n");
+			fprintf(stderr, "Child: register failed: %s\n",
+				strerror(-ret));
 			exit(ret == -EINVAL ? 0 : 1);
 		}
 
@@ -449,30 +1564,27 @@ static int test_allow_inet_only(void)
 			exit(1);
 		}
 
-		if (test_socket(&ring, AF_INET, SOCK_STREAM,
-				"AF_INET TCP should succeed", 1) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&banned, sizeof(banned),
+				 "2001:db8::dead should be denied", 0) != 0)
 			failed++;
-
-		if (test_socket(&ring, AF_INET6, SOCK_STREAM,
-				"AF_INET6 TCP should be denied", 0) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&other_lo, sizeof(other_lo),
+				 "::1 should be allowed", 1) != 0)
 			failed++;
-
-		if (test_socket(&ring, AF_UNIX, SOCK_STREAM,
-				"AF_UNIX should be denied", 0) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&other_doc, sizeof(other_doc),
+				 "2001:db8::1 should be allowed", 1) != 0)
 			failed++;
 
 		io_uring_queue_exit(&ring);
 		exit(failed);
 	}
 
-	/* Parent waits for child */
 	waitpid(pid, &status, 0);
 	if (WIFEXITED(status))
 		return WEXITSTATUS(status);
 	return 1;
 }
 
-static int test_allow_tcp_only(void)
+static int test_connect_allow_v6_addr(void)
 {
 	struct io_uring ring;
 	int ret, failed = 0;
@@ -486,11 +1598,35 @@ static int test_allow_tcp_only(void)
 	}
 
 	if (pid == 0) {
-		ret = register_bpf_filter(allow_tcp_only_filter,
-					   sizeof(allow_tcp_only_filter) / sizeof(allow_tcp_only_filter[0]),
-					   IORING_OP_SOCKET, 12, 0);
+		struct sockaddr_in6 allowed = {
+			.sin6_family = AF_INET6,
+			.sin6_port = htons(80),
+		};
+		struct sockaddr_in6 denied_lo = {
+			.sin6_family = AF_INET6,
+			.sin6_port = htons(80),
+		};
+		struct sockaddr_in6 denied_doc = {
+			.sin6_family = AF_INET6,
+			.sin6_port = htons(80),
+		};
+
+		allowed.sin6_addr = in6addr_loopback;
+		/* ::2 -- test target */
+		denied_lo.sin6_addr.s6_addr[15] = 0x02;
+		/* 2001:db8::1 -- test target */
+		denied_doc.sin6_addr.s6_addr[0]  = 0x20;
+		denied_doc.sin6_addr.s6_addr[1]  = 0x01;
+		denied_doc.sin6_addr.s6_addr[2]  = 0x0d;
+		denied_doc.sin6_addr.s6_addr[3]  = 0xb8;
+		denied_doc.sin6_addr.s6_addr[15] = 0x01;
+
+		ret = register_bpf_filter(connect_allow_v6_addr_filter,
+					  sizeof(connect_allow_v6_addr_filter) / sizeof(connect_allow_v6_addr_filter[0]),
+					  IORING_OP_CONNECT, CONNECT_PDU_SIZE, 0);
 		if (ret < 0) {
-			fprintf(stderr, "Child: register failed\n");
+			fprintf(stderr, "Child: register failed: %s\n",
+				strerror(-ret));
 			exit(ret == -EINVAL ? 0 : 1);
 		}
 
@@ -500,16 +1636,14 @@ static int test_allow_tcp_only(void)
 			exit(1);
 		}
 
-		if (test_socket(&ring, AF_INET, SOCK_STREAM,
-				"TCP should succeed", 1) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&allowed, sizeof(allowed),
+				 "::1 should be allowed", 1) != 0)
 			failed++;
-
-		if (test_socket(&ring, AF_INET, SOCK_DGRAM,
-				"UDP should be denied", 0) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&denied_lo, sizeof(denied_lo),
+				 "::2 should be denied", 0) != 0)
 			failed++;
-
-		if (test_socket(&ring, AF_INET6, SOCK_STREAM,
-				"IPv6 TCP should succeed", 1) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&denied_doc, sizeof(denied_doc),
+				 "2001:db8::1 should be denied", 0) != 0)
 			failed++;
 
 		io_uring_queue_exit(&ring);
@@ -522,7 +1656,7 @@ static int test_allow_tcp_only(void)
 	return 1;
 }
 
-static int test_deny_rest(void)
+static int test_connect_allow_port(void)
 {
 	struct io_uring ring;
 	int ret, failed = 0;
@@ -536,13 +1670,29 @@ static int test_deny_rest(void)
 	}
 
 	if (pid == 0) {
-		/* Register allow filter for NOP with DENY_REST flag */
-		ret = register_bpf_filter(allow_all_filter,
-					   sizeof(allow_all_filter) / sizeof(allow_all_filter[0]),
-					   IORING_OP_NOP, 0,
-					   1);  /* deny_rest = true */
+		struct sockaddr_in allowed = {
+			.sin_family = AF_INET,
+			.sin_port = htons(80),
+		};
+		struct sockaddr_in denied_ssh = {
+			.sin_family = AF_INET,
+			.sin_port = htons(22),
+		};
+		struct sockaddr_in denied_https = {
+			.sin_family = AF_INET,
+			.sin_port = htons(443),
+		};
+
+		allowed.sin_addr.s_addr     = htonl(INADDR_LOOPBACK);
+		denied_ssh.sin_addr.s_addr  = htonl(INADDR_LOOPBACK);
+		denied_https.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+
+		ret = register_bpf_filter(connect_allow_port_filter,
+					  sizeof(connect_allow_port_filter) / sizeof(connect_allow_port_filter[0]),
+					  IORING_OP_CONNECT, CONNECT_PDU_SIZE, 0);
 		if (ret < 0) {
-			fprintf(stderr, "Child: register failed\n");
+			fprintf(stderr, "Child: register failed: %s\n",
+				strerror(-ret));
 			exit(ret == -EINVAL ? 0 : 1);
 		}
 
@@ -552,11 +1702,14 @@ static int test_deny_rest(void)
 			exit(1);
 		}
 
-		if (test_nop(&ring, "NOP should succeed", 1) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&allowed, sizeof(allowed),
+				 "port 80 should be allowed", 1) != 0)
 			failed++;
-
-		if (test_socket(&ring, AF_INET, SOCK_STREAM,
-				"Socket should be denied (DENY_REST)", 0) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&denied_ssh, sizeof(denied_ssh),
+				 "port 22 should be denied", 0) != 0)
+			failed++;
+		if (test_connect(&ring, (struct sockaddr *)&denied_https, sizeof(denied_https),
+				 "port 443 should be denied", 0) != 0)
 			failed++;
 
 		io_uring_queue_exit(&ring);
@@ -569,28 +1722,12 @@ static int test_deny_rest(void)
 	return 1;
 }
 
-/*
- * Test denying O_CREAT flag for IORING_OP_OPENAT.
- * Verifies the operation works before filter installation,
- * then fails with -EACCES after.
- */
-static int test_deny_openat_creat(void)
+static int test_connect_deny_v4_subnet(void)
 {
 	struct io_uring ring;
 	int ret, failed = 0;
 	pid_t pid;
 	int status;
-	char tmpfile[] = "/tmp/cbpf_test_XXXXXX";
-	int tmpfd;
-
-	/* Create a temp file path we can use for testing */
-	tmpfd = mkstemp(tmpfile);
-	if (tmpfd < 0) {
-		perror("mkstemp");
-		return 1;
-	}
-	close(tmpfd);
-	unlink(tmpfile);
 
 	pid = fork();
 	if (pid < 0) {
@@ -599,52 +1736,112 @@ static int test_deny_openat_creat(void)
 	}
 
 	if (pid == 0) {
-		/* Test that O_CREAT works BEFORE installing filter */
+		struct sockaddr_in in_subnet_a = {
+			.sin_family = AF_INET,
+			.sin_port = htons(80),
+		};
+		struct sockaddr_in in_subnet_b = {
+			.sin_family = AF_INET,
+			.sin_port = htons(80),
+		};
+		struct sockaddr_in out_subnet = {
+			.sin_family = AF_INET,
+			.sin_port = htons(80),
+		};
+
+		in_subnet_a.sin_addr.s_addr = htonl(0x7f2a0001);  /* 127.42.0.1 */
+		in_subnet_b.sin_addr.s_addr = htonl(0x7f2a0063);  /* 127.42.0.99 */
+		out_subnet.sin_addr.s_addr  = htonl(INADDR_LOOPBACK);
+
+		ret = register_bpf_filter(connect_deny_v4_subnet_filter,
+					  sizeof(connect_deny_v4_subnet_filter) / sizeof(connect_deny_v4_subnet_filter[0]),
+					  IORING_OP_CONNECT, CONNECT_PDU_SIZE, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: register failed: %s\n",
+				strerror(-ret));
+			exit(ret == -EINVAL ? 0 : 1);
+		}
+
 		ret = io_uring_queue_init(8, &ring, 0);
 		if (ret < 0) {
 			fprintf(stderr, "Child: queue_init failed\n");
 			exit(1);
 		}
 
-		if (test_openat(&ring, tmpfile, O_CREAT | O_RDWR, 0644,
-				"O_CREAT should succeed before filter", 1) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&in_subnet_a, sizeof(in_subnet_a),
+				 "127.42.0.1 should be denied", 0) != 0)
 			failed++;
-
-		/* Clean up created file */
-		unlink(tmpfile);
-
-		/* Test that regular open (no O_CREAT) works */
-		if (test_openat(&ring, "/dev/null", O_RDONLY, 0,
-				"regular open should succeed before filter", 1) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&in_subnet_b, sizeof(in_subnet_b),
+				 "127.42.0.99 should be denied", 0) != 0)
+			failed++;
+		if (test_connect(&ring, (struct sockaddr *)&out_subnet, sizeof(out_subnet),
+				 "127.0.0.1 should be allowed", 1) != 0)
 			failed++;
 
 		io_uring_queue_exit(&ring);
+		exit(failed);
+	}
 
-		/* Now install the O_CREAT deny filter */
-		ret = register_bpf_filter(deny_o_creat_filter,
-					  sizeof(deny_o_creat_filter) / sizeof(deny_o_creat_filter[0]),
-					  IORING_OP_OPENAT, 24, 0);
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return 1;
+}
+
+static int test_connect_allow_v4_subnet(void)
+{
+	struct io_uring ring;
+	int ret, failed = 0;
+	pid_t pid;
+	int status;
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		struct sockaddr_in in_subnet_a = {
+			.sin_family = AF_INET,
+			.sin_port = htons(80),
+		};
+		struct sockaddr_in in_subnet_b = {
+			.sin_family = AF_INET,
+			.sin_port = htons(80),
+		};
+		struct sockaddr_in out_subnet = {
+			.sin_family = AF_INET,
+			.sin_port = htons(80),
+		};
+
+		in_subnet_a.sin_addr.s_addr = htonl(INADDR_LOOPBACK);   /* 127.0.0.1 */
+		in_subnet_b.sin_addr.s_addr = htonl(0x7f000063);        /* 127.0.0.99 */
+		out_subnet.sin_addr.s_addr  = htonl(0x7f2a0001);        /* 127.42.0.1 */
+
+		ret = register_bpf_filter(connect_allow_v4_subnet_filter,
+					  sizeof(connect_allow_v4_subnet_filter) / sizeof(connect_allow_v4_subnet_filter[0]),
+					  IORING_OP_CONNECT, CONNECT_PDU_SIZE, 0);
 		if (ret < 0) {
 			fprintf(stderr, "Child: register failed: %s\n",
 				strerror(-ret));
 			exit(ret == -EINVAL ? 0 : 1);
 		}
 
-		/* Create new ring after filter is installed */
 		ret = io_uring_queue_init(8, &ring, 0);
 		if (ret < 0) {
-			fprintf(stderr, "Child: queue_init 2 failed\n");
+			fprintf(stderr, "Child: queue_init failed\n");
 			exit(1);
 		}
 
-		/* Test that O_CREAT is now denied */
-		if (test_openat(&ring, tmpfile, O_CREAT | O_RDWR, 0644,
-				"O_CREAT should be denied after filter", 0) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&in_subnet_a, sizeof(in_subnet_a),
+				 "127.0.0.1 should be allowed", 1) != 0)
 			failed++;
-
-		/* Test that regular open still works */
-		if (test_openat(&ring, "/dev/null", O_RDONLY, 0,
-				"regular open should still succeed", 1) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&in_subnet_b, sizeof(in_subnet_b),
+				 "127.0.0.99 should be allowed", 1) != 0)
+			failed++;
+		if (test_connect(&ring, (struct sockaddr *)&out_subnet, sizeof(out_subnet),
+				 "127.42.0.1 should be denied", 0) != 0)
 			failed++;
 
 		io_uring_queue_exit(&ring);
@@ -657,30 +1854,12 @@ static int test_deny_openat_creat(void)
 	return 1;
 }
 
-/*
- * Test denying RESOLVE_IN_ROOT flag for IORING_OP_OPENAT2.
- * Verifies the operation works before filter installation,
- * then fails with -EACCES after.
- *
- * Note: RESOLVE_IN_ROOT requires a relative path since it treats dfd as root.
- * We use "." with O_DIRECTORY to test this.
- */
-static int test_deny_openat2_resolve_in_root(void)
+static int test_connect_deny_v6_subnet(void)
 {
 	struct io_uring ring;
 	int ret, failed = 0;
 	pid_t pid;
 	int status;
-	struct open_how how_with_resolve = {
-		.flags = O_RDONLY | O_DIRECTORY,
-		.mode = 0,
-		.resolve = RESOLVE_IN_ROOT,
-	};
-	struct open_how how_normal = {
-		.flags = O_RDONLY | O_DIRECTORY,
-		.mode = 0,
-		.resolve = 0,
-	};
 
 	pid = fork();
 	if (pid < 0) {
@@ -689,49 +1868,139 @@ static int test_deny_openat2_resolve_in_root(void)
 	}
 
 	if (pid == 0) {
-		/* Test that RESOLVE_IN_ROOT works BEFORE installing filter */
+		struct sockaddr_in6 in_subnet_a = {
+			.sin6_family = AF_INET6,
+			.sin6_port = htons(80),
+		};
+		struct sockaddr_in6 in_subnet_b = {
+			.sin6_family = AF_INET6,
+			.sin6_port = htons(80),
+		};
+		struct sockaddr_in6 out_subnet = {
+			.sin6_family = AF_INET6,
+			.sin6_port = htons(80),
+		};
+
+		/* 2001:db8::1 */
+		in_subnet_a.sin6_addr.s6_addr[0]  = 0x20;
+		in_subnet_a.sin6_addr.s6_addr[1]  = 0x01;
+		in_subnet_a.sin6_addr.s6_addr[2]  = 0x0d;
+		in_subnet_a.sin6_addr.s6_addr[3]  = 0xb8;
+		in_subnet_a.sin6_addr.s6_addr[15] = 0x01;
+		/* 2001:db8:dead::1 -- same /32 prefix, different remainder */
+		in_subnet_b.sin6_addr.s6_addr[0]  = 0x20;
+		in_subnet_b.sin6_addr.s6_addr[1]  = 0x01;
+		in_subnet_b.sin6_addr.s6_addr[2]  = 0x0d;
+		in_subnet_b.sin6_addr.s6_addr[3]  = 0xb8;
+		in_subnet_b.sin6_addr.s6_addr[4]  = 0xde;
+		in_subnet_b.sin6_addr.s6_addr[5]  = 0xad;
+		in_subnet_b.sin6_addr.s6_addr[15] = 0x01;
+		/* ::1 -- loopback, outside the /32 */
+		out_subnet.sin6_addr = in6addr_loopback;
+
+		ret = register_bpf_filter(connect_deny_v6_subnet_filter,
+					  sizeof(connect_deny_v6_subnet_filter) / sizeof(connect_deny_v6_subnet_filter[0]),
+					  IORING_OP_CONNECT, CONNECT_PDU_SIZE, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Child: register failed: %s\n",
+				strerror(-ret));
+			exit(ret == -EINVAL ? 0 : 1);
+		}
+
 		ret = io_uring_queue_init(8, &ring, 0);
 		if (ret < 0) {
 			fprintf(stderr, "Child: queue_init failed\n");
 			exit(1);
 		}
 
-		if (test_openat2(&ring, ".", &how_with_resolve,
-				 "RESOLVE_IN_ROOT should succeed before filter", 1) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&in_subnet_a, sizeof(in_subnet_a),
+				 "2001:db8::1 should be denied", 0) != 0)
 			failed++;
-
-		/* Test that normal openat2 works */
-		if (test_openat2(&ring, ".", &how_normal,
-				 "normal openat2 should succeed before filter", 1) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&in_subnet_b, sizeof(in_subnet_b),
+				 "2001:db8:dead::1 should be denied", 0) != 0)
+			failed++;
+		if (test_connect(&ring, (struct sockaddr *)&out_subnet, sizeof(out_subnet),
+				 "::1 should be allowed", 1) != 0)
 			failed++;
 
 		io_uring_queue_exit(&ring);
+		exit(failed);
+	}
 
-		/* Now install the RESOLVE_IN_ROOT deny filter */
-		ret = register_bpf_filter(deny_resolve_in_root_filter,
-					  sizeof(deny_resolve_in_root_filter) / sizeof(deny_resolve_in_root_filter[0]),
-					  IORING_OP_OPENAT2, 24, 0);
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+	return 1;
+}
+
+static int test_connect_allow_v6_subnet(void)
+{
+	struct io_uring ring;
+	int ret, failed = 0;
+	pid_t pid;
+	int status;
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		struct sockaddr_in6 in_subnet_a = {
+			.sin6_family = AF_INET6,
+			.sin6_port = htons(80),
+		};
+		struct sockaddr_in6 in_subnet_b = {
+			.sin6_family = AF_INET6,
+			.sin6_port = htons(80),
+		};
+		struct sockaddr_in6 out_subnet = {
+			.sin6_family = AF_INET6,
+			.sin6_port = htons(80),
+		};
+
+		/* fe80::1 */
+		in_subnet_a.sin6_addr.s6_addr[0]  = 0xfe;
+		in_subnet_a.sin6_addr.s6_addr[1]  = 0x80;
+		in_subnet_a.sin6_addr.s6_addr[15] = 0x01;
+		/* fe80:cafe::beef -- same /16 prefix */
+		in_subnet_b.sin6_addr.s6_addr[0]  = 0xfe;
+		in_subnet_b.sin6_addr.s6_addr[1]  = 0x80;
+		in_subnet_b.sin6_addr.s6_addr[2]  = 0xca;
+		in_subnet_b.sin6_addr.s6_addr[3]  = 0xfe;
+		in_subnet_b.sin6_addr.s6_addr[14] = 0xbe;
+		in_subnet_b.sin6_addr.s6_addr[15] = 0xef;
+		/* 2001:db8::1 -- documentation prefix, outside fe80::/16 */
+		out_subnet.sin6_addr.s6_addr[0]  = 0x20;
+		out_subnet.sin6_addr.s6_addr[1]  = 0x01;
+		out_subnet.sin6_addr.s6_addr[2]  = 0x0d;
+		out_subnet.sin6_addr.s6_addr[3]  = 0xb8;
+		out_subnet.sin6_addr.s6_addr[15] = 0x01;
+
+		ret = register_bpf_filter(connect_allow_v6_subnet_filter,
+					  sizeof(connect_allow_v6_subnet_filter) / sizeof(connect_allow_v6_subnet_filter[0]),
+					  IORING_OP_CONNECT, CONNECT_PDU_SIZE, 0);
 		if (ret < 0) {
 			fprintf(stderr, "Child: register failed: %s\n",
 				strerror(-ret));
 			exit(ret == -EINVAL ? 0 : 1);
 		}
 
-		/* Create new ring after filter is installed */
 		ret = io_uring_queue_init(8, &ring, 0);
 		if (ret < 0) {
-			fprintf(stderr, "Child: queue_init 2 failed\n");
+			fprintf(stderr, "Child: queue_init failed\n");
 			exit(1);
 		}
 
-		/* Test that RESOLVE_IN_ROOT is now denied */
-		if (test_openat2(&ring, ".", &how_with_resolve,
-				 "RESOLVE_IN_ROOT should be denied after filter", 0) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&in_subnet_a, sizeof(in_subnet_a),
+				 "fe80::1 should be allowed", 1) != 0)
 			failed++;
-
-		/* Test that normal openat2 still works */
-		if (test_openat2(&ring, ".", &how_normal,
-				 "normal openat2 should still succeed", 1) != 0)
+		if (test_connect(&ring, (struct sockaddr *)&in_subnet_b, sizeof(in_subnet_b),
+				 "fe80:cafe::beef should be allowed", 1) != 0)
+			failed++;
+		if (test_connect(&ring, (struct sockaddr *)&out_subnet, sizeof(out_subnet),
+				 "2001:db8::1 should be denied", 0) != 0)
 			failed++;
 
 		io_uring_queue_exit(&ring);
@@ -1391,6 +2660,43 @@ static int probe_bpf_filter_support(void)
 	return -1;
 }
 
+static int probe_connect_filter_support(void)
+{
+	struct io_uring_bpf io_bpf = {
+		.cmd_type = IO_URING_BPF_CMD_FILTER,
+		.filter = {
+			.opcode = IORING_OP_CONNECT,
+			.flags = 0,
+			.filter_len = sizeof(allow_all_filter) / sizeof(allow_all_filter[0]),
+			.filter_ptr = (unsigned long)allow_all_filter,
+			.pdu_size = CONNECT_PDU_SIZE,
+		},
+	};
+	pid_t pid;
+	int status;
+
+	pid = fork();
+	if (pid < 0)
+		return -1;
+
+	if (pid == 0) {
+		int ret;
+
+		ret = io_uring_register(-1, IORING_REGISTER_BPF_FILTER,
+					&io_bpf, 1);
+		exit(ret < 0 ? -ret : 0);
+	}
+
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status)) {
+		int code = WEXITSTATUS(status);
+		if (code == EMSGSIZE)
+			return -1;  /* No populator for IORING_OP_CONNECT */
+		return 0;  /* Populator present (or unrelated error we will catch later) */
+	}
+	return -1;
+}
+
 int main(int argc, char *argv[])
 {
 	int total_failed = 0;
@@ -1431,6 +2737,27 @@ int main(int argc, char *argv[])
 	total_failed += test_deny_openat_creat();
 	total_failed += test_deny_openat2_resolve_in_root();
 
+	/* Task-level connect filter tests */
+	/*
+	 * Probe whether the kernel exposes a filter populator for
+	 * IORING_OP_CONNECT.
+	 */
+	if (probe_connect_filter_support() == 0) {
+		total_failed += test_connect_allow_family();
+		total_failed += test_connect_deny_family();
+		total_failed += test_connect_deny_v4_addr();
+		total_failed += test_connect_deny_port();
+		total_failed += test_connect_stale_addr_len();
+		total_failed += test_connect_allow_v4_addr();
+		total_failed += test_connect_deny_v6_addr();
+		total_failed += test_connect_allow_v6_addr();
+		total_failed += test_connect_allow_port();
+		total_failed += test_connect_deny_v4_subnet();
+		total_failed += test_connect_allow_v4_subnet();
+		total_failed += test_connect_deny_v6_subnet();
+		total_failed += test_connect_allow_v6_subnet();
+	}
+
 	/* Ring-level filter tests */
 	total_failed += test_deny_nop_ring();
 	total_failed += test_allow_inet_only_ring();
-- 
2.53.0


