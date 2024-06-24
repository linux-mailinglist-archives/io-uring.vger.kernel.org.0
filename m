Return-Path: <io-uring+bounces-2325-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3ADC9140CA
	for <lists+io-uring@lfdr.de>; Mon, 24 Jun 2024 05:15:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F081B280E3F
	for <lists+io-uring@lfdr.de>; Mon, 24 Jun 2024 03:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8CD94C97;
	Mon, 24 Jun 2024 03:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="T7NJI7NJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0101E4683
	for <io-uring@vger.kernel.org>; Mon, 24 Jun 2024 03:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719198954; cv=none; b=CjECcI6+8G2pJNWGDhbjS5Il8Q1Cu6OB4D01hc65y34aXhZ9EDcGXIS539GUJokaL7T4mtBBZb/MAPi7KWFSMftxTadvl38LjCgDtWs4hZ09i3qCEGOOYCETEpXLr5CkUYa3OBEJ3q3cXi3yhPPDxMZHCOZAfVxcQO+TPHtkp+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719198954; c=relaxed/simple;
	bh=MWfcOS/fpDZc5+yTzWXxZQbqNGuKZmdjH1+ri1Kjs6s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=dWsGNX7MwMnn6U5z+UqxSB8qSdrs41Kz/i/1q3Us18LmzmQw3qCLgSFqYO6XPP7UeAr6qGgEjEjxq9Yv6bD4z/y261Y8+Fyv5SMyxbUAMTY+8kNjKsAnA/I40AEOLo6e2IN4cOunhN8nSWltpxVWrrnPL2aVaxJEYBjBP7n/y2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=T7NJI7NJ; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240624030702epoutp01f637c9037ebffc4f43db6ca23c23fbb5~b0ds9tzdh2421924219epoutp01e
	for <io-uring@vger.kernel.org>; Mon, 24 Jun 2024 03:07:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240624030702epoutp01f637c9037ebffc4f43db6ca23c23fbb5~b0ds9tzdh2421924219epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719198422;
	bh=tXE911zpJm5uEPgj6wYABxOu8GD/9MWdwpLAU0xwGas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7NJI7NJRtOgnLLuohLy3yd4rFsdTczvx/q+iLhqP8zHOglioNjAhOe4jiLwFrs0x
	 8CSi4CS9HfNapP3gv0Ax5nPbFugD9++5cn3jAbYILWBCRtqMUvyjIdDkaRqDzvDRPG
	 713K260a2AqXKsMXlr85tgliicNwoHPD0lNdKfmM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240624030701epcas5p3b9dc38710641253dd382dfdbbfa10e6b~b0dsb8xDc1324413244epcas5p3-;
	Mon, 24 Jun 2024 03:07:01 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4W6tD43k0rz4x9QB; Mon, 24 Jun
	2024 03:07:00 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DF.5D.11095.4D2E8766; Mon, 24 Jun 2024 12:07:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240624025406epcas5p4ce2b80c63d185cf9e02615365fb3d89d~b0SaEOHhv2162121621epcas5p40;
	Mon, 24 Jun 2024 02:54:06 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240624025406epsmtrp25b85fb38f4ef9464665e0c856614d9c7~b0SaDjAxz0074600746epsmtrp2A;
	Mon, 24 Jun 2024 02:54:06 +0000 (GMT)
X-AuditID: b6c32a49-3c3ff70000012b57-5a-6678e2d4e357
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	69.45.18846.DCFD8766; Mon, 24 Jun 2024 11:54:06 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240624025405epsmtip1eec79575b6199f63d8774ff291c96165~b0SZP1v6F1024910249epsmtip1n;
	Mon, 24 Jun 2024 02:54:05 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: asml.silence@gmail.com
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v5] Subject: io_uring: releasing CPU resources when
 polling
