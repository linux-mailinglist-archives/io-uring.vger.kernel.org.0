Return-Path: <io-uring+bounces-10900-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D6ECC9D67F
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1F893349399
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC64621773F;
	Wed,  3 Dec 2025 00:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSlyreMM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E770221DB5
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722198; cv=none; b=tDH9tTuw9rQEl4QZBQ5nteCI0Mah0wgnS9ErN6qo8uptEYGciRKYIjsAnEuxy59/+E0YZ9ae436Xc/t7yedcOIhWoNw5yvdAQggK2i/bPjEQJUBKKnM855dqspc4ZhlpHKRxyoKoZKjDDGWp/zyOo4vE1W1+6dAS+7Vfh79B8xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722198; c=relaxed/simple;
	bh=95J19zdA0gFR5TQ9JtO/onNl+Rpz2nyDeix6qIuVJpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3fH8aJ7Lt9j4FHj2EH94j7m4wuHWE29JTR56UypVvSbthp/sbkQtS0EVnflftaXIDQodkydWi3Ya29Nubqy1/GQHay21CxSrQ6F+8k3RSCp1ZNw6jDOc0KGVQvyPNgyFFwFaTrjRY6maMe/1FVk8ae1O7jUEgSgCZukCGeJmKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mSlyreMM; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-29ba9249e9dso68310905ad.3
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722196; x=1765326996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J/LVHiRdfY144qEpuet9OcoP6m8LjFCEGntwPIjqRxY=;
        b=mSlyreMMWcf3Xlrsz5GBukX29icKW8/kFV/UeFtx7uASjbjE0lKohB+oMisnUD11be
         iAc66Ig6bRF47XYg7cq6YcuceYGS9iDQ0LLkqOLVD3Pn4wkCu/jxbjK4rY3E2Cgtc5dI
         djzxnPWP4iGCcFSkQ5TOdQXBlb6Xj+FiL1yiRBJCRmlehC1KyIzjHDuMxBGXo/NUC9FF
         xe7eKHhTjhV2xOD5/HVZdtZfxkPhn80c/SQyesx1LSSwFoWxlDY2pW+bXpTVyUveVGmK
         OHbHuKs6yQ+8iLPmBcx1GdTmwdxD6dBUii2AY+CfoetRiQ11ekDpFe5TplnV91F0QyHz
         FsUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722196; x=1765326996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J/LVHiRdfY144qEpuet9OcoP6m8LjFCEGntwPIjqRxY=;
        b=ZojKbSN+fe9NRLHUZ+89+91oYT4HoymeH5LCXjY5iuusY2lHEbJ0EQJzY/RmFplprC
         CODUeqyUx6/aM8jttFEpBiw8q/k7TuXM8AvLnt7cnQI+DLruuF1xE0ySHQMxl+CJ7o+U
         kZkQszVv1gAFz5IK8HvB++3rFzwsbtpFip4cA1pnhaZNxUa3BJLoa0J3EdJ2+gSU2AkX
         wq5YgKbq7C5330E8d+bcnNTWbttpFygEe1rPnpcjHp3Oxnvmbwb4AZbmXKcsKwnjJ9cT
         7bEDBK5rb+6rIboL8a7Wb9bfbxl5D/7qwieBg8qKaz20h+Lb2wmcfDYRWfjPpwlfdy9L
         f0FQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIgwV5WzfC3oF2kFD0REj8eBBMm8psvXaVNh+HB5EVgjMeqjQLvarbCdkqsRSjI2dwhlH22dp63g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWtXducCzqmOVVBcgwdSQFZCCmgRjK04FWdYp3Ql3zoQ7N0au+
	YyqoU8ZZMuXyE4of2JIMVGMXcGno6RCpkTNfXskv1J/WDDVh0wteYBf2
X-Gm-Gg: ASbGncsF62rsJxEKcEu01JJzgNZVxUV+af3D3ZVnz8Wiha903d5dBRPjj9MOlCmT8YN
	FMQKEVuBTM7uWYxplIaqujoFfsxcXeNIHT4YknuNFnyDE2iziVJNWQ1YARC3m/DkzB1sbmOSW6V
	GxncxSJNANVWpLMLa67xgktVtFPz1kzczlEfVnvuVvbHKQkoIG4+7+CUHgxtdZ/S+QLiuH9nUxI
	w9EIln+kukxfxTaRmRZJ4tarM1fbMU8K8WlRB5qdR57hCN80USp9J+uGakiUxf0MM0SPhNHxZdQ
	sicZ6rwTYzK7TkMPTVv8DAq99zf8n8h1QdKAyrNLt5PQCV0Ssz+rf7HiTdySsRQtGbUgHKXDrQR
	w3gNP3eplnIvL/CTzvydg+9KUxtZBl3Lx3uQUbHQSGs9PvP/WIA8LIXtQLnKC+mvHfSAEOeLIAF
	bRxVdNfa8tryoxriq3wQ==
X-Google-Smtp-Source: AGHT+IE+zujOuCxHYlrac2mQToPfmTEH/033p3LJotHccaXCVNMYsUR3N2EIIFaCxfgWhFH/eiptSQ==
X-Received: by 2002:a17:902:cf4e:b0:295:560a:e474 with SMTP id d9443c01a7336-29d68400fabmr3500845ad.32.1764722196397;
        Tue, 02 Dec 2025 16:36:36 -0800 (PST)
Received: from localhost ([2a03:2880:ff:54::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce40a5ffsm168764905ad.18.2025.12.02.16.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:36 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 05/30] io_uring/kbuf: support kernel-managed buffer rings in buffer selection
Date: Tue,  2 Dec 2025 16:35:00 -0800
Message-ID: <20251203003526.2889477-6-joannelkoong@gmail.com>
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

Allow kernel-managed buffers to be selected. This requires modifying the
io_br_sel struct to separate the fields for address and val, since a
kernel address cannot be distinguished from a negative val when error
checking.

Auto-commit any selected kernel-managed buffer.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring_types.h |  8 ++++----
 io_uring/kbuf.c                | 16 ++++++++++++----
 2 files changed, 16 insertions(+), 8 deletions(-)

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
index 619bba43dda3..00ab17a034b5 100644
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
@@ -200,9 +205,12 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_index = buf->bid;
 	sel.buf_list = bl;
-	sel.addr = u64_to_user_ptr(buf->addr);
+	if (bl->flags & IOBL_KERNEL_MANAGED)
+		sel.kaddr = (void *)buf->addr;
+	else
+		sel.addr = u64_to_user_ptr(buf->addr);
 
-	if (io_should_commit(req, issue_flags)) {
+	if (io_should_commit(req, bl, issue_flags)) {
 		io_kbuf_commit(req, sel.buf_list, *len, 1);
 		sel.buf_list = NULL;
 	}
-- 
2.47.3


