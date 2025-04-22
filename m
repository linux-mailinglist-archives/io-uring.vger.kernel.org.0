Return-Path: <io-uring+bounces-7628-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3982CA972BD
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 18:29:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7215E3A47B0
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B175328FFE0;
	Tue, 22 Apr 2025 16:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B7V38zcp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C93515098F;
	Tue, 22 Apr 2025 16:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745339370; cv=none; b=J1bzPAT5CL7VTGJgHbyNJklZfXO42eR8JKGia5eAvJLjBVTTId1FeVbxNRu7xK3TsWyknQSC0iEq3Ia3Wb3Pq3t0QwXeg7VES45wvE+ZUsdrZ2bE6ezhD8s48tJ+Y51xzZlIuxVr7vYdvrYNcfgC/MOvUmeuwEMWx2JR7Ub7lsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745339370; c=relaxed/simple;
	bh=qSqTKpu4LDNDGZIdCc0qOwHHWfSeJU5SAY2QSbYBuT8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FWjsNtKwraqFK/P7DLVSbVPqt31YqfY0P4d5jj9mS5Buu6SECN57c/Jo5g3sgb1ObR/DN4n91p+BAt8KDdZ40XR+1+wtHpAHs3S3SO1EqYZMAFeFvpHlyc/0w2UPLnkZz5ohIb9H22tiWanw4J2eoWkTusvJ37U6CXk3oHG/I+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B7V38zcp; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22423adf751so55044765ad.2;
        Tue, 22 Apr 2025 09:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745339368; x=1745944168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mqFQjXcx1dupphMpacBjgQn4b3sEJ6P436qTqlhXx8M=;
        b=B7V38zcpxXOHWNAzvUGjUsCxDJgeSVQbLyRjaSfGE1VmvbEcFcToQ8Vn2OPjWhzBM2
         HdOCx0RN1PM3sw+Eq8mIoti47nyYESyUqaYVbG/Z+mvt9tYDERAnE2u+iDgHbc6RcMLS
         UkEtgHi72xrYi3wAj4aDA0Spa2apMTemtlrnwnnlGvi0YfRSx8gje1dXeg2u2c3xms8Q
         /vid0snDYfQB+PkKdtHFgV8FT4egDoEzbZwPD1J2KghtEUKmWLFP5oo+sogbQJV3pITz
         T/ptzD4+nAjpCOQlnDoHCzse4y5ADIbD2iRynHLoLDmgoS0HVRmeaHpDE7AKE6Ot8ZVh
         vSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745339368; x=1745944168;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mqFQjXcx1dupphMpacBjgQn4b3sEJ6P436qTqlhXx8M=;
        b=VwLjjCleiZ5RSw7mujAzvOWSRvM3E1hutKU8qaE8xo8gEakb7TS5tDbTf3OdboTHVA
         6qtBzvj5eKYr25/TG2w3oa8kIpaOnWoZqD4/a/q7MJhCFSr89e59pMsYIBmpOfHRNBiX
         D/v9VueTNaxOvnhk9mUKAYJqYNtSy95c+xRd6C4/N48ErusqE/OxgE0fxu6wpIgyd2mC
         qHwe01KBbUWXoRB43Pfmb92f7Fp6vsYTJdz0p4WGgvYrFDsMzGeqBaYhbQ1zpDeqBCn/
         0bZRbTVznnqfxO3sT5oBb14grj0dTP1k0m5CsU4ujGQftMfc2ljf5tIXVYcQLBXORcH5
         lIZw==
X-Forwarded-Encrypted: i=1; AJvYcCVVyvV8Inv5QrtgwrLYI1hIhKY7Vh9L603cuUhhKzUMR70G/yR15HsGtWEy+zwojl2wwpBQXtUeAQ==@vger.kernel.org, AJvYcCVYQ5O+jyyVSYeEZ+iton5Go4nkaJLNUy9nfMEBsg8Czbl7H5HJ/mTpSkP5hkeMR6C/PUWKjFLCXS8IVgZmNQ==@vger.kernel.org, AJvYcCX8/n84EXHZwIV1tP2fdMCHUew4WB7hRK5TMAU8wsDINKiABggMPyK9ncw9JYI2/CutH23tk1xdl5IXFR4+@vger.kernel.org
X-Gm-Message-State: AOJu0YxY9O1wdq1s4Fm0kvYmaBYl3D4J7YBLV54Ddum93UWIMP+Br57/
	4Ep5bcAi4qKlNDM7YTOX+MiKt7vFRVpgRgjwETgreaTdj8x/QZE4
X-Gm-Gg: ASbGncs6ippQMS6N6jqOsOtbLV+4N7dr7fgEq6d6pYrpK4KAxJHUDiiuYI5G0Mt/HZX
	DQRLxrzIYEViBfow0dv/+sPaI1ALn9ADiNMe/DNCo9aGivxpZjjMLZxt+/zNVlK1jgtdQUs8PUG
	URyO9vsjajrwK/+AScWBx2Jij3Fn7/RvKZroX59AhKOpwszu3DmeGxBobERnHbi5bPKcDfUzIVW
	cx+y8+ZHjaAS6fgMilD43PGxHx0l5w0xZ5w8cMZN4GveB92s96g5WCV4pX0S6o8HQq1I1tgVnFp
	3oluQcCTlH/zGTGGHRGV2QyzJHI/GaIpzE+TOdJJ5vc1SLlN9VwNfIEvyvxTQpfVsurm7beArrE
	uLASyyG5d28Oo0a504DQ813tbODMAx1dTlpztnhKql9Nj0wNJDv3dkvVSE3UoZ+3BfV6LlSMe6Y
	3Pns9M
