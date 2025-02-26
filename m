Return-Path: <io-uring+bounces-6807-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D334A469AB
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 19:27:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EAB787AA4CC
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 18:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B47723C38C;
	Wed, 26 Feb 2025 18:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="kDBN0UGx"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85E523535C
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 18:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740594076; cv=none; b=Qk7w/OqKtyeFcAt36FVZbpdZHyye8ZCCSQbVGa2P8tWJHNeqpD7zxJDNK/lR76Tu0zGK4bkiTo33GtmISLpz/8D+mU1+zoXH4OO9pC8Nbyqt7JmT0NMTLACTZuht1kSpuT/IcvDWgsCITPCzP3oQwbUhrrm5vqzKHUfuHAc80JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740594076; c=relaxed/simple;
	bh=U1G2hHgsYRVHHC50XSnhtPJqPQY+sriLsVq9/vyaitA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jbYfce44pH6atIQrYhixU+UsrZfpEsUhrpUZ95+LtCWOx65L2IpYvIlK+OX0R04BLQ2M67xFcSFv+dTKW4+eF3tRVCyWyIGcRJdl9baSO/0+8XOhmZqC7QIRLKZA6z35ngEwn+g7/dgTVlImxKWpsWsGo8ViQAKIQ9x5vNfiA7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=kDBN0UGx; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 51QFa2lc015036
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:21:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=culURc658vVmanTo+X
	YHxzDv6Z18DgPKZ90+OM6pNpo=; b=kDBN0UGx/yolLikJbs+sFXOujrCeB3A6x+
	PjfJNLBdR5Iqwtma1wCcbOd4tPgyiuzeLveB3UjeNc9Sedy3a/66LJKgDfcKJ0Tc
	d2FkKzVS3r2k85bGzL5JkZtg/mF9p0ZvjfQ/unZhImTthnRdhAYF2/a1a7ZaelNL
	x7mgohUtDJnejrRlKKba22wL77mWOTjmo54pka+HZt0kQIaG2A7sk4UzEinwYEk3
	2u1JvU9HpMueyJqA4ZZXLdOUY3a+avIdy//qr7s4SPD2Vub8mNiiv7snbC10f66Y
	iWbpXkesB0+Vygz73qqgYTqFAaPwNmjKg8pvhDlB28ct8pDjnlwg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 4525r799f0-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:21:13 -0800 (PST)
Received: from twshared53813.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 26 Feb 2025 18:21:00 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id AAB85187C82C3; Wed, 26 Feb 2025 10:21:04 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        <linux-nvme@lists.infradead.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv7 0/6] ublk zero copy support
Date: Wed, 26 Feb 2025 10:20:55 -0800
Message-ID: <20250226182102.2631321-1-kbusch@meta.com>
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
X-Proofpoint-GUID: 8aYPSya4IGVchlvbrRf92S2vbMIX3aBl
X-Proofpoint-ORIG-GUID: 8aYPSya4IGVchlvbrRf92S2vbMIX3aBl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Nothing's changed from intended v6. This just fixes up the directory for
the mailed patch set.

Changes from v5:

  Merged up to latest block for-next tree

  Fixed up the io_uring read/write fixed prep to not set do_import, and
  actually use the issue_flags when importing the buffer node (Pavel,
  Caleb).

  Used unambigious names for the read/write permissions of registered
  kernel vectors, defined them using their symbolic names instead of
  literals, and added a BUILD_BUG_ON to ensure the flags fits in the
  type (Ming, Pavel).

  Limit the io cache size to 64 elements (Pavel).

  Enforce unpriveledged ublk dev can't use zero copy (Ming).

  Various cleanups.

Keith Busch (5):
  io_uring/rw: move fixed buffer import to issue path
  io_uring: add support for kernel registered bvecs
  ublk: zc register/unregister bvec
  io_uring: add abstraction for buf_table rsrc data
  io_uring: cache nodes and mapped buffers

Xinyu Zhang (1):
  nvme: map uring_cmd data even if address is 0

 drivers/block/ublk_drv.c       | 119 +++++++++-----
 drivers/nvme/host/ioctl.c      |   2 +-
 include/linux/io_uring/cmd.h   |   7 +
 include/linux/io_uring_types.h |  24 +--
 include/uapi/linux/ublk_cmd.h  |   4 +
 io_uring/fdinfo.c              |   8 +-
 io_uring/filetable.c           |   2 +-
 io_uring/io_uring.c            |   3 +
 io_uring/nop.c                 |   2 +-
 io_uring/opdef.c               |   4 +-
 io_uring/register.c            |   2 +-
 io_uring/rsrc.c                | 280 ++++++++++++++++++++++++++-------
 io_uring/rsrc.h                |  10 +-
 io_uring/rw.c                  |  39 +++--
 io_uring/rw.h                  |   2 +
 15 files changed, 389 insertions(+), 119 deletions(-)

--=20
2.43.5


