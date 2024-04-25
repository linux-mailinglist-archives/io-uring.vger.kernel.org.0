Return-Path: <io-uring+bounces-1635-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7946E8B2864
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 20:47:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96204B232FC
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 18:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE42F1514E1;
	Thu, 25 Apr 2024 18:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EBDheG8A"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FA51514CB
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714070829; cv=none; b=qOEdY2Vdoctn2TmZneI+Sz0CSaG8g4yf0EV+PwSOm5mIvB6Q3254I5DJxagv4ieon7BIEKzDfAGMgk7DtEnmk0PjwWPqKm7I3hjTkBZVDGgkWX6M6MkxEV7WHf5bbSolIscvjF53BiNY3ryCzjvuywXWOLkLjv6J0biw/c3qRTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714070829; c=relaxed/simple;
	bh=jlEo7mjTEa/d+J31Oce5T1eo2vI+1xW+upTvWFWz27o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=aMp632OPYFtBPkWbvXUzTy/36RAU01vs2A9pSaC/I7Gr8pZhUXv9H0P2zQnYz/Gk1JHTFpFo/N3Gg9RHeG0aWUWyM4rd1Z6RgFwtbUABt1eRvMuAJQ2kvnb4tpfzWv8Lk498u9BYhCW7vuQ/07pbGlFE0Sng2f2BD1KcIyDQAOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=EBDheG8A; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240425184706epoutp0123e9d6cca7abaedbff857ebf0e50aaa7~JmlXZUJd03260632606epoutp01B
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 18:47:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240425184706epoutp0123e9d6cca7abaedbff857ebf0e50aaa7~JmlXZUJd03260632606epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714070826;
	bh=Js/hSRW8kEp1k9VQrph3vgZ0lgiRTB0hNOFeT7LTDp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBDheG8AIWMBRVL6ov9bmb4ExSb+NI+B8PVbci3C6OO/yOq4XvOKwkDzQ1E37ji/7
	 kviG1rA2ZMyjm3Quq422qoaoBfkC/m/r6hfEZLxiRn51bvqlP43uEZQIM42SyXaQO9
	 vbKfWQMYv0Uwm5gOElWJPiloOJcwEmfaL1MkhYtU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240425184706epcas5p1029962312fa51b49df216c5a1ce74a64~JmlW9NoKZ1431014310epcas5p1N;
	Thu, 25 Apr 2024 18:47:06 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VQPwS4Hr2z4x9Pr; Thu, 25 Apr
	2024 18:47:04 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8B.20.09665.825AA266; Fri, 26 Apr 2024 03:47:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240425184704epcas5p3b9eb6cce9c9658eb1d0d32937e778a5d~JmlVCx69z2385723857epcas5p3v;
	Thu, 25 Apr 2024 18:47:04 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240425184704epsmtrp18d551fa6e17310e3273e8197843ea9c7~JmlVCCY9O0085200852epsmtrp1W;
	Thu, 25 Apr 2024 18:47:04 +0000 (GMT)
X-AuditID: b6c32a4b-5cdff700000025c1-22-662aa528bc6d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AE.B4.08390.725AA266; Fri, 26 Apr 2024 03:47:03 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240425184702epsmtip1e3c93d2f39f3720b3bbf1b4c9c180f46~JmlTSyjgm3266832668epsmtip16;
	Thu, 25 Apr 2024 18:47:02 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	hch@lst.de, brauner@kernel.org
