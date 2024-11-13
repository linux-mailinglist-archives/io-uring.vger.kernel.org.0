Return-Path: <io-uring+bounces-4639-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 638AE9C6A59
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 09:10:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6E701F26734
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 08:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC4F317C22E;
	Wed, 13 Nov 2024 08:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="c3Y9JT08"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CE618A94C
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 08:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731485395; cv=none; b=E0wWCo3PBBWvkh2nU+vGA3iOUwp3SKdfL0ODA2IzLIbxTvGTuo5k+YSfXAlZEBA9/lQ3cj6s/8uy3k/2Nb17z6c78Tm3X0Z7sn+Z+n92BBopCX1c6nXWKXvkb3ErUGJXX3/wyaGmPu5NnMV9KyeqcQHUIVKRwoh0O1USMtV8k88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731485395; c=relaxed/simple;
	bh=uCMOHCZGd25jMMY0rplarIQnfETa87H0TDBeaCYdI+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=QMtyN8vSzval8IS/dSCh8MbV+2YO75+fWfMHfakvcxBQ+Wv0pUu/3KCV1zUwOyItLDdhNRRQfep/l4igYk3X/yR0sg8uMQRgaVxntWaZX7kquj2BIAewxpGBLBlbHbAZdBcJHrDC4MOsvX2fxMeX6jLk0YmeQpRySgIpyT8FLn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=c3Y9JT08; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241113080945epoutp0302b36476a06eed9b1939d11d81a56fcb~HeMjK7SN82410024100epoutp03g
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 08:09:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241113080945epoutp0302b36476a06eed9b1939d11d81a56fcb~HeMjK7SN82410024100epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731485385;
	bh=uCMOHCZGd25jMMY0rplarIQnfETa87H0TDBeaCYdI+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3Y9JT08zDzOuaor314SfJynezaVE2vxxI+QnBApUgKSuUcgYyib5kHz+qKJj/ULi
	 ZNMSi1+WBtwh2QRzGwJJBALeDSURA2WqyJ+kmTeJ4ilrIPvf4zJqrLGkDGT/ONXePm
	 xli2i+PgmZZB8iUSjkVeDmpUzccX2MjAiysmc2as=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241113080944epcas5p1fdd8c90247d3a2c67ff370c44b8026cd~HeMiR04Lb1834518345epcas5p1T;
	Wed, 13 Nov 2024 08:09:44 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XpGCq1PX7z4x9Pw; Wed, 13 Nov
	2024 08:09:43 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	3C.03.08574.7CE54376; Wed, 13 Nov 2024 17:09:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241113062658epcas5p3d7234648ac86e7a16dab96c3c1d5dc98~HcyztyyCh2882928829epcas5p3v;
	Wed, 13 Nov 2024 06:26:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241113062658epsmtrp2a20c45ba9fe3cda02b1b3e46e8518ecb~Hcyzs38xT0278102781epsmtrp2d;
	Wed, 13 Nov 2024 06:26:58 +0000 (GMT)
X-AuditID: b6c32a44-93ffa7000000217e-8e-67345ec75e00
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	00.8B.35203.2B644376; Wed, 13 Nov 2024 15:26:58 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241113062656epsmtip18d0729e3ab0c612f702013b3085d7d61~HcyyLNfMr3226532265epsmtip15;
	Wed, 13 Nov 2024 06:26:56 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: anuj20.g@samsung.com
