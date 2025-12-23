Return-Path: <io-uring+bounces-11256-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C4322CD7803
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:37:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 95C4E302EA26
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EE0920DD75;
	Tue, 23 Dec 2025 00:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iOE02wlY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D36205E25
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450195; cv=none; b=KwZ6XN7w7xsaincDV3KYDUR/8Vk3vVfd8SbvIwWtvkujoCpca5Tlre3++2PG0Y+71kyMkWR7kEgRQm4vCVOWDXjmvsG7ExL7sGwpeVNZlFscDEt4/ZPMuyOwV8Ux/ert9t+OSJw1XMpVwiAFg8+VrSDfHWFMJBFcaqF64/F+u2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450195; c=relaxed/simple;
	bh=AGXy415mglRhicrXFs4D990sYRrSFJ4XFWWVaF9HToY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVITFAFAhMucsD7wxrX9BUNbHk+AF77ZlkIZ9z6N+x/GfrhGVS2T0zpIeaXXKvF9H0BfDxeJt7j4VJyZdNRUyqa59nPN3xde9hTHqswAFg3v2Sq2+Vy9x418SQDJehpLFmD1KAMqpxjt4FO8sZz9u2lC/5k73YaEmuNfW23Aljg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iOE02wlY; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7f651586be1so2060238b3a.1
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450193; x=1767054993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zJPtGsBDIN/oNHzNofS3ETHdQP92YfTTdzZt1yyrgZ0=;
        b=iOE02wlY/f80BFyhRFcJ7V0QPfz49LXY8Sd8HCg/C0aFeRF5S2On7EpWhcFpcRCEJQ
         b2e/jg87w29TK/ZO2Ecmbmtx4cMhIO8a4J+QTj0uMcRdQapXcrSDKWenL1gT+x7BCREi
         3aKkkfthT9XXkjqbFy2vw1/3KKV0as8tuj21ckDAyVt01+QhjOCDlFHlPamGPLWJUmH8
         OC4jVaI0PSg9XPhTTHIElcCqmCIFaH3o/ro0k1A/3Nv6Lspc7K2MPoiOjTVsDR1NjjKf
         5GSpJnJQRlqe4V7epK6qA+4kCHSfPiZZbk8igt8uUzpjxiJNJxCyyT6DFhScHcympQCK
         hioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450193; x=1767054993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zJPtGsBDIN/oNHzNofS3ETHdQP92YfTTdzZt1yyrgZ0=;
        b=OJOPe6PjeVlgGuYiHBwD6Qf006BsCNbZZCwUw6JAZ2F7JSfFaQ7hBYHKiA1NbBKQUC
         vZjVPYg+aprj7ASCVk1iIIzGqfd+Xisj2f9JvS6uajs6107f68nxhvztwdyYjRm+Ccsu
         tuClEGy5OfPV+zI7YkKNaKC6Rn/oDib8XY/jjtZHdtV/rfdu6FQAR6MqL/e/kZ2qocSn
         dKUvqoNE81BEIcqr7bawQxzOTUOva9JWAyGVWz1/wjaSBCK2h6bctLj1Q2cQ+JVqhEro
         wClWk+rToEDXVgZC61r6O3MEe+/VSA+zz4AdcvCp/efjDWOCAg7X9T1t0YH7n9tW7szj
         yYRA==
X-Forwarded-Encrypted: i=1; AJvYcCVFYcpIO2QcPyQXmMoKuznp4+Y9yOgqKnq4FNjQtEkOkrrJrASisP4SFGGFBPfpXxORDtssT04QiA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeDdgptizwJdycst/JeUS4EcOlMZ+vAfrmmO/fcjo4M/B8fwZP
	akdEGxTYKCE0NSpWX0AYeeWFABkioANolFsQUDlXbdGhwc811zBA7c9f
