Return-Path: <io-uring+bounces-26-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A0ACE7E175A
	for <lists+io-uring@lfdr.de>; Sun,  5 Nov 2023 23:30:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33E231F216B0
	for <lists+io-uring@lfdr.de>; Sun,  5 Nov 2023 22:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A004E1C692;
	Sun,  5 Nov 2023 22:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wfsk7Vrg"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EFE1A726
	for <io-uring@vger.kernel.org>; Sun,  5 Nov 2023 22:30:28 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE23CDD
	for <io-uring@vger.kernel.org>; Sun,  5 Nov 2023 14:30:26 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-4083f61312eso29984875e9.3
        for <io-uring@vger.kernel.org>; Sun, 05 Nov 2023 14:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699223425; x=1699828225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TjbxQQROHn5RaXhXiYTu3jRMDbxVpPecsYg591f68Bo=;
        b=Wfsk7VrgKAOFwtqJa2NsCEIp9JvXySPy4kt6oVbqpdsZbA0fUtHBMxQt7j0UrY3lNi
         FyUdW3q/87ibZMuokEEJVSUvwhGpYw6SM38xMHyvUhkbMfPxARRubHcCJlgfIYpC4n6k
         jDJ+hSND1yPZRNxloTmOk67vhxqn9QxMJ105KlmEZqQuhdXhZa5ECLk6cEAzbeGuG6Nc
         llZtoMF84WlTmHfQL5Pt8KUpx/jmZEW5ERjDblfcMm8Mc1/ZpUN29vr1C2uFEmy6fRXm
         ZLZ3E9I9BwbVbRsA6JjgXtkysel+aG9ySBzSqOFycS9Vmk2Iz5M/LW1e4SobYHNW1/Y3
         S1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699223425; x=1699828225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TjbxQQROHn5RaXhXiYTu3jRMDbxVpPecsYg591f68Bo=;
        b=w+N6qM7APbu+L8l4BepwXi8oT/KXwOxGyt0x/3CyFnwLne9g8lc/7zVA1EX6TBrFKz
         PzgBo+3eZ76vJ9CtnbhPfktZtUWbHCH+m6GPt7Y46x216Q58aVVhiVQhx2zizuVh6KDi
         kJXs59yiyYf3avySXYoL0oUN0v0Ye8YSi/QFQ+03pVSEeHDaaOnbYfsCwXjChMJvOqMw
         3ai9I1FJR/RLPS3et1IqclL+WxARe8J253TOdOym9k+M0LgwNq5AFQJPTi5ITrR22BKK
         ZMRU3Jk7GT9cR/R8ZZ2zH5kayOuaktq2av1F9iMubQgObTTmVUO31BLnCYW9I8GtxL+I
         qAPQ==
X-Gm-Message-State: AOJu0Ywp3qF+PAdHP/v4uHmSz7Ggof5LOHC49YmqAaB9UzU2Qt9M6qO0
	t3hofCGnb5a7FzuG6i5OmmnUaX6NpPE=
X-Google-Smtp-Source: AGHT+IHSbWcqO6Upd4ctzD0hW15unzCqDJY4vHDqZObY1jmcT9eHludIvisAkYOtkGlVOdSI/9QwKw==
X-Received: by 2002:a05:600c:1f93:b0:40a:25f1:7a28 with SMTP id je19-20020a05600c1f9300b0040a25f17a28mr272822wmb.40.1699223424836;
        Sun, 05 Nov 2023 14:30:24 -0800 (PST)
Received: from puck.. (finc-22-b2-v4wan-160991-cust114.vm7.cable.virginm.net. [82.17.76.115])
        by smtp.gmail.com with ESMTPSA id m26-20020a05600c3b1a00b00407752bd834sm10244267wms.1.2023.11.05.14.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Nov 2023 14:30:23 -0800 (PST)
From: Dylan Yudaken <dyudaken@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	asml.silence@gmail.com,
	Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH 2/2] io_uring: do not clamp read length for multishot read
Date: Sun,  5 Nov 2023 22:30:08 +0000
Message-ID: <20231105223008.125563-3-dyudaken@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231105223008.125563-1-dyudaken@gmail.com>
References: <20231105223008.125563-1-dyudaken@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When doing a multishot read, the code path reuses the old read
paths. However this breaks an assumption built into those paths,
namely that struct io_rw::len is available for reuse by __io_import_iovec.

For multishot this results in len being set for the first receive
call, and then subsequent calls are clamped to that buffer length incorrectly.

Fixes: fc68fcda0491 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Dylan Yudaken <dyudaken@gmail.com>
---
 io_uring/rw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index ea86498d8769..b7f7fbc28032 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -417,6 +417,8 @@ static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
 
 	if (!io_issue_defs[opcode].vectored || req->flags & REQ_F_BUFFER_SELECT) {
 		if (io_do_buffer_select(req)) {
+			if (opcode == IORING_OP_READ_MULTISHOT)
+				sqe_len = 0;
 			buf = io_buffer_select(req, &sqe_len, issue_flags);
 			if (!buf)
 				return ERR_PTR(-ENOBUFS);
-- 
2.41.0


