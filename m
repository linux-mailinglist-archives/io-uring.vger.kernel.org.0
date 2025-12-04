Return-Path: <io-uring+bounces-10964-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B176CA58B3
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 22:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3286B3068153
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 21:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31BE334CDD;
	Thu,  4 Dec 2025 21:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m5juWzei"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAB5398FBF
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 21:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764885101; cv=none; b=RmisUS7OdINWjQSqquqE1Tm9Gmn++BBOoCdzU5QwiXPKYbQ0nOb1uYqJFAgprU/geOpCLAJHFySGErFc2qPOOmzD2yHCEKEyAMrZ4HdUzoN7ceZjMAeZiwNOK73OQDIysGrYmBrP+cLVvuEtXvdW4yPTHDzUoCeM4KaaOBKcSwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764885101; c=relaxed/simple;
	bh=2dQ9YLiyhcqOxT6yP61AykxhIxkkTKcdCOlnd3qBc8o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B55xCdGSoTK+8sUy8Jbxxx81K9NJZLfa9t8N9s4oFD8DFF4k/jPxkREC/GM/6lA2xUhvDtWWRSt4Z7XteXTEcK2arQzj/iBvBKyWSehKu6DcTguZHiXm52fHh2KbFA8FbFE4m+uBnEpNrxuER6M7FtIIF/H/Euh+4Xhw/RqcbOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m5juWzei; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-298039e00c2so18461145ad.3
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 13:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764885099; x=1765489899; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mpdOsv0f7G8gxL7IxLGSwcMh85NsqtU3YBk1hCpkg3s=;
        b=m5juWzeiMq98MTfG94OJMSXBdvRKMEo3f2P6cvbSpS776B9OGPnhVMuCO+SWUilkdo
         TR/f3DivRgSpPSFD9CXg+beKvPI/67InDs5ORxhjCUhhLp2RMVHB9QZz37l+Ut/PM53Y
         5gkk3dU1//vi4yDjDqjLk3zI4UitFuspJ559lxRr8zyWFtNeHDW7Zp7eKj1feZLmbzpQ
         7SxAJU1JnAb/dEeqEi0KUbHv1yLE4S7V2BaJEzl/8+00w7b/bNs/zywC/fqxeztCXBip
         TstrtOlIcnJWKCzR2NF5LFdBF9Zblxc9Z4o4A0ku4/dbj3DwjG3aKCWLnfhY+ZHF+561
         koQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764885099; x=1765489899;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mpdOsv0f7G8gxL7IxLGSwcMh85NsqtU3YBk1hCpkg3s=;
        b=MNupo/rg52KtdONUUb1+kur8hF6Foahkv/GtMWG4g0tTVWEr0bcD6958YUfokb7frQ
         +LQFoe+s3ND12XFt8tv3SJGZzS5v53+ftE994MU5AXypGfQjiWnO3jmpmUSHRMS1MZLx
         Gv3L48yZ9qBuXEanS9efSyZI7MXq6s9SOcnNxRKN5Xe8sa4aMhIKrUiDMmQ9qWo2hTcW
         oEplA0p0CzEndJEWFq27YN0G4EPKka8n480OmX25Ucwv7DPh3UEyVBLZj+lCNpXkqmQV
         oYBPAdoyBcivIpkTs6H7+i1h8SCDevdIaOLCEHKJ5YIQXy6gnZFnVm+fgJToi/RljgHO
         jOVg==
X-Gm-Message-State: AOJu0YwoJaxw/XHg72GKsdC11r7xprydK6Ne6mbm3mEBPoCYjjWtMC/P
	FgBfObLF2erTK2aXXfNW6IgBLl4Kf4ftiel/WPmrdHnJ2TC9CUEHS99b
