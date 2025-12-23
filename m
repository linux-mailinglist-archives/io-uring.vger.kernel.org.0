Return-Path: <io-uring+bounces-11258-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DF425CD7818
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:37:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 53B363021F80
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2051F1F5842;
	Tue, 23 Dec 2025 00:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gOUp1dr9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652A91FAC34
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450199; cv=none; b=fXBG7GPbkTigYj8o9L2ZNHHEVtnWii+dZUQGWdOoaKV8j/jN8+wYLm6Ba2MUlaMSlU07HS0inYNqshKj+78OQOaCqo+jzk05xpxaRgTldDI91fFH2IOQqWC6WuTBAKaLhDBRdpfYlStWw/SfGBkfPDQ69JvyUMT9xEiYhVnst3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450199; c=relaxed/simple;
	bh=Cn4YXhtfJtQCorTHnlGIJjHih1NZjRUoyEUVM/vGQF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dN5bRhzfycsjbKpVhPQDgK0oiyH/BPJRy+0CVlVXpiFYXGfUQ8DOz+svJk2s8H29FlqJWK/E3HvoF/VuaJ5iTJoitZAJ99fLVyGFhbbXsC7SyB3CXkTGYhtiy8DzHTiCXUotfaxso1PRYB+vavmHdfVZdihdy9TmWO4xPIX+sms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gOUp1dr9; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7b75e366866so2106057b3a.2
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450197; x=1767054997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qiTizGnGuIHEXoLHJRCFyeDtU6SNZ1Pdn69Hi3vyqHo=;
        b=gOUp1dr9PIMTG6xg33JcLzZjhv7qcLNVFYst6bsFGYMMph0vFYJgj1MzeoT9J/Rdn9
         LnujeaLRaqlAu3c8kET1b6C0kMjfGwODSaSVoWDE+IxApv/olClegrGrwziiSzsU6ALL
         ky12dzsHO/czGSkCCHAhPqI8q2jEZbyJHBlE1jD+E3pZIXf9AHYfZwWIHh5EnoacD0Fn
         xGEEpbEw2jOvDvgyRIKDfynAp8beqra/re+G9DAbOEkS/94EXg+qmgEnxE0ljGN/7eOr
         8lvVIEFqUSFE/s0DYCajrj5MHmV+kPQJotVBvb/0BUWMPFDBN/+YMdnJ1PdAv34yKYKg
         RMYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450197; x=1767054997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qiTizGnGuIHEXoLHJRCFyeDtU6SNZ1Pdn69Hi3vyqHo=;
        b=We0SL9q9TrZgG9Q2EmWJH+HR7aP75iklPWavx/k2mTHlrNZA/zX7WKziPqV2xYVPde
         OTPq6oxDu5YP25BfWO+loPgN2STWhSmc4BAFUGo+a3YrfUsnb0QaSFB+vupyT8bYawk4
         GiXPRM3YvS2OUf62M+BVQO7FWhp6aOxCCb8UJWhcslTkY2K0NgqPSJ4x16K5HPEBOk6e
         aypfeMepcAG+DedVDRMfg8wPKS4XYRexi6LidKpYtHofk7/zGhAlRt30FVRt7lW6FTwX
         4gTMu0KGQeBXfLubiOA0mLI5cthytAfAB2dfrYRibYXsHd1D+FTpXWnQTyBTawz9GSjO
         yYLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTTSL4mHIW1ODCy2AHH6Atdo+EwFSmKm16HtSh+lOrEaZILF3Zx/S3cfRCblgHvQ8+UZyIB4l3uA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwVY1T2xeP9kBfoZ47Aocmf5wbElD1dIVtmCG69DK/xsjUKeW+R
	9QKYrSKmD2oljMCiTDBgkHJFphqJfCFnFYzQ0VueRcMdDlpHwQMeTLKE
X-Gm-Gg: AY/fxX74GTzo1F14uoaIpkjcmMVRxvX6e9Iwqjp5V30M28gSXKstI+BH5L4cgy9UMFm
	ueS6kVk9WXN7c1ZkMJFpu18odLDjSnmUqJ0CMwewG8QziO3REaBvWdZYqea4A9w/Hh6+fnE+zqb
	lYNGqrLkVY0Qd9JQwmDurceC8tuORR1eDdvVD+zu4ve8CL6vSYSfYbhD9k3B7MGfCMtBcM8bFqf
	ppCb3EY6oRNxKyYUK79GJhduHc/sm4yVKxF4gPh/ZfNV3xdVjrJXs2hxInzGPNLUTdSCh2ugSkd
	y3nc9oULBCmHHVpNamEcSgHcosaU7sdI87gyeggIqZ/+alPz/wdVXfmtTaBN15EBNDriZpMAiqz
	aCChVLjOmsXycXsBjj9N6TAxGmTzp4mG9cH1P4DvukNpfY8aFsmXne/vutyzsaFQhdBIe9eDz38
	qn9bEDuQk7FNuwAcpr9Q==
