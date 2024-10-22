Return-Path: <io-uring+bounces-3913-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 813FD9AB15D
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 16:50:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42407285635
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 14:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1501A255C;
	Tue, 22 Oct 2024 14:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="X/OZULTY"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159D91A0BE0
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 14:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608647; cv=none; b=lpidC7OhzXPrACPcq/6Ly7wyr2ysjRHwKKylo0LUHp8q53G61kHHyNDuxcyZd9+tCmx+C+/cctgxss0gT5g9CPCa4AK+XUZoUxZYTjr7vwKp5NA4ZgYLTYle1FMMKFlim1/n7+lHRAReg7Mxmyo967vRGDplnPWebjRxOTeCbgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608647; c=relaxed/simple;
	bh=TSm1BN9emZ76LQu0latI5pEpX1HqmM7/npDVoP2FMko=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jXLEMzPUV7Q2Hhe65BdLcpXaFWGhs3BTbRJXrpMI+IsnGZg2l4uQ4rlELj/TWe9Z1v3wve4g5dQ4xUrDrwsBf5scAatkVlnFf7HlniQtXNXAizny+em1ZQG+yno+Vwir+NtGrQlYXfbdRM4gMOzRcU5jRaMS3B3+7TVGR/yIbMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=X/OZULTY; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 49MDn5MC003018
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 07:50:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=facebook; bh=du7uXR3XWoZvnk0xJBO7Lrq
	L+u4jlZYXQvd50LOD9Zs=; b=X/OZULTYujw3VyHZiDcm5lhxnfi98dOgvWrN2dx
	ZhC7KECQTEfL2Nu3oK1k6d1RwVn2y2cYx3in34wIlrb32v7nLmUyQl3UyUPQTz1b
	1c6iQLc2BjKY3Ee6KXA4eOeOD3Iv9RY70d5Th8u0uPoaguz3krYDHKIAUtQjakjw
	iB6E=
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 42ea7hhgw1-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 07:50:44 -0700 (PDT)
Received: from twshared11671.02.ash9.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Tue, 22 Oct 2024 14:50:43 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 91BB27FDCDA6; Tue, 22 Oct 2024 15:50:32 +0100 (BST)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: <io-uring@vger.kernel.org>, Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH v4 0/5] btrfs: io_uring interface for encoded reads
Date: Tue, 22 Oct 2024 15:50:15 +0100
Message-ID: <20241022145024.1046883-1-maharmstone@fb.com>
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
X-Proofpoint-GUID: nPXXRWBtRurZDdEu97MNOFKF-XMwxp6S
X-Proofpoint-ORIG-GUID: nPXXRWBtRurZDdEu97MNOFKF-XMwxp6S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

This is version 4 of a patch series to add an io_uring interface for
encoded reads. The principal use case for this is to eventually allow
btrfs send and receive to operate asynchronously, the lack of io_uring
encoded I/O being one of the main blockers for this.

I've written a test program for this, which demonstrates the ioctl and
io_uring interface produce identical results: https://github.com/maharmst=
one/io_uring-encoded

Changelog:
v4:
* Rewritten to avoid taking function pointer
* Removed nowait parameter, as this could be derived from iocb flags
* Fixed structure not getting properly initialized
* Followed ioctl by capping uncompressed reads at EOF
* Rebased against btrfs/for-next
* Formatting fixes
* Rearranged structs to minimize holes
* Published test program
* Fixed potential data race with userspace
* Changed to use io_uring_cmd_to_pdu helper function
* Added comments for potentially confusing parts of the code

v3:
* Redo of previous versions

Mark Harmstone (5):
  btrfs: remove pointless addition in btrfs_encoded_read
  btrfs: change btrfs_encoded_read so that reading of extent is done by
    caller
  btrfs: don't sleep in btrfs_encoded_read if IOCB_NOWAIT set
  btrfs: move priv off stack in btrfs_encoded_read_regular_fill_pages
  btrfs: add io_uring command for encoded reads

 fs/btrfs/btrfs_inode.h |  13 +-
 fs/btrfs/file.c        |   1 +
 fs/btrfs/inode.c       | 175 ++++++++++++++-------
 fs/btrfs/ioctl.c       | 342 ++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.h       |   2 +
 fs/btrfs/send.c        |   3 +-
 6 files changed, 473 insertions(+), 63 deletions(-)

--=20
2.45.2


