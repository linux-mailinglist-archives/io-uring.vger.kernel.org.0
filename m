Return-Path: <io-uring+bounces-7168-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 804B5A6C2BF
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 19:48:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D2B716A8B5
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 18:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798431E7C19;
	Fri, 21 Mar 2025 18:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="GeD8eRh1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f225.google.com (mail-il1-f225.google.com [209.85.166.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990AE13C914
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 18:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742582916; cv=none; b=RCJMMEgCVhV6Waf455K5k7O4da6F8KRa1d+bGZaM6sL902F4SPaI5HuE9o1cGd/Os3Nr704HVP5U7NTJrxCG1EC61cxRO02AR8JYvrOOJDkLiFkF+6HDuszUbaEnLNzRfZVls2claYdKzjsyTWtZFnMhcPBzgcJJlg3I+xrt9a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742582916; c=relaxed/simple;
	bh=6AzoF/Ua5e+W0pbqITq3gdd8+FkMv4UUD2h/rIjjbfA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SZIMmpfvN2cd1Vi2cAWjUx+XDec2UkDejI+t1I1SOgJ2AMSALtbPEBdMriIc6x7JvIFYAS8A02Z22T1CqYDScFNP+7TJBR/fzkagvaPcCXu0x4eZTIkw1ouHHr8KOxU4hwH7mzw8djUhzK7nnQ/d8O7TgwNviCiEHdc8zvkCzUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=GeD8eRh1; arc=none smtp.client-ip=209.85.166.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f225.google.com with SMTP id e9e14a558f8ab-3d43bb8ac26so603535ab.2
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 11:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742582913; x=1743187713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mHccgnyGjmXgT4aBmP5V5Ck7Nqm5/kAs+bF2mszWGKw=;
        b=GeD8eRh1277u5DbojD1w6Xwrk4LvnZT8OeLW7rzO+VERXspOo5+3pusJGujSKToZkQ
         vtUgy49gWfzhwR6bNFE8nA3oF5qPD45BZWDd0qNkyMOaBgJojHmPrR21lhbOxuehabma
         YOOs3wDkZcsx6usegGHYqaFoveNLsyOrmkTS6QmM/t0Wrh2RbSgHFov4JVLhVqq2KA24
         JgAwW+E2/sggso/COVOIyBR7FJwPb7lKoo8IB7cwM7yHQOPTqf/r0qM1ccvGna3dr6nG
         Yk7H7uTt69WLVu2o3IWdZ2Urgvc8T6eRrFE/Tvy4FlXc7RiT3s7PWqo3xVMtbqtH3fQO
         91Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742582913; x=1743187713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mHccgnyGjmXgT4aBmP5V5Ck7Nqm5/kAs+bF2mszWGKw=;
        b=ltc19uw0+LEWVd3eY/nX8L8T+wEvlBVyOKthtOPV8vFstipDbYbnWCbSd39DWkeomL
         MTdBD974OUUOQWMocxi12kn15giDUC4tccT/V7wI0+LNhcK0+fHwLJftMHL/B+wPDOP7
         99KwE5Gzi8ewI89ZtClRLkztd6n3yrSpAf6pKP3tDqXznxRGPk6puEKGr09TIgfFjvon
         zE0UOTeEY+goWo99KEooWMnZx4P0bPcSUpT4RBy/c5ECVf/PzsjomNwZSEtWAHZ6Kx6E
         12uPuUlLdKuZIppr2uBb3DyEB+jG3JvueY+qMpdNRFDAMc/4P7gIKSLQ98yiFYivjqIQ
         LbSA==
X-Forwarded-Encrypted: i=1; AJvYcCWYPeB7cmXdpe3/cbYbnK0nStNySiINZFBnoAbT8i6z+ImMk1M6Fua8xA9nI23XHteMhQd0KDPaRA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZdzkZbSMCpeHRuavxMfO4FMOQb3YmE9jxCfjGVN85WhKADrBe
	L61/mkNUZMbt5t1SUi7ZypRe1fJCWGs2X3GTBfXLwlAXgPKD4tTBtT6aeEitjlO9FlZEpKZlp6J
	k7WFCapRavJP2lmkXESvowwZ1O8XljQ+p
