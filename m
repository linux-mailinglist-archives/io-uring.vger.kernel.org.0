Return-Path: <io-uring+bounces-9571-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2416DB44659
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 21:27:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D57B81CC093B
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 19:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B996F271A9D;
	Thu,  4 Sep 2025 19:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="k+orytqh"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2607D25B1D2
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 19:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757014048; cv=none; b=D/V1zt99CNTk0eRB8V898NIrsUeE4OA+EL9TC52oup6pWOCQC5294awORAR+4jBcC3/HsnXWes1qZoLVSi3lrirjxeWDV6M83lzR32nyJ3n8UugxA1EJP/KRZ0+LCa+/KY7negYt8xLRv5uuyRL2nhW0lyWSgZCzyWy3BAC3NPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757014048; c=relaxed/simple;
	bh=UDSn/fN/Egt7g+Lj6in0l9gpRfWJOfOintydRmapizM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UezH/9+yEgq5vxxqRkdlTHyYJiyKUP56XOuPs6kPiKme5CQGGxEVK4ScVqOAp7tnxLIROuOgd/e0NEXH5P4IXg8WZ//DbQ24ZrvVt959880R8dsbCS0ez2lKeuH3V/PsBEiiVl+OjtMBRHaDgk9k6NGcpxiAw7F9Pq8/M66Tmoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=k+orytqh; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 584J84Ar1658920
	for <io-uring@vger.kernel.org>; Thu, 4 Sep 2025 12:27:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=647ymQXMRcTRP6TWwn
	O0VR2bQLvabova39IkZH3O4ZY=; b=k+orytqhqy65kDPjmWa2YB3ELHnUZiTbVb
	kGo/I3HexK1c04LYM8bA/Flb0he6yHHkCml/y0yUPWgo/yJetfUdszeSv9FDUm7S
	ED5RSgmDO2ail0cNdMtAZcLdH3DPbz4ZxFKMYxs/GwXWGryryYT7AVJb8buzTFMn
	8pvCT56X9+aeJ+s0YC+i0RYGxvepn5QSM7oT8SnzU+R8wLcCPD5Zcr2ROZ6oPgU1
	Am7j1YfvOGDwrRO1fMaGutL36KAPgm82rwiq1w258xe5Uu010l0lj8ZSLNITANVR
	qS0nmmdx5LJ2fawg85eA6fvJ4vzY4vl5+Uon49j2DMKiZpnwLw+g==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 48ydytj62b-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 12:27:26 -0700 (PDT)
Received: from twshared45213.02.ash8.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Thu, 4 Sep 2025 19:27:25 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 85CAF1578783; Thu,  4 Sep 2025 12:27:22 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [RFC PATCHv2 0/1] 
Date: Thu, 4 Sep 2025 12:27:12 -0700
Message-ID: <20250904192716.3064736-1-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=BuqdwZX5 c=1 sm=1 tr=0 ts=68b9e81e cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=3XHC07UCt-Vp8LPqvbwA:9
X-Proofpoint-GUID: 9ghFPSi_GrSqZCHrEQeAIuAPkVwG3Ifs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE5MiBTYWx0ZWRfX+2ROOjF1g8Mi
 ZHCoqi7GqyIS4mNeGfcwjeZR6/Pt8Q8Tg0+zosywSWKhw+qJSwfLbgknJlkkEdDK+uA29lJpTJf
 DRcSJEAQmdX9SRsfiBwIVdO8DaSoQhySfZUsUxcws1rKmIWrK358i6G2na4oQGHL5UzqOq6Hy0R
 IYC/FYvNhg4kEmIMKtDTKDcIBl+yY8oOcLxHvvMB8oczBrMEOp6UTMXWjqJM0a6D9noei/melEh
 nGHxR49NpDUmep+/j0pyE3VjpS6BxShd/klXyMfwmMMmaskCaVaz4iVQMhN5aQpnKfzMbAqI4kZ
 +2Bb2mFxRnLxP5dlb6sl1gna4qkQOIhPo1oyDS8m//f5ozRdmZtKVpVTNsS3fg=
X-Proofpoint-ORIG-GUID: 9ghFPSi_GrSqZCHrEQeAIuAPkVwG3Ifs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

The CQ supports mixed size entries, so why not do it for SQ's too? There
are use cases that currently allocate different queues just to keep
these things separated, but we can efficiently handle both cases in a
single ring.

This RFC is taking the last SQE flags bit for the purpose. That might
not be okay, but serves as a proof of concept for an initial look.

Changes from v1:

  - Fixed up the kernel's handling for big SQEs on a mixed SQ for
    uring_cmd and fdinfo

  - Added liburing tests for nvme uring_cmd usage and inserting a 128b
    SQE in the last entry to test the kernel's handling for a bad wrap.

kernel:

Keith Busch (1):
  io_uring: add support for IORING_SETUP_SQE_MIXED

 include/linux/io_uring_types.h |  3 +++
 include/uapi/linux/io_uring.h  |  9 +++++++++
 io_uring/fdinfo.c              | 32 +++++++++++++++++++++++++-------
 io_uring/io_uring.c            | 20 +++++++++++++++++++-
 io_uring/register.c            |  2 +-
 io_uring/uring_cmd.c           |  4 +++-
 6 files changed, 60 insertions(+), 10 deletions(-)

liburing:

Keith Busch (3):
  Add support IORING_SETUP_SQE_MIXED
  Add nop testing for IORING_SETUP_SQE_MIXED
  Add mixed sqe test for uring commands

 src/include/liburing.h          |  31 ++++++++
 src/include/liburing/io_uring.h |   9 +++
 test/Makefile                   |   3 +
 test/sqe-mixed-bad-wrap.c       | 121 +++++++++++++++++++++++++++++
 test/sqe-mixed-nop.c            | 104 +++++++++++++++++++++++++
 test/sqe-mixed-uring_cmd.c      | 168 ++++++++++++++++++++++++++++++++++=
+++++++
 6 files changed, 436 insertions(+)

--=20
2.47.3


