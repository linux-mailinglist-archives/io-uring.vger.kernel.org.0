Return-Path: <io-uring+bounces-1796-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C915F8BDAA2
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 07:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A8E32852D9
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 05:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F6F2744D;
	Tue,  7 May 2024 05:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qL2BIh1h"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B526BB4E
	for <io-uring@vger.kernel.org>; Tue,  7 May 2024 05:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715059435; cv=none; b=RA+lCxkP+K0QKpJO3Qh+vz7SkxTbtZtdg78h4EWRj+1fxjCqmUt8LwnZvlXEyPAD9QNkLxLFmD12HRY1Gg3MyCSnjTQQAV4iXjQrMUnslx6uTmC69ulP6aqah3ZPYnKhudJ0fG38plU7j5gOr+1SGGSnIqncgCH1hwPaTyj/xDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715059435; c=relaxed/simple;
	bh=rw1WD8iW0Gin6xrr/ze+7VZddUt6rFngb7Xf/Hf/NyU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Zzi7B2HKlj+hS8WfSS2cv0qAoVW2UWq+y0XId69IG7/VFlXoGOCZ9NJUjGZEy2VV/LLU309dkVW/LCciE6v42wmAw25P5Mu4pG9jFAcaE5vGTkH3XH9mhKAGVcgut/Zrt0i9ZI/BROyC6XEtxVOuF819WZv6/9ZUSGd9FKGHKm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qL2BIh1h; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240507052349epoutp0255eabb86f37ffd9ab0be6ea900567899~NHXbuwkE70043100431epoutp02w
	for <io-uring@vger.kernel.org>; Tue,  7 May 2024 05:23:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240507052349epoutp0255eabb86f37ffd9ab0be6ea900567899~NHXbuwkE70043100431epoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715059429;
	bh=eLSWL99Uk2hAz/dS69zc+plpzQva2XWJGmy85zm1bw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qL2BIh1h16G9HTz2nd1pylvnymLz0PDVPwidNxOG6BNKGiOepmJ4NXbexkI3H1iB3
	 RN++JVBBOJwxc3wfQjPXaoccqt0gLtRaIc7g0eSmAJaByyQqHsN8Htgb3D8ReTQ9RU
	 YJF6tl62DMayR2jpdZljxWj4SFeDiRtUYAxmoXi8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240507052349epcas5p46bd9f56be2888b628cd91add6763f454~NHXbV55eN0641106411epcas5p4I;
	Tue,  7 May 2024 05:23:49 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VYRX40d2cz4x9QF; Tue,  7 May
	2024 05:23:48 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DB.96.09665.3EAB9366; Tue,  7 May 2024 14:23:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240507052214epcas5p351e1ff563e3d62bf1fff305dccc1905c~NHWCwn0zA2998529985epcas5p3f;
	Tue,  7 May 2024 05:22:14 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240507052214epsmtrp2e601e6ceb4c3eddd58d0bb9ddc50a35e~NHWCv7nyU0876208762epsmtrp2t;
	Tue,  7 May 2024 05:22:14 +0000 (GMT)
X-AuditID: b6c32a4b-5cdff700000025c1-e7-6639bae3e951
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	66.D4.08390.68AB9366; Tue,  7 May 2024 14:22:14 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240507052213epsmtip21f1e5c1752b1be67e1da93dc2a912ef9~NHWB2xYii1163211632epsmtip2X;
	Tue,  7 May 2024 05:22:13 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, cliang01.li@samsung.com, gost.dev@samsung.com,
	io-uring@vger.kernel.org, joshi.k@samsung.com, kundan.kumar@samsung.com,
	linux-kernel@vger.kernel.org, peiwei.li@samsung.com
Subject: Re: [PATCH] io_uring/rsrc: Add support for multi-folio buffer
 coalescing
