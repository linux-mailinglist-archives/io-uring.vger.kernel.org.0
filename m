Return-Path: <io-uring+bounces-2328-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E86491617B
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 10:40:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBD361F20D48
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 08:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A4101CABF;
	Tue, 25 Jun 2024 08:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FrZURWZB"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8729218E1F
	for <io-uring@vger.kernel.org>; Tue, 25 Jun 2024 08:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719304804; cv=none; b=Lp2K/j5ZGJoEZ9INMUaNaxCy/xXvE+kdBq601x2wVnHJTr/2H7a9N7KRiRjYsy0EM6vOfPQkfGdEPImv+59HXpDgR5802C5+qf3QqLHQpD5rOAC0NLW859GInQBSLyDy62HREn9/cBzCUiQJMPmTU7IF/AV/y5jS2oge7JM2+aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719304804; c=relaxed/simple;
	bh=x0h6zK81zeMdC2nbxPC6G2Vyzce29720Fg37YW0c+8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=dwj4ALlX9dUgNuMQEE6npK8OVin9ayuymLByFCRFD07NTfTaMZY9PH944SJ98TP/fpBUZdQ2b74MM6p8PtaaYMh5Wg0dRCdrw3t3iQkgOssXw+Op5D+MWXGGfrMcxmAce/bqMEFGTjwoa0R3U2q1+YOXDewzq14pmSpHiEufgHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FrZURWZB; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240625083958epoutp0373ce7a6c0a9cf3496015942c9c6a380b~cMprpx68j0815308153epoutp03F
	for <io-uring@vger.kernel.org>; Tue, 25 Jun 2024 08:39:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240625083958epoutp0373ce7a6c0a9cf3496015942c9c6a380b~cMprpx68j0815308153epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719304798;
	bh=x0h6zK81zeMdC2nbxPC6G2Vyzce29720Fg37YW0c+8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FrZURWZB7LbaR0YShmrzOTq3mfL3yJOKJqS8TuatUcZ9PNVPq2QOxLVz8Kf1rhMiB
	 oC4+1TsSxXfhff9wkzinqiJ3VYDM9H3bv1Hx4ISHHM40bFXNpjG+Fdn9I8OvNeyPr0
	 b713V3mdcr1YpZZ77sYISqP4ee6Z04yKBEBGZjPA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240625083958epcas5p4b061cfdc465701cf6ffe9f3ccef6b46b~cMprYgGAw2493924939epcas5p4q;
	Tue, 25 Jun 2024 08:39:58 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4W7dYm2Wg9z4x9Q9; Tue, 25 Jun
	2024 08:39:56 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2C.02.06857.C528A766; Tue, 25 Jun 2024 17:39:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240625083927epcas5p4b9d4887854da457946504e98f104e3c2~cMpOecyHR1446514465epcas5p4o;
	Tue, 25 Jun 2024 08:39:27 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240625083927epsmtrp13ed9e28a93148c9b2aed7be32fba41c1~cMpOd0HSQ1105111051epsmtrp1g;
	Tue, 25 Jun 2024 08:39:27 +0000 (GMT)
X-AuditID: b6c32a4b-88bff70000021ac9-13-667a825c0ead
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	46.26.29940.F328A766; Tue, 25 Jun 2024 17:39:27 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240625083926epsmtip2379fc54e913e25e0985f89d784b702c1~cMpN7tEfj1826118261epsmtip2H;
	Tue, 25 Jun 2024 08:39:26 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v5] Subject: io_uring: releasing CPU resources when
 polling
