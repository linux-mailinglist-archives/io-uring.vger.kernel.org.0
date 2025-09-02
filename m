Return-Path: <io-uring+bounces-9530-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D612CB3F1E1
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 03:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0B35162BE0
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 01:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F6D32DECDE;
	Tue,  2 Sep 2025 01:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ImmrXrA0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f99.google.com (mail-oa1-f99.google.com [209.85.160.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FD826C3A7
	for <io-uring@vger.kernel.org>; Tue,  2 Sep 2025 01:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756776377; cv=none; b=g9FB5AJ31UfCLTQPSZ6rMswRm8sPEZK79tOgb6D2nSaOic98GLyIL62nqBVRBoYYWjpPl5mHrqXNZpr+HOgP4S13dIB9nL66kB+IWPxowEqBc0Ugmmw2ZPH3jO1PHo09Cp6y9A+waqQXkaLhG4XFzTrDmEncmKIeyHfma0aCX0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756776377; c=relaxed/simple;
	bh=BtmRQ2JZVKQosuKD9EwRNIFM+4SVu1qxP+Nd0xQRvNM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=isV11NqvqRcFRltl4IsDzNF5YB0SOjWKPr8NA118/b4yXsV98/HvbsBGCymeUmyC6e3OKJo1awXwU2pLi+ffirl8MKTZ7gBfy1kWmGe8G/dhT+X435HC3GbnlXirCFlVVDvFiZItQ5QTmvtdHADcdxySi+SLFxSofImruqBkH0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ImmrXrA0; arc=none smtp.client-ip=209.85.160.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oa1-f99.google.com with SMTP id 586e51a60fabf-315c16f4c2aso897187fac.1
        for <io-uring@vger.kernel.org>; Mon, 01 Sep 2025 18:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756776373; x=1757381173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FuAqbXrE5OAa9YMUeCtG7mhaJFLjAeGfEFxSVF+yHR8=;
        b=ImmrXrA0xwb86CZgw82vrMZcT/01c2zKaqyV0jgSsGVzOQmcWtPNxfkZr45ybhaltY
         o7JDrno4EEAtSygV3RKNk3xZkXLh3YVkCVdcKNdW2Ihr/U+SvwXK6AapLjlwV6V5adRj
         zus+SFIFKIQIqlm1LrcEzm0Wf5eC1/hk4wfFcY3X58MHAFZpfw5uQA/TU7Am9dwDRSVc
         C8TeLm8OYu9rnduMXNwKkU1Juh7BfKWydvRV0DTEClTU0GtmBk3y3P0tfUCWcd0SegMk
         Q4pdQz942tk64VJZlVUcOqn6TYgj86DkoHSNnodlEQHBteoxePx/73HDU1ipXojBlFCq
         65FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756776373; x=1757381173;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FuAqbXrE5OAa9YMUeCtG7mhaJFLjAeGfEFxSVF+yHR8=;
        b=AemOS8O1yUnGmwWmkXJmggot4Y2C9YmjSF/7FLrUSZ6cRUoWuDM8KAXjb0vuOoeHBn
         7TQvWfHsL+oy039jgggC99XMm91WwEWhydZN11SzEk6bwgK/NSuOSIqQ9DpswUBZndMz
         S2SHGrD6DXS5NNKjKKzAm9tXIZm4JwMB7ZPCQ3gyPjUdkJMZ0FmIrhZcctHRdw6izTNd
         i9COVgSg9S33e4mbNbVPk/OKUFtEnhsi9Z3e9nSDPKRS+vh49cFBjz5mWmq863BaVc3D
         jaH7sKztTNsOhMq+oLqmh273xOtUHLPhTpYnkDfqhYw9PidWhSoGcA3oXaR0tzN1ENR+
         jOHA==
X-Forwarded-Encrypted: i=1; AJvYcCUK2VYj1CWxguG+jt3VD2/+glKpCuNLvP2q0iUU6i48T4caq/4LkpuotxX/jfuctoreLYcCerWKgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQKwWSjOPvJrtGLtF2FR5wkVCCkXEJscu9JIgzSNryGo6QDz6p
	gHDmbuNV9abHwu8ndD/25M56d67TnDSCFixgp+juIJzTv5cP1UJIJpVovRlARAca675556x/YmS
	3IzAbcjmlWhksWjYHA03HUMbHP1CKUeb8fv5U
X-Gm-Gg: ASbGnctE86VP5GjdgAF9SLe3qHexQZ/93psysRTsWUDwt9P3kYueSKFGgspMlqCcTKK
	i6pAgsVhRIRCMLKOxyE497u2G/lf+u8p1GCPyM+WrLLMnKmkbS9pYKCOR+inJ/KtkACXGZg4pS9
	jWDWrYxnG3n3Ygj0Nc/KhbbdKS/ksOO+6+KoNmrGcRSGI6vGexELAbc0WClsYh19+nKGJ5nkhFj
	VxQvJ6I8bc6xl0XVp2ISav7Mqer5C1/nF3N0amFO62NjH4649UYpDZ4p4zao3d/cETlkNi4BJc2
	/Nr8lwbEviHhx4KC+kUl4T39t/Fk+0WncM5NNenESUKgp7kfxFFL0qLkt/d8ixG1V+ZPSpuP
X-Google-Smtp-Source: AGHT+IGoMeqv5Ug0hkm/76GxajhxbOr5rO5Bbw0UFNXDEbLMN86Q44z+6+NI5zvsArM2lPrFPkWW71wCF/3e
X-Received: by 2002:a05:6870:5491:b0:30b:6ffc:4bbc with SMTP id 586e51a60fabf-315bfd6ccffmr2989217fac.11.1756776373440;
        Mon, 01 Sep 2025 18:26:13 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-319b5dad889sm40684fac.18.2025.09.01.18.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 18:26:13 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 625463404C4;
	Mon,  1 Sep 2025 19:26:12 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 5E552E41A5E; Mon,  1 Sep 2025 19:26:12 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/uring_cmd: correct io_uring_cmd_done() ret type
Date: Mon,  1 Sep 2025 19:26:07 -0600
Message-ID: <20250902012609.1513123-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cmd_done() takes the result code for the CQE as a ssize_t ret
argument. However, the CQE res field is a s32 value, as is the argument
to io_req_set_res(). To clarify that only s32 values can be faithfully
represented without truncation, change io_uring_cmd_done()'s ret
argument type to s32.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/io_uring/cmd.h | 4 ++--
 io_uring/uring_cmd.c         | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 4bd3a7339243..64e5dd20ef3f 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -51,11 +51,11 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
  * and the corresponding io_uring request.
  *
  * Note: the caller should never hard code @issue_flags and is only allowed
  * to pass the mask provided by the core io_uring code.
  */
-void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, u64 res2,
+void io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret, u64 res2,
 			unsigned issue_flags);
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
 			    unsigned flags);
@@ -99,11 +99,11 @@ static inline int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 						int ddir, struct iov_iter *iter,
 						unsigned issue_flags)
 {
 	return -EOPNOTSUPP;
 }
-static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
+static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret,
 		u64 ret2, unsigned issue_flags)
 {
 }
 static inline void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index f5a2642bb407..2235ba94d3f0 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -149,11 +149,11 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
 
 /*
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
  */
-void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
+void io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 		       unsigned issue_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
 	if (WARN_ON_ONCE(req->flags & REQ_F_APOLL_MULTISHOT))
-- 
2.45.2


