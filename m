Return-Path: <io-uring+bounces-11826-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 81424D3BC28
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 00:56:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B7A813060A66
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 23:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8699E2BEC4A;
	Mon, 19 Jan 2026 23:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zeAM43rc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E472D948A
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 23:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768866907; cv=none; b=dGQeBTRr9b6JaKgxXpr7GJwqq7DpCXWTkyErzUYhC5pnJS02eiE2LyvZLDLGpBxLklDBhG9rxJW9ONjvniRPvyCp98UuJcDeJEKMcwVROG6gh8m5YwE2Z6CA0j+1TpT6VXHa42wUqQwxRE+yYirK9tD1gIo8nr60dmz1TKgopJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768866907; c=relaxed/simple;
	bh=LYfQxkXISYiwJSpmvFVsR3GjXHr7DechQooKrXuIbgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eh0UF284ByY+Ydn33pd8sWokSrztk9e9thtijnL14A3WVov+3LWp/UZYpy+FqV+y0p2HNBbTC5FDNCzs+bPt/cl3W5z7iH0ET66fuf2KBX1aRMTQ7graYY8xGgMlgZGIdgI5sXJNwCPmcNeNges+ERNLY/baK9wDnGFsfzbCUaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zeAM43rc; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7cfd57f0bf7so2949430a34.3
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 15:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768866903; x=1769471703; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b4CCFIzHIzx0zrm1l0N7Snv5MbrIq8arZzHeLeGcbdc=;
        b=zeAM43rcjb0sVNyqj44+uUcIDXYv0NHLiDMGYNRFXM4ZTvRvcHBVc8nd3rPbyJVONa
         1XN6r/xOx6XaBB8z99gThFk07s4kvq1khXn56CAzxpWy8rpb+IARZrz8QIrXa6TC/n+9
         akB/Jf5px4ZxcB1KBZlCM1Z8jNtGYyUkkBNozx7Ta/eVwM+FT44lOEPa8IAK0DBKOe3I
         qnXXwOXG5Pa8ZKBYSDEvRXPULpga1J1SHwAcyxhJaJ0cDPU9pprpCvAnRc4D30gqLWv1
         dti/Njf8RGTul2uTXX9c+1s9Vgfp3mFVHbvxnNYg8e5vDmMIlx2ML+iMxl7wsKEKneUf
         3rlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768866903; x=1769471703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b4CCFIzHIzx0zrm1l0N7Snv5MbrIq8arZzHeLeGcbdc=;
        b=lBSGMnCzLfAVoNN2wktGP7cN+khXhjk5lzvMKP+QXKW1Y/V/KZpwKi8KWQ/qfMvJv3
         Osi/Eq6INm1ePBMDUBchTjaf/Ardmq22/mVh6crdTjTkXCZFGzOcRLRyM4srjxoBysoX
         /M2CTF/TUbHcnR2lGql+zlSsLnjST/WwBdSOJcNYWt+BYF5rR9GzmS+xRfZRpBbw2MN5
         NVPn/tnbOzQ2BtU1mwE9mty4+GxZ/UCYtw4O2uBmBcmiD4FZRuQbHjbf3IlT0xJoRYtI
         WgGNMJ6inAdqp/Yz02JMsY5AlBxgSy2HBRpzO3g/aY6fzXsfAJt1Aiy/b8Nw39gxBtPi
         B4yg==
X-Gm-Message-State: AOJu0YyeIacS0mR7/pTlnxN7N6Jm8GSJtuG0waDGTNm+p2BLyFAKihsq
	OUhRC3dHaB1jeJwyVr5/HPLvDjGw873ZWW4IzY5SL9n6ouHr4aDCtm2omB/Mt2WIpWRJPEC1Woq
	3oBhg
