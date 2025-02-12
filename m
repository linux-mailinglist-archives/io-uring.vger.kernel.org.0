Return-Path: <io-uring+bounces-6382-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C0F8A330FC
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 21:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 848643A8AEB
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 20:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76EC7202C52;
	Wed, 12 Feb 2025 20:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="SsQzcMpj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750C62010F6
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 20:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739393170; cv=none; b=ob+ZNY3ez65Kx5PshO7x9FqJvZkU2PYYfHRSF+f/QB/ebMu5aPu631IyJPy5s7gpWZnx73C83YQ+rqVG09pOHtU9unFMIvjfFZmNgbWb5SHT50tfoC+mD2NrazsXg7Xv+cduKtXC0oDUDkqy8LRf/1b6EYdfjOu6494f/J9TomY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739393170; c=relaxed/simple;
	bh=eeT59URkB8BtNx633XNrD7bxhoHpewE+65P5H0rT0oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFSdlj9UJT31r3emCG5XabPu/y50uiwzhwscBIA5ZiwxoBgVnpi3K1TNIxNa3mtiiSWoVUiSdhCA6Wck/HLUXNYoA+RqLFQo1dEzRbJSeHQL9GULExDUzp5JSgK7WxDiHW1eqPbUqIvC7w++ExWkm7pkSHqPnJnOVBY3BeTZMRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=SsQzcMpj; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-2fbf706c9cbso44327a91.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 12:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739393167; x=1739997967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oPNijH5Sc3nr2XmbysFEspzjbNv2CMnY8sx3nT5qMWI=;
        b=SsQzcMpjTCck10euX3vb1V7WFAcLvIwA/86YqNu4EYBIId1d3ZNcw7RA4IJYtbIlI4
         wnklpCs7tYZSOktTP2PCcqzIvIKfzBclgMue+2a3OT75zjcbCrXys2/BUfvSF2Pl+LaS
         cB2/K2q5U9Y/J15B7yeCOHO4RHZaC2LpY9VFvIXTdbPnuo7upeEBzb9DZvfVOgzyik1q
         TEVCWL0t6Fd8sbAydgFcZIoMBzVCNMy7nFvtAwDRrUR0KKpFA5Ye+7HMyUvampJi0GJt
         JWf5TFsKk/car9IsSZGXKIERs6MSaXYSUkC0Z0x9OCCdY5L3KJO5/br9ao8Xay3i/lpz
         5zYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739393167; x=1739997967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oPNijH5Sc3nr2XmbysFEspzjbNv2CMnY8sx3nT5qMWI=;
        b=D9+CtNX3G8MBwwswrfoTjqTDZrS/eiV/sEl90V5FKYEGaX7Ln0GxCg00OYUEZC2fcx
         VPoRrxv9bdX4p9ePkWFlQIEw4cH3Pi9oKY0jhpbGQS7LHD0yjt+/bYSD2ysplUbvhccn
         mjxzRiNkcZ3/hPtmFsXuOovfzmfBZFUAwm+47IPkKRycPW1hEpXZKcfP6rxp2Tn1hfbk
         JIw+S67OxLzd22MGJtciS5RPKVo3rgmw5it7uAdKfl6OVWqGcbHzqXOgsdCUclBYeUTp
         CAa+B5zqJCmkYY5G0wOmJAXtZ1VDcPmVpF0y8oIOCFTxr2hc6Ik+EWrv2m6ZnUydXksR
         h88A==
X-Forwarded-Encrypted: i=1; AJvYcCU1xL0LV7fLuSVJVnFIOMCJgQXPEeKlc1CZhXFvX3qjMNAQIudJWh1k8o8Il03731eT/oUuRf16Vg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzwGAIq/stV3horpluGl+6q40gCbVaGJpSghj/qLdnZ8pXAiORf
	nlTzw+2zLSg4iGKIOVn79hlmAbg2Ub4m+a80ZVqz8cMBkrhDxFs9WaBGWBlv8acOQJBmM8P36Ee
	kx0modp9Db1UJzDIN3j9KR54se/ldJZ19
