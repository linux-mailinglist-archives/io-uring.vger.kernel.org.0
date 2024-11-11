Return-Path: <io-uring+bounces-4597-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F749C3AE8
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 10:32:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27998283205
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 09:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F26E1149C55;
	Mon, 11 Nov 2024 09:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qnk6fON3"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A2713A87C
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 09:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731317519; cv=none; b=C67q3Q6t2oPH0gTgWOYfbwGUscJoelarsMV9g4i07RYMSEOWyPq58dBgOmoRsVcd1pnlMVECHlQ802ZQ0mUGEnLvYGVbeqvsXeWbjoU9iUvF06nEE26WBWW7sai29mivENKJzHsJQQ7AbqLM0Hf+If04+QidLzrDe6iQEtHiJws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731317519; c=relaxed/simple;
	bh=wSo8owcbmmdZLdtSUlDCR3rgaYI63gjofW60l0l59dQ=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=gpwLk26cGhCq9gW3yUiapSiNkTbL060GYOQtIBz5CK37BEtU7hc28dW75GcvWf5TC4qrxSpG/N9VEGR0MBJxTWpiOBBXtN7Lfb+uoQA7GL7Gm/bP/lBjQhSS4BXM2hwSJ6ATmrUYMiRTOdUpEFA1gQ9FgmBC+gnwwMwgesrY+Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qnk6fON3; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20241111093156euoutp02e8b63a4e0a21669a4f19b1c044a9699c~G4Bu4xVgk1866218662euoutp022
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 09:31:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20241111093156euoutp02e8b63a4e0a21669a4f19b1c044a9699c~G4Bu4xVgk1866218662euoutp022
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731317516;
	bh=wSo8owcbmmdZLdtSUlDCR3rgaYI63gjofW60l0l59dQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=qnk6fON3KC6vXoYoKz5NYq3yWytrFaVhI9pMfcLvw4/M7MlpJv0bwFiTstGg3AzIz
	 wCjN5oYjCOLD8n/M3/DElueVI2ytgnoVT2/b7K7T1CkctO3cMklGTT5PZoXh6nTGx9
	 RtTr39oIGeit7Spk9vHrZR3X+Kcuzoz58LxnErYY=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20241111093156eucas1p1daede80b307fed0064acc9ea541373dc~G4BuoOCQC2892328923eucas1p1K;
	Mon, 11 Nov 2024 09:31:56 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 66.58.20821.C0FC1376; Mon, 11
	Nov 2024 09:31:56 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20241111093155eucas1p21a04cbacd57cffa49c2158c7b5f8d801~G4BuS7j2T3162731627eucas1p2O;
	Mon, 11 Nov 2024 09:31:55 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241111093155eusmtrp1c2e1f6559e1b7f89df28018594ce4ffe~G4BuSUaNm3074830748eusmtrp1L;
	Mon, 11 Nov 2024 09:31:55 +0000 (GMT)
X-AuditID: cbfec7f2-b09c370000005155-84-6731cf0cf5e4
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id FD.AB.19654.B0FC1376; Mon, 11
	Nov 2024 09:31:55 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241111093155eusmtip19a835f2627c842b28105af41f3a00884~G4BuF1Afm1735817358eusmtip1E;
	Mon, 11 Nov 2024 09:31:55 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Mon, 11 Nov 2024 09:31:54 +0000
