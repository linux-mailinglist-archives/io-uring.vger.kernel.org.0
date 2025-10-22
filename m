Return-Path: <io-uring+bounces-10129-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 93E3BBFD89A
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 406B1358B51
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3CD285CB8;
	Wed, 22 Oct 2025 17:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="DfYsOrII"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E86A2737F2
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153686; cv=none; b=DEpio7yUosJK26dW0BIGB39SJH9bCuwTMtBeWN7OXXh4NYPk5MeWW8Tn8bWpqSRW9U8kwGT78SjdDNePBXOC3pEgFyPWHmxmXNzA87Ogu5fSszgkQcEW8k1TWLYQiqAPEv8a5AtvQesGdtKA1CLzcbG45xTaLyqOxCD9A6R4ZtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153686; c=relaxed/simple;
	bh=szIyqSsFsC4GHo02p1vmI1XKqf6tTRf6MR0CX8bAq60=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uLZ7b/thOyGkclm0d0iHnzSW4vIYOyunonlooHPrxoJDDYs9pt1rVyNLwzg4gU3mjdMmyO+QWz0HJnO52wdGkmWeIz9mvzKE2NOacaWuEiJAlhCeD8EJr6X4A2DT84rQL+HlUDlacNcyvoZocrZmVtbPOB84MmgXpHbZ90JaszM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=DfYsOrII; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59ME9TQt3459161
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:21:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=61cHS1960JTZsUcbx2
	Emx/jBG+xNZBRJpGui1UuU7zQ=; b=DfYsOrIIMwFymLGdpemdzM8TKNSN2R0S/W
	ondHiVT14aEE5qPuhLgYDWKUfi3yN894f4srR1My4T5ra7yfUtCbzJM3ulmq11as
	2Y5TD22cUN+l9SJQfZUUKi/IPGEHewBFcHWr2VyLNw4WpTWmKCkElqhoAJDQYIOg
	RL1RzjraHBegshH0wCP78sEcGzZYZGTz2X0Awk9sBX1m1fEVMv43bElG940tMidr
	z++oxccwkCLUku0YUpUz/RbrB85OHfyYT0uMLcBKNDdSR0fcNuGPXKn1afPAy9Dm
	EtPd7WdzgERusuYe813PFn7MDoK+O6Y+eQtDtXAW2a80hNfmAn5Q==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49y0sjssbr-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:21:22 -0700 (PDT)
Received: from twshared0973.10.ash9.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 22 Oct 2025 17:21:18 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id CFE022F95CAE; Wed, 22 Oct 2025 10:21:04 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv6 0/6] liburing: support for mixed sqes
Date: Wed, 22 Oct 2025 10:19:18 -0700
Message-ID: <20251022171924.2326863-1-kbusch@meta.com>
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
X-Proofpoint-GUID: cui8eND-fB-0QmiWsmgSQCgYAk3-onQ-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDE0MSBTYWx0ZWRfX1slQ5BfvN8FM
 QiGuXWXOB2htYxr658p0bKCA9v0Q2JQxEOkE0DFIaYhqEbrFKVLaEmkQYdWGeib0tnaETh0Cy/Q
 rCa09OazSghzo0PISx4Vvph1vW4eoJBTachQ6NtP5eYMJeK/twzLG4Gj9v0I7skZGPAhwSkm2jx
 ktzTjiMwQ1opCWQDGa9eAnjSs8/GJw5xtHPhEBUx7FV6izxWL5gfTQShNF8WtZ4zIHlmKnhMNbD
 HHhHgPF4rGZKcongqwAQbUedcMynhUwfSUa2+YAU9mjNzAWNH6w/DmShlc8hfMVv+u9qaroIH0q
 rIjnpBrEFwNiZrkfV894xetBVuT3Hjh9euMbG05+rcLxxt2sOlCDJ0BvXAegfL3XxLO8brz6hm0
 CatRNed2y800/Rs4+HyLvGtj/zB5Dg==
X-Authority-Analysis: v=2.4 cv=AoLjHe9P c=1 sm=1 tr=0 ts=68f91292 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=n3WiU3FGNjuRN7ARKjEA:9
X-Proofpoint-ORIG-GUID: cui8eND-fB-0QmiWsmgSQCgYAk3-onQ-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_07,2025-10-22_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Changes from v5:

 - Fixed up braces and line code style

 - Added fdinfo mixed sqe tests

 - Fixed up errors when CONFIG_USE_SANITIZER is enabled

 - Changed api name to io_uring_get_sqe128 from
   io_uring_get_sqe128_mixed

Keith Busch (6):
  liburing: provide uring_cmd prep function
  Add support IORING_SETUP_SQE_MIXED
  test: add nop testing for IORING_SETUP_SQE_MIXED
  test: add mixed sqe test for uring commands
  test/fdinfo: flush sq prior to reading
  test/fdinfo: add mixed sqe option to fdinfo test

 src/include/liburing.h          |  84 ++++++++++++++++++-
 src/include/liburing/io_uring.h |   8 ++
 src/sanitize.c                  |   4 +-
 test/Makefile                   |   3 +
 test/fdinfo.c                   |  51 +++++++++---
 test/io_uring_passthrough.c     |  18 ++--
 test/sqe-mixed-bad-wrap.c       |  87 ++++++++++++++++++++
 test/sqe-mixed-nop.c            |  82 +++++++++++++++++++
 test/sqe-mixed-uring_cmd.c      | 140 ++++++++++++++++++++++++++++++++
 9 files changed, 448 insertions(+), 29 deletions(-)
 create mode 100644 test/sqe-mixed-bad-wrap.c
 create mode 100644 test/sqe-mixed-nop.c
 create mode 100644 test/sqe-mixed-uring_cmd.c

--=20
2.47.3


