Return-Path: <io-uring+bounces-8950-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18945B2491C
	for <lists+io-uring@lfdr.de>; Wed, 13 Aug 2025 14:05:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F4D67245F2
	for <lists+io-uring@lfdr.de>; Wed, 13 Aug 2025 12:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 851332D0C7B;
	Wed, 13 Aug 2025 12:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="LmF30KRv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E16120D4E9
	for <io-uring@vger.kernel.org>; Wed, 13 Aug 2025 12:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755086552; cv=none; b=jtlU/jXNHdokRdQwglINlpguZAsPoC0EWgdEgCkqVl+4cKOQKezerZOSXi7kCAi+fhkG9I5oYrj931WSSXCTKmhjIFhY9Z3sOsKowDDcqNR5J7lnm7Kz+olO2fnKOs246RutmTZK8vMu2BPGJTIkzBE/yLAA9sgZhYM8wOltzUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755086552; c=relaxed/simple;
	bh=Y5ODJCve4cCycGhbA64XVIR9NzpaJXUpoWfB8nnryGM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GMCJvktPpTtJI/ZXL/fQDkPa3G/U8UMTDOlrP/rq/8x1M9RRDvYPWXoLc2puqoO6fWLjjgcs2d6NpLD3h0/tRW+cBbMvHMLx+gwMrqGSuXBRNebzWWfw3jyFGbyHdp2emcKP6ldNZ+6tf7X4wGO4ruCW3f8F7irCbBBDe/NS1P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=LmF30KRv; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2407235722bso64175665ad.1
        for <io-uring@vger.kernel.org>; Wed, 13 Aug 2025 05:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755086550; x=1755691350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K/a33gWoxGv6jtj2gUgSbJ0h6/gIpUnPSM4PrLUvScU=;
        b=LmF30KRvSZ2xOmdqpgt8R6+BarCBUZFffhMw4R7VkFYaDYe4ZHTYjezS3RqpsFHsim
         UJbg1+wOSTkLZq+7bZifLjwBXvEkZ7V0gaRIGV9sscZbaWYDVFt6b1iPo9lWNNE71tAs
         EDX0p+89NtLGbjuiX/PI+mAuRhQ4U+GXnbX4oa33zSqjIuTQi+d3JN6aKVoUKAlswhUf
         WB2ttVjRJM2imUr27txf69KPxNI/PPqjnMC7BETKsF9JL/ZcXMr3zCb4c158W9X/jXKF
         GXz0vQNo+NlCRFb2EEy0QmzbRFTZP3vWuOd8ePPlNwJqWZzLxxCUOR6lALvX2OjWJFY5
         3rAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755086550; x=1755691350;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K/a33gWoxGv6jtj2gUgSbJ0h6/gIpUnPSM4PrLUvScU=;
        b=HMBw9XF19BRVan8M1c/zDXrv5CnEvhMbpwBJW2OhtgyFseQ9oKjKuDZ78c0p9c95BC
         zS0jx2EhU0sbuLnbQ2S8A1Fi+U3e8bN/AArO+qrsJi7J0Z5rKTiqRy17WANiqfmb+eO8
         BXKtJj/8ByNOzqrWMtWpLaZx7tOSuB3rYFs6XKEVU07TeUGt0+6YZvdTdQrAUmdGbr6M
         kAmTxn1ot3NiWW9A6ern08PKfrykDSOGtpo7BtfECmf/u8bvsmlk0QkUOECnm45+npwX
         Ts6pN5wBXdhAUDT1Lgd5bK85EGyNl1U57XYKElthbOtnoLSbQGXLzjRkn61IkJfGrknN
         IkcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAEj912AF98NSfXp6yqGwnwS4t2A2yQZA7Q7ymbNLqBc3srjpJEm/tsBMax6gS1RhlbUAb7pvUjQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo1yYmDbo3rcp5MGcoUYlAXhMYS3DBzKiuHejmsNfVFi427hpc
	OCyPvOQVWXXo5P6NdosnDVgtqriX4yUrYCQ+3y0q65ji3H8Y1TtSO2gxyWongREvlzs=
