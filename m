Return-Path: <io-uring+bounces-9981-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA034BD59FD
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 20:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1191E402FD9
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 18:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B070149659;
	Mon, 13 Oct 2025 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="YFCjpA3m"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E248C1CA84
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 18:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760378425; cv=none; b=gQA6ubBmsJFGpEbXH+6uattTu41Ycn/SfCnXapPfN2kwP/UDkcS1bQyyxOutT5Z47GEEnAonVD4BY7Kf1seDN3NJjBcCdXy1Wib6Z+j3KM6+R6QvriCPZhHQ0fHVShhHKzX5sC6KlbapL/AnyFMzuyY2dL5bdfPQQdMz6gXxtEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760378425; c=relaxed/simple;
	bh=btLuGy0OB/1jM8ExK0vUw1weho1aRqVx3V2dt1vPUmE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RlxJL6yyiAeZj0Rfrl9ZUGiwtlDbaRXiAYEhtxuue9tZjQW/j3Kzwmf6Sy7WJl1W5mf6uZWbYblYVrXu6/wmnWPld6H+zyBV7CN8fPO4g8wC0xQBXCk1ae1N2UYkfi6qjvXi7prb888QZl7UTgh4N2QiL/+Slli4Gjf8wKCTuH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=YFCjpA3m; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59DEMkuA1942041
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:00:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=a0rttkEc+q7PYVQkLswnuSQq1CFrOFdUKB1+xz9CC54=; b=YFCjpA3my548
	/sGRPxZaylweg4Io9ie/rWnHp2q9Y9PcCXAF/yi1H235CMPne6dbznm3Xel/r13m
	+iijlcOBY5EPKhM0vInCiTtgPXavAL6KXIhRaZkCmPv6O5pYmfs5Yob7hURNsgz7
	wD1oegaSikzG1ytzZb03lBsiXgK4NHZCb7QieFIDX/knexEOu6YPwFhQruzAhqpD
	hwIAaEpdDXh7jwGjwkcsX6gxTNE1EmlAhrNjfPB8J9UTXGT3629txcxcblhL9Qz2
	EkPaRRz3Ct8qN+ZzXr0qllzkoWtlxAstegFYt1PdTVbxyCJH7Yq+O063L3ysu/Yt
	A8lslXjXxw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49s34vt0a8-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 13 Oct 2025 11:00:22 -0700 (PDT)
Received: from twshared42488.16.frc2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 13 Oct 2025 18:00:18 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 70A8F2AB3F77; Mon, 13 Oct 2025 11:00:11 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv5 0/1] io_uring: mixed submission queue entries sizes
Date: Mon, 13 Oct 2025 11:00:06 -0700
Message-ID: <20251013180011.134131-2-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013180011.134131-1-kbusch@meta.com>
References: <20251013180011.134131-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEzMDA4MSBTYWx0ZWRfXyjobzsT6NMV2
 +Gg8H3AdkC3E7e8vIJJ191p+F+7UXY3P79BQQ7te8TkU9CsPDXo8fKZTwQjQsiTSg0S7R0DLb5e
 otqjO7haH0taOA86nADnDiKRAIqLLrbZvLFxnKFyk594gCaAiqbp93Y74CsIhn84fG+eQHFj8Of
 ZvEOVDhHiZjWzXqXO7RqfkX2ER5iXKIsfEPymDcAG4O7OHW/So0GQ6+V+Ofj6b9HfRa3QKWE7gL
 nXOPtvCKZI3xne8C+ddfP29oXjbwYQG7bHJmqJ0WLTbTC+s/iiearpGVM7ni93Mmqnxm6BWyKut
 TxZPTTjD4MKFkkPEOjc/BzA9T8j1644SMQueqD5i7cDNS5nSrnCgEsBa69c1kID4RCUdPm3aVPC
 dy7rXjx7s2aL+tKNp2HFzRtdKNkNHA==
X-Proofpoint-GUID: lI67fAIM5waH6DgK4GlqRM3Z61mQuWjR
X-Authority-Analysis: v=2.4 cv=TMBIilla c=1 sm=1 tr=0 ts=68ed3e36 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=Q_LS-WoNEPSO0wj3tYwA:9
X-Proofpoint-ORIG-GUID: lI67fAIM5waH6DgK4GlqRM3Z61mQuWjR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_06,2025-10-06_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Resending to the correct mailing list.

Changes from v3:

 - Allowed 128b opcodes on both big and mixed SQ's

 - Added additional comments for clarity

 - Commit message fixups

 - Moved the uring specific entry size fucntion to the uring code.

Keith Busch (1):
  io_uring: add support for IORING_SETUP_SQE_MIXED

 include/uapi/linux/io_uring.h |  8 ++++++++
 io_uring/fdinfo.c             | 34 +++++++++++++++++++++++++++-------
 io_uring/io_uring.c           | 35 +++++++++++++++++++++++++++++++----
 io_uring/io_uring.h           | 14 ++------------
 io_uring/opdef.c              | 26 ++++++++++++++++++++++++++
 io_uring/opdef.h              |  2 ++
 io_uring/register.c           |  2 +-
 io_uring/uring_cmd.c          | 17 +++++++++++++++--
 8 files changed, 112 insertions(+), 26 deletions(-)

--=20
2.47.3


