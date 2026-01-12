Return-Path: <io-uring+bounces-11579-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D737D11500
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 09:47:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DBF4F301E15C
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 08:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EED6F345740;
	Mon, 12 Jan 2026 08:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="A/Elq1IQ"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750AA3446A0;
	Mon, 12 Jan 2026 08:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768207603; cv=none; b=MS7hzajqN0FY0Ic2as7TjbPW1zBLs/Ti+Ra/QPXVXqA/jwRLVbzZyfl0FIM1jg55UOhbkE9ajgv5FKY1nsUsnNg2pAfd58g6f6Pm/qXuufNyMLeFaXk5T3iDIUlMREw2nzkf7FNvQ6hx9vfCo5tHawLaOQRGCB7QyAumDbBZAMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768207603; c=relaxed/simple;
	bh=l91fAIW+LoyMLpzM59+1l+GVSdNLIvP3pPGcMQfiztk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uEEkcWivh1UHxCqruUsLENV2M/m1YSBiD7YlTVR9ABkJLhuyKmO7wqlHdX5TCnN0NsBII5mVyElZDx7fs8gjhJKWQrOR99pS/Tesg12EfLpIGXeLnFMSLvdWaLK1hqGiPH/4tfG60arsIIvoFdTJpR8KrgHRCxRLCENRcRKKFxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=A/Elq1IQ; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=mA
	ewqvESQ7qpSvyz0ZhWTQKpFnobVQ4e4AZQElc513s=; b=A/Elq1IQXJ9sEEU97A
	NA3WY4P2l5o0+ydU4NvbjIVSTukuwtsUi1L6IN28+XztRNDbMbMR8oOO9tUZxuMz
	IHcmvVZjC0gbg0Jv47tgjXqfyb2SsQsLZlc9jQlJk4VoRGlxxp0JHn+YQ/JES360
	TUHdwQ07NPZAVnSDg9pvFgRv4=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDX7+bQtGRpQ4BSMg--.12084S2;
	Mon, 12 Jan 2026 16:46:09 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [RFC PATCH 0/3] bsg: add io_uring command support for SCSI passthrough
Date: Mon, 12 Jan 2026 16:46:03 +0800
Message-Id: <20260112084606.570887-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDX7+bQtGRpQ4BSMg--.12084S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWFyrJr48AF17ZryDJr4kXrb_yoW5XF1UpF
	WfKrn3JrWUGr1xAFnxXrWDAFW5Xa48G347t343t340yr90kF1avr1YkF1rXrWUJry7J34U
	Xw1jqrn8Ca18A37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jo9a9UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6hHUZWlktNHqiQAA3B

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
drivers (e.g., nvme, ublk). Key design decisions:

1. UAPI Structure: A new bsg_uring_cmd structure is defined that fits
   within the 80-byte cmd field of a 128-byte SQE, with 16 bytes reserved
   for future extensions.

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

Patch Series:
-------------
Patch 1/3: Adds the bsg_uring_cmd UAPI structure
Patch 2/3: Adds uring_cmd handler to the generic BSG layer
Patch 3/3: Implements the SCSI-specific uring_cmd handler

Yang Xiuwei (3):
  bsg: add bsg_uring_cmd uapi structure
  bsg: add uring_cmd support to BSG generic layer
  bsg: implement SCSI BSG uring_cmd handler

 include/uapi/linux/bsg.h | 23 +++++++++++++++++++++++
 block/bsg.c              | 21 +++++++++++++++++++++
 drivers/scsi/scsi_bsg.c  | 193 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bsg.h      |  4 ++++
 4 files changed, 241 insertions(+)

-- 
2.25.1


