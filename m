Return-Path: <io-uring+bounces-4637-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A959C68B9
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 06:30:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87654B2613C
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 05:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD38230995;
	Wed, 13 Nov 2024 05:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Rt7yHtr9"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BF123098A
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 05:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731475837; cv=none; b=WGPSl9l8oxQ2IAnrIlEmlYnLK0EwPZuNET0vRbOF7sVPnUvkLe//5OOxm04FatlvV1wPc4k7IYNDj+5VpEzAk7YtFGXg382MnfONui5bGX5sZekCQS6AJpWW3DF/UxgjJUClCkWTMqofH9y8/OJqQ4FEHhlhFz8VC5eDfYvXUck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731475837; c=relaxed/simple;
	bh=qUqxhdgVX9SUv43Q+hcjIg4PHs2A7Pgg9vlVIrMAsqs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=AM+MQb5umgHYl99t7RRWpoJ9/SIubnEBwI8eh+TLx7gdmuc+f5U+Ya+OpFjnnWFtv/Y0QCzr+0jDPrvoiNzwGN3eGgUaEMopgOpjH5Gi3zECQ47c60YaTGQDv2esXnFus8zTf7I8/jUj6LO+q77+7pfNN0ocCloXy9bpfLlD5OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Rt7yHtr9; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241113053026epoutp040440f8e2f7f800224c0ed81f8a3a3dc6~HcBdEJQEy2830228302epoutp04Z
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 05:30:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241113053026epoutp040440f8e2f7f800224c0ed81f8a3a3dc6~HcBdEJQEy2830228302epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731475827;
	bh=qUqxhdgVX9SUv43Q+hcjIg4PHs2A7Pgg9vlVIrMAsqs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Rt7yHtr9nYpDAi/AbMpElTlXR0TyY8IhapYpLf0ToGHezDPBEZNjDOHBrbgK+5+3S
	 b7ENcsYlnIvSwgXHFKn48Ec0mEI3G05ZaLdF7qvGgw4Qp17fW0FdMsVsRA86poRZtF
	 1pziLS+nXwDcqGpzSofIikpUtKYFejgWZXDkR8lk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241113053026epcas5p25da0323c52a6b642c5beda9d01df8a47~HcBc1Ni8X2725127251epcas5p2u;
	Wed, 13 Nov 2024 05:30:26 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XpBh20lnjz4x9Q5; Wed, 13 Nov
	2024 05:30:26 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C2.2B.09420.C6934376; Wed, 13 Nov 2024 14:30:20 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241113052729epcas5p1974aa07265d274d2e92839f45cf0acc4~Hb_4NZkaX2807928079epcas5p1p;
	Wed, 13 Nov 2024 05:27:29 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241113052729epsmtrp11418e1daf7b826e7a78b5f100ce1b1c3~Hb_4M1Svf2732827328epsmtrp1i;
	Wed, 13 Nov 2024 05:27:29 +0000 (GMT)
X-AuditID: b6c32a49-33dfa700000024cc-51-6734396c6d55
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	B6.97.18937.1C834376; Wed, 13 Nov 2024 14:27:29 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241113052729epsmtip1323f87a9609d5cbdb97c65dc2a7398c5~Hb_3lsMun3113331133epsmtip18;
	Wed, 13 Nov 2024 05:27:29 +0000 (GMT)
