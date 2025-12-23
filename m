Return-Path: <io-uring+bounces-11263-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9003DCD783F
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:37:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F9373019B4C
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68BC919C553;
	Tue, 23 Dec 2025 00:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ekw/VbLk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5D91DF736
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450207; cv=none; b=iGsUZf4EZGS+sD28hDJPDNIYw6Amf0tyLA8DdEhoIohM2QTcFv1McL9NhBDYjIe+72q97lxVolAns4uAZcwL5N1caiJSJcIKr8vmrdIJ53mWKZGDdOvRldLhDw2Y/Wub/sjFnAgLPLdcPS5xltlyYnGyBs0abdk2aCDJrD2hVdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450207; c=relaxed/simple;
	bh=aKLejG38uvIOlTozL6KpMQyVF5B+JfW8946A+LiVe7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXtPZ2EdZ/o3DIOJUh0Lf0ExiqWr5TOMqE0PbskrVPHtUVj69sRai4F3FgzAjI3CBARWGL9JrTyz1iWatxqGQoF8eBy9hCkMegwNgs0iP48xY/hWA+NEX2MTQO+/CFe3e9FiEapLfrMDrGnEdXGtWe0SnQpm4+J4il8yZlfC/tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ekw/VbLk; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34c277ea011so4508053a91.1
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450205; x=1767055005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kh5ZVXmsBZcQ3OrKebkx1eIN+Pz6xPHYh4mwcIs+LIA=;
        b=ekw/VbLkD4wiZ09sFp/fb6uF5lI3c024eYpyefEzw81rW1KwuwuSxFaa82oe+giJ5T
         vsfXHBT3oNeGgYcGei9sP/MjO7vdTvcbb8f9G49XIxc4UyctSGn/KCl4Emi2spEEodEi
         6EXcajhCH2bJ8yNnqsBYW/ZbQyD+uh7CRNY8uNIxHDuPIjqseuE/Ei2bOcstWLcsIO/k
         nOmDcY3pUmgN0BBzkZa8WjEMnrmk8cVr05CIMo7pgmrFycI8fUcIdg6UMwV31M6F8CRj
         UlUJLPSdVSEPDh4ydHhKeGluFOsZSQthVrBZp7wl4pPhRqEwvkKgkdBBQKu8EQPc8JoQ
         QDJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450205; x=1767055005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kh5ZVXmsBZcQ3OrKebkx1eIN+Pz6xPHYh4mwcIs+LIA=;
        b=tTB4KCLLwl21JZ5WgiTkfXDytx7eTokTZSnTyd5oN5lDLIywgDwnaDyGLQIId8/A7R
         BEPyKcaFvWiE4YSUWzNq2+DlAmOLjFiHw653Q6DK4j7hSyxpICKVEnvcq47d5s48xzFY
         /jUoDV9WOl8Br79vZnnkepkV01u9MkkslohMC5HpFmkDJTUdOAsKWatg51ASdK/2HEhU
         N0fbjLT0PrdX6QF32JSOwrnfyJBN4ec9QxFKArGKH6doq6gwvQ9QypGbraKXOQ2Oqv0s
         LosibMgonD/o2i87YAV04OVFwylfieUWZgPbo0plqi2qZ2I+YG/+1as8L+3TxLBTzewd
         5OSA==
X-Forwarded-Encrypted: i=1; AJvYcCXQ1AihHw+dazrNxeGR0+AGuaH9tzEkyaHLEwKQZ96E7NOXBEx8odCs4i15YIxctGaHGls2GJYsyg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7nTpCL3uXlfyxIdzJU/kYLU58Pbc0WBu9pr1EIbMQlPlqgepE
	iBJVGiuzdLd+Heoi6CbnJUHvebVJTdBiTcXwsnQSdYBY9JI2RDLSwsXffyk3LBoK
X-Gm-Gg: AY/fxX7ylcLrlhbqJh3mgl8RMwPFs51o55W2bnYBhnVOdzvV6k9raTjOMNTki5RJtOz
	Zx818xEt35zhNVJEYQMaDtw98vgeRu4DUmV7rOkK5u2d9GgLEq4jmsevhbkU4zICpxKMJRcjkKM
	dakNMqErk1FoRqeejZ0FRpgleC39UzkWg7Sn2QA5ZTQd8Uzj66rwbjl5hvvQkRKkoxXhIVxXfTh
	GfMYKXf9uMJ9mb1GqVVEJ54++faz1xyzCNRAZ/NVYGzrSQ4bj+jLPOVfiTdTyLhoSoVu28aEYVB
	UR9Vcz5IllcMjIFPyKfpD61UfxdDP3UHGjstyec/SEu/y0gLneGIiq640bMA/R6upn4qgRy5g39
	tS5nBDDuX6WymU5QXNV++b24N52lNaHZpmK8T81/IZ4LM/oNzzDvo5d0a23oWMtHGPrhXix0/wp
	39zb/9wRwloibI5NvuxQ==
X-Google-Smtp-Source: AGHT+IHQmJ/iYFMQ1CONToiMLDUQ2ZEpyegdZpTA+eDDXrBPi1fE6+xkXGGpdKmj0U7uxNsGP+aRNg==
X-Received: by 2002:a17:90b:3c83:b0:339:d03e:2a11 with SMTP id 98e67ed59e1d1-34e9214931dmr10605718a91.14.1766450205178;
        Mon, 22 Dec 2025 16:36:45 -0800 (PST)
Received: from localhost ([2a03:2880:ff:40::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e79a164d0sm10248466a12.10.2025.12.22.16.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:44 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 12/25] io_uring/cmd: set selected buffer index in __io_uring_cmd_done()
Date: Mon, 22 Dec 2025 16:35:09 -0800
Message-ID: <20251223003522.3055912-13-joannelkoong@gmail.com>
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

When uring_cmd operations select a buffer, the completion queue entry
should indicate which buffer was selected.

Set IORING_CQE_F_BUFFER on the completed entry and encode the buffer
index if a buffer was selected.

This will be needed for fuse, which needs to relay to userspace which
selected buffer contains the data.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/uring_cmd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 4534710252da..c78a06845cbc 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -142,6 +142,7 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 		       unsigned issue_flags, bool is_cqe32)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	u32 cflags = 0;
 
 	if (WARN_ON_ONCE(req->flags & REQ_F_APOLL_MULTISHOT))
 		return;
@@ -151,7 +152,10 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 	if (ret < 0)
 		req_set_fail(req);
 
-	io_req_set_res(req, ret, 0);
+	if (req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_BUFFER_RING))
+		cflags |= IORING_CQE_F_BUFFER |
+			(req->buf_index << IORING_CQE_BUFFER_SHIFT);
+	io_req_set_res(req, ret, cflags);
 	if (is_cqe32) {
 		if (req->ctx->flags & IORING_SETUP_CQE_MIXED)
 			req->cqe.flags |= IORING_CQE_F_32;
-- 
2.47.3


