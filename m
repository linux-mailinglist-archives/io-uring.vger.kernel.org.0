Return-Path: <io-uring+bounces-2029-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1DF28D5844
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 03:41:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C9E11F220DE
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 01:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC5FE5234;
	Fri, 31 May 2024 01:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="csAsv3pO"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5B7EAC0
	for <io-uring@vger.kernel.org>; Fri, 31 May 2024 01:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717119711; cv=none; b=l5bG+5nyPDwN1jU4hvj9HB+lZkABphM9qzK+ph89Yczi/tsp9keAfFMtscfBn0FTGm1cqjUMqrCuRhHZrH2olc46YLnYWAaNCL7sCkCRSV1M02CWaudLlJRImI+cGAqyXPgsKF7gnO0ScWq72qtXUkajKRe4IJfMDXosUQOCn60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717119711; c=relaxed/simple;
	bh=lRjSAdq2FdtWzsoMh50Gsb+Iybh1I+/A9oj0Ki+T1Pk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=e2q64ua8WQRh7OZayP85nA3BeUl9nqkcxk35/jrI0R9SOZPe6l4SQ7SuuLxLKc4H5SfGrrUPcxYe1UbNjuPeasNHR7/Gcc5nRjt8WW7KUnNSfwdOQ1RA2YSMfk8lx97leNBErQtEwL5S5EtuIw0nCeMXgzH+WzxPqv1O7KZAN8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=csAsv3pO; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240531014147epoutp026d940847f8a66bc7a21e5b56735318d4~Ub0att23D1352413524epoutp02N
	for <io-uring@vger.kernel.org>; Fri, 31 May 2024 01:41:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240531014147epoutp026d940847f8a66bc7a21e5b56735318d4~Ub0att23D1352413524epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717119707;
	bh=jBRff9EnumBbFjZ6rw47NTrF68QSb8h+StGdX1gtL1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csAsv3pOi47Wt2g+GBADMBZDQBvchpVyyo7IcsdEfaHpKksP+jPmtkIeLJoYw2bbJ
	 UuPxqmDJ5ZPKAvPFS2xdsYkFJx8hjfsvDT7b9TDLjEdChpu7SuoJsWJdxMBG5Fqi5l
	 eJq6G0R7VKbqCWS/c2HlEtvDmIL1feTkf1L5eqFc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240531014146epcas5p4f3ce3fbcdab420b74d1b69615e934337~Ub0aDknJE0823108231epcas5p4T;
	Fri, 31 May 2024 01:41:46 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Vr5Sm57Zkz4x9QB; Fri, 31 May
	2024 01:41:44 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DC.46.10047.8DA29566; Fri, 31 May 2024 10:41:44 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240531014136epcas5p2a13112956b5b492f7ac74d230270c8eb~Ub0Q5rdGa1463114631epcas5p2d;
	Fri, 31 May 2024 01:41:36 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240531014136epsmtrp2815e60381e804bae9b1811e9177bee43~Ub0Q4dBe_0927609276epsmtrp2L;
	Fri, 31 May 2024 01:41:36 +0000 (GMT)
X-AuditID: b6c32a49-1d5fa7000000273f-90-66592ad89d01
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	75.90.08622.0DA29566; Fri, 31 May 2024 10:41:36 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240531014135epsmtip1658c72957b6cd8d89a39dfe990c04f72~Ub0PlTNFo0227802278epsmtip1o;
	Fri, 31 May 2024 01:41:35 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk
Cc: anuj20.g@samsung.com, asml.silence@gmail.com, cliang01.li@samsung.com,
	gost.dev@samsung.com, io-uring@vger.kernel.org, joshi.k@samsung.com,
	kundan.kumar@samsung.com, peiwei.li@samsung.com
Subject: Re: [PATCH liburing v2] test: add test cases for hugepage
 registered buffers