Date: Wed, 13 Nov 2024 10:49:42 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, xue01.he@samsung.com
Subject: Re: [PATCH 1/1] io_uring: fix invalid hybrid polling ctx leaks
Message-ID: <20241113051942.wn7ltls7jhcm4akh@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <b57f2608088020501d352fcdeebdb949e281d65b.1731468230.git.asml.silence@gmail.com>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsWy7bCmlm6OpUm6wdvlkhZzVm1jtHjXeo7F
	ouvCKTYHZo+ds+6ye/RtWcXo8XmTXABzVLZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGu
	oaWFuZJCXmJuqq2Si0+ArltmDtAiJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6B
	SYFecWJucWleul5eaomVoYGBkSlQYUJ2xttpyxgL/jFVzF2n3sB4n6mLkZNDQsBE4vSny8xd
	jFwcQgK7GSWWr9nBBOF8YpQ4NHkBC5yzp+EyK0zLoTu9bBCJnYwSjxZchmp5xijx4PYtZpAq
	FgFViRM3m8BsNgF1iSPPWxlBbBEBbYnX1w+xg9jMAkYSu1cfBrOFBdwlmnbsBNvAK2Am8WDy
	GxYIW1Di5MwnYDanQKzE/PeXwGxRARmJGUu/gh0uIXCMXaLz+XWo81wkznx4wgxhC0u8Or6F
	HcKWknjZ3wZlp0v8uPwUGgIFEs3H9jFC2PYSraf6mSGOy5C4cOAzC0RcVmLqqXVMEHE+id7f
	T6B6eSV2zIOxlSTaV86BsiUk9p5rALI5gGwPie3n0kHCQgIbGCV2TvWawCg/C8lrs5Bsg7Ct
	JDo/NLHOAupmFpCWWP6PA8LUlFi/S38BI+sqRsnUguLc9NRi0wLDvNRyeHwn5+duYgQnQy3P
	HYx3H3zQO8TIxMF4iFGCg1lJhPeUs3G6EG9KYmVValF+fFFpTmrxIUZTYFRNZJYSTc4HpuO8
	knhDE0sDEzMzMxNLYzNDJXHe161zU4QE0hNLUrNTUwtSi2D6mDg4pRqY3H597Jk/0ZIjfrlF
	z8mWb3vyEyZNXycWdpp19k9dRQ6NaT8en+K4zrTx0PPLzOJL/hz6nVx1wvZP6FEHh8lnve2m
	bZ7iNOWHa5d62dfmI+ZGHct2lndbev/+cujKQv+l/NsWHWlpbTrRxvet7TVH9ievdl5+5g0T
	J4jdFGj30Lqxk6Xx4Q7dyiUnWBnNpN6KnJMzqckTirAO2t91L+pZbaNdZImzVIvY3g6LOU9j
	T7gEcMr9EF/V/9Ez/i/zFrOa/qdKfhIPnOtfcszr/TfDxCbpaOW+C95m7u3W882WnziY57NY
	/jF/8/sXt3cf2qOwdv35U6+ntVepO2eZsOxteMzjWKHWVcVauzDopMgBJZbijERDLeai4kQA
	H1L5dg8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWy7bCSnO5BC5N0g6MTzCzmrNrGaPGu9RyL
	RdeFU2wOzB47Z91l9+jbsorR4/MmuQDmKC6blNSczLLUIn27BK6Mmw/msxcYVLxtX8TawKjd
	xcjJISFgInHoTi9bFyMXh5DAdkaJNx8fsEAkJCROvVzGCGELS6z895wdougJo8Teo3fZQRIs
	AqoSJ242MYPYbALqEkeet4I1iAhoS7y+fgishlnASGL36sNgtrCAu0TTjp2sIDavgJnEg8lv
	gJZxAA2NkTj30BQiLChxcuYTFohWM4l5mx8yg5QwC0hLLP/HARLmFIiVmP/+EliJqICMxIyl
	X5knMArOQtI9C0n3LITuBYzMqxhFUwuKc9NzkwsM9YoTc4tL89L1kvNzNzGCA1craAfjsvV/
	9Q4xMnEwHmKU4GBWEuE95WycLsSbklhZlVqUH19UmpNafIhRmoNFSZxXOaczRUggPbEkNTs1
	tSC1CCbLxMEp1cCUPV/n4Qp1l5ZH/kEp4ifCn9W95nt9oMXJ32yaXO+EBL6/MYe+r40tTWtc
	FGa/bVO81o8j947FXVDdMnvW74ldxdv03mx7sU817tI5yfML3i+fMq+nd/vSTBUDwcVXFc+b
	zrO5IKa6uJYncsPGsCP7jrL9TP20KjBxzVyR9l3rlW78ll5wwHj+jCW5tmUPLaw2VD/eXefK
	8ZOX9Z3mVBdGs60xrHGei25+3rbnaaqKt9ylz/bJ/RncK1Ll/+5Scjr475DizX+/oz++rUlk
	DJH79G+DDIvX7fjDCdMeH3QT5b00I09ua4ajwCybp691d8paV/A7a5jF6txYs99e+cEB3i+X
	jOIbHpbPPKucXD3vrxJLcUaioRZzUXEiAGu8BPnLAgAA
X-CMS-MailID: 20241113052729epcas5p1974aa07265d274d2e92839f45cf0acc4
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----4Q1Zi_KIf9_.4xoFwoas6UvdQHcFnkls7nqrl97Ci5BoFZ08=_c60a2_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241113052729epcas5p1974aa07265d274d2e92839f45cf0acc4
References: <b57f2608088020501d352fcdeebdb949e281d65b.1731468230.git.asml.silence@gmail.com>
	<CGME20241113052729epcas5p1974aa07265d274d2e92839f45cf0acc4@epcas5p1.samsung.com>

------4Q1Zi_KIf9_.4xoFwoas6UvdQHcFnkls7nqrl97Ci5BoFZ08=_c60a2_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

------4Q1Zi_KIf9_.4xoFwoas6UvdQHcFnkls7nqrl97Ci5BoFZ08=_c60a2_
Content-Type: text/plain; charset="utf-8"


------4Q1Zi_KIf9_.4xoFwoas6UvdQHcFnkls7nqrl97Ci5BoFZ08=_c60a2_--

