Return-Path: <io-uring+bounces-2502-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0326D92F6D9
	for <lists+io-uring@lfdr.de>; Fri, 12 Jul 2024 10:23:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2FC32834E7
	for <lists+io-uring@lfdr.de>; Fri, 12 Jul 2024 08:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F44713DDBA;
	Fri, 12 Jul 2024 08:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="f4X13abJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3133C13D509
	for <io-uring@vger.kernel.org>; Fri, 12 Jul 2024 08:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720772606; cv=none; b=PmYrMMsoiUU7BnwV9CFC86Pv1/VQg4KDa8DDLYKEC+OcjGIOPAn1XkpudhLxwaDNFL/FRruYch1XZ4rBeIVvb+x+5Rm/Z2IBc9A9WkoRuHRcKmM6uZVL6euDcJa05pERZTpLmxvqAchaXS4GCgB06xiIKW3ZaDbJu898/PCl82c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720772606; c=relaxed/simple;
	bh=k4DqjM+f2mpsIHVU3sYPFhWs1zxrgHI2U6K0amjP790=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=XuzjgRny/E9iluhXXTwYCjB3U4Ek5OQM/KeguvYcwq1SQf5C4evwkPNadtBKAzp1Cqe5kvLCc55kK3PRVpK4jJ52JXekePzoD3oQwZET9CC1Ss3mHSJcyWG7VDJWJ/r2IqP/myqgU/4ZoImkgavSxJdkQAqcWHCX3+dOZr/SPqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=f4X13abJ; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240712082316epoutp0112031d69334aa3caea7b82d4e3778cb2~haY84NBKP1966819668epoutp01K
	for <io-uring@vger.kernel.org>; Fri, 12 Jul 2024 08:23:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240712082316epoutp0112031d69334aa3caea7b82d4e3778cb2~haY84NBKP1966819668epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720772596;
	bh=EN2jPuqsDevY28zpnNxB4ovNHRij5bWkyvMEhUSw2Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4X13abJ596q46JWe9vPb+8ZFybe1rCxJUe78G/h2H8VtbWZLiSTPScQ+98d1Xzdj
	 szrn025sLmd32gTAVUj8Hls0hwKsni6FlT3vfwDR/PqI4B0vqLYK+gqYLR+zExPDv1
	 gMRIFRbJTzuB0l8wnPJRfivaagY2ukZASE8KTySg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240712082316epcas5p35604a34dfcf2354a6b13fe6b8b4a5fc2~haY8obsCL2635226352epcas5p36;
	Fri, 12 Jul 2024 08:23:16 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WL4Nf14bWz4x9Q2; Fri, 12 Jul
	2024 08:23:14 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6D.C7.19174.AE7E0966; Fri, 12 Jul 2024 17:23:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240712065750epcas5p2149131922a27554e6a40313e5c73699e~hZOXCVf222681526815epcas5p2B;
	Fri, 12 Jul 2024 06:57:50 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240712065750epsmtrp2ca7a7789bd9d3112d069765defcde925~hZOXA82723072830728epsmtrp2N;
	Fri, 12 Jul 2024 06:57:50 +0000 (GMT)
X-AuditID: b6c32a50-87fff70000004ae6-88-6690e7eafd35
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	BF.FC.18846.EE3D0966; Fri, 12 Jul 2024 15:57:50 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240712065749epsmtip163077e8f8b8a31d4f3c51eb31c04eb76~hZOWAz0Y31597715977epsmtip1W;
	Fri, 12 Jul 2024 06:57:49 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: hch@infradead.org
