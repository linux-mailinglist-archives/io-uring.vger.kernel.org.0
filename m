Return-Path: <io-uring+bounces-6873-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B325FA4A6E3
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 01:16:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 628E6189C606
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 00:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C7C11CBA;
	Sat,  1 Mar 2025 00:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="X4uQgNFp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f227.google.com (mail-qt1-f227.google.com [209.85.160.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0445B664
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 00:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740788177; cv=none; b=dqUbjbqLvB3XjRc1DgrmEt12syaPpywpsv7DDd82WdGTVnm8Xre9VTSKxw0ob7bzkm0ZzJgP8ex4ARsF5ngOz8WA7CgKHKe7CoNSSqIVDqWeyjiviScf5cWMMOEQsvUXLjmDT4dSggbJs0yv3qpYD+ImyPF69nvGz9ga21omuMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740788177; c=relaxed/simple;
	bh=4hMsOKF8Z/yO+NqEsxZWBSKHFvNbXcp5QYOUrmQ6oIM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pcHI2FqnCW5TiurmDZ0tLD5VX5KWIlAbVQ4A8Nk2puIeYPx78RqkVlRLgIc96Ux95xsX3VC3Dj/ii6YFn/OVlTh2O9CHvKUGKpJ5EJKJm+/M9rDR82nEpUEEZcEw4CGFqYkt6sMDWqCXyaSxpbgo86AxY/ne90LxzYus8Ic3s4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=X4uQgNFp; arc=none smtp.client-ip=209.85.160.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-qt1-f227.google.com with SMTP id d75a77b69052e-47213299363so3533521cf.0
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 16:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740788175; x=1741392975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hxj+5zFTIPMH7w6ZRnBk60oQjP9P4xpyjsa1wNR06yU=;
        b=X4uQgNFpM36XkrCJupHi6XgVebZiTyuEVrFhkG7hSEN2dFG/3g3/j5b19YLFMestgl
         eZ8LCVFhfs6XBoWVBuf2Bh38pgOPPgm5ype6F9jg7jRKKR3wuPLyXFYZ7yQAJF1o7YAW
         rG56w5RI1iLJQZBOqj3mTjFmwU09K8IugxuSa2gUBHrvQuPApj5gJmGxzQ/1Il/fBkfE
         KyP2ZBZHr0oQmbrIL7WmoBQqs4gQZau/4WRRHwurXymGD08pyQn7G4TRY2gzwwSylGI2
         Yul5UqsjgSEPQIbD4SWF8uVEUjp/wrIBpCGI1wqwBeoPiz9TNqLRCbORJRnfTzR+wUxX
         x9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740788175; x=1741392975;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hxj+5zFTIPMH7w6ZRnBk60oQjP9P4xpyjsa1wNR06yU=;
        b=C1B2YWB5ky1Mq9hTghfatK4pc9mtFqC/TXPRIDdFId9ii3VfutfQx1/4+TOLvXCBJJ
         TR+NtZPpInPBG/XhnDWXCi4gr/qpVKHChQYMJqUSOroAdy4lXF0xJaBMt1+DcZh3aa3s
         ef9q38yb/EWrd04+/AuxsKeQ8/vRDTr+CdMhFGwEYZ3Ae0o+BMZCmRPseD6Ow28kpU2X
         7kdz6ASTxLiXF3f92cWp4q5rg9ZxVkxAwOqn7LeIXwfuiStJRffxlB7zbo2BvH+HObli
         7i/Bbt+HosSODKvXfaoe3MRctYM/M/2piMXLjqamgCKCuBZn4KmOsNbM61f1eXtiQOOx
         Ga2w==
X-Forwarded-Encrypted: i=1; AJvYcCXc6Zhzbs97w40qF++HcqEuoEL27KuanxgFdw+lk24KxRx4JHGq43twYsCo5N79PY2tta6cuH22Hw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwA8K6PUpfoNV0HSsI5/k8dqBY1/5XZmX9RxPYxqqBkGamP5TpQ
	dMpNK5OCqsbwHj/Ku5ZTULeN94xpoaCYedrfoSlq2HP2E8GW3Paq4T8A+OmrdOL0MN9AQaiCOCF
	aC+5eEYOvinIVVWIloy9CP1KlCgK9uDRhLmXac7iQjq+cW7wT
X-Gm-Gg: ASbGnctauhr9aZIxRt5RigsejqF9/uUgbEY9pWemXCdzglnTeEzW1fXQ1u4y+GtyE/j
	qr+lp0TGj5If7fjmgWvRYfosJwy9MzKbUx34okW+ziZnSZH/0CwJyp7uzudSU8ZPx6Sv7DaS/7V
	r2sRU4YkkGqFz531BaSwpeSfIKmOVfnBPlEByH5QFimhWPxXIA21WQoJnFn5dtuuTi+iqaoK9Ix
	5GpbLfA+XfihSntU9F+8F/fTiMlHhAT+RVAJfkZ7ms3WeqXcMEZg0K0pDLu8dHW/8eZ7xEV/1hn
	pttdsFvN9YlX+HX5aTF/1weGtFI+xGXByg==
X-Google-Smtp-Source: AGHT+IHguvY06BDl+ZarmWIdL/s0NMRf39nRdnunRIkL+vsRrLv/O43lL6h3pnJa268Y04LlLuKMdVdi0hLj
X-Received: by 2002:a05:6214:1c4e:b0:6e6:9bd4:82a2 with SMTP id 6a1803df08f44-6e8a0c7da71mr30408066d6.1.1740788174710;
        Fri, 28 Feb 2025 16:16:14 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-6e897604364sm1893876d6.27.2025.02.28.16.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 16:16:14 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 224FC34028F;
	Fri, 28 Feb 2025 17:16:13 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 191FCE419EA; Fri, 28 Feb 2025 17:16:13 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] io_uring/rsrc: declare io_find_buf_node() in header file
Date: Fri, 28 Feb 2025 17:16:07 -0700
Message-ID: <20250301001610.678223-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Declare io_find_buf_node() in io_uring/rsrc.h so it can be called from
other files.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.c | 4 ++--
 io_uring/rsrc.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 45bfb37bca1e..4c4f57cd77f9 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1066,12 +1066,12 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 	}
 
 	return 0;
 }
 
-static inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
-						    unsigned issue_flags)
+struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
+				      unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_rsrc_node *node;
 
 	if (req->flags & REQ_F_BUF_NODE)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 6fe7b9e615bf..8f912aa6bcc9 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -53,10 +53,12 @@ void io_rsrc_cache_free(struct io_ring_ctx *ctx);
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int type);
 void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node);
 void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_data *data);
 int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
+struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
+				      unsigned issue_flags);
 int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
 			unsigned issue_flags);
 
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
-- 
2.45.2


