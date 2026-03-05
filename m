Return-Path: <io-uring+bounces-12560-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iEWiMFXdqGlmyAAAu9opvQ
	(envelope-from <io-uring+bounces-12560-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Mar 2026 02:33:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 87183209DD3
	for <lists+io-uring@lfdr.de>; Thu, 05 Mar 2026 02:33:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 23257307E87A
	for <lists+io-uring@lfdr.de>; Thu,  5 Mar 2026 01:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D545D1DF970;
	Thu,  5 Mar 2026 01:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="jcgYLnkA"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3486920ED;
	Thu,  5 Mar 2026 01:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772674211; cv=none; b=KxN5upXh8envW0MHAaKVZdDUkST1zkL0a9byZ7CN/DG/mcqw9zPnfzEV+tHtyh054q98erUtcItV8j84LE/N5kATD4+DnGPlSdI8t1qkdOxcwHYkYmPTn2ihU0LwhTjBSkpx0c/aaqRVxkutJdStnTPW2ZXxvS/+QbybhtDcHWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772674211; c=relaxed/simple;
	bh=dV/FPRteY1wulI6CA5N2gnWp2+JTFOt8V+6zE8RHQ+0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KIM9q33XU8c+e5zO8/Sa17sBa/xbzLIhebssqhY2zqh3Qldrhi6Sn44fAt14l3S8ZpcNi806qCPn3skgN+du/FtIPyRmKqFN5aKx3edTS3KESvAcvpYc7iIlXj8t2nljT3ni2pQnCKDOgb72dhfqRGY/xZCRRH9c7kdaThfg9oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=jcgYLnkA; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=T6
	3Vv00CV8w3oQ42GU98ZAmfpnNbI05s+0v60yzo/hI=; b=jcgYLnkAHsm5AXxDfA
	97cMJd8WdoGQisRv2oPMcZGCM6A6dvw54CzqzmfRdUSovaFWMFrqQYhf/grbkFXU
	azNgmfmxSqWn6DbvSvF96HbumjVq4CDEnRo4DsAb2NI1ch/en/Dx3lcgr7Q3ToFb
	B2Wfqqj9Bl0sKpENdehOABGQk=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wBXMO9b3Khp6W63OA--.24976S2;
	Thu, 05 Mar 2026 09:29:01 +0800 (CST)
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
Subject: [PATCH v6 0/3] bsg: add io_uring command support for SCSI passthrough
Date: Thu,  5 Mar 2026 09:28:54 +0800
Message-Id: <20260305012857.2136525-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260304080313.675768-1-yangxiuwei@kylinos.cn>
References: <20260304080313.675768-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXMO9b3Khp6W63OA--.24976S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWF13Ar13Xw4DKry3WryDWrg_yoW5WFy8pF
	WYgFnxJrWUC3WftFyfAF4DWFyYq3s3Ca1xG347Z34kArn8AF9Fgr1DKF45XFZrCw129a4U
	Xr12vrZ8u3WDAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j1HqcUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6R-SY2mo3F+X1wAA3F
X-Rspamd-Queue-Id: 87183209DD3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12560-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kylinos.cn];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[163.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kylinos.cn:mid]
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

Changes since v5:
- Fixed compilation errors:
  * Use io_uring_sqe128_cmd() instead of io_uring_sqe_cmd()
  * Update scsi_bsg_uring_cmd_done() signature to match rq_end_io_fn typedef

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
 drivers/scsi/scsi_bsg.c  | 207 ++++++++++++++++++++++++++++++++++++++-
 include/linux/bsg.h      |   6 +-
 include/uapi/linux/bsg.h |  21 ++++
 5 files changed, 264 insertions(+), 4 deletions(-)

base-commit: af4e9ef3d78420feb8fe58cd9a1ab80c501b3c08
-- 
2.25.1


