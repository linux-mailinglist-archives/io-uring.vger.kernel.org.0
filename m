Return-Path: <io-uring+bounces-10420-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A3ACC3CAE8
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:02:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE5111895A5F
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBA8522B8C5;
	Thu,  6 Nov 2025 17:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJmFW1As"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241B734D4F8
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448536; cv=none; b=M/aJofwUg0/DFSUlb2MyuepQ965IA/v0U7IAwZ2CBlqxOZCIzslAzdJ0pnmlonqaWt8NpOsAbxBYx/eJJCa5fhvk1UwZYIiDdaJtz/41TDpdTzK1GkgBYO5hrL5ahrhjBphAB7PZRyn2LxGEYjrDzkFdZXXfUGwXwgR3Ahrcyjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448536; c=relaxed/simple;
	bh=FvApHM5jygEfFLsapCf+ymYroQBR4lVGbWdk5YVhftg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEC3C6zzReDrNIsoXp3rTh3b1z3ibP4e7cdiEtWjHmBJjhAs40qSicEr+As6rQ4Xw5IkwaA2kZO5Nj424yrS3k1Jfsn6Ig66HNVpM72HdPU0zciMwkvCKDKxTHrvcbawEGAfjZ//Xhi1IFelH9Jv+/DmL7ix/GXfzJecqP0O0/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KJmFW1As; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4710a1f9e4cso9745855e9.0
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448533; x=1763053333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1WHj+8mIofHVWnELKtEQJtsaecXpbdxjeVcrcLK+txk=;
        b=KJmFW1AsIumXJ1ZwPJLtiCzWm2uOdqyC4vtPNz+pOKiHE7ATpMtYggnULS8q38rTaO
         /8k4+6ZQv0Qx5Dhvs46qx82hkm6Ltd7xjX0qj5g/QFSubgzI2HHhVZc4hPssSEnD2aic
         BYSLs6uR0ad9TehHvsMZfPDkoGyU2wIHoVpRMH0ifE2FE+S6BeHr0ztpCyq5anF6I8io
         fGr4NQ6YBFkSTNhhGibtV7j3VtrRNa+CqExmdGcUz/B63fAlLrrPy5Ldhlu4+EUDz5CF
         SWB2uW4mwJL2Gmpk0+eKZl2k1vUHNlai0pDBVmkjVRqMa6nTT6HXezNRPtmoG68UtX5/
         5BJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448533; x=1763053333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1WHj+8mIofHVWnELKtEQJtsaecXpbdxjeVcrcLK+txk=;
        b=DBlZM0/2E83w+eqcEs71uEVdfPyjCa/dMoSim1Ve85eeAwngin2kHeKCqEtvEoZklv
         PbYri/jxop2UGfGhei5ebiasZf9JqTrNDUpBjVXqbi3YD2jG1lr8RrIYuVm3rGN73XgO
         tbi4dvT6BXdsYuNP+tTQdrKcjraYiBQWFVdnoJqfD39rlrfZR+yPJE0xGg6cTpSAz4iV
         uexsL/Bsb4drZqwJJj9CsE9oWmazA33X02Jb0uFVW6OGznhI6x1dhzsqMb9NpIZCHfOA
         T2AkjEXP3BbcTEXPT4FXKbM1kMherxH/qolC1r3BIXIc1FgoqrmzOiuEQqrcT0J1NLEl
         y9Yw==
X-Gm-Message-State: AOJu0Yxg3bTywh4peoc6t+5amNycHQ40XsH1DDwp02Zf4AYE5D9sQ5HE
	EY6iyW9VrQ/+k+4xfrVVRX6NLjlwDLDtxgku7sbvNm5EQh1C0fMxokacgZXLfQ==
