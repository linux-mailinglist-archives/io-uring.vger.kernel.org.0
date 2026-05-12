Return-Path: <io-uring+bounces-13284-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iHURMi4JA2pmzwEAu9opvQ
	(envelope-from <io-uring+bounces-13284-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 13:04:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 21FE551F05F
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 13:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9DC833031CE2
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 11:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD42B254B18;
	Tue, 12 May 2026 11:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hEFf+ESY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C73C2836A0
	for <io-uring@vger.kernel.org>; Tue, 12 May 2026 11:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778583770; cv=none; b=ulmBtdj7CIM9cS6bwqEDEW0IFjDQp9PaIEIWb7bz/9UTp8R8FQgBMEpqUkDAcxi+drjnWQjoEraOJCROBJep/J4uTmu9Z8f60uDFGftPe1kHCYEWSOJH77euw1hk8/Q9ss44fNFSsoQKAZRlZfaW5PFvjM7IsV27wfeO+wD2LR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778583770; c=relaxed/simple;
	bh=5eR+gF6oDwQlRNLmgZA7Lt2dR7gSBePi9kX4+P0cEPs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SyhiyXORjZcZ1Z2LBY8gBLMBIFhpuo8I/8/D4Y+YHq0H+C1rNKn/nVeTo5Tv+ZVvGwsXJXB7OprQ4jUTAo72hXThh3VgoQLidxeRj3zlXBuaFBPsVsgMxCwQ0mm5fSb8ksMjg6mEhCq/Lr/NQ7cweJkKSZNDr7L6bkGfSxUeKNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hEFf+ESY; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-834da62e52dso2320399b3a.3
        for <io-uring@vger.kernel.org>; Tue, 12 May 2026 04:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778583768; x=1779188568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xssrm6xj2btBy2lijkgvwdKC5XiFPRZBbqi9N9gjnnw=;
        b=hEFf+ESY+Z096kDe8sENMN7saE2AzKbQsdFhMBvy1PLQBq89C3RdTk/1WdNnoAlyzQ
         8j3rx8wxGI8wkNKIn0WB+ExAyf72558FpFvg40+fopNEce2ongup6RLnbLIqkahlgUYZ
         aG5DU9BdQmdw9Dev2JZYE8qRaMIFhZ0TSGvN2JmrtoIA9S/nZyhc/Fgf20yK8RsmMs1D
         ewRSgfVxLMlmxZBtM7eunblZQGP44HREp0357b98Ue0k0Z1oQGcpPWMaih9ZNFMpb0/m
         z6+8pg6+c132fAdGhFUD3H/pgCqymqpHxCYzQ9/LDCj+L13CmqVl/cmUdTwgAPgAFJ3v
         D5bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778583768; x=1779188568;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xssrm6xj2btBy2lijkgvwdKC5XiFPRZBbqi9N9gjnnw=;
        b=rHiXbLU80ywz2Yl3BYRW5bMlwMuQVpPZ+nsQma2V4Y+Q+lxazL2liPH6B7DlDHPrOK
         Du5GLhCp5BTjySVF85eWg1pwdtMYLRvfjTV3Qsv5/Pq9+xn0XrTQl2V/iI5JEpJH+l9y
         nHYXp5cTxQKtoPo82+gDRW1l15uRvvZqQY0DzRfuOEwkSBC7JkUo0YMvOZFvoIUH85wG
         H0vgdrCJIac9ZMW0+7yXoNRXVoqZpB1l7zoEHBXYmJlCoPdGr7iViK/7FDKIWMD5I1zt
         9p43wRKPHSe5wPy34SoVQnk0E3jHZm5DCC4hPXZ0NcXmk52GPw85wG7hABgfbGpibD1q
         pDtA==
X-Gm-Message-State: AOJu0YxBiqYXOsclxwvnlQ5vT3zqO7TCR0DJB+qbMI84xNos1RwhHMtg
	2YTBe3UZMmMUiAA9EnWDy2dYG/2lepJJfQY2ezMw5ATe6OEYPIIphSb+OllOWw==
X-Gm-Gg: Acq92OFOPRsUI6f3Jvp97NDTTocdPcIId88DkHUXSPZ6nMj59T4NblZ2jwWoFR4024W
	l6nnCR5TiEsCRLSA5bWTEPPVBMeAdRL7PxPXeh7eOql4W1H9kE24zRv6Glo2823YsFPJQygiso4
	4/YayMSLWjP6bRUsZF26y+QsJRXQxuUXtUIUNJAYoyrG2L8IkK9bj1MMTF1TpSW6esFE1ep5ITl
	PRLALdEdwIECaA8rhww8KvBqiDZmIk/4oOqfxaXAyFjjEuh3PZkoROxs9tcO1f1i3TJdeQ4fG17
	jbTxiG1T7RmAdpKNGMdN7VCaqB6hLZisozKswwSLpFkuYFANvuFBDgP+9eJc44I3oYHSwN2O3kU
	NDQJqiz6jLCq41lyesvPCjJ8hVtnMbGz4MMYfE4LPP9ofm/fTMqVkGEAB9eeK0GGYPNnv3P4vA8
	qPoENzDAlbUoiS50jEP8v5xwmfPRvaLMCMlrmMbs37m6ES2BSuXEA=
X-Received: by 2002:a05:6a00:3e13:b0:837:75d1:a724 with SMTP id d2e1a72fcca58-83eebc4e514mr2917595b3a.37.1778583768149;
        Tue, 12 May 2026 04:02:48 -0700 (PDT)
Received: from kali-linux-2025-2.localdomain ([106.219.120.163])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83967dbcf16sm26992655b3a.40.2026.05.12.04.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 04:02:47 -0700 (PDT)
From: Shouvik Kar <auxcorelabs@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH] io_uring/net: allow filtering on IORING_OP_CONNECT
Date: Tue, 12 May 2026 16:32:42 +0530
Message-ID: <20260512110242.26219-1-auxcorelabs@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 21FE551F05F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,kernel.org];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13284-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[auxcorelabs@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.995];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

