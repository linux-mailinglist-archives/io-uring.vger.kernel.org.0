Return-Path: <io-uring+bounces-2630-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BF3F944593
	for <lists+io-uring@lfdr.de>; Thu,  1 Aug 2024 09:36:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED5BA1F22525
	for <lists+io-uring@lfdr.de>; Thu,  1 Aug 2024 07:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96B327450;
	Thu,  1 Aug 2024 07:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NXyolnfo"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A3916DEA6
	for <io-uring@vger.kernel.org>; Thu,  1 Aug 2024 07:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722497771; cv=none; b=ci1neh8xCR4RSM/Qau0j912KrnVlQ5YpDFLBh3P7atiuX1mfHtJh/7dmQO7j0AKK6ketwAA7wkiTy1ynJlveatznddhaDqz156LM3ymK0bki3yCMq0fWhRav2BxGXEToTM9OSnHdkghrZSe9BXT7L7FIibEaFwLKDbCnBzLgFhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722497771; c=relaxed/simple;
	bh=A4AKCYMcPD//5sUlxAklpQ3ZunN5gmERCZFpy7xQlN0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=O8wbpqH/DunL5ad41l35jQUwHy/N1mvJgXYdUo2DdDRCf/f/vrMrG7dx+NeQzjL7/ZtnWydV4swKKzr5PKRwqQFcAKQ4WwiOM9hd9uUyrSr22n08Bc6lYLf3IiDMT9h7B8GRkDX76YtmEM0g2UL8xGd4HtRvv1NAlFqxhuT+9gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NXyolnfo; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240801073602epoutp0250a39c0a007ff7f67f1ac2f4a7a88366~nipafrr9x1596915969epoutp02e
	for <io-uring@vger.kernel.org>; Thu,  1 Aug 2024 07:36:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240801073602epoutp0250a39c0a007ff7f67f1ac2f4a7a88366~nipafrr9x1596915969epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1722497762;
	bh=A4AKCYMcPD//5sUlxAklpQ3ZunN5gmERCZFpy7xQlN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXyolnfopC12gcl5dsWhuK9oIlt+FalSXZQOUQAil+3CvLSmOD8Kk7anGr+Of4C+b
	 9bZAc/wC2EhU+CoKVyXapwPip1wD7YWrFf0VyRhaHJlNJxUNnyJlpywuE7eTkHlSIt
	 audx8EfwwdaIHgxNfmd38nSy5MtyLUxRul1KK5mU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240801073601epcas5p299094a7085dc9aba03cddbb03f2206ab~nipaIfiCw0569105691epcas5p2J;
	Thu,  1 Aug 2024 07:36:01 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WZLNv6g61z4x9Pt; Thu,  1 Aug
	2024 07:35:59 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C0.7A.09642.FDA3BA66; Thu,  1 Aug 2024 16:35:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240801073424epcas5p22be96bbc4dd0fbaaf0b214e37b0a1b02~nin-omxdz0379103791epcas5p2M;
	Thu,  1 Aug 2024 07:34:24 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240801073424epsmtrp2d2be8c6c85ddf09030b57bae2944d59d~nin-n3mPR1227012270epsmtrp2t;
	Thu,  1 Aug 2024 07:34:24 +0000 (GMT)
X-AuditID: b6c32a4b-613ff700000025aa-9b-66ab3adfd790
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	70.33.07567.08A3BA66; Thu,  1 Aug 2024 16:34:24 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240801073423epsmtip1f8aae8f40e46b7af5de0e6c8f3d7458a~nin_ggwu01454014540epsmtip19;
	Thu,  1 Aug 2024 07:34:23 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V7] io_uring: releasing CPU resources when polling