Date: Tue,  7 May 2024 13:22:03 +0800
Message-Id: <20240507052203.67459-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <71c1f01f-f740-43b0-9962-afcf08cab686@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmpu7jXZZpBvseyVvMWbWN0WL13X42
	i9N/H7NY3Dywk8niXes5Fouj/9+yWWz98pXV4vKuOWwWz/ZyOnB67Jx1l93j8tlSj74tqxg9
	Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
	AbpESaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBg
	ZApUmJCd0bRrL2tBG0fF1Fvn2RsYl7B1MXJwSAiYSLw6qdjFyMUhJLCbUeLO/p/sEM4nRomu
	s0fZIJxvjBJHd85jhel4eIwLIr6XUeLI/2tQHb8YJSbO+MfUxcjJwSagI/F7xS8WEFtEQFhi
	f0crC0gRs8BpRol9R3+wgSSEBYIlDrW/ALNZBFQlep6tB2vmFbCRaGvYDBaXEJCX2H/wLDOI
	zSlgK7H1z2d2iBpBiZMzn4AtYAaqad46mxlkgYTAR3aJVb19TBDNLhIzHx6HGiQs8er4FnYI
	W0ri87u90AAolli2Tg6it4VR4v27OYwQNdYS/67sYQGpYRbQlFi/Sx8iLCsx9dQ6Joi9fBK9
	v59AreKV2DEPxlaVuHBwG9QqaYm1E7YyQ9geEouX34EG6QRGiaU991gnMCrMQvLPLCT/zEJY
	vYCReRWjZGpBcW56arFpgXFeajk8lpPzczcxglOnlvcOxkcPPugdYmTiYDzEKMHBrCTCe7Td
	PE2INyWxsiq1KD++qDQntfgQoykwwCcyS4km5wOTd15JvKGJpYGJmZmZiaWxmaGSOO/r1rkp
	QgLpiSWp2ampBalFMH1MHJxSDUw6DWvfa/IkSTbd9nRUi7vyokz65Iq6yx/PZirdEZ6YpdpV
	ss9HY97jTltp/8/1lQ7tB8sn3/zo4LYgba2AqXmVyIkv6st8F7RO2h/DzXEnd9kjNxWeg0/b
	mg+wT/tnvW/S1IuTdkz7Ylk/OdT3+u5Zxq9UrszWYrdNVXqblGDclf/3x2H/f89254tM5lsu
	r/9w/6WYuez3J0cvTeg8Ld1s6bNSzXplXsy660x988IrFz76Pudx3qqwyG3ySbemdnr+5Lqw
	ZNNKjbKQHWquIvt2z2fukP08Wdwx5VBB/GF+DZfzRh4Lb15M12va9W7ajV83niyrO7Lj9IlF
	8bN/LOotmbKsq2li86uV7o43vjx/pcRSnJFoqMVcVJwIAJpWiH0mBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWy7bCSvG7bLss0g2NHWCzmrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLLZ++cpqcXnXHDaLZ3s5HTg9ds66y+5x+WypR9+WVYwe
	nzfJBbBEcdmkpOZklqUW6dslcGU07drLWtDGUTH11nn2BsYlbF2MHBwSAiYSD49xdTFycQgJ
	7GaU6J63gLGLkRMoLi3RcaiVHcIWllj57zmYLSTwg1Hi3TJREJtNQEfi94pfLCC2CFDN/o5W
	FpBBzAJXGSW2nlnLBpIQFgiUWPLzPzOIzSKgKtHzbD0TiM0rYCPR1rCZDWKBvMT+g2fBajgF
	bCW2/vkMtcxG4t3WQ8wQ9YISJ2c+AVvGDFTfvHU28wRGgVlIUrOQpBYwMq1ilEwtKM5Nzy02
	LDDKSy3XK07MLS7NS9dLzs/dxAgObS2tHYx7Vn3QO8TIxMF4iFGCg1lJhPdou3maEG9KYmVV
	alF+fFFpTmrxIUZpDhYlcd5vr3tThATSE0tSs1NTC1KLYLJMHJxSDUzHFu5VZM7eNU9gzp+P
	qrzWyzJUWc5r9NUvm8CwY/YR12u3uk152JYWHNqY0Cem6xSTXNh7UGPtpbqNC5jzPzY+nvH5
	qNKC4pW9wUsL46doVOj+c3I2TWDYH7KC/+C/afVXlhmIVf49OX/K1CdhVa2syY+c3P/Nr7wT
	8+7q5jm5B2cdXNq8I3TZ9P+eNzf3f4idccrhT4Kw/8l253tHNpfMX/0kwej0mXveP1n1rTqO
	6M69HB6XdGBK5o8eZpe6sN9cMjWb/Z6aPmYI2nRs18tMvWvnlUuX5NZ63bzcpPPlzutVy5ya
	/q3eZJMY0qP58/7X4y+zql55yGWm2f26UZp8STfZSt+2tr3yh9bUSUdilFiKMxINtZiLihMB
	IMa+5twCAAA=
X-CMS-MailID: 20240507052214epcas5p351e1ff563e3d62bf1fff305dccc1905c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240507052214epcas5p351e1ff563e3d62bf1fff305dccc1905c
References: <71c1f01f-f740-43b0-9962-afcf08cab686@kernel.dk>
	<CGME20240507052214epcas5p351e1ff563e3d62bf1fff305dccc1905c@epcas5p3.samsung.com>

On 5/6/24 6:57 AM, Jens Axboe wrote:
> Can you add some justification to this commit message? A good commit
> message should basically be the WHY of why this commit exists in the
> first place. Your commit message just explains what the patch does,
> which I can just read the code to see for myself.
> 
> As it stands, it's not clear to me or anyone casually reading this
> commit message why the change is being done in the first place.

Thank you for the instruction. I'll submit a V2 patchset with better
commit message.

> Outside of that, you probably want to split this into two parts - one
> that adds the helper for the existing code, then one that modifies it
> for your change. We need this to be as simple as possible to review, as
> we've had a security issue with page coalescing in this code in the
> past.

Will split this in V2.

> Minor comments below, will wait with a full review until this is split
> to be more easily reviewable.

Thank you for the comments. Will address them in V2.

