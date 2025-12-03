Return-Path: <io-uring+bounces-10905-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FDFFC9D6A6
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:37:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 15ADA4E4E9B
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E5521ABD7;
	Wed,  3 Dec 2025 00:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTtzBa7M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC5823D7E6
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722207; cv=none; b=mZ05s6IFoKruQVMGQkQ6FlkMYGDiXxzXbKKQo4v3wNOF9SsOog6PgHJopgsKDLQfy4jnmjD9/KBeDDRkhHZNFXW7XD6aMvXSOQBeXmNP2C3VJhVAVXTIgHH1dMe+Fay/akCnL7Ci5ynxf7UCWdSmSlooj0/1xKgO1BCn27Zo1xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722207; c=relaxed/simple;
	bh=JeZ4PnbcXkAe0cXmwfgERZlf11yTWQRHwJFaB/D/uYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNpFXq0WEQ3VKfXhjMRzlKHGO2jbQGmsLi34oyAd8Y9bwhOJOlwWyfsEh7lCgtljmII7eqkQRpFlVlfh/zH7w9PVT9/gyv6481azOfANrWqe9yeV20sC2598SHmVx48nRB7Y4x3ZEHFcr3ztaNBWikbwiPNUHby/eU/scb99MgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FTtzBa7M; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-297e239baecso2390195ad.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722206; x=1765327006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhOeHkxPrbMQ325EQN88eJBPNWjEdCqlX1NTe94cSAg=;
        b=FTtzBa7MQSiODxbJ2KOlGCaFp2gRQxZHKt6KZZRa/nJUvaSGdTXxYaP4pkJmd4z17E
         lxeEV0jdYn0lyWqEJgtGNfYmXDG5uDNiss8Y7hMhUVQFDnsM1SqNy0S9c2NmasRs1Cln
         D24h5wi8Nv2LndjNRR2FMQr+kJb4LswaoxBUm2IND7NdTxgXRyL2EuARrPjRxKBfGpSF
         /vY1q8jTVEvHWS+I4j5vpJJ9bxl912wEXFeknFGcsyEw8W2UYsWR1ufWSt5e+E+kgWMP
         RhWPfAEc23QjQNFX/Ch8li5MWOAWaZoEESaZxclJtZ3ELTxvoxdkdXSg1vrXVcjkvBzP
         Qvcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722206; x=1765327006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hhOeHkxPrbMQ325EQN88eJBPNWjEdCqlX1NTe94cSAg=;
        b=X6GsBmZN1RFBkBJpnVyNHVryQYWKfpO0k557lsrC3PZ3Usx9tkqYX7MXVOazD2JArg
         iZ2YiKLSK/5h4JkQ/o+oDKk2wdKPq73+OstU5f+i+FeC0aUX9qS+2fqGDfY9vhlHfB7o
         k0xwYWjx5J3GN1joFXDyi6ObbFHg+2Ex7gVTzpiIdrYDQb7FrcL9x0Qf6Vejk9Osu8QZ
         LxmVL6mZmBTtDPnzZipnQBLYm9Ns794KRMhjSu8pED85goFISeQBqPpRFRGT4voIV5hU
         fkWNyQtoYxPtCG1o8PgXLAdvX+WRUV6ryO2cnIgSMQnEP1fzgYgzXHOB/76uSY4FQeA2
         jZPQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0CFh5RT/Af2uZPWtAYY4BUWP9uPV6VPyCNQz/qe/HcTGiHeZBD//OuqibOc2USd+i5FtcKUbgRw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxSI6h8va2MMG/KmbOuW62mqYwhRnhMxFLdpHFU0gES1STOn3cW
	0pckYqobI9gFjERg/c//nLLCPQoJi9gypNf12nM9ThjQNY4lhPs1eVHK
