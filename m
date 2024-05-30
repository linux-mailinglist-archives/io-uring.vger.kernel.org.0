Return-Path: <io-uring+bounces-1995-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B43418D44B0
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 07:11:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D2CF1F23288
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 05:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD807143724;
	Thu, 30 May 2024 05:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XN3n1Z1R"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBEF2BD0F
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 05:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717045873; cv=none; b=QGDCdC35keqWMiDp8uCiK18LS+SS3+kpLq+FWwEHii9STvFJtfn+XmZIVKWLsfzeGlyH8OqFn86ZoLu0jzQkzaRb6iPtTgPmH59LgtykNBQnVS+xc231jQvSrYw6iMtLR4azkZW80nM3MSi7t44nlc3+1umsrVm+6e12q0uS1nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717045873; c=relaxed/simple;
	bh=04He1RiDClnhT2DSYpfr+/xcA2eNo8S/gOCr0L15+cY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=kNUI4+OJxtExoXXE4hkKFfYVDP+88aPuhTnFbJECKYtM8QK3Tsgh6SRiDpnZ2Q2ZpaitsLg82bW/kIZx8B/1YoWaRl4oktZM5nqlObVPxHOjFgGLnOXDpC7WGiQdwH3407uRlzkvklsJCvg4e/O/NFvQfP90GBb4kAXHU9PwwbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XN3n1Z1R; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240530051102epoutp0353b157831553bd274a0d9339eae7fb42~ULB1vm-oO1727417274epoutp03R
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 05:11:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240530051102epoutp0353b157831553bd274a0d9339eae7fb42~ULB1vm-oO1727417274epoutp03R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717045862;
	bh=04He1RiDClnhT2DSYpfr+/xcA2eNo8S/gOCr0L15+cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XN3n1Z1RATeNlyAeBP52zpeGmqooxd1gueDBqHNseZg9BKrpYmCq6Y0VgiXvy/1ji
	 lxE+4hNPVD71PS3I9DqrofN5urIGVwnO92xtHGJsSQ/Vzvmum7WErjOepTR69BRa3L
	 ogFNtFE4VPysJnu8t1pfGHxhqKNlSqndr+McSqmo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240530051102epcas5p4f4799a43842bf56c594a25dde4a52df8~ULB1XVxeO0326003260epcas5p4Y;
	Thu, 30 May 2024 05:11:02 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VqZ8g6WpGz4x9QF; Thu, 30 May
	2024 05:10:59 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E4.EB.10035.26A08566; Thu, 30 May 2024 14:10:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240530051050epcas5p122f30aebcf99e27a8d02cc1318dbafc8~ULBqhpcJT1417714177epcas5p1d;
	Thu, 30 May 2024 05:10:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240530051050epsmtrp249d183a13b0024b5b60f3c5d70544c35~ULBqgyTWV2166321663epsmtrp2i;
	Thu, 30 May 2024 05:10:50 +0000 (GMT)
X-AuditID: b6c32a4b-b11fa70000002733-35-66580a627c8d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	92.3F.08336.A5A08566; Thu, 30 May 2024 14:10:50 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240530051049epsmtip10e2876bfa6098a722a5f061e9fbcca62~ULBpFtruB1982719827epsmtip1f;
	Thu, 30 May 2024 05:10:49 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk
Cc: anuj1072538@gmail.com, anuj20.g@samsung.com, asml.silence@gmail.com,
	cliang01.li@samsung.com, gost.dev@samsung.com, io-uring@vger.kernel.org,
	joshi.k@samsung.com, kundan.kumar@samsung.com, peiwei.li@samsung.com
