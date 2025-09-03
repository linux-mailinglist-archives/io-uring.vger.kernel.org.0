Return-Path: <io-uring+bounces-9549-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E8CB412DF
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 05:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 073B35E6289
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 03:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E37FA2C3254;
	Wed,  3 Sep 2025 03:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="LuGX1/Pn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f228.google.com (mail-il1-f228.google.com [209.85.166.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0882C234E
	for <io-uring@vger.kernel.org>; Wed,  3 Sep 2025 03:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756870021; cv=none; b=ugPfVn28CmhKLRDHGPAY3Q+TTV998YQx9qk3YQHR3okywDcIm7qJSFO7LZxl9puWfSMZqOFfs/1h8BzTSwRZH89e4HXn9UeGUV1zFIHbMtGFa0Me+aw8AvGFRvEU9KvwsOA92uBPTJ9R45XaU0FTQrUMIMLYBMKOsKD+ePlGKAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756870021; c=relaxed/simple;
	bh=vT37VwGjZOyCl9u5Iz9sHTvtTUWCCe6Xb+1IziJLUvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfhviBDcgJVL7ouqBJs9mT0SCi5H/Ns5l06UcpeBWzYjLmst9P+Jz43hDI1EoV6jDR2xNk0ir/uNyvBFoUKBok5WAdh9ArbSC+v90rNiyX5Iw5m6psA4U2qnw5N0wFZD1dP2tfVWcYErtZ6HUUERXYwee+fhmsMd9j2kRUC1NKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=LuGX1/Pn; arc=none smtp.client-ip=209.85.166.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f228.google.com with SMTP id e9e14a558f8ab-3f4926aa183so2154935ab.2
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 20:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756870019; x=1757474819; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/lOOvLhOLy/sorN2ba6lIemJd4kQXZprLIftfp53Us=;
        b=LuGX1/PnYywp65OygFqFuKoe8cbMSZnDmR/5RYZdkgbivLBbyGQrG3uovIEpVhQupT
         5s7PqJ2HZDKG8odigdx7qF7ibegml1gAL7OhI6nRWYHjaRVIBoBo+Hwe0U+qiHWoscyo
         5WbIbUm13RJgiP3ZCjLl/ZEuErIozFlFHo9/JPl/I4waI3gZqF7xdMXpLKFp+m4Gg3nc
         +9DqR6yroOxuNM1KaFmrD/vOyzEzjqy/CIdB11GqtPeJo9J+f8Dw0muIMycfP7QdSOG9
         Rxkq4jK3TKJX2HwQ+oTkAJAupkBN+p0Bfzg95RhDuiteKIa/xPuGhW18edKA9ty1skMt
         THcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756870019; x=1757474819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o/lOOvLhOLy/sorN2ba6lIemJd4kQXZprLIftfp53Us=;
        b=VLFc2Wz9YxLM5/oH8IHb86N+QnQcbSKZwhgTySZ+j/vFBq1Q60Foy75+Q8hCMJDVY2
         RXDa54lvjcBrKoJ2lyRaDR5l0oi/J26A022bMAgCFi6rniA5NT8CDJKj+r17QqJV/nfB
         Ymb6Wc7L28K7/bNXHL/96CB57/B9WEHwLnNRWxwf+AQp1Y0srYGQE1HpTOYy8FZ6SvjQ
         nQZzuuvez6Vr6hvoBwfFhDWHEdl2gEoNl2fZmFKEkem7+7xAQEi4eQH5MzU0vUXjvvMJ
         lOLyGwUjUs0ik+bUO2gDBI+Nxv5n1qHefnqaFN6jIRQnWVNh/Kj9b4lo9I2kaTrSR1x8
         LCjA==
X-Gm-Message-State: AOJu0YwuxuKs0GGKisEJM2Cv+XFi0g2Wb1mME5ty45tUAkvnDi2oJu1k
	XfPfREVr86mitqnEcWu5Pvb4lm7piapdE6xS3CXclB5m2BjEN8VM8ZMch4Fqh+oX2ouYibIR76O
	f5C89MzQBrJFeWlfNUNSijZAFJVmUvci21kGsYN0puNMxTZam8f/8
X-Gm-Gg: ASbGncsBvIG5FByjgd9M4qD1R9Kdne8KDgZQD0mIwdfJia0DRFP+kjQ7TW9rLsoDqVI
	VN0r0PyHSWhzadnm7NIMCycZ1y5G9CrZ8/QCvoFpUM6YH5MRcPy+gDS5fRS1kqoftcUDcDZ59in
	Ib9LZ6IHJKX3J4/v/2wK6Ly2/udEyEcj0+8u5BiU0RVWL/5Vi5Ktp3lDIotmBsG4aYYVpK8/Oc4
	cS7oaPQ4w7R2GxrKvGhtvLFiImwDFpQ+YBzaGJORLWFEO5R88aciJ4zCIGeSWdX/CpxMs7IFaJp
	W7Xl78ZRzYk693nqx0456M74ax8CclNnOOIB8nY5rZzsUIn4NY8U/pO6OQ==
X-Google-Smtp-Source: AGHT+IG6TC1qm4eO2jp6q81u7BtA9gndoChMx4n9tAGaldjwUIcSFnLmfQ16RVQQVkcE5oHUy/Sqof2Cdqst
X-Received: by 2002:a05:6e02:1fc5:b0:3ef:beb7:dba4 with SMTP id e9e14a558f8ab-3f321afda65mr110085785ab.2.1756870019411;
        Tue, 02 Sep 2025 20:26:59 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 8926c6da1cb9f-50d8f31b06bsm723181173.48.2025.09.02.20.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 20:26:59 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id C06EF34029E;
	Tue,  2 Sep 2025 21:26:58 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id BD418E41964; Tue,  2 Sep 2025 21:26:58 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 2/4] io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
Date: Tue,  2 Sep 2025 21:26:54 -0600
Message-ID: <20250903032656.2012337-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250903032656.2012337-1-csander@purestorage.com>
References: <20250903032656.2012337-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_ring_ctx's enabled with IORING_SETUP_SINGLE_ISSUER are only allowed
a single task submitting to the ctx. Although the documentation only
mentions this restriction applying to io_uring_enter() syscalls,
commit d7cce96c449e ("io_uring: limit registration w/ SINGLE_ISSUER")
extends it to io_uring_register(). Ensuring only one task interacts
with the io_ring_ctx will be important to allow this task to avoid
taking the uring_lock.
There is, however, one gap in these checks: io_register_clone_buffers()
may take the uring_lock on a second (source) io_ring_ctx, but
__io_uring_register() only checks the current thread against the
*destination* io_ring_ctx's submitter_task. Fail the
IORING_REGISTER_CLONE_BUFFERS with -EEXIST if the source io_ring_ctx has
a registered submitter_task other than the current task.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 2d15b8785a95..1e5b7833076a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1298,14 +1298,21 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 
 	src_ctx = file->private_data;
 	if (src_ctx != ctx) {
 		mutex_unlock(&ctx->uring_lock);
 		lock_two_rings(ctx, src_ctx);
+
+		if (src_ctx->submitter_task && 
+		    src_ctx->submitter_task != current) {
+			ret = -EEXIST;
+			goto out;
+		}
 	}
 
 	ret = io_clone_buffers(ctx, src_ctx, &buf);
 
+out:
 	if (src_ctx != ctx)
 		mutex_unlock(&src_ctx->uring_lock);
 
 	fput(file);
 	return ret;
-- 
2.45.2


