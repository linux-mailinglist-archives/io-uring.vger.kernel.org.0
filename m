Return-Path: <io-uring+bounces-3813-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 030699A3BF0
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 12:48:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 243791C21402
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 10:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEE392022E2;
	Fri, 18 Oct 2024 10:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AQ1EnjKU"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1AC201245
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 10:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729248506; cv=none; b=rZJrgb4ZYKmE1oMfLWf8G8XM01OlsFEqqLu1Y7QSZZWuz+D2kk8KVFjTQtBkwdgVJ3ZzOJFJXa0Wlv2mEvOD+2PSlCw/n3wFTiKpfGtzIuN278OCMZ6EsLEn8e9UoaubMAzjidyATJ07wWTG+1aRyazP6GDH15mwigEhq8aZ9P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729248506; c=relaxed/simple;
	bh=XWFaYzUR7M6h9Z99dH+0cLnfV+20GuKDv8AUwNBtNgo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=sIrQS5rD46qN7Mv0PQtlm3c5+QDclC/9+gGnt3h+xElocqEGPcHf1r4SAQ/R6mkqCl4X2X4dZj0mRLZeW+TZiMGnHFVR/8dudI0IkPloF5jBjGwpia08U+nc7M49xzWJk/XsfJSGdSK7yleeERkRTzDkQ9y0IzgpN0cBM96eciA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=AQ1EnjKU; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241018104822epoutp01d44084dd1373ca807d579282b802e314~-hlncq8Ac2694526945epoutp01P
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 10:48:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241018104822epoutp01d44084dd1373ca807d579282b802e314~-hlncq8Ac2694526945epoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729248502;
	bh=a6GZtz02sRXMNYbtfu3vRBWPZjl0hOynSDjR+0HGGEs=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=AQ1EnjKU06KoznaLLsOWeGfkz3zY/6bVElMQ21acRQvqQDm4v6bxlfuB+xN6ScJqo
	 CSpFbU6v2789yO1J+ONsA5wKAUP6aIyJ3B9Dv3WKcdaNGNf2CZdPfg7KtMWmBaIBdh
	 UyDjlDmgF24IfC9yDaAvskJiLzj1/XMDgkyArs1k=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241018104821epcas5p2ca965e217820ebd922ffc32a546d261d~-hlm-9e4A0569605696epcas5p2S;
	Fri, 18 Oct 2024 10:48:21 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XVLys1yjzz4x9Pp; Fri, 18 Oct
	2024 10:48:21 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	99.3F.08574.5FC32176; Fri, 18 Oct 2024 19:48:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241018104820epcas5p44da029e96f7fc71ac491ad4e3cffd0e1~-hlmCrmUO1092410924epcas5p4x;
	Fri, 18 Oct 2024 10:48:20 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241018104820epsmtrp1387a5804edd25426b3b35c7f7b19370b~-hlmB9PnI0866408664epsmtrp1K;
	Fri, 18 Oct 2024 10:48:20 +0000 (GMT)
X-AuditID: b6c32a44-93ffa7000000217e-b7-67123cf50659
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	BE.FC.18937.4FC32176; Fri, 18 Oct 2024 19:48:20 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241018104818epsmtip2c585eb3baf60bf763056efa92948d37a~-hlkMYvxl2276622766epsmtip2b;
	Fri, 18 Oct 2024 10:48:18 +0000 (GMT)
