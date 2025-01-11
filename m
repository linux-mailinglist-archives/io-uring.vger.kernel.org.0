Return-Path: <io-uring+bounces-5821-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62513A0A328
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 11:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58E2D3A48EB
	for <lists+io-uring@lfdr.de>; Sat, 11 Jan 2025 10:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81C9718FDB2;
	Sat, 11 Jan 2025 10:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LeK8dyU0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E446D29A2;
	Sat, 11 Jan 2025 10:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736593182; cv=none; b=l7LW1hpWoKdFMs3ZexqVo9XsapusupBNmOkYETMJE3PQa4FnHOu3D/mfpdwS5eyOt7jyIqMxLWpcv4z3teYrDKgnU04H+GbFs7ymRlwjMhs4bqtk3ErWBjowoxIFr80HVhqTT/60G+SffZveEDqzx2AYjWDToneQ4C3lJtXStmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736593182; c=relaxed/simple;
	bh=4va/D/7VNV9RG36s5tN0dq/b0wnskqjvoOhbpA5FbYY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pTYYAVN2riy4HJM6gI7FihkbjtiJLV821YLC5LgiEb4ig1MPtkvCa8YapbDxK2eaGCFujn9+OpbiA80v4tiJkZm/S3m2x4k2P4MEZw0L+1TdIvS6ZQnafjQqF6i+hqPb2IKHbfHdhfZo+sh/RpmdXZ/5sU0HGbzElpNk29YJkz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LeK8dyU0; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2163bd70069so49578115ad.0;
        Sat, 11 Jan 2025 02:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736593180; x=1737197980; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k6PxeiI4+qwtPmD4gWgjrZQbEO5YivclUq4PMEPeaEU=;
        b=LeK8dyU0L+76S7pjAw8S8yj98b4BL4VN/eOydJQUmQ8UP7OzQs0yx141S02UCWBH2q
         YtT3jysJIqzic5DNhRQHAe+C0h3ozj9opdSvq/oEnAcgwG9jOmBjjGlETe/ehzYi7Zkx
         Uv58JOBlkuscyW0I2q6lPZZfL4lPFp1nf3yk8+CB9/snV5Ei22TYR1oTnjuM9M+Ar2Ac
         8C71exjqU6Z77NEFYNcu35HNJUWfKI8CBkZJWmhTQrrwUvyB4wCDW51ctJ5yVo8lrvgJ
         81K91XPk1pD+HCC061J4/GzSftc4Hi3vfTILOJspvaKKvOwk6owBCT6YK4Gcot8LjGC7
         LLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736593180; x=1737197980;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k6PxeiI4+qwtPmD4gWgjrZQbEO5YivclUq4PMEPeaEU=;
        b=HDQJbAXyLVL+lQLCxyz1L/O8/NCX9IcXbGHVRBdxvGR9t6274j2YpW3tL9m2sUQpQl
         n/OeWs1Zv5iuHw1NNLq8g3ayoMYXe6HODpY2doyR/7VfhHRlUpmv6RaV7y4QOMwN07mj
         C5C6aVdyf/PXjzjbKCfWtL3qjRRDykWQzgzaIBkZLK9ntKZIF0R/xDdjnQmTyJnNeGcg
         H4Ud4edHb77fZli/v7CHcGHfBT/Ci7yeKkJTXRWwUr0UynnX2Oh3TEex/wYhsEJ2vuTX
         Z3TKOfTusQzCc0LQbRCCYL2dRz0LjLgkrshC2MnmRSB/ppr8Pxdhw9fKVLHXBB1D8L2B
         Ishg==
X-Forwarded-Encrypted: i=1; AJvYcCV9ykkJl1mYZp3/93gXhJ/jviNCYnyl5SlIH1NdPAV33LsuRcy/YyI4+tsKiAOx7NzrT309nWEu9Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxYf45e37RQxRIuDYL3Ok66itUFq73PQaH+TFH4njJ/UQhBZ0q0
	y2DY9NCK6FBO28neJW6wgizSV0LtrsZ2cMUUkFmGVRI9bNYDB4u5JUipFA==
X-Gm-Gg: ASbGnctEERBOl4tzEAyLoCkfqlDNKpH+u0BW3oU+7TpWPRNJJfbuu+eToaqBPjZXM44
	cOAJZhG3dCydD9CjV/9ZaALi0ee3Ou64y3IPreRWur9lWUQ797i4FX/UvEYdVWEr8p8zPouiJcR
	0Ug9BvWG6+qRtZevi56tr+w1rK3l8L5pFB6reP0zDFAFTEzoQ6kDobceM0/s4MqTvEVjoGplvza
	B42ph4XiHUbsj/LNsgWj91yo9fQ2bvPg3QfGZEfFgJNG3vhXaYk9hurwLhe
X-Google-Smtp-Source: AGHT+IHU5CV8B8ICdN5PHFiSHSB9Pjd9M6/qTx8XwZ/n3JMMzIIojtTPTFV5AauSv2jEHPBjTLPOag==
X-Received: by 2002:a17:902:dac8:b0:215:773a:c168 with SMTP id d9443c01a7336-21a83f48cf9mr224572325ad.1.1736593179728;
        Sat, 11 Jan 2025 02:59:39 -0800 (PST)
Received: from local.. ([2001:ee0:4f4c:d5a0:3ced:5989:32fe:cecf])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-21a9f256e39sm25811395ad.226.2025.01.11.02.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2025 02:59:39 -0800 (PST)
From: Bui Quang Minh <minhquangbui99@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Bui Quang Minh <minhquangbui99@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com,
	Li Zetao <lizetao1@huawei.com>
Subject: [PATCH] io_uring: annotate sqd->thread access with data race in cancel path
Date: Sat, 11 Jan 2025 17:59:19 +0700
Message-ID: <20250111105920.38083-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sqd->thread access in io_uring_cancel_generic is just for debug check
so we can safely ignore the data race.

The sqd->thread access in io_uring_try_cancel_requests is to check if the
caller is the sq threadi with the check ctx->sq_data->thread == current. In
case this is called in a task other than the sq thread, we expect the
expression to be false. And in that case, the sq_data->thread read can race
with the NULL write in the sq thread termination. However, the race will
still make ctx->sq_data->thread == current be false, so we can safely
ignore the data race.

Reported-by: syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com
Reported-by: Li Zetao <lizetao1@huawei.com>
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---
 io_uring/io_uring.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ff691f37462c..b1a116620ae1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3094,9 +3094,18 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
 	}
 
-	/* SQPOLL thread does its own polling */
+	/*
+	 * SQPOLL thread does its own polling
+	 *
+	 * We expect ctx->sq_data->thread == current to be false when
+	 * this function is called on a task other than the sq thread.
+	 * In that case, the sq_data->thread read can race with the
+	 * NULL write in the sq thread termination. However, the race
+	 * will still make ctx->sq_data->thread == current be false,
+	 * so we can safely ignore the data race here.
+	 */
 	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
-	    (ctx->sq_data && ctx->sq_data->thread == current)) {
+	    (ctx->sq_data && data_race(ctx->sq_data->thread) == current)) {
 		while (!wq_list_empty(&ctx->iopoll_list)) {
 			io_iopoll_try_reap_events(ctx);
 			ret = true;
@@ -3142,7 +3151,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 	s64 inflight;
 	DEFINE_WAIT(wait);
 
-	WARN_ON_ONCE(sqd && sqd->thread != current);
+	WARN_ON_ONCE(sqd && data_race(sqd->thread) != current);
 
 	if (!current->io_uring)
 		return;
-- 
2.43.0


