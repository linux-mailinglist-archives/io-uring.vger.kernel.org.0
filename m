Return-Path: <io-uring+bounces-9984-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2029BBD5A09
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 20:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8AAD64E9AEE
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 18:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577A2221DB0;
	Mon, 13 Oct 2025 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Yijs1z4W"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99ADC49659
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 18:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760378429; cv=none; b=leTDas2l3rg1nreEE1yNqtvKQ2GNhjCO5/WWvDIY+F/eaOn3MNtxuGnkf6k4+zKa9dTQJRBPZy0PehCv86UA8QMd6w+xxYIoFRT4Laef02+M+xdURMlz4vYn930ZgD51/Zv8HqwspS5ZZHkalTjxpB1Ryq/dc4P6hrt6n2too1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760378429; c=relaxed/simple;
	bh=y7eUjupwk25vo0ywymDIUgdu0mFltHblS+Bx2R2ders=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rNqv4yfkFamFctfuud6Xs8tV93Ttb9MYAd0HXKEXwGSFo4RnCyI/9xMmmaghB4Fk5QvCkLTvVbfr/tyGcc4bSPPuSoGWnoy2Buydx/Zf2omFh57NrKSfmXvsTiBYLL7EkfQOABzflKw8h49OOh3TRWU7jXkMpxhOidC1OojAIYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Yijs1z4W; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 59DFC07D3404722
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:00:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=KNrkJdrz+zm23Qccy4
	5rlDEoj3VcFbPW/vgjCgR2QWM=; b=Yijs1z4W+Cu8ppiWwcEPtKMgHgsOYlKs5W
	/VxiZD7LJqhI15raGCeCforDzhPW5bZcarRxgNfDDWsceE6OaaprM5zVaKnPk9mY
	p0rsFiPmXB9N7i5dsY/lbjhC3GeJEXIh8bg2MTvJFp0n3UEAO/e5JGOgEeTmi9Ho
	iz1wSVPAS4rqJAhJaRSC8brUUTBWRY0FFnEAVCzuo7HsBkZxOZssQHaD32yyYCcz
	zcB+kI8VJlRQl9LIavLlnnECYRAAvrASlQFvcY6+uLQnHHEMJphE6KXnl8XO+ZRt
	Cz8XrZXEKjgTwTEfhyW1FDsyjr264v18gEExCcHlhlUVtg5PMH3Q==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 49s3uysjrx-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:00:26 -0700 (PDT)
Received: from twshared0973.10.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 13 Oct 2025 18:00:24 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 6F2EA2AB3F76; Mon, 13 Oct 2025 11:00:11 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv5 0/4] liburing: support for mix sized sqe's
Date: Mon, 13 Oct 2025 11:00:05 -0700
Message-ID: <20251013180011.134131-1-kbusch@meta.com>
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
X-Proofpoint-GUID: kSZDgmeVCAOe_ZJX6j4iwgk7j70tjIEu
X-Proofpoint-ORIG-GUID: kSZDgmeVCAOe_ZJX6j4iwgk7j70tjIEu
X-Authority-Analysis: v=2.4 cv=df2NHHXe c=1 sm=1 tr=0 ts=68ed3e3a cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=HSQpo1lqXIhcmgcK7MoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEzMDA4MSBTYWx0ZWRfX3A+wm7puMByR
 k7AqLjlltMhQoQeVd2/JfT3xPKhV1EWS0qWVPVaM4/1SR5EHYOP5gsaOzvKnhu595JkDQoHkvnm
 LR2Tj+AdNa9FfJPJnedBXdbkg2jfpPIfDrmguGTFHs2jhUULRB5WiGfbOiX/RzBnqXaI+3q//v2
 Di9aDscVipCn6KTnnLSwaRBIfRugSKG6dLiCoyPUXcKdZxGGRs+gNtCkUytfxUma2TXrDQ2/m9T
 2G1txi73EedCRPgke5Fbk5BeU1bLOSi8ONFWgGRwOhFB4JNRO7l5vPTC/GkxxrovrdJtBE73H1g
 udYXGuhzgrlkIIplqCByZo4Q49blPeXLRwGbOcueZVCzJyYrVB5N0qBIyS3XAkJxtuwLHNo2E4o
 HmzfXZWtboiGAXwluaDVLec15NZdOg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_06,2025-10-06_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Changes from v3 and v4:

   - Removed the old artifacts leaked from previous versions

   - A prep patch introducing a helper for uring_cmd=20

Keith Busch (4):
  liburing: provide uring_cmd prep function
  Add support IORING_SETUP_SQE_MIXED
  Add nop testing for IORING_SETUP_SQE_MIXED
  Add mixed sqe test for uring commands

 src/include/liburing.h          |  82 ++++++++++++++++++-
 src/include/liburing/io_uring.h |   8 ++
 test/Makefile                   |   3 +
 test/io_uring_passthrough.c     |  14 +---
 test/sqe-mixed-bad-wrap.c       |  87 ++++++++++++++++++++
 test/sqe-mixed-nop.c            |  82 +++++++++++++++++++
 test/sqe-mixed-uring_cmd.c      | 140 ++++++++++++++++++++++++++++++++
 7 files changed, 402 insertions(+), 14 deletions(-)
 create mode 100644 test/sqe-mixed-bad-wrap.c
 create mode 100644 test/sqe-mixed-nop.c
 create mode 100644 test/sqe-mixed-uring_cmd.c

--=20
2.47.3


