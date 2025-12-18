Return-Path: <io-uring+bounces-11190-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A82CCCAF6B
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:42:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5E73D30B947A
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D4353328E0;
	Thu, 18 Dec 2025 08:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KWqUwnsF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0372E285C
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046892; cv=none; b=KCueNwPZr8AHs1NzREM5Tif4wVw4ZBph7I2vrNJjuFBpsM7IdjZsPL5WLea6bJ0pyMK4UgB1r5msa17UwfFwbUilE6Kar440KZQ4lVvWr7et/ZONfW+MzYyILT1LsKyct+4LSwl/SdYXqmBUWynpjaV3vtVF8+ADKYFx6VLEUyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046892; c=relaxed/simple;
	bh=DCNKP3+49vhsf4cR8h81Amd4timhDqQ6YrmPdGVutew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RShCux+nQMK8MKz80Xb7bLiqRAlM8dwoQy/N6aHDqzFTVAmk/KCIo983lvj5Hbx2mLXVkal7TmB+bA+AZlScEIZ9CGhLXLCthS40qY0LInQI8xH4S0oloMilACnZSKRNkAq+0P+XWYIQCQY+FqH8xLdWTfCMifJiwpa0YXtxVTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KWqUwnsF; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7fc0c1d45a4so415902b3a.0
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046890; x=1766651690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eKprIPw7Nh5cga4NDcCgZlBnpUXee2i1WiaSjB0Z+Io=;
        b=KWqUwnsF2yn/EWrBIRam4taQP0nea95NeG0UgMEweU1MPRrO3wZL8E6Qckme2tV5al
         LUCBR2XYLUQcb0NznW/B7C2Beauw5avDtbqOuSOyPGuH9hSpPwKh6a5/RrRkKLZi5ll0
         bR8uEehr7W3BsA8YlO8hjeyb41fhrJbbJGuQ1EAM5u+ZACB8M6R2r0lOuXP7e/ExLjum
         rEGDxwqB83ka4j3neo9xCN0gPhxzddwg225r9jRBtUQTf7HcXSpfIidSpU18dwlEuou/
         1jDFItn6xB3X0Jm8HshX5NmfO2T6G1G2vUnrC9B7R6vkN14uVDdFaarcKgHWZd3Krr5I
         fGIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046890; x=1766651690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eKprIPw7Nh5cga4NDcCgZlBnpUXee2i1WiaSjB0Z+Io=;
        b=l+HBCNDqW/dok9p3AAHTiE8vh+hKOBeTHs0Da6jgam/ce7BZBDFgoDHRcUUK1RXOHZ
         6jQJ+mBkkTaI47aKETfLZWBki49sFLYgv/Km+NJHlCQ2/3KVEuCpIE1W/4si4KWOwVcW
         mOAYL401R1EJlrPsGt4hC+zLe8aZLqT/EgWvqrYPs5dhFxS3dyWUIGH0DTTqQiHg3oVJ
         ZbwDG8gkVd8yah94+T+AmDmefb2pVeLVh1iY1iXmlxEORON0zBxyRcCkrvC60jgXdfvB
         xpKqI6EBwNsLj6UaLG1Wa5sVuzifOlBHwZLDCmmiLfv2F7mxPGDUp34sEySspTIbTdM/
         CLZw==
X-Forwarded-Encrypted: i=1; AJvYcCXk3U03AUFjd8uW3zDZmbjcc/Bi+pUNYorqS7ZjHvnvkHvGImqTOLaLipLW+pCQCI34U9ZDITJ05Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywa59rOUUmtN3N1ok1IEIP/+qWfANgZd2ac2elQA7q1Eloe2u4x
	IESvRV+4iWUtYpZ8QelEEjJGkw56v8QWLTioEGT35szFWSmcxQaHPuPo