Cc: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, xue01.he@samsung.com
Subject: Re: Re: [PATCH v2] io_uring: Avoid polling configuration errors
Date: Fri, 12 Jul 2024 14:57:45 +0800
Message-Id: <20240712065745.808422-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <ZpC9HxJnokkbjKAO@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmlu6r5xPSDBbPUrGYs2obo8Xqu/1s
	FqcnLGKyeNd6jsXiV/ddRovLu+awWZyd8IHVouvCKTYHDo+ds+6ye2xeoeVx+WypR9+WVYwe
	nzfJBbBGZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
	AF2ipFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAw
	MgUqTMjOOD69j6mgn6Vi39HEBsZFzF2MHBwSAiYS2x74djFycQgJ7GGUePHrHwuE84lR4kn7
	eyY45++3L0AZTrCO9Tf2QiV2Mkq0TWtmhHB+MEo03WhiBqliE1CS2L/lAyOILSIgKnFv+hUw
	m1mgWuL/sh52EFtYwENiwrvVYFNZBFQlvnzdDlbDK2AlsWv+enaIbfISN7v2g83kFNCVaDh1
	mA2iRlDi5MwnLBAz5SWat85mBjlCQuARu8TViR+ZIZpdJFY3/GKCsIUlXh3fAjVUSuLzu71s
	EHa+xOTv6xkh7BqJdZvfQb1pLfHvyh4WUCAxC2hKrN+lDxGWlZh6ah0TxF4+id7fT6DG80rs
	mAdjK0ksObICaqSExO8Ji1ghbA+J3T2rmCGB1cAosW7bJ/YJjAqzkPwzC8k/sxBWL2BkXsUo
	lVpQnJuemmxaYKibl1oOj+Xk/NxNjODUqRWwg3H1hr96hxiZOBgPMUpwMCuJ8Hqe7U8T4k1J
	rKxKLcqPLyrNSS0+xGgKDPGJzFKiyfnA5J1XEm9oYmlgYmZmZmJpbGaoJM77unVuipBAemJJ
	anZqakFqEUwfEwenVAPT7iiTHc8MgvcK8i19MGlmSr/zltyc6XkR1UwPvHYK1SXGTNawOXxr
	z+1+z8Rp+hlv7946dWmP1s05s+dpWzTNK9NtPLL41dFTH15d5fiyX/Hp/S+NcsvDOQ/cfeMv
	fGC9rWF68xejvknB4pNNSxLfc09vOv+06nlYkbe68pKrHgmHDO7nv7NPYJ6e66G49MKx6TFB
	2mrHLp4p2vYpwPXC3jBFA3MR9soLDbfksiamaq8z1p2acJnVZmZ6ZeDWTcpXM0z4NV1n/Qp2
	2t5iI1j4Y4PjYjmhCas01u+tUOorW8AqPHvp47dTJgiHya0y3qT5bAWzlOqke8eecH0wf6P8
	cvaZ/ROvL3o7/9ll4ZU7pymxFGckGmoxFxUnAgDI/fY8JgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSnO67yxPSDCZ0K1jMWbWN0WL13X42
	i9MTFjFZvGs9x2Lxq/suo8XlXXPYLM5O+MBq0XXhFJsDh8fOWXfZPTav0PK4fLbUo2/LKkaP
	z5vkAlijuGxSUnMyy1KL9O0SuDKOT+9jKuhnqdh3NLGBcRFzFyMnh4SAicT6G3uZuhi5OIQE
	tjNK/Ns7mQ0iISGx49EfVghbWGLlv+fsEEXfGCUuXGlkBEmwCShJ7N/yAcwWERCVuDf9CiNI
	EbNAI6PE8h0HWUASwgIeEhPerQazWQRUJb583Q7WwCtgJbFr/np2iA3yEje79oOdxCmgK9Fw
	6jDYFUICOhLLbjayQtQLSpyc+QRsDjNQffPW2cwTGAVmIUnNQpJawMi0ilE0taA4Nz03ucBQ
	rzgxt7g0L10vOT93EyM4qLWCdjAuW/9X7xAjEwfjIUYJDmYlEV7Ps/1pQrwpiZVVqUX58UWl
	OanFhxilOViUxHmVczpThATSE0tSs1NTC1KLYLJMHJxSDUwTtxiG79Fzlgwqz2E49KGv4fsU
	GyP/hXP59VgOF4gHSDG9vPa4S+aj/Za1zGFOq74cNlh6RTx1g9Aew93ljcpni13+MDw7FcfI
	+t66+UXr+eqqk480H/kceGdt1iTnVp1THb7k5ONdgSmf1mjscd9x8cOCqIYrfgom8yxElP6s
	lbDPelBbdVMpIYFN07vQr8iK79/aR+ejbucF/gleyHo8MHfBJttmV2333uTzkvcN56mvfCL2
	VMvbYK/R4U+z2T2qPtzZ5a359M2f7XN0gzWenOx1DvG86eMv5zvXpubc0a2BXQyJuob/S+9J
	tGV1JE9+GlWdcz/+1PPXXwvclpS77JzBf/fWGV5ZTQ13BSWW4oxEQy3mouJEALsA1vvZAgAA
X-CMS-MailID: 20240712065750epcas5p2149131922a27554e6a40313e5c73699e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240712065750epcas5p2149131922a27554e6a40313e5c73699e
References: <ZpC9HxJnokkbjKAO@infradead.org>
	<CGME20240712065750epcas5p2149131922a27554e6a40313e5c73699e@epcas5p2.samsung.com>

>This is wrong for multiple reasons.  One is that we can't simply poke
>into block device internals like this in a higher layer like io_uring.
>Second blkdev_get_no_open is in no way available for use outside the
>block layer.  The fact that the even exist as separate helpers that
>aren't entirely hidden is a decade old layering violation in blk-cgroup.

Got it, thanks.

>If you want to advertize this properly we'll need a flag in struct
>file or something similar.

Thanks, I will try to do this.

--
hexue

