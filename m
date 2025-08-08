Return-Path: <io-uring+bounces-8913-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28DFBB1ED93
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 19:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE41C3A6449
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 17:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13F627F728;
	Fri,  8 Aug 2025 17:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fmOe83pl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138EC1C2437
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 17:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754672633; cv=none; b=hPlbSKeYUnvoB2Uq5fsAfpwDcfSwVGtp+cvs09g8TOdeiHBhZSXlyLK5BAoe5aO0UiK33yoVpTeNVMcotwMvB//ImMtGpIH7n8k6ujCebIz4PvvmN+3MG3jSzfe806Jk8hUqBISfGOLzzhRRNz/IwAHrblSIYYn5He2xOg48Dck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754672633; c=relaxed/simple;
	bh=eOpOcG9mNnOvunH+6HUTWGnFNFfkCUEmeRi0lvZOms8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EECvhl5fsTd6j2bsNwQm85BxQrGM77DItg/4+pyZQqaMjnc0RjTpNspLk8P9YGJSbp4UdMezA3zmHeFvEVgEPXhM8DP+gPyEZzEEg7CmVRvH06WPj9ma+3W4nVCUo4onpUrI6BIKSelQo1RmnE2M8V3xyZ+1cokCGvxZuzDkeCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fmOe83pl; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-8818be8d6e4so183111939f.2
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 10:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754672630; x=1755277430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXs8RA8orWwnolYDYMRWEMjo7fPdEdY/frZXY5Mo8so=;
        b=fmOe83plGDMtx3Ney7LWfroO+d2R+vfaGyr1AT3oW5imjCyTEfdyWm2nOwSZFqu4Vi
         SEX77hFcSsTgRAZQrB3qxCJ9WFhDG6xrqb18YVvaC6tr+AQNI9KkGYUVK7ygNkRYmlyK
         oOBE5g+6C3KofED9k69H45sRG1TmIPv8Aqx3To0t4pqm4/p5VqLQ1RanFiwtBkLjlZDO
         c1gxLo/4EFZk4ZGcZ9i27wtR1Z9LSZ+J77wdaFbk1gFuu6M9Scq8wuZsyENp1dVdNipz
         VbF8fL7Xc5Y01LeCUBtm28yeuEP6DXRiSUsT5mpatVAuY7IjdoV5AkN3ndFZeseS80fp
         GqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754672630; x=1755277430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lXs8RA8orWwnolYDYMRWEMjo7fPdEdY/frZXY5Mo8so=;
        b=qsTEPs6MVBbqJApHOQltWyvEys7ZQHO/6wDyVDWwkrk8WPcJrm1Qy8YB23fLO6FeIL
         /wBvrOq+aiTRlhx+ArR7mYGbdDVA8ZkzsfopKs1N2gSlNmFh37PXhZncMkoTfcfTFZmK
         lYIOIRP6cLwc11O/ceby/no3tuwa0Y7uYxdDHLnKS7KjOtHJXFOj2dG8K1v9h7He/4bC
         oSlQutc8moJaoo2QpJEDjXLc3LJCl/f5TNGI2jjldM1zKTX/EPFgtYWF615jPLRVjNN8
         TnaEf/NyGMNQBcbvpEMkiPLT+seg0juFb/rezXPx0OEtPR9fd9CPkoGxH8ptztnrDR+t
         oLPw==
X-Gm-Message-State: AOJu0YxutJAwaSDqnximCAoZg3DcGYxWUL/P5H2tENF0/CBLKdu4ugGv
	9Z5OoYHUu58LKRvdf824b0kp9a7bOGtpUxk3G7p5iV3ToHN4xMl3BPSqSaoVz4PQctnoCy8h9rW
	yalWE
X-Gm-Gg: ASbGnct595gaVOjK9s6xt88cXVf88p8AfCayGNXYxxvqh7pXwzb06u+CnFnr9fTnfUC
	3mFKtic2FhmAKDzZEPoqXGMaMOrXaX2X17RP24sUjlsp/ofikYbQm659nz4Lzx5WeeT3hfoV7If
	2iLR+xkfGjJUamB9UMxlhaJctuG1SP/9e6jgVr5DaL2DYpMv0xPnRKewuYiIkHpmVhsY+6FimVm
	cp6kSKCmg6bBS5ggn0PzNd/1KhItrjOmACwYnFnCE4PoWJxYWYSAenwZ6oJ9+ftkyhyuJSqonma
	mK67G2FXFt3cfW3Wign1wiAQ+e5EfnM4tmH1EFgoXIPUGwfXV5LEcfCwrClA8euj/VyzDLX89hJ
	ROX9UeA==
X-Google-Smtp-Source: AGHT+IEQBLCzhLTr96kHQR/NbSzVrhL7y0xsQN20zRuWvCssIzs0SeO8hk3wZaLPJxCJMXJhFNhwvw==
X-Received: by 2002:a05:6602:6c08:b0:881:9412:c917 with SMTP id ca18e2360f4ac-883f10e23c7mr742805039f.0.1754672629717;
        Fri, 08 Aug 2025 10:03:49 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-883f198d65esm68203439f.20.2025.08.08.10.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 10:03:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/8] io_uring/trace: support completion tracing of mixed 32b CQEs
Date: Fri,  8 Aug 2025 11:03:04 -0600
Message-ID: <20250808170339.610340-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250808170339.610340-1-axboe@kernel.dk>
References: <20250808170339.610340-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check for IORING_CQE_F_32 as well, not just if the ring was setup with
IORING_SETUP_CQE32 to only support big CQEs.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/trace/events/io_uring.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 6a970625a3ea..45d15460b495 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -340,8 +340,8 @@ TP_PROTO(struct io_ring_ctx *ctx, void *req, struct io_uring_cqe *cqe),
 		__entry->user_data	= cqe->user_data;
 		__entry->res		= cqe->res;
 		__entry->cflags		= cqe->flags;
-		__entry->extra1		= ctx->flags & IORING_SETUP_CQE32 ? cqe->big_cqe[0] : 0;
-		__entry->extra2		= ctx->flags & IORING_SETUP_CQE32 ? cqe->big_cqe[1] : 0;
+		__entry->extra1		= ctx->flags & IORING_SETUP_CQE32 || cqe->flags & IORING_CQE_F_32 ? cqe->big_cqe[0] : 0;
+		__entry->extra2		= ctx->flags & IORING_SETUP_CQE32 || cqe->flags & IORING_CQE_F_32 ? cqe->big_cqe[1] : 0;
 	),
 
 	TP_printk("ring %p, req %p, user_data 0x%llx, result %d, cflags 0x%x "
-- 
2.50.1