X-Gm-Gg: AY/fxX58LrcJwxD4Juk1rSyjbLI6I8JXQ0tYvy68ZsiC75HdwImqoF283V2NxwwMCkr
	N0BpBMMVAIhdR95+PXNELJbQKjErU1QVhP4wZEdMbD3d1k6P+8ovrht1fw4ywUoudxWtruWzUZ+
	tTzoRjPuN8Knerfrkyt3wZuPCHnPmNwJvr4B3BGdD1w7WSojcThXdLhWFAhuDo3+yekFERb9iKY
	hbOdyiRsP9+IWwO/9WM+54UfQNeRzGpBYMqfw/NgdjJXHbSgDqfEPNAnnYQBJJQWNgGdzonl4Cp
	Z1+MkYwRVSUxp/f0n6hOPzA30C7yOwoX/y48GjHAbSJY4Da/h23rhLHkV1Etp5u/nH8Ik2bON6c
	Ugwvge1wzE+M2I21yhzMnx4+FFlwbymn+nQXMkmg0pws3q0b6s13/XTF5IeUivvagqEg213ScBh
	Al6J+lvRK93SLZU1oHfNDD7dQzvkYIQvZLP+QKj4TQIdEc5jlrDH8M7xbGqLmARRFyKuM=
X-Received: by 2002:a05:6830:6690:b0:7cf:db0f:c824 with SMTP id 46e09a7af769-7cfdeea2089mr6872319a34.32.1768866902758;
        Mon, 19 Jan 2026 15:55:02 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2a5f02sm7509997a34.25.2026.01.19.15.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 15:55:02 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	jannh@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/7] io_uring/bpf_filter: allow filtering on contents of struct open_how
Date: Mon, 19 Jan 2026 16:54:26 -0700
Message-ID: <20260119235456.1722452-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260119235456.1722452-1-axboe@kernel.dk>
References: <20260119235456.1722452-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds custom filtering for IORING_OP_OPENAT and IORING_OP_OPENAT2,
where the open_how flags, mode, and resolve can be checked by filters.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring/bpf_filter.h | 5 +++++
 io_uring/bpf_filter.c                    | 5 +++++
 io_uring/openclose.c                     | 9 +++++++++
 io_uring/openclose.h                     | 3 +++
 4 files changed, 22 insertions(+)

diff --git a/include/uapi/linux/io_uring/bpf_filter.h b/include/uapi/linux/io_uring/bpf_filter.h
index ad6961be5efa..7f468628c491 100644
--- a/include/uapi/linux/io_uring/bpf_filter.h
+++ b/include/uapi/linux/io_uring/bpf_filter.h
@@ -22,6 +22,11 @@ struct io_uring_bpf_ctx {
 			__u32	type;
 			__u32	protocol;
 		} socket;
+		struct {
+			__u64	flags;
+			__u64	mode;
+			__u64	resolve;
+		} open;
 	};
 };
 
diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
index 8934c0586842..3352f53fd2b9 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -12,6 +12,7 @@
 #include "io_uring.h"
 #include "bpf_filter.h"
 #include "net.h"
+#include "openclose.h"
 
 struct io_bpf_filter {
 	struct bpf_prog		*prog;
@@ -38,6 +39,10 @@ static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
 	case IORING_OP_SOCKET:
 		io_socket_bpf_populate(bctx, req);
 		break;
+	case IORING_OP_OPENAT:
+	case IORING_OP_OPENAT2:
+		io_openat_bpf_populate(bctx, req);
+		break;
 	}
 }
 
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 15dde9bd6ff6..31c687adf873 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -85,6 +85,15 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	return 0;
 }
 
+void io_openat_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req)
+{
+	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
+
+	bctx->open.flags = open->how.flags;
+	bctx->open.mode = open->how.mode;
+	bctx->open.resolve = open->how.resolve;
+}
+
 int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
diff --git a/io_uring/openclose.h b/io_uring/openclose.h
index 4ca2a9935abc..566739920658 100644
--- a/io_uring/openclose.h
+++ b/io_uring/openclose.h
@@ -1,11 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include "bpf_filter.h"
+
 int __io_close_fixed(struct io_ring_ctx *ctx, unsigned int issue_flags,
 		     unsigned int offset);
 
 int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_openat(struct io_kiocb *req, unsigned int issue_flags);
 void io_open_cleanup(struct io_kiocb *req);
+void io_openat_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req);
 
 int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_openat2(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.51.0


