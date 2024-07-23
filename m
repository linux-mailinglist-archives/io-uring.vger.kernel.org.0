Return-Path: <io-uring+bounces-2546-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DABE939DDD
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 11:32:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6644CB22B13
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 09:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E9F13B58D;
	Tue, 23 Jul 2024 09:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WQpBCbBf"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524D161FE1
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 09:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721727082; cv=none; b=A/4BvY5HUmrdO6VOcRlyhSGVrGxqhOhf+qpy6XQxKMFgKOAV7f2ZBYw3/pKdxSmq17jRmYOieg28IX0ohYV/o3EBXUaqMLWUGYx55W3NTrgPfd28S28n7e5G5sYiuIm0fv5d9sfJ1hv610CcQ7AgVVng7qIT5htLtWhu93qoV74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721727082; c=relaxed/simple;
	bh=Pn5sg/x2ZqQv2rGOtc/rqYKziPGkEGvRFjBPc6TuARg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=pFpT09zTr/XBrabb9+vU8FFkUuXjKMR1R2l15SpSaBzCZuAuuhm5/L6Q+YDUO1MFybdjd4MyZI5gg4zO1erX88r3jGHO3TvB1oRcxgN8biPq04tqLKq2T1tYFz9vxtIMQD/LWoV4AKXTutk+hRFzDwlmHvKrVhfyFE++y8CL6FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WQpBCbBf; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240723093116epoutp03d5eb51d1df164c0eb49dce02a067268a~kzadnN4fl2027620276epoutp03w
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 09:31:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240723093116epoutp03d5eb51d1df164c0eb49dce02a067268a~kzadnN4fl2027620276epoutp03w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1721727076;
	bh=CBmF/yDk4pyfAh9vtjln+olK11uKbDJYSgYn1QuN7sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQpBCbBftsM/FZxqjPO7vxWDkuK6OeW770LAEq5VG/e2+Vo+9pbLrOgqcpB+K2UuS
	 PX9f1+WcHIhuWcM03/KiFr7rF0C1mRtupLSa9aPCHYDYITxpUs4Qe9BVGxUxWo9NUO
	 4cCTosD6A6r6PkwnFEe+wWcqKSSw384XWfHU64Xo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240723093115epcas5p3a7a51758a858962f9c4c5995b7bc3c27~kzadDlj2V0402304023epcas5p3w;
	Tue, 23 Jul 2024 09:31:15 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4WSsN152LDz4x9Q3; Tue, 23 Jul
	2024 09:31:13 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BF.5A.09642.F587F966; Tue, 23 Jul 2024 18:31:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240723070343epcas5p4c4050288a03e56f973fb90d6f0dd82e1~kxZoS4oGO1263912639epcas5p4D;
	Tue, 23 Jul 2024 07:03:43 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240723070343epsmtrp2ff98e1b28264e8681b4690c3f8b88195~kxZoSHEM23033330333epsmtrp2I;
	Tue, 23 Jul 2024 07:03:43 +0000 (GMT)
X-AuditID: b6c32a4b-613ff700000025aa-29-669f785f2c16
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5E.DB.08964.EC55F966; Tue, 23 Jul 2024 16:03:42 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240723070341epsmtip150306354c44ebd7d3d7263974c1c82fa~kxZmmFu740666006660epsmtip1J;
	Tue, 23 Jul 2024 07:03:41 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: cliang01.li@samsung.com
Cc: anuj20.g@samsung.com, asml.silence@gmail.com, axboe@kernel.dk,
	gost.dev@samsung.com, io-uring@vger.kernel.org, joshi.k@samsung.com,
	kundan.kumar@samsung.com, peiwei.li@samsung.com