Date: Tue, 25 Jun 2024 16:39:21 +0800
Message-Id: <20240625083921.2579716-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <5146c97b-912e-41e3-bea9-547b0881707a@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsWy7bCmhm5MU1WawbtJQhZzVm1jtFh9t5/N
	4l3rORaLy7vmsDmweOycdZfd4/LZUo/Pm+QCmKOybTJSE1NSixRS85LzUzLz0m2VvIPjneNN
	zQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAlikplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVS
	C1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjN+r9nBVPCDtWLLmQfMDYxPWLoYOTkkBEwk
	+na+ZO1i5OIQEtjNKHF75hU2COcTo8Shs/PYIZxvjBJbd99hh2np/TSPBSKxl1Hi44aVUM4P
	Rom7l+4wglSxCShJ7N/yAcwWERCW2N/RClTEwcEsECJx80wESFhYIFRi3f5usBIWAVWJpetv
	MIHYvALWEis6+qCWyUvc7NrPDGJzCthKNB9bzwhRIyhxcibED8xANc1bZzOD3CAhsItdYt/y
	N0wguyQEXCT+PxOGmCMs8er4FqiZUhIv+9ug7HyJyd8hZkoI1Eis2/wOGi7WEv+u7IE6WVNi
	/S59iLCsxNRT65gg1vJJ9P5+wgQR55XYMQ/GVpJYcmQF1EgJid8TFrFC2B4SHx/fhwb1BEaJ
	NVfeMk5gVJiF5J1ZSN6ZhbB6ASPzKkbJ1ILi3PTUYtMC47zUcngkJ+fnbmIEpz8t7x2Mjx58
	0DvEyMTBeIhRgoNZSYQ3tKQqTYg3JbGyKrUoP76oNCe1+BCjKTC8JzJLiSbnAxNwXkm8oYml
	gYmZmZmJpbGZoZI47+vWuSlCAumJJanZqakFqUUwfUwcnFINTCqv5BYc4kl8e12g69UKbp3f
	+W2vV1bdW9/WG14jnl++Q2hl1WM3Vdve4rlOe95u+XTQWkzoSeSWGTfnBjjFFrh8PNdgarDc
	Um/uE6u2hLYe8b3Tt7hWzj34tiN2FqPxKjU9xtqTTNtPPUt1E/y8Xlpx7t8rB9M80m6+/Pht
	l1tHb48X/6p0w4NadX+kraf+6eKI2DnT5MSCe56Cv11F5Z7euvRzzp+TW1PULm7TlpOKnCpx
	5XREzv4z8p7rTB9/Ofvi61MXTT7bP5Z2O8oTvl4xeFBgt3fJfrMLO2/0RFTdKlh2ouW756ct
	8TGMM+WfcK3aey5u53s+16x3VY+zJfOKKnvvXSpwruS90muSw6DEUpyRaKjFXFScCAC222wN
	CAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsWy7bCSvK59U1WawdqtQhZzVm1jtFh9t5/N
	4l3rORaLy7vmsDmweOycdZfd4/LZUo/Pm+QCmKO4bFJSczLLUov07RK4Mn6v2cFU8IO1YsuZ
	B8wNjE9Yuhg5OSQETCR6P80Dsrk4hAR2M0qsnTGPGSIhIbHj0R9WCFtYYuW/5+wQRd8YJXp2
	PWUDSbAJKEns3/KBEcQWASra39EKNpVZIEyia8cZsGZhgWCJnZumsoPYLAKqEkvX32ACsXkF
	rCVWdPSxQyyQl7jZtR9sMaeArUTzsfVgM4UEbCRWzPgIVS8ocXLmE6j58hLNW2czT2AUmIUk
	NQtJagEj0ypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOAQ1dLcwbh91Qe9Q4xMHIyH
	GCU4mJVEeENLqtKEeFMSK6tSi/Lji0pzUosPMUpzsCiJ84q/6E0REkhPLEnNTk0tSC2CyTJx
	cEo1MGVtTHLor3j54bfijaCMvULb+ndmR4XN2fPf70S08fytZc94RPa8PtdnkX9VwNchUMXv
	qeiOI4EB+eEBRx7psC+OF48TXPTy6DyN6bNmFc/LedgqVR6+fukq9jkJwiJiISa5cfqlK/od
	n7f3+XNPEFbOyH71yc/C2qF14gW3hR5iXgznW1YfXK3+wn/Veoflj9Pn5kUcXT1z6oE5lwo3
	ebAFP1gZuL9qDn+NSRu32ZkLez+V7nhl2dxms9auyMVuYlqUWlVfvODJTXp+s9/ers44d/v7
	ZLbYEDvvnHsrhK8lXlnZ/znUV5h1/fSXpSuCpc27prO2xWisu938k6NVIvF/Zej7jCWFsjbL
	su66K7EUZyQaajEXFScCAL//ZxrAAgAA
X-CMS-MailID: 20240625083927epcas5p4b9d4887854da457946504e98f104e3c2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240625083927epcas5p4b9d4887854da457946504e98f104e3c2
References: <5146c97b-912e-41e3-bea9-547b0881707a@kernel.dk>
	<CGME20240625083927epcas5p4b9d4887854da457946504e98f104e3c2@epcas5p4.samsung.com>

On 6/19/24 15:51, Jens Axboe wrote:
>On 6/19/24 08:18, hexue wrote:
>
>While I do suspect there are cases where hybrid polling will be more
>efficient, not sure there are many of them. And you're most likely
>better off just doing IRQ driven IO at that point? Particularly with the
>fairly substantial overhead of maintaining the data you need, and time
>querying.

I rebuilt the test cases based on your information, that is, each drive has
only one thread with high pressure, there is a significant performance loss.
I previously provided test data for a single drive with multi-threaded, which
can achieve performance stable and CPU savings.

Thanks for your data, I will reduce the cost of each IO and submit the next
version.

--
hexue

