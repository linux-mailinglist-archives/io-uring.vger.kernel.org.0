Return-Path: <io-uring+bounces-7608-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCF01A9663E
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 12:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06FF517A9E3
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 10:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD10A2D600;
	Tue, 22 Apr 2025 10:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRG7NHA5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212E01E231E;
	Tue, 22 Apr 2025 10:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745318760; cv=none; b=mHWks+kTAJ6m8x/UVrcqy9Mg8Qaghvny6mRlybTYejIdiWDU8/mcZ3vQHdSpzeXs4+2rjAPAUXhj0eGzDdfF9VY412HswGrnJR/3cjpr3sWYERBMYND8U77a1eH62Kx8upbPZdQN5CiuqTRgjvmwniXHUlHwLphuJPEL4cNPUUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745318760; c=relaxed/simple;
	bh=Ek5IBzxkpX634z6QTNzqEVMVth1EXW0Rz7zi0ayFyuk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FuNlmwJeIO3PTWncwoCcaXRgllp+Y4/IzKvRlpl/WGK8Z2k1qMTD2jMMo2xhAjnzRLRUa4qPuJ+O/86MsgDzKKWpPeGva5Nefp8cRxP2oj1fY4j0ZzbxF5wdJ6X4Rtgx3v+4kzXHLUyeK5CzC81i4ceVjb5VZy/J7UA8HsRqYSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRG7NHA5; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ff6e91cff5so4680582a91.2;
        Tue, 22 Apr 2025 03:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745318758; x=1745923558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oAk3LSdkuszAv8KpcrFbr7se8m7uepNgIQTOnUvP5nA=;
        b=BRG7NHA5XZAPxMjOyOqaabGo/XnAfeLzi4ofbLAO5w4HEFeSBl1xF8TliRWdj0KyNv
         iDKBnNtrIbHd6A6lGdo59yGC0z8DZXynKtR7YfMTwEm//DyPfZDl1KS2xQBE2xgOuEow
         Yu1RbI2IPHxv2duksyjprtsJZmX1p9JfpLBcnsWleWhKn912pnUANyUZNrcxVaDG3JF8
         dyOTWQzGexBDTY4eTXVJW7heW5JtUn0/Y3UegBqTeICJ4CfRp/D/tyqXOK42HlQGxEY7
         dVLk5wK2VELto3dpTiehzM3XrGeMUQGXxJehppwk5fPnDXl3GOoHlOLBgIqCQxKNSH8g
         +Z1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745318758; x=1745923558;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oAk3LSdkuszAv8KpcrFbr7se8m7uepNgIQTOnUvP5nA=;
        b=YLrVlFQq8qWv37krV8S/NI9aPokS+Dt6w8by4VELtvEBgHDFlI8fH8ifJsR/3+CSWD
         dhSAv4AL4QxYVtjYh63JLEtiM5LT8WKfr9dQSdYfXikFsXZ1rPpndoN//mmvD+07tpTf
         qTz1J9aFQ9U5zguKHNqkbgPSanR5dRI5nWtx7HG1ZU88pohbxUbVOAi41RPncg61kYD7
         NaaZ1DJSKXtcnSD9sJJ0GAZ2WLBv/zcj/0+fUUc9QJiiTLZrnybOwH+Z7Ia8ppHXNMq/
         eZGVeYCEiqDPCPR12dHigfA6SoG8kk4KrprsVWMrcyovwzCAwlrTP5BDaA63ooCZ7wW1
         OiUg==
X-Forwarded-Encrypted: i=1; AJvYcCVAyp6j7kX8+mMU0sEmeYWjCihd1g9zdzJ1lQ5U3xvhqZbjgLfyxw0S6vvN9j3J4WWqKcQ3PSyOIT/8Du/SuQ==@vger.kernel.org, AJvYcCVVdAvpgSPk9BmVPloVJ+UXfswciuvVqYPf5hdXPm1j/9fudBNLSSeBXj87ChUtczBgkfahAd0WVQ==@vger.kernel.org, AJvYcCWAahnWW41pwZlKuiWdOIGgvwlZBoeG1z9v1WgOdkw4GzYgaVCQCcZjZrKFpweK+35qkP2kAJc1SdOZr3qr@vger.kernel.org
X-Gm-Message-State: AOJu0YziPf3O50cvTg385vvSRTh8dOXCBP84NgDha4OcLscX0FrdfRd0
	RXwsOiYks40XHqkc3lIdH05PR5Ecba+kV85jwNkblQyjIgiXaXBI
X-Gm-Gg: ASbGncv3fNfG8XwyV1t41+X1JEj0IHRBCY+zw4ppykySeFw9HeUokCgUEqTVD/tZyTO
	P50JK6QorI5Z0tEfa0EBOXN4nUSp0DpX3nJ0Lav8trk5H9LBFJ5SxttrA1J8Z6HeAQBsVZriu7L
	Xg0Gf/bDdoESRog2vpwNBEtV9gJC16hCpwEdVZdCPna/Eve+9jIjoXLoL5QqcGA+/QG/CYiNmMQ
	ASolZgzrHRbMl9quIHOze2Rwz1rV2oAkDwrt5u6+kzGE/n64KvZ5sdcPYS+f8K+qWZphUs7zJCX
	z13EEquogaXXrGDpm8nL8wRdCWW1wnp6pjXRSejuGfTfcQMf2/FwfZcgqt2vrDbHOTtS7o9XpoE
	nnzmTmhsF/EVLMRiCzPh7ekE60TucDVC0CB8FXYP4Bxrb20JVIn6lC4nC684VTf+FuXT7aA+5eX
	dRObvM
X-Google-Smtp-Source: AGHT+IHYsEH7ZWnfGGAiKUP5TBoIGiQKr5vc56YtEizByy5efF79/BYuvg4SY9GW30gzJXTY6WVbhg==
X-Received: by 2002:a17:90b:3a0c:b0:2ef:31a9:95c6 with SMTP id 98e67ed59e1d1-3087bb56439mr24551509a91.14.1745318758002;
        Tue, 22 Apr 2025 03:45:58 -0700 (PDT)
Received: from linux-devops-jiangzhiwei-1.asia-southeast1-a.c.monica-ops.internal (92.206.124.34.bc.googleusercontent.com. [34.124.206.92])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3087e05e90bsm8276853a91.45.2025.04.22.03.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 03:45:57 -0700 (PDT)
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
Subject: [PATCH 0/2] Fix 100% CPU usage issue in IOU worker threads
Date: Tue, 22 Apr 2025 10:45:43 +0000
Message-Id: <20250422104545.1199433-1-qq282012236@gmail.com>
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

 fs/userfaultfd.c |  7 ++++++
 io_uring/io-wq.c | 57 +++++++++++++++---------------------------------
 io_uring/io-wq.h | 45 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 68 insertions(+), 41 deletions(-)

-- 
2.34.1


