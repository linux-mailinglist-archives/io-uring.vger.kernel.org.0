Return-Path: <io-uring+bounces-3406-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A263D98FD3E
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 08:21:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD0B31C21F24
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 06:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C4877581F;
	Fri,  4 Oct 2024 06:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Cwln0NeA"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A866F305
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 06:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728022896; cv=none; b=hdVVPaVuPTep6otQ8MNIuZil89NQxBrZKyQVeloY7qhO2+rutR5cU8XUWDYpAIdBZaXhCpx9gtTNC4cK+QLafKjHBYI+u4oaNuAqGuzo7n3udxORukyqkyICKBX/Wfjhyljf9aIYjmvVVGJ851GgWTPn/5ERDn0/NKP95PmHADE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728022896; c=relaxed/simple;
	bh=z5Jg3KoffXeo85mccSZSvB9eEQbAaHl8F2zos0V76uw=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=h2btSQwyWuqViLwXf8Hm3Wee+7byL/DyiqAcJ+by+M3WhLmDpdWRVKiOPMDZmB4CalHECZnUheBGxMc8LaCfgtAOT0NLU0P1ImjwbQn6fbZzh9NMwyb2Dn53fuCNsbTuKJ+gqMeeZR8AsNBeFoxTsO3Zs0v3meNlkVOLV3DhRYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Cwln0NeA; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20241004062133euoutp02b1a60c58d8e5537f0a1d9b5f01973cf5~7K6py3uh92878228782euoutp02u
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 06:21:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20241004062133euoutp02b1a60c58d8e5537f0a1d9b5f01973cf5~7K6py3uh92878228782euoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728022893;
	bh=F9Gv2ForhV6hTrvVmLhgEigzeBV339w4jLSMQBIETrk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Cwln0NeAKRONWcjeVFsGuWT6Lnpliv6ZhlzAKIrg3xPLii+qtbp1YzfOa52Hm3JQ4
	 JFANKF5hB7iCa+BTCY/Ryi0+U82jZh5ZkJHwAXvhggASqB8fYF9oP8DZ0oDAuTEX8V
	 SrgsToiMjfSLucTMPyQeoxNsD/MvKoHauvjbqGPA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20241004062132eucas1p26097cf9947f923223405394528ad8773~7K6peLcOZ2042120421eucas1p2B;
	Fri,  4 Oct 2024 06:21:32 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 99.DF.09875.C698FF66; Fri,  4
	Oct 2024 07:21:32 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20241004062131eucas1p2ee4e9ef12627dd234ff9812807c9e04d~7K6oqc2S62042120421eucas1p2-;
	Fri,  4 Oct 2024 06:21:31 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241004062131eusmtrp203580cb9fe83d3cd8e4aaf08dd6091b6~7K6oprF391557815578eusmtrp2O;
	Fri,  4 Oct 2024 06:21:31 +0000 (GMT)
X-AuditID: cbfec7f4-11bff70000002693-bf-66ff896c6a94
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 25.51.19096.B698FF66; Fri,  4
	Oct 2024 07:21:31 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241004062131eusmtip1c6cdc7643a8ac562e3f26ac833a4af04~7K6oYk-911305713057eusmtip1k;
	Fri,  4 Oct 2024 06:21:31 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Fri, 4 Oct 2024 07:21:30 +0100
