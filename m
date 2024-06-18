Return-Path: <io-uring+bounces-2243-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 286EA90C286
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 05:39:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44C7E284601
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 03:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5767633C9;
	Tue, 18 Jun 2024 03:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CVW6DEt7"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37F517BD3
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 03:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718681965; cv=none; b=topbKcCf3Hf/Dw7083iOHk33ZzImZmeJNlDeW3sqbr7cMROJWv83nmy6GlAE9vbFau0YadedsravUhhLQqwXyZWsBsa+1TIW8u70piz0BHjy3FprM73S4jeYhZvxSgSNum5tn+VOC8abliMQfwUgx7Ty10PTv5XIdaqg2/gbZBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718681965; c=relaxed/simple;
	bh=GOmXc5Eb6YtR3dTrqLJhST7YPBxaiJpcn7/4SkizI1I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Tihb8K6+MMioPgxYsEUyEmRWaT5NdCa+CzKpnJ7IHIYQaBVSlbdOVPSXHdbvrISUi6lV+wso7iitjNCv0cJZhL5Cib6wbu7PL8jA6ok4t7xLQh0gJuEEBA02cq/yqq3OBBjuOpuQurUwYekwKJiMooaqOhGvTgkHOkXztIl94CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=CVW6DEt7; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240618033915epoutp0436a4dd62ce789621bf4b8023a7393412~Z-CHgQJUG0658106581epoutp04F
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 03:39:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240618033915epoutp0436a4dd62ce789621bf4b8023a7393412~Z-CHgQJUG0658106581epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718681955;
	bh=GOmXc5Eb6YtR3dTrqLJhST7YPBxaiJpcn7/4SkizI1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVW6DEt7pwXYIKtSqMvpmgKSObP14KED/ruOVIjuXHuM63UaLgSd7BmIkbd5O9mIO
	 uAEQ2FqHxdUXItPFQF+AhbItm+dMXDLe7Pkmwv3G86/GayWPNOLYktD6Vg45J09fzn
	 xPx4qpvp9Kyaw/BsCZCoCVUA6nxFgk6lKuwg++hE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240618033914epcas5p315530dc30947cec22843013a8e75b15d~Z-CHAzRac0325703257epcas5p3O;
	Tue, 18 Jun 2024 03:39:14 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4W3CD12ncvz4x9Q1; Tue, 18 Jun
	2024 03:39:13 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E9.5A.06857.16101766; Tue, 18 Jun 2024 12:39:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240618032433epcas5p258e5fe6863a91a1f6243f3408b3378f9~Z_1SBMvX22228722287epcas5p2u;
	Tue, 18 Jun 2024 03:24:33 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240618032433epsmtrp193f91aa5c669e5f0800ad123a528cde8~Z_1SAVAga1686516865epsmtrp1_;
	Tue, 18 Jun 2024 03:24:33 +0000 (GMT)
X-AuditID: b6c32a4b-88bff70000021ac9-0e-6671016103f5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0A.29.08336.0FDF0766; Tue, 18 Jun 2024 12:24:32 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240618032431epsmtip11e649e4430d44e795f448368ef8b82dc~Z_1Qva_mP0369103691epsmtip1E;
	Tue, 18 Jun 2024 03:24:31 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: asml.silence@gmail.com
Cc: anuj20.g@samsung.com, axboe@kernel.dk, cliang01.li@samsung.com,
	gost.dev@samsung.com, io-uring@vger.kernel.org, joshi.k@samsung.com,
	kundan.kumar@samsung.com, peiwei.li@samsung.com
Subject: Re: [PATCH v4 3/4] io_uring/rsrc: add init and account functions
 for coalesced imus
