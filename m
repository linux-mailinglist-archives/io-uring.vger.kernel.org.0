Return-Path: <io-uring+bounces-9540-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5663EB40A1F
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 18:07:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 113713A3C0C
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 16:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8AC30AADA;
	Tue,  2 Sep 2025 16:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ORBapOli"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f226.google.com (mail-yb1-f226.google.com [209.85.219.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067C52652A4
	for <io-uring@vger.kernel.org>; Tue,  2 Sep 2025 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756829223; cv=none; b=FxKP3MVyXuRB2jOhMe0JRvlhH9UHXj9uUGCfN0if6JP5QW9JdbWgUqntnnIqlznOCMbTwsRFkrO3aW/yB4LfTXZgqNuwmGC9/5bEKi5yAkBYqnYZblouaXaSDvdNgbNqQbvrOYNTgGbLkWjit5bkWRrYWX0LDBYNJHOqRJd2rK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756829223; c=relaxed/simple;
	bh=oscotWeu2ofDRZ2I7B+ST50R3lMq/oklG8FOxuKuJzw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fC2Rc7ooksNkqZtTIDNQAvQbqye4cBzNCCyZOiSNREWJrHDYfY8MMRG1hSI1mnAQtKiAtqqsoeHut8zarFMfa1VWQWBoKG0oB3M8xBc3LRaSJql1aRaPe8thoTTLPI0ZxoSQMT9RMcGAvQiWMisWsItHMrcqxNQbvhaiHQ0fQhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ORBapOli; arc=none smtp.client-ip=209.85.219.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-yb1-f226.google.com with SMTP id 3f1490d57ef6-e96eb35e36cso888622276.0
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 09:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756829221; x=1757434021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RlJrQ5tmWGYzBhNWJHSwFwCHVK4G1iWt6SUsZakgOpw=;
        b=ORBapOli6/6JhTr2x9gqyDu9E5YWMhdLqsDfJG8Z4QUMslowi/Ce2a5P0jRX1Jo2Sd
         VESAeNi0/DKlSUM7eh9s8rO6cxuYN1sHAUOQBxq0NIvdZKhbKkjOKCxjEbrasRQDRCYA
         vL88jlzinCMwYwmWTIx8cUJDz5fDZ3pfQz4CZ4QMMJfpH3HrX5fRErRZpUtm00hrNx0y
         0oO6UeRsVQK1ewgzY8mmH2mTwaTbPIZvP2WUOnsEEsmqltqTZIAXZnqXq0yw8Yg7FZdd
         WiF1/9iLu8Sl2sFEGu3k2jSW6yt7v86DpU1yePnvaIKN6tnBzkQRqrCbGmmCIGfAIPdn
         YZsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756829221; x=1757434021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RlJrQ5tmWGYzBhNWJHSwFwCHVK4G1iWt6SUsZakgOpw=;
        b=AR12OSl19rFH3ufeno1TZ1qSPZj7mW0qw1elCbENQ/qbEp57vd5mv5mStGhc6K8D1m
         x1uuRTwcpVajAL7YpTeYWvTh5fAoi8Wdy41Ij0ZpnjBzG5lqjBPcUU9YNhCRatFeqbqj
         b3koa0WE2/RG8gf2Ydk/0dqu18Z5afEjdWQFSN8K1jPKxQHRUktuk7EKF2qtVhRlwLEp
         MHGpdXnJU5sWafbmR5jz16ZxD63m+YkQwNuGmgsdsVHTML/O/v9xC37IskFfaYmRJK5u
         nfIvVJc63/zSKkjNL16IiRVXGbyi0Vt37lHOreQZV7JGknyGfJiS1JBBEQWnCo7PNzis
         DFZw==
X-Forwarded-Encrypted: i=1; AJvYcCXef2tr2pxvE5wt3xZqCt9lkXXEj8PKp314rh8yOBvEzV6GNYtNuy3fXGxLAMGXZeZGR+oJrWp3rA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMEJBGnscDXIIzV9hucPHIv44zoBHQoweK+BpZ3ExhTD6/AXFN
	Kl0vTotBIhuapY2rFbwKBM9f1Vq2Fg+V3hKrSEQOSC5IMAPrxQsbpvIXkQR5/3njtRl9BV7buiA
	1/whq7N3kEYYPmgyJe1eo5zFiQ8daw2DbPpLd8hKKnf1mF0tH/LGF