Date: Fri, 4 Oct 2024 08:21:29 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To: Christoph Hellwig <hch@lst.de>
CC: Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>, Jens Axboe
	<axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>, <hare@suse.de>,
	<sagi@grimberg.me>, <brauner@kernel.org>, <viro@zeniv.linux.org.uk>,
	<jack@suse.cz>, <jaegeuk@kernel.org>, <bcrl@kvack.org>,
	<dhowells@redhat.com>, <asml.silence@gmail.com>,
	<linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<io-uring@vger.kernel.org>, <linux-block@vger.kernel.org>,
	<linux-aio@kvack.org>, <gost.dev@samsung.com>, <vishak.g@samsung.com>
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241004062129.z4n6xi4i2ck4nuqh@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
In-Reply-To: <20241003125516.GC17031@lst.de>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7djP87o5nf/TDK5+ULaYs2obo8Xqu/1s
	Fl3/trBYvD78idFi2oefzBbvmn6zWOxZNInJYuXqo0wW71rPsVjMnt7MZPFk/Sxmi0mHrjFa
	TJnWxGix95a2xZ69J1ks5i97ym6x/Pg/Jot1r9+zWJz/e5zVQdjj8hVvj52z7rJ7nL+3kcXj
	8tlSj02rOtk8Nn2axO6xeUm9x+6bDWweH5/eYvF4v+8qm8eZBUeA4qerPT5vkvPY9OQtUwBf
	FJdNSmpOZllqkb5dAlfGnhdTWAtmclRMPNzD3MB4ia2LkZNDQsBE4sbSJUA2F4eQwApGifbf
	f5kgnC+MEh2bvrJDOJ8ZJVpXHmOBadn7aSFUYjmjxL/lh5jgquauPssC4WxmlHj/8RszSAuL
	gIrEgZsvmEBsNgF7iUvLboHFRQSUJJ6+OssI0sAscIlF4tbFM2BnCQsYSLz/3gtm8wrYSiz/
	sZcJwhaUODnzCdgdzAJWEp0fmli7GDmAbGmJ5f84QMKcAjoSZ17sZoY4VUni8Yu3jBB2rcSp
	LbfALpUQ+Mcp0XhjCyNIr4SAi0TfB0GIGmGJV8e3sEPYMhL/d85ngrCrJRpOnoDqbQGGRcdW
	Vohea4m+MzkQNY4SB1/9ZoYI80nceCsIcSWfxKRt06HCvBIdbUIQ1WoSq++9YZnAqDwLyV+z
	kPw1C+GvBYzMqxjFU0uLc9NTi43yUsv1ihNzi0vz0vWS83M3MQKT5ul/x7/sYFz+6qPeIUYm
	DsZDjBIczEoivPO2/00T4k1JrKxKLcqPLyrNSS0+xCjNwaIkzquaIp8qJJCeWJKanZpakFoE
	k2Xi4JRqYBL/dPW53rGZsyXa5jWkZasnPTRPvdN4T2HR/Blpm5/NtfWX4F7FrrqqI1NULnYe
	16rY67uWnfsbsyCn7qzPbOnkaSU7dp1SfN9/2WhK8KJz5XMWdu3N11tjazV/l3rRsncXQxVY
	9lzqs7nc4v+PhT9Jc0Iol7fZyqKL8woizivmSPXMDgu5xb9k1/MvzhGBi3WWbf7zg+XQoj1a
	L608AySV/srm+j+I+GVQLtvJqNvseVrlpA9v/5V9L62aVklOTa55oLpcLeCyzOqzhzwSNQ/o
	XFW4PUFWjeG/kSTTNSbbxSsPHJ9c/oWx8u2Ov16zVZ6Ef7wnskU7pV7l5zynnbt85dxeS2Rq
	Wp0VbXmydq0SS3FGoqEWc1FxIgAn1AT+CQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t/xu7rZnf/TDG616VnMWbWN0WL13X42
	i65/W1gsXh/+xGgx7cNPZot3Tb9ZLPYsmsRksXL1USaLd63nWCxmT29msniyfhazxaRD1xgt
	pkxrYrTYe0vbYs/ekywW85c9ZbdYfvwfk8W61+9ZLM7/Pc7qIOxx+Yq3x85Zd9k9zt/byOJx
	+Wypx6ZVnWwemz5NYvfYvKTeY/fNBjaPj09vsXi833eVzePMgiNA8dPVHp83yXlsevKWKYAv
	Ss+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384mJTUnsyy1SN8uQS9jz4sp
	rAUzOSomHu5hbmC8xNbFyMkhIWAisffTQvYuRi4OIYGljBI3rhxmhUjISGz8chXKFpb4c62L
	DaLoI6NEw/2LUM5mRoltm1YwglSxCKhIHLj5ggnEZhOwl7i07BYziC0ioCTx9NVZRpAGZoFL
	LBK3Lp4B2y0sYCDx/nsvmM0rYCux/MdeJoipt5gl1v7YwQSREJQ4OfMJC4jNLGAhMXP+eaBJ
	HEC2tMTyfxwgYU4BHYkzL3YzQ5yqJPH4xVtGCLtW4vPfZ4wTGIVnIZk0C8mkWQiTFjAyr2IU
	SS0tzk3PLTbSK07MLS7NS9dLzs/dxAhMH9uO/dyyg3Hlq496hxiZOBgPMUpwMCuJ8M7b/jdN
	iDclsbIqtSg/vqg0J7X4EKMpMCwmMkuJJucDE1heSbyhmYGpoYmZpYGppZmxkjgv25XzaUIC
	6YklqdmpqQWpRTB9TBycUg1MXV/zBPy2RW1x+L7DTazUY0lt1qErW0Um2zuzf/n3xmbVtKd9
	Nns1kx1qDrMeDPhz4crCqZ1rLl084n8iV6x/WZfS/wWW9hqqoRK3jzzrfPLYleFfgMrcJWVp
	9S9Cz/7YempqmOWnheVWX2dU+QbFMJirfGawnbuwz3z9tbnnvhc9v275wLbnoJFe2++zMjmH
	bkjfX77Iw+8K0+9Fj3LU907p/e9rtC47XOtM8ZeVU3UPqN6NrV1t0DDzxX0GHY5fqws61wjo
	8Sw6cO0In9OTjG/bNjJM/jpRcP+RU6suF8SWW8Scu+DDsTLq1rQKuyr2jy6bFCc6XeCUN5/5
	LXLpkaKAxXohFaIzFCsWmE1+/E2JpTgj0VCLuag4EQBtph7sqAMAAA==
X-CMS-MailID: 20241004062131eucas1p2ee4e9ef12627dd234ff9812807c9e04d
X-Msg-Generator: CA
X-RootMTR: 20241003125523eucas1p272ad9afc8decfd941104a5c137662307
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241003125523eucas1p272ad9afc8decfd941104a5c137662307
References: <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk>
	<20241002075140.GB20819@lst.de>
	<f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
	<20241002151344.GA20364@lst.de>
	<Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
	<20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com>
	<a8b6c57f-88fa-4af0-8a1a-d6a2f2ca8493@acm.org>
	<CGME20241003125523eucas1p272ad9afc8decfd941104a5c137662307@eucas1p2.samsung.com>
	<20241003125516.GC17031@lst.de>

On 03.10.2024 14:55, Christoph Hellwig wrote:
>On Wed, Oct 02, 2024 at 11:34:47AM -0700, Bart Van Assche wrote:
>> Isn't FDP about communicating much more than only this information to
>> the block device, e.g. information about reclaim units? Although I'm
>> personally not interested in FDP, my colleagues were involved in the
>> standardization of FDP.
>
>Yes, it is.  And when I explained how to properly export this kind of
>information can be implemented on top of the version Kanchan sent everyone
>suddenly stopped diskussion technical points and went either silent or
>all political.
>
>So I think some peoples bonuses depend on not understanding the problem
>I fear :(
>

Please, don't.

Childish comments like this delegitimize the work that a lot of people
are doing in Linux.

We all operate under the assumption that folks here know how to wear two
hants, and that there is no such thing as so specific incentives
neither to push _nor_ block upstream contributions without a use-case
and technical background.

