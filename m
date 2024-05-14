Return-Path: <io-uring+bounces-1895-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EFAE8C4A98
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 02:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB2911F234E8
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 00:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A447A29;
	Tue, 14 May 2024 00:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WkJ0px44"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF5E1852
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 00:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715647733; cv=none; b=AQplrEIQXFJVaaxqlXWy5P4Ckomrvn+znKLJtMhqn3hFSGkMtfai2jelOuSSVjqA4sCMsWEAWv5wkeRGq7sL7/4+0kwu/TlFIlI2ZpgJ0/x4gTCOeUmuo2sgqBLl6f5ujVdnb9B8te4sJghDZoRTXLYed2S0dCMfOG+cPbXPiig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715647733; c=relaxed/simple;
	bh=NLoKTt2ugJaI96plhbt/LIs0brSW4OwXJn1R/jNhXhc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=mRwqkc7FlFi+JbDBrcZGIxy66NXAOkBSITkgenF/9iMOj7WPX+2sV/Z68BPrfR4eM4R9GBEGOk1YyXmZgQqyAp9r6ZbXW09h3uzF6OKT4an5yrQlJ3zFNvKfZzDaGFpmajtMfzrSnTIiFQRWd1+ECzLMQMwGlz437buL8YSGh6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WkJ0px44; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240514004847epoutp013c208dec68aa1cdf04f48b1cc6443298~PNIS9ryzd1983319833epoutp01j
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 00:48:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240514004847epoutp013c208dec68aa1cdf04f48b1cc6443298~PNIS9ryzd1983319833epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715647727;
	bh=NLoKTt2ugJaI96plhbt/LIs0brSW4OwXJn1R/jNhXhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkJ0px44o5fraRqtEgdwbys3lM0NAVuO3sRUsErnE5dVOQiWui7mOdtASPGNSlkEV
	 01BoB2v1F20z+DcvAjtSAQky7wMSpfl8gIKDhQ9wsff5vXe9S5FWunhJLZUh6tsqGk
	 fJvbdLAyHMT9vdIOmyHVxuDkKvb6sDBfAmrrgxOE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240514004847epcas5p196de6bdc81f64f71426545b3eef4a910~PNIShRonY0782007820epcas5p1Z;
	Tue, 14 May 2024 00:48:47 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Vdd5T4Gs9z4x9Q2; Tue, 14 May
	2024 00:48:45 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C0.0A.19431.DE4B2466; Tue, 14 May 2024 09:48:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240514001443epcas5p362c60c233ed2aecdb5e144099b44d9be~PMqiu7jif2237322373epcas5p3v;
	Tue, 14 May 2024 00:14:43 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240514001443epsmtrp2a167e48f869d5f003a618b4669e02a64~PMqitxSxp0343603436epsmtrp2-;
	Tue, 14 May 2024 00:14:43 +0000 (GMT)
X-AuditID: b6c32a50-f57ff70000004be7-63-6642b4ed6df5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	21.CB.08924.3FCA2466; Tue, 14 May 2024 09:14:43 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240514001442epsmtip170010857f75a0f0eae1fda4e5e97bb6d~PMqhs3IVG2169521695epsmtip1U;
	Tue, 14 May 2024 00:14:41 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: anuj1072538@gmail.com
Cc: asml.silence@gmail.com, axboe@kernel.dk, cliang01.li@samsung.com,
	gost.dev@samsung.com, io-uring@vger.kernel.org, joshi.k@samsung.com,
	kundan.kumar@samsung.com, peiwei.li@samsung.com
Subject: Re: [PATCH v3 4/5] io_uring/rsrc: enable multi-hugepage buffer
 coalescing
