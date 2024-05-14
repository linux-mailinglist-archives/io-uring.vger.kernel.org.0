Return-Path: <io-uring+bounces-1897-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04EEA8C4A9A
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 02:49:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56004B236D2
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 00:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A078EDC;
	Tue, 14 May 2024 00:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="L7YsUCBX"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A6FA34
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 00:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715647764; cv=none; b=kzcM3h43hRMT0+ZqI1hmgyXqoYsYAsGCGNylSrHFymr1mf8UMEspVa5dmdf7KRj+aCDURnb9WkKAFtulUcdVtIPg7Uj8zOhNJxi+pKpa+74CtFAyJVJFxAdIO6iNm4VHTLkt1J8FYt39ncsZJC7iY0OX9aiVcSnfePlJCYVoUAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715647764; c=relaxed/simple;
	bh=HYckqs1xcyDJbcOax5Nwyad6bGQVjWLc/h+LF5w1xmU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=XLXKYN/35eF52xzWHg93J8jZSPChTaWYAXlBum88A3PynUffcRHYRLahGwqmSquSdQT3IE/NCGhes9c/gYesUVlISJbsgNvsVc892AwKj75LSa03rJo/6QY22t7+oEUUzXfOxLk8hO4igR330sidLFFKguXOtNYKw85CPhrOfFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=L7YsUCBX; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240514004919epoutp04a06cb007e0a5a8598f351245c3a8a95f~PNIwcRV6I1173811738epoutp04q
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 00:49:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240514004919epoutp04a06cb007e0a5a8598f351245c3a8a95f~PNIwcRV6I1173811738epoutp04q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715647759;
	bh=HYckqs1xcyDJbcOax5Nwyad6bGQVjWLc/h+LF5w1xmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7YsUCBXvxMY3uMblm40WkmnltqWM6jShgOWrVUh6U7VJz4L/NMietSV9xF2gyPw1
	 CoDiNWZPpu+n5IEEbqpk+9/rib7XnksKnK8cYZuauYnuIA7PURix6rbBfKIDHrl+7c
	 r4mZVmJXzuxOlRHXngZjzKrPLjGpNmbQaWFHSVOc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240514004918epcas5p28a465944c61bc1229e27bf98384505d2~PNIv-gQnK1087610876epcas5p2w;
	Tue, 14 May 2024 00:49:18 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Vdd653l4cz4x9Pw; Tue, 14 May
	2024 00:49:17 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	64.E2.09666.D05B2466; Tue, 14 May 2024 09:49:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240514001813epcas5p455c8a3dd6f2164626a526c05f7fd92c4~PMtmOUOiD0554305543epcas5p4V;
	Tue, 14 May 2024 00:18:13 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240514001813epsmtrp2c5fd41df156d1d72501bc19ae6566cf1~PMtmNfg5i0574005740epsmtrp2Y;
	Tue, 14 May 2024 00:18:13 +0000 (GMT)
X-AuditID: b6c32a49-cefff700000025c2-3a-6642b50d0e45
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5E.1C.08390.4CDA2466; Tue, 14 May 2024 09:18:12 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240514001811epsmtip131bef453c08bee4843f6ca45ff19813c~PMtlL8nP52302823028epsmtip1-;
	Tue, 14 May 2024 00:18:11 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk
Cc: anuj1072538@gmail.com, asml.silence@gmail.com, cliang01.li@samsung.com,
	gost.dev@samsung.com, io-uring@vger.kernel.org, joshi.k@samsung.com,
	kundan.kumar@samsung.com, peiwei.li@samsung.com