Date: Mon, 11 Nov 2024 10:31:54 +0100
From: Javier Gonzalez <javier.gonz@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
In-Reply-To: <2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SaUwTYRCG/brb7bZaXYrKKMajBoMYQaLB9ap30njWHxo0RqmyFqQU7FJB
	8GjkVhRF8UBFiHLYJsbQFg2IgaYFKgRUVJCIaMSooA2iJSJqtN16/Htm5p3MvJMhMUkpfyIZ
	rUlgtBqlWkqI8Mr6odbZo1pDVXOyavj0uf4hjL5htPNoZ3oLTudZnyK6+UkxTtd0zqLv1jhw
	+mrpGwF9vP0OQQ9/vUwsE8nbHq+Vm8qD5BWGbEJuun5EXv1MT8hbHibJP1dMVgi2iRZHMuro
	/Yw2RBYhirJklxHx3XhSV42d0KM+7BgSkkDNg7OOc/xjSERKqHIE7R8sOBd8QWCxuQgu+Izg
	W+Hb3y2kp8VVhXH5MgRNPWbsr8jZe9UbmBEMGM0C9xCcCoBK1yPkZoIKAcPt+x4eSwXC4Msy
	zzyMGsQgrSjDU/ClVkLOlS4Pi6klUDJgFHDsA46LPbibMWohZPcf5btXwih/KPtJutNCahE0
	VtXxOHNSeP3uI+L4ENw3d/Lcs4BKFcKnE4Ve0So48a5IwLEv9DaYvTwJms7k4ByngN7R6G1O
	Q5CeZeFzt1gEJ5vVnGY5dDtP41x6NHR89OHWHA15lee9lxNDVoaEU88A44sP+Ck0veA/YwX/
	GSv4Z6wIYQbkx+jYWBXDhmqYxGBWGcvqNKrg3XGxFej3KzX9bBi4g670fgq2Ih6JrAhITDpW
	HLgxRCURRyoPJDPauJ1anZphrcifxKV+4oDIKYyEUikTmBiGiWe0f6o8UjhRz7uQGzCP9X22
	oUBks7OX8lmfqVtsHfr5/i9bozJt+/qI9pvWlH6H8bjZ5GfPrc6cVhxTvbdOP3dcUEeUve29
	M/XodEWxCfWF7yqvbEgJi40TZdQbcsz+tYUrbLWTh5sHfRewwvBE+pQm+dUyXe/rlryA7cyP
	8LA39GJZ6uG2tPiU7DV+aaE3D9oT1I/Sq6a+DYywdO0YOT6znoXGmLVjZu7Lp2r7XIpbiVj3
	odIjnTvbNyc9uLduOKFxT/0Ik8a5XjZQ0jX0Taa56zOrtSQw7MDCfDS09HmxwF4Liojrhq2b
	vi+HpebkbZrC6NUPRpRe273hgi6iR9YJcyfUtYx3KaQ4G6UMDcK0rPIX+UEn37kDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t/xu7rc5w3TDU61a1lM+/CT2WLl6qNM
	Fu9az7FYTDp0jdHizNWFLBZ7b2lb7Nl7ksVi/rKn7Bbd13ewWfz+MYfNgcvj8hVvj80rtDw2
	repk89i8pN5j980GNo9zFys8Pm+SC2CP0rMpyi8tSVXIyC8usVWKNrQw0jO0tNAzMrHUMzQ2
	j7UyMlXSt7NJSc3JLEst0rdL0MvY2rmcreA+S8XdvUfZGhhfM3cxcnBICJhIfN0FZHJxCAks
	ZZRo2/SXqYuREyguI7Hxy1VWCFtY4s+1LjaIoo+MEr1nzrNDOFsYJXY9+M0CUsUioCqx7esl
	RhCbTUBfYtX2U2C2iICGxLcHy1lAGpgFvjFLtCxoA0sICzhL9My9C2bzCthKLP20GmrqImaJ
	T28PsUMkBCVOznwCtoFZwEJi5vzzjCB3MwtISyz/xwES5hSwljix6yDU2UoSj1+8ZYSwayU+
	/33GOIFReBaSSbOQTJqFMGkBI/MqRpHU0uLc9NxiI73ixNzi0rx0veT83E2MwOjcduznlh2M
	K1991DvEyMTBeIhRgoNZSYRXw18/XYg3JbGyKrUoP76oNCe1+BCjKTAsJjJLiSbnA9NDXkm8
	oZmBqaGJmaWBqaWZsZI4L9uV82lCAumJJanZqakFqUUwfUwcnFINTKwHI2cUSwQkdfkcFZkv
	Oyvmb+x1rujg9n+eBptOXv1r3a/A/u1ZVsGLZ4psSalctn4+v89V1r5dGBkSddirbPs585W2
	Eb8WMia+XXvmmGgem87Ux//du4riuqdbyO7IaxR/lRG9r1n1/dxtS3zU5zlftNfbe5734c/v
	JnINxfJFJ1l37lozMaZr5s1vJZWGXTpm/u7niuy/TmV7l7VbT+Lq/di/LkfOrju+QPzFxArj
	av+IudkyZVNMwn/wr+S8+uvB8tXOorbq/wNEmtrfLGrOZfFhK14ixlBenNr8uZfjyI+a3cWi
	ylYK9y0496hd6M1cfiH/yPt9x2ZvnP/rr/F9xVzf4E8btMu/Ok5drcRSnJFoqMVcVJwIAJ5m
	i7hXAwAA
X-CMS-MailID: 20241111093155eucas1p21a04cbacd57cffa49c2158c7b5f8d801
X-Msg-Generator: CA
X-RootMTR: 20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a
References: <20241029151922.459139-1-kbusch@meta.com>
	<20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp>
	<20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp>
	<CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com>
	<Zy5CSgNJtgUgBH3H@casper.infradead.org>
	<d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
	<2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>

On 08.11.2024 10:51, Bart Van Assche wrote:
>On 11/8/24 9:43 AM, Javier Gonzalez wrote:
>>If there is an interest, we can re-spin this again...
>
>I'm interested. Work is ongoing in JEDEC on support for copy offloading
>for UFS devices. This work involves standardizing which SCSI copy
>offloading features should be supported and which features are not
>required. Implementations are expected to be available soon.
>

Do you have any specific blockers on the last series? I know you have
left comments in many of the patches already, but I think we are all a
bit confused on where we are ATM.

