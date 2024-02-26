Return-Path: <io-uring+bounces-759-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C62C48680EE
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:25:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 771F628BE77
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 19:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D1C51292FF;
	Mon, 26 Feb 2024 19:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CuNcvDXC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EB112FF76
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 19:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975514; cv=none; b=UV9MUPJ20gNun5xQkIVDlDob3r6T0IiSZ+pks+pxR8n62G0V6howR6K3ozOy5OCjOrq7665EGbQnfWR5byIc+P6wXU5rR2CdFYXBC0fRpmOnJquldVK1rTJKuNx+fgVdvODdVgsu4akym4V68L54UwlT8HnpBIFyeeXOsSDJcdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975514; c=relaxed/simple;
	bh=Bwz1XCGG8sAa4hB/q27XYGr3ZK5UY47pzg7bfBwJ80o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oo2OaV+oJq0dWHVDNQzmQmlGNts7TSbL8oXQE08sq9Nde45ze/KPzeR+EM8esEI9mAjaGe1VYSXEseRpuLKwINA555luMMcaJURWrOdgPk+VnOzBqTWrwkq+RCarg8ReDuIhhgfWEUsjToc3CP36x3K7MSIztYim9fINJo1Kh44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CuNcvDXC; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7c495be1924so52266539f.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 11:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708975511; x=1709580311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qke7VBOcxahFVWc17Wbuzh6Bf+gTJGXU/ImftE7zCJs=;
        b=CuNcvDXCKi6YDJ7fWyVLJnD/YPoZjsatLC5o3g/tu2c/BQh7z7NUrvCpj3UkIGF5Ey
         2tpGWM9DtmCZKD5BKtHxu1PYI2AFKj4jOfT+8rRfOYgTWa9GNm6x/4XPLfpjXTUJL+2B
         0Dio8H5cmCVbvKv9dYpjCLv4pQwXoi9U8dZBa2cvcbETfqQowdS69Wo5GjODJtueokYa
         MZA7FM/NMhj/6iM1N+3qIA/QnB5HoPjHWd3407zqKN1/yxjv/hG2NMexfY/CN3V2NEjt
         bCfsxWzxzJr67oddBvY26rPUB4/sigr5Ns/kZbO6XVvkX4O0EWw63NW0xTp9+iBCFMta
         HH4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708975511; x=1709580311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qke7VBOcxahFVWc17Wbuzh6Bf+gTJGXU/ImftE7zCJs=;
        b=WbHlSSeymdfQL/yK/Jd/u+Z5Xo7FpgDTfIDXAQ7JXnY5hzMqlcHZsMpdh6otObzOsK
         HU8Prt7ZlKz2skeyuUYesXGFy8H1HhpkyXlTxUT9bIopiMuodPSrlvYxuiP+Jr+FX/j+
         FbCAAflITo7whSWyodZcC02JEGfbl0uDsarm5rGNghWKcMLx1qAzOfuwd2bYgpCGPJKO
         MrjfRnj/OlSG1B3lo4xU2xIYkUJDLzhcgAODwWETGJWekLe3EoZ34VAURYLeVNBWiTgE
         0LeYYNaafrucQviPU17B1uc5uTkMB3l1FDIhCjXiIY9wdCYOKfzU6FQ+5VufCNQq8a5y
         We3w==
X-Gm-Message-State: AOJu0Yy0ptdkZsUSgkS16Tmbl5gSSOeJ+ZhVoo2DChouAL94Z9iL/4Gz
	aehp7oyGVZXWICvNsPC3Cipk2ed1eNTI81FrhsVxqgU5hIP3KtjA6wH+Uf4tnjb7BMiY/Nbzj/9
	Q
X-Google-Smtp-Source: AGHT+IGnWeMxC92Q2Q7Ud/prQ8XL43ODqu5UF/85S7l3lE/fZbIzShkZyoWNZQOcDUDY/sMe+DkimA==
X-Received: by 2002:a05:6602:38d:b0:7c7:8933:2fec with SMTP id f13-20020a056602038d00b007c789332fecmr7386660iov.2.1708975511642;
        Mon, 26 Feb 2024 11:25:11 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id eh3-20020a056638298300b0047466fd3b1dsm1370484jab.22.2024.02.26.11.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 11:25:09 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/9] io_uring/kbuf: flag request if buffer pool is empty after buffer pick
Date: Mon, 26 Feb 2024 12:21:16 -0700
Message-ID: <20240226192458.396832-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240226192458.396832-1-axboe@kernel.dk>
References: <20240226192458.396832-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Normally we do an extra roundtrip for retries even if the buffer pool has
depleted, as we don't check that upfront. Rather than add this check, have
the buffer selection methods mark the request with REQ_F_BL_EMPTY if the
used buffer group is out of buffers after this selection. This is very
cheap to do once we're all the way inside there anyway, and it gives the
caller a chance to make better decisions on how to proceed.

For example, recv/recvmsg multishot could check this flag when it
decides whether to keep receiving or not.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/kbuf.c                | 10 ++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index bd7071aeec5d..d8111d64812b 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -480,6 +480,7 @@ enum {
 	REQ_F_POLL_NO_LAZY_BIT,
 	REQ_F_CANCEL_SEQ_BIT,
 	REQ_F_CAN_POLL_BIT,
+	REQ_F_BL_EMPTY_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -556,6 +557,8 @@ enum {
 	REQ_F_CANCEL_SEQ	= IO_REQ_FLAG(REQ_F_CANCEL_SEQ_BIT),
 	/* file is pollable */
 	REQ_F_CAN_POLL		= IO_REQ_FLAG(REQ_F_CAN_POLL_BIT),
+	/* buffer list was empty after selection of buffer */
+	REQ_F_BL_EMPTY		= IO_REQ_FLAG(REQ_F_BL_EMPTY_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index ee866d646997..3d257ed9031b 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -139,6 +139,8 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 		list_del(&kbuf->list);
 		if (*len == 0 || *len > kbuf->len)
 			*len = kbuf->len;
+		if (list_empty(&bl->buf_list))
+			req->flags |= REQ_F_BL_EMPTY;
 		req->flags |= REQ_F_BUFFER_SELECTED;
 		req->kbuf = kbuf;
 		req->buf_index = kbuf->bid;
@@ -152,12 +154,16 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 					  unsigned int issue_flags)
 {
 	struct io_uring_buf_ring *br = bl->buf_ring;
+	__u16 tail, head = bl->head;
 	struct io_uring_buf *buf;
-	__u16 head = bl->head;
 
-	if (unlikely(smp_load_acquire(&br->tail) == head))
+	tail = smp_load_acquire(&br->tail);
+	if (unlikely(tail == head))
 		return NULL;
 
+	if (head + 1 == tail)
+		req->flags |= REQ_F_BL_EMPTY;
+
 	head &= bl->mask;
 	/* mmaped buffers are always contig */
 	if (bl->is_mmap || head < IO_BUFFER_LIST_BUF_PER_PAGE) {
-- 
2.43.0


