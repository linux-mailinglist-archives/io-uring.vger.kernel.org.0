Return-Path: <io-uring+bounces-10970-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB30CA5A37
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 23:44:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9DF9631342C7
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 22:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8294D3314DD;
	Thu,  4 Dec 2025 22:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="b3Nw/9pC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DB12E1730
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 22:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764888223; cv=none; b=oa/QPHfNKIk97VCDYP65r8OqR3XMntvBrNhUGDRkaMsDi+dBnjaqEwgAPzsxZiKbraPeSJvXyAWYZKWIRjOPBufVMcaXcvea6P4v7vsZgyt93QIefasElCKwnDRtxqL7zw5xnRqfS9aJZ03nHRwyAwkxE5jBPAPOJicQ7ToS3Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764888223; c=relaxed/simple;
	bh=fKji5UW4qQnxmds1k5RC/OxIA1Jh6yZN4K7RxDG0990=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dX33iPmi8trdFeDyDrxpKiPJWykgpYFKCk/taxzFJSSgBIZHASQbIw7+cAJmtpardrCNR5pq0Wh+ZxyxO2AEoefAw0FO0jvqT/HhPIViibkRXGENC8Fglpv3baBh7GQNn46KK6d+HgjsAFN01LEOzrgWRBYR6gxl4lX6X0VRTkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=b3Nw/9pC; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-297d6c0fe27so1954665ad.2
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 14:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764888217; x=1765493017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yUQAkBnTqkldE0MNFpzbBZDBYWqzkXqzRwim8JXEfT8=;
        b=b3Nw/9pCUw0XrlBFL8YJig0uyClDMBN21MtKHo+/MAMd+VWxPqF8snDv+jddYzDUHe
         SNV4P+GNy5lgKvuuuwXSVvmH1Z7TP5Lx9gOTEhyK+gDDWP3vISSJcLT3tEcDlczdhUiE
         e0FadU6Ldt+ynT+uPyzDM+goflROX/SppPfMRJzybQgCTq7zY995QlrYUx0wdHioyqyA
         ULU6tCmxWJgJMa817wrBF98P2CZm+JNE/KQTzA/UcV+3wAtfavuJPXO+mE0MpP7+XdF5
         h9xzh8eV1GMRYAquyJyK/oke3CIa78Fe+1+t8epQOZZSOZLGcvVdB2xVnC6EgWNMu+tR
         a6hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764888217; x=1765493017;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yUQAkBnTqkldE0MNFpzbBZDBYWqzkXqzRwim8JXEfT8=;
        b=okD661TveCxBqDum3bwDAHHe7nMvI2T/iyRCFX70WGadPipdCHZ3N5sM/cCuw6NoMf
         21uTfBHs7TOuKv8OkW0EmaMQwvmIQv23aXZiY0ktXXm6NJy5D5hjgwfvhug2DufhVU3p
         wZ3c8MRa93fJJDqZYWFiV1xOtyeStdpvpql8EvZkBNDTjDX9wNmGLp9nRN3yJbjupq6x
         DOrXQtNxv8ucGA8TZHwdt/uIseHuiwz2zw5YBakfEKBIZCVQqvSWwS+b5n3F4enDJ7pK
         t23nDEUgL806B5h78FrMFDGg09pM2EZHez32PZCbIFTIt7GsHDtraokXJaQj5Y9buWzb
         TJpg==
X-Forwarded-Encrypted: i=1; AJvYcCXPR5r6UcTxDlOqNrBqrVWn8Q7yy+ABY7ciqaLhSvQ+r+skSMqGU6YGDCThr0f87s4qkBHP5sMuNw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWOFk6oO9OWgMZVfTkQrrypEj0DqeT1S2O3dbIP3nDR+CQioPx
	xXxeGA/tzD6q303p8xG9PafRPGlSwT6Tp+bQsempbmoYsheT8JQhvIzCpqsmZUQY2lR3/0oVVTB
	TFhB+MIkcttl5XPxddUuLM8cVQUKqA8kGuk4G