Subject: Re: [PATCH v3 0/5] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
Date: Tue, 14 May 2024 08:18:07 +0800
Message-Id: <20240514001807.566346-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <76621ef7-8d0a-47d9-bc64-405f9277a336@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmui7vVqc0gwtHxC0+fv3NYjFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAlqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWl
	eel6eaklVoYGBkamQIUJ2RnLvs5kLbjCVHFsxRTGBsYpTF2MnBwSAiYST79PYe5i5OIQEtjN
	KPHyzGxGCOcTo8SZxQvZIJxvjBJPFixigWmZtXM7C0RiL6PEq4ePoKp+MUoce9MONphNQEfi
	94pfYB0iAsIS+ztawTqYBY4wSlx9vB1oIweHsECkxN2vYPUsAqoSVy5vZAcJ8wrYStx8yAex
	TF5i/8GzzCA2J1D4+JSpYCN5BQQlTs58AmYzA9U0b50N9oOEwE92iXMN36AudZG40whztbDE
	q+Nb2CFsKYnP7/aygeySECiWWLZODqK3hVHi/bs5jBA11hL/ruxhAalhFtCUWL9LHyIsKzH1
	1DomiL18Er2/n0DDkVdixzwYW1XiwsFtUKukJdZO2MoMscpD4tu/eEhQTWCUmLjpOuMERoVZ
	SN6ZheSdWQibFzAyr2KUTC0ozk1PLTYtMMxLLYdHcnJ+7iZGcDLV8tzBePfBB71DjEwcjIcY
	JTiYlUR4HQrt04R4UxIrq1KL8uOLSnNSiw8xmgKDeyKzlGhyPjCd55XEG5pYGpiYmZmZWBqb
	GSqJ875unZsiJJCeWJKanZpakFoE08fEwSnVwGQi1qDRVi1b6DVJRqrr6JvZ98vW6j93XLJk
	/5mcNLmk+XqNaiXpC3imHZwkkLRB7IsKq9y3OC4D9Yd/FK3NQtem+ja/My78Znvqv8P1/z81
	Hn7omnNixse1jp8eGC3s/lAudXft2SWSPec6Dx95NfsqY86s4xw/vcX1v8x0DP38Z6/Ddt6e
	PJttjzfe5PLc8IAhvsvo6P7qabwXmtuOdJ123HFZif/Llok7p9Zs6rqQuSRMrbrLi5khMHWr
	+fqTN1JdtifrpDJZCcRL8xZtsSoyTuDXnLdH6PfZGnv3zc/NJQpFVt6zPN6ZFVB91GqyztOD
	SfEvN14R827I4+vRyf8RuD8lQVrv2CoOmy97y5VYijMSDbWYi4oTAfBIU04vBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWy7bCSnO6RtU5pBlO/WVh8/PqbxWLOqm2M
	Fqvv9rNZnP77mMXi5oGdTBbvWs+xWBz9/5bN4lf3XUaLrV++slo828tpcXbCB1YHbo+ds+6y
	e1w+W+rRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGcu+zmQtuMJUcWzFFMYGxilMXYycHBIC
	JhKzdm5n6WLk4hAS2M0ocXbfBqiEtETHoVZ2CFtYYuW/5+wQRT8YJT7NWgOWYBPQkfi94hcL
	iC0CVLS/oxXMZhY4xyhx/lUsiC0sEC7R9eMzWJxFQFXiyuWNQL0cHLwCthI3H/JBzJeX2H/w
	LDOIzQkUPj5lKli5kICNxNOPh8Du4RUQlDg58wnUeHmJ5q2zmScwCsxCkpqFJLWAkWkVo2Rq
	QXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZwuGtp7WDcs+qD3iFGJg7GQ4wSHMxKIrwOhfZp
	QrwpiZVVqUX58UWlOanFhxilOViUxHm/ve5NERJITyxJzU5NLUgtgskycXBKNTBtvdzo9r90
	zt0pNtuuTl8Wf2fVAi3bf7f13O9Pib++/32vbwnXrUrmlCL3/7MsnLidj2o7p0zk+siuK7vE
	b7d+QWr6udzSWIEUde7/B6bf17Ao0mjX8+e7wpk7+fCnzbn7Hk+ecjknwWmDZVf4pYBj0R16
	Z1OYHucIzHPM8Nuf8eCz4PsmYTu+6zcCDP9x3t1odX+p7BOva10Bs2LnnIl/Im9ftz6ek/3c
	Kqsl31U3VL3cekuiefPqlIiu55vdRA4mlPVs/8fbvMXqV95mLsl/s99qGbR++++dtGvixIPK
	YU+X+7XvzKn/4z9Fgn9euWF4S4NParNsykaO5W87qlrfJl2sUJUsNDy0dsl98QglluKMREMt
	5qLiRABNaNW+5gIAAA==
X-CMS-MailID: 20240514001813epcas5p455c8a3dd6f2164626a526c05f7fd92c4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240514001813epcas5p455c8a3dd6f2164626a526c05f7fd92c4
References: <76621ef7-8d0a-47d9-bc64-405f9277a336@kernel.dk>
	<CGME20240514001813epcas5p455c8a3dd6f2164626a526c05f7fd92c4@epcas5p4.samsung.com>

On Mon, 13 May 2024 07:40:13 -0600, Jens Axboe wrote:
> Yes, please just send a separate series/patch for both liburing and fio.
> This series should be strictly the kernel side changes required, then
> reference/link the postings for the t/io_uring and liburing test case(s)
> in the cover letter.

Sure, will send them separately.