X-Gm-Gg: ASbGncti24UM84iF/HpAWH/rORP9HGKjNayvmvalpseEZPFwjzveURAoYeBe9YF4TBU
	xmPZpki7ffvzgtGBKCCFmxYWKvB5yWnLCDmTmz5qkygSz4neUgIOjd+TZ3BSUkGWxBBtS0QAEFu
	LMxjM6YTi/EGWHAsSAwhOW8CC0KDIaN/O6mWikpL5pXGoLGm7Nw3G40GdGb3hkCmDJqUSAxs8e8
	cclCy3WU3qfy0pp40Ufda5+ks4+nrbSyQRJ5Qeoyw3FPU/aBxFIYaeXSRhi8FckKVOViE0dl52L
	5M/y+jAARkhLzPz/oQMlolpujyBJABLQekqJZQ==
X-Google-Smtp-Source: AGHT+IEGGGYFBXQjVOXTA9A01ACW598Eb6VOLJN33xDmsi02G3BvTVlhYf6Ii7mAGdq/sBr0KLz9S/+1QQxO
X-Received: by 2002:a17:90b:1807:b0:2ee:a558:b6bf with SMTP id 98e67ed59e1d1-2fbf5c79d4emr2804484a91.8.1739393166677;
        Wed, 12 Feb 2025 12:46:06 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-2fbf98b9449sm129276a91.4.2025.02.12.12.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 12:46:06 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id E55423401A2;
	Wed, 12 Feb 2025 13:46:05 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id E1AFDE419A0; Wed, 12 Feb 2025 13:46:05 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Riley Thomasson <riley@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 2/2] io_uring/uring_cmd: switch sqe to async_data on EAGAIN
Date: Wed, 12 Feb 2025 13:45:46 -0700
Message-ID: <20250212204546.3751645-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250212204546.3751645-1-csander@purestorage.com>
References: <20250212204546.3751645-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5eff57fa9f3a ("io_uring/uring_cmd: defer SQE copying until it's needed")
moved the unconditional memcpy() of the uring_cmd SQE to async_data
to 2 cases when the request goes async:
- If REQ_F_FORCE_ASYNC is set to force the initial issue to go async
- If ->uring_cmd() returns -EAGAIN in the initial non-blocking issue

Unlike the REQ_F_FORCE_ASYNC case, in the EAGAIN case, io_uring_cmd()
copies the SQE to async_data but neglects to update the io_uring_cmd's
sqe field to point to async_data. As a result, sqe still points to the
slot in the userspace-mapped SQ. At the end of io_submit_sqes(), the
kernel advances the SQ head index, allowing userspace to reuse the slot
for a new SQE. If userspace reuses the slot before the io_uring worker
reissues the original SQE, the io_uring_cmd's SQE will be corrupted.

Introduce a helper io_uring_cmd_cache_sqes() to copy the original SQE to
the io_uring_cmd's async_data and point sqe there. Use it for both the
REQ_F_FORCE_ASYNC and EAGAIN cases. This ensures the uring_cmd doesn't
read from the SQ slot after it has been returned to userspace.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 5eff57fa9f3a ("io_uring/uring_cmd: defer SQE copying until it's needed")
---
 io_uring/uring_cmd.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index cfb22e1de0e7..bcfca18395c4 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -166,10 +166,19 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
 		io_req_task_work_add(req);
 	}
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
+static void io_uring_cmd_cache_sqes(struct io_kiocb *req)
+{
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	struct io_uring_cmd_data *cache = req->async_data;
+
+	memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
+	ioucmd->sqe = cache->sqes;
+}
+
 static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 				   const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	struct io_uring_cmd_data *cache;
@@ -177,18 +186,14 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 	cache = io_uring_alloc_async_data(&req->ctx->uring_cache, req);
 	if (!cache)
 		return -ENOMEM;
 	cache->op_data = NULL;
 
-	if (!(req->flags & REQ_F_FORCE_ASYNC)) {
-		/* defer memcpy until we need it */
-		ioucmd->sqe = sqe;
-		return 0;
-	}
-
-	memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
-	ioucmd->sqe = cache->sqes;
+	ioucmd->sqe = sqe;
+	/* defer memcpy until we need it */
+	if (unlikely(req->flags & REQ_F_FORCE_ASYNC))
+		io_uring_cmd_cache_sqes(req);
 	return 0;
 }
 
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -251,11 +256,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
 	if (ret == -EAGAIN) {
 		struct io_uring_cmd_data *cache = req->async_data;
 
 		if (ioucmd->sqe != cache->sqes)
-			memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
+			io_uring_cmd_cache_sqes(req);
 		return -EAGAIN;
 	} else if (ret == -EIOCBQUEUED) {
 		return -EIOCBQUEUED;
 	}
 
-- 
2.45.2