X-Gm-Gg: ASbGncudvji8KSdgEkasMcLrWnrANhC+n3TXaE/tbLjVAHK1BSR7XcHdVUApR8fa9TJ
	quseou/l3eHDUtJiAHkjq8mDp5S/xfqGA8wBnudL44i8Ym4Gji7D/cY35eWj1NLZeRPGk5dk38m
	/QMocKNkynaYph7sVTdkP4pokgQASvcZUoGat0hftcxehxum5wZhs01CdL/ARAPsk4HlWs8fyWE
	aVwGjPpKv5r14M/ngfGlTdohjkOH8lxHlBODhBLRY3zCoNZ29y+53ehasoboKiPGEkXLXLreXah
	1STnxQu+dYwCvWzhtmpg3uwO3ODKl1iAbzvddt6ZVirTcrmDLrAOLH7WEWsh2XwEAfa2U79AX0w
	AfgzCwtqDpDpgXPOQVsoYx4+Mmuh1hUnuxhA9bDVr8tMmaGgn43eLvZO0v/DK+Ir/EsRNRhLoW9
	BFh3KeTkqXPfazj/cg
X-Google-Smtp-Source: AGHT+IFm66sV0bCwR9D2cpB1eAqwDxIT+UzLH5S+F1k9kNLhunb2p23f/etFoavE3TH34UOHIQXMGg==
X-Received: by 2002:a17:903:b8d:b0:269:7840:de24 with SMTP id d9443c01a7336-29d5a5cff47mr44466035ad.21.1764722205742;
        Tue, 02 Dec 2025 16:36:45 -0800 (PST)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34910ba58a9sm623645a91.8.2025.12.02.16.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:45 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 10/30] io_uring/kbuf: add io_uring_is_kmbuf_ring()
Date: Tue,  2 Dec 2025 16:35:05 -0800
Message-ID: <20251203003526.2889477-11-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a function io_uring_is_kmbuf_ring() that returns true if there is a
kernel-managed buffer ring at the specified buffer group.

This is a preparatory patch for upcoming fuse kernel-managed buffer
support, which needs to ensure the buffer ring registered by the server
is a kernel-managed buffer ring.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/buf.h |  9 +++++++++
 io_uring/kbuf.c              | 19 +++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/buf.h
index 839c5a0b3bf3..90ab5cde7d11 100644
--- a/include/linux/io_uring/buf.h
+++ b/include/linux/io_uring/buf.h
@@ -16,6 +16,9 @@ int io_uring_buf_table_unpin(struct io_ring_ctx *ctx, unsigned issue_flags);
 int io_uring_kmbuf_recycle_pinned(struct io_kiocb *req,
 				  struct io_buffer_list *bl, u64 addr,
 				  unsigned int len, unsigned int bid);
+
+bool io_uring_is_kmbuf_ring(struct io_ring_ctx *ctx, unsigned int buf_group,
+			    unsigned int issue_flags);
 #else
 static inline int io_uring_buf_ring_pin(struct io_ring_ctx *ctx,
 					unsigned buf_group,
@@ -46,6 +49,12 @@ int io_uring_kmbuf_recycle_pinned(struct io_kiocb *req,
 {
 	return -EOPNOTSUPP;
 }
+static inline bool io_uring_is_kmbuf_ring(struct io_ring_ctx *ctx,
+					  unsigned int buf_group,
+					  unsigned int issue_flags)
+{
+	return false;
+}
 #endif /* CONFIG_IO_URING */
 
 #endif /* _LINUX_IO_URING_BUF_H */
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 82a4c550633d..8a94de6e530f 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -945,3 +945,22 @@ int io_register_kmbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 
 	return 0;
 }
+
+bool io_uring_is_kmbuf_ring(struct io_ring_ctx *ctx, unsigned int buf_group,
+			    unsigned int issue_flags)
+{
+	struct io_buffer_list *bl;
+	bool is_kmbuf_ring = false;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	bl = io_buffer_get_list(ctx, buf_group);
+	if (likely(bl) && (bl->flags & IOBL_KERNEL_MANAGED)) {
+		WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING));
+		is_kmbuf_ring = true;
+	}
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	return is_kmbuf_ring;
+}
+EXPORT_SYMBOL_GPL(io_uring_is_kmbuf_ring);
-- 
2.47.3