X-Gm-Gg: ASbGncuBoBgWnO5n6TyyUm7fkHEz8c0HFhDoUj27C14EU7PfE/L86H/Yf+7QaVtehE8
	d4B8QJ7DvsiHP+Q5y2DJvMV0v7CtzkrP1b7Kelye3xGiaYcaINe8tVOjDX4Tb0C6p9NrinbZdwR
	/6my82pkh+Dhh9ue0uKOcsI82FQRHBfvpcG5+MRRokLLguKqiGyXWCDsBVng2QfS70ojZoec4HI
	4TB4YyWdpHUPZqOvI0Tqv3Fy6oO4n6v89LgIWEGjHYoh80QJzBx7YA8jBOIQB4pjh9tu56Pizzx
	hLwDgciyYC5/YTmRwktRH7Wcki3YLo67tOMErkfklatvtUmAkOLuti7fLo3foqpcJQP/J8ytnUV
	NAVbEqla6vxH+RschDOhHkgGoU6xqbcxROAGN2WmKSwmRwDWu2E8Qk0zSWGK+
X-Google-Smtp-Source: AGHT+IEES5D0+mE56G4Ki/FgoBcVZQ4pkgwGRMo0AVRTZ1b2S+YjtR/3hGDvo7TUDVzsaJV7bdwj/A==
X-Received: by 2002:a17:903:f8d:b0:240:99f7:6c35 with SMTP id d9443c01a7336-2430d21c5demr44559605ad.43.1755086549299;
        Wed, 13 Aug 2025 05:02:29 -0700 (PDT)
Received: from MacBookPro.bytedance.net ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2422ba1e09csm298100165ad.16.2025.08.13.05.02.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Aug 2025 05:02:28 -0700 (PDT)
From: Fengnan Chang <changfengnan@bytedance.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
	Diangang Li <lidiangang@bytedance.com>
Subject: [PATCH] io_uring/io-wq: add check free worker before create new worker
Date: Wed, 13 Aug 2025 20:02:14 +0800
Message-Id: <20250813120214.18729-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit 0b2b066f8a85 ("io_uring/io-wq: only create a new worker
if it can make progress"), in our produce environment, we still
observe that part of io_worker threads keeps creating and destroying.
After analysis, it was confirmed that this was due to a more complex
scenario involving a large number of fsync operations, which can be
abstracted as frequent write + fsync operations on multiple files in
a single uring instance. Since write is a hash operation while fsync
is not, and fsync is likely to be suspended during execution, the
action of checking the hash value in
io_wqe_dec_running cannot handle such scenarios.
Similarly, if hash-based work and non-hash-based work are sent at the
same time, similar issues are likely to occur.
Returning to the starting point of the issue, when a new work
arrives, io_wq_enqueue may wake up free worker A, while
io_wq_dec_running may create worker B. Ultimately, only one of A and
B can obtain and process the task, leaving the other in an idle
state. In the end, the issue is caused by inconsistent logic in the
checks performed by io_wq_enqueue and io_wq_dec_running.
Therefore, the problem can be resolved by checking for available
workers in io_wq_dec_running.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Reviewed-by: Diangang Li <lidiangang@bytedance.com>
---
 io_uring/io-wq.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index be91edf34f01..17dfaa0395c4 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -357,6 +357,13 @@ static void create_worker_cb(struct callback_head *cb)
 	worker = container_of(cb, struct io_worker, create_work);
 	wq = worker->wq;
 	acct = worker->acct;
+
+	rcu_read_lock();
+	do_create = !io_acct_activate_free_worker(acct);
+	rcu_read_unlock();
+	if (!do_create)
+		goto no_need_create;
+
 	raw_spin_lock(&acct->workers_lock);
 
 	if (acct->nr_workers < acct->max_workers) {
@@ -367,6 +374,7 @@ static void create_worker_cb(struct callback_head *cb)
 	if (do_create) {
 		create_io_worker(wq, acct);
 	} else {
+no_need_create:
 		atomic_dec(&acct->nr_running);
 		io_worker_ref_put(wq);
 	}
-- 
2.20.1


