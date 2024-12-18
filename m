Return-Path: <io-uring+bounces-5560-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D89109F61B7
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 10:31:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6454316F9CD
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 09:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73A8199FB2;
	Wed, 18 Dec 2024 09:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="h0HhrfgN"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48AC1993A3;
	Wed, 18 Dec 2024 09:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734513923; cv=none; b=WX/AU20q8aO20Shr2HV+JY91P3lhtj8C99PUmtRXnncLaBGoiltd/49wxhGe3eHLFx//ClG54vpp8vpqVgA/vAM9IAmPT0VpZgxGah7j26jr6GrpG7/x/vn/0aOVClzunbhwybP3c7eBkHvg8OG1vzxTR7vrNy9B4wmF54EaJJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734513923; c=relaxed/simple;
	bh=SV/ABhFOep9Tk3yKT30cZcPjlxpWVVquWs0fQAW70HI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MMwJtFglV7gHoNwUckVVU6gzE2kWmdZ4R/r0cvLz1uPFzi7eBeKG7vFyEfSeO73qifPFkjdlLCIY5V2CZRcBRoagTOqjXrhaIFikbxMdtAH9bLfI0UZz47CSlXGk/pQnAZn6CAIIpkheORwD83RVz9++fvFqL04pJc5b0JW9sPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=h0HhrfgN; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734513918; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=9YUzUIz7NeGljYU1LTpxknf/0f1jm1sYvRzMtoxQZcY=;
	b=h0HhrfgNe4BjLXzV6WcezGe1X509OKK/kERV3pDDjXDxTRA2HP5FVtdU3NkHGaDSbH1xSBhAE5/6VYU47sp+4d6IfDwtAsuF1Ciz8KG6beQjzln9dwn8hEiPuBNoY2r77QXgthN8xDKDNqh/Y4x4uMuJnQSV76HYmMQrt/IqQbc=
Received: from localhost(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0WLmA.SZ_1734513913 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Dec 2024 17:25:17 +0800
From: Ferry Meng <mengferry@linux.alibaba.com>
To: "Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	virtualization@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: [PATCH v1 0/3] virtio-blk: add io_uring passthrough support.
Date: Wed, 18 Dec 2024 17:24:32 +0800
Message-Id: <20241218092435.21671-1-mengferry@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset implements io_uring passthrough surppot in virtio-blk
driver, bypass vfs and part of block layer logic, resulting in lower
submit latency and increased flexibility when utilizing virtio-blk.

In this version, currently only supports READ/WRITE vec/no-vec operations,
others like discard or zoned ops not considered in. So the userspace-related
struct is not complicated.

struct virtblk_uring_cmd {
	__u32 type;
	__u32 ioprio;
	__u64 sector;
	/* above is related to out_hdr */
	__u64 data;  // user buffer addr or iovec base addr.
	__u32 data_len; // user buffer length or iovec count.
	__u32 flag;  // only contains whether a vector rw or not.
}; 

To test this patch series, I changed fio's code: 
1. Added virtio-blk support to engines/io_uring.c.
2. Added virtio-blk support to the t/io_uring.c testing tool.
Link: https://github.com/jdmfr/fio


===========
Performance
===========

Using t/io_uring-vblk, the performance of virtio-blk based on uring-cmd
scales better than block device access. (such as below, Virtio-Blk with QEMU,
1-depth fio) 
(passthru) read: IOPS=17.2k, BW=67.4MiB/s (70.6MB/s) 
slat (nsec): min=2907, max=43592, avg=3981.87, stdev=595.10 
clat (usec): min=38, max=285,avg=53.47, stdev= 8.28 
lat (usec): min=44, max=288, avg=57.45, stdev= 8.28
(block) read: IOPS=15.3k, BW=59.8MiB/s (62.7MB/s) 
slat (nsec): min=3408, max=35366, avg=5102.17, stdev=790.79 
clat (usec): min=35, max=343, avg=59.63, stdev=10.26 
lat (usec): min=43, max=349, avg=64.73, stdev=10.21

Testing the virtio-blk device with fio using 'engines=io_uring_cmd'
and 'engines=io_uring' also demonstrates improvements in submit latency.
(passthru) taskset -c 0 t/io_uring-vblk -b4096 -d8 -c4 -s4 -p0 -F1 -B0 -O0 -n1 -u1 /dev/vdcc0 
IOPS=189.80K, BW=741MiB/s, IOS/call=4/3
IOPS=187.68K, BW=733MiB/s, IOS/call=4/3 
(block) taskset -c 0 t/io_uring-vblk -b4096 -d8 -c4 -s4 -p0 -F1 -B0 -O0 -n1 -u0 /dev/vdc 
IOPS=101.51K, BW=396MiB/s, IOS/call=4/3
IOPS=100.01K, BW=390MiB/s, IOS/call=4/4

=======
Changes
=======

Changes in v1:
--------------
* remove virtblk_is_write() helper
* fix rq_flags type definition (blk_opf_t), add REQ_ALLOC_CACHE flag.
https://lore.kernel.org/io-uring/202412042324.uKQ5KdkE-lkp@intel.com/

RFC discussion:
---------------
https://lore.kernel.org/io-uring/20241203121424.19887-1-mengferry@linux.alibaba.com/

Ferry Meng (3):
  virtio-blk: add virtio-blk chardev support.
  virtio-blk: add uring_cmd support for I/O passthru on chardev.
  virtio-blk: add uring_cmd iopoll support.

 drivers/block/virtio_blk.c      | 320 +++++++++++++++++++++++++++++++-
 include/uapi/linux/virtio_blk.h |  16 ++
 2 files changed, 331 insertions(+), 5 deletions(-)

-- 
2.43.5