Message-ID: <77feb398-d6af-4f07-93bc-b12165604f04@samsung.com>
Date: Fri, 18 Oct 2024 16:18:17 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 6/6] nvme: enable FDP support
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, axboe@kernel.dk, hch@lst.de,
	io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, javier.gonz@samsung.com, Hui Qi
	<hui81.qi@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>, Hannes
	Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20241017160937.2283225-7-kbusch@meta.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDJsWRmVeSWpSXmKPExsWy7bCmhu5XG6F0g+43vBar7/azWexZNInJ
	YuXqo0wWO5etZbd413qOxeLxnc/sFpMOXWO0OHN1IYvF3lvaFnv2nmSxmL/sKbvFtt/zmR14
	PC6fLfXYtKqTzWPzknqP3Tcb2DzOXazw6NuyitFj8+lqj8+b5AI4orJtMlITU1KLFFLzkvNT
	MvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AuVVIoS8wpBQoFJBYXK+nb2RTl
	l5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZxyeMIupYCZjxdwPL1gb
	GCu7GDk5JARMJBb2zWbpYuTiEBLYzSix+OURJgjnE6PE6f/XWeGcbS/3scC0nNjwAiqxk1Hi
	5a6vzBDOW0aJG68+sHUxcnDwCthJXNkqBmKyCKhKTG5gB+nlFRCUODnzCdgcUQF5ifu3ZrCD
	lAgLGEtM6XEAmSIiMJNR4sS0CYwgDrPAUUaJC9v+M4E0MAuIS9x6Mp8JpIFNQFPiwuRSkDCn
	gLnE6pWr2CBK5CW2v50Ddo6EwA4OibN377JCHO0i0bdvGyOELSzx6vgWdghbSuJlfxuUnS3x
	4NEDqCdrJHZs7oPqtZdo+HODFWQvM9De9bv0IXbxSfT+fgJ2joQAr0RHmxBEtaLEvUlPoTrF
	JR7OWAJle0gcnX0cGmzbGSU+NW9nnsCoMAspWGYh+XIWkndmIWxewMiyilEytaA4Nz012bTA
	MC+1HB7dyfm5mxjByVjLZQfjjfn/9A4xMnEwHmKU4GBWEuFNqhdMF+JNSaysSi3Kjy8qzUkt
	PsRoCoyeicxSosn5wHyQVxJvaGJpYGJmZmZiaWxmqCTO+7p1boqQQHpiSWp2ampBahFMHxMH
	p1QDk5DEgzZhTs9AQ/eyPf/4n3Wu0FjeuD2ayVb+VynDZKlZvfqXJXkfxvGuCVm99Z2ugK5r
	1PKFr0PE5vM97Vl8+3DjrxUTD9xS2LjjY3mn4/UDu31uVrNszpE+NkPmnu+xcBHLEJnZldXL
	y36c/HG3Msx47/vdNrF17bceCaatsZu0nEXdVEdno574l6o4za2pja/Wrrt191dL7ZuTWffl
	L7/O25LfeuyOf2jtq74PZU+fNp5YYbA1r2ExL0vupAOh814FnA52Lzd35CpqlGow+8Tv1dJy
	RIH98sm0g88CCnRUJvAdszrbIG5f8unE133M0sUbsq+rMDMti/zP97TAt3zx6jcVjPPZLi53
	6l7/TYmlOCPRUIu5qDgRAGLEF0FPBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvO4XG6F0g8nLjC1W3+1ns9izaBKT
	xcrVR5ksdi5by27xrvUci8XjO5/ZLSYdusZocebqQhaLvbe0LfbsPcliMX/ZU3aLbb/nMzvw
	eFw+W+qxaVUnm8fmJfUeu282sHmcu1jh0bdlFaPH5tPVHp83yQVwRHHZpKTmZJalFunbJXBl
	HJ4wi6lgJmPF3A8vWBsYK7sYOTkkBEwkTmx4wdrFyMUhJLCdUWLZucfsEAlxieZrP6BsYYmV
	/56zQxS9ZpRYvOUPcxcjBwevgJ3Ela1iICaLgKrE5Aawcl4BQYmTM5+wgNiiAvIS92/NYAcp
	ERYwlpjS4wASFhGYySjx7aYfyERmgaOMEisOnGeDu2HVon9sIFXMQDfcejKfCaSZTUBT4sLk
	UpAwp4C5xOqVq6BKzCS6tnYxQtjyEtvfzmGewCg0C8kZs5BMmoWkZRaSlgWMLKsYRVMLinPT
	c5MLDPWKE3OLS/PS9ZLzczcxguNNK2gH47L1f/UOMTJxMB5ilOBgVhLhTaoXTBfiTUmsrEot
	yo8vKs1JLT7EKM3BoiTOq5zTmSIkkJ5YkpqdmlqQWgSTZeLglGpgYs30WvDnpek0y9jVxgW2
	++vPFF/6e3+29rumrU1HlD0zV7w8ahA9TfG8180EtkB+fvl8z9USyxbrm8wTPJee5PWy8epi
	5lMNHcuuTV/ixXVSTn7Xo3Re33vX8rs32T//kmRYx7F2+tGzyxhjuCevtj+ut+ZW4rwNdtuM
	ne4HdlZ/X8mwoUuavzSk4l3Lebc3jf5ul6YdWqdgmW2c+KiAWURres+bbXKFly/vlnJkqzz0
	z4Sv0aDrndxcjrfXL9U2fLh8/qtZ1lxTr8we97Ibeulr2urTmDc8iHA9v7Cp66a33JJp4bNL
	2D9aJV6WWnM6ZL5tV+CCl626c1aEZ95h6vigUHGwas60Bat4ikvfKrEUZyQaajEXFScCAGWq
	BS4mAwAA
X-CMS-MailID: 20241018104820epcas5p44da029e96f7fc71ac491ad4e3cffd0e1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241017161628epcas5p1006f392dc6c208634997f3a950ec8c67
References: <20241017160937.2283225-1-kbusch@meta.com>
	<CGME20241017161628epcas5p1006f392dc6c208634997f3a950ec8c67@epcas5p1.samsung.com>
	<20241017160937.2283225-7-kbusch@meta.com>

On 10/17/2024 9:39 PM, Keith Busch wrote:
>   
> +#define NVME_MAX_PLIDS   (NVME_CTRL_PAGE_SIZE / sizeof(16))
> +

Seems you intended sizeof(u16).

