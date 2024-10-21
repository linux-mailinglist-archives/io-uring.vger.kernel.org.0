Return-Path: <io-uring+bounces-3843-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4399C9A59E5
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 07:46:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BF9A1C2102D
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 05:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1DC119938D;
	Mon, 21 Oct 2024 05:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YQp+am13"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861B219340D
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 05:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729489579; cv=none; b=bgDJdvDqztQBjiSzHxd/KPV5eJ9n2DGxjNFNt1zh4t1mcfOrUzPIfdlYKJDaTEgxobmhDBirHLeUEWH8178KaCcUdhrcjDaujlJDJrbmODSeXmFvlIFqbP9IWKtWOgTChHr0WW+BTqnX9ShPgi3I+WWYOM6kwxyy67qP5ekTyjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729489579; c=relaxed/simple;
	bh=WYR0bDNkGe9X68XYEReTJwExKJCaA46pObJ2KdmkveU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=j7PyE5IMF+9OmTbMG4abYRzrJRlwFcJKh2pbMEYduQQvf3/L1viCswjBPXlEHrNXiNARApVFkAd0bFpQv35lvT1GOxEtD9iBMyrGuBRn8hDdtdyE216C81ub6qxuzAW7rs6sZ5L33FYwQuzAny89pC9mGXtZhM9vEpkoNjYTUxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YQp+am13; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241021054614epoutp04310763c2bfa94726bcf64cd7adc189b9~AYZrj9p9r1855118551epoutp04E
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 05:46:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241021054614epoutp04310763c2bfa94726bcf64cd7adc189b9~AYZrj9p9r1855118551epoutp04E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729489574;
	bh=Ulf1ksMYUE48Lu6prNlTGdKuI66NQr+PY9q1T25et7A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YQp+am13l49BWM9zrOhUQjf4CeeUczK3XUhEluSRV8gbIbOeRqHa5Ap1SKKL9ITtG
	 owkWmZ2KfG65fts3vCmpmF3SD8Zvru0uqEzExuZjNweVEoWpP/zoYfFYjMw5DwjAMQ
	 TJ1bDutIEulUFoBPyNU3l/rvF1WzuDAlHs6tvolo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241021054614epcas5p49b1b700178b50cab66292a5f758b4a99~AYZrGrJFc1969619696epcas5p4s;
	Mon, 21 Oct 2024 05:46:14 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XX46q2lLmz4x9QB; Mon, 21 Oct
	2024 05:46:11 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	31.3B.18935.3AAE5176; Mon, 21 Oct 2024 14:46:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241021053853epcas5p28278ac9cd4f6791bca8d676cf06d99c5~AYTQNEp_O2430924309epcas5p20;
	Mon, 21 Oct 2024 05:38:53 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241021053853epsmtrp2824203125cc849df811967e71284722f~AYTQLzLCz2056520565epsmtrp2i;
	Mon, 21 Oct 2024 05:38:53 +0000 (GMT)
X-AuditID: b6c32a50-cb1f8700000049f7-14-6715eaa32d47
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	40.A0.08227.CE8E5176; Mon, 21 Oct 2024 14:38:52 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241021053850epsmtip27568a368b48baf3fd3e276f32d38fe4a~AYTOKAtMD1344313443epsmtip2c;
	Mon, 21 Oct 2024 05:38:50 +0000 (GMT)
Date: Mon, 21 Oct 2024 11:01:10 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: Re: [PATCH v4 07/11] io_uring/rw: add support to send meta along
 with read/write
