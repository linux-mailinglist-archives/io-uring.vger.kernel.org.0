Return-Path: <io-uring+bounces-11722-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 495C5D2203E
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 02:25:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 43A9D3034939
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 01:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7826B231A41;
	Thu, 15 Jan 2026 01:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="f6+0/olL"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE971C5D77;
	Thu, 15 Jan 2026 01:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768440319; cv=none; b=ghqdu/6i3CenIfwXeN2SEdFW818NUsdSwvZhQU4OZM9Vu34lJPVCqrTw5IL/c+KtYyAG+3nHtzpalJ1sNionjjGvwn080H4nUzw0+ZxgVTATZ7M/6kVanSTJe6kyUnmLV8kEyhgQgEB8iqnJa88XoJdtNO+mLXTczCzAFQpDHWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768440319; c=relaxed/simple;
	bh=sPfse5Cc5z9C+okX6nNmVsZ6uUCzWV2DIzBj3kmjSW0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=q1uqforQfIawqiK5ghx8Nvukq2eGwQFwOZMctVIqBOgV+fWJ5hXEZQHyWmpMSHwOFtNesr81Op27YEp3wI8zMWpf4QkhqxbvfPvLHRc+GRAkFbI1OxmFS5IeArdSm+dtm9bXz4MF+78k488wwMymY0J8LqiAyhD5eKWPYVM2BzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=f6+0/olL; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Kx
	pEQ33grYiIYyFVG6/rA3+zwrNTxIpguT9J6DE6a4o=; b=f6+0/olLiTCWyzsHrn
	QIel86VQi3rYG5ceXPbL9KsGTtTJwB/ry4Pbj0U59oMUGk1Z1FNvUlFIcPEMBCPo
	ikoX4JAIBnQxhXV1NO2lw2CUJTK2iRQwDZIX2yd2TnzeQU0gES5J2DI9y+sDEiKQ
	5UZ8eK3a3mwOJfqfL28IxS4OQ=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wAnDqzXQWhp5NZdGA--.64S2;
	Thu, 15 Jan 2026 09:24:41 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [RFC PATCH v2 0/3] bsg: add io_uring command support for SCSI passthrough
Date: Thu, 15 Jan 2026 09:24:34 +0800
Message-Id: <cover.1768439194.git.yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnDqzXQWhp5NZdGA--.64S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWFyrJr48AF17ZryDJr4kXrb_yoW5ZF47pF
	WSgr93GayUJr1xuFn3XrZrZFWFqa95G347G343K34vyr909F9FyF1UKF1Fq397Gry2q34j
	qw4jqrs8Ca1kAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j1v38UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRn6i2loQdk0kQAA3V

This RFC series adds io_uring command support to the BSG (Block layer
SCSI Generic) driver, enabling asynchronous SCSI passthrough operations
via io_uring.

Motivation:
-----------
The current BSG interface uses ioctl() for SCSI passthrough, which is
synchronous and has limitations for high-performance applications. By
integrating with io_uring, we can provide:

1. Asynchronous I/O support for better scalability
2. Zero-copy I/O via io_uring fixed buffers
3. Better integration with modern async I/O frameworks
4. Reduced system call overhead

Design:
-------
The implementation follows the io_uring uring_cmd pattern used by other
drivers (e.g., nvme). Key design decisions:

1. UAPI Structure: A new bsg_uring_cmd structure is defined that fits
   within the 80-byte cmd field of a 128-byte SQE, with 24 bytes reserved
   for future extensions. The structure uses protocol-agnostic field names
   to support multiple protocols beyond SCSI.

2. Status Information: SCSI status (device_status, host_status,
   driver_status, sense_len, resid_len) is returned in the CQE res2 field
   using a compact 64-bit encoding.

3. Zero-copy Support: The implementation supports both traditional
   user buffers and io_uring fixed buffers for zero-copy I/O.

4. Async Completion: Command completion is handled via task work to
   safely access user space and copy sense data.

5. Non-blocking I/O: Support for IO_URING_F_NONBLOCK flag to enable
   non-blocking command submission.

Limitations:
-----------
- Currently only SCSI commands are supported (BSG_PROTOCOL_SCSI)
- Scatter/gather I/O (iovec arrays) is not currently supported, but
  the data structure includes fields for future implementation.
- Bidirectional transfers are not supported (consistent with existing
  BSG behavior).

Testing:
--------
A user-space test program has been developed to validate the
implementation, including:
- Basic SCSI commands (INQUIRY, READ CAPACITY (10), READ (10),
  WRITE (10))
- Zero-copy mode using fixed buffers
- Error handling (invalid flags, unsupported features)

The test program is available separately and can be provided upon request.

Changes since v1:
-----------------
- Renamed SCSI-specific fields (cdb_addr/cdb_len) to protocol-agnostic
  names (request/request_len) to support multiple protocols beyond SCSI
- Removed __packed attribute and optimized field alignment to avoid
  suboptimal code generation on architectures that don't support unaligned
  accesses
- Simplified data transfer structure: unified din_xferp/dout_xferp into a
  single xfer_addr field with xfer_dir to indicate direction (0=read, 1=write),
  consistent with existing BSG behavior where bidirectional transfers are not
  supported
- Updated implementation to use new protocol-agnostic field names

Yang Xiuwei (3):
  bsg: add bsg_uring_cmd uapi structure
  bsg: add uring_cmd support to BSG generic layer
  bsg: implement SCSI BSG uring_cmd handler

 block/bsg.c              |  28 +++++
 drivers/scsi/scsi_bsg.c  | 222 +++++++++++++++++++++++++++++++++++++++
 include/linux/bsg.h      |   4 +
 include/uapi/linux/bsg.h |  19 ++++
 4 files changed, 273 insertions(+)

-- 
2.25.1