This adds custom filtering for IORING_OP_CONNECT, where the target
family is always exposed, and (for AF_INET / AF_INET6) port and
address are exposed. port and v4_addr are in network byte order so
filter authors can compare against on-wire constants.

Skip population unless addr_len covers the populated fields, to
avoid leaking stale io_async_msghdr data on short connects.

Signed-off-by: Shouvik Kar <auxcorelabs@gmail.com>
---
 include/uapi/linux/io_uring/bpf_filter.h | 16 +++++++++
 io_uring/net.c                           | 41 ++++++++++++++++++++++++
 io_uring/net.h                           |  7 ++++
 io_uring/opdef.c                         |  2 ++
 4 files changed, 66 insertions(+)

diff --git a/include/uapi/linux/io_uring/bpf_filter.h b/include/uapi/linux/io_uring/bpf_filter.h
index 1b461d792a7b..ce7d78ab13b3 100644
--- a/include/uapi/linux/io_uring/bpf_filter.h
+++ b/include/uapi/linux/io_uring/bpf_filter.h
@@ -27,6 +27,22 @@ struct io_uring_bpf_ctx {
 			__u64	mode;
 			__u64	resolve;
 		} open;
+		/*
+		 * For CONNECT: fields are populated only when addr_len covers
+		 * them; unpopulated fields are zero from the caller-side memset
+		 * in io_uring_populate_bpf_ctx(). port and v4_addr are network
+		 * byte order. Filters may only issue BPF_LD|BPF_W|BPF_ABS at
+		 * 4-byte aligned offsets; load + mask for sub-word fields.
+		 */
+		struct {
+			__u32	family;	/* sa_family_t zero-extended */
+			__be16	port;
+			__u8	pad[2];
+			union {
+				__be32	v4_addr;
+				__u8	v6_addr[16];
+			};
+		} connect;
 	};
 };
 
diff --git a/io_uring/net.c b/io_uring/net.c
index 30cd22c0b934..cceb5c1409ca 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1674,6 +1674,47 @@ void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req)
 	bctx->socket.protocol = sock->protocol;
 }
 
+void io_connect_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req)
+{
+	struct io_connect *conn = io_kiocb_to_cmd(req, struct io_connect);
+	struct io_async_msghdr *iomsg = req->async_data;
+	struct sockaddr_storage *ss = &iomsg->addr;
+
+	/*
+	 * move_addr_to_kernel() skips the copy for addr_len == 0, so
+	 * iomsg->addr may hold stale data from a prior CONNECT. Bail
+	 * unless addr_len covers the family discriminator.
+	 */
+	if (conn->addr_len < (int)sizeof(sa_family_t))
+		return;
+
+	bctx->connect.family = ss->ss_family;
+	switch (ss->ss_family) {
+	case AF_INET: {
+		struct sockaddr_in *sin = (struct sockaddr_in *)ss;
+
+		if (conn->addr_len < (int)sizeof(*sin))
+			break;
+		bctx->connect.port = sin->sin_port;
+		bctx->connect.v4_addr = sin->sin_addr.s_addr;
+		break;
+	}
+	case AF_INET6: {
+		struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)ss;
+
+		if (conn->addr_len < (int)sizeof(*sin6))
+			break;
+		bctx->connect.port = sin6->sin6_port;
+		memcpy(bctx->connect.v6_addr, &sin6->sin6_addr,
+		       sizeof(bctx->connect.v6_addr));
+		break;
+	}
+	default:
+		/* family is set; per-family fields stay zero - family-only filtering */
+		break;
+	}
+}
+
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_socket *sock = io_kiocb_to_cmd(req, struct io_socket);
diff --git a/io_uring/net.h b/io_uring/net.h
index d4d1ddce50e3..51fda715d3c0 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -46,6 +46,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags);
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_socket(struct io_kiocb *req, unsigned int issue_flags);
 void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req);
+void io_connect_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req);
 
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
@@ -69,4 +70,10 @@ static inline void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx,
 					  struct io_kiocb *req)
 {
 }
+
+static inline void io_connect_bpf_populate(struct io_uring_bpf_ctx *bctx,
+					   struct io_kiocb *req)
+{
+}
+
 #endif
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index c3ef52b70811..8ea6bd274607 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -203,9 +203,11 @@ const struct io_issue_def io_issue_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 #if defined(CONFIG_NET)
+		.filter_pdu_size	= sizeof_field(struct io_uring_bpf_ctx, connect),
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_connect_prep,
 		.issue			= io_connect,
+		.filter_populate	= io_connect_bpf_populate,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
-- 
2.53.0


