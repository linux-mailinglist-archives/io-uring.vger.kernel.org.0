Return-Path: <io-uring+bounces-4057-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A339B23BE
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 04:55:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DD901C21326
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 03:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41870189918;
	Mon, 28 Oct 2024 03:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cuWgeGAA"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C4C18593B
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 03:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730087722; cv=none; b=ZRVVJCZYWCMRuw2C5yL0nt5Zfz2RbYEGtA5wOoqBdjRv8/qOT3TVqBM3rTHga51nzfHSWCXXnbiC2r/th0lhRRXwplpa7AyNoyTvfkfIg3yzJbqymMV15acYouC7nhb4RAT5nx/AGgnSwirZLPj3iRLSmzC49ACocWSqsbZoLAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730087722; c=relaxed/simple;
	bh=wKdq2ojcsvjFSKLtbJ43rf1uG8MA5N83T36nu1dsqMs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=T+ler2JFk8zCkAo7aWPzg/a/dLmXHykFwCWWZ/8qcs6cSp/am4bRJuehOUXCdM+rVBY2Wo114G2WfMefE+iYZQuaub1istbPlTZvBRR6Tzsw1R+zdcOn6M69zUZIMb5SPv1FFtGFFRyEb+EnwTHaku1H2ecuA4bKJJXbjV3wQFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cuWgeGAA; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241028035511epoutp03567291736f711739a74bdbc6a280f0a2~CgZt3JSJL1351413514epoutp03E
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 03:55:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241028035511epoutp03567291736f711739a74bdbc6a280f0a2~CgZt3JSJL1351413514epoutp03E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730087711;
	bh=bo6Ea5i0R6emGG7nj9+WppTEgZq02wQoJLP9S61V1so=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cuWgeGAAxiRPYto8Vna81W6OItruMIz3jjDQB6H+MCaRHXO6PkfHOQZNTCZRajkVb
	 CGGuM6JRagmkzQTN5OT43pqHs67vE2iwQqT64BHiwsoZRz0zF+ba8qNulbJk4vyF/P
	 LLa4m1HHm6PYkAetkSIuadaCKSpaF0x7/zmEIG6k=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241028035510epcas5p2656031a5840a38aca3e05b9581123591~CgZtMYkcw2900229002epcas5p2k;
	Mon, 28 Oct 2024 03:55:10 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XcKKS43Vpz4x9Q5; Mon, 28 Oct
	2024 03:55:08 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F1.A6.09420.C1B0F176; Mon, 28 Oct 2024 12:55:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241028035435epcas5p4dbd78e5f7bacde9fc302fcfde86453b9~CgZLzQgVv1472514725epcas5p4c;
	Mon, 28 Oct 2024 03:54:35 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241028035434epsmtrp2eb03ec25eb9f71578219fd904e79a04d~CgZLyUu_81877218772epsmtrp2k;
	Mon, 28 Oct 2024 03:54:34 +0000 (GMT)
X-AuditID: b6c32a49-33dfa700000024cc-a9-671f0b1cde6c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	02.26.08227.AFA0F176; Mon, 28 Oct 2024 12:54:34 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241028035432epsmtip2358aad8e30b6e4241266bb0a578e7b49~CgZJ1ATw50427304273epsmtip2a;
	Mon, 28 Oct 2024 03:54:32 +0000 (GMT)