X-Gm-Gg: AY/fxX4MzdEEmKInEX6Q8fJ7Kz4z86+yzNs7Ad/+bqGfAMWvlXQUvYMtjR4PME/RNAF
	HSzoT8HoqeZypPVBhNlIJ6veXr/vqW8N27+UBkeUuo6e6XCLX1RhMANZ4UHhJEUdmfSEsJSdcN+
	mtZCiPWJS7kf7DV6ggbJptKzIxqIeYZsGTfetL3bgkTzQSl2CWu5j2fW64dyC2VCUuE6onyIjdJ
	oXOdPyH4h2ebfYW8XrwrN5EVPZEIjBOQZGUexaFFveaYaY958ni2gnkETWXcNOI9HE54D9DoPNy
	TP/zfMi5QQmnmX4sHmeopVEQoXCiSqd7dvVh1BKn86zY7D7aEopoCzE0I3LJhchig9JorD4brrz
	KukVGMnig4m0U5T/HiCnzdQNYjAwqocCrFFHivY2MzLrOOMQikfqfemAPctdRcS0UIan0iolPbK
	BcquQVRn5quy3jxPCJ2w==
X-Google-Smtp-Source: AGHT+IHte06w8cL1HeOcpUCOZlyCXvbS/uuDeFFFjpbIG+jyu3TxHkiTYZ/vWxynMjKc7Fc8r0nbSQ==
X-Received: by 2002:a05:6a20:728b:b0:364:14f3:22a7 with SMTP id adf61e73a8af0-369b6ab05aemr20561282637.42.1766046890234;
        Thu, 18 Dec 2025 00:34:50 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4b::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1d301e592csm1595484a12.28.2025.12.18.00.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:34:50 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 10/25] io_uring/kbuf: export io_ring_buffer_select()
Date: Thu, 18 Dec 2025 00:33:04 -0800
Message-ID: <20251218083319.3485503-11-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Export io_ring_buffer_select() so that it may be used by callers who
pass in a pinned bufring without needing to grab the io_uring mutex.

This is a preparatory patch that will be needed by fuse io-uring, which
will need to select a buffer from a kernel-managed bufring while the
uring mutex may already be held by in-progress commits, and may need to
select a buffer in atomic contexts.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/buf.h | 25 +++++++++++++++++++++++++
 io_uring/kbuf.c              |  8 +++++---
 2 files changed, 30 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/io_uring/buf.h

diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/buf.h
new file mode 100644
index 000000000000..3f7426ced3eb
--- /dev/null
+++ b/include/linux/io_uring/buf.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_IO_URING_BUF_H
+#define _LINUX_IO_URING_BUF_H
+
+#include <linux/io_uring_types.h>
+
+#if defined(CONFIG_IO_URING)
+struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
+				       struct io_buffer_list *bl,
+				       unsigned int issue_flags);
+#else
+static inline struct io_br_sel io_ring_buffer_select(struct io_kiocb *req,
+						     size_t *len,
+						     struct io_buffer_list *bl,
+						     unsigned int issue_flags)
+{
+	struct io_br_sel sel = {
+		.val = -EOPNOTSUPP,
+	};
+
+	return sel;
+}
+#endif /* CONFIG_IO_URING */
+
+#endif /* _LINUX_IO_URING_BUF_H */
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index b16f6a6aa872..3b1f6296f581 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -9,6 +9,7 @@
 #include <linux/poll.h>
 #include <linux/vmalloc.h>
 #include <linux/io_uring.h>
+#include <linux/io_uring/buf.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -223,9 +224,9 @@ static bool io_should_commit(struct io_kiocb *req, struct io_buffer_list *bl,
 	return false;
 }
 
-static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
-					      struct io_buffer_list *bl,
-					      unsigned int issue_flags)
+struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
+				       struct io_buffer_list *bl,
+				       unsigned int issue_flags)
 {
 	struct io_uring_buf_ring *br = bl->buf_ring;
 	__u16 tail, head = bl->head;
@@ -259,6 +260,7 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	}
 	return sel;
 }
+EXPORT_SYMBOL_GPL(io_ring_buffer_select);
 
 struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 				  unsigned buf_group, unsigned int issue_flags)
-- 
2.47.3