Date: Mon, 24 Jun 2024 10:54:00 +0800
Message-Id: <20240624025400.2341405-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <c6b297ae-b1a9-4500-966e-9a0ea192d46b@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdlhTQ/fKo4o0g21XJCzmrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sDmweO2fdZfe4fLbUo2/LKkaPz5vkAliism0yUhNTUosU
	UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgHYrKZQl5pQChQISi4uV
	9O1sivJLS1IVMvKLS2yVUgtScgpMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7IzOs6rFdxnrTg8
	6Rx7A+NSli5GTg4JAROJu19/M3YxcnAICexmlNhS3cXIBWR+YpS4fmkrG5zzcEcfXMPjpfOY
	IBI7GSUuHHzFDOH8YJRYd2gNK0gVm4CSxP4tH8DGighISfy+ywESZhbwlvj85C0TiC0sECqx
	bn83I4jNIqAqcXLqOTCbV8Ba4l3rOjaIZfISN7v2M4PYnAK2Eu3H10HVCEqcnPmEBWKmvETz
	1tlgN0gIXGKXuHuhgRmi2UXi+MkJUFcLS7w6voUdwpaS+PxuL9SCfInJ39czQtg1Eus2v4Oq
	t5b4d2UPC8j9zAKaEut36UOEZSWmnlrHBLGXT6L39xMmiDivxI55MLaSxJIjK6BGSkj8nrCI
	FcL2kPjxYy80RCcwSjyYs4B5AqPCLCT/zELyzyyE1QsYmVcxSqYWFOempxabFhjmpZbDozg5
	P3cTIzgxannuYLz74IPeIUYmDsZDjBIczEoivNPry9KEeFMSK6tSi/Lji0pzUosPMZoCA3wi
	s5Rocj4wNeeVxBuaWBqYmJmZmVgamxkqifO+bp2bIiSQnliSmp2aWpBaBNPHxMEp1cA074TA
	vLr8K5sv6O/WnnmzJGgOxwyjzJAp3SYtl2tmHf4jc8vI/MnLpMgvXQK7VqXWhPE5/hY76jZl
	786NbtfCk7+cy2rIm+hpsdfvr+OMWRfjO3JWZjAdYdFSy/xaonaazXez47UOg6bAh8Z6nMLp
	t3g2/xA8KLf56I+v/O//F4j8eMioKsL7JTiqaPWOnpLD3frnbjJsWPkleO26z3FaMg8dzu7w
	yvDokDdo2rQl4oriWlcj7sudJqF7lQykc/nWB92zT7lcXHr7UUxu7fJn/1R2P3ts0tP+jTtR
	5p+jgHDu9EdyIQ9FFqoms2hwx5rk5VuEx3Ovv9fbG8Vbs+DZucfPao7nXqv1MorJzVJiKc5I
	NNRiLipOBABWggFGFQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsWy7bCSnO65+xVpBpczLOas2sZosfpuP5vF
	u9ZzLBa/uu8yWlzeNYfN4uyED6wObB47Z91l97h8ttSjb8sqRo/Pm+QCWKK4bFJSczLLUov0
	7RK4MjrOqxXcZ604POkcewPjUpYuRk4OCQETicdL5zF1MXJxCAlsZ5SYuOs6K0RCQmLHoz9Q
	trDEyn/P2UFsIYFvjBJf/xmB2GwCShL7t3xg7GLk4BARkJL4fZcDJMws4C9x/9teJhBbWCBY
	YuemqWCtLAKqEiennmMEsXkFrCXeta5jgxgvL3Gzaz8ziM0pYCvRfnwdI8QqG4ner6tZIeoF
	JU7OfMICMV9eonnrbOYJjAKzkKRmIUktYGRaxSiaWlCcm56bXGCoV5yYW1yal66XnJ+7iREc
	sFpBOxiXrf+rd4iRiYPxEKMEB7OSCO/0+rI0Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzKOZ0p
	QgLpiSWp2ampBalFMFkmDk6pBiaVKdefq13esiEh8sKBiv07Du/jEjZm2Ls5+pVxs6Sb+3//
	1smFR65Ov8bCq3Nh60Wjl4YFDbo7RTaWq5rnHT1wPjCK63dYS63HpXzWViWpp38+Hvz3Vc1Q
	WPrXdtnM139+iz+zkepgaWbavOBU4rHmnXvue9a060Wcv5426/qJYwsvzFizMf0Z35HpFjom
	997XvTA5WJD55fadGlE7v9v8Hu/1pjA/fBCwNvD5yfUGbsUJZ+ec+9zIWsfAmOL/cXK6Lfc3
	eRMr77vvE+4p8Xg80IjS6GTWXu524nVNeJpNgFul/EQPyyffRSbk7dIutlzpJai21LHdfJX/
	rYWT9p/P3XPvT/v6/R9jX6883mOtxFKckWioxVxUnAgALyi+mMcCAAA=
X-CMS-MailID: 20240624025406epcas5p4ce2b80c63d185cf9e02615365fb3d89d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240624025406epcas5p4ce2b80c63d185cf9e02615365fb3d89d
References: <c6b297ae-b1a9-4500-966e-9a0ea192d46b@gmail.com>
	<CGME20240624025406epcas5p4ce2b80c63d185cf9e02615365fb3d89d@epcas5p4.samsung.com>

On 6/19/24 16:22, Pavel Begunkov wrote:
>On 6/19/24 08:18, hexue wrote:
>
>> Test results:
>> set 8 poll queues, fio-3.35, Gen5 SSD, 8 CPU VM
>>
>> per CPU utilization:
>>      read(128k, QD64, 1Job)     53%   write(128k, QD64, 1Job)     45%
>>      randread(4k, QD64, 16Job)  70%   randwrite(4k, QD64, 16Job)  16%
>> performance reduction:
>>      read  0.92%     write  0.92%    randread  1.61%    randwrite  0%
>
>What are numbers for normal / non-IOPOLL runs?

for normal poll, per CPU utilization is 100%*8
performance like this:
				read			write			randread		randwrite
normal poll		BW=10.9GiB/s    BW=6202MiB/s 	IOPS=1682k		IOPS=255k
hybrid poll     BW=10.8GiB/s	BW=6145MiB/s	IOPS=1655k		IOPS=255k

--
hexue