Date: Thu,  1 Aug 2024 15:34:03 +0800
Message-Id: <20240801073403.2046300-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240724075929.19647-1-xue01.he@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdlhTS/e+1eo0g33XjSzmrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sDmweO2fdZfe4fLbUo2/LKkaPz5vkAliism0yUhNTUosU
	UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgHYrKZQl5pQChQISi4uV
	9O1sivJLS1IVMvKLS2yVUgtScgpMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7IzJt04z1Kwkqli
	/ZYGtgbG94xdjJwcEgImEntbzjB3MXJxCAnsZpT4ePwHO4TziVFi1/6PUM43Rom95xrZYVr6
	v8xmgUjsZZSY3beKDcL5wShxaHoH2GA2ASWJ/Vs+gNkiAsIS+ztagTo4OJgFQiRunokAMYUF
	3CROfbAGMVkEVCWev04FKeYVsJaYcu4T1HXyEje79jOD2JwCVhKXlt5mgagRlDg58wmYzQxU
	07x1NtgHEgLX2CU6N+5khmh2kfjUNZMJwhaWeHV8C9T9UhKf3+1lg7DzJSZ/Xw+1rEZi3eZ3
	LBC2tcS/K3ugLtaUWL9LHyIsKzH11DomiL18Er2/n0CN55XYMQ/GVpJYcmQF1EgJid8TFrFC
	2B4Si/smg60VEuhllFi3TWwCo8IsJO/MQvLOLITNCxiZVzFKphYU56anFpsWGOellsOjODk/
	dxMjODFqee9gfPTgg94hRiYOxkOMEhzMSiK8QidXpgnxpiRWVqUW5ccXleakFh9iNAUG90Rm
	KdHkfGBqziuJNzSxNDAxMzMzsTQ2M1QS533dOjdFSCA9sSQ1OzW1ILUIpo+Jg1Oqgak39Mr6
	L4oH3h5zn9VyOUHjlfHBtc7WlTXO3HNuck6ZxX/3g9uegjdVmdyrXYvv6rhVBveZ/jW0Np+R
	Yzr7vulGG8WIzHBPL8lJ1w3W7Y3NC3t7J+Jqwen+S/bXZlwOThbinN/lduFfVsqPfbuK1Bw5
	im1kDdaYBBUxNq4PaZtaFPPP7WxfUt3kxRMed8/gLz9z7vNGSevdeUrXTA29Jt+0KHx38kT2
	0dIFgWuEz7ttOnjn9uUt3mFbz4k8v34r8q6X7IrtlyYwvkz7/KXpQup6bg+H3dIhOWbLtbe6
	rTiz2PL6k+0eehaH7ytca+xp/G2ieEFvn0ZVUnr6Yas791bcWaR77NWmfd139Xti35QosRRn
	JBpqMRcVJwIAwgsMZxUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsWy7bCSnG6D1eo0gz3PxS3mrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sDmweO2fdZfe4fLbUo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDIm3TjPUrCSqWL9lga2Bsb3jF2MnBwSAiYS/V9ms3QxcnEICexmlLj2fDtUQkJix6M/
	rBC2sMTKf8/ZIYq+MUp8+bKVGSTBJqAksX/LB7AGEaCi/R2tLCA2s0CYRNeOM0DNHBzCAm4S
	pz5Yg5gsAqoSz1+nglTwClhLTDn3CWqVvMTNrv1gEzkFrCQuLb0NNkVIwFLi6tTHbBD1ghIn
	Zz6Bmi4v0bx1NvMERoFZSFKzkKQWMDKtYpRMLSjOTc9NNiwwzEst1ytOzC0uzUvXS87P3cQI
	Dl4tjR2M9+b/0zvEyMTBeIhRgoNZSYRX6OTKNCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8hjNm
	pwgJpCeWpGanphakFsFkmTg4pRqYaper7pmjq53tlX71nH6m8MM9x3ze/j1kWb77/LpV0/wb
	6rmWns18sWSaybJt864q6z7cuNSDgcf1Qe636zlJwo0FnTeSr4h96531ddL1i+tOtHUX7lzT
	W/nc2Te9/rnp1XBtsb3LeVvY33zc1Wb32Ffgb4VzwuwzP268dngcuSDm+oUfXeWTWuZxFek0
	nTmqUK1j5PzsUsHe1vtsxjFRacfr95zu15iyRuJP5sLtp6JiTOdNcheLrtyxfduRI6/3lIta
	6vY23uibatn1c8F5BcOLrX94T+iZnZGrZWnfkhh3adJDt8z6GR+WLOLRSD59XMRcgev96caL
	lxiucry/s9Tjg+jN4ANvu8Lr8q4u9VJiKc5INNRiLipOBADdNmUuzQIAAA==
X-CMS-MailID: 20240801073424epcas5p22be96bbc4dd0fbaaf0b214e37b0a1b02
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240801073424epcas5p22be96bbc4dd0fbaaf0b214e37b0a1b02
References: <20240724075929.19647-1-xue01.he@samsung.com>
	<CGME20240801073424epcas5p22be96bbc4dd0fbaaf0b214e37b0a1b02@epcas5p2.samsung.com>

On 24/07/24 7:59AM, hexue wrote:
>This patch add a new hybrid poll at io_uring level, it also set a signal
>"IORING_SETUP_HY_POLL" to application, aim to provide a interface for users
>to enable use new hybrid polling flexibly.

Hi, just a gentle ping. Any coments on this patch?
--
hexue

