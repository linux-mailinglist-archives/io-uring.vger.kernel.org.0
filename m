Return-Path: <io-uring+bounces-2463-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D4D2A92ADEE
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 03:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62789B21273
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 01:48:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1069B4A05;
	Tue,  9 Jul 2024 01:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dP7LsRah"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17EC3D966
	for <io-uring@vger.kernel.org>; Tue,  9 Jul 2024 01:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720489707; cv=none; b=skSDzYe9Jfzinv3Of7NE0af8YejpJrNWOjmSDvADRUIHCTBpr+l5DV4Sa6Q1YxvbbYvRFQ3fEzASaO7yRUbcPzzaRwvE1JwgghyJ3riSHCo9RZqdU+V4IiuNJAdtTzlaIAI/fG9RdDTSPR20nCFOVT0ButwFhNIC7NUAi2MVQ/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720489707; c=relaxed/simple;
	bh=4bprW1oEnmKRwnmi0O10kzb3M7YieHDxus5EyHOA2hw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nxvjCVkXQ4I9lthQwJdxJXTDvhBpgYjj9ryyNtZwPwmSa6PQ2P9pYTvHlOJ1ENpZ5ny6j0LNoVaYZWR1ZaxoVcB2XJVLVJ0qbWZEThtW0ArLwTmZ8Ij+Usw+TD/SilvM7hkFhSXkj6VPxf56axlQWfSyteMtqhFpxIWniPYgVfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=dP7LsRah; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240709014815epoutp01ebaa9bca65db418352d0d64cb7054ddd~gaEMYSzGM0082700827epoutp01L
	for <io-uring@vger.kernel.org>; Tue,  9 Jul 2024 01:48:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240709014815epoutp01ebaa9bca65db418352d0d64cb7054ddd~gaEMYSzGM0082700827epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720489695;
	bh=4bprW1oEnmKRwnmi0O10kzb3M7YieHDxus5EyHOA2hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dP7LsRahbrnrYx0mbzurgEPlwtLHa08UkwrW1iGmW53JAP7F+tpm5cFfX97wqmUCl
	 xxVtXBeiEQODKvfPX05rZH8nZKsg7DLtYOL22fXkPpI4CmvCvqiIWIyW8vahsVcIvK
	 pYcbHnJ40tPZmIpPF5xFIA0izucfmtN+g84tIqAo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240709014814epcas5p2cde0c0bc31639ad6e7843c8cc9e4e853~gaEMHvwgA0485204852epcas5p2h;
	Tue,  9 Jul 2024 01:48:14 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4WJ3mF3T19z4x9QQ; Tue,  9 Jul
	2024 01:48:13 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D9.53.09989.CD69C866; Tue,  9 Jul 2024 10:48:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240708021432epcas5p4e7e74d81a42a559f2b059e94e7022740~gGx3dePax1570415704epcas5p4-;
	Mon,  8 Jul 2024 02:14:32 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240708021432epsmtrp1b9be56cedcce3153f0984f8af9dd987f~gGx3bjjzB1370013700epsmtrp1f;
	Mon,  8 Jul 2024 02:14:32 +0000 (GMT)
X-AuditID: b6c32a4a-e57f970000002705-fd-668c96dc994b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F4.F3.29940.88B4B866; Mon,  8 Jul 2024 11:14:32 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240708021432epsmtip14b43c8dfe2bb7ff73275d2ddf7964a1f~gGx22HhRw0238402384epsmtip1S;
	Mon,  8 Jul 2024 02:14:31 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH v5 0/3] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
