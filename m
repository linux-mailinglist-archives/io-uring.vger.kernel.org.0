Return-Path: <io-uring+bounces-10903-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id F2663C9D697
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:37:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 22EFA34AE21
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C175123770A;
	Wed,  3 Dec 2025 00:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ECzkRAF/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2969A22E406
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722203; cv=none; b=RBVRgLR5yIgdLLEikDfSIkwfx7XbaRd6hY/mU3K3OOrMv0YpbIGBl8Zev5/JShAj0tVsjEayLaVbmq9Y81BzyV4yFKKX+62zXZK5SjVZvsyU535jF7in6R56ll7uOqxDbyzziXQDcAiUTTRd225V+XTfSHQA1e0QmjyDeDMof6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722203; c=relaxed/simple;
	bh=9RyemEm3xlDvo1zuttIsC6bydxv6sxwCp3aNwuaC0sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOeQYPRmXF3tRr+6xGT0b20Gzavgo4JTSVAyfEOjZQMJOpsqDfpcHnPGP9K3/ZeaTPBT+BTYV+3hlwgjrZP+N+wJNc7qUPgEX7vKbSjeIcNltq6Mzsq0mT0NE88LWwl+r/dy2FQJgsTu8wgw5/O6NH4zf2tFu9ASqYMZecppGmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ECzkRAF/; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2984dfae043so53047755ad.0
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722202; x=1765327002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XnYyEzTSEPVl4kDponzZw4cGyFS7cP/hmTM+WADvqAs=;
        b=ECzkRAF/GTmg80KlsRHVO+Y1QtsT1Xj3E+3sKSRu9eKIs+BVc/4BpXlhQ3uEDv7Ct2
         tJtpgS5HhoN/tjU1D7mFDTt8RqLyJqa7EoULR0pZZPmKW8L2GjZ8vDJpjUK2qcuBkTDO
         0ISszCvMEZ3YwIJX64AO1BPt+FsaJCC26+wbT53kao/sIb5BVmeNg16OU5sky7A+K5C7
         TaXT9g7baUHd+nNHkM+P1TzDCKZjq3FDGZS2U7wJgQIZgYVWNCQUrgss/LbKvfPFkTNh
         ud6AoQdT/fOxI05/uzofSs9oMITrL6HsyZZMtYU4tHF0RcHAVh22JTUUSk/Pae5vnW4Q
         02BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722202; x=1765327002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XnYyEzTSEPVl4kDponzZw4cGyFS7cP/hmTM+WADvqAs=;
        b=LdWfdmAYxq0rSpVkBhUETRAEt6jT+LNyxSj4fNWOyWOwmRfXZOvf3ehwuuQCcjb446
         2TUVOm0JX2fuqt/FPp2bXhQlNWme2NOTw+ZXI3AIhZQgFZtEx+HBiHpkJFPGYUYFU/mC
         xIEiovhK0gEJYh9hZZoTpYnyWFK5lHQ7y5p8ONJ1Et5BpuYk5yxqDxqYUFObPydxf+ld
         2iT8CZ+VcZjl8jieyXcmzaNHvJ7insB/6EZEUZKv+FsZrBAjLJEEUjXK3lZdh53h9a/p
         L7WmRWL+wJf+D1Tylh4hXT+lny5r/p7tcLOykouex796wwpWE691mRCFBQYpY2kVRLE1
         66oQ==
X-Forwarded-Encrypted: i=1; AJvYcCUX3q8Mwz/gTr2IHVaisyfcQNB5RJOcA8woHhyVEW4A2gizl+xWYi9KSdVHaOcQkE5Eu7l7cKDlxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfKZGn0k/BM7S2UN5yZv//sVvMG6nXdvkLE8aN5/CzdmIerZ8r
	/ZuDQt2qtWS45Vm1i7c0CEQRz/G4l+5IJv84l+WCdwv/tY4VPRVt9xR9
