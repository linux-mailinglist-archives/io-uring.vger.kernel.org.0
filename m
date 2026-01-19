Return-Path: <io-uring+bounces-11823-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CFFBD3BC1F
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 00:55:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0F8B6302355D
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 23:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E6029ACDB;
	Mon, 19 Jan 2026 23:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="R8L9808v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC9D197A7D
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 23:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768866902; cv=none; b=IAVq9eK/cTpObtIs8BUMMfFeB6OgHYwgccTY2DteeEI9225CNwx3LKq9ieP1dLnsQQs+Uyn+nkTGfydTKcGdRYM+eD9spmls/fjD9yTbm4eBVmFhIsatLXuHrV0C8LKhQJ3fKoPYu/GHFtaDHV+VrlVIPp7f0osJV1c3GPgsHvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768866902; c=relaxed/simple;
	bh=pe5PgprGbWezv87hCbUjnrfn8oNgy5Tjc5maeUOw2TA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VNmOOs4wNTfaA8PR0E5asfX4j/qlhCDtj/UpH1w85WwAVYmiVio49XmuO1ZWVc2uxNn9OH4SxcBuuFS+1kfZgxVNlFJ/1/MEpxhzafHxmx4PY6rX06iwN4ORDsHvtSrWMCjg8kVMhpPpF4Z2t1g0mVvQkDfIk23FHAqCNOCBhks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=R8L9808v; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7cfd9b898cdso2691004a34.2
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 15:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768866899; x=1769471699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m4u5agnBPG6kjVsWfBjMEG93YV3WRf8S+mdQiJEG9PQ=;
        b=R8L9808vbLY7SEDt72oxSwPF5zQ9MvRG+fOcZbEn8okw1/ptpBu8RTrh9iv9C3qmxD
         ovFVraY3CBIyuYT3qqyLTjUVW+J3NLoTbQ/PE6XwBpFirS8JoQboXlAuLN99C9YgJQTl
         Yw1uGv33boCILVC6n3H7x7RtXwI2A8eBJdiaQ4B5e6SFcs46Osw58ZE2iB84KE0yxeAs
         B0LygFV/EUpz6OCB6i+FwCVkzv2+1b07vkjyzApf2AGvNV6oqTwAoM/5tboINOGv3fSQ
         0jp7zj3m0UYgKv09uHErA6ZxFQqCB1KyJDt4t6wc14c9Mid0jagLOYKJ7cRJpmrk2qTh
         BUpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768866899; x=1769471699;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m4u5agnBPG6kjVsWfBjMEG93YV3WRf8S+mdQiJEG9PQ=;
        b=nUrkY9R4OT4qyk9nPOIRk4cUer42fwXMTONbBCyJP2Az33dPZPEgNwvG4F5S8f7Zpm
         QGNPXLld3H34rHPaYlGU7m3ERtShLdxcR6uyGXtPaL+0tXFaajFbWNIgECFS1GFeUGbD
         IbMZmkoqpbmIklcLZ0EYJGj51AeN0k/SwXrCBkHij1qD5RLKeGWp4PYFDxn7aOFsg6Ds
         VTydpgiGMJ3scpjO4UPNwGVxYEuHLzVb4FIZi0X2zelnVOoTjRdM1fzMgrgL7XNgT4ew
         64wf6YoU91UiguTc8GSCQ+BOUNKIbD1Mzk62G/K3IBI2zASaOX++TUmzmmmWUluHXh/s
         unow==
X-Gm-Message-State: AOJu0YzjVOFEWI3bBFKLndccyuPDCrGImd+vV+ogf/T3GG4ReF9GDicV
	4GzmBLAPThkMTDHce+2GR+BZ8AJk8awmkWAxrAo2I/fXc5MGwJPxDqTi+ZGJBtIQBUOA3q1+OGn
	ywCNK
X-Gm-Gg: AY/fxX4XjuT1JIsSyhIz+ZfffUhJpQC2tZeQ9g+SbycGYHXIsKTozeAWXww2TOc0sWO
	xiXTUBvEaAw320Cdeb6XobI+7U2M9CpjQIasWl3bh/8zviDg3sdIUD08lHNtOEfyniFem35/+E1
	YBqgCPE+PysikIsb/qZPHDUTKzrI/9LDADV2K7pcEvRqkyH3UncWlX4OeF7f0EWLn9I02slYJyE
	nrM6PL0zSG345PTDdpJ3cpaVutWaKBxzAvlDflIe47aTOdCSII3v/3Oq1QBC+LQoTmP3z1qXSKO
	pCIylt68TL8LwTpBo2pHitgueB7dZOoe7XjYvbozk5wDcHFCV+QVIQ/63BYgJGHDUCr3qHTOcCe
	bn5qHAB8ImWgD9tIoavaJPONhb+hZTviO7xqG8sNMyut4E7InLe9L4XUlSN3SEhVYHIqCyw+J9b
	svlOFvU1zyc7Sn7z1rSyx0g3l3I56rNzeT9ibB9VeU1cgLAEa2ZZbMoArp
X-Received: by 2002:a05:6830:6c08:b0:7c5:2dbf:4a7d with SMTP id 46e09a7af769-7d140ac8fc2mr70247a34.31.1768866899026;
        Mon, 19 Jan 2026 15:54:59 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2a5f02sm7509997a34.25.2026.01.19.15.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 15:54:58 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	jannh@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCHSET v6] Inherited restrictions and BPF filtering for io_uring
Date: Mon, 19 Jan 2026 16:54:23 -0700
Message-ID: <20260119235456.1722452-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Followup to v5 here:

https://lore.kernel.org/io-uring/20260118172328.1067592-1-axboe@kernel.dk/

Mostly just addressing a bit of feedback, feature wise this is all the
same as before. For details on the patches, see the v5 posting linked
above. For details on the changes, see the changes section below.

Kernel branch can be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=io_uring-bpf-restrictions.3

and a liburing branch with support helpers, man page, and a fairly
substantial test case can be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/liburing.git/log/?h=bpf-restrictions

Feedback welcome!

Changes since v5:
- Disallow setting or appending filters for no_new_privs, unless the
  user is also CAP_SYS_ADMIN (Aleksa)
- Add support for filtering of IORING_OP_OPENAT/OPENAT2, in terms of
  being able to deny certain resolve or creation flags.
- Change layout of io_uring_bpf_ctx slightly, for easier/faster clearing
  of unused members.
- Expand liburing test cases to cover both the no_new_privs situation,
  and testing the OPENAT/OPENAT2 filters.

 include/linux/io_uring.h                 |  14 +-
 include/linux/io_uring_types.h           |  13 +
 include/linux/sched.h                    |   1 +
 include/uapi/linux/io_uring.h            |  10 +
 include/uapi/linux/io_uring/bpf_filter.h |  62 ++++
 io_uring/Kconfig                         |   5 +
 io_uring/Makefile                        |   1 +
 io_uring/bpf_filter.c                    | 436 +++++++++++++++++++++++
 io_uring/bpf_filter.h                    |  48 +++
 io_uring/io_uring.c                      |  48 +++
 io_uring/io_uring.h                      |   1 +
 io_uring/net.c                           |   9 +
 io_uring/net.h                           |   6 +
 io_uring/openclose.c                     |   9 +
 io_uring/openclose.h                     |   3 +
 io_uring/register.c                      |  91 +++++
 io_uring/tctx.c                          |  42 ++-
 kernel/fork.c                            |   5 +
 18 files changed, 794 insertions(+), 10 deletions(-)

-- 
Jens Axboe


