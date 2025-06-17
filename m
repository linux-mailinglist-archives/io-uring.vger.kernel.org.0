Return-Path: <io-uring+bounces-8385-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0C7ADCBE4
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:49:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2FD41765C9
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 12:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F35628BA9C;
	Tue, 17 Jun 2025 12:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HCGZEutD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48027296177
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 12:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750164568; cv=none; b=fvF8gHYLJ0zRYC+nXe7g/j4imZfePGJqeOxGriLvdInwx7lszq0V+Oe5uzl5yzbu6v9NoMUagDlQbPxHZDBTk7DDqNfRO5kwnAopcaZsmm2v3scSZyDEN6aEQYPd26PTBEgpk3buQdZsaKrsVuibGJ2Evs9nO9NOH4+YpCZtjqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750164568; c=relaxed/simple;
	bh=k8F17MOUPZsgftWmo+Lrf+Sa9Vz5/BiQgUFi4lb2ZZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0X182S4L4C9M69sVcbsS+JQF5YjihmWapSHSa7ahc9sr0PT8stKtINgM+XCdqgh3/kdolVUVFBNucvwno7/XwzOAZptWhmyne9GP+XhsZ480avLtnok+IeNoVQLp1bT+nsUJPnUJ6iUrSHnOsg96Si0IisZVwpW2ioJImppiQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HCGZEutD; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-8723a232750so567855139f.1
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 05:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750164565; x=1750769365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZdmXf2lEkRpVE1uNCbQri56d7AotK9thgp+39Bxens=;
        b=HCGZEutDwEhtXtRGwvj7AhSjFQNeD9dbni+HBVWanGWrirsNH2tEvVJgzvL7htKDod
         xQAwZ+ih4yGFpIyT3eJqJzVqEMGDu3y8Hqlx/HvC20c7yRhftfS+BBrRB/nCfyiIAetz
         M6i74qfS79BMhZcTaqBmWTCs5XnRhH2Tu91o8s+VPcO9NxqNzd8U2dDhPqK/vtcr6aL7
         2I+nFIyBhOLXY7EsSvlzm7TrKyc90YOyWe1D9vuyt1OZ54GwaHwZf5uSKwquQYQTNueY
         OYP6OEvL/dzZmVvVEzVoKEqpnaW5KCsDIVqinG1StTUtIEqKqxK9rXCbvZsG2b0mlmrQ
         bOtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750164565; x=1750769365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GZdmXf2lEkRpVE1uNCbQri56d7AotK9thgp+39Bxens=;
        b=CXM/xbhOCz5+5CGhtxJuN5WmKILrX5PFY2W+I6L2GzXfwnaIAF8TgbjVUxKG/mrTB0
         e6WOG56HItaShV/gaB2hx4uG9cGY0OiYWQN+TqULtPBzHqXqfjTKijReoJb/HmtR0Kbz
         iAoqMb44+SDdBRa56j+4PdjTsuvLvWFMckcqc9m8WX5sTE/GU9O5I1+I0B091o3S7iUt
         T5U9LeSNkfiqNbOkFISb65bMpv2IGQFldGhjKfYmCnSeNdtD5mS3v3twMalgSLdbHwaO
         rJMP9AkKLbxpcIeGqAgtGGRxnhqbnvmkXXJbQ03mDgmn3+XgPhb3+GB4RJ5FZWXqSCFs
         zXAA==
X-Gm-Message-State: AOJu0YwI0VC/qiI4rwfRumf/hfe7EnTH503nEC1KlAlefT128VVDg7No
	fvp9URZEzgn10D8fzoZjI1qPTNuwYqY4hYvYpDFgzvtOc0YRnn6x/5ZaClZo/niOEREpuo/0mzf
	lOR7V
X-Gm-Gg: ASbGncvK2D+9XbovArOy9W84C45jmqSHb0z4P4zda28TQLaxBJjbygZe9Co28sh8eD1
	4F7YN+NWRcoWIh+fnRxJmw0W0Lt/+1h/f4o18APzH+wDomtwHSzLUoIv/+hNSdcZuTrnTyNCsYt
	2eC8rqpyjaE2BTuvkh+IfZQoCBmC1U+cd+O+YBwXBzDOwvc6fuuZBCiljRG3/SeoxFPOeTmYQY4
	y1YSPKS9l3MMLOiC3EWw9g4nYjUCR2gtRohfwn+JR4qslXzHhOwlhOCszJahYxrsJyoim4yWaR+
	+y7ajNgEDEp+6Nw3JtFzOyramHxez2VTtwuBUy2bqSnJoA==
X-Google-Smtp-Source: AGHT+IHLzcubUNDXYCbElXHOzzg88I2efGDeErXF4ygMqfcEVLcZhM7rO3ruCVoNihTIXIFv1DRsLg==
X-Received: by 2002:a05:6602:2dd0:b0:875:b998:7ff7 with SMTP id ca18e2360f4ac-875ded73249mr1712254339f.3.1750164564813;
        Tue, 17 Jun 2025 05:49:24 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50149c6c900sm2161057173.76.2025.06.17.05.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 05:49:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: remove duplicate io_uring_alloc_task_context() definition
Date: Tue, 17 Jun 2025 06:48:31 -0600
Message-ID: <20250617124920.1187544-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250617124920.1187544-1-axboe@kernel.dk>
References: <20250617124920.1187544-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function exists in both tctx.h (where it belongs) and in io_uring.h
as a remnant of before the tctx handling code got split out. Remove the
io_uring.h definition and ensure that sqpoll.c includes the tctx.h
header to get the definition.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.h | 2 --
 io_uring/sqpoll.c   | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d59c12277d58..66c1ca73f55e 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -98,8 +98,6 @@ struct llist_node *io_handle_tw_list(struct llist_node *node, unsigned int *coun
 struct llist_node *tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries, unsigned int *count);
 void tctx_task_work(struct callback_head *cb);
 __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
-int io_uring_alloc_task_context(struct task_struct *task,
-				struct io_ring_ctx *ctx);
 
 int io_ring_add_registered_file(struct io_uring_task *tctx, struct file *file,
 				     int start, int end);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 268d2fbe6160..fa5a6750ee52 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -16,6 +16,7 @@
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
+#include "tctx.h"
 #include "napi.h"
 #include "sqpoll.h"
 
-- 
2.50.0


