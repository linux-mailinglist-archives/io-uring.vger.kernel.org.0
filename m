Return-Path: <io-uring+bounces-4742-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CDB359CFA77
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 23:55:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AFF2B2E2AE
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 22:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EB0018FC85;
	Fri, 15 Nov 2024 21:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UgXQRsY0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8575C1FDF92
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 21:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731706397; cv=none; b=a1zVK+sbPt8E9XK1NvDLd5uFgscaV8F6ySz+d8NnHYtLaQNUGBQSJqZJ5oY5mY74CFV6UqcJy7CuWsqs84fHGgL5XqJuOrUSSOVVXvplSNHedtRoabctUBDyd9xa2uFC6qCCmcwdoahDqywhpXxUYvbvG9itUvRrkmXC2O8LDvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731706397; c=relaxed/simple;
	bh=xYZHUvywzGJloDPhoEEV20mT5d5lF6lAtamijUkqOOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miF/ThkySEcgfMrQ2HJKM6IvJjjflOvILaCbtPmSQp2TxBXhbM137ovMFhmokpHtsE4GZadoH+epdvlpbk2BVxIiesi120lsSzZgPNJddTQC7kwPexXxd6Y6WF53xYvY+TjGNcQ8uBvZZX3hSqj3eZcvn5fFUlTF5phwrrNJKQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UgXQRsY0; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4315e62afe0so19535475e9.1
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 13:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731706393; x=1732311193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xQBi1iIuoh3NbsC5pbTwBoqOZ+wl3kG8MmjMdEdWtac=;
        b=UgXQRsY0Tw6GJ0lm3pxH0t/Y2KHekhX8huR7abRxbymFVN3d2sIyl2MS4pKAVKKUut
         0fZnEvjAnaSrxDNZGB8HJnfRAtLAK0BK5hk2Qe2u+KPXJ1VUVEC5xw0Q1G3C+sgEPj5j
         culoDwbsquhFgyuHIVVOhMPD41DLLJEmpqKCFrp9La9xuhwv6/ztrpR7q8Aqx1yvZezH
         QEJfuUHbZuTU81ADe/D8ehmNF8jAn5YLXczw/a4O3a/IYg5f1yosHgBxTgaKXt0QAClo
         BIUWEzlISsYng5cMRIvOswqGhzxuugSZBSV6e6cQ3cCTaqU7KtTZrV8P/Ap6IG3ts7Nu
         CZyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731706393; x=1732311193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xQBi1iIuoh3NbsC5pbTwBoqOZ+wl3kG8MmjMdEdWtac=;
        b=XGXLEo9MedqNT5a1nQx73Tvw0F21lHmGLAf3NbiiS8v8rJyiR6Hglu+G0F486qsvoz
         mUn1zUE6hk6Dw1QOToAuGbhA71S6kt4n+q990IoaA8+a66qNKqNPd9jVZTvwsILpSVXW
         op7bYjsWd0oGayfTLIRrhtVQwMl7wCbwKFj5Fm9C2eNCasgq1o3ra/oOSJo6jTSAqPXy
         Hb4TPpLvnedo9ir3p68gM8CZc41K6RpNwSUxJYSViM3+n58VsCPC0Fbq58ioVoM0lTHQ
         RdLq1yJ/ssygXWolr8sOYZqjqcr0ahywbvs5hTkWePwB9L2CihZ3tXtVz40EBtbJxB/w
         RqUg==
X-Gm-Message-State: AOJu0YySj7rvlbQfJxTWe3DhyS99YiRyPgEXmF35VstPPERW0Ac9nbnc
	t614+J4dyGTyX3SvL1vnVLrwuNV5DsyaKDe4eGe+6xNaK2A4jsOatuy4VA==
X-Google-Smtp-Source: AGHT+IH+P+Af+6i0o/SKPip46fTFOx42P56MmNZ9z6W2VBEGytZsGoUO9X0CP+4VfgsP+WiVgIU4kA==
X-Received: by 2002:a5d:64c8:0:b0:382:2ba9:9d65 with SMTP id ffacd0b85a97d-3822ba9a39cmr1934094f8f.31.1731706392881;
        Fri, 15 Nov 2024 13:33:12 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382247849b0sm3397258f8f.97.2024.11.15.13.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 13:33:12 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 2/8] Update io_uring.h
Date: Fri, 15 Nov 2024 21:33:49 +0000
Message-ID: <7f84430397941168cd4237590cad20578236184b.1731705935.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731705935.git.asml.silence@gmail.com>
References: <cover.1731705935.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the wait register opcode and add region registration
bits.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 20bc570..b2adc3f 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -615,7 +615,7 @@ enum io_uring_register_op {
 
 	IORING_REGISTER_RESIZE_RINGS		= 33,
 
-	IORING_REGISTER_CQWAIT_REG		= 34,
+	IORING_REGISTER_MEM_REGION		= 34,
 
 	/* this goes last */
 	IORING_REGISTER_LAST,
@@ -637,6 +637,31 @@ struct io_uring_files_update {
 	__aligned_u64 /* __s32 * */ fds;
 };
 
+enum {
+	/* initialise with user provided memory pointed by user_addr */
+	IORING_MEM_REGION_TYPE_USER		= 1,
+};
+
+struct io_uring_region_desc {
+	__u64 user_addr;
+	__u64 size;
+	__u32 flags;
+	__u32 id;
+	__u64 mmap_offset;
+	__u64 __resv[4];
+};
+
+enum {
+	/* expose the region as registered wait arguments */
+	IORING_MEM_REGION_REG_WAIT_ARG		= 1,
+};
+
+struct io_uring_mem_region_reg {
+	__u64 region_uptr; /* struct io_uring_region_desc * */
+	__u64 flags;
+	__u64 __resv[2];
+};
+
 /*
  * Register a fully sparse file space, rather than pass in an array of all
  * -1 file descriptors.
-- 
2.46.0


