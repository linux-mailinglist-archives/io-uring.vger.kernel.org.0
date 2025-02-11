Return-Path: <io-uring+bounces-6339-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A261A2FFC8
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 01:57:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C27F164486
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 00:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6841524F;
	Tue, 11 Feb 2025 00:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="fQ+g9p/B"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F867B3E1
	for <io-uring@vger.kernel.org>; Tue, 11 Feb 2025 00:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739235438; cv=none; b=kfmEBr73F+z1rS+RMecewkwjULhi8y6yLQlgxteD8AbeI01kuT6r4XF6Wg0nuzW21/EpVQfIGJEvmlYmKnAihs1etihOmFRRwxg5zwNB6XuaUWkWGosMzOmFOufbHRLM+kFHaI8KqRgIY2bRjivOOveb2AIHQ+NJyEgZ1ZFzvqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739235438; c=relaxed/simple;
	bh=dQTSbey2I6qZYTRrpe1OAJ3O8Fsu8vUxAtS502Ul64g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QDada+9Sl+rdShIJFEsHbiSduCm1D3z7pFh7hOH2wwzD5H3vMnLcTq5pdsiSVWdQWWFoFmPk7dlUbJKyRz/Uov+M4WFMOo2qApLkLOV9zqJFWOcQonoO9pGcNKOhQnaoNQQNNm64YHSdSYYw4fNNmNpfSldodAWuzgMLycCikj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=fQ+g9p/B; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51B0ogKh026613
	for <io-uring@vger.kernel.org>; Mon, 10 Feb 2025 16:57:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=TLQ2xNCftVMO3UKGr4
	33gL23Bpr8l+JzYk0nggM5K4o=; b=fQ+g9p/B9N8mH4/unDYUbB5pCAtN71GxHV
	MkJaBnra43HsfwUJzcLnsgrVY7lqipddycAoQPLYrTO+Mpck889fP/Xhva2eC2a/
	rybXVrB3BMfwXkGSF2V4fXeVJpx3CAtzc1nNxrn7CoGSkGwIScb21Zn9DlFebtsQ
	Mi72QyU+ZgQaKiSFI15SvfwFi3WjuKVdjShXizWH9d6ZmB0uB0ec009wt8ZlA3B6
	/zhUi5r2dfLTvK39QhTqFRf86HPTEol4ChY3CIlGJGhI2c9bbf3GtEgxjZruY63I
	b5CpNxsCRP4dC7CgQVRsd6pXJun5Lj1BUA4WYxGDwryjGxL6RwwA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44qqg2jc01-17
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 10 Feb 2025 16:57:16 -0800 (PST)
Received: from twshared3076.40.frc1.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 11 Feb 2025 00:57:02 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 7599917E18F7C; Mon, 10 Feb 2025 16:56:48 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 0/6] ublk zero-copy support
Date: Mon, 10 Feb 2025 16:56:40 -0800
Message-ID: <20250211005646.222452-1-kbusch@meta.com>
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
X-Proofpoint-GUID: eZrr4AwtkXOten_IuHeKxARRwLy92o1w
X-Proofpoint-ORIG-GUID: eZrr4AwtkXOten_IuHeKxARRwLy92o1w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-10_12,2025-02-10_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Previous version was discussed here:

  https://lore.kernel.org/linux-block/20250203154517.937623-1-kbusch@meta=
.com/

The same ublksrv reference code in that link was used to test the kernel
side changes.

Before listing what has changed, I want to mention what is the same: the
reliance on the ring ctx lock to serialize the register ahead of any
use. I'm not ignoring the feedback; I just don't have a solid answer
right now, and want to progress on the other fronts in the meantime.

Here's what's different from the previous:

 - Introduced an optional 'release' callback when the resource node is
   no longer referenced. The callback addresses any buggy applications
   that may complete their request and unregister their index while IO
   is in flight. This obviates any need to take extra page references
   since it prevents the request from completing.

 - Removed peeking into the io_cache element size and instead use a
   more intuitive bvec segment count limit to decide if we're caching
   the imu (suggested by Pavel).

 - Dropped the const request changes; it's not needed.

 - Merged up to latest block uring branch

Jens Axboe (1):
  io_uring: use node for import

Keith Busch (5):
  io_uring: create resource release callback
  io_uring: add support for kernel registered bvecs
  ublk: zc register/unregister bvec
  io_uring: add abstraction for buf_table rsrc data
  io_uring: cache nodes and mapped buffers

 drivers/block/ublk_drv.c       | 145 ++++++++++++++-----
 include/linux/io_uring.h       |   1 +
 include/linux/io_uring_types.h |  28 ++--
 include/uapi/linux/ublk_cmd.h  |   4 +
 io_uring/fdinfo.c              |   8 +-
 io_uring/filetable.c           |   2 +-
 io_uring/net.c                 |   5 +-
 io_uring/nop.c                 |   2 +-
 io_uring/register.c            |   2 +-
 io_uring/rsrc.c                | 252 ++++++++++++++++++++++++++-------
 io_uring/rsrc.h                |  11 +-
 io_uring/rw.c                  |   4 +-
 io_uring/uring_cmd.c           |   4 +-
 13 files changed, 355 insertions(+), 113 deletions(-)

--=20
2.43.5