Date: Tue, 18 Jun 2024 11:24:26 +0800
Message-Id: <20240618032426.2189-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <6b4b27c4-1b71-49f9-bb85-8bad2a5a4170@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsWy7bCmhm4iY2GawaS5QhZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFp
	XrpeXmqJlaGBgZEpUGFCdsb7Y2eYCnYwVXze85a9gfErYxcjJ4eEgIlE/9oeVhBbSGA3o8Sk
	v+JdjFxA9idGiVft/ewQzjdGift921lgOl7/XsEKkdjLKHH901smCKeJSeL6wsVMIFVsAjoS
	v1f8Aurg4BARkJL4fZcDpIZZYA+jxMbFi9hAaoQF4iRm79oBZrMIqEpsPrUZ7A5eAWuJLZtf
	s0Fsk5fYf/AsM4jNKWArcXr1a0aIGkGJkzOfgF3EDFTTvHU2M8gCCYFGDoltG8+yQjS7SPS+
	PMsOYQtLvDq+BcqWknjZ38YOcpyEQLHEsnVyEL0tjBLv382BBoy1xL8re8AeYBbQlFi/Sx8i
	LCsx9dQ6Joi9fBK9v58wQcR5JXbMg7FVJS4c3Aa1Slpi7YStzBC2h8TSl9OggTWBUeJlz3zW
	CYwKs5D8MwvJP7MQVi9gZF7FKJlaUJybnlpsWmCcl1oOj+Xk/NxNjOB0quW9g/HRgw96hxiZ
	OBgPMUpwMCuJ8DpNy0sT4k1JrKxKLcqPLyrNSS0+xGgKDPCJzFKiyfnAhJ5XEm9oYmlgYmZm
	ZmJpbGaoJM77unVuipBAemJJanZqakFqEUwfEwenVAOTy5QDAvvrZ4rzlkmK8ZzhnGB9frWz
	g9TdG+xvJVRV1LbJsuRnbUnYdXrZx/9MJycd1c1z/d60lO1abJzQB/UlhVws208FZd/ez7+q
	JvWd5sOzt4+9DxefXvronZjHXpFJubuivcUvX18RqSa6kq+XO9vmhsbtm3wXK9TKEnt7zM8J
	JawJkt0f1PWWa5qJlIgEl+D9WRb/+mef57KyWMG+WtH5EcuGC30LpjVov/q/etbClar97sV3
	zp+acEhK8UDV3YPxkxX6ZXPebdl+h71Frb5CwrNk72QPu2vGLu3lHrE6qa9WM9rOUrfYsspB
	7h3zh0mr3y7z4bHWXe1Q6ui37mjzJedFAq/eLrQ82vdHiaU4I9FQi7moOBEA5HHlRTAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWy7bCSnO7HvwVpBg8fMlo0TfjLbDFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujPfHzjAV7GCq+LznLXsD41fGLkZODgkB
	E4nXv1ewdjFycQgJ7GaU6N63nhkiIS3RcaiVHcIWllj57zk7RFEDk8SXT7PBitgEdCR+r/jF
	0sXIwSEiICXx+y4HSA2zwDFGiRnf7rKA1AgLxEjsaGxgA7FZBFQlNp/azApi8wpYS2zZ/JoN
	YoG8xP6DZ8FmcgrYSpxe/RrsOiEBG4nni14xQ9QLSpyc+QRsJjNQffPW2cwTGAVmIUnNQpJa
	wMi0ilEytaA4Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMjOOC1NHcwbl/1Qe8QIxMH4yFGCQ5m
	JRFep2l5aUK8KYmVValF+fFFpTmpxYcYpTlYlMR5xV/0pggJpCeWpGanphakFsFkmTg4pRqY
	5j+4Z3padL9bL2P7ozU7HffuET55ynajx7f3r+7b56apvxZwijf8ey309P970peK9/gZfe9N
	WBS05NtiExcWa/eK0127mwKZIqNifZ+mLPG8s/HBt2/JvDd6A/WnVf5kmizrnvY05pebiq6C
	h7qB7Vk352lKDwReZkosMjbhmLXGq2anh/hXdu8nYQpOz+MDSjfd5Yw78vTirz49hpTznTHb
	1tlNPam+rHCl4AmZck/N0s3fX3162HImxFfghXhmhte2U8dttoQpdM+OemWjnPyhvOkN26qb
	jJwL7j2d1hLBY3AteO2trenPqosY3CeWr/4Ro+BwTSiwU3yaGs+HacE+swKvv3gY/WjbRRd5
	JZbijERDLeai4kQAPbPEu+cCAAA=
X-CMS-MailID: 20240618032433epcas5p258e5fe6863a91a1f6243f3408b3378f9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240618032433epcas5p258e5fe6863a91a1f6243f3408b3378f9
References: <6b4b27c4-1b71-49f9-bb85-8bad2a5a4170@gmail.com>
	<CGME20240618032433epcas5p258e5fe6863a91a1f6243f3408b3378f9@epcas5p2.samsung.com>

On Mon, 17 Jun 2024 13:22:43 +0100, Pavel Begunkov wrote:
> On 6/17/24 04:16, Chenliang Li wrote:
>> Actually here it does account an entire folio. The j is just
>> array index.
>
> Hmm, indeed. Is iteration the only difference here?

Yes, but I'll try make this less confusing.

Thanks,
Chenliang Li