Cc: asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 07/10] block: define meta io descriptor
Date: Fri, 26 Apr 2024 00:09:40 +0530
Message-Id: <20240425183943.6319-8-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240425183943.6319-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNJsWRmVeSWpSXmKPExsWy7bCmhq7GUq00g1k98hZzVm1jtFh9t5/N
	4vXhT4wWr2asZbO4eWAnk8XK1UeZLN61nmOxOPr/LZvFpEPXGC323tK2mL/sKbvF8uP/mBx4
	PK7NmMjisXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49Pb7F49G1ZxejxeZNcAGdUtk1GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0MFKCmWJOaVAoYDE
	4mIlfTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMtXsOsxZM
	Za1YfCq8gbGfpYuRk0NCwERi3RMQm4tDSGA3o8TCLa/AEkICnxglDjwvgkh8Y5TYdPgWG0zH
	k/3fWSGK9jJKzLwpDlH0mVHizLyZQN0cHGwCmhIXJpeC1IgIpEi8WveaEaSGWeAAo8Si50/A
	BgkLmEts2riTHcRmEVCVODdhDpjNCxS/u+oX1DJ5iZmXvoPFOQUsJCZfPA1VIyhxcuYTsEuZ
	gWqat85mBlkgITCXQ+LzjE9MEM0uEjvXzGaHsIUlXh3fAmVLSbzsb4OykyUuzTwHVV8i8XjP
	QSjbXqL1VD8zyDPMQM+s36UPsYtPovf3EyaQsIQAr0RHmxBEtaLEvUlPWSFscYmHM5ZA2R4S
	7S+WM0HCp5tR4tGKlywTGOVnIXlhFpIXZiFsW8DIvIpRMrWgODc9tdi0wDgvtRwercn5uZsY
	walWy3sH46MHH/QOMTJxMB5ilOBgVhLhvflRI02INyWxsiq1KD++qDQntfgQoykwjCcyS4km
	5wOTfV5JvKGJpYGJmZmZiaWxmaGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxSDUzLvCxqoqPn
	ObEt1ec+Kr1GSLJssYnFtzWxR/1L1y1POvEhr9tey46/yzEs32JdaGjcEUbWo3NUPi1f4rRo
	Sq/X21SBixe231p9JsGgLGhfRPSRc9XNTNkZUff7g85oRK9ymPW+9rZD3R6OTVafvlsEaCmd
	lVWO+TtZq8DVOu/M5C2n33n+PnGuWWPVhWj+hPnbVJ/9XFQtvT3o34WrmzqiJ3W7ZDY8+aW3
	KzRgW/UkoUc17qdZa/5wfvl646flq+0OenLli/0WJurWX9CbKtPebb3eYO2yZPGTjPMfFj5m
	uWCStbHG34pB8k36iydibuv85p5S/O6nGnKIeXHvXIYFJ1c9U2Bs8v6kuMb/yRMlluKMREMt
	5qLiRADtL2aEPgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWy7bCSnK76Uq00gytsFnNWbWO0WH23n83i
	9eFPjBavZqxls7h5YCeTxcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpu8Xy4/+YHHg8
	rs2YyOKxc9Zddo/LZ0s9Nq3qZPPYvKTeY/fNBjaPj09vsXj0bVnF6PF5k1wAZxSXTUpqTmZZ
	apG+XQJXxto9h1kLprJWLD4V3sDYz9LFyMkhIWAi8WT/d9YuRi4OIYHdjBKN+y6xQSTEJZqv
	/WCHsIUlVv57zg5R9JFR4v/EjUDdHBxsApoSFyaXgtSICGRJ7O2/AlbDLHCCUeLQ/MNgzcIC
	5hKbNu4Es1kEVCXOTZgDZvMCxe+u+gW1TF5i5qXvYHFOAQuJyRdPg9lCQDVT1yxihKgXlDg5
	8wnY1cxA9c1bZzNPYBSYhSQ1C0lqASPTKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M
	4DjR0trBuGfVB71DjEwcjIcYJTiYlUR4b37USBPiTUmsrEotyo8vKs1JLT7EKM3BoiTO++11
	b4qQQHpiSWp2ampBahFMlomDU6qBibk2YEnr2n27D5x/HO223jp7o2vc+z8T+GcKqRlwpqpd
	naeT4eja25zu9dpm6zuLNaVLLJvc76270RpVkXna4sKpq/e0Fa/67eu/NVv4p1vC5g7VcLFF
	Jc+ef+jdE1bJbZ62gTmrfErlnnOCBw7O+ix8j/fj5jVnPggK7p37Umanx3Wnmiu827zVb8yd
	bB2Zy1ZqFKzXFxlgMOtYz1mBaf7brFOLd98L1jvVwnP0/9rZgYahUp1fw9cIndPQ9j60aSLT
	xIIExfVTjz5XDDlUwXlQO8Ly4LI5gTuvPS83T0isi9cz+VK+mjt+o5H0HZ/uPUnODuXLbyVm
	Lpj873dM7uuV316oaoiL/vxp1CM5SYmlOCPRUIu5qDgRABmbW38CAwAA
X-CMS-MailID: 20240425184704epcas5p3b9eb6cce9c9658eb1d0d32937e778a5d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184704epcas5p3b9eb6cce9c9658eb1d0d32937e778a5d
References: <20240425183943.6319-1-joshi.k@samsung.com>
	<CGME20240425184704epcas5p3b9eb6cce9c9658eb1d0d32937e778a5d@epcas5p3.samsung.com>

Introduces a new 'uio_meta' structure that upper layer (io_uring) can
use to pass the meta/integrity information. This is a prep patch.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/bio.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 20cf47fc851f..0281b356935a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -331,6 +331,12 @@ enum bip_flags {
 	BIP_COPY_USER		= 1 << 6, /* Kernel bounce buffer in use */
 };
 
+struct uio_meta {
+	u16 flags;
+	u16 apptag;
+	struct iov_iter iter;
+};
+
 /*
  * bio integrity payload
  */
-- 
2.25.1


