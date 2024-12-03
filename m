Return-Path: <io-uring+bounces-5176-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 258749E1BD9
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 13:17:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E56FC161381
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 12:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BDA81E7641;
	Tue,  3 Dec 2024 12:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NlGZAjfV"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870751E570A;
	Tue,  3 Dec 2024 12:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733228079; cv=none; b=rllMAx6GBkXDV0m3zNhYJF9x0PYutRlTp8KTLmaddZlKf7DF1sLTp4J9nggZJyXE8so1s5HgSRgTwAzqSMYRMS/uuIB5/Pmgg94o2CTPT744sj7ZAeibMED3C0ytbKtzEa/y8Wk/Rfbp/i1nx5lLN/gxEGAHNhm3u5o87KBOfmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733228079; c=relaxed/simple;
	bh=QdBxzNQs/JcMK80Dvkj/Snot7CWTforQH5lu/RdEUjs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=O9nW9oMV+3CZB3Zi91coEs5ZkO85EKTqnSCUHp4Ymlg5zqVDFJ/S/KedW5eXNK2w1+lWXG1GU5I9MDGeWUA/T/dG6gjP6YbA1b3rmN7O9TIh4xvEJYErPGvHcI0nhqq3s91BQiz3V1Hvol+ZCrufgc1aNOO73lUWnJ5dnaRgjio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NlGZAjfV; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733228074; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=HuqGAvbN2L/LVkbTrKAfpTJN10lUOcd/PL9tmLaFQ8g=;
	b=NlGZAjfV5YqUdQ2Dju/QcLIgN2Xyx+TSPhYiEEF7pm9QiJYd6iH2n9nxX/aDkSRrWK0flChp6aIvMm4aw1lu8RzF3syrBRMxkphZ9+ZPmSlIlrs8M4YdRMK67j6yePPZ1Wo6N8ZXHK3v2FjQ7FmolWnQgwUQV8vP8r9zsyCw3Ok=
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0WKmboQr_1733228066 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Dec 2024 20:14:33 +0800
From: Ferry Meng <mengferry@linux.alibaba.com>
To: "Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	virtualization@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: [PATCH 0/3][RFC] virtio-blk: add io_uring passthrough support for virtio-blk
Date: Tue,  3 Dec 2024 20:14:21 +0800
Message-Id: <20241203121424.19887-1-mengferry@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We seek to develop a more flexible way to use virtio-blk and bypass the block
layer logic in order to accomplish certain performance optimizations. As a
result, we referred to the implementation of io_uring passthrough in NVMe
and implemented it in the virtio-blk driver. This patch series adds io_uring
passthrough support for virtio-blk devices, resulting in lower submit latency
and increased flexibility when utilizing virtio-blk.

To test this patch series, I changed fio's code: 
1. Added virtio-blk support to engines/io_uring.c.
2. Added virtio-blk support to the t/io_uring.c testing tool.
Link: https://github.com/jdmfr/fio 

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

The performance overhead of submitting IO can be decreased by 25% overall
with this patch series. The implementation primarily references 'nvme io_uring
passthrough', supporting io_uring_cmd through a separate character interface
(temporarily named /dev/vdXc0). Since this is an early version, many
details need to be taken into account and redesigned, like:
● Currently, it only considers READ/WRITE scenarios, some more complex operations 
not included like discard or zone ops.(Normal sqe64 is sufficient, in my opinion;
following upgrades, sqe128 and cqe32 might not be needed).
● ......

I would appreciate any useful recommendations.

Ferry Meng (3):
  virtio-blk: add virtio-blk chardev support.
  virtio-blk: add uring_cmd support for I/O passthru on chardev.
  virtio-blk: add uring_cmd iopoll support.

 drivers/block/virtio_blk.c      | 325 +++++++++++++++++++++++++++++++-
 include/uapi/linux/virtio_blk.h |  16 ++
 2 files changed, 336 insertions(+), 5 deletions(-)

-- 
2.43.5


