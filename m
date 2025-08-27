Return-Path: <io-uring+bounces-9305-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAAA0B3839B
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 15:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 357753B7756
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 13:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FBCD298CC7;
	Wed, 27 Aug 2025 13:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BCWDVHdn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B30307ACB
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 13:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756300800; cv=none; b=d5npCPp+7Eb7IyaLaBh0Pf995LW6Wdnw4xCnJT+6OrR15xPRWLkC1jy4yNjGvJyNCt+vFs8y/viZH68NyPiPe62IkNllK36WtYD5JxB1F28qYBuWQaybxw5ggQq1KP51va0zWL28tmCqHIv2mnwv23Dbz0yMthn10n16uXxVC5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756300800; c=relaxed/simple;
	bh=H5pdTud0VmB9Y+jm/aef20IBkxf8Sx3srSgP0dQ6hZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Utlbppgoj3Dgyu5602v4JojHaOVoBIGTZ/zmKCs/IMj8IGIU7sDqIt5tOFB/oHOulQbg1WJVdQN1C9m3cvr0R9xkIh/TpFB/2jZBoCjN+k4nnab6DmIneCT6IJE5SThgunptR+ogtGwE62ZZHwtneb4WR9CUMHcY9M8341eADME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BCWDVHdn; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45b5d49ae47so19941255e9.0
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 06:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756300797; x=1756905597; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xFIGcw5KkavrX0aj2qePxU+wG3hhn5RTfBkTDkg+cq4=;
        b=BCWDVHdnBmtCRlJkyjw3jMkhduVTiK3RPGMuLRMxOWhN6h08Cx6rdDIBwS0VgTZPx8
         evY6lJcn1Jq0cfL/nlPhPNJiSbsOsPxmCOvXTI7GOQnKJQoNaSkROEfSB58WEH3IowM8
         oWQUB+vW27ss/kwArWj5byJ7CdqQnVN34npr791lxbl3/qU2MzQe4Vl8nJVES+IHwoHQ
         SNHgzF0mks096NZLX+M71KRgWc1zQwioW5pZ5e5ufiQtAX9mxPRtGmyPPXJAZrQRIoRG
         XM+EFDwHTSAq3b5Nm0tSEz4e1LtMEaMOCwIao9j2R334gwd+RsK9HFC2jZBYe8uIWSGg
         edxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756300797; x=1756905597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xFIGcw5KkavrX0aj2qePxU+wG3hhn5RTfBkTDkg+cq4=;
        b=lguG4pOZniklZbB8fCoL+UuAJ28Sz+0211caKsr68hKi04iSTuTOTQuzWt3ykm/1Vt
         Jra9GLuqDGDc1uR0F55RNNxdrp892vgoffK3rWAdISnLnSZ7k7CA5n0KO7IG66S2bL+f
         yvXPanmN/ZdUjZtPmdcgTCfOBXGgj7o9M75sa5l+X6bDsu+LDsLam/5S2T+5EUoTJQnc
         9aiBWvGzCq8CAdyyZz12fAFYG19NfWPcnh8KLrBm/91BKSOtshmZmu1naVkMqkkhMcaa
         ofYXWujB52yV/pVmhixZastKHRbjqR3s0CTgyh2rU7EfHy6cxiUEIucqJueNI4/wjXOv
         1YDQ==
X-Gm-Message-State: AOJu0YzubGurNHwUz9ZAudZ58p3niFTrAaj4sE/IdZXrkgggmTAET0W+
	A+ch8GTm/e+Y14vA9NRMW3W9OmFYsyZ6M7xSkk1ZqlMPA598VM6Ae1L9g/+3dw==
X-Gm-Gg: ASbGncvXvvpy7DgwJRx46uF7WvYuXP0Oz9ZrgxRPkzjvgpkHmhnUlWM5LiE5LU7X5H3
	khb2UHqf/OUj+AOYJSWeYwOsc8G5NvshDEiWO7vYRu3gFfzA4lFC7WKupIfL3MOrmTwNBXB620l
	Aymk617PL8Xq1cVcSZxNCmIkZGDTVFlTzbcqUHJUwx8DVJXp/W3+WX5FPant17KXMBg/JM2ZN8s
	a7S/NnVYJcyVR++sqCMk60ZTxCPA8dXru7XLMWCIpnOa2ifl4XdAIpzQzMkzRoIIcclU51jl4rS
	FIoxpfz492eC1ZfR9lOkhO/kK6MWTify3yMimMJkklKcuBJCuF5Qn6XDAcZjjP67D8Iz8AhexYz
	wkD2R+w==
X-Google-Smtp-Source: AGHT+IGsNA+yf62akdySxlo9x1BHtTIlekbiBzDVwkr8RbzRjvd3AKGgXP6QOBpShOM3FJlYaxtjMg==
X-Received: by 2002:a05:600c:4692:b0:456:1514:5b04 with SMTP id 5b1f17b1804b1-45b517b9636mr159208045e9.21.1756300796663;
        Wed, 27 Aug 2025 06:19:56 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f306c93sm30170305e9.14.2025.08.27.06.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 06:19:55 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC v1 2/3] io_uring: add macro for features and valid setup flags
Date: Wed, 27 Aug 2025 14:21:13 +0100
Message-ID: <3d5f99d4aafbcc66fbd90cde77470f0fe1641291.1756300192.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756300192.git.asml.silence@gmail.com>
References: <cover.1756300192.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The next patch will need the mask for available features and setup
flags. Add a macro constants for them to io_uring.h.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 21 ++-------------------
 io_uring/io_uring.h | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ef69dd58734..8aac044cd53d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3808,15 +3808,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
-	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
-			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
-			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
-			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
-			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
-			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
-			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
-			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_MIN_TIMEOUT |
-			IORING_FEAT_RW_ATTR | IORING_FEAT_NO_IOWAIT;
+	p->features = IORING_FEATURES;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
@@ -3876,17 +3868,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			return -EINVAL;
 	}
 
-	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
-			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
-			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
-			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
-			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
-			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
-			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
-			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HYBRID_IOPOLL))
+	if (p.flags & ~IORING_VALID_SETUP_FLAGS)
 		return -EINVAL;
-
 	return io_uring_create(entries, &p, params);
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index abc6de227f74..37216d6eb102 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -18,6 +18,26 @@
 #include <trace/events/io_uring.h>
 #endif
 
+#define IORING_FEATURES (IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |\
+			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |\
+			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |\
+			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |\
+			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |\
+			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |\
+			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |\
+			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_MIN_TIMEOUT |\
+			IORING_FEAT_RW_ATTR | IORING_FEAT_NO_IOWAIT)
+
+#define IORING_VALID_SETUP_FLAGS (IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |\
+			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |\
+			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |\
+			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |\
+			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |\
+			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |\
+			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |\
+			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |\
+			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HYBRID_IOPOLL)
+
 enum {
 	IOU_COMPLETE		= 0,
 
-- 
2.49.0


