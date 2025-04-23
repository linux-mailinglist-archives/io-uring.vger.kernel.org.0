Return-Path: <io-uring+bounces-7674-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E9E9A995D9
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 18:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7A9B464CEF
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 16:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCDBC28935A;
	Wed, 23 Apr 2025 16:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VYn+k0tI"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F35289359
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 16:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745427315; cv=none; b=ML/L1Je0Pqi+UsL7EEA6HfPrAq4IxMNbFF7xKSxXsODzx6TkY79sRGI/CFY4xK61yk4Z9phsakBG9qUCLO+Jn8u3tNAknuiJPAoWx5ThfDh/agZjyYtxiLBnjDj7i89nT+MPrJI0y2yD4UJMGDnSdbzlj058uai/7AnKP7cgJLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745427315; c=relaxed/simple;
	bh=mve0s9ogrDAX57xl12OWzaIocDqYrfvPpxhH9SQ7Dp0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:References; b=j1YwyNo0W+cH86PxLtyvLIb9MJLrW9DMEOAkRbLSKhndk6LMJnT2ymJ+aJ9LN0Sk08alV2EzA6YuvyLGv6Vlthjw/co8dfkKUa2AU7bzqbPBomoVyBekzDXb7EjoGk2uy+KLP7a7y5A2BGGmd53pXaS5AT28hUW0pxJWHEjqgT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=VYn+k0tI; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250423165510epoutp031761d481d1fa019999adfdc1e456cc22~5AOQOu0z42650226502epoutp031
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 16:55:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250423165510epoutp031761d481d1fa019999adfdc1e456cc22~5AOQOu0z42650226502epoutp031
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1745427310;
	bh=kRWghWv/XVGijoHIq6UZmmuLoqKEl5j6V4EQ0hkceVY=;
	h=From:To:Cc:Subject:Date:References:From;
	b=VYn+k0tItbOtBlobcGoXaxU4a5XOAcuZZPDh8FD9C/Jfcfz3npHrRtskpTCmxyabC
	 XRN4UFXgxbSQLOAAMpvgtK8o3JubvsWu96HcI00ZwjyJpowxQ1o1mogRfQ6sNBRxof
	 kQovHD5ZLAFxMLwXAueMgUh/fTx2m/jbIvQJm4Ic=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250423165509epcas5p3cdeea471617c2c21a561720158c77d04~5AOPpbce_0928009280epcas5p3Z;
	Wed, 23 Apr 2025 16:55:09 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.174]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4ZjQFm1MnLz3hhT3; Wed, 23 Apr
	2025 16:55:08 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250423133628epcas5p2b4752a672a64bd2f1392f663a284f9f2~49gw9VlEv2472624726epcas5p2O;
	Wed, 23 Apr 2025 13:36:28 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250423133628epsmtrp277b86bd80a2673275e37338b1943c7ea~49gw8fgSb2861728617epsmtrp2z;
	Wed, 23 Apr 2025 13:36:28 +0000 (GMT)
X-AuditID: b6c32a29-55afd7000000223e-e5-6808ecdb87c3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6A.F3.08766.BDCE8086; Wed, 23 Apr 2025 22:36:27 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
	[107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250423133627epsmtip26aa9c831b374d7877ed26a723579975b~49gwMrFqg0819108191epsmtip2T;
	Wed, 23 Apr 2025 13:36:27 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: io-uring@vger.kernel.org
Cc: gost.dev@samsung.com, nitheshshetty@gmail.com, Nitesh Shetty
	<nj.shetty@samsung.com>
Subject: [PATCH liburing 0/3] test/fixed-seg: Add data verification and
Date: Wed, 23 Apr 2025 18:57:49 +0530
Message-Id: <20250423132752.15622-1-nj.shetty@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsWy7bCSvO7tNxwZBp/7LCxuHtjJZPGu9RyL
	xY4njYwW237PZ3Zg8dg56y67R9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGV0z9jAVPCIteLg
	hZWsDYzXWboYOTkkBEwk5p1/wNbFyMUhJLCbUeLs+1mMEAlJiWV/jzBD2MISK/89ZwexhQSa
	mSS2TczvYuTgYBPQljj9nwMkLCIgIzF95iKwVmaBGImTLVOZQGxhAXeJPY3vwGwWAVWJb/uf
	soG08gpYSXz6FgwxXV5i9YYDzBMYeRYwMqxilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/d
	xAgOBy3NHYzbV33QO8TIxMF4iFGCg1lJhPeXG3uGEG9KYmVValF+fFFpTmrxIUZpDhYlcV7x
	F70pQgLpiSWp2ampBalFMFkmDk6pBiZOy54NQR+vHrx7+cq6tpmXMtlr3yr8fxAqeLD31F1V
	ueUbH/jn53iucvCWXb1khmNuxF62D+fSNVesyREQN/AVi1/Oosofqr1s7pyzB19WZhw67NyS
	fno+O9PLVo7Sgvs738rdmnnM0NFNXYJzmvvc/vzI65abLz9Qf9RgKHvs4YsXE9gW6mbefmjy
	dZPijspF8z4xrLVRO20Y+XReXY2QQ+9qYRVXM5ZY4WNZScYBliJ7b99X/c3vrMqV1VezWXWv
	acecYu7DczfdP2doPIlv5aFFCfsPPTm6zte3YsX3D5nLynUc/szpsOX5EnL8klB+UNGteluf
	0ONK8/fqHC3YcW390VdirUJTk+58EjynxFKckWioxVxUnAgAAHpcYXYCAAA=
X-CMS-MailID: 20250423133628epcas5p2b4752a672a64bd2f1392f663a284f9f2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250423133628epcas5p2b4752a672a64bd2f1392f663a284f9f2
References: <CGME20250423133628epcas5p2b4752a672a64bd2f1392f663a284f9f2@epcas5p2.samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Write data before issuing read and verify the data once read is
completed. This makes sure we are failing if nr_seg is passed wrong,
incase of offset is present.

At present test fails for block devices formatted with non 512 bytes.
This allows to test 4k block devices. Some of the corner cases such as
3584 offset test are not valid for 4k, hence skipped.

Nitesh Shetty (3):
  test/fixed-seg: Prep patch, rename the vec to rvec.
  test/fixed-seg: verify the data read
  test/fixed-seg: Support non 512 LBA format devices.

 test/fixed-seg.c | 51 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 11 deletions(-)


base-commit: 353fc7dcc61e059ac8890916f41d39df10e5bfa5
-- 
2.43.0