Message-ID: <20241021053110.GA2720@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241017081057.GA27241@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEJsWRmVeSWpSXmKPExsWy7bCmlu7iV6LpBjOv8Fl8/PqbxWLOqm2M
	Fqvv9rNZ3Dywk8li5eqjTBbvWs+xWBz9/5bNYtKha4wW288sZbbYe0vbYv6yp+wW3dd3sFks
	P/6PyeL8rDnsDnweO2fdZfe4fLbUY9OqTjaPzUvqPXbfbGDz+Pj0FotH35ZVjB6bT1d7fN4k
	F8AZlW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3S5
	kkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafApECvODG3uDQvXS8vtcTK0MDAyBSo
	MCE74+GLf8wFX/kr7i6+x9jA+IWni5GTQ0LAROLdnU3sXYxcHEICexglDp1ZzAbhfGKU2Ppj
	BlTmG6PEwaOX2WBa7p5oYoVI7GWUmLDyGSOE84xR4teU+ewgVSwCqhLP/j8Hs9kE1CWOPG9l
	BLFFBJQknr46C9bALHCBSeLQ5b9gY4UFoiVmvv8BVsQroCPxfNlPKFtQ4uTMJywgNidQ/Oif
	16wgtqiAssSBbceZQAZJCJzhkJh1egIzxH0uEu9nnmCFsIUlXh3fwg5hS0l8frcX6od0iR+X
	nzJB2AUSzcf2MULY9hKtp/rB5jALZEgcPnUIqldWYuqpdUwQcT6J3t9PoHp5JXbMg7GVJNpX
	zoGyJST2nmuAsj0kFn/dCw2v+4wSX/bNZJvAKD8LyXOzkOyDsHUkFuz+xDaLkQPIlpZY/o8D
	wtSUWL9LfwEj6ypGqdSC4tz01GTTAkPdvNRyeKQn5+duYgQnbq2AHYyrN/zVO8TIxMF4iFGC
	g1lJhFepRDRdiDclsbIqtSg/vqg0J7X4EKMpMLomMkuJJucDc0deSbyhiaWBiZmZmYmlsZmh
	kjjv69a5KUIC6YklqdmpqQWpRTB9TBycUg1MuczGB0Ojty6PLb8hb7jDbcVH4QYHs5XhCkv3
	T72o/3TRO4P6XSoJju/b+NtaTeR1X0zdFhTfZ3RccktmCP/n/5slP+yq4ppY7ZNZ22NVdfu9
	6ZUrdbIMPinxdYq177+u23Ey7+ekO18e/JPcp3vso/hqvi8ic5mDbbZ/fpLvsIpderlMa522
	zbZ5z9Z9Fpc9IByuUBYTvvbFy9baE2Y2J/2X7N9c6sWiOffWo6v5BzW/bIkWPvNkW4AWk+p0
	n8ylBya0cl5548TUf0LpjfnXV2eTzVkjfRx4Nn/+ppo0Obv4w5pHLQbH6/J2N883euM4/cJV
	40me5jyZcQusnin9PPPzkn2B36YuKd6rFi2LlViKMxINtZiLihMBZMA/GGUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWy7bCSvO6bF6LpBs83mVt8/PqbxWLOqm2M
	Fqvv9rNZ3Dywk8li5eqjTBbvWs+xWBz9/5bNYtKha4wW288sZbbYe0vbYv6yp+wW3dd3sFks
	P/6PyeL8rDnsDnweO2fdZfe4fLbUY9OqTjaPzUvqPXbfbGDz+Pj0FotH35ZVjB6bT1d7fN4k
	F8AZxWWTkpqTWZZapG+XwJXRvfQbS8FW3orP2xazNjCe5epi5OSQEDCRuHuiibWLkYtDSGA3
	o8TxmV+ZIBISEqdeLmOEsIUlVv57zg5R9IRRov/qd7AiFgFViWf/QRKcHGwC6hJHnreCNYgI
	KEk8fXWWEaSBWeACk8S2JW+YQRLCAtESM9//ACviFdCReL7sJyPE1PuMEqfPtDBDJAQlTs58
	wgJiMwtoSdz49xJoGweQLS2x/B8HSJgTqPfon9esILaogLLEgW3HmSYwCs5C0j0LSfcshO4F
	jMyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCo01LawfjnlUf9A4xMnEwHmKU4GBW
	EuFVKhFNF+JNSaysSi3Kjy8qzUktPsQozcGiJM777XVvipBAemJJanZqakFqEUyWiYNTqoFJ
	sO3yqnksO3Zm9R3OaOfgWBI263OCYGjVsbkru33uy90NPNifJdS5nVm+ueHz05zDJ5/bf9W7
	+XdyKL/WN+4VNglbeyY95zvEl/B69doq0aOF+94uyVY/r7vYMkM50sdW5c7kebJzIvsnVOhv
	ZErhc3hw5KqwUBXvhN9PBXIOcvn9Pru4U3qJTH7ATK8Ug03vD5/K7pNpej33v/mrB2wnw/rt
	HFsvGnfrnPrFNelKhXSCjcusnyde+tpIu+nmVK/MKFOTqv2zXCpZISxuQl3rj/21ix6fOW8c
	Jcbm/idJymlxOJdNhtyDFQ8eLHX/vjb/pt5Cdu7rbx0zNrzfyv1A3c7lQZzmPdeMMr3/ty2U
	WIozEg21mIuKEwEHf0/iJQMAAA==
X-CMS-MailID: 20241021053853epcas5p28278ac9cd4f6791bca8d676cf06d99c5
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_5d1e1_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113747epcas5p4e276eb0da2695ba032ce1d2a3b83fff4
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113747epcas5p4e276eb0da2695ba032ce1d2a3b83fff4@epcas5p4.samsung.com>
	<20241016112912.63542-8-anuj20.g@samsung.com>
	<20241017081057.GA27241@lst.de>

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_5d1e1_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

> What is the meta_type for?  To distintinguish PI from non-PI metadata?

meta_type field is kept so that meta_types beyond integrity can also
be supported in future. Pavel suggested this to Kanchan when this was
discussed in LSF/MM.

> Why doesn't this support non-PI metadata?

It supports that. We have tested that (pi_type = 0 case).

> Also PI or TO_PI might be
> a better name than the rather generic integrity.  (but I'll defer to
> Martin if he has any good arguments for naming here).

Open to a different/better name.

> 
> >  static bool need_complete_io(struct io_kiocb *req)
> >  {
> > +	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> > +
> > +	/* Exclude meta IO as we don't support partial completion for that */
> >  	return req->flags & REQ_F_ISREG ||
> > -		S_ISBLK(file_inode(req->file)->i_mode);
> > +		S_ISBLK(file_inode(req->file)->i_mode) ||
> > +		!(rw->kiocb.ki_flags & IOCB_HAS_METADATA);
> >  }
> 
> What partial ocmpletions aren't supported?  Note that this would
> trigger easily as right now metadata is only added for block devices
> anyway.

It seems that this scenario is less likely to happen. The plumbing
seemed a bit non trivial. I have the plan to look at it, once the
initial version of this series goes in.

> 
> > +	if (unlikely(kiocb->ki_flags & IOCB_HAS_METADATA)) {
> 
> For a workload using metadata this is everything but unlikely.  Is
> there a specific reason you're trying to override the existing
> branch predictor here (although on at least x86_64 gcc these kinds
> of unlikely calls tend to be no-ops anyway).

The branch predictions were added to make it a bit friendly for
non-metadata read/write case. 


------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_5d1e1_
Content-Type: text/plain; charset="utf-8"


------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_5d1e1_--