X-Gm-Gg: ASbGncsL5B4i0iGrsYYBXFw+q4lwnLDXkK0RIwIYFce423g2NdktPec+AIyjD5LSemn
	dP3jc0V7osiavTPDW/UJEJI4zZb8o6nZ4T3mHylC2nNoTojho4CEixyeK/oZRBJt03T4co1hlRw
	JIzdvdvCjaAKYaJHaK/wIcydzEkwSa2T6D3QekUjg0JtgImF5BoDG8qM6V3AzgosU42ENbnyrhf
	hH6qvEVlpkMHC7ZXUsDGj6GkyC5DbtHNdxfRy9sVW03cuuCiiztcLMklsCW8s/tCVxFwr4BH2CX
	KiQX2yglagUvi02ZPED9DhDwleVYp6DPzKElVYylZtNyftuDNxZOuP55XUQvzA+CUzfvru9IhDe
	nF8APpqNN/HL2nmx6PxQAr3CVEKpOBDhbKep9/W2P2A==
X-Google-Smtp-Source: AGHT+IEt9ug7nEQAm2LDkRUFBItANDF870I5/sEI6n4aXjKv+4LBOhHOR3cOuk0Y23FkZAwlHH5prB4sCoTt
X-Received: by 2002:a17:902:f606:b0:29d:7e23:629 with SMTP id d9443c01a7336-29d7e2307e3mr42480665ad.0.1764888217329;
        Thu, 04 Dec 2025 14:43:37 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-29dae49cc11sm3869575ad.14.2025.12.04.14.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 14:43:37 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id D77613400EA;
	Thu,  4 Dec 2025 15:43:36 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id C6533E42318; Thu,  4 Dec 2025 15:43:36 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/kbuf: use READ_ONCE() for userspace-mapped memory
Date: Thu,  4 Dec 2025 15:43:31 -0700
Message-ID: <20251204224332.1181383-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The struct io_uring_buf elements in a buffer ring are in a memory region
accessible from userspace. A malicious/buggy userspace program could
therefore write to them at any time, so they should be accessed with
READ_ONCE() in the kernel. Commit 98b6fa62c84f ("io_uring/kbuf: always
use READ_ONCE() to read ring provided buffer lengths") already switched
the reads of the len field to READ_ONCE(). Do the same for bid and addr.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Cc: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/kbuf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 8a329556f8df..52b636d00a6b 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -42,11 +42,11 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 		buf_len = READ_ONCE(buf->len);
 		this_len = min_t(u32, len, buf_len);
 		buf_len -= this_len;
 		/* Stop looping for invalid buffer length of 0 */
 		if (buf_len || !this_len) {
-			buf->addr += this_len;
+			buf->addr = READ_ONCE(buf->addr) + this_len;
 			buf->len = buf_len;
 			return false;
 		}
 		buf->len = 0;
 		bl->head++;
@@ -196,13 +196,13 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	buf = io_ring_head_to_buf(br, head, bl->mask);
 	buf_len = READ_ONCE(buf->len);
 	if (*len == 0 || *len > buf_len)
 		*len = buf_len;
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
-	req->buf_index = buf->bid;
+	req->buf_index = READ_ONCE(buf->bid);
 	sel.buf_list = bl;
-	sel.addr = u64_to_user_ptr(buf->addr);
+	sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
 
 	if (io_should_commit(req, issue_flags)) {
 		io_kbuf_commit(req, sel.buf_list, *len, 1);
 		sel.buf_list = NULL;
 	}
@@ -278,11 +278,11 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 
 	/* set it to max, if not set, so we can use it unconditionally */
 	if (!arg->max_len)
 		arg->max_len = INT_MAX;
 
-	req->buf_index = buf->bid;
+	req->buf_index = READ_ONCE(buf->bid);
 	do {
 		u32 len = READ_ONCE(buf->len);
 
 		/* truncate end piece, if needed, for non partial buffers */
 		if (len > arg->max_len) {
@@ -293,11 +293,11 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 					break;
 				buf->len = len;
 			}
 		}
 
-		iov->iov_base = u64_to_user_ptr(buf->addr);
+		iov->iov_base = u64_to_user_ptr(READ_ONCE(buf->addr));
 		iov->iov_len = len;
 		iov++;
 
 		arg->out_len += len;
 		arg->max_len -= len;
-- 
2.45.2


