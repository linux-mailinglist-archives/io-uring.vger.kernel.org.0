Return-Path: <io-uring+bounces-2523-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B1C8934B71
	for <lists+io-uring@lfdr.de>; Thu, 18 Jul 2024 12:02:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC0A81C21911
	for <lists+io-uring@lfdr.de>; Thu, 18 Jul 2024 10:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C15FA12D76F;
	Thu, 18 Jul 2024 10:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EvvCop/Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDCA8286D
	for <io-uring@vger.kernel.org>; Thu, 18 Jul 2024 10:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721296945; cv=none; b=giKTa7RDaRWrmZFQElCnAWZ0i7Mn77Pymq8Um9S8iK7djT046QQRm4QxrbFX94bUAlSvyESs0mDtHdy91oYuCqpgZ3OuB34h3RZ8NC6kc7orG1ESqOldSeoUC9MN0yphuFoUXsoRkikzUDoaRlX327PaxzLGVuS7yFhmlgPVkEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721296945; c=relaxed/simple;
	bh=E4WObEXdg2x+zMuBUTWmGjfhILP+Bo+7aUXRUvh2dx0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=t9UkYKNBLghZzxkGm/NCQA/qstjDmQvnBO1Y+arzHFYMmWBn/52D9Ce3SQ4Ktyp9UoP3gwOPu0dIWyMHNsxSxEVLIu2v+6b4K5NlP1QI/oYdwd4ZGiwNjfjnEf/P6caf2zsO37O40IJAh856nZ9jrPgSBcaBR99iCicloXJEvj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=EvvCop/Q; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240718100215epoutp0183cce0b9da682eb86c0dd4a42c59591e~jRnFeu5fY2438124381epoutp01V
	for <io-uring@vger.kernel.org>; Thu, 18 Jul 2024 10:02:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240718100215epoutp0183cce0b9da682eb86c0dd4a42c59591e~jRnFeu5fY2438124381epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1721296935;
	bh=E4WObEXdg2x+zMuBUTWmGjfhILP+Bo+7aUXRUvh2dx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvvCop/QBEjNNCp4xE7TQLbSqNWPuqnwbHhQXoyQVAadfOl+r+seF3yZwRXcBUz6b
	 Du0uL4MEp2oK66L3TewbpEYWaz/4B5p5N6SeV5edQkp0pL8gQJST2yCtwWg201ngWU
	 O3V6ozhgTIvTWwKS9s2D9fhZqi5OAuIBV32Aps3I=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240718100215epcas5p2329a43fef460ce02ae36677320a3b115~jRnFOhtNU3088330883epcas5p21;
	Thu, 18 Jul 2024 10:02:15 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WPpJ534fRz4x9Pr; Thu, 18 Jul
	2024 10:02:13 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AC.37.06857.528E8966; Thu, 18 Jul 2024 19:02:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240718100113epcas5p255acf51a58cf410d5d0e8cffbca41994~jRmLhVOjY1158311583epcas5p2N;
	Thu, 18 Jul 2024 10:01:13 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240718100113epsmtrp25e4ee2f08258ba8f315e77dd36a4900c~jRmLgc8mG1042010420epsmtrp24;
	Thu, 18 Jul 2024 10:01:13 +0000 (GMT)
X-AuditID: b6c32a4b-ae9fa70000021ac9-d5-6698e825e12e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	74.7D.19057.8E7E8966; Thu, 18 Jul 2024 19:01:12 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240718100112epsmtip2886cec36726a0e511aa6eee8b330094c~jRmKl736_0213902139epsmtip2C;
	Thu, 18 Jul 2024 10:01:11 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6] io_uring: releasing CPU resources when polling
