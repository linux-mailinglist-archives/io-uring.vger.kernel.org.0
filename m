Return-Path: <io-uring+bounces-3773-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3E369A219D
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 13:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C159B22029
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 11:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A85061DD0CE;
	Thu, 17 Oct 2024 11:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JxjTZWPQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3D61DD53D
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 11:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729166205; cv=none; b=Fo0TlZcp7lixa2VHBhCxGZl5NfHTLreld6u3RMIuI9aRjCDAAlRiO0XKp9vFFoJKjVUdyLSR/5x7vrozKF9eFRzL9hmbs1cLcEmbijqD0lRgtjYFVN/1VdQoAJCGli8DIVMtjb1mFeGbrAdCHsssrqHKXTFUHcJAYhpaSDWamts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729166205; c=relaxed/simple;
	bh=wKlc9kzgItkD45rE8CzhCzLeADKHKSm7OpaZLxeG5B0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=KiJQikY9DiEmWluyU/dtUzET2jsfh/wriFt/quNc+cbG4G7SmtAGgCP3+A5OdKb9dWZA9shuuAmB8Uisc8CAOKnyT25Yp94y3pHarm3CNlh7DpLnbSCjfwro+wDJ6ngViac00dSvT1RyAKHcnxxpNJ+qN6fvkreI/Y6JUnAWi+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JxjTZWPQ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241017115641epoutp027ff37f8edbca97dced216fa605a4d34b~-O3_dgzWE0516605166epoutp02c
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 11:56:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241017115641epoutp027ff37f8edbca97dced216fa605a4d34b~-O3_dgzWE0516605166epoutp02c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729166201;
	bh=ZvMWWIWabCDUU/W5wbEpw/iLYt0jWPczryMohRLAoGs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JxjTZWPQtPls+p41o0kr94GLFB1+PNog6DCJPZ1Nv9ryFD74nxckq7xbxVhY9UFK3
	 Qb4EPYSAsmZEibEPDe63ULjGVXJVcf3lGNR60qGskDvwlmiJSEZTdmylu77p2IKTaU
	 BvRm1NzcKUm0xNvsBd12WUP2ULaE7K+IcTWoX6No=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241017115640epcas5p2431fd2118725f8574bcdc1d6a6701ec2~-O3_AWxTs1782417824epcas5p2V;
	Thu, 17 Oct 2024 11:56:40 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XTmX70D8xz4x9Pw; Thu, 17 Oct
	2024 11:56:39 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	97.AF.09800.67BF0176; Thu, 17 Oct 2024 20:56:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241017105243epcas5p17b56990fb2eefe7bff17b0707d36e251~-OAIuJtYB0222202222epcas5p1i;
	Thu, 17 Oct 2024 10:52:43 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241017105243epsmtrp2eef245216cc7529d04b0b210c77eef24~-OAItU7GG2323823238epsmtrp2F;
	Thu, 17 Oct 2024 10:52:43 +0000 (GMT)
X-AuditID: b6c32a4b-23fff70000002648-df-6710fb761402
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CA.8C.08229.B7CE0176; Thu, 17 Oct 2024 19:52:43 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241017105241epsmtip257eaec683d37859ce33f3feca07cbcbc~-OAG30yfZ2794027940epsmtip2G;
	Thu, 17 Oct 2024 10:52:41 +0000 (GMT)