Cc: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH liburing] test: add test cases for hybrid iopoll
Date: Wed, 13 Nov 2024 14:26:52 +0800
Message-ID: <20241113062652.3080848-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241112104406.2rltxkliwhksn3hw@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42LZdlhTS/d4nEm6wYatnBZNE/4yW8xZtY3R
	YvXdfjaLd63nWCx+dd9ltLi8aw6bxdkJH1gd2D12zrrL7nH5bKlH35ZVjB6fN8kFsERl22Sk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaCkUJaYUwoU
	CkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM74OWUx
	e8FF9opDK3vZGxgns3UxcnJICJhILNmyhhHEFhLYzSixd69XFyMXkP2JUWJPaysrhPONUWJK
	yzlGmI72C83MEIm9jBJtd/4wQjg/GCWudl1jAqliE1CS2L/lA1iHiICExJrnp1lBbGaBVImf
	96aDxYUFPCSmLDoPdgeLgKrE5UOrWEBsXgFrifdTN0Ntk5dYvGM5M4jNKWAu8XD3P0aIGkGJ
	kzOfsEDMlJdo3job7CIJgVvsErMeXmaFaHaRaDjcBvWosMSr41vYIWwpic/v9kLF8yUmf18P
	taxGYt3mdywQtrXEvyt7gGwOoAWaEut36UOEZSWmnlrHBLGXT6L39xMmiDivxI55MLaSxJIj
	K6BGSkj8nrAI6hwPiVVNICNBgdXFKPFq3ifWCYwKs5D8MwvJP7MQVi9gZF7FKJlaUJybnpps
	WmCYl1oOj+Xk/NxNjOBEqeWyg/HG/H96hxiZOBgPMUpwMCuJ8J5yNk4X4k1JrKxKLcqPLyrN
	SS0+xGgKDPCJzFKiyfnAVJ1XEm9oYmlgYmZmZmJpbGaoJM77unVuipBAemJJanZqakFqEUwf
	EwenVAPTiuPpGxStTdYtW1jc9MGf3+LbssBL23pn3fKIO3DKpL27oc/+XdhZnoQT2XPf/wxb
	yRf6WUMm1c5mSZZplFX6jpC/8hX+tXMDf81edljqgpue++v8Jct/rxCY9CLkgfLDktWvMmK1
	GM+5vvyY87I5/Lyu54VXUv/Pt/x4UPxsddsE/ehWkdDG0POmT4ynaFsdu7xEUUT6acoezyD1
	L3wbOtSbgv9YH7onoSJs2eCkqc346N/+nVYawiYtHDOuyGdp5Ok1uLdZb5HkPRLKbnxxI+/7
	CR/qTEt3G6XuUv7s5NDPfWa54aG2+K0x9WsSPQ4dSm1z2uy5atf9/lgvh2ePYpVPLMz2vLLv
	pKHZBRUlluKMREMt5qLiRACJSmvdHQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsWy7bCSnO4mN5N0g9XTZC2aJvxltpizahuj
	xeq7/WwW71rPsVj86r7LaHF51xw2i7MTPrA6sHvsnHWX3ePy2VKPvi2rGD0+b5ILYInisklJ
	zcksSy3St0vgyvg5ZTF7wUX2ikMre9kbGCezdTFyckgImEi0X2hm7mLk4hAS2M0ocXPxC6iE
	hMSOR39YIWxhiZX/nrNDFH1jlOi69ZUJJMEmoCSxf8sHRhBbBKhhzfPTYA3MApkSuybcZAax
	hQU8JKYsOg82lEVAVeLyoVUsIDavgLXE+6mbGSEWyEss3rEcrJ5TwFzi4e5/YHEhATOJV2sf
	QtULSpyc+YQFYr68RPPW2cwTGAVmIUnNQpJawMi0ilEytaA4Nz232LDAMC+1XK84Mbe4NC9d
	Lzk/dxMjOJS1NHcwbl/1Qe8QIxMH4yFGCQ5mJRHeU87G6UK8KYmVValF+fFFpTmpxYcYpTlY
	lMR5xV/0pggJpCeWpGanphakFsFkmTg4pRqYKq88tt39a1JD9Pn50+axH/oe/lhov3pGn3xI
	21dGu+xFn4ID0tUPJJQ+bZiw85SjltNO475tC+9cmtZmXdq6lHmp8izGR6uaIorq3BaeqtfP
	Cp6x1F73x917a/UrGi8tXXmae8fGvhVFf+VuLt76b6uBqZix8PPSsulcDuw2f/Q56zyfpfyq
	V1otO7XWTOr65LZf+x4fjvgzT/DV97MsT/buLdFRrpWcEX7z3tMOtqtuE88+zp71a5KXmYTe
	o/TaTgEZff3pm81m2OVYlJlPk2pduLI42cbscVdTaeGJ1QysEtfXb3lxseFAnczGx5eCBG7F
	F5mvd1p/re3hjo9dTgf/nz7Wb5f/kMP/kszSbCWW4oxEQy3mouJEALoDBa3UAgAA
X-CMS-MailID: 20241113062658epcas5p3d7234648ac86e7a16dab96c3c1d5dc98
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241113062658epcas5p3d7234648ac86e7a16dab96c3c1d5dc98
References: <20241112104406.2rltxkliwhksn3hw@green245>
	<CGME20241113062658epcas5p3d7234648ac86e7a16dab96c3c1d5dc98@epcas5p3.samsung.com>

On 11/12/24 3:44 AM, Anuj Gupta wrote:
>> +utilization than polling. Similarly, this feature also requires the devices
>> +to support polling configuration.
> This feature would work if a device doesn't have polled queues,right?
> The performance might be suboptimal in that case, but the userspace won't
> get any errors.

The usersapce will get error in this case. Hybrid must be dependent on iopoll,
if hybrid polling is set separately,it will not pass detection and an error will
be returned. Therefore, device end cnnfigured are required for polling.

......

> This patch mostly looks fine. But the code here seems to be largely
> duplicated from "test/io_uring_passthrough.c" and "test/iopoll.c".
> Can we consider adding the hybrid poll test as a part of the existing
> tests as it seems that it would only require passing a extra flag
> during ring setup.

Make sense, I will try to do this in exsiting test file. Thank you very much.

--
hexue