Date: Thu, 18 Jul 2024 18:01:07 +0800
Message-Id: <20240718100107.1135964-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240709092944.3208051-1-xue01.he@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdlhTS1f1xYw0gz/N4hZzVm1jtFh9t5/N
	4l3rORaLX913GS0u75rDZnF2wgdWBzaPnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUK
	qXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QLuVFMoSc0qBQgGJxcVK
	+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZL78vYCn4wFTR
	deYDawPjCqYuRk4OCQETiXkTW4BsLg4hgd2MEotXTWeHcD4xShzdtY4ZwvnGKLFxfhMjTEvz
	+ZVQLXsZJS7v6mODcH4wSuy6fosdpIpNQEli/5YPYB0iAsIS+ztaWboYOTiYBUIkbp6JAAkL
	C7hJXJh5ng0kzCKgKrFnSjyIyStgLfFruTjEKnmJm137mUFsTgEbiadHl7CC2LwCghInZz5h
	AbGZgWqat84Gu1NC4BK7xOc1k5ghml0kTtx9yQJhC0u8Or6FHcKWkvj8bi8bhJ0vMfn7eqi/
	aiTWbX4HVW8t8e/KHqiLNSXW79KHCMtKTD21jgliL59E7+8n0FDkldgxD8ZWklhyZAXUSAmJ
	3xMWsULYHhIvLv0CGy8k0M8osaxBeQKjwiwk78xC8s4shM0LGJlXMUqmFhTnpqcWmxYY56WW
	w6M4OT93EyM4MWp572B89OCD3iFGJg7GQ4wSHMxKIrwTGKelCfGmJFZWpRblxxeV5qQWH2I0
	BYb2RGYp0eR8YGrOK4k3NLE0MDEzMzOxNDYzVBLnfd06N0VIID2xJDU7NbUgtQimj4mDU6qB
	qXjHmfQ8F5MNlqv5L/w7y7/31Aq37Mp8n1860x4eX1eytzzWZt5+T9WnB2Wf3NC5tt5iq3nK
	aYmC6vLjrVsm7gl7/oAvoL9A5nuvxCdFq3N1xYvK7jfZywle37v7XfjP45lXzb2KQiQe5KZ+
	4Sref/yeTzDTNl7bXNepn3pD3r2rsZhb2HWubP7Og1PDJxioPgsx6oxNXb117eV0l/1z78sy
	88Rm99wIn/W4IK34zq39a7dGlB3t/Sm9fEb18V/Hd+3zuOd95WnL3j0sUTPc78alGu7tN+y8
	JW76gPO1uuuDirsnrv3rmjKfMeDr9W6hKK1IO/npHn135pw31J5RNyGMV/iNm05BCMN8KW5G
	UyWW4oxEQy3mouJEAPXBjVwVBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsWy7bCSvO6L5zPSDH7+s7GYs2obo8Xqu/1s
	Fu9az7FY/Oq+y2hxedccNouzEz6wOrB57Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mp4+X0BS8EHpoquMx9YGxhXMHUxcnJICJhINJ9fCWRzcQgJ7GaUaPp9kQ0iISGx49Ef
	VghbWGLlv+fsEEXfGCU+b9wLlmATUJLYv+UDI4gtAlS0v6OVBcRmFgiT6NpxBqxGWMBN4sLM
	80BDOThYBFQl9kyJBzF5Bawlfi0XhxgvL3Gzaz8ziM0pYCPx9OgSsE4hoJKZS7+AxXkFBCVO
	znwCNV1eonnrbOYJjAKzkKRmIUktYGRaxSiZWlCcm55bbFhglJdarlecmFtcmpeul5yfu4kR
	HLxaWjsY96z6oHeIkYmD8RCjBAezkgjvBMZpaUK8KYmVValF+fFFpTmpxYcYpTlYlMR5v73u
	TRESSE8sSc1OTS1ILYLJMnFwSjUwnY4One4SHFNUeL1m7Vs9V9cq1691Jww37LHc2HDpF+tU
	Yb7Jpck+jK9cd5S/3yV+pb/pDdc/1dsNDqfKetNe5G+euGfDX+5lDaXieeXG274eXv3w37kS
	Te6NXw/kiBa2l6d1n2Ot+jprOUsfv+L8Xb9+rBF7IDlrtunkNuPcl2ynJ8Vtec9ao7I3fbnu
	WTUTUxWlVZMvv37EpxEazSTauWf3rb7dBt8sdjKtFAg+tmjl52kvrr+e+on9RtOKEzOUJ6zg
	sT1QsouPQ9NY9CCThOeyNaVBfvwP3JqtO350nPmu/Sxys9wdVmF3+eBXKxj+26lEysXPO8g4
	Z9VE+8VCH/g4Iusir7Fsr7/1RqRxmxJLcUaioRZzUXEiACQOB/bNAgAA
X-CMS-MailID: 20240718100113epcas5p255acf51a58cf410d5d0e8cffbca41994
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240718100113epcas5p255acf51a58cf410d5d0e8cffbca41994
References: <20240709092944.3208051-1-xue01.he@samsung.com>
	<CGME20240718100113epcas5p255acf51a58cf410d5d0e8cffbca41994@epcas5p2.samsung.com>

On 09/07/24 9:29AM, hexue wrote:
>io_uring use polling mode could improve the IO performence, but it will
>spend 100% of CPU resources to do polling.
>
>This set a signal "IORING_SETUP_HY_POLL" to application, aim to provide
>a interface for user to enable a new hybrid polling at io_uring level.

Hi, just a gentle ping. Any coments on this patch?
--
hexue

