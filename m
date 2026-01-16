Return-Path: <io-uring+bounces-11777-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A8F9D38A22
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:32:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 90C41308009C
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBA2832470D;
	Fri, 16 Jan 2026 23:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F/EGo95/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4B6320A34
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606280; cv=none; b=sbg2GrnE6BT2/24ddQDOAl2J8r72Njrcptu3NuZFpppzDWNuwsVlCzUbNIcygoJDKvX+UdHv4nPYa2OCFV7DiXFiaqMRKuMb0CeFjLOoOhuDd4+Hf9AZcxW8mdCSN4Nau+kXjs18sRPeBH24SnwvCzVZa+Lj23MvWNNJoWD7JxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606280; c=relaxed/simple;
	bh=SkTAYdFLozzjB1vK8i7C+LXE/zWxy5igiQClQFcNSiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHfyJTpJzsu2+HaJhkpHbbz4prz9gfjYmmneO8Gsaufwk8ov3k3E6f4xAQBHUv0upSMH4gucet9ILtc3/pDQh73xkHY5ugTWV0VHmVOsIUrBIxu5FkkZEYQhsXYF7W1rROkTx8vnLcx3Ps022BaQ1s2Nf2ty1uv6Ms4T+sQ/f4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F/EGo95/; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a0d0788adaso17231515ad.3
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606279; x=1769211079; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mDcuLWgFDiAMG+J9Ks4YlrYbHfO0+rT15fOojd2hUtQ=;
        b=F/EGo95/ijF/TmOrph7Y8ZhBmAxTmWb9yAnjfEiEa9a8t1V2JGQRnLJYAipGHrF3w5
         C8CKaioHIyhDGdwvt48PUkgmXoh41TXo51pITcf8omYn99hmn+Phunsk/QOgF8Kqjn87
         WARxEkaz7Q1TZIK8os1ViVuPwjJR4vxZwK0VYkS38pE/VORbqOqBl2MTh05rGJFP6f9w
         9pls2HOdrN/UVN65JmKqeJRVj8slADhkVNZJzv8MeBiXhLUxx0KQl8SE4rLLkz2gt999
         Ub5yDQ6xxisMG+VMoW+v8lxhFq84CNA77tTmTZSW98BAVTo11YSCxeCEA3d1oMvOHA/h
         0zGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606279; x=1769211079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mDcuLWgFDiAMG+J9Ks4YlrYbHfO0+rT15fOojd2hUtQ=;
        b=A7pH3h7eEH2PzModsK4trVeSPM60/s9l2TJK5M8EAAmz6geya+WWkY32Rcvol+GH2h
         SKbP99frli2a4a1EoJrG4q7oaU+lWQr0+XOf3S/O2dT60/4jpbK8iYFvnsoHPOpctxLd
         EtICCDRLVdSUqZTfRjf8cYOCbjmDqblaq8v0brmLzW9Ik9ri299sOzdM3Iy13QZ2zqdq
         tbMCIbm8iXzzLypM6A1h6lvN0KObrqDT/jqv3wOyR7b3U16dUxFF9Oi/A1kvEH3j+rxs
         GlvAD148wmRDGKi4XZGIRvrGGCGZ6LsgjxZrudF+xlyLEW9OehSQtWF1THXsh/YHS08y
         i3hg==
X-Forwarded-Encrypted: i=1; AJvYcCVUPPYcpYhXVhlM0ywl6nsAE+PUXTswNenMOjD2+jcV9pCixc/F0TuEe9/itYux1ckujuNVBDa14w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzpJZ7UjVLpGz6P+HrjAiGW84JPVlY3i5koRkzbLhF+RNT3sfzZ
	GM1fdgVtgkTnGm5Q4Y5WHFWzspX3sSHpaU9BY2/2wMQFzHS3E7tQvHG2
X-Gm-Gg: AY/fxX7kl7BRDVQTO4e61jlQUIRwmsumwPePOwrHZZ2tEPcLC3JDRUTiZQlQOO4Wk+P
	RgFeZge1AC6r3blcoFc6JIendDBNCpcpN8LYhjCzOaoANAMe43kRgE7VX0Z3fju1leHWXitFUh2
	djaZFZF+2POrm+CYnSqFWAtbf4z+nR2/1ldK3URqPrAIqY8BdmIrAUcbFWq5KGdQgtwt+Q8/8pl
	ciTdz9PZOmamAb3aNPE3lCJsE/P/zv8EopZmGA1Q8Z1BeDqa8qyK5YQbFBtZy4k6xG1lWmGruxq
	X68NVqZDWGHj3ygWCkP5Sc+MJ7nxQK+1qR6+gVpZMLjo3Hl6KYP+vupsSXsNgOLNAWGB5TxJMkM
	hOsZhYEhXgyFBu8SI0kI0hPvGYR3bQmT8cUZciyaTdye+dILOrhNlsn+OWeh+Ojt6TccifXnM4B
	pVq84KzKHrMty2l6k=
X-Received: by 2002:a17:903:2ece:b0:2a0:c884:7f09 with SMTP id d9443c01a7336-2a7175cd277mr41444305ad.38.1768606278813;
        Fri, 16 Jan 2026 15:31:18 -0800 (PST)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190eee39sm30187665ad.45.2026.01.16.15.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:18 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	miklos@szeredi.hu
Cc: bschubert@ddn.com,
	csander@purestorage.com,
	krisman@suse.de,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	xiaobing.li@samsung.com,
	safinaskar@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 09/25] io_uring/kbuf: add io_uring_is_kmbuf_ring()
Date: Fri, 16 Jan 2026 15:30:28 -0800
Message-ID: <20260116233044.1532965-10-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_is_kmbuf_ring() returns true if there is a kernel-managed
buffer ring at the specified buffer group.

This is a preparatory patch for upcoming fuse kernel-managed buffer
support, which needs to ensure the buffer ring registered by the server
is a kernel-managed buffer ring.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h |  9 +++++++++
 io_uring/kbuf.c              | 20 ++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index de3f550598cf..6ff5c0386d0a 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -100,6 +100,9 @@ int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_group,
 int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_group,
 			   u64 addr, unsigned int len, unsigned int bid,
 			   unsigned int issue_flags);
+
+bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd, unsigned int buf_group,
+			    unsigned int issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -174,6 +177,12 @@ static inline int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd,
+					  unsigned int buf_group,
+					  unsigned int issue_flags)
+{
+	return false;
+}
 #endif
 
 static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index a7d7d2c6b42c..d86199ac3377 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -961,3 +961,23 @@ int io_register_kmbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 
 	return 0;
 }
+
+bool io_uring_is_kmbuf_ring(struct io_uring_cmd *cmd, unsigned int buf_group,
+			    unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
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