X-Gm-Gg: AY/fxX5PuGw9mtSvFZdFqG8sgRS5PqI9Q9NEewn2Hin1YuQaGG+2Wb2/KX1D+dr2rdL
	Os/Bw78uC2aAKE6BU217BmSE9phj0BR7GUT57hzVwcturTzq1A89xiNOYQy7b97zbcYc+rs5pv0
	+6uoZMXWwKo67KD5zfQ9+T9N1fjcl8mv/z59YRyNq7cV24Wjk8yLIsmSwG5SoV39v4LNfBwL+fJ
	SODBRwXvhs+FWXUmIYSBGX7b43AwQgwre9AxLfdZPBaT7tGT4nQ2B60NQBR33u1WD0Ot2IGTokW
	bP4qGO3k/cUWStU0FBv4Jq5h6IYNEfJrDUl+rJ/ZyTXzbWJAs6Ssghmj/lhWdi9APjhdY/01PyU
	fkd4tWNcHUreYnZT48M+LkpXFff3oY8uI3mXB6XRQBxa2eIMIKgy/KnZF11CwrkZrLz9W3aSFcS
	qtw4HVOjPJCnjmVYwaFw==
X-Google-Smtp-Source: AGHT+IFSWF/+pZwJ8Or78PAT5/Ws9/B3l4ukDuEE2AokJzuO+eJCnLy7bAvuSvhWAfCLDbzfxiH+dw==
X-Received: by 2002:a05:6a00:3bca:b0:783:44b9:cbc9 with SMTP id d2e1a72fcca58-7fe0bd134d0mr11762174b3a.9.1766450193224;
        Mon, 22 Dec 2025 16:36:33 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5f::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e0a0595sm11554677b3a.44.2025.12.22.16.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:32 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 05/25] io_uring/kbuf: support kernel-managed buffer rings in buffer selection
Date: Mon, 22 Dec 2025 16:35:02 -0800
Message-ID: <20251223003522.3055912-6-joannelkoong@gmail.com>
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

Allow kernel-managed buffers to be selected. This requires modifying the
io_br_sel struct to separate the fields for address and val, since a
kernel address cannot be distinguished from a negative val when error
checking.

Auto-commit any selected kernel-managed buffer.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring_types.h |  8 ++++----
 io_uring/kbuf.c                | 15 ++++++++++++---
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e1adb0d20a0a..36fac08db636 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -93,13 +93,13 @@ struct io_mapped_region {
  */
 struct io_br_sel {
 	struct io_buffer_list *buf_list;
-	/*
-	 * Some selection parts return the user address, others return an error.
-	 */
 	union {
+		/* for classic/ring provided buffers */
 		void __user *addr;
-		ssize_t val;
+		/* for kernel-managed buffers */
+		void *kaddr;
 	};
+	ssize_t val;
 };
 
 
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 68469efe5552..8f63924bc9f7 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -155,7 +155,8 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 	return 1;
 }
 
-static bool io_should_commit(struct io_kiocb *req, unsigned int issue_flags)
+static bool io_should_commit(struct io_kiocb *req, struct io_buffer_list *bl,
+			     unsigned int issue_flags)
 {
 	/*
 	* If we came in unlocked, we have no choice but to consume the
@@ -170,7 +171,11 @@ static bool io_should_commit(struct io_kiocb *req, unsigned int issue_flags)
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		return true;
 
-	/* uring_cmd commits kbuf upfront, no need to auto-commit */
+	/* kernel-managed buffers are auto-committed */
+	if (bl->flags & IOBL_KERNEL_MANAGED)
+		return true;
+
+	/* multishot uring_cmd commits kbuf upfront, no need to auto-commit */
 	if (!io_file_can_poll(req) && req->opcode != IORING_OP_URING_CMD)
 		return true;
 	return false;
@@ -201,8 +206,12 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->buf_index = READ_ONCE(buf->bid);
 	sel.buf_list = bl;
 	sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
+	if (bl->flags & IOBL_KERNEL_MANAGED)
+		sel.kaddr = (void *)(uintptr_t)buf->addr;
+	else
+		sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
 
-	if (io_should_commit(req, issue_flags)) {
+	if (io_should_commit(req, bl, issue_flags)) {
 		io_kbuf_commit(req, sel.buf_list, *len, 1);
 		sel.buf_list = NULL;
 	}
-- 
2.47.3


