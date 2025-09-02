Return-Path: <io-uring+bounces-9531-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2D77B3F1EB
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 03:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6784917FD0E
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 01:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2DDA2DEA97;
	Tue,  2 Sep 2025 01:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="VvrkGPvZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275F528725A
	for <io-uring@vger.kernel.org>; Tue,  2 Sep 2025 01:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756776813; cv=none; b=eLgf+XOtS+qO00z1972l8Be2NeKDzk+TiwUx2wdIlDvmjJ5tAG9zuDvh5qLDjdB7KsbflccqoRVNdV6OfpNqkNa+LPlMIWDQvQk26s2dmqvxKQjSV3X25DmoDZI2ONE6XIj5jfZmCHl9kM1H6iMKG/37lUp8hKKfbc0bCVba2TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756776813; c=relaxed/simple;
	bh=2YsAuU9Q6pFZYBD4YIVLPsPJ6+ZyQoKmksaP5ZOibHE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mp+hdDcSHqmMF+5fVmoyKRNmFzazVXs2uXhugTKCc5MbBX5gIUzM82tShLjKCK2cAvtpqfGy8e3YomibKLnnICWQTVb3I541bo0UQB4Si2Ud1BPOZCdOHgqwDN96SG8UlZ6yJgKVQYfl6s1pJR0Rgw9qqAzdVlt4T++K2InuLs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=VvrkGPvZ; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-b4f18ddd8c3so65771a12.1
        for <io-uring@vger.kernel.org>; Mon, 01 Sep 2025 18:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756776811; x=1757381611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tApxxDHtl1zCXhBCC76r6xxWiaU0tPGEcHjM+O4IQNw=;
        b=VvrkGPvZNziWc27vjL0LKr+QFMmWC0Mic0iY7oKKgUNfFvWps8Hgk3QLb29iQGmToq
         CBKIGUZ9R71MQEsheTOF9j1S4GkjYS8HB7UlxY56G7u3tq6ew9f8g2N/IGrUbTJ3HQ34
         Rc8AFUfMtbK3HXh8Sn3YQ6RohG/rGPd/QCZfUqxWCvF0REUf3MxekwboJrT+ARpUnjsE
         QXF1x+aAUfRYqYFWCm2K8rigeqGULioDaj9PbXdawrhpBN6VJ38Nq22BzpAD94sg4gsW
         mmijf84AAnXoVUKqAhhFC30uPcOWF1Hg2DAw3cWeondMrc6wD1vlT4RBuSC+vGdEm3OZ
         4P2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756776811; x=1757381611;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tApxxDHtl1zCXhBCC76r6xxWiaU0tPGEcHjM+O4IQNw=;
        b=wTesTPRVYk8BHhmd9cIgZ1okOzO37QKnxOZjIekdaiIAddDi+rdl3EeUQv42TMKbp0
         6rvhcHiZLOpDQJgn01nmr7nmTpwpMitsCw0alUEZeiTNFwJlvQUNE/vAO3e7VxAvAXdI
         HKLY49C2ziZILbw5OY13AKJGVS/VtMzIJIyfTC6zOnN31TjYnKajrOB79QpOSARrEJOQ
         l1q4bfd19Y4bZ5TaBTme0EpJ7bcQ/rNAbeURX4yVd8zM/JzwOJ/o721qm3W2jBs5lLJD
         F032GdhGORjfqxTjmLRnukizOPeusb0KZ3aQdNM5v4/QvCIRQJirbFixmvIFUK/MtA9M
         JzdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIoAXH9aK7HFXfGtqOCc7GZ+1TMdDX6gpvpGB92I1CNJztuAzg22q398xG88/leE5o4aFmB4wyBg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyNiH0WDScpMZQDSMZfMMyywqDQPivecDB3yahoyN3CDT/VZGkM
	ymjvxWqz5LdKnwrOnWXtnUDRODcpkJUQFA0RlhqCUY+DttWxTACjlWgTd7hfsG8UE8TuqGSJUay
	CAu6kD9JPYqiwaX8gYbcafPLCnQ4ffD0Bmc2B
X-Gm-Gg: ASbGncviku+GAuxQVd3gDGfJNbbMVO3GyO7TRYJ997Qp+NvCgGgo4o9Bm6xnUUqvNqa
	WdhY/QYpyAZXncbU3dDpY2es/AchyZSd54gvEQ7+RZpRoOlqJL40ORxnHm3SIDI0JOSl2zeeQUl
	yxy4pEvhabjA9VZszmKb04gLQ3xVHzLEfLDsMElFUuARona+rdXtNhJ8pVkmFVpIRX/DFxU+Gft
	zlAviHnPV5T28psHUs4Ii0rrBKZtRHlIWJvmF5tT0297H1Ek4SRkbbVE5lwTxlUttERX/+7bkZZ
	+Fht+OUlB34XbWO8jrZ/jfrULOn3nvhF1UC8rNI6YZWwEq6YC7Vz+xuCFZJW/EN6qEWoQCdi
X-Google-Smtp-Source: AGHT+IHU1FqiL7D/IMH3xDzyGN84Oykg//qTxXsV/RSMqcFDXgJplTBnuFFO+SZlIBfrd/4KNCwO0v3MoUcT
X-Received: by 2002:a05:6a00:2193:b0:772:5fb8:e398 with SMTP id d2e1a72fcca58-7725fb8edbcmr2836966b3a.6.1756776811206;
        Mon, 01 Sep 2025 18:33:31 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-7722a4c8d8asm666100b3a.14.2025.09.01.18.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 18:33:31 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 8A0EA3404C4;
	Mon,  1 Sep 2025 19:33:30 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 87DA2E41A5E; Mon,  1 Sep 2025 19:33:30 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/cmd: remove unused io_uring_cmd_iopoll_done()
Date: Mon,  1 Sep 2025 19:33:27 -0600
Message-ID: <20250902013328.1517686-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cmd_iopoll_done()'s only caller was removed in commit
9ce6c9875f3e ("nvme: always punt polled uring_cmd end_io work to
task_work"). So remove the unused function too.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/io_uring/cmd.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 4bd3a7339243..7e38d4512b6a 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -128,21 +128,10 @@ static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
 {
 	return true;
 }
 #endif
 
-/*
- * Polled completions must ensure they are coming from a poll queue, and
- * hence are completed inside the usual poll handling loops.
- */
-static inline void io_uring_cmd_iopoll_done(struct io_uring_cmd *ioucmd,
-					    ssize_t ret, ssize_t res2)
-{
-	lockdep_assert(in_task());
-	io_uring_cmd_done(ioucmd, ret, res2, 0);
-}
-
 /* users must follow the IOU_F_TWQ_LAZY_WAKE semantics */
 static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
 			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
 {
 	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
-- 
2.45.2