Date: Fri, 31 May 2024 09:41:31 +0800
Message-Id: <20240531014131.1441446-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <301ba50b-5015-46d0-a7a9-48692be7dfa0@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsWy7bCmhu4Nrcg0gw1XlCyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7IyXm+wLVrBVXJp+hamB8RtLFyMnh4SAiUT/p23MXYxcHEICuxkl
	3r7bwwThfGKUuLXgICuE841R4smlS+wwLW+a17BDJPYySqyatJsFwvnFKPFuWgsjSBWbgI7E
	7xW/wJaICAhL7O9oBStiFjjMKDF3/VM2kISwQLhE17JbYDaLgKrE2pkvmEFsXgE7iTOL/jFD
	rJOX2H/wLJjNKWArceTOPRaIGkGJkzOfgNnMQDXNW2eDfSEh8JFdorWnnQ2i2UVi1vt1TBC2
	sMSr41ugfpCS+PxuL1ANB5BdLLFsnRxEbwujxPt3cxghaqwl/l3ZwwJSwyygKbF+lz5EWFZi
	6imIkcwCfBK9v59AjeeV2DEPxlaVuHBwG9QqaYm1E7ZC/eIhsWbhe2hoT2CU+Lf3EssERoVZ
	SP6ZheSfWQirFzAyr2KUTC0ozk1PLTYtMMxLLYdHc3J+7iZGcELV8tzBePfBB71DjEwcjIcY
	JTiYlUR4f6VHpAnxpiRWVqUW5ccXleakFh9iNAUG+ERmKdHkfGBKzyuJNzSxNDAxMzMzsTQ2
	M1QS533dOjdFSCA9sSQ1OzW1ILUIpo+Jg1OqgUmheaHsfamU99OuTfm8ep+cW1v30rrLD3NW
	7rig9t6U439ZcQS3ZL1Hz5Npnv9PFrmc54s6clBv05KXYr/PHfka7rOig+dIdcrNbRnrP6tk
	3dLdcvNpkovs/nW8c+af+3Wx383s8jWXByf+mDH6Xt3xvO2FR8Reyfn3nhW3Fm+fvJ+3bIfu
	mndzdm48IsCz+ZZ407eg7XdcDhfXrmZwi65ZpWM1TdOmLyLmzxyJsOoe/mBrnzOLIiy219hM
	TlrdsMF6150lzkIqUmqbvSPVRK0+Lfm9QSuy88WiG1UGkllO3nbe8jvNnzM5LH0XXLWFWSrh
	/ISYOQVezRJWju+VEhea2lXLHdz30/ZX5LKm0AlKLMUZiYZazEXFiQDoqV14MQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWy7bCSnO4Frcg0g4mnlS2aJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxstN9gUr2CouTb/C1MD4jaWLkZNDQsBE
	4k3zGvYuRi4OIYHdjBLbTmxkhkhIS3QcamWHsIUlVv57DlX0g1Hi3PlGsG42AR2J3yt+gdki
	QEX7O1pZQIqYBc4ySlw/1s4GkhAWCJW4faUTbBKLgKrE2pkvwDbwCthJnFn0D2qbvMT+g2fB
	bE4BW4kjd+4BDeIA2mYj8XONHUS5oMTJmU/AdjEDlTdvnc08gVFgFpLULCSpBYxMqxglUwuK
	c9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxgsNdS2sH455VH/QOMTJxMB5ilOBgVhLh/ZUekSbE
	m5JYWZValB9fVJqTWnyIUZqDRUmc99vr3hQhgfTEktTs1NSC1CKYLBMHp1QDkxpPikme5bO8
	iflKNlwZ60Kjq76cqLzKxjrfYWX3Q2du29p37InfeWsDpecl5J4OUpBNm3/KQCQ+6LiH1Cop
	9S5e/0Uhe0TPVk3d5hacxxlZmlNobaHH4fTjX8oaF0bW1vscQfonYw+Vn3gSl9R6WVfA5bKO
	SuDCGRPK9TOnNGUUR1lHF5vu8SxQf3DGTO1K0IUy20c/FbOjLrIq5j27/qp8nTX31yL+o5/N
	Wp31nvp58h/p/V/53avhAH/on3KbP192hdY9eOh0f0X0tF6ewtj9996UHWYRrijfxbbYTlPG
	6G7zN4trO0v+n7PmlV6yK/LRLiVB8wuHtE6/7lNp1pvic+BwmALnxveOU5RYijMSDbWYi4oT
	AdqTznrmAgAA
X-CMS-MailID: 20240531014136epcas5p2a13112956b5b492f7ac74d230270c8eb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240531014136epcas5p2a13112956b5b492f7ac74d230270c8eb
References: <301ba50b-5015-46d0-a7a9-48692be7dfa0@kernel.dk>
	<CGME20240531014136epcas5p2a13112956b5b492f7ac74d230270c8eb@epcas5p2.samsung.com>

On 2024-05-30 14:51 UTC, Jens Axboe wrote:
> Thanks for improving the test case. Note on the commit message - use
> '---' as the separator, not a random number of '-' as it would otherwise
> need hand editing after being applied.

Will pay attention next time.

> This is against a really old base, can you resend it so it applies to
> the current tree? Would not be hard to hand apply, but it's a bit
> worrying if your tree is that old.

Sure, will rebase it.

> Outside of that, if you get ENOMEM on mmap'ing a huge page because the
> system doesn't have huge pages allocated (quite common), the test case
> should print an information message and return T_EXIT_SKIP to skip the
> test case rather than hard failing.
> 
> A few other comments below.

Will fix these issues. Thanks!


