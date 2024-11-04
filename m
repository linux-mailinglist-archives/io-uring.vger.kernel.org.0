Return-Path: <io-uring+bounces-4397-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 806DD9BAFF2
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 10:40:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4C241C2205C
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 09:40:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB5B1ADFE2;
	Mon,  4 Nov 2024 09:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WbV5qoMS"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88A11AC426
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 09:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730713231; cv=none; b=ncDL7IWhezEXMVzdQ3TtpCWojiES8oOtjbGdP7mcM5Wj5NvZcjQS2rR2HKcAQuFuJQi5j5lDBkj/RkqBYB5glynzmxNCffR5fs1bVtjt7nFMvLfXVIPNL++LQfUbMcajS+MkMiAk3nmhBY/xKbpBcxZkrqQR7g4DV0lMCyq8xsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730713231; c=relaxed/simple;
	bh=/2KWbTeIX8OFyjJnGDxLsfFpKtH0vHpcfurYnQGh9qk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Yf0RJcjCE7WwnozBrzU9dMV6LDCGUI/fQ8EYEoMmY5Zuf5hREwog4MWja1kJcR4ge3IJRjaCvYXZInynn/nMYGXZ/76vsGbp1PPpT3gGBE65fHxnME02rKH4vpRltHeNvqAgAwDKeUpua/8lSeihrvtlqttEZxu5yAGz7h3AuTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WbV5qoMS; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241104094024epoutp0253bef925d9b2aa1c6c68ef28438b3373~EuoILIQk82292022920epoutp02G
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 09:40:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241104094024epoutp0253bef925d9b2aa1c6c68ef28438b3373~EuoILIQk82292022920epoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730713224;
	bh=/2KWbTeIX8OFyjJnGDxLsfFpKtH0vHpcfurYnQGh9qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbV5qoMS2c/2HCrxiQebd3ssuLJCXYymmIt7uqgfze6G0m92ADzsimjdfLxTBJzMI
	 kFPUzCx+9sBsgn2xAIEGUB/34P+4WaC4q0ne/G/Lj9A8GPBPmuDOuUL6D5wjS7AA80
	 XQkPQcjPf6FtQbr42vjrRztxEDY0WopV6TpLqjk0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241104094024epcas5p19f2baa060a32014627aef72cdb4c641a~EuoH64rqM2520225202epcas5p1N;
	Mon,  4 Nov 2024 09:40:24 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XhmfZ1hSSz4x9Pq; Mon,  4 Nov
	2024 09:40:22 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	49.74.09800.48698276; Mon,  4 Nov 2024 18:40:20 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241104072914epcas5p2d44c91a277995d5c69bacd4e4308933d~Es1mOsiEQ2271622716epcas5p23;
	Mon,  4 Nov 2024 07:29:14 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241104072914epsmtrp188c60915ea9c82d5676ee59a90969a29~Es1mOBVzt0180401804epsmtrp1X;
	Mon,  4 Nov 2024 07:29:14 +0000 (GMT)
X-AuditID: b6c32a4b-23fff70000002648-67-672896845931
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E2.98.07371.9C778276; Mon,  4 Nov 2024 16:29:13 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241104072913epsmtip2d779602a1dd38bcd762dc37d60793f5f~Es1lU23lA1188611886epsmtip2F;
	Mon,  4 Nov 2024 07:29:12 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v9 1/1] io_uring: releasing CPU resources when
 polling