X-Google-Smtp-Source: AGHT+IHEFpvt2yM13kra3DTZbBby3wsgWEMQQdPQlccwS0dzadJOUKXG3q6hx2tj8M9/i/HfEK2TNg==
X-Received: by 2002:a17:903:1aa6:b0:224:2201:84da with SMTP id d9443c01a7336-22c5356de05mr207898855ad.6.1745339368281;
        Tue, 22 Apr 2025 09:29:28 -0700 (PDT)
Received: from linux-devops-jiangzhiwei-1.asia-southeast1-a.c.monica-ops.internal (92.206.124.34.bc.googleusercontent.com. [34.124.206.92])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50fe20b0sm87481695ad.243.2025.04.22.09.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 09:29:27 -0700 (PDT)
From: Zhiwei Jiang <qq282012236@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	peterx@redhat.com,
	axboe@kernel.dk,
	asml.silence@gmail.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Zhiwei Jiang <qq282012236@gmail.com>
Subject: [PATCH v2 0/2] Fix 100% CPU usage issue in IOU worker threads
Date: Tue, 22 Apr 2025 16:29:11 +0000
Message-Id: <20250422162913.1242057-1-qq282012236@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the Firecracker VM scenario, sporadically encountered threads with
the UN state in the following call stack:
[<0>] io_wq_put_and_exit+0xa1/0x210
[<0>] io_uring_clean_tctx+0x8e/0xd0
[<0>] io_uring_cancel_generic+0x19f/0x370
[<0>] __io_uring_cancel+0x14/0x20
[<0>] do_exit+0x17f/0x510
[<0>] do_group_exit+0x35/0x90
[<0>] get_signal+0x963/0x970
[<0>] arch_do_signal_or_restart+0x39/0x120
[<0>] syscall_exit_to_user_mode+0x206/0x260
[<0>] do_syscall_64+0x8d/0x170
[<0>] entry_SYSCALL_64_after_hwframe+0x78/0x80
The cause is a large number of IOU kernel threads saturating the CPU
and not exiting. When the issue occurs, CPU usage 100% and can only
be resolved by rebooting. Each thread's appears as follows:
iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork_asm
iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork
iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker
iou-wrk-44588  [kernel.kallsyms]  [k] io_worker_handle_work
iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_submit_work
iou-wrk-44588  [kernel.kallsyms]  [k] io_issue_sqe
iou-wrk-44588  [kernel.kallsyms]  [k] io_write
iou-wrk-44588  [kernel.kallsyms]  [k] blkdev_write_iter
iou-wrk-44588  [kernel.kallsyms]  [k] iomap_file_buffered_write
iou-wrk-44588  [kernel.kallsyms]  [k] iomap_write_iter
iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_iov_iter_readable
iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_readable
iou-wrk-44588  [kernel.kallsyms]  [k] asm_exc_page_fault
iou-wrk-44588  [kernel.kallsyms]  [k] exc_page_fault
iou-wrk-44588  [kernel.kallsyms]  [k] do_user_addr_fault
iou-wrk-44588  [kernel.kallsyms]  [k] handle_mm_fault
iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_fault
iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_no_page
iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_handle_userfault
iou-wrk-44588  [kernel.kallsyms]  [k] handle_userfault
iou-wrk-44588  [kernel.kallsyms]  [k] schedule
iou-wrk-44588  [kernel.kallsyms]  [k] __schedule
iou-wrk-44588  [kernel.kallsyms]  [k] __raw_spin_unlock_irq
iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker_sleeping

I tracked the address that triggered the fault and the related function
graph, as well as the wake-up side of the user fault, and discovered this
: In the IOU worker, when fault in a user space page, this space is
associated with a userfault but does not sleep. This is because during
scheduling, the judgment in the IOU worker context leads to early return.
Meanwhile, the listener on the userfaultfd user side never performs a COPY
to respond, causing the page table entry to remain empty. However, due to
the early return, it does not sleep and wait to be awakened as in a normal
user fault, thus continuously faulting at the same address,so CPU loop.
Therefore, I believe it is necessary to specifically handle user faults by
setting a new flag to allow schedule function to continue in such cases,
make sure the thread to sleep.

Patch 1  io_uring: Add new functions to handle user fault scenarios
Patch 2  userfaultfd: Set the corresponding flag in IOU worker context

Changes since v1:
- Optimized the code under Jens Axboe's suggestion to reduce the exposure
  of IO worker structure.


 fs/userfaultfd.c |  4 ++++
 io_uring/io-wq.c | 35 +++++++++++++++++++++++++++++------
 io_uring/io-wq.h | 12 ++++++++++--
 3 files changed, 43 insertions(+), 8 deletions(-)

-- 
2.34.1


