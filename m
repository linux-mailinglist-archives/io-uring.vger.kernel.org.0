Return-Path: <io-uring+bounces-5404-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AA909EADCD
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 11:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 789F2281EAD
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 10:17:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5634B190685;
	Tue, 10 Dec 2024 10:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="iR1lnLMp"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9D423DE8D
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 10:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733825858; cv=none; b=Ujr54EM8knvJ/Zka3dpojv/Xef1o3x3gipgZx7nN+9XqsndAb04O0cEexGD1GK32SIbdcW8/C9uPjeaKyCvNYNueG8E1GI5QubbK4aw3A7zBDBhfIAOM/ljqgxMFmCcqQz0NFxpno56wlYTzGLaILbzkCyxjLyuTEpNU6GG8Cmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733825858; c=relaxed/simple;
	bh=zvA4BHDw3LfYGAlNahI+LaAncARYU6p/zWepiBNst/o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=h35TberZ0sXIzFnX0E+4SvtHZpm1Ai4wD685C2HzK6dwyVfZs8nWokE9Dkp0jxUWOQvFPm81QkrnqqyRSxQcnuwfUy6Kb0KTj/9j3JVn1zlRvo6ZSuHqfpdPj+trnvv8XqJ7jcK/kMbyBlpHEv0ZVG/Jpmc1wSEW01dtK/yesfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=iR1lnLMp; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241210101733epoutp039f1afc1fe7bda492fba18c3d7f5087e1~PyW1-Tc430205602056epoutp03E
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 10:17:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241210101733epoutp039f1afc1fe7bda492fba18c3d7f5087e1~PyW1-Tc430205602056epoutp03E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733825853;
	bh=hagd1kzu2Y9OGheeixtNt3W/s8dl8yLxLzpPJfeIvwU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iR1lnLMpYDYJx/Z9i3wSxADUJyrzCFOk/K3udY7ws8XcFfii1TEMgfRzeT2YEwa83
	 vjWq56dgdkTioaKTkfSCC57IjZi5H8WAxwO7cMxowgB18APwQe/I13McYuHQLJaFeS
	 85n2fV/NeA44/xy4nb30QDucjw1ufLGCHqLToPik=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241210101733epcas5p2647b0a49c806514de8c3de261e0d7424~PyW1hgjpi2747027470epcas5p20;
	Tue, 10 Dec 2024 10:17:33 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Y6vmr0GFKz4x9Pv; Tue, 10 Dec
	2024 10:17:32 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	09.86.19933.B3518576; Tue, 10 Dec 2024 19:17:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241210100129epcas5p20a9f10663931e6772650d37131dfcee0~PyIzkLKw30188301883epcas5p2F;
	Tue, 10 Dec 2024 10:01:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241210100128epsmtrp152a243d9c4553b9e5e900f77b4a0b973~PyIzjAwmZ2079820798epsmtrp1Q;
	Tue, 10 Dec 2024 10:01:28 +0000 (GMT)
X-AuditID: b6c32a4a-c1fda70000004ddd-00-6758153b6972
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4B.10.18729.87118576; Tue, 10 Dec 2024 19:01:28 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241210100126epsmtip197d4d20d160964c8a59a1bd49bc8a0e2~PyIxogehw3155031550epsmtip1B;
	Tue, 10 Dec 2024 10:01:26 +0000 (GMT)