Subject: Re: [PATCH v4 0/4] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
Date: Thu, 30 May 2024 13:10:44 +0800
Message-Id: <20240530051044.1405410-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <c99eb326-0b36-4587-b8a2-8956852309be@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKJsWRmVeSWpSXmKPExsWy7bCmlm4SV0SawbmXphYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1mc/vuYxeLmgZ1MFu9az7FYHP3/ls1i65evrBbP9nI6cHnsnHWX3ePy2VKP
	vi2rGD0+b5ILYInKtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLx
	CdB1y8wBOkdJoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5da
	YmVoYGBkClSYkJ1x+Yt1QTdLxbnDk1kbGDcydzFyckgImEgs2PyACcQWEtjNKPGi2wbC/sQo
	seejbxcjF5D9jVHiTtNDli5GDrCG3v1KEPG9jBL/Dz5ihnB+MUp8e3gLbBKbgI7E7xW/WEBs
	EQFhif0drSwgRcwCtxglTlz5A1YkLBApsXhBFyOIzSKgKrFt5RVWEJtXwE6ir3Ue1HnyEvsP
	ngWzOQVsJXZMWM0IUSMocXLmE7AFzEA1zVtnQ9V/ZZd41aIDYbtI3L3ZwA5hC0u8Or4FypaS
	+PxuLxvEN8USy9bJgdwmIdDCKPH+3RxGiBpriX9X9oB9zCygKbF+lz5EWFZi6ql1TBBr+SR6
	fz9hgojzSuyYB2OrSlw4uA1qlbTE2glboU7zkFj99z4bJLAmMEr8PfKReQKjwiwk78xC8s4s
	hNULGJlXMUqmFhTnpqcWmxYY56WWw6M4OT93EyM4fWp572B89OCD3iFGJg7GQ4wSHMxKIrxn
	JoWmCfGmJFZWpRblxxeV5qQWH2I0BYb3RGYp0eR8YALPK4k3NLE0MDEzMzOxNDYzVBLnfd06
	N0VIID2xJDU7NbUgtQimj4mDU6qBqdVI7cf7ludFV4pcZAw7nGxcrvi9Tc49uV9i+vFHeyb4
	G26rrdiv8pzd7ZGY/LoTNbdOfLla55DZwam5QWfCf4GPC86+nq8tUahk+EcufvGGj/L9y48u
	9ChxiJKLXm0UdLiMZenDiypxCYq3WOZU+fKIJzitv/fsbKtk7k6+TZ4Hxflv5N6aw/Dl+TPV
	tDq+fP6n7UouK2pWrXj0elqb4hQpTk4Hfq+2w3+n7nx9YFeBd3n9P7YzTN2RnXfUs/KY/4kr
	8em5Vy2pLFjL2MOun8l48NmrfYvm+UdxhfgVt9ot2PiWOW5Gbi/n8ozOq9cblcz+PvjI3sNn
	Msm4mYcnX1157fv5V/2WhrgHa55UYinOSDTUYi4qTgQADVrecSgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWy7bCSnG4UV0SaweXlmhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1mc/vuYxeLmgZ1MFu9az7FYHP3/ls1i65evrBbP9nI6cHnsnHWX3ePy2VKP
	vi2rGD0+b5ILYInisklJzcksSy3St0vgyrj8xbqgm6Xi3OHJrA2MG5m7GDk4JARMJHr3K3Ux
	cnEICexmlLjZeJ+1i5ETKC4t0XGolR3CFpZY+e85O0TRD0aJzzMawBJsAjoSv1f8YgGxRYCK
	9ne0soAUMQs8Y5S4sOsuE0hCWCBcYtn0TYwgNouAqsS2lVfANvAK2En0tc5jhtggL7H/4Fkw
	m1PAVmLHhNVg9UICNhK3tu9lhqgXlDg58wnYMmag+uats5knMArMQpKahSS1gJFpFaNkakFx
	bnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcJBrae5g3L7qg94hRiYOxkOMEhzMSiK8ZyaFpgnx
	piRWVqUW5ccXleakFh9ilOZgURLnFX/RmyIkkJ5YkpqdmlqQWgSTZeLglGpgShC718nZqHy1
	lfvHrLw5ZYVvhEumWvl/usPmk7HzR/+8uo47aWlVglqX53e5rxbzvvP6oEdZx7yN/2KkrHhe
	rb3HUlWWvvx63YpvL+as9nT6WagQKRkV6tC0++OGdxpWy8ufaJUV/qvlmKtU+nGf8zKTzyfz
	Dn2ZJO+fw3P8RuzqnX4J/zZabzD2WvP6z8ag9Wzby/ZVtuSxpWekanbd/BJQ0ilU8/3Cw3Rl
	q6c21iUzZ01r39SVvMRdXKW9+J7vc1bXmrmLz83kN5ELr5oyTWJt+wFnFV3mILFTd81e2+UF
	zFrBpjND9vy/+tePFG+ab42LYv9inT7bLiqf6z7XPeOJz3mnyuvz+CzdLRKtxFKckWioxVxU
	nAgAav6kyOECAAA=
X-CMS-MailID: 20240530051050epcas5p122f30aebcf99e27a8d02cc1318dbafc8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240530051050epcas5p122f30aebcf99e27a8d02cc1318dbafc8
References: <c99eb326-0b36-4587-b8a2-8956852309be@kernel.dk>
	<CGME20240530051050epcas5p122f30aebcf99e27a8d02cc1318dbafc8@epcas5p1.samsung.com>

On Thu, 16 May 2024 08:58:03 -0600, Jens Axboe wrote:
> The change looks pretty reasonable to me. I'd love for the test cases to
> try and hit corner cases, as it's really more of a functionality test
> right now. We should include things like one-off huge pages, ensure we
> don't coalesce where we should not, etc.

Hi Jens, the testcases are updated here:
https://lore.kernel.org/io-uring/20240530031548.1401768-1-cliang01.li@samsung.com/T/#u
Add several corner cases this time, works fine. Please take a look.