Subject: Re: [Patch v7 0/2] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
Date: Tue, 23 Jul 2024 15:03:36 +0800
Message-Id: <20240723070336.2424-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240723055616.2362-1-cliang01.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsWy7bCmhm58xfw0g5Y5phZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFp
	XrpeXmqJlaGBgZEpUGFCdsbLeX3MBftYK3avPsrSwHicpYuRk0NCwETiycdOti5GLg4hgd2M
	Eo1btjFBOJ8YJfbcmg/lfGOUmHP5GhNMy+meHYwgtpDAXkaJqWetIIqamCQ2bF3CCpJgE9CR
	+L3iF9gOEQFpiVfbVoNNYgbZcW3fW7CEsECkxIzZDWANLAKqEuv2LAGbyitgLdFx/RQ7xDZ5
	if0HzzKD2JwCNhKPz02CqhGUODnzCdgcZqCa5q2zmUEWSAj8ZJfo/d4HdaqLRNPpyWwQtrDE
	q+NboIZKSXx+txcozgFkF0ssWycH0dvCKPH+3RxGiBpriX9X9rCA1DALaEqs36UPEZaVmHpq
	HRPEXj6J3t9PoFbxSuyYB2OrSlw4uA1qlbTE2glbmSFWeUis3WMNCax+RonJyw+xT2BUmIXk
	nVlI3pmFsHkBI/MqRsnUguLc9NRi0wLjvNRyeCwn5+duYgSnUy3vHYyPHnzQO8TIxMF4iFGC
	g1lJhPfJq7lpQrwpiZVVqUX58UWlOanFhxhNgeE9kVlKNDkfmNDzSuINTSwNTMzMzEwsjc0M
	lcR5X7fOTRESSE8sSc1OTS1ILYLpY+LglGpgOjlhDuPaD3d6laVOyOokH1fvPOox48zD2p9X
	Y01XHDFg7SnJNZ/O2vHETvmNB+eTBnPtZWa698sbFJLWyGqms3x1mal+i9GQh7nEakfPM+vd
	jOkPBI5PTOQ5sr8z8vikyHUZ5Tt1HRmMBK79TX2kfX3r3hnJ5yb+a2zXXjP1fdWl5Ahe2/8/
	Nqxy/dEQqcjlzF4Qv9Xus7yV87W0w3u3mPY2a4jfnh7cGcAjFXby0PzCX3kvjM7tTne8X6b7
	Uv7j/a6YiR/Nq653fI49/aTKeDr/sQW6R3wsHBVPCVTUbU384hw2/9yENVLvT56TtGC8GX4t
	XsXjyF7lrNxntTwu33g/vxZr2Lkiwv6lk0qJEktxRqKhFnNRcSIAe69XWTAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWy7bCSnO650PlpBjMuWFs0TfjLbDFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujJfz+pgL9rFW7F59lKWB8ThLFyMnh4SA
	icTpnh2MXYxcHEICuxklPi7awgSRkJboONTKDmELS6z895wdoqiBSWLXlXfMIAk2AR2J3yt+
	gU0SAWp4tW01E0gRs8BRRon7XVvBJgkLhEss7D7LBmKzCKhKrNuzhBHE5hWwlui4fgpqg7zE
	/oNnwYZyCthIPD43CaxGCKhm8qY1UPWCEidnPgFbxgxU37x1NvMERoFZSFKzkKQWMDKtYpRM
	LSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIDnktzR2M21d90DvEyMTBeIhRgoNZSYT3yau5
	aUK8KYmVValF+fFFpTmpxYcYpTlYlMR5xV/0pggJpCeWpGanphakFsFkmTg4pRqYDM4tNQ6K
	mPXXhzFrw6Pa7r2/nZ6GGVb+d3i/VrxJ6WXy/wVTxCKOa7JKHj7ierRvZfQyTYces4w7/10u
	lSU1R/qxFG16u25CyQGPYJuwtd/MilR/vD2uaZKna7hYqdlHsCtixQFxE+/jyRf60jXXv778
	UvCRawbDloa97nyXHu8OenM8mUE/9Pb9/80he9SLD5/5xtvB7Lf0zOTLXa46vMv3LjvzJfWf
	lOeliTLb4i8rXeCL1C45pxoa3v3vlukm+RV9HZ+MnY/Nsl7B/WrOzagnJa+fW6ea3D9SnFka
	e9xhHndq1+brCybN91rI0rVvuVz43AmVciVNl/Ly727J6ulznKjP9aMglq1l/X1nJZbijERD
	Leai4kQAQmovH+gCAAA=
X-CMS-MailID: 20240723070343epcas5p4c4050288a03e56f973fb90d6f0dd82e1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240723070343epcas5p4c4050288a03e56f973fb90d6f0dd82e1
References: <20240723055616.2362-1-cliang01.li@samsung.com>
	<CGME20240723070343epcas5p4c4050288a03e56f973fb90d6f0dd82e1@epcas5p4.samsung.com>

On Tue, 23 Jul 2024 13:56:14 +0800, Chenliang Li wrote:
> Changes since v5:
> - Reshuffle the patchset to avoid unused funtion warnings.
> - Store head page of the folio and use folio offset to get rid of
>   branching on bvec setups.
> - Add restrictions for non border-aligned folios.
> - Remove unnecessary folio_size field in io_imu_folio_data struct.
>
> v5 : https://lore.kernel.org/io-uring/20240708021426.2217-1-cliang01.li@samsung.com/T/#t

Forgot to add:

Changes since v6:
 - Remove the restriction on non-border-aligned single hugepage.
 - Code style issue.

v6 : https://lore.kernel.org/io-uring/20240716060807.2707-1-cliang01.li@samsung.com/T/#t

Thanks,
Chenliang Li

