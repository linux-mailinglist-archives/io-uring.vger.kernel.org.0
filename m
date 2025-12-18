Return-Path: <io-uring+bounces-11192-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E737CCAF74
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:42:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF42230F164A
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A8C3328FB;
	Thu, 18 Dec 2025 08:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dv6p/5uP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651873328F0
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046895; cv=none; b=dBIfzr3bd/ShjY1s/N0sFdk9vFxDXHwvc6OcBwxpvJr+FXLoB0qx1MbfMP+kEMAAsnQ06cbNn6lHVlGtz0JXRZFExs8t5f8SvznnvnvaNwuEyt468lCl7kMCNeUehQCqhizgL1r+/GrXUAKKH1R+WPF/6R3Tn+Q1uB6C+QAem84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046895; c=relaxed/simple;
	bh=aKLejG38uvIOlTozL6KpMQyVF5B+JfW8946A+LiVe7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUmcJ9uDd5tvhIR9rKrNcj6K5mYVMFIq73GJ3whEiJ0N6MQnY7wdIyVjjzUKOumDMJCyGhrCAIgWpwHs+CEg+cAJ3io3ZqPq2P5YeqpNRMM0a/Ou17Rb0GwP5+SftvtFiqeVoi/OTalUWP12FuA8WjXqXZEbUAKpkAgkQCEMiiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dv6p/5uP; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0d52768ccso5083355ad.1
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046894; x=1766651694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kh5ZVXmsBZcQ3OrKebkx1eIN+Pz6xPHYh4mwcIs+LIA=;
        b=dv6p/5uPCPeQ9U0lx9Ed+FqZyglbyblr+T1OdUQHcaqdpfqqVfsK1UuFZSXLAYznLh
         nITf/ZOjcqz8ih4R8fCtWXNnP0EZVP/7lHMPiJhlYWYkVEZqO+H0AKxRqRDqjJjiPeZO
         kJHfYO6FOH3XxzAqEaXabQ6st+NR3OoUalRoVPAmv4Rww4unBoiK7rsxecZ09VNBDXwm
         Tlg6UaldeHOmkjchaJlehJZHwbjrnmoWt1FPhFhoFF1THUi9epXV5VhYiRelAH2yJ33j
         2NtaTJD2nvWReqRYVJ3+ywTZrciAKNvdxB6ybuE9VesowVga/Bnd9VmP2UvWCn3y5EaN
         Xorw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046894; x=1766651694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kh5ZVXmsBZcQ3OrKebkx1eIN+Pz6xPHYh4mwcIs+LIA=;
        b=u4jph0CcojqNYA3ZzzIrxOoNKqSkWsngeLwlKLQmr6+L5cUyN+t1UltxumPV9eCzeJ
         P6tVz2tgv1bwYC5Opb+esJSeEOVfjMR+tLPlFEywI7IZ1XfM3sch+1yz4LcR+klP8C47
         1rILWRAs1xaEExQKSHapjG36ShD8jI7WwaO5TWzGpfLQs0Ofd59slIvLZwhyi0+D2jp5
         G8SLr6HK+/iZH3XIEVJq40HxWFwhxWWaUln/fhkdktiUWhVb8dq2dfMM8HPzZq3K03gz
         kYBcEcr9JyNcDsld/KTRZVMbJW55JKVrAGoJHLh/JrJFzO0A0wz5x0HX/GQLEt6o1Qfj
         OHTg==
X-Forwarded-Encrypted: i=1; AJvYcCXihsAFBTkyPF8Awc/9uGN4xdIksonP5p/AP6n26ylgkTwovxMmXF3QYz291ShL4JSeF7OufME2cg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxGh2O1aFBNTi71+Ecgi64/l7H52NY9OZe51mvEf63D290womoh
	IGhut4ewQTYy65P2Bso4mhNdrIugVz+/C3Pvo6RKwqzlxDLw35zu/GWlYKqemI5nJWE=
X-Gm-Gg: AY/fxX6NDIb+7MFxTe59tDZkjdakSd5D3FhufdOE4u/IYCu0l2G5dHYqXr173opvtLE
	Tj7Hhi3BZiHsuMUGyy0icaVgoZUGHvk8NBkSyXIeqPLKpC3RVdvaGX7KK13NiTJZetczngqCEaW
	j5G7kDthoHp7Iw94RGq7Low4Xm/gV/6rJszqNeHi9RWMe16FqcxVZ9sNcVG7jwSRVGakqqsAltX
	XXd4dafxZ4xfrvCj9/4mtvWGo9krE3VEa1z2K08HWlHg7zP1N7gOt+so6b8pGKWOJWxy3iSldrX
	xAVeInqOBSFgvZ0tUxyp81p8dKzgLM9VuYa4evNyKqyD/+ZX0fI3VSf6PkLgSm7fWp0WwoO3qJg
	wJPxZJDQU7msiT2gEDRF4vQtOIOCFjbDxcvfk8xSRQVCxakCdtkQ+LKpLQ4Sm4pnlParvKMkpWO
	R43dtGtcEoZOdNvplMeQ==
X-Google-Smtp-Source: AGHT+IFy1wNQtxR6XrTsutP7X45DcO+p8cC2DrtHUY4GL2TaRF3VMMnpfu5CdG06ll4VHA9ZjNp4Fw==
X-Received: by 2002:a17:902:ebd1:b0:298:3aa6:c03d with SMTP id d9443c01a7336-29f244cca9emr230094625ad.57.1766046893648;
        Thu, 18 Dec 2025 00:34:53 -0800 (PST)
Received: from localhost ([2a03:2880:ff:17::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d1926bbbsm17029345ad.84.2025.12.18.00.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:34:53 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 12/25] io_uring/cmd: set selected buffer index in __io_uring_cmd_done()
Date: Thu, 18 Dec 2025 00:33:06 -0800
Message-ID: <20251218083319.3485503-13-joannelkoong@gmail.com>
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


