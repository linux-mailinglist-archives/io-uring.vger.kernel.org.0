Return-Path: <io-uring+bounces-13123-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uMgFLj3V6GklQQIAu9opvQ
	(envelope-from <io-uring+bounces-13123-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 16:03:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E7137447075
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 16:03:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C2F813090663
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2026 13:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62DA13EB816;
	Wed, 22 Apr 2026 13:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="IFYbt5lD"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1533EAC60
	for <io-uring@vger.kernel.org>; Wed, 22 Apr 2026 13:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776866284; cv=none; b=c3C3jPSiHs84V/h5KwsltMwVRGZ7GTsErRSfvWQES4c7FTlp1YkSdgtzNWgqgRyM8OpehAvz1+PCXOp+NDIo6RsfPiHBg6LQhErkVa2tnivgEcf5VcvupbSFeSuk/xLdx32xTfQsXKPpP4B6eKFBfvGUf9HrLGQ38sbF3HTVO+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776866284; c=relaxed/simple;
	bh=LGCjPxq9+/ot93Ord4Zb5yj0jo3AG6iUU/UW9AymfQI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qZYYmyLYbT7dBct22LMrKUPTcN2hR7zOTKCZB/Tqo7KfNyrnff/2bvjmKgzlTqZT0/LmCMdMAcw5Sg+0DhD8M7A3EnPPIRqPpuWdSejJf0Xigigw3o/9bUl1vCfMU5S4V8Sp46RV6APav8Gxq4r8cS2kFKKL/7QBS1CxkDZ/c+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=IFYbt5lD; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0528006.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIbb9Y460309;
	Wed, 22 Apr 2026 06:58:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=eITW/sQJbTVyoX5teE
	cuZWAKYpIE6cVbD3IXYnu7cLQ=; b=IFYbt5lDh/Q8juhocEyPOi2cfQsJhxFUz+
	ZpL4RY+6lQBe8d3IX8gm2H6lYKsqufvC2PQhHGJ9RqeTvF7QVOoJ/GBmoCOErwjc
	/lvJ/EqA2qiv/ZY+bnWZ4bs2pigguR+baw46SMo+FidvhYxdulVVud59GcMY/NOH
	AcBPp4EhIkNy/3kR31Vl/kolt7kSzRXAKXzLEFJ8C3Uxd5vMEF0IMCgTjLGqjxUv
	9lGe2coBlOFnPwdhjJLh2TihIOPZ9OLfo0qLnI6uoNtkinYXNHccs3ycKAmC99rM
	OOjZUyJccp/NJgUzvoeS7iu1a9LZsBgS1Hq5nWRMSAVksNXGsPBQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4dpep9nbxu-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 22 Apr 2026 06:57:59 -0700 (PDT)
Received: from localhost (2620:10d:c085:208::7cb7) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Wed, 22 Apr
 2026 13:57:58 +0000
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>
To: <io-uring@vger.kernel.org>
CC: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>,
        Jens Axboe
	<axboe@kernel.dk>
Subject: [PATCH liburing 0/3] zcrx: add support for notifications and statistic
Date: Wed, 22 Apr 2026 06:57:19 -0700
Message-ID: <20260422135724.528518-1-cleger@meta.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=VYjH+lp9 c=1 sm=1 tr=0 ts=69e8d3e8 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=kkcUborcUVj0H7zxAXTl:22
 a=Lcr2TwkPRyfvNUoJwZQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: qSSLXFja5uI0c07yhNFAMw0fv1GJOaLg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDEzNSBTYWx0ZWRfX2l8NgLQwHGvZ
 /CVDZ1iCkzQl6kRPM9cIYhv2cPf0Uit3aSLpCoyS21arGfammgUB0nM+qXeddoxty9Fh1Yzvslm
 0vhpdR1os/KZGfK0GPXgzGQUt2U+0AD6tn9Py7bJw/qEG+ID0RLd5Ukj+Oco7HPm3A8MBM2WdE6
 AszgCLW2B2hjKtWwAvoNuak52XUSvXl7WG8iCdCLHW4hk30paGGSCuSAsbZAE1EgRdccIjj7iFo
 SMm7yQ6knzYBPUkT0yN4HxygCI239of96VK5GiYdIX0UWfdZl8eCgZniyeZgE8cQLR32cxC0rC5
 Ese6vVZgGyUl6tXv26kEyKT/7LZ+J1pRM7u7qeVhSw5gV5bR1u/HHcDVsCJOOWQZkNjxQ75sxyd
 Lu2BFXw+6iIy84u+jVXlh1vzbhoUW6N/G5l5zbxfRM3lK65Q05tU5aPlNkfWdXnc9exnTzmqJOw
 BZQhJaJg678/FC9B+FA==
X-Proofpoint-ORIG-GUID: qSSLXFja5uI0c07yhNFAMw0fv1GJOaLg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Spamd-Result: default: False [-0.45 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.71)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13123-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[6];
	MAILSPIKE_FAIL(0.00)[172.234.253.10:server fail];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[meta.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,meta.com:dkim,meta.com:mid]
X-Rspamd-Queue-Id: E7137447075
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add support for io_uring notifications and statistics. This allows to
receive CQE notifications upon out of buffers or when copy fallback is
used to copy packets. An associated stat structure is also supported and
allows to track copy fallback statistics without requiring the user to
handle notifications CQEs.

Clément Léger (3):
  Update uapi headers to add ZCRX notification
  test/zcrx: add ZCRX notification/stats tests
  examples/zcrx: add notification support

 examples/zcrx.c                       | 109 ++++++++
 src/include/liburing/io_uring.h       |  34 ++-
 src/include/liburing/io_uring/query.h |  12 +
 test/zcrx.c                           | 376 ++++++++++++++++++++++++++
 4 files changed, 530 insertions(+), 1 deletion(-)

-- 
Clément Léger