Date: Thu, 17 Oct 2024 16:15:02 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com
Subject: Re: [PATCH v4 06/11] block: add flags for integrity meta
Message-ID: <20241017104502.GA1885@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241017080015.GD25343@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmhm7Zb4F0g/PHrSw+fv3NYjFn1TZG
	i9V3+9ksbh7YyWSxcvVRJot3redYLCYdusZosf3MUmaLvbe0LeYve8pu0X19B5vF8uP/mCzO
	z5rD7sDrsXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49Pb7F49G1Zxeix+XS1x+dNcgGcUdk2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBHKymUJeaU
	AoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM6b3
	LmQt+M9WceXvLbYGxg+sXYycHBICJhLNMyewdTFycQgJ7GaUuP+0kRnC+cQose/8RijnG6PE
	8ekbmWBadh0+yQKR2Mso8fZmGzuE84xRYu3tr4wgVSwCqhJvu/6ygNhsAuoSR563gsVFBJQk
	nr46ywjSwCywkkli79VZzCAJYQFHieXf34Gt4BXQkfi6rIUNwhaUODnzCdggTqB494VzYINE
	BZQlDmw7zgQySELgAIfEnZtfoe5zkTjZ2soMYQtLvDq+hR3ClpL4/G4vG4SdLvHj8lOo+gKJ
	5mP7GCFse4nWU/1gvcwCGRLTWzZDzZGVmHpqHRNEnE+i9/cTqF5eiR3zYGwlifaVc6BsCYm9
	5xqAbA4g20Oi95AsJITuM0rMOnCLcQKj/Cwkv81Csg7C1pFYsPsT2yygdmYBaYnl/zggTE2J
	9bv0FzCyrmKUTC0ozk1PLTYtMM5LLYdHeXJ+7iZGcKrW8t7B+OjBB71DjEwcjIcYJTiYlUR4
	J3XxpgvxpiRWVqUW5ccXleakFh9iNAVG1kRmKdHkfGC2yCuJNzSxNDAxMzMzsTQ2M1QS533d
	OjdFSCA9sSQ1OzW1ILUIpo+Jg1OqgUnsCefN/y57ZrhM7Hogu8N151zGswWz83drrfn6XGfx
	5FMeUbm9Zq/dpZ6EhG2u+C2m7XQjIs2r/87PNdY3SrzYLxqeWq+1wLri2repR+5a6/ALJ95M
	PfZR6Urt1y1+G56mMB5lM5z9eUtAi8Y7LbZZXZ9LJDsmFEZIOSzPWJYUKaXik5X6KU4o+8Ch
	I6pKk8JVBf39ZyVNFOJbdkzof7f0bxf14p0NJR1X3y5beS0/PYPv2WmN5pbCs+nxF2Oe398d
	tLyYJ/yLVorUUb9bBnubNvZFLlpw6uGX6ldXF03Zqfou5YLFnZCX0v9snVc0BOg++nD33uPL
	wcfYVR/v3lXVOi9sp9nt9bmiK5au0V6hxFKckWioxVxUnAgAPuvZpF4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42LZdlhJXrf6jUC6wYX3RhYfv/5msZizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02H5mKbPF3lvaFvOXPWW36L6+g81i+fF/TBbn
	Z81hd+D12DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvTYfLra4/MmuQDOKC6b
	lNSczLLUIn27BK6M7Xs3sBTsZ6k4O6OHvYHxJHMXIyeHhICJxK7DJ1m6GLk4hAR2M0pMfvob
	KiEhcerlMkYIW1hi5b/n7BBFTxgljvTsYQVJsAioSrzt+ssCYrMJqEsced4K1iAioCTx9NVZ
	RpAGZoGVTBJ7r84Cmyos4Cix/Ps7JhCbV0BH4uuyFjaIqfcZJa42z2OFSAhKnJz5BGwqs4CW
	xI1/L4EaOIBsaYnl/zhAwpxAvd0XzoEtExVQljiw7TjTBEbBWUi6ZyHpnoXQvYCReRWjZGpB
	cW56brFhgWFearlecWJucWleul5yfu4mRnCMaWnuYNy+6oPeIUYmDsZDjBIczEoivJO6eNOF
	eFMSK6tSi/Lji0pzUosPMUpzsCiJ84q/6E0REkhPLEnNTk0tSC2CyTJxcEo1MAm4bVppszjK
	/RxvoMSLV2Z7ZsnL5gu6LF9Z0VdRNFfK3e+n/Zz3Gm6zpBlvFCglHLF8oPOipIptq9FdVr3K
	y5ImN+dxFBarBKl8yLg1iVmlWkVMSVR4gwQPg8FD1bWhrtetjX/eabtz7umM3MKnU3ga0p1U
	9h7dlmRwR9Or/UcVc11fwzHXvrSfl/487Vj69pX+hLvr57DY7p95RP5Hv4VC2zqngPlPpk6d
	eqhJ/PTMNi4lsaTFjlfzejcERVYz5VdfnjFNhdl2pyiT+KPYlKBTm6R71E9Vma6e8/W87byM
	3/fWP9TXi1PRXf1M5+Ab696Fc1blz1PuE0oz+W40K11+p2rx0Zagtond4T7qSizFGYmGWsxF
	xYkAHxIvQiADAAA=
X-CMS-MailID: 20241017105243epcas5p17b56990fb2eefe7bff17b0707d36e251
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_5007d_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113745epcas5p1723d91b979fd0e597495fef377ad0f62
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113745epcas5p1723d91b979fd0e597495fef377ad0f62@epcas5p1.samsung.com>
	<20241016112912.63542-7-anuj20.g@samsung.com>
	<20241017080015.GD25343@lst.de>

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_5007d_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Thu, Oct 17, 2024 at 10:00:15AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 16, 2024 at 04:59:07PM +0530, Anuj Gupta wrote:
> > Add flags to describe checks for integrity meta buffer. These flags are
> > specified by application as io_uring meta_flags, added in the next patch.
> 
> These are now blkdev uapis, but io_uring ones even if currently only
> the block file operations implement them.  I do plan to support these
> through file systems eventually.

Are these flags placed correctly here or you see that they should be
moved somewhere else?
> 
> 

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_5007d_
Content-Type: text/plain; charset="utf-8"


------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_5007d_--

