Return-Path: <io-uring+bounces-12548-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gNdBJabnp2mDlgAAu9opvQ
	(envelope-from <io-uring+bounces-12548-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 09:04:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E542F1FC23C
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 09:04:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 795AD30515CD
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2026 08:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AD26388E6B;
	Wed,  4 Mar 2026 08:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="bfQ4q8YB"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3A7389106;
	Wed,  4 Mar 2026 08:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772611449; cv=none; b=HVJKfSyGVFLAyN1USVVgRWGowPPtgzlEioT+hox4pgZXkgjC+I/vH0TwNYuq7SjcfdpO5uy2UP1ql7OafSjOFQjAHPiPxuOM0VNKEEBp65rJ3NvmcmHOAjr8Up8TTivcvL7RuGdQAhX7NQRQX5GDwlbYCTeRr5afFz08E3XyPso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772611449; c=relaxed/simple;
	bh=zZOgqHVM9pWLQP4Ykc5XwSDoVzuR3cQEJFlNLrBCK4M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uEJIzNThFIkicVN6gMqPQAkjuPwhsMk9Fa/fwHfmMf7Bqe9OnzFZjQL/WTfFAo0Xrnlm/HrUtG7EnVwZRo7ld5z60+9J/QaLHI4J6Ggbhu5oQiHBkxixSXSLQcenDNrYZMUZsRhNOrKfeiO6e/DHKPNfle8ZMkcmBMBXuMUAlCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=bfQ4q8YB; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Qr
	9amUivXQzVorKOnDSOzZFaDMUuPQCR/oV7gsbMtxU=; b=bfQ4q8YBO/6taqtAjd
	/NmtqWDUtHiBU8SmwFtrF1tZuSMPzeAukK/46W9oFtJ1O9nZHAtz8JBo7tgYCkbH
	KsQ9lBm4eHdC5K2hTLYbORAKKQxybVNL86Mt6cQ58xiwVslwQQVPdnKJPaT2swoK
	VZUfdRnXrx9Ym/jCyZ4Q3o11Y=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3CvhD56dpCDV7PA--.26869S2;
	Wed, 04 Mar 2026 16:03:16 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v5 0/3] bsg: add io_uring command support for SCSI passthrough
Date: Wed,  4 Mar 2026 16:03:10 +0800
Message-Id: <20260304080313.675768-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3CvhD56dpCDV7PA--.26869S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWF13Ar13Xw4DKry3WryDWrg_yoW5GF48pF
	WFgFnxJr4UC3WftFyfAa1DWFyYq3s3CF47G342q34kArn8AF9Fgr1DtF45XFZrAw17ta4U
	Xr1jvrWDC3WkAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j1mhwUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwQZP32mn50ZYdAAA3U
X-Rspamd-Queue-Id: E542F1FC23C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12548-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[163.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

This series adds io_uring command support to the BSG SCSI passthrough
path.

The goal is to allow userspace to submit SCSI passthrough commands via
IORING_OP_URING_CMD, in addition to the existing sg_io interface.
The io_uring path mirrors the existing BSG behaviour: it currently only
supports BSG_PROTOCOL_SCSI + BSG_SUB_PROTOCOL_SCSI_CMD and does not
support BIDI transfers.

Patch 1 defines struct bsg_uring_cmd in the UAPI so that userspace can
describe SCSI passthrough requests for io_uring.

Patch 2 extends the generic BSG layer with an .uring_cmd file operation
and a bsg_uring_cmd_fn callback, allowing transport-specific handlers to
be registered.

Patch 3 implements the SCSI BSG io_uring handler. It builds a SCSI
request from struct bsg_uring_cmd, maps user buffers (including fixed
buffers), and completes asynchronously via a request end_io callback and
task_work. Completion returns SCSI device/host/driver status, residual
length and sense data length packed into the CQE result.

Compared to the earlier RFC v4 series [1], this version only includes
minor code cleanups (mainly comments and wording), without changing the
behaviour or logic of the implementation.

[1] https://lore.kernel.org/linux-block/20260122015653.703188-1-yangxiuwei@kylinos.cn/

Testing
-------
Testing was done inside a VM on a disk with:
  /sys/block/sdd/mq/0/nr_tags     = 1024
  /sys/block/sdd/queue/nr_requests = 256

The following SCSI INQUIRY micro-benchmark was run with N=100000:

  sg+SG_IO (v3), /dev/sg4:
    avg = 139.0 us, p50 = 128.9 us, p90 = 149.7 us, p99 = 301.0 us

  bsg+SG_IO (v4), /dev/bsg/2:0:0:0:
    avg = 97.2 us,  p50 = 92.7 us,  p90 = 111.5 us, p99 = 150.9 us

  bsg+io_uring, /dev/bsg/2:0:0:0:
    avg = 105.9 us, p50 = 95.4 us,  p90 = 116.2 us, p99 = 175.0 us

  bsg+io_uring (batch=64), /dev/bsg/2:0:0:0:
    avg = 61.9 us,  p50 = 60.9 us,  p90 = 63.9 us,  p99 = 94.6 us

These results show that the new io_uring path is comparable to the
existing BSG SG_IO interface for single-command workloads, and that
batched io_uring submission can significantly improve latency for
high-concurrency workloads when the device supports sufficient queue
depth.

Yang Xiuwei (3):
  bsg: add bsg_uring_cmd uapi structure
  bsg: add io_uring command support to generic layer
  scsi: bsg: add io_uring passthrough handler

 block/bsg-lib.c          |   2 +-
 block/bsg.c              |  32 +++++-
 drivers/scsi/scsi_bsg.c  | 206 ++++++++++++++++++++++++++++++++++++++-
 include/linux/bsg.h      |   6 +-
 include/uapi/linux/bsg.h |  21 ++++
 5 files changed, 263 insertions(+), 4 deletions(-)

-- 
2.25.1