Date: Tue, 10 Dec 2024 15:23:33 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Javier Gonzalez
	<javier.gonz@samsung.com>, Matthew Wilcox <willy@infradead.org>, Keith Busch
	<kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Keith Busch
	<kbusch@meta.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241210095333.7qcnuwvnowterity@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <yq1frmwl1zf.fsf@ca-mkp.ca.oracle.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNJsWRmVeSWpSXmKPExsWy7bCmpq61aES6wc4TZhbTPvxktli5+iiT
	xbvWcywWj+98Zrc4+v8tm8WkQ9cYLc5cXchisfeWtsWevSdZLOYve8pu0X19B5vF8uP/mCx+
	/5jD5sDrcfmKt8fmFVoem1Z1snlsXlLvsftmA5vHuYsVHh+f3mLx6NuyitHj8ya5AM6obJuM
	1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJuVFMoSc0qB
	QgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZh/6n
	FLzkrvh47y5TA2MLVxcjJ4eEgInE1Hm32bsYuTiEBHYzSvScf8wC4XxilJi39wQbhPONUWLP
	5x+sMC1tu5czQiT2Mkr86b7KBOE8YZTY8fkQI0gVi4CqxLX9+4ESHBxsAtoSp/9zgIRFBEwl
	Jn/aygZiMwucZJHovmYBYgsLOEv0zL3LCFLOC7Tg2uQ4kDCvgKDEyZlPWEBsTgFjidNvG8BW
	SQjs4JC4O7ubDaReQsBF4m+/CMRtwhKvjm9hh7ClJF72t0HZ5RIrp6xgg+htYZSYdX0WI0TC
	XqL1VD8zxD0ZEv37+lkg4rISU0+tY4KI80n0/n7CBBHnldgxD8ZWllizfgEbhC0pce17I5Tt
	IdF6pRMapi+YJbZPes0ygVFuFpKHZiHZB2FbSXR+aGKdBfQPs4C0xPJ/HBCmpsT6XfoLGFlX
	MUqmFhTnpqcWmxYY5aWWw+M4OT93EyM4FWt57WB8+OCD3iFGJg7GQ4wSHMxKIrwc3qHpQrwp
	iZVVqUX58UWlOanFhxhNgdEzkVlKNDkfmA3ySuINTSwNTMzMzEwsjc0MlcR5X7fOTRESSE8s
	Sc1OTS1ILYLpY+LglGpg6ug9NeF4zVGrK6ZKr741XHix4uiRovfyyjZzsqfyyXM3SEeUdz/V
	7raNqbj8xLntz7Ud7MGGe2VD4rTD5TMv956OX2OUa7lsStcusedn1R4vWMe0SeuoyIJr93KX
	eR58K2vF//5d47I/l6Vu76wpcjPc9LRsybHyHf2f2qRfrUzYe5R7TXud7u+30S/vlqf82dD5
	+yDvW2WDR6ELVJ/apm4OXDnb8odhWllOfJbcISWNnR+2H15eV5NYVdets3oJe1TT7vVHBPML
	r9u+nqTUPIM98pT8rXorV0H/fIetC9Yt3ek/43GgowBX7iLrepGHfv1v3PUv2yR959ns+j4x
	JuLcvcxJm+6/WBC/IrW+RYmlOCPRUIu5qDgRAP6aM31OBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWy7bCSnG6FYES6weJJ5hbTPvxktli5+iiT
	xbvWcywWj+98Zrc4+v8tm8WkQ9cYLc5cXchisfeWtsWevSdZLOYve8pu0X19B5vF8uP/mCx+
	/5jD5sDrcfmKt8fmFVoem1Z1snlsXlLvsftmA5vHuYsVHh+f3mLx6NuyitHj8ya5AM4oLpuU
	1JzMstQifbsErozfbz+zFczmrNjwcAJLA+MF9i5GTg4JAROJtt3LGbsYuTiEBHYzSkzaNB0q
	ISmx7O8RZghbWGLlv+fsEEWPGCV6F8xiAkmwCKhKXNu/H8jm4GAT0JY4/Z8DJCwiYCox+dNW
	NpB6ZoGzLBLvvj4AqxcWcJbomXuXEaSeF2jztclxEDNfMEvsXNjPCFLDKyAocXLmExYQm1nA
	TGLe5ofMIPXMAtISy/+BzecUMJY4/baBaQKjwCwkHbOQdMxC6FjAyLyKUTK1oDg3PbfYsMAw
	L7Vcrzgxt7g0L10vOT93EyM4irQ0dzBuX/VB7xAjEwfjIUYJDmYlEV4O79B0Id6UxMqq1KL8
	+KLSnNTiQ4zSHCxK4rziL3pThATSE0tSs1NTC1KLYLJMHJxSDUxqip1NZuuvnAm2nlCRO1la
	IZN/uhUv995jLH9cD2WtWmryVFjRlrn866orEnm3tkUHx83OKkpc+8x/thGj9hPdnPU33ZZP
	u5+/uLTpapSgbUjuy6rVzEreWvui1u96e8xu7o3yBocyhRdKCyWf1anHbjqQuy/eyOfV8nxn
	OY9Z7c+rZkX8OzOLM3PeJWte9ynn7l+p19556b7ZGpX5HpMO/t2ZcvN+a8oB8eLtZ3MbuCcc
	zJjzKphz5a/MQ5kN3p3qfWbX5vUrpCRPi/QQ1K+fu3Th7lOJDmnvN660fvDRVjt57uK5nI+m
	vXp3YkfWsS1/BFbnnru8xunILo6txv4rdfcxPOQ1ValndhH3WWepxFKckWioxVxUnAgAR6T/
	BxEDAAA=
X-CMS-MailID: 20241210100129epcas5p20a9f10663931e6772650d37131dfcee0
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_721d0_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1
References: <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
	<9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
	<yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
	<8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
	<yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
	<CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>
	<20241205080342.7gccjmyqydt2hb7z@ubuntu>
	<yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com>
	<d9cc57b5-d998-4896-b5ec-efa5fa06d5a5@acm.org>
	<yq1frmwl1zf.fsf@ca-mkp.ca.oracle.com>

------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_721d0_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 09/12/24 09:20PM, Martin K. Petersen wrote:
>
>Bart,
>
>> Does "cookie" refer to the SCSI ROD token? Storing the ROD token in
>> the REQ_OP_COPY_DST bio implies that the REQ_OP_COPY_DST bio is only
>> submitted after the REQ_OP_COPY_SRC bio has completed.
>
>Obviously. You can't issue a WRITE USING TOKEN until you have the token.
>
>> NVMe users may prefer that REQ_OP_COPY_SRC and REQ_OP_COPY_DST bios
>> are submitted simultaneously.
>
>What would be the benefit of submitting these operations concurrently?
>As I have explained, it adds substantial complexity and object lifetime
>issues throughout the stack. To what end?
>
>-- 
Bart,
We did implement payload based approach in the past[1] which aligns
with this. Since we wait till the REQ_OP_COPY_SRC completes, there won't
be issue with async type of dm IOs.
Since this would be an internal kernel plumbing, we can optimize/change
the approach moving forward.
If you are okay with the approach, I can give a respin to that version.

Thanks,
Nitesh Shetty

[1]
https://lore.kernel.org/linux-block/20230605121732.28468-1-nj.shetty@samsung.com/T/#mecd04c060cd4285a4b036ca79cc58713308771fe

------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_721d0_
Content-Type: text/plain; charset="utf-8"


------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_721d0_--

