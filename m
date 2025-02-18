Return-Path: <io-uring+bounces-6528-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7424FA3ABE3
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 23:43:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 006723AA5DE
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 22:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C50311D7E5F;
	Tue, 18 Feb 2025 22:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="IIkjq+yn"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B72286297
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 22:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739918576; cv=none; b=JCY6as/RJ8aaxwuiMajH3zSR+5vSF4FAkHudU9bG0Z9lKukgz+ZmR7GLStY9wprCBOd3FM6wcdlDrOMXxQx6q87C0u5RA+a72cTNhGagcYLDD4bpXZw+R37nd/fbTnM3Nu4xYdSghBVAAc1G5JnIJe6Oyu8bwrpXJ2jUt1ho6rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739918576; c=relaxed/simple;
	bh=fHZLEfX0eVvpMWiOWQKyUceb87Z7nbopPwJUzGmCEMk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YAZXoUGFO5SnLISMdmzqNSP4WyGJpn1v9phRy6/X9Iq2MefhfgQPc5OjoDAE+UToAGg3BK6WnivGrBDYoL02HgbGU/iI8pS9kj2vBf+bmMmPavHhau/PU0FvdIVsE7u3wWxXo9JLQaY1gCatrS3BeOhFxSFKA65cjCrzSRFz6Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=IIkjq+yn; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 51IM833l012484
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 14:42:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=JiY33QFrLrp0+oqkp0
	4LqfCKN8Tidwf7MPyeJpoleB8=; b=IIkjq+yn5wAlz1fJMwx3PdHVETP3YNfD3+
	4y8kWwbRplBC7YYqYPQtad/DtMVxpHAxnkypgq7fuJlVXNZ+miM/iWspG8hoKZe2
	UnXvHrqF2E9YUgt9OC+Rb+SzyyPXXOk1fOSxPf8BvkQoCoAK/D0Fgo9IxAze8MDs
	z76pJ13HwxzZwAyPY/GKNgzN67alcS9lOYdj3rslFH4HUZXwEX3eMExXDLahdGtC
	wAKxhVF/DgFliBX+gjEPuwJ7L5/r+E1xpc1kayoyIDwweXMxO5omTjXWKyYgsSta
	RPj5aB2bqwpjZ4mPB9V4aLVSsB+5kYX7dJP/RkOiFEw8ulkWX+7w==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 44w018fc2g-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 14:42:53 -0800 (PST)
Received: from twshared24170.03.ash8.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 18 Feb 2025 22:42:47 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 6B144182F61C3; Tue, 18 Feb 2025 14:42:49 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv4 0/5] ublk zero-copy support
Date: Tue, 18 Feb 2025 14:42:24 -0800
Message-ID: <20250218224229.837848-1-kbusch@meta.com>
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
X-Proofpoint-GUID: 3_JoE6czktvzscscwVStqAEW4CjdJ8xg
X-Proofpoint-ORIG-GUID: 3_JoE6czktvzscscwVStqAEW4CjdJ8xg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_10,2025-02-18_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Changes from v3:

  Fixed putting the imu back in the cache on free instead of releasing
  it to the system (Caleb)

  Fixed the build bisect breakage (Caleb)

  Use appropriate error value if cache initialization fails (Caleb)

  Check data direction when importing the buffer (Ming)

  Using the array_no_spec accessor when using a user index (Pavel)

  Various cleanups

Keith Busch (5):
  io_uring: move fixed buffer import to issue path
  io_uring: add support for kernel registered bvecs
  ublk: zc register/unregister bvec
  io_uring: add abstraction for buf_table rsrc data
  io_uring: cache nodes and mapped buffers

 drivers/block/ublk_drv.c       | 137 ++++++++++++-----
 include/linux/io_uring.h       |   1 +
 include/linux/io_uring_types.h |  33 ++--
 include/uapi/linux/ublk_cmd.h  |   4 +
 io_uring/fdinfo.c              |   8 +-
 io_uring/filetable.c           |   2 +-
 io_uring/io_uring.c            |  19 +++
 io_uring/net.c                 |  25 +---
 io_uring/nop.c                 |  22 +--
 io_uring/register.c            |   2 +-
 io_uring/rsrc.c                | 266 ++++++++++++++++++++++++++-------
 io_uring/rsrc.h                |   6 +-
 io_uring/rw.c                  |  45 ++++--
 io_uring/uring_cmd.c           |  16 +-
 14 files changed, 419 insertions(+), 167 deletions(-)

--=20
2.43.5