Date: Tue, 14 May 2024 08:14:38 +0800
Message-Id: <20240514001438.566160-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CACzX3At7k+kspDrzz-=HhFGHpcgi+O8S6D+fPND7imfiodHTOg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmhu7bLU5pBjunKFh8/PqbxWLOqm2M
	Fqvv9rNZnP77mMXi5oGdTBbvWs+xWBz9/5bN4lf3XUaLrV++slo828tpcXbCB1YHbo+ds+6y
	e1w+W+rRt2UVo8fnTXIBLFHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJ
	uam2Si4+AbpumTlANykplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCkwK9IoTc4tL
	89L18lJLrAwNDIxMgQoTsjN2f1jEWnCYuWJ57zPWBsZ3TF2MnBwSAiYSJ7vmMnYxcnEICexh
	lFj3dg47hPOJUaL1zA9WCOcbo8TqAwvhWrbOuw9VtZdRYu6PfhYI5xejRMfOa+wgVWwCOhK/
	V/xiAbFFBCQldn48CFbELLCPUeLDzFtgCWGBEIndP/+BjWURUJX4PRviKl4BW4mrF06yQ6yT
	l9h/8CwziM0pEChxtXEWK0SNoMTJmU/A5jAD9XYfecoEYctLNG+dzQyyTEKgk0NiwfQzjBCD
	XCR+bpnNAmELS7w6vgVqgZTE53d72boYOYDsYoll6+QgelsYJd6/mwPVay3x78oeqF5Ziamn
	1kEt45Po/f0EGi68EjvmwdiqEhcOboOaLy2xdsJWZoj5HhJ39gaAmEICSxglprNNYFSYheSb
	WUi+mYXkmwWMzKsYpVILinPTU5NNCwx181LL4fGcnJ+7iRGcUrUCdjCu3vBX7xAjEwfjIUYJ
	DmYlEV6HQvs0Id6UxMqq1KL8+KLSnNTiQ4ymwACfyCwlmpwPTOp5JfGGJpYGJmZmZiaWxmaG
	SuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUwmRlds2N9nqG3Q/jK/uh977MehnLGyj1e2vrG
	+4zQtt7fvr+nVzzPmhEge8Dx9Q+vGH/lI2sSdsvm9jOmBstluTPaRX2Lv3IkZ/WSxZmh7cZS
	Qgef9sf/jfz17uvDJ9+NTC88rDkpHSD1ql3nzoMZ1yftqVET3p6Qu22qSd2Ouks71bU07giV
	20xmiaqfW+SdbX5f1nGJ7pQPbFtifuvLfvq8oSH49faDZZxJ9hdTWU+75WSy2XRu+Prp2f9C
	v8e3nl79vkHgZZA4l0TR2T2pnbv5Izd07be9FWIQ/DD80f2zs9lLpnR9ejVLdftLvcp7r7j3
	eCvvOfLyIrdrgjyP+60Zc790KvnGvKn6V/HIQYmlOCPRUIu5qDgRADWSRQQyBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSnO7nNU5pBq1PmC0+fv3NYjFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujN0fFrEWHGauWN77jLWB8R1TFyMnh4SA
	icTWeffZuxi5OIQEdjNKvFs1iwUiIS3RcaiVHcIWllj57zlU0Q9GiStnlrCBJNgEdCR+r/gF
	1iAiICmx8+NBFpAiZoETjBL990+CdQsLBEn0PpvPDGKzCKhK/J4NsZpXwFbi6oWTUBvkJfYf
	PAtWwykQKHG1cRYriC0kECDxZ+YONoh6QYmTM5+ALWMWUJboOrOMDcKWl2jeOpt5AqPgLCRl
	s5CUzUJStoCReRWjZGpBcW56brFhgWFearlecWJucWleul5yfu4mRnCMaGnuYNy+6oPeIUYm
	DsZDjBIczEoivA6F9mlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEecVf9KYICaQnlqRmp6YWpBbB
	ZJk4OKUamAQeRGt/jd1t2rVvoUJ4UpZ7832JnwXzJv4p26StzJNtX+Wmed8o7SUnn4Xc/bVT
	rDeIxBQbav0/8DLsWqdNy+O6umVNJ40+frKNPq758k9Cls6ce+cFNA57b8nd0XZXaW0gi8Ca
	C8s2pmld/pC0+1Hdpt81U5YzNsjWh36OZU83n66/sNBEpaMn9gDj4u1e5oeCr4Ytbgk1fh6c
	JaPUufCdr8yOtauK3z8/ZmLOURnX9v5D7q3TiyZWRKuJC8t8KRZR3TZlMtvh0OL9J3vj2Zzz
	SvbtlMv4nplvwp2TEby2x69drU2E69fWrM3/TjyfeL3XtmfRglPnGT6JVDr8ieJvTCisVVKa
	FcLzMsBJiaU4I9FQi7moOBEAdZVhxgADAAA=
X-CMS-MailID: 20240514001443epcas5p362c60c233ed2aecdb5e144099b44d9be
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240514001443epcas5p362c60c233ed2aecdb5e144099b44d9be
References: <CACzX3At7k+kspDrzz-=HhFGHpcgi+O8S6D+fPND7imfiodHTOg@mail.gmail.com>
	<CGME20240514001443epcas5p362c60c233ed2aecdb5e144099b44d9be@epcas5p3.samsung.com>

On Mon, 13 May 2024 17:41:14 +0530, Anuj Gupta wrote:
> On Mon, May 13, 2024 at 2:04 PM Chenliang Li <cliang01.li@samsung.com> wrote:
>>
>> Modify the original buffer registration path to expand the
>> one-hugepage coalescing feature to work with multi-hugepage
>> buffers. Separated from previous patches to make it more
>> easily reviewed.

> The last line should not be a part of the commit description IMO.

Will delete that. Thanks.