X-Gm-Gg: ASbGncvl8IJov14VGJxgif6la4N0ysU2MI7L400CO76vKT/FG0xNJF5HqFxRCh1cDku
	mLLwWFXWtjX2wT50oqCKIpLPRrljXtc3C4KvZvK/NdfJ+1ootKbDFaowUbQh7zIdcjV96TcEeiF
	z3UhTm2HZ/rCEnftJhViX7ku6/IDWeS3ZN4XwPDo2dVG3aSpIdSolQBJOlylNu8WgqpHuSTLeiW
	k5KNoZTVmuOX6JKKfj3pBTTvrFu69XXE6igVFMdcoDvqxd8rndVkvnwXaeqfCbqBmNL7B6w4yym
	q9PeuoQVFg60YfWWnvMm0xb9M2bg/g9PfmzUkd8tDMUYugelauIl7dulbkhfUD1pe26/2T6fICc
	LDlC2xgpK2e5MHEhW1vyutU1nGFbi478zWanl9cMoo/zhYobefeX3bshGlUZRehtuUuNBuz5CDt
	jg//yjF1Nu6GCV4f5p1w==
X-Google-Smtp-Source: AGHT+IG2GG1Qz0dgG7rFP7eYwuINk3SdJynefdKMq8ayQm+uiou4+jnjhTRVNF1tMx94An5Ny113Zw==
X-Received: by 2002:a17:903:3c4f:b0:298:90f:5b01 with SMTP id d9443c01a7336-29d68491244mr96673905ad.52.1764885098942;
        Thu, 04 Dec 2025 13:51:38 -0800 (PST)
Received: from localhost ([2a03:2880:ff:44::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29daeae6d75sm28739665ad.98.2025.12.04.13.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 13:51:38 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	csander@purestorage.com
Subject: [PATCH v1 1/3] io_uring/rsrc: clean up buffer cloning arg validation
Date: Thu,  4 Dec 2025 13:51:14 -0800
Message-ID: <20251204215116.2642044-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Get rid of some redundant checks and move the src arg validation to
before the buffer table allocation, which simplifies error handling.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/rsrc.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3765a50329a8..5ad3d10413eb 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1186,12 +1186,16 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		return -EBUSY;
 
 	nbufs = src_ctx->buf_table.nr;
+	if (!nbufs)
+		return -ENXIO;
 	if (!arg->nr)
 		arg->nr = nbufs;
 	else if (arg->nr > nbufs)
 		return -EINVAL;
 	else if (arg->nr > IORING_MAX_REG_BUFFERS)
 		return -EINVAL;
+	if (check_add_overflow(arg->nr, arg->src_off, &off) || off > nbufs)
+		return -EOVERFLOW;
 	if (check_add_overflow(arg->nr, arg->dst_off, &nbufs))
 		return -EOVERFLOW;
 	if (nbufs > IORING_MAX_REG_BUFFERS)
@@ -1211,21 +1215,6 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		}
 	}
 
-	ret = -ENXIO;
-	nbufs = src_ctx->buf_table.nr;
-	if (!nbufs)
-		goto out_free;
-	ret = -EINVAL;
-	if (!arg->nr)
-		arg->nr = nbufs;
-	else if (arg->nr > nbufs)
-		goto out_free;
-	ret = -EOVERFLOW;
-	if (check_add_overflow(arg->nr, arg->src_off, &off))
-		goto out_free;
-	if (off > nbufs)
-		goto out_free;
-
 	off = arg->dst_off;
 	i = arg->src_off;
 	nr = arg->nr;
@@ -1238,8 +1227,8 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		} else {
 			dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 			if (!dst_node) {
-				ret = -ENOMEM;
-				goto out_free;
+				io_rsrc_data_free(ctx, &data);
+				return -ENOMEM;
 			}
 
 			refcount_inc(&src_node->buf->refs);
@@ -1265,10 +1254,6 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	WARN_ON_ONCE(ctx->buf_table.nr);
 	ctx->buf_table = data;
 	return 0;
-
-out_free:
-	io_rsrc_data_free(ctx, &data);
-	return ret;
 }
 
 /*
-- 
2.47.3