Date: Mon,  4 Nov 2024 15:29:07 +0800
Message-Id: <20241104072907.768671-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <a9b7a578-cf47-474f-8714-297437b385cd@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42LZdlhTQ7dlmka6QesJKYs5q7YxWqy+289m
	8a71HIvFr+67jBaXd81hszg74QOrA5vHzll32T0uny316NuyitHj8ya5AJaobJuM1MSU1CKF
	1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoN1KCmWJOaVAoYDE4mIl
	fTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyM5Ue/Mhd8Zq2Y
	vPMyYwPjTZYuRk4OCQETiT037zJ3MXJxCAnsZpSYc3k+C4TziVHiw6urUJlvjBI7F7fBtaz4
	3gFVtZdR4sCymYwQzg9GidmXZzCDVLEJKEns3/KBEcQWERCW2N/RCtTBwcEsECJx80wESFhY
	IEBi/b+vYOUsAqoSl7/2sYPYvAJWEr/nb2GDWCYvcbNrP1gNp4CtxPQv85khagQlTs58AnYQ
	M1BN89bZYJdKCFxil+h8so8JotlFovv9dHYIW1ji1fEtULaUxMv+Nig7X2Ly9/WMEHaNxLrN
	76C+tJb4d2UP1M2aEut36UOEZSWmnlrHBLGXT6L39xOoVbwSO+bB2EoSS46sgBopIfF7wiJW
	CNtDYv7Xk9AQncAo8WjuHPYJjAqzkPwzC8k/sxBWL2BkXsUomVpQnJueWmxaYJyXWg6P5eT8
	3E2M4PSo5b2D8dGDD3qHGJk4GA8xSnAwK4nwzktVTxfiTUmsrEotyo8vKs1JLT7EaAoM8InM
	UqLJ+cAEnVcSb2hiaWBiZmZmYmlsZqgkzvu6dW6KkEB6YklqdmpqQWoRTB8TB6dUA5NL6dOK
	2RPUT0rp91qnbXc5WFViNTPbKXD7QzGJr7PtpvinpuUo30k6y/TMVqns4r7gaGuxGXP4z79u
	d127+fvho+mzlDfmpQee1koPfHIvJ+HXk70R6/kn1TTMZjdiWnjVbVryJLcj9R0a30rDZ+72
	LvnEavLENG5J8Ta9mqNivsUMTLVPM196lbnt9pvsqh45+dHjbxsPfmSLnPXzbteXH8w7Dmqt
	/93BxBF5JWl7kOPVepfyPzuT0h+Yu7Afue/WpJQU/GPyaZu/bVInujMPTPrzpmj5BdmanulX
	+nabFahciT5pvcLqD4uxxwS2SeZyAbvk/7pnH/8jxcgj9GJpr2PM41NtFfze35eu3afEUpyR
	aKjFXFScCACwjSJMGAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsWy7bCSvO7Jco10g48zzSzmrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sDmweO2fdZfe4fLbUo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDKWH/3KXPCZtWLyzsuMDYw3WboYOTkkBEwkVnzvALK5OIQEdjNKfL90jxkiISGx49Ef
	VghbWGLlv+fsILaQwDdGiTVPwkFsNgElif1bPjCC2CJANfs7WsGGMguESXTtOAPWKyzgJ3Hr
	9kWwmSwCqhKXv/aBzeEVsJL4PX8LG8R8eYmbXfvBajgFbCWmf5kPZHMA7bKR6NmZBlEuKHFy
	5hOo8fISzVtnM09gFJiFJDULSWoBI9MqRsnUguLc9NxkwwLDvNRyveLE3OLSvHS95PzcTYzg
	4NXS2MF4b/4/vUOMTByMhxglOJiVRHjnpaqnC/GmJFZWpRblxxeV5qQWH2KU5mBREuc1nDE7
	RUggPbEkNTs1tSC1CCbLxMEp1cB0Ul3dtfGGO7vSbhFGUbtTvrM3zU28uJ7Tvz336OEXi793
	Ra2Rr7mXYKnDXKjW0ZXKGpydv1lTXfhYrZ+500fHm0e2mRTYT9c+9v21zp0lzm41bms+vTH3
	Zbo6b5/kFw2WRocF+5va/sU8ufgrYfeP0t3zFBXEd815fNHrgqmA4q9Xh1L6+Hp+Vzgq9Ybc
	X3tp8oXzT/vnbYxjVE76XLfl3PlO2U635Qkfs2bdbvuwPVpuf6rOzATh1b+uGPJ5B8tIvFR7
	GlMYl1KsKvTsataZ4GuFQZEvF22Y8M+wjItt8hLhp6HSAXNehzd9fvcj5eZhthk6k74f+XJT
	e07CKrlbStlT9N/fY1E/kKKprfBaiaU4I9FQi7moOBEAcfWJSs0CAAA=
X-CMS-MailID: 20241104072914epcas5p2d44c91a277995d5c69bacd4e4308933d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241104072914epcas5p2d44c91a277995d5c69bacd4e4308933d
References: <a9b7a578-cf47-474f-8714-297437b385cd@kernel.dk>
	<CGME20241104072914epcas5p2d44c91a277995d5c69bacd4e4308933d@epcas5p2.samsung.com>

On 11/1/2024 08:06, Jens Axboe wrote:
>On 11/1/24 3:19 AM, hexue wrote:
>> A new hybrid poll is implemented on the io_uring layer. Once IO issued,
>> it will not polling immediately, but block first and re-run before IO
>> complete, then poll to reap IO. This poll function could be a suboptimal
>> solution when running on a single thread, it offers the performance lower
>> than regular polling but higher than IRQ, and CPU utilization is also lower
>> than polling.
>
>This looks much better now.
>
>Do you have a patch for liburing to enable testing of hybrid polling
>as well? Don't care about perf numbers for that, but it should get
>exercised.

Sure, I'll add some liburing test cases and submit patch soon.
Thank you.

--
Xue