X-Gm-Gg: ASbGncslDgHKkADW5UpWggBNHlRIgPopJQzMVpG0aUb034pjJzDpSMYhCZmACjRxW2z
	x8Px2a7zX1koaGV2HGhpkLIXXJ09UweQbrN6iIzEdyETqSmQ76ZvrpeJqk2bGGJDigFnUP3bkKK
	lYApPZLiHxhdD/h8MGc9EqqSAfDm/m8WdGcXL91a17TOE4lFswA8+DbsiqqX9ggBENPg+KEnCAf
	6qewICIQtgEN0YwOBXDvCXg6UAtrupNOmudwfKGX0AXzBGrfgZwWgr1C16d5yQnjbAz6jyR98Xd
	BUixG8q+Neoa2PE3bBC/VwDBPV7naus+wWcXTfuljMculbpgbV3s3x9GNw==
X-Google-Smtp-Source: AGHT+IGehGKy1s/4ECGVhm6Ytshrk21h/CKWiX53aH303nut6igUt+bsRoA2rH9L1NNTY357MPkA4BL/eq2s
X-Received: by 2002:a05:6902:1148:b0:e97:604c:ce6f with SMTP id 3f1490d57ef6-e989be98834mr8924297276.1.1756829220457;
        Tue, 02 Sep 2025 09:07:00 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 3f1490d57ef6-e9bbe1a9f19sm171338276.17.2025.09.02.09.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 09:07:00 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id CD706340214;
	Tue,  2 Sep 2025 10:06:58 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id C92A7E415E2; Tue,  2 Sep 2025 10:06:58 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/uring_cmd: add io_uring_cmd_tw_t type alias
Date: Tue,  2 Sep 2025 10:06:56 -0600
Message-ID: <20250902160657.1726828-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a function pointer type alias io_uring_cmd_tw_t for the
uring_cmd task work callback. This avoids repeating the signature in
several places. Also name both arguments to the callback to clarify what
they represent.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/io_uring/cmd.h | 13 ++++++++-----
 io_uring/uring_cmd.c         |  2 +-
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 4bd3a7339243..7211157edfe9 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -9,15 +9,18 @@
 /* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
 #define IORING_URING_CMD_CANCELABLE	(1U << 30)
 /* io_uring_cmd is being issued again */
 #define IORING_URING_CMD_REISSUE	(1U << 31)
 
+typedef void (*io_uring_cmd_tw_t)(struct io_uring_cmd *cmd,
+				  unsigned issue_flags);
+
 struct io_uring_cmd {
 	struct file	*file;
 	const struct io_uring_sqe *sqe;
 	/* callback to defer completions to task context */
-	void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
+	io_uring_cmd_tw_t task_work_cb;
 	u32		cmd_op;
 	u32		flags;
 	u8		pdu[32]; /* available inline for free use */
 };
 
@@ -55,11 +58,11 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
  */
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, u64 res2,
 			unsigned issue_flags);
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
-			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
+			    io_uring_cmd_tw_t task_work_cb,
 			    unsigned flags);
 
 /*
  * Note: the caller should never hard code @issue_flags and only use the
  * mask provided by the core io_uring code.
@@ -104,11 +107,11 @@ static inline int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
 		u64 ret2, unsigned issue_flags)
 {
 }
 static inline void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
-			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
+			    io_uring_tw_t task_work_cb,
 			    unsigned flags)
 {
 }
 static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
@@ -141,17 +144,17 @@ static inline void io_uring_cmd_iopoll_done(struct io_uring_cmd *ioucmd,
 	io_uring_cmd_done(ioucmd, ret, res2, 0);
 }
 
 /* users must follow the IOU_F_TWQ_LAZY_WAKE semantics */
 static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+			io_uring_cmd_tw_t task_work_cb)
 {
 	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
 }
 
 static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+			io_uring_cmd_tw_t task_work_cb)
 {
 	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
 }
 
 static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index f5a2642bb407..d76d6d27765c 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -124,11 +124,11 @@ static void io_uring_cmd_work(struct io_kiocb *req, io_tw_token_t tw)
 	/* task_work executor checks the deffered list completion */
 	ioucmd->task_work_cb(ioucmd, flags);
 }
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned),
+			io_uring_cmd_tw_t task_work_cb,
 			unsigned flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
 	if (WARN_ON_ONCE(req->flags & REQ_F_APOLL_MULTISHOT))
-- 
2.45.2


