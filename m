Return-Path: <io-uring+bounces-10198-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EABF9C073EB
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 18:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2063E1A679E6
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 16:17:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB0226D4DD;
	Fri, 24 Oct 2025 16:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="VRSyGVwO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f99.google.com (mail-ed1-f99.google.com [209.85.208.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A86A1E5B60
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 16:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761322608; cv=none; b=cDkNUutsEojh08rB8fFLLjpR/1tD+5Y9xIw8vV8EAt84qbSOE3ZguHpXrJNQFh6caKV/wchdAnhH44wNBZAOOdAJz5M2WdBXKiDGZQgiKEmCYUmvnREd/tDm6GixixZ9FuPS2ESVdool+N43sHZXJZllo/WMY2j43hlv4PXK9yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761322608; c=relaxed/simple;
	bh=YomMeTWUJ6G46aIP1D0t9jfDvY9NgzXbyID3QyTXYtI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jzELKUAjVtv4Knspd8dliq3MIhUZYB629k3mifQfKd0wFDg91pxxoYIm0OvKQK+tuPkf7pC7i5DvNwd/1Gg5/7z4elcJx8ZvBo0QSYI4rKG1ZmRH9UoTbur1nruWXb+w4vTn7Fb3sKi7jTE7TBmcdhU891JBkvg6Ns3G67tv/b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=VRSyGVwO; arc=none smtp.client-ip=209.85.208.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ed1-f99.google.com with SMTP id 4fb4d7f45d1cf-633b4861b79so399417a12.1
        for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 09:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761322604; x=1761927404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uD5SEY+RcOlfAFX96OUUMkucvjgpoTTXRCwQAyCSH6M=;
        b=VRSyGVwOpnQEQN7AHNBWcEZtQAH0MP65OkuG72+6lKx2rF3pCJRYDmsn+3+YWT9jbg
         Cl/CodrbXnCoDh7Wf/inFicu4ygrqxzKvB54NOsn3U52jC/qxskCwWN5N7dEWHwCHbd0
         IydUTay7CHqefwf3z1++aZ71Z0kDMw4ADphsJUlvBCEtN6wxqjoI2gCaqPHp+JlgIzeN
         sK/Njg7ipZcznJpek94eZ0xNk8G/tRlYIilK8Ieyc5WrTE8AQ4bxvWRX21H0gxIb4GpK
         vPEDgW2vN4ltiervCZziN3FTCMFgaNwL/FEmr7zc+j1E3POLamVAt1a4ezDiMSWcFAEI
         sEiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761322604; x=1761927404;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uD5SEY+RcOlfAFX96OUUMkucvjgpoTTXRCwQAyCSH6M=;
        b=Kp6iA1bJ/IWC9ruVBd0cnP6jrfR5IstUsM9r3601DTASxVeVKwOHnPjN4F2lBPboXe
         6kyqGjRImhw9GuARg1otQsnlnHkMuYAYdm3gA2oOQFtPriWmi5kExnZRk4tZk7D0XGfx
         chrgEKQw8YEpuEXevxax6v/L569ATjOeYH0her3zB0cCCpHNDVTVVBzHWIHQ/Ta7rlLm
         89h8Jj3yIO8exaCcX1bgWPdRDZAB+1EFTtt7ykgwP/8LTDRvLYunJEY8/juNY1kaL/Fq
         uypGvvB7gBx/SZzs5E4AP1+mz182WbO2rqK7CtiH9UhEcgOgOz37arFBDLp5P+dQgYJ5
         vXSQ==
X-Gm-Message-State: AOJu0Yx3pTX6Bk9aDcCswwQhrC1A4OF8HmaY4mH6GHbfnVGmNUrKRfiC
	b4l0ByaCDwidsYqtdD2yEWkGN5nFdTb9EOSq/YV5o11BBFf0jRbRetHjWAR2bWAt/N4B1PMJVON
	Bqa1ktdph/qDHczzbeYtGisInnkMc7xogqLPECmiQQjO+GaJZNTma
X-Gm-Gg: ASbGncvueZGFBHleV+pXwU2Z+13G5dkSnzlJjRj6ms3JSgDYG8cMP+WoVNiXoUklHP4
	uxMqTySsgKxuQznfKRJhuY/R6aJvHEuSpk3meV/g4gV7zJk6cntt0rFnH3kBw+0BhSCw2y9fBNT
	syPOaRtSj8greFFUEAEBR7v4L1ElcIGKK1M3//Nr48bt2PZ3OAOI35Xuz2bES2Q6Qg65BSaE8Hj
	AjY0IrrQEiOKyqLJR9K6vGV9EU/NB2iSn1eRMmTuzv09Q9F3quX85miqQHRxpHK6JBJGmxM/lAw
	ASpAtI0gcYF1R7VCithocTnwl3/IagebGWRGg5A1IbWbikuRKAn3nByW1i+lCKcO+LcdwjY4/XI
	ncg+U1Z/rSE+DyTvB
