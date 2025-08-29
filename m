Return-Path: <io-uring+bounces-9479-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD1FEB3C33E
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 21:42:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1E4B3BB7CC
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 19:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 976212459ED;
	Fri, 29 Aug 2025 19:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="vJIrYYrM"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FF1245005
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 19:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496396; cv=none; b=Fff/uSW34AodnhApP7QsaoU81yB8AfjTfU2IMtCzsutI5eU762tmW50+bLwJSNC1gQ3BiDkjiAzypMizijaX2vDtF8gdrWJrxl06gXkSGPR1uDoFe1aSe4Fn4R+cYYI1xaKL3W3tCkgSKZH5frNKacnCQXi//OpvQzcBQSHt3j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496396; c=relaxed/simple;
	bh=G5M3fFbaK/5oL2CtVAP/ILiwzHhLVL9ASDKF5ZzsMIo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XrzdShBaYLHTgSGIcoeU7Q/tVw1WQtgqYwMgVMm/B0MdqnmW6ibwiOn/GRnA+c7mBfvy15lbVGtrpa+2IYNuRymQZtipK1hG5hvvxLpxCFKkhLHki+7AYcW6eeq+FRh4nf7qiKUEBHnILb924mluYBd5YQWQA8mFbo7/I2JJ4YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=vJIrYYrM; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 57TIO0Ho791068
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 12:39:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=vBMRJMHhEy51IuBU5/
	QPL5ML3sWS/rg0qPLggDxkeTY=; b=vJIrYYrMA8v7Qpmz5VVLns2hqJ3QhMVqfc
	xGVFpRlHD2wAjdhkHg7x737/tLADeH3nqmEVUB3FwccepRm9xU3ZVHELmE2SXjjO
	Ypi0AZnxVbbLJzPhccy9sX7ASsyE680YyAXtEZB2bixRB8ip9o6da/zC1hoJtJss
	EvKQILTpdtVKmU3MGNDvq9shBkLIGqFyMf9JkIuP5RE+yDNAxykd55QXf7PeQYct
	CUlT419+nt6/auOuy4iAGFpSBdr69GvgwbBgA/x8RaUVjAQupMq6PFCq66pxuP4O
	eCylmPSENd24jyOWc2Zx20TFtXks2J7HsFB7f3vND1rgauJkAQrg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 48uhet0jag-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 12:39:53 -0700 (PDT)
Received: from twshared25333.08.ash9.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.17; Fri, 29 Aug 2025 19:39:52 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 9E4EC121EBB5; Fri, 29 Aug 2025 12:39:43 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <io-uring@vger.kernel.org>
CC: Keith Busch <kbusch@kernel.org>
Subject: [RFC PATCH 0/1] io_uring: mixed sqe support
Date: Fri, 29 Aug 2025 12:39:32 -0700
Message-ID: <20250829193935.1910175-1-kbusch@meta.com>
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
X-Proofpoint-GUID: 38YgsdgD0QB_yVVamg7vYHm_xh940WRd
X-Authority-Analysis: v=2.4 cv=R9UDGcRX c=1 sm=1 tr=0 ts=68b20209 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=LEcnF4cmSA45hKYyEJUA:9
X-Proofpoint-ORIG-GUID: 38YgsdgD0QB_yVVamg7vYHm_xh940WRd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI5MDE3NSBTYWx0ZWRfX5BIvNoQwostW
 OoIcwCVgoWQE0nO7SNFwy1hHtJPrYyxEjH34i/MxWzLhdzZtze2s2i8zGJn/cSJzn+ETiXwaFJR
 4KvaHTI+Z2u6qX8ow8GKdnHpPPFFEi1dX5rNSFeBIuGPh/f/G/8egwvoQis05OvHJVhlrIUdhUy
 kaiM6lrh21EcXLbVgQneY7Db5rxF8WZ4xXoIFgfyiOcLwuziELSVwHogYhjXFeAIjhfgeAQQFPN
 fd+A5NguUSMKp0ehs9a0TjCFLrNY44nGvYZypwbHFZTkQ0806HazQ/vYzZVDgzxNCZlGlU2e5sD
 B/EG6IJ72wzD34Qi9Jmf+lx9qfUsqjzYeYdlkzaqWahhPIOwLP0P6EY5eq/oH8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_06,2025-08-28_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

The CQ supports mixed size entries, so why not do it for SQ's too? There
are use cases that currently allocate different queues just to keep
these things separated, but we can efficiently handle both cases in a
single ring.

This RFC is taking the last SQE flags bit for the purpose. That might
not be okay, but serves as a proof of concept for a first look.

Keith Busch (1):
  io_uring: add support for IORING_SETUP_SQE_MIXED

 include/uapi/linux/io_uring.h |  9 +++++++++
 io_uring/fdinfo.c             | 21 ++++++++++-----------
 io_uring/io_uring.c           | 15 ++++++++++++++-
 3 files changed, 33 insertions(+), 12 deletions(-)

--=20
2.47.3