X-Gm-Gg: ASbGncsw/xoCFZxXPZhiDgrbC6IfX+nW/RJIEHwocl3E5aO0CUNi1ohhwFjwNrMwYQX
	wxDsfp95+uKicbQoGzviIxqaQ+f9lQc+5EQU1rMlI9WcHtQel4/hEKhk8xYj9I87wsTWq2XCSmZ
	C68WLbaKEZX+9xIBNECP+xdmBir6+ccUmC5ngbEhaXbGn2FEAUowC4ylPFmnVY2Af/mT6t2noMF
	2yLMWXfm2g5SvgLzliVsO8bM3Bov7WjjZ7MJQmd2TdFwfYq4R3s32AUABAvdZ2VTwFEziHoyCiA
	KXG/yTOxGMR2TSXegBvQTp56H+Rr3LW5rAAxOP0JnLkAvQC6
X-Google-Smtp-Source: AGHT+IE2gq8VfE7y0u8ZE/y1UaXhkIL7UtIv5Dn35ylqA63nyjKdHBiBzbQoseHLAnZkyIwqHMeuICy9o9u5
X-Received: by 2002:a05:6e02:1fc7:b0:3d4:2db:326f with SMTP id e9e14a558f8ab-3d5961853b9mr13368595ab.6.1742582913368;
        Fri, 21 Mar 2025 11:48:33 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 8926c6da1cb9f-4f2cbf03526sm103702173.56.2025.03.21.11.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 11:48:33 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id B430F340245;
	Fri, 21 Mar 2025 12:48:32 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id ADE5DE4192A; Fri, 21 Mar 2025 12:48:32 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Ming Lei <ming.lei@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: Xinyu Zhang <xizhang@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 0/3] Consistently look up fixed buffers before going async
Date: Fri, 21 Mar 2025 12:48:16 -0600
Message-ID: <20250321184819.3847386-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To use ublk zero copy, an application submits a sequence of io_uring
operations:
(1) Register a ublk request's buffer into the fixed buffer table
(2) Use the fixed buffer in some I/O operation
(3) Unregister the buffer from the fixed buffer table

The ordering of these operations is critical; if the fixed buffer lookup
occurs before the register or after the unregister operation, the I/O
will fail with EFAULT or even corrupt a different ublk request's buffer.
It is possible to guarantee the correct order by linking the operations,
but that adds overhead and doesn't allow multiple I/O operations to
execute in parallel using the same ublk request's buffer. Ideally, the
application could just submit the register, I/O, and unregister SQEs in
the desired order without links and io_uring would ensure the ordering.
This mostly works, leveraging the fact that each io_uring SQE is prepped
and issued non-blocking in order (barring link, drain, and force-async
flags). But it requires the fixed buffer lookup to occur during the
initial non-blocking issue.

This patch series fixes the 2 gaps where the initial issue can return
EAGAIN before looking up the fixed buffer:
- IORING_OP_SEND_ZC using IORING_RECVSEND_POLL_FIRST
- IORING_OP_URING_CMD, of which NVMe passthru is currently the only
  fixed buffer user. blk_mq_alloc_request() can return EAGAIN before
  io_uring_cmd_import_fixed() is called to look up the fixed buffer.

Caleb Sander Mateos (3):
  io_uring/net: only import send_zc buffer once
  io_uring/net: import send_zc fixed buffer before going async
  io_uring/uring_cmd: import fixed buffer before going async

 drivers/nvme/host/ioctl.c    | 10 ++++------
 include/linux/io_uring/cmd.h |  6 ++----
 io_uring/net.c               | 13 ++++++++-----
 io_uring/rsrc.c              |  6 ++++++
 io_uring/rsrc.h              |  2 ++
 io_uring/uring_cmd.c         | 10 +++++++---
 6 files changed, 29 insertions(+), 18 deletions(-)

-- 
2.45.2


