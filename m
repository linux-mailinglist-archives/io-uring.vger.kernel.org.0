Return-Path: <io-uring+bounces-11757-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E8536D2BA11
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 05:53:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 024E83033DCF
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 04:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33DE634AB16;
	Fri, 16 Jan 2026 04:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ND+j4jvA"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948E3347FD0;
	Fri, 16 Jan 2026 04:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768539184; cv=none; b=gobvejQWEXHCXC+I2GhYggKJ72wBiXWGcCttLyJjNY9Enjm4oVSaf8m6+N/lnfPpm1K1QRsXHdRTpPkmo/TRwwWVxhxTIAhUWUiQ8sgLvmIKRNUn7cFg16esx7YHztYHi6UtVNkJHBPd/EcC7b5QotYafJLXb2hz7IOMda9XxVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768539184; c=relaxed/simple;
	bh=Km94l5dOzb9/BKwN9ws3sLMgxzatXl7DyHXFTSOVL1o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u2H0uzvLak5cEVqEVovn0M0GW8lb2rnTQwd2mcGWqMymt9lUOxucYkMn6+IH2oUVl3bhAiLUPyP7iAYjjBlejsPnfoLeYzCmzNINPanGlVzzefMjekGZC9UdtXAykzsJC07OUSj/Xsv7AfPbVUwJIZpX4dEaVwky/XprbCueVO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ND+j4jvA; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Ma
	HH9s8Et9nU7Iy0cnZpKfH3AnGQ526YacPtNjoeqwM=; b=ND+j4jvAB0RVA56BBX
	F+yRw8yBGeF9dRJgIAs65TFAmtOishFH3M7H5uhxW6uTaVwNKtCCiFMA7MWlztx6
	MX2eLKzEjO2EE3OFLd283zpRI6TTwxzm6xytzMD3VHv2dGQVjp/tvzUzpPHJ1TRO
	U6GuCFCMEKykXmxFMtHfxERJA=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgA3BNvxw2lpiES4NA--.28497S2;
	Fri, 16 Jan 2026 12:52:03 +0800 (CST)
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
Subject: [RFC PATCH v3 0/3] bsg: add io_uring command support for SCSI passthrough
Date: Fri, 16 Jan 2026 12:52:00 +0800
Message-Id: <cover.1768536312.git.yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgA3BNvxw2lpiES4NA--.28497S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFy8GF4DKF4ftr4rCFyUWrg_yoW8CF4rpF
	WakF43Cw4UCr1xCF4fJFWDA34rX395Ga4UG343Kwn2yFZ8uF10qr4YgF1FvrWkGryIqFyj
	qw1qqr98uw1DArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j86pPUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6RPhcmlpw-MnNAAA3K

This RFC series adds io_uring command support to the BSG (Block layer
SCSI Generic) driver, enabling asynchronous SCSI passthrough operations
with zero-copy support via fixed buffers.

The implementation follows the io_uring uring_cmd pattern used by other
drivers (e.g., nvme). A new bsg_uring_cmd structure fits within the 80-byte
cmd field of a 128-byte SQE, with 8 bytes reserved for future extensions.
The structure uses protocol-agnostic field names and follows the sg_io_v4
design with separate din_xferp/dout_xferp fields. SCSI status information
is returned in the CQE res2 field using a compact 64-bit encoding.

Currently only BSG_SUB_PROTOCOL_SCSI_CMD is implemented. Scatter/gather
I/O and bidirectional transfers are not yet supported.

The implementation has been tested with a user-space test program covering
basic SCSI commands (INQUIRY, READ CAPACITY, READ, WRITE), zero-copy mode,
and error handling.

Changes since v1:
-----------------
- Protocol-agnostic field names (request/request_len instead of cdb_addr/cdb_len)
- Removed __packed attribute for better code generation
- Reduced reserved space from 16 bytes to 8 bytes to fit within 80-byte SQE

Why v2 was superseded:
----------------------
v2 unified din_xferp/dout_xferp into a single xfer_addr field, which
diverged from the established sg_io_v4 interface. v3 reverts to separate
din_xferp/dout_xferp fields to maintain consistency with the existing
BSG interface.

Yang Xiuwei (3):
  bsg: add bsg_uring_cmd uapi structure
  bsg: add uring_cmd support to BSG generic layer
  bsg: implement SCSI BSG uring_cmd handler

 block/bsg.c              |  66 ++++++++++++++
 drivers/scsi/scsi_bsg.c  | 192 +++++++++++++++++++++++++++++++++++++++
 include/linux/bsg.h       |   4 +
 include/uapi/linux/bsg.h  |  24 +++++
 4 files changed, 286 insertions(+)

-- 
2.25.1


