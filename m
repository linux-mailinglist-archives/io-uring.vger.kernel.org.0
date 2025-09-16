Return-Path: <io-uring+bounces-9802-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D808DB59A6B
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C1E2467E25
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61888322DAC;
	Tue, 16 Sep 2025 14:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LUqWIZAZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17FD313E39
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032812; cv=none; b=qulM+E+ZtoShvx045zEjjhAtoMy01JhPYSpDw1x834c/6fs2A3QPERzcuyWYxabLx5rKdV9XtmK7W19Jsgc6QzxTrjSNIbBEe6OfSbOUfESV4Bu4U26aa+G+6OpFAwUO9+QVpdyxMuPmSadp67yBSLQsvCSW5j8e54Ja9G823iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032812; c=relaxed/simple;
	bh=my+Q7dEHUc5ialRgpreKXsB/majGXMlrcKZ5miiUyW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPAcLKkac5IE8pzsZsVsReueYfjVptGfgRysFlPSPRG43MO21GVn7uVyF0RRF29gzwUl9+bI39JS8hBAOgWobsOeR5X8grAn9Oxp8SNwbplNRoDBEcoPMOkf86U91LLDbCLYDUo541f79JBVyulZeXY0CiuXLt0l00ygvHCOt+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LUqWIZAZ; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3e8ea11a325so3754174f8f.1
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032808; x=1758637608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Zf4U+FX0WVldyBueXghFqY5DGCqMSEWSoM3TnvY6N8=;
        b=LUqWIZAZ2oahas/7T+/3rjHDRUhKy7SAiuFdy5/+s5XGAIEhHtu0kNF7QFIDiQXW5Z
         4DpEWR23yDY/Ted4jOEswFM8NlQ8KcIHiDboO2gZBFCCiTq07/xLju35V98urQ/r9NKc
         Mrffh4L7Ee6w3DUAWWDwrWkpqFRMwHKzTSKFJY27WgkOSw9OT1suV7U0WVls42ZKwAW5
         O10uy4MM4SjcNVmSyxZhCMRo9uTsG3+3zDxeWPOaUwkcTY71mEwEwgEkkwSc7wHNBGZS
         bmXAsoLjsVPxt6hPVW70Gu7rYxy/3a0rd65MIEoRVPwwd7pKsjiqqUStJ/cXJPT3jPLd
         EfpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032808; x=1758637608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Zf4U+FX0WVldyBueXghFqY5DGCqMSEWSoM3TnvY6N8=;
        b=MpjDEqQvV6z7Kv0Xf+Chw2prVn71iUeyIYTCShidIPMc0F2tq0a/3aMxBKszBCFST8
         oszqA3T/jq3+qSKI1bA7VPeOXTJpHoNjZe/DcvQ3LTuzVSdLcGY0WXpYPBEU253qwccI
         fs3tiWt7RDZWJzHHe0A1kTkfGw7/zZeicnwx7573oiefzuOT8Z00lSuIMwizxQKhyLfU
         HohIMps0S72IsnoHtVy8OBtT1wD2GqCL/+zNXP1W8uq/nSrKTpB50A0uHc70dP2c2xfR
         3g2ys8usX3Rgqh6nmd8Cx+na7bo5ZUT/WCBiQ+/F0du7rG5IC7mi9UNTglx5kMO4Cvjb
         G6vA==
X-Gm-Message-State: AOJu0Yycb3JHPKaDgN0QcQXxAeuP2G5CkE+uZi206Z2a4HUqKTFxjh7Q
	9wm+h7eS/8H8nSynNEl2jYg5vG7i4s67wA69KTqVEVWrvwdWWoHR39JkUONmCQ==
X-Gm-Gg: ASbGncvvkc/3ksMldR6AwgINgatEwuX/YJus73fjkWf4qxuu3Z2MAPwSGgzKK12UT0v
	sU6oKWO6TYZFAlAhou0XcUimB8kVDta2285C39WpCOuYMnsBTvQ6rq9UzryNk/oBPvgdRagY518
	4kcjvB95TlekZQFCwRozEgx2lCQD7jQrQ+kMHw064FWfj3kpBjXzF1m8zsXqTNEmULB7qDHPz4S
	Wt7GLo8f+ghET0YPEHeb5fL/ZHdbH+OFlQSpQoVPxLlTd16rHUAACUPzxz1lz5z+P4lExIIF3zR
	Gp4W+/sg3R0GDc+RRLYezAPtlPVU5UQ0ehBuTbJfbzFBvAfyjPQDvw70IEh8kVhAaUAjvGinpVy
	SzdG8ow==
X-Google-Smtp-Source: AGHT+IHgly2HboHXGWES/kkqSLsldYjPeQisFh0CvTWXK/3eqU5RbsMXaeIVzAtDFLxNkeUOlpWHFQ==
X-Received: by 2002:a05:6000:2289:b0:3e5:47a9:1c7a with SMTP id ffacd0b85a97d-3e765a157b7mr15407646f8f.62.1758032808298;
        Tue, 16 Sep 2025 07:26:48 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:26:47 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 02/20] io_uring/zcrx: replace memchar_inv with is_zero
Date: Tue, 16 Sep 2025 15:27:45 +0100
Message-ID: <1464bccfdbd45ff98c875c7086bbc67e14386ae7.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

memchr_inv() is more ambiguous than mem_is_zero(), so use the latter
for zero checks.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index c02045e4c1b6..a4a0560e8269 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -566,7 +566,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EFAULT;
 	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
 		return -EFAULT;
-	if (memchr_inv(&reg.__resv, 0, sizeof(reg.__resv)) ||
+	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) ||
 	    reg.__resv2 || reg.zcrx_id)
 		return -EINVAL;
 	if (reg.if_rxq == -1 || !reg.rq_entries || reg.flags)
-- 
2.49.0