Date: Mon,  8 Jul 2024 10:14:26 +0800
Message-Id: <20240708021426.2217-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240628084411.2371-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsWy7bCmuu6daT1pBp3r2S3mrNrGaLH6bj+b
	xbvWcywOzB47Z91l97h8ttTj8ya5AOaobJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11D
	SwtzJYW8xNxUWyUXnwBdt8wcoD1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKT
	Ar3ixNzi0rx0vbzUEitDAwMjU6DChOyMR2+/MhUEV7ze/ZWxgdGhi5GTQ0LAROLh8Ta2LkYu
	DiGB3YwSLy9tZoVwPjFKNO/thnK+MUp8eLWYHablVNcDqMReRokbS5pZIJwmJomzh78xgVSx
	CehI/F7xiwXEFhHQlnj9eCqYzSwgIzF5zmWwScICkRK3bzYzg9gsAqoS3/59AevlFbCW2Lz3
	LQvENnmJ/QfPgtVwCthIXJo+ix2iRlDi5MwnUDPlJZq3zmYGOUJCYBe7RPP9xawQzS4SU04+
	Y4KwhSVeHd8C9YKUxMv+NiCbA8gulli2Tg6it4VR4v27OYwQNdYS/67sYQGpYRbQlFi/Sx8i
	LCsx9dQ6Joi9fBK9v59AjeeV2DEPxlaVuHBwG9QqaYm1E7YyQ9geEhMf3IQGdj+jxM/V2xgn
	MCrMQvLPLCT/zEJYvYCReRWjZGpBcW56arFpgVFeajk8kpPzczcxgpOeltcOxocPPugdYmTi
	YDzEKMHBrCTCO/9Gd5oQb0piZVVqUX58UWlOavEhRlNggE9klhJNzgem3bySeEMTSwMTMzMz
	E0tjM0Mlcd7XrXNThATSE0tSs1NTC1KLYPqYODilGphcLq45tW1B3GJP97qKfWISk//OvOjN
	5aHpf6DW5naIlVDq4v8aKpVLzHXVLn5+6DWhZNO7G1PfuCiYbmL7cMZusk7rLsaHy0v+hU6a
	K3TYdP+cqH3C2t5LFPifytwJXPG/3S/ETmStUNHV7UarVFRm33gbf9r966F9652ssjd0cn14
	Pnea9XZZiw3lwnyST+U13jzOCdpbaiJn33jy9HXGvbcdm+949/2U36dvMH+WUa/cmu937Ldu
	+FzpHt06784LwWUqDs1GLVs2CFydENDf/tZYXu2QQ2Dg1a/dmcrqhyd/+arW1pV14WqCkLnb
	wQpjBZmZP285CSpX6n2NZBGelSsnl/1kbrSw7ytR3tdKLMUZiYZazEXFiQBmuzDLAwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsWy7bCSnG6Hd3eawfz/6hZzVm1jtFh9t5/N
	4l3rORYHZo+ds+6ye1w+W+rxeZNcAHMUl01Kak5mWWqRvl0CV8ajt1+ZCoIrXu/+ytjA6NDF
	yMkhIWAicarrAWsXIxeHkMBuRonN+58wQySkJToOtbJD2MISK/89Z4coamCSmNz6kQkkwSag
	I/F7xS+WLkYODhEBXYnGuwogYWYBGYnJcy6D9QoLhEs8ujcXrJxFQFXi278vYDavgLXE5r1v
	WSDmy0vsP3gWbC+ngI3Epemz2EFGCgHVfLgbCVEuKHFy5hMWiPHyEs1bZzNPYBSYhSQ1C0lq
	ASPTKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4IDU0tzBuH3VB71DjEwcjIcYJTiY
	lUR4Tz9uTxPiTUmsrEotyo8vKs1JLT7EKM3BoiTOK/6iN0VIID2xJDU7NbUgtQgmy8TBKdXA
	5KDLekakd7/6Yp+N/3dvD332dYnsE+WwZqlwzoKYp05c+kzzpiXvb+R67vJSycxIXaLs9oej
	m9hPvRfQvnfc2+nnynUPZy30XK7OLDCx7pXysuVR5dc+uTYe+OK88ecGD7U8rumfGE7OEFwT
	HKrE1fnyX+Eib6ugZPtzr4vvLvjfdepUU9LDiJj5b87vM+E0mFz0Ws1Iivf1lKWLD/A/S0m/
	U7fljah0rNJtx3M7ROZNE+0z+/5+/91/zIbpp3fdfhBmY/1m5vJD717/2O835/C87yEPDIPa
	bVMW1Ze//JOZdcnswJFemx6zwH/OSm+Plpgtufib/b/Z9Tr2wxqqu9nyfe0ChSL5yjV3TNBX
	yFNiKc5INNRiLipOBADIjT18twIAAA==
X-CMS-MailID: 20240708021432epcas5p4e7e74d81a42a559f2b059e94e7022740
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240708021432epcas5p4e7e74d81a42a559f2b059e94e7022740
References: <20240628084411.2371-1-cliang01.li@samsung.com>
	<CGME20240708021432epcas5p4e7e74d81a42a559f2b059e94e7022740@epcas5p4.samsung.com>

Hi, a gentle ping here. Any comments on the v5 patchset?

Thanks,
Chenliang Li