X-Google-Smtp-Source: AGHT+IG63B7cklMxolSJwHvySWezv1dFsudVKltt05KOdFOyB2wBiEGSfSbAgDlwFJOWTcHWbJ7NqQ==
X-Received: by 2002:a05:6a00:328f:b0:7e8:43f5:bd36 with SMTP id d2e1a72fcca58-7ff66d5f579mr11233083b3a.34.1766450196693;
        Mon, 22 Dec 2025 16:36:36 -0800 (PST)
Received: from localhost ([2a03:2880:ff:43::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a93b441sm11461718b3a.9.2025.12.22.16.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:36 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 07/25] io_uring/kbuf: add recycling for kernel managed buffer rings
Date: Mon, 22 Dec 2025 16:35:04 -0800
Message-ID: <20251223003522.3055912-8-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003522.3055912-1-joannelkoong@gmail.com>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an interface for buffers to be recycled back into a kernel-managed
buffer ring.

This is a preparatory patch for fuse over io-uring.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h | 13 +++++++++++
 io_uring/kbuf.c              | 42 ++++++++++++++++++++++++++++++++++++
 io_uring/kbuf.h              |  3 +++
 io_uring/uring_cmd.c         | 11 ++++++++++
 4 files changed, 69 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 424f071f42e5..7169a2a9a744 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -88,6 +88,11 @@ int io_uring_cmd_buf_ring_pin(struct io_uring_cmd *ioucmd, unsigned buf_group,
 			      unsigned issue_flags, struct io_buffer_list **bl);
 int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd, unsigned buf_group,
 				unsigned issue_flags);
+
+int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd,
+				  unsigned int buf_group, u64 addr,
+				  unsigned int len, unsigned int bid,
+				  unsigned int issue_flags);
 #else
 static inline int
 io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -143,6 +148,14 @@ static inline int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd,
+						unsigned int buf_group,
+						u64 addr, unsigned int len,
+						unsigned int bid,
+						unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 03e05bab023a..f12d000b71c5 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -101,6 +101,48 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
 	req->kbuf = NULL;
 }
 
+int io_kmbuf_recycle(struct io_kiocb *req, unsigned int bgid, u64 addr,
+		     unsigned int len, unsigned int bid,
+		     unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_uring_buf_ring *br;
+	struct io_uring_buf *buf;
+	struct io_buffer_list *bl;
+	int ret = -EINVAL;
+
+	if (WARN_ON_ONCE(req->flags & REQ_F_BUFFERS_COMMIT))
+		return ret;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	bl = io_buffer_get_list(ctx, bgid);
+
+	if (WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING)) ||
+	    WARN_ON_ONCE(!(bl->flags & IOBL_KERNEL_MANAGED)))
+		goto done;
+
+	br = bl->buf_ring;
+
+	if (WARN_ON_ONCE((br->tail - bl->head) >= bl->nr_entries))
+		goto done;
+
+	buf = &br->bufs[(br->tail) & bl->mask];
+
+	buf->addr = addr;
+	buf->len = len;
+	buf->bid = bid;
+
+	req->flags &= ~REQ_F_BUFFER_RING;
+
+	br->tail++;
+	ret = 0;
+
+done:
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index c4368f35cf11..4d8b7491628e 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -146,4 +146,7 @@ int io_kbuf_ring_pin(struct io_kiocb *req, unsigned buf_group,
 		     unsigned issue_flags, struct io_buffer_list **bl);
 int io_kbuf_ring_unpin(struct io_kiocb *req, unsigned buf_group,
 		       unsigned issue_flags);
+int io_kmbuf_recycle(struct io_kiocb *req, unsigned int bgid, u64 addr,
+		     unsigned int len, unsigned int bid,
+		     unsigned int issue_flags);
 #endif
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8ac79ead4158..b6b675010bfd 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -416,3 +416,14 @@ int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd, unsigned buf_group,
 	return io_kbuf_ring_unpin(req, buf_group, issue_flags);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_buf_ring_unpin);
+
+int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *ioucmd,
+				  unsigned int buf_group, u64 addr,
+				  unsigned int len, unsigned int bid,
+				  unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	return io_kmbuf_recycle(req, buf_group, addr, len, bid, issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_kmbuffer_recycle);
-- 
2.47.3


