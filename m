Return-Path: <io-uring+bounces-2509-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67080930CE7
	for <lists+io-uring@lfdr.de>; Mon, 15 Jul 2024 05:03:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10517281370
	for <lists+io-uring@lfdr.de>; Mon, 15 Jul 2024 03:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9104C79F0;
	Mon, 15 Jul 2024 03:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="t8Al8rEU"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D44A95E
	for <io-uring@vger.kernel.org>; Mon, 15 Jul 2024 03:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721012617; cv=none; b=d78retANuGih0T0HVxQZI9F8S8s4V3fFNgs8n5KAQcT+aRMJbYN9Ww/5LtDy+Yo6megvrweoivF7/a52qNj/fX/UsMHbSTgoWE8E9I6bThO4yE3fGeZ0aQt8/ZiGohn642UVAPiaO/pJCejalmO6llUI2IMP/Wj7UUj7RkO8kq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721012617; c=relaxed/simple;
	bh=cNPLygRRwTIu66cd/nVFWcNAuVbNA5tBwUY2iWU9j7w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=gD1LSN/6vMgtoWP5en83eF+k7OZ+b6T1/dzIi2uSf86m8V0gnelVjnLNxHL7C5tFCcZlQkqCmJfvgdUDyl6XD8TU9tMSaPskofvjatxbH+3fwPw34Bgl4gsKTjUZIyQSN+em0Rbq4kg2viqWIxyN1EYNqCvVFQLWw1sOUH+Y4zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=t8Al8rEU; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240715030326epoutp01e7627b801c6df08b59d3482213b9a8d0~iQ9jqsWGB3191231912epoutp01W
	for <io-uring@vger.kernel.org>; Mon, 15 Jul 2024 03:03:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240715030326epoutp01e7627b801c6df08b59d3482213b9a8d0~iQ9jqsWGB3191231912epoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1721012606;
	bh=cNPLygRRwTIu66cd/nVFWcNAuVbNA5tBwUY2iWU9j7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8Al8rEUOKzHb/DfRQA9di8sx0A7QOTqx+7eaMQbg5QcesHHhwXcmk3qzmtRNrXts
	 gNEJCAKsXXqhlpoO8+RU3w9tyM7RumgMLT7hCpT0xHeI1UwFOQ7UHEeiMk2keRs8kF
	 l5YEhiA5v1ZFQIXs0XAS/WByALrg12mNbqHcQ0K4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240715030326epcas5p3b2cd769c2922a05bc94ecb95e97330cd~iQ9jaqWIa0512305123epcas5p3P;
	Mon, 15 Jul 2024 03:03:26 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WMn8D57qKz4x9Pt; Mon, 15 Jul
	2024 03:03:24 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	05.E1.07307.67194966; Mon, 15 Jul 2024 12:03:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240715023908epcas5p1e16b2ac82c7f61edf44bfd874c920f04~iQoVnRHJ62003220032epcas5p1d;
	Mon, 15 Jul 2024 02:39:08 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240715023908epsmtrp2e9a0f21ebec19b8850d1b801685c4bae~iQoVmYJj21973619736epsmtrp25;
	Mon, 15 Jul 2024 02:39:08 +0000 (GMT)
X-AuditID: b6c32a44-18dff70000011c8b-36-6694917692c7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	77.7C.19057.CCB84966; Mon, 15 Jul 2024 11:39:08 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240715023907epsmtip2f6218aa8eecc031fb29114da76ad582c~iQoUlIdhE0963209632epsmtip2h;
	Mon, 15 Jul 2024 02:39:07 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, hch@infradead.org, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v2] io_uring: Avoid polling configuration errors
