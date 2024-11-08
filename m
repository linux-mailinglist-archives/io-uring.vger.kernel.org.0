Return-Path: <io-uring+bounces-4570-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91EAD9C25BA
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 20:43:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB6091C2362A
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 19:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8BFF1C1F10;
	Fri,  8 Nov 2024 19:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="RhE734Fe"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1996C1C1F06
	for <io-uring@vger.kernel.org>; Fri,  8 Nov 2024 19:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731094990; cv=none; b=QAwD5tI01kJ4LbZ1TayTZhBxevVuRBAQoZmgeR7vOcZwhMkAJw/sZsaJ0IvoGMhQUnZZimONyf03nGkvfbuLxxsv/BlGcqy1MW8w+eZkh0lcieYl096SUIhMSR8RgcgzBgA3rmbX7lYxDo8CG7wEeKxiZpf+ZfXv6FOpK+Dpt0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731094990; c=relaxed/simple;
	bh=kJHUOkZq4OqxDP2m8gl/HfwIZuznYWslLepJFC+6drU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LkGQUFo9HDHUqRT/jTzYfyrxRPFC+Ss46dSbZBQVP5FQgLHoGW256gDTLeLMjsiHN//G2VxCzbGHHxALWrGAWqN/pb4XlWPG31Dci9qkxfc7XcMHIIqfhYFErrZaG8d+UtoDR8/PIuvrSBjLN1uyr4MdrO24VguGMM32KKx3dGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=RhE734Fe; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8HPiFZ014433
	for <io-uring@vger.kernel.org>; Fri, 8 Nov 2024 11:43:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=6okj447WixbNNhNQHa
	A9DEOarhvhg3oKtVsSwQCEn3Y=; b=RhE734FeexQvP2U1/uC+/vT3UbmmyFSZTM
	t6gNuFDeljwFO4jwyriPVo/Z3MCFa2XrL5kQJeuxBIkYwLR/mfpEC6mdWzISpHeF
	BLc70a91dCVA6Mj51ps0q4sHzLVLoRGMWdevQ2ZF8SWqiwEw/KANbr3Lg/apws1i
	bFW8XpENiSQmwfY652E+abHV8lxjGQ4zGTwBNQbVnM81IHgPIhPZMyNi1aL00Box
	JyXPtvbD/KIwwQ6dO2KSs9bSvt/x92rzotW2OymXKnZ0yhfDBkO1qfA8l6exs7ct
	NV7N1daP8VwsO2MOwRABrflZdZTdDI4XFIyPvZxHqY98amJToO/Q==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42sp2t9mrh-12
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 08 Nov 2024 11:43:07 -0800 (PST)
Received: from twshared29075.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 8 Nov 2024 19:43:00 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 35FAE14E3A027; Fri,  8 Nov 2024 11:36:58 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <axboe@kernel.dk>
CC: <hch@lst.de>, <martin.petersen@oracle.com>, <asml.silence@gmail.com>,
        <javier.gonz@samsung.com>, <joshi.k@samsung.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv11 0/9] write hints with nvme fdp and scsi streams
Date: Fri, 8 Nov 2024 11:36:20 -0800
Message-ID: <20241108193629.3817619-1-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: j8h2miGDPyDosop39YBnrXPZuBBqidNb
X-Proofpoint-ORIG-GUID: j8h2miGDPyDosop39YBnrXPZuBBqidNb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Changes from v10:

  Fixed FDP max handle size calculations (wrong type)

  Defined and used FDP constants instead of literal numbers

  Moved io_uring write_hint to the end of the SQE so as not to overlap
  with other defined fields except uring_cmd

  Default partition split so partition one gets all the write hints
  exclusively

  Folded in the fix for stacking block stream feature for nvme-multipath
  (from hch xfs-zoned-streams branch)

Kanchan Joshi (2):
  io_uring: enable per-io hinting capability
  nvme: enable FDP support

Keith Busch (7):
  block: use generic u16 for write hints
  block: introduce max_write_hints queue limit
  statx: add write hint information
  block: allow ability to limit partition write hints
  block, fs: add write hint to kiocb
  block: export placement hint feature
  scsi: set permanent stream count in block limits

 Documentation/ABI/stable/sysfs-block | 14 ++++++
 block/bdev.c                         | 22 +++++++++
 block/blk-settings.c                 |  5 ++
 block/blk-sysfs.c                    |  6 +++
 block/fops.c                         | 31 +++++++++++--
 block/partitions/core.c              | 45 +++++++++++++++++-
 drivers/nvme/host/core.c             | 69 ++++++++++++++++++++++++++++
 drivers/nvme/host/multipath.c        |  3 +-
 drivers/nvme/host/nvme.h             |  5 ++
 drivers/scsi/sd.c                    |  2 +
 fs/stat.c                            |  1 +
 include/linux/blk-mq.h               |  3 +-
 include/linux/blk_types.h            |  4 +-
 include/linux/blkdev.h               | 15 ++++++
 include/linux/fs.h                   |  1 +
 include/linux/nvme.h                 | 37 +++++++++++++++
 include/linux/stat.h                 |  1 +
 include/uapi/linux/io_uring.h        |  4 ++
 include/uapi/linux/stat.h            |  3 +-
 io_uring/io_uring.c                  |  2 +
 io_uring/rw.c                        |  2 +-
 21 files changed, 263 insertions(+), 12 deletions(-)

--=20
2.43.5


