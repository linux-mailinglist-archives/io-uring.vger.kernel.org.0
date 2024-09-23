Return-Path: <io-uring+bounces-3264-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D58597E951
	for <lists+io-uring@lfdr.de>; Mon, 23 Sep 2024 12:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D622828321A
	for <lists+io-uring@lfdr.de>; Mon, 23 Sep 2024 10:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3855B1946C2;
	Mon, 23 Sep 2024 10:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WXQiwpSQ"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B940EEB5
	for <io-uring@vger.kernel.org>; Mon, 23 Sep 2024 10:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727085923; cv=none; b=Sgv+/tVrYSrVAs+EPODx7GpiBHiQXkCVdd59rzc7+/ohcMVSsriuDkLXWne3b0fTaMp4x1D0dbyICZz+JcuA55NCxNZOd6J7L3hiO7WbcabxGEaGD0r0yesCPNavhECjGGwYAiYYbMwtJys85FGdMPr3h3F0jCCLVdYwFOD8Jkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727085923; c=relaxed/simple;
	bh=ke8zOMSYcgafYIq4JdY2CpFg8O3wvhsVN+ZJAAd936M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mBT/ltYvcl2DU5PFcXp+ovxMc+7ZPPUZco8TrFn5H9EnXhFSOyWkdL2HdnK2mP/2u2oCGKqWmK1fb6+t9m1YipgtrtbIDe7/nIWDE/QIeY2anr0sodFYY/rz6bS/qq2qLeI0kMaInwebtwFGSjX57R4KnSwv3u7ImCRHLuysauE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WXQiwpSQ; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1727085917; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=1LwZ3EO0VeLLyh5BHRfkEfHkhrbJV7WNtSHdhZrqUfY=;
	b=WXQiwpSQI8Akfwv4Sq1KTEMw7R5pvIvmhzYIl2+OMJ6sQYAdPXE5oGod3WxQ3WulNMSqklQK3UeOq+8JtMhaBc4QREhHHqqCIzAwIRyrIc9Ok6Snsfflv1XzcXg27fmF57C9DtAyML5BCj/mX6Wj35fcSo+x2xQf0VUldyGbG1s=
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WFXhjK._1727085912)
          by smtp.aliyun-inc.com;
          Mon, 23 Sep 2024 18:05:17 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org
Subject: [PATCH] io_uring: fix memory leak when cache init fail
Date: Mon, 23 Sep 2024 18:05:12 +0800
Message-ID: <20240923100512.64638-1-kanie@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We should exit the percpu ref when cache init fail to free the
data memory with in struct percpu_ref.

Fixes: 206aefde4f88 ("io_uring: reduce/pack size of io_ring_ctx")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
---
 io_uring/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 154b25b8a613..a1cda4139c9f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -316,7 +316,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 			    sizeof(struct uring_cache));
 	ret |= io_futex_cache_init(ctx);
 	if (ret)
-		goto err;
+		goto free_ref;
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
@@ -344,6 +344,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_napi_init(ctx);
 
 	return ctx;
+
+free_ref:
+	percpu_ref_exit(&ctx->refs);
 err:
 	io_alloc_cache_free(&ctx->rsrc_node_cache, kfree);
 	io_alloc_cache_free(&ctx->apoll_cache, kfree);
-- 
2.43.0