Date: Mon, 15 Jul 2024 10:39:02 +0800
Message-Id: <20240715023902.1105124-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <db1816bc-c3f4-41c0-8946-f8d4a260216a@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42LZdlhTXbds4pQ0gwVPZC3mrNrGaLH6bj+b
	xekJi5gs3rWeY7H41X2X0eLyrjlsFmcnfGB1YPfYOesuu8fmFVoel8+WevRtWcXo8XmTXABr
	VLZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtARSgpl
	iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTs
	jLfTPjIV3GKt+HjpLVMD416WLkZODgkBE4mJ008ydzFycQgJ7GaU2HnkLRuE84lRYsmJGUwQ
	zjdGiYXvbrHCtPSdfgSV2MsocWbZVnYI5wejxKEXc9lAqtgElCT2b/nACGKLCAhL7O9oBVrI
	wcEskC7R9sILJCws4CEx4d1qsDtYBFQltq9ZxAxi8wpYS5xresMEsUxe4mbXfrA4p4CtxPpD
	TWwQNYISJ2c+AetlBqpp3job7AcJgXvsEu/bDjBCNLtIzGm7xwZhC0u8Or6FHcKWkvj8bi9U
	PF9i8vf1UPU1Eus2v4MGjLXEvyt7oG7WlFi/Sx8iLCsx9dQ6Joi9fBK9v59A3ckrsWMejK0k
	seTICqiREhK/JyyCBpyHxP3js1kgYTWBUWLOq40sExgVZiH5ZxaSf2YhrF7AyLyKUTK1oDg3
	PTXZtMAwL7UcHsvJ+bmbGMEJU8tlB+ON+f/0DjEycTAeYpTgYFYS4V3JMjFNiDclsbIqtSg/
	vqg0J7X4EKMpMMAnMkuJJucDU3ZeSbyhiaWBiZmZmYmlsZmhkjjv69a5KUIC6YklqdmpqQWp
	RTB9TBycUg1MwbtWcU89+WFZ49XQX0aTrW5dNTjgGHGsmPnZllOfVmp1S71z+++x/tM/95Ob
	wqcfEKoxEtMPjpDZVx60f7fpHRmu/gO/PztlH+4VDjp365PTLXmxd4UzHFSrflfwGudKF/Xk
	fTYWse2/6PizQ+b+pcoEH/4W96u5qs+lld7tnbKx60tESlR45K2lz2cbafwJ8/5xrOZtpcX/
	6vz6FaXdF41j4n708W7d0JUmL1xkVjNdWHzqEjHBY3V2FnseFr0zyc6etc++V0vZ8fjshZ8T
	Yr7VXdfacv7MSYu5C33eG/l37RGvWPTlqfDyXVzWSc/PvRf8FVwlfG7T68/qyy5lmZvblmS3
	8xjdd+Zy7rZQYinOSDTUYi4qTgQA3d6YtSEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsWy7bCSvO6Z7ilpBi8W8VvMWbWN0WL13X42
	i9MTFjFZvGs9x2Lxq/suo8XlXXPYLM5O+MDqwO6xc9Zddo/NK7Q8Lp8t9ejbsorR4/MmuQDW
	KC6blNSczLLUIn27BK6Mt9M+MhXcYq34eOktUwPjXpYuRk4OCQETib7Tj5i6GLk4hAR2M0oc
	mruGESIhIbHj0R9WCFtYYuW/5+wQRd8YJVb9vAqWYBNQkti/5QNYgwhQ0f6OVrCpzALZEntn
	XQOrERbwkJjwbjVYnEVAVWL7mkXMIDavgLXEuaY3TBAL5CVudu0Hi3MK2EqsP9TE1sXIAbTM
	RmLRAgGIckGJkzOfQI2Xl2jeOpt5AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOWllusVJ+YW
	l+al6yXn525iBAe0ltYOxj2rPugdYmTiYDzEKMHBrCTCu5JlYpoQb0piZVVqUX58UWlOavEh
	RmkOFiVx3m+ve1OEBNITS1KzU1MLUotgskwcnFINTJJbpDwCj+zcbn847fqVz6+en/jaLbew
	pmVRubdXi47Uqc49Mk8Mivl+ivvL9Jy3OFvMu2Ky21nGVes8dnQlCxc5JSy/9OC5XuROMZHP
	ExzLnV+W2BtX7/F4/jnCW6lFRaaoNKnr5ScjJ/X44nvXV+6webXTdltrnE/eKfak8AlmzEoX
	F3rkC1Vz3FdZqyykVJR7zOvRlIerj7Q09wf/CyzZqcY18/a82L2KU1z3TCtiPZVv/V/OwtU2
	yI+H/0gyT9tU/S/33d9J1//3E97zMPzq1n9fuZJX5edp7jqR9fOtmNDC7GnBq/33b2XvmLH4
	w1PVvJfJWs/vFKZHVLz+kMl6vUfa1PabWH7TI113JZbijERDLeai4kQA1U54GdcCAAA=
X-CMS-MailID: 20240715023908epcas5p1e16b2ac82c7f61edf44bfd874c920f04
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240715023908epcas5p1e16b2ac82c7f61edf44bfd874c920f04
References: <db1816bc-c3f4-41c0-8946-f8d4a260216a@kernel.dk>
	<CGME20240715023908epcas5p1e16b2ac82c7f61edf44bfd874c920f04@epcas5p1.samsung.com>

>My stance is still the same - why add all of this junk just to detect a
>misuse of polled IO? It doesn't make sense to me, it's the very
>definition of "doctor it hurts when I do this" - don't do it.

>So unless this has _zero_ overhead or extra code, which obviously isn't
>possible, or extraordinary arguments exists for why this should be
>added, I don't see this going anywhere.

Actually, I just want users to know why they got wrong data, just a warning of an error,
like doctor tell you why you do this will hurt. I think it's helpful for users to use tools
accurately.
and yes, this should be as simple as possible, I'll working on it. I'm not sure if I made
myself clear and make sense to you?

--
hexue