X-Gm-Gg: ASbGnct/TwPRYRpZwcpK8wk86IM/D+Dfd7eH0w77PKe+hHWBhu/ndQScSPSYJZTACCU
	uRPSNXWkEYy7fjnZ0G7taalrYXURX1itOVKvdV6hOjouFg0MSaUGkz5PvQPuihw09MZpP77VF7p
	JRIbZHjkxceim/89ByQSJZwn/6gwlz7URbVXwFUk/g6M2rL2kt3CDuSsJ4d0BG4pTezyzcnBWPc
	3mppT1jHEM7W8nkPOYU0fNfZob7prGGWeLZDWtZLeTk1xO+DFmRJF7vl4IVMKC6YrD1yT3wGkl0
	MVPrnNnWZ7T1lgxHnCXju6ozlhPRFEHOkPZFIoBodi25x0pNtq8EdDAZBEuR86VEHh81P9Q8cep
	HphHGaJbj1RjJFQNfRkj6Cy0fLa2nNFvvob21PuM3poTSXdDT1bOnSEZnXjLSB7LSYh/WEm66YX
	2DdMzTHEQlfjhWeyj6
X-Google-Smtp-Source: AGHT+IEYCenSCuDNaBs0yLpejZ7XuLQ+z5/+esIlGpOR9el8oQZ0YbzBwDMOmjrUoigOr4hSbRx31w==
X-Received: by 2002:a17:903:1a30:b0:298:8a9:766a with SMTP id d9443c01a7336-29d683e6e7amr5342125ad.53.1764722201645;
        Tue, 02 Dec 2025 16:36:41 -0800 (PST)
Received: from localhost ([2a03:2880:ff:f::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce40acbbsm169826115ad.11.2025.12.02.16.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:41 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 08/30] io_uring/kbuf: add recycling for pinned kernel managed buffer rings
Date: Tue,  2 Dec 2025 16:35:03 -0800
Message-ID: <20251203003526.2889477-9-joannelkoong@gmail.com>
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

Add an interface for buffers to be recycled back into a pinned
kernel-managed buffer ring. This requires the caller to synchronize
recycling and selecting.

This is a preparatory patch for fuse io-uring, which requires buffers to
be recycled without contending for the uring mutex, as the buffer may
need to be selected/recycled in an atomic context.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/buf.h | 10 ++++++++++
 io_uring/kbuf.c              | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/buf.h
index c997c01c24c4..839c5a0b3bf3 100644
--- a/include/linux/io_uring/buf.h
+++ b/include/linux/io_uring/buf.h
@@ -12,6 +12,10 @@ int io_uring_buf_ring_unpin(struct io_ring_ctx *ctx, unsigned buf_group,
 
 int io_uring_buf_table_pin(struct io_ring_ctx *ctx, unsigned issue_flags);
 int io_uring_buf_table_unpin(struct io_ring_ctx *ctx, unsigned issue_flags);
+
+int io_uring_kmbuf_recycle_pinned(struct io_kiocb *req,
+				  struct io_buffer_list *bl, u64 addr,
+				  unsigned int len, unsigned int bid);
 #else
 static inline int io_uring_buf_ring_pin(struct io_ring_ctx *ctx,
 					unsigned buf_group,
@@ -36,6 +40,12 @@ static inline int io_uring_buf_table_unpin(struct io_ring_ctx *ctx,
 {
 	return -EOPNOTSUPP;
 }
+int io_uring_kmbuf_recycle_pinned(struct io_kiocb *req,
+				  struct io_buffer_list *bl, u64 addr,
+				  unsigned int len, unsigned int bid)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_IO_URING */
 
 #endif /* _LINUX_IO_URING_BUF_H */
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index ddda1338e652..82a4c550633d 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -102,6 +102,39 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
 	req->kbuf = NULL;
 }
 
+/* The caller is responsible for synchronizing recycling and selection */
+int io_uring_kmbuf_recycle_pinned(struct io_kiocb *req,
+				  struct io_buffer_list *bl, u64 addr,
+				  unsigned int len, unsigned int bid)
+{
+	struct io_uring_buf *buf;
+	struct io_uring_buf_ring *br;
+
+	if (WARN_ON_ONCE(req->flags & REQ_F_BUFFERS_COMMIT) ||
+	    WARN_ON_ONCE(!(bl->flags & IOBL_PINNED)) ||
+	    WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING)) ||
+	    WARN_ON_ONCE(!(bl->flags & IOBL_KERNEL_MANAGED)))
+		return -EINVAL;
+
+	br = bl->buf_ring;
+
+	if (WARN_ON_ONCE((br->tail - bl->head) >= bl->nr_entries))
+		return -EINVAL;
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
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(io_uring_kmbuf_recycle_pinned);
+
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-- 
2.47.3


