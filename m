Return-Path: <io-uring+bounces-13649-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id HUJMEg7ZJ2oh3QIAu9opvQ
	(envelope-from <io-uring+bounces-13649-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 09 Jun 2026 11:12:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ACD5B65E26A
	for <lists+io-uring@lfdr.de>; Tue, 09 Jun 2026 11:12:45 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=YNdasmrI;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13649-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13649-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A1C2B3088D15
	for <lists+io-uring@lfdr.de>; Tue,  9 Jun 2026 09:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D5D36EA8B;
	Tue,  9 Jun 2026 09:02:17 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421243101BC
	for <io-uring@vger.kernel.org>; Tue,  9 Jun 2026 09:02:15 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780995737; cv=none; b=WZ1tJYwqcE05ol/S04y4sz7/Jx+SWFadr0WbyCrVK9T1CmdmuKxdpbA2UJlwzPxQgQvyTzNrni4pQ+6+2whL4BNGY320p95e9JpFp6UIs1sTLAO3ClzYq1UcRZPVvT/rEK/erwrX2rI5oOtxPqaQVipkRPiqASOTcZVKImRZwho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780995737; c=relaxed/simple;
	bh=MO9DdEmFREMzWNKtPRgTBi5xY/IEdgm6hE08Lwh8L14=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FHNxfE9EEoUXAekQo3hb/5VHAMVj0oBj4tncImCpmP7IXmHk9/Evf70qc9ahi9LxSBju9EpTUmkTvq0rFtLhqXzOa48M0v1NYlEva20IXUN/Q8jYDTzlHyWEFqDTGKe008ojGRQOwG7XhUMzuk1oQgSMbohtly5r0WX8nEeYsHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=YNdasmrI; arc=none smtp.client-ip=67.231.145.42
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658JWUNm1173470;
	Tue, 9 Jun 2026 02:02:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=3zJHtjWRnCeKAy/ACh
	TSm4naja1fsl8aEe+5cWGZq2I=; b=YNdasmrIcbc+jSbbM1vPDGyHvtjBVcf1tJ
	zPm5M/cNKKLwmm/owg5PXNi9ksEI5ZCkTvN3ZmAK5wWQtozgk8UAhFZD9mZP4yoF
	XVXxJO1kO+O3sGPgxmJwXKzMwvT8/UGOYEgGtInT0ApPcJ9YlojneOt0tVVQQ3sU
	5+8l1Wd+U23SOgxxnWcEJnkK5iONbC4fqZBjohDtM/UsM3ChPIhwKJJVfvqypnnE
	0ZhaxxaVOkal8chryhzKuXmEKWJtS484qxDdWFiYLUTS5JVgVzWC9qDabSuyMKaZ
	hE7VVFbYq9MmOAFKpgvsjHdHVPcaWLJr1eR1Ebk5atGNoC4UVGvg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4emjum6s1t-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 09 Jun 2026 02:02:14 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1b::30) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.41; Tue, 9 Jun
 2026 09:02:13 +0000
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>
To: <io-uring@vger.kernel.org>
CC: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>,
        Jens Axboe
	<axboe@kernel.dk>
Subject: [PATCH liburing v2 0/3] zcrx: add support for notifications and statistic
Date: Tue, 9 Jun 2026 02:01:47 -0700
Message-ID: <20260609090156.3862920-1-cleger@meta.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Fvk1OWrq c=1 sm=1 tr=0 ts=6a27d696 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=crHB47gyY4rKiduisYu9:22
 a=Lcr2TwkPRyfvNUoJwZQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: lmwOt6fNyEykeHEG4SM0XZIYeYxShunH
X-Proofpoint-ORIG-GUID: lmwOt6fNyEykeHEG4SM0XZIYeYxShunH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDA4MyBTYWx0ZWRfX0mWvDhrMDIqQ
 tg1+m3gVuDJVcYGN8g2e7XT9cTfdQYCScPt5bYvzihtjSjYllpobPUr7vgPp5EN/GzkbIcIFgQs
 I56teetvJo9DzMI9oIyngvAA6YXcr9dA0eseOFYZnpkLxt0m+sCmWxIhkjO0py2HTUNzFfWILE6
 vcOykg7kHBtsU3I9w7DFLUKmBat76A2c1ICWBSU51fkKtUAzS6KFlW+xEzLuxGoNkfZB7xsHyjh
 R8CGti7wkl7eVb7GHKENlpZOW8No3gwXNP5YcafRD1JPZYPBkKMvQqIYLxcNr0AlpZcvmRCeT+U
 9ed13CUiFnhBRzuOC6O+iMXFHiwENMY8cLZJzrBL09oIsi9SnpwBt4DiNuLbuohLVTnIqJr83Xy
 ZJUGBXuWzNoXynQDXMrt/0WzraZt/71itYhc/jTYx/wNZQSyud/QrqKDQca//k8uMQVpKTENz6R
 ANu62MKSuGfSgcKgfPw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_01,2025-10-01_01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.49 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.67)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13649-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:cleger@meta.com,m:axboe@kernel.dk,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[meta.com:+];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: ACD5B65E26A

Add support for io_uring notifications and statistics. This allows to
receive CQE notifications upon out of buffers or when copy fallback is
used to copy packets. An associated stat structure is also supported and
allows to track copy fallback statistics without requiring the user to
handle notifications CQEs.

Changes in v2:
 - Update kernel structure after padding/reserved changes
 - Update test/example to use interface with a single event type rather
   than a mask.

Clément Léger (3):
  Update uapi headers to add ZCRX notification
  test/zcrx: add ZCRX notification/stats tests
  examples/zcrx: add notification support

 examples/zcrx.c                       | 110 ++++++++
 src/include/liburing/io_uring.h       |  36 ++-
 src/include/liburing/io_uring/query.h |  12 +
 test/zcrx.c                           | 376 ++++++++++++++++++++++++++
 4 files changed, 533 insertions(+), 1 deletion(-)

-- 
Clément Léger

