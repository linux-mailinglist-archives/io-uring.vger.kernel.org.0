Return-Path: <io-uring+bounces-8484-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63034AE7F37
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 12:27:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 560383B59FF
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 10:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3545E1F3BB5;
	Wed, 25 Jun 2025 10:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LP3h28ZG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43EB280CE0;
	Wed, 25 Jun 2025 10:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750847233; cv=none; b=Pa11VCd+7J8mN4GpdMdbz3zu1mNmUvev/ao8Nd8vLhOxzpc+hvCsujjvvkB0FqboT8O6rGwyPLYf3HDWVU9hykLRuPAoU7Ffeap8M9JD4FmPxH7Pw44hMSyz8tyj2j2sJg02qwLFCzgaH84/Ma9hzIvJQ9zl9sNbuLFxObpIp1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750847233; c=relaxed/simple;
	bh=HSCjCiEHKsROo2fk/Ce1a6UUAjVcLaJv73jMuM0kV+4=;
	h=From:To:Cc:Subject:Date:Message-Id; b=oPiCZO2YgAnp2SNZTo6oqQiByQ6+D5fh4hyes800rL7H1p/EB6qETP1AgNxlI29rSGPXPMrz+mMaFgueLsf0K3Y2waxPTfBmktBJRRVPfCe3lzHQrWM1VOyqLSuTrIffAxxqczRym+S+K8OCd0SEf/JAkWPO3ss08GhUVGaWZP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LP3h28ZG; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2360ff7ac1bso12488255ad.3;
        Wed, 25 Jun 2025 03:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750847231; x=1751452031; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zY7fKC/qV7ZHlYsM900r395rGJcUyLQ039J8xew1IFA=;
        b=LP3h28ZGYVkcW4utc6U0bmY5yN5+kt0Gw85yN2hR8F2s7OatGoiQwg8iILAyAIm6Pz
         5y4bnKHu21qx3HFvvZYc6Slr/7AcC1tB8N9hvne8lo7ER/RQk2UwcJpFVrv80QhaueNc
         XahJb0XCDfK/7nGa6iuIIr6dQK93HKEYIfCKarfFujugFxYNtOj3uVr6Z8y4UVTVWrkM
         46Xr0I3g1fHkH7MAecFltyfJRH1J3olktYUuKipzHvBJNFFGH5IAxq4DX/iJiwSAbg9Z
         5+VqouXAz34Qzuvr0f5fYF5lGcyTZTIJ1JPJEfkL1ES/MM/enHVLBL2WN3KDG0E6ZZmm
         Yd5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750847231; x=1751452031;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zY7fKC/qV7ZHlYsM900r395rGJcUyLQ039J8xew1IFA=;
        b=YzGkfXOsuQMt5DT+tJUF8l3RJkGzSeGVOZnwbUbZwloV8mqCXfHK9D/xRXx0krkuYU
         5cAGcyJt24/XLLce0Qii+URM6M1hs1x5TO0wue98KxRtZ49dzvYKtyqn6nG55S8fh5DN
         lSZK8rvYK2H4e1YzkEbex45LNPIOnzbuwP86uj5eZDjsERBog/9fFT7cLQ+CrbM7iB0O
         n4HIZ8G8wl837ceEbuT9F9atx+JxHbHkNmq38T8rng0NosmlSKw2/2C9WfvmXS/rQft8
         q9kFGwU2RobSv/dv60yFsFDkEriHYymL4HgTEyOw4zrjKk1HRvssWdYbXYltTg7w6TI3
         wmAA==
X-Forwarded-Encrypted: i=1; AJvYcCXsLkhHhiwRC14F4ZdDf0kQFJkYcO8TF14DzILLpREMMo2IYMDqiZ8PlhgCWkTriKbtMhPAOpkwegvWw/k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzARBZ6ms2biRZlTMkY4CHi0SN6vUdUIIKBsQXri/l0NZg7yyW
	C+c6YpX9vnIhpxHd6v5KD8FadfCQwQQROdrsj0EK1mXFmUvAPTuFas56
X-Gm-Gg: ASbGncsRvQQZUc6T+edR3jF646PkxaL/ZtlCFSXRJjiyC5BBjg5XghgWvKItEyDjFql
	A8AbmeOjDgJtDOMvZahNGSVj9PHVik1u6k7jaHULR84hnLaA6xHAPJbQWcBRIndrNluin43ZDJi
	poONkjU7T3RdAzhsggzGRqPxH3TV1Q42NQ/Sn2iNZ4sQRsR254bfwwMJuw1zY5PVQsBpsQ6wftY
	hBqCntYOc+n6YagRFHRrBMqGDE6Scyx9URbkZ/lBpmbyTA9Dxbl1ozC1un1A/oCzmOR52Bd2ajS
	18xF/dCjVPJuiqvY/ZQLZdfiLGRhiLHCtGF7l8sYDkcJkPsxWrIzp0XrC6lbFyNxuDrrv6ofqUb
	0OkrB8HGg
X-Google-Smtp-Source: AGHT+IFlIjrksnX9+mThUlVZlM9ouOL4FyPUOwuFYKC6Nsq007BT2Fo3tCOGrcfFXd8IRbbqNkRUQQ==
X-Received: by 2002:a17:903:2304:b0:234:1163:ff99 with SMTP id d9443c01a7336-2382478cecemr47637105ad.43.1750847230907;
        Wed, 25 Jun 2025 03:27:10 -0700 (PDT)
Received: from ubuntu.localdomain ([27.213.151.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d8640c61sm134185795ad.141.2025.06.25.03.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 03:27:10 -0700 (PDT)
From: Penglei Jiang <superman.xpt@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	asml.silence@gmail.com,
	Penglei Jiang <superman.xpt@gmail.com>
Subject: [PATCH] io_uring: fix resource leak in io_import_dmabuf()
Date: Wed, 25 Jun 2025 03:27:03 -0700
Message-Id: <20250625102703.68336-1-superman.xpt@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Replace the return statement with setting ret = -EINVAL and jumping to
the err label to ensure resources are released via io_release_dmabuf.

Fixes: a5c98e942457 ("io_uring/zcrx: dmabuf backed zerocopy receive")
Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
---
 io_uring/zcrx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 797247a34cb7..085eeed8cd50 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -106,8 +106,10 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 	for_each_sgtable_dma_sg(mem->sgt, sg, i)
 		total_size += sg_dma_len(sg);
 
-	if (total_size < off + len)
-		return -EINVAL;
+	if (total_size < off + len) {
+		ret = -EINVAL;
+		goto err;
+	}
 
 	mem->dmabuf_offset = off;
 	mem->size = len;
-- 
2.17.1


