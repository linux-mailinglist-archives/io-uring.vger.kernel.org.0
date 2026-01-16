Return-Path: <io-uring+bounces-11756-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A04B5D2B61F
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 05:28:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 040053072F84
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 04:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E4F346799;
	Fri, 16 Jan 2026 04:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="gAk7E7e3"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C81346766;
	Fri, 16 Jan 2026 04:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768537583; cv=none; b=UkPzfFU0bn99ga004YSzi1X04Y+vQrIBw5ik5kIe5wToRtLNaqqoI5P8CHE2KAxFU8NZyQxLYDg8weJ6V0cRFmdlHV1WolHEMZFN6/rmtgMIJUYTiLQiFmvW1Cy/M0BE626rwFXeTCM8ry6TphB9/VdB66x4Ro5PjVcyNv1PNvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768537583; c=relaxed/simple;
	bh=Km94l5dOzb9/BKwN9ws3sLMgxzatXl7DyHXFTSOVL1o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TxasZ3dvDv8mhpJfP+LsLZuw+uHAy4QTNYVALGIvL6222x3ZMF8PevneBcKUk08qk2nVbewUaTPL07CHBJJq8RHv1vSDWKcl9f+jRA/8FsDlOKvXveOOUZzhN2W0+tGOoUNxcuxEpZK0rphtTfFavwJ8hVGn3V17wwRG45hTPBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=gAk7E7e3; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Ma
	HH9s8Et9nU7Iy0cnZpKfH3AnGQ526YacPtNjoeqwM=; b=gAk7E7e3+YKxGs5ugK
	/2jFxkzU+YCRuDoyN1dbQkRX+Tege9SQjEw9ASmCl+6ZHomB2V+C7pEs0Y6Fqv5R
	U6zjSjtMFcGpc1iwx0/ZU2wVdHbAh5m09svzEiWSOUof7NZmYVBUdb1+TqXK8Dko
	+4peZBp8bMeS4VzQw4IVZ/7UQ=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAXCLKuvWlpM1mcFw--.2330S2;
	Fri, 16 Jan 2026 12:25:20 +0800 (CST)
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
Date: Fri, 16 Jan 2026 12:25:13 +0800
Message-Id: <cover.1768536312.git.yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1768439194.git.yangxiuwei@kylinos.cn>
References: <cover.1768439194.git.yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXCLKuvWlpM1mcFw--.2330S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFy8GF4DKF4ftr4rCFyUWrg_yoW8CF4rpF
	WakF43Cw4UCr1xCF4fJFWDA34rX395Ga4UG343Kwn2yFZ8uF10qr4YgF1FvrWkGryIqFyj
	qw1qqr98uw1DArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j1v38UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6RBQ4GlpvbC16QAA3Y

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


