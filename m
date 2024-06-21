Return-Path: <io-uring+bounces-2317-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CFC97912101
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 11:43:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79CBC1F24CF9
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 09:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB5A16EB6D;
	Fri, 21 Jun 2024 09:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Hi1xGEdL"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9A0171090;
	Fri, 21 Jun 2024 09:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718962876; cv=none; b=Q36MzsPym08wVW4AJmQM4XLRzgoT/qwPNAO5mgezk5bggFruQy424tf7KfLFNc2JaorlBNRuxCCwurT7TUhOOrX98MGJOcFAtvkYh9JIKHO3XqxIK+hsFGCaiQ8gsG5GqOiZWQtyQ5Vemc+xfonzuPSMwXS6kjr8rMVX8Rd5QDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718962876; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=GJZyPXP+mJvAU/Azq/gBGWuF6tQ6+2S/YUZggZ4iFgbP5pqxvWrMzzsCSgBviTNRgcc9ltk7zAuiyXvif/qVIE4Fo6da0bLH2YfeSx0BMo8KFDWzV2ZKBvHI+znp33WntXPzcz2ehCxDw+67tkkIzzR4iuiTIMCndxYPOinVx7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Hi1xGEdL; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240621094108epoutp0325cfbb776d11c0e35e466c6c0f697fb4~a_58Nze_k0655806558epoutp03N;
	Fri, 21 Jun 2024 09:41:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240621094108epoutp0325cfbb776d11c0e35e466c6c0f697fb4~a_58Nze_k0655806558epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718962868;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Hi1xGEdLErucvZk7wLOBpKEOXg5XqGNySmSuWathHUdUHo/L2AO+KFV9URqs6PT9M
	 0Usqfx9nPNkQUtWU/heH5soJHIhYd0LYB6r2wXbTGsWKRBqGv94y/RdAQuUum+D/fm
	 BYq443nAZCd9uONBL5YiEA0t53HHqBNMC4Akqhi8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240621094107epcas5p2b0a17ad3fe44e89812089c806bf1b171~a_57ya0tm2777127771epcas5p2B;
	Fri, 21 Jun 2024 09:41:07 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4W5C6B2dY7z4x9Q5; Fri, 21 Jun
	2024 09:41:06 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4F.2A.07307.2BA45766; Fri, 21 Jun 2024 18:41:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240621094105epcas5p153dd810baaee7e4e13e64b546776433b~a_559q-Gk0829508295epcas5p1C;
	Fri, 21 Jun 2024 09:41:05 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240621094105epsmtrp28ca64e30e9bc1b4849bbaa9e039a9a76~a_558V0KW3266732667epsmtrp2e;
	Fri, 21 Jun 2024 09:41:05 +0000 (GMT)
X-AuditID: b6c32a44-3f1fa70000011c8b-27-66754ab244a7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7E.82.07412.1BA45766; Fri, 21 Jun 2024 18:41:05 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240621094101epsmtip219c6921e5efe00eca97c744e48a99b6c~a_512C05B0531105311epsmtip2V;
	Fri, 21 Jun 2024 09:41:01 +0000 (GMT)
Message-ID: <23df0031-a724-abbc-5496-a0d17b333124@samsung.com>
Date: Fri, 21 Jun 2024 15:11:00 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [Patch v9 07/10] block: Add fops atomic write support
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk,
	kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
	dchinner@redhat.com, jack@suse.cz