X-Google-Smtp-Source: AGHT+IG8gFXuIVrlLTWGUD0g0EOZLXyjJX9chpxv4yvhTOB1IEBXXJTsiJvcaStjG4vwLEdZRXnJyJnr0kjt
X-Received: by 2002:a05:6402:510f:b0:637:e361:f449 with SMTP id 4fb4d7f45d1cf-63c1f6213bamr15532654a12.1.1761322604347;
        Fri, 24 Oct 2025 09:16:44 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 4fb4d7f45d1cf-63e3ebcd3e0sm400844a12.9.2025.10.24.09.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 09:16:44 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id EB517340150;
	Fri, 24 Oct 2025 10:16:42 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id E1EE8E4066A; Fri, 24 Oct 2025 10:16:42 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH liburing] test: remove t_sqe_prep_cmd()
Date: Fri, 24 Oct 2025 10:16:36 -0600
Message-ID: <20251024161636.3544162-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

t_sqe_prep_cmd() does the same thing as the recently added liburing
function io_uring_prep_uring_cmd(). Switch to io_uring_prep_uring_cmd()
to provide coverage of the real library function.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 test/helpers.h   | 7 -------
 test/mock_file.c | 6 +++---
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/test/helpers.h b/test/helpers.h
index cfada945..6317dcf2 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -127,17 +127,10 @@ int t_submit_and_wait_single(struct io_uring *ring, struct io_uring_cqe **cqe);
 size_t t_iovec_data_length(struct iovec *iov, unsigned iov_len);
 
 unsigned long t_compare_data_iovec(struct iovec *iov_src, unsigned nr_src,
 				   struct iovec *iov_dst, unsigned nr_dst);
 
-static inline void t_sqe_prep_cmd(struct io_uring_sqe *sqe,
-				  int fd, unsigned cmd_op)
-{
-	io_uring_prep_rw(IORING_OP_URING_CMD, sqe, fd, NULL, 0, 0);
-	sqe->cmd_op = cmd_op;
-}
-
 #ifdef __cplusplus
 }
 #endif
 
 #endif
diff --git a/test/mock_file.c b/test/mock_file.c
index 0614c09b..0f6460fc 100644
--- a/test/mock_file.c
+++ b/test/mock_file.c
@@ -44,11 +44,11 @@ static int setup_mgr(void)
 		return T_EXIT_FAIL;
 	}
 
 	memset(&mp, 0, sizeof(mp));
 	sqe = io_uring_get_sqe(&mgr_ring);
-	t_sqe_prep_cmd(sqe, mgr_fd, IORING_MOCK_MGR_CMD_PROBE);
+	io_uring_prep_uring_cmd(sqe, IORING_MOCK_MGR_CMD_PROBE, mgr_fd);
 	sqe->addr  = (__u64)(unsigned long)&mp;
 	sqe->len = sizeof(mp);
 
 	ret = t_submit_and_wait_single(&mgr_ring, &cqe);
 	if (ret || cqe->res) {
@@ -66,11 +66,11 @@ static int create_mock_file(struct io_uring_mock_create *mc)
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
 	int ret;
 
 	sqe = io_uring_get_sqe(&mgr_ring);
-	t_sqe_prep_cmd(sqe, mgr_fd, IORING_MOCK_MGR_CMD_CREATE);
+	io_uring_prep_uring_cmd(sqe, IORING_MOCK_MGR_CMD_CREATE, mgr_fd);
 	sqe->addr  = (__u64)(unsigned long)mc;
 	sqe->len = sizeof(*mc);
 
 	ret = t_submit_and_wait_single(&mgr_ring, &cqe);
 	if (ret || cqe->res) {
@@ -88,11 +88,11 @@ static int t_copy_regvec(struct io_uring *ring, int mock_fd,
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
 	int ret;
 
 	sqe = io_uring_get_sqe(ring);
-	t_sqe_prep_cmd(sqe, mock_fd, IORING_MOCK_CMD_COPY_REGBUF);
+	io_uring_prep_uring_cmd(sqe, IORING_MOCK_CMD_COPY_REGBUF, mock_fd);
 	sqe->addr3 = (__u64)(unsigned long)buf;
 	sqe->addr = (__u64)(unsigned long)iov;
 	sqe->len = iov_len;
 	if (from_iov)
 		sqe->file_index = IORING_MOCK_COPY_FROM;
-- 
2.45.2