Date: Mon, 28 Oct 2024 09:16:48 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v4 04/11] block: define meta io descriptor
Message-ID: <20241028034648.GA18956@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <yq1h694lwnm.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJsWRmVeSWpSXmKPExsWy7bCmhq4Mt3y6wfVbUhYfv/5msZizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jsjg/aw67A5/Hzll32T0uny312LSqk81j85J6j903G9g8Pj69xeLRt2UVo8fm09UenzfJ
	BXBGZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2u
	pFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUq
	TMjOuP/as2ADW0XvuW+sDYwrWLsYOTkkBEwkrv3oYuxi5OIQEtjNKLHlcjuU84lRYsnaVijn
	G6PE/Ddv2GBavq66yAKR2MsoMWvJRSYI5xmjxMnLp8GqWARUJQ5/uMMOYrMJqEsceQ4yipND
	RMBUYvKnrWwgDcwC+5gkjl2awwySEBawk+g5sg+sgVdAV+L32otsELagxMmZT4DWcXBwChhL
	LJ4rABIWFVCWOLDtONhiCYETHBLPbzRAfeQiceg5SD2ILSzx6vgWdghbSuLzu71QL6RL/Lj8
	lAnCLpBoPraPEcK2l2g91Q92D7NAhsTa/Z+h5shKTD21jgkizifR+/sJVC+vxI55MLaSRPvK
	OVC2hMTecw1QtodE04EWNngIdTxdwDyBUX4Wkt9mIdkHYetILNj9iW0W0M/MAtISy/9xQJia
	Eut36S9gZF3FKJlaUJybnlpsWmCYl1oOj/Hk/NxNjOCUreW5g/Hugw96hxiZOBgPMUpwMCuJ
	8K6OlU0X4k1JrKxKLcqPLyrNSS0+xGgKjKyJzFKiyfnArJFXEm9oYmlgYmZmZmJpbGaoJM77
	unVuipBAemJJanZqakFqEUwfEwenVANTduR9QT9BM7/J6V6us3/2a3nWzpR8yf/1h7TZfXNN
	T57NR3bc1o2yOKrLuDz97GVtqWWlml2JJk6c+9YH/jNRFS1Z+2aKwBqmJrOel499NoQs2hLo
	uvBdxqtXod6yuiH1XW11qQmddoY+V07NzY7anx21pGHOycPBDP/q3/tNqam980Ba72iHn7mW
	z2F36Xm3LdcLsq+OrNG9crNN8n/QfTsHwanLRQ34v9syXtilFb7i7/UZDd5BaZxlXRNnbbjO
	lNx+9atRWSP3bNP64LVz3bS/L5uekNu2s3jK28rSjx9dHDUnbkr6ZWOeujiH343NaKV6+u/z
	nVfP/X9gfb6Wca7bqTe2c+u31orM71ViKc5INNRiLipOBAB9ZzhnYgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSvO4vLvl0g039xhYfv/5msZizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jsjg/aw67A5/Hzll32T0uny312LSqk81j85J6j903G9g8Pj69xeLRt2UVo8fm09UenzfJ
	BXBGcdmkpOZklqUW6dslcGVsPfaTveADc8WKpjbmBsZG5i5GTg4JAROJr6susoDYQgK7GSVu
	fuSBiEtInHq5jBHCFpZY+e85excjF1DNE0aJk32z2UESLAKqEoc/3AGz2QTUJY48bwVrEBEw
	lZj8aSsbSAOzwD4miRW9b8ESwgJ2Ej1H9oE18AroSvxee5ENYuozRolV7x+wQCQEJU7OfAJm
	MwtoSdz495Kpi5EDyJaWWP6PA8TkFDCWWDxXAKRCVEBZ4sC240wTGAVnIWmehaR5FkLzAkbm
	VYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwZGmpbWDcc+qD3qHGJk4GA8xSnAwK4nw
	ro6VTRfiTUmsrEotyo8vKs1JLT7EKM3BoiTO++11b4qQQHpiSWp2ampBahFMlomDU6qBKdRx
	2YKrJ9ZGXFO98FgyYc+9b44aIpl2vvstei93an5MeixVZai7hENA1tO0eH/Bdj1/07tJx61P
	RrG5LF/r5TJzw6kuJW7H3b8EXLguBF1/aJ29T8H7adrPN7bLdr1XEvAXjk86deoyZ87nR37n
	ZvB25cpG1731ct9wQ/64bvzz1e2erXn8t2aXtm1mevhATCBjges7wx/5FWzuOhNPr/SfeaAm
	7ajyRrV/Aq8FzExkcpdoTJyu1BYjrHZ20Y/HuiumXD7UoDRNv3xjzN5lfnUvk2bP5xB0XWT9
	bf0nJ+nfHUz+mWEuNzjCWe+wfGgp7RM9fstiWVnnxZjTFc8NPl2JNZbIPxFyIqOxVLFUiaU4
	I9FQi7moOBEAaLCvJyMDAAA=
X-CMS-MailID: 20241028035435epcas5p4dbd78e5f7bacde9fc302fcfde86453b9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_7d6d3_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113741epcas5p3b90adb3b43b6b443ffd00df29d63d289
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113741epcas5p3b90adb3b43b6b443ffd00df29d63d289@epcas5p3.samsung.com>
	<20241016112912.63542-5-anuj20.g@samsung.com>
	<yq1h694lwnm.fsf@ca-mkp.ca.oracle.com>

------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_7d6d3_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

> Not sure what to do about the storage tag. For Linux that would probably
> be owned by the filesystem (as opposed to the application). But I guess
> one could envision a userland application acting as a storage target and
> in that case the tag would need to be passed to the kernel.

I will reserve space for storage tag in the user interface for now.
That way, we can introduce and use it later when it is actually used.

> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> 

------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_7d6d3_
Content-Type: text/plain; charset="utf-8"


------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_7d6d3_--