Cc: djwong@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
	linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	hare@suse.de
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20240620125359.2684798-8-john.g.garry@oracle.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ta1BTVxDHe24uNyEz0EuA4fCohrRFhAkklMeJAlZF51rsDB1rP7SdoZFc
	CSWENCEV+lAEsRAskqCiAYTBJ9CRMVAaUVoEEaEiCCIUCwiFqmF4VjvybAMXW779ds/+5392
	d5bD4t1ku3HilEm0WilVCAguXtO40Vtoek+7X/S8zQ5Vtt5moYr+4wQaa5wBqM1SxEZdI/ao
	pLQIRzdKDRgqq2jC0ETGPRwV5KdjqOWXSQKV9tZgqGPODJCh4SFAJ06lAVTX54s6/7jMRjfq
	WnDUVVtIoOKLo2yU3WMm0KXmJQzpM7sxVK2fwtC5sr3oZmsmG10Zm8TRnT53lHFslo3aF5tt
	0PzLQuLd9dQ1Yz+bKjFpqfaBqzhVddmH6mrTUqbyLIIyzRjYVG5pPaCqzh+inladAdT131IJ
	Ku1uE4uaHu3DqcmfuwnqbsktNlX169dRvI/jQ+W0VEar+bQyJlEWp4wNE0Tuid4eHRQsEgvF
	EhQi4CulCXSYIGJ3lHBnnMI6LQH/S6lCa01FSTUagX94qDpRm0Tz5YmapDABrZIpVIEqP400
	QaNVxvop6aRNYpEoIMha+Fm8vNV8AVMFJD8sysFSgVAHbDmQDIQZj5qADnA5PPI6gLePLGBM
	MANgmeH5avA3gM8eGLFXkun7jQTzUAegpeMsiwnGATyc3bVSZUeGw3NF0/gy4+TbcDT3CWDy
	DrDlzMhK3pmMgbO6emKZHcltMPVqhc0ys0gX2DdSvGLtRE4B2JnzDF8OWOQQC57o1VurOByC
	3Ag78rTLAltyCyydbAeMeD38abyQxXw1jQvzBhwYjoBTt46utuAILc3VbIbd4F8TdQTD8fDx
	8GOc4W+guSrHhuEtMHWhd8WWZbWtrPVnrOzh9/Mj2HIaknYw8yiPqfaEA4bRVaULHDp9fpUp
	uNBuWZ1oM4AT83kgF/CNa8ZiXNO+cU03xv+dSwBeDlxplSYhlo4JUomV9IH/9h2TmGACK7fk
	E2EGvcVLfg0A44AGADksgZPdE516P89OJk35ilYnRqu1ClrTAIKs+9Gz3JxjEq3HqEyKFgdK
	RIHBwcGBkneCxQIXu7GMIhmPjJUm0fE0raLVr3QYx9YtFdNTCscssyHN5s3S+e8WhZ39Rwzk
	gcWAY/ULstNlBePsmsPVEaIO+NFgmTzkxxy+ZZbLNb1RM/XSbcz+msRLzDkb3jAXER6yY2H3
	EK9AHmks35SlPhhe+8H7r+ddmtn7iWUP++n4592eSzWzBbxt3OS3pOv8do4lH7LHvWR6erHy
	20+Ha0/57hrGsoUzilDRyXx1bdNgcv0LZ+0d5aIDZjR/uI9j849c53Uh6p5ue/Rxb4n7/R7/
	SM+5+V0CQ/+6zTu2pmeMe3d77Gtb0Dy4KPGQ+1xx+jN/Mjhq86N+19e4Kc4/jPg1Nflt8Bic
	2jAw5/p7+tZt7ilflLn76nknXxz06dEKcI1cKvZhqTXSfwHABxUF1AQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWy7bCSvO5Gr9I0gyMbDCzWnzrGbLH6bj+b
	xevDnxgtzr6ay25x+QmfxYJFc1ks9iyaxGSxcvVRJot3redYLGZPb2ayOLn/PZvFohvbmCwu
	/NrBaDHp0DVGiynTmhgt9t7Strj0eAW7xZ69J1ksLu+aw2Yxf9lTdovu6zvYLJYf/8dkMbHj
	KpPFlokfmCwWrwy1OHiqg91i3ev3LBYnbklbtPb8ZLc4//c4q8XvH3PYHOQ9ds66y+6xYFOp
	x/l7G1k8Nq/Q8rh8ttRj06pONo9Nnyaxe0xYdIDRY/OSeo8Xm2cyeuy+2cDm0XTmKLPHx6e3
	WDze77vK5nFmwRF2j82nqwOEorhsUlJzMstSi/TtErgyTu1YylRgVHFtbh9TA6NuFyMnh4SA
	icTHi4fZuhi5OIQEdjNKtF/4yAiREJdovvaDHcIWllj57zk7RNFrRonTL2eBFfEK2EksnvuR
	BcRmEVCVeDrhOVRcUOLkzCdgcVGBZImXfyaCDRIWcJJo2LiaFcRmBlpw68l8JpChIgIfGCXe
	bFzDAuIwCzxklrj44zULxLrjjBI9rauADuTgYBPQlLgwuRSkm1PAXmLR+/OMEJPMJLq2dkHZ
	8hLb385hnsAoNAvJIbOQLJyFpGUWkpYFjCyrGCVTC4pz03OTDQsM81LL9YoTc4tL89L1kvNz
	NzGCk5CWxg7Ge/P/6R1iZOJgPMQowcGsJML7vKsoTYg3JbGyKrUoP76oNCe1+BCjNAeLkjiv
	4YzZKUIC6YklqdmpqQWpRTBZJg5OqQYmn1mM3heL658tCOryXzlB6VHmZW7zVqdGzkVpNw8r
	z1G368gJPvPNONfZvpCd+0/o0s++CYciBNrDZ5ws3MQWsDHu4cT+TZud3C4ZZ4clzJIp2exc
	fcefcbedfAAL3+Z/65nfc0sVLjpxfPaSkw/7PoS/l71a+42nkI0/iu9H2MGD1TpMlxfJfPu4
	5/BhB72+RW5Xji19Ito08Y7Cjt7D9/Q6H1xslknX47sTfqSRMWfht1n8LHMiat+2bC8S+iUj
	HFx8ZZ3DL67ssvndh6U6NDcmC3/1ZK9lZNax/27H/22q8e09x887fWFybLr35E7+x9TIZR88
	z5yyKrL51h/bLXi1kbf34ve3Gldn/YxTYinOSDTUYi4qTgQA9Ot10bEDAAA=
X-CMS-MailID: 20240621094105epcas5p153dd810baaee7e4e13e64b546776433b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240620125745epcas5p441e0a77a41d426788a64d9c668f9db17
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
	<CGME20240620125745epcas5p441e0a77a41d426788a64d9c668f9db17@epcas5p4.samsung.com>
	<20240620125359.2684798-8-john.g.garry@oracle.com>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