X-Gm-Gg: ASbGncurr00u7gk6S6VZ0FUmHoAXCuGI4/fxvQEJGqj703+AF7AGojeo+pILSDew4ID
	LHG26FbX1EcgJJy+Ly+BPUq6URMAE+Vu332XA5Lx53BMEzjiHO98tYGmsDPI30x1oir66dmVvT5
	1X/UbpQGRZxr0UftM6Fno24yuadFv6tbx1sKZHmC34iMh3GAzCB2o1Hm2+wc4gTz8g8Gm58SZnZ
	KmE6zfMTWr9yGojfFtsBl9FTWb/h65kxARfdT89OgOV+V5v0c4IxPwf7wF1AO7ICTmqIcHPBUkJ
	WtEM3Pyk4aM/pdQ3cfBaa038u6bmKdKnm9yWu3AnkXhZNcs79EMGwtewLfV078la0FsAaWH5jEM
	YMRHJQRdZAhuNqT7kGqLcrrhQ65Kp+alxEHD5tqAYSanfGWN0gwiL06/sdB0zl61Hkzan0cERdL
	sGdsQ=
X-Google-Smtp-Source: AGHT+IH2z2IS11EWv41SqBtoOZ+ylZw7VYq0nQebLfw2KIVyUGOdt6qhsdw37HXddMcip1i4nOYaZw==
X-Received: by 2002:a05:600c:c8a:b0:475:da1a:5418 with SMTP id 5b1f17b1804b1-4776bc89fe6mr430455e9.1.1762448532778;
        Thu, 06 Nov 2025 09:02:12 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:12 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 13/16] io_uring: refactor rings_size()
Date: Thu,  6 Nov 2025 17:01:52 +0000
Message-ID: <e1698a6bf952053026183bc2150a05822f844615.1762447538.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762447538.git.asml.silence@gmail.com>
References: <cover.1762447538.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor rings_size() to facilitate further changes. Move entries checks
to the beginning, which localises offset calculation. And instead of
special casing IORING_SETUP_NO_SQARRAY, reverse the check and just
continue offset calculation. This way it assign cq_comp_size only once
at the end.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4f38a0b587fd..ff52d9f110ce 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2761,6 +2761,15 @@ int rings_size(unsigned int flags, unsigned int sq_entries,
 {
 	size_t cqe_size, off, sqe_size;
 
+	if (flags & IORING_SETUP_CQE_MIXED) {
+		if (cq_entries < 2)
+			return -EOVERFLOW;
+	}
+	if (flags & IORING_SETUP_SQE_MIXED) {
+		if (sq_entries < 2)
+			return -EOVERFLOW;
+	}
+
 	dims->sq_array_offset = SIZE_MAX;
 
 	sqe_size = sizeof(struct io_uring_sqe);
@@ -2786,29 +2795,19 @@ int rings_size(unsigned int flags, unsigned int sq_entries,
 	if (off == SIZE_MAX)
 		return -EOVERFLOW;
 
-	if (flags & IORING_SETUP_CQE_MIXED) {
-		if (cq_entries < 2)
-			return -EOVERFLOW;
-	}
-	if (flags & IORING_SETUP_SQE_MIXED) {
-		if (sq_entries < 2)
-			return -EOVERFLOW;
-	}
-
 #ifdef CONFIG_SMP
 	off = ALIGN(off, SMP_CACHE_BYTES);
 	if (off == 0)
 		return -EOVERFLOW;
 #endif
 
-	if (flags & IORING_SETUP_NO_SQARRAY) {
-		dims->cq_comp_size = off;
-		return 0;
-	}
+	if (!(flags & IORING_SETUP_NO_SQARRAY)) {
+		dims->sq_array_offset = off;
 
-	dims->sq_array_offset = off;
-	if (check_add_overflow(off, dims->sq_array_size, &off))
-		return -EOVERFLOW;
+		off = size_add(off, dims->sq_array_size);
+		if (off == SIZE_MAX)
+			return -EOVERFLOW;
+	}
 
 	dims->cq_comp_size = off;
 	return 0;
-- 
2.49.0


