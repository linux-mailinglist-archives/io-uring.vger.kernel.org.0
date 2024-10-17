Return-Path: <io-uring+bounces-3775-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95A699A21A2
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 13:58:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BC54281973
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 11:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62C0A1DD53E;
	Thu, 17 Oct 2024 11:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ijp/IOI1"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CAE1DD548
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 11:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729166241; cv=none; b=NpxV0G4Ef3sshdeEoxfCuSdKHIXFl6W2GpXpiD1RCmoeR0VinrqQFTaDFhl7hPcGb801KQbtobfATcFA4g3O1t6YPyNPyds4PrflJiMbRna1WjqjpR/vmAA3Z18ZrzJX7jcxEdPTWY6XLPJfeeMQQy2ifk3vibg4B3esE3jkxBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729166241; c=relaxed/simple;
	bh=Wvobxwk10eyYL3VqO3KmPO3FLWGsG64YhxPc6/akDoo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=GGp5fZf3py6qMr/FBxOzmHSuJpwrpfS7vmsl84Y/B2BBZgCcREI5aassvDULTSelSVlKdKm2bTrSdGozytPUNmBlVit+Y62nKuSs79I5MRiD5+8RE9HsuVhp5hjNiERiNaX7C3sxBmeXLSGdfU3unTZMj44SoSdlHjeqmbzm5AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ijp/IOI1; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241017115716epoutp0255fecf5b9cc94dcdfdc764cce4d2f3cf~-O4fje8zP0296602966epoutp02k
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 11:57:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241017115716epoutp0255fecf5b9cc94dcdfdc764cce4d2f3cf~-O4fje8zP0296602966epoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729166236;
	bh=Q4hHKn1fvmxyFIMMGNPMj5Q2BqLJbwWcipMK/6ZRwgo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ijp/IOI1AwDIK2TNyWMKfEdXI1C7ikx5cmnK8HiR04kTXjWSEIdQNmFft5WqU9gud
	 byJcA9q4Df8qRi81a9hW/O9iKrcTvijVun5S/kIgL42979FzyuE/qG+e3nBUtdiwYH
	 fL8kEfNxo2s7IYv9IlP/IbE/FsV8leIKx6vdliV4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241017115715epcas5p3a3266c9f18db518c2ea85fb8f3e619da~-O4e1ekmR2518825188epcas5p3F;
	Thu, 17 Oct 2024 11:57:15 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XTmXp2hbMz4x9Pp; Thu, 17 Oct
	2024 11:57:14 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C5.F1.18935.A9BF0176; Thu, 17 Oct 2024 20:57:14 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241017114701epcas5p257951decab3610f0fb7b77a5104ea23f~-OviwUmc73273832738epcas5p2q;
	Thu, 17 Oct 2024 11:47:01 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241017114701epsmtrp20cd6a46e1646a64b8308ce8f6164173b~-OviviJJ12251122511epsmtrp2J;
	Thu, 17 Oct 2024 11:47:01 +0000 (GMT)
X-AuditID: b6c32a50-a99ff700000049f7-0f-6710fb9a11e6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A8.E1.07371.539F0176; Thu, 17 Oct 2024 20:47:01 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241017114659epsmtip26cdaf5998c8ff6fe84d6b4a62d72f3a2~-Ovg5udWI2791127911epsmtip2c;
	Thu, 17 Oct 2024 11:46:59 +0000 (GMT)
Date: Thu, 17 Oct 2024 17:09:23 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com
Subject: Re: [PATCH v4 11/11] scsi: add support for user-meta interface
Message-ID: <20241017113923.GC1885@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241016112912.63542-12-anuj20.g@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te1BUVRzHOXcvdy8My1xA6rgmj+sYQQK7tWwXhMCJ4s5ktWaNyjStd5Y7
	u8S+2oeZ0rSTrg0UCkghKxaN8XAxIlRcMggXdOPZ8JCSaW1iWM1lwlhCGxGnZe/S+N/n9zvf
	7znf88J50UOYEC/WmliDllGTWDja2ZeckmpbJpSi4QtR1MLSMkrV2zsB1eo+hlHXe7sQ6kzr
	FYSat46iVLVzClAXhxt5VPf009SXTR4+9ckvDoxqdj1EqJ9t9fw8Ad1lc/PpiREz3WEvw+hz
	X39IX7puwegFzzRKHz1vB/S5oYP0YkecLKywJFvFMkWsIYHVKnRFxVplDvnyTvkL8gypSJwq
	zqSeIxO0jIbNIfO3y1JfKlb7Q5MJ+xi12d+SMUYjmf58tkFnNrEJKp3RlEOy+iK1XqJPMzIa
	o1mrTNOypiyxSPRMhl+4t0Q12tfG118O3z9ia8IsYB4vB2E4JCTQV/U5Wg7C8WjiBwAtY0PB
	wgdg3+0KhCvuAnjI60LXLMeXWzFuoBvA6r6bQctNAN1z4wEVSmyGTlcLf5UxIgn237KCVV5H
	VAN4a+LNVeYRjQCu9EtXOYYogCd6fg9oBMQWeNQxFspxFByomw3MGUZshUuTrYF+LLEJ9na6
	AvEg0YvDOw+cGBcvH9ae9PA4joFe13k+x0K4ON8d1CjhvxMehGM9PHS1B3CcC62Dx3hcOBWc
	uvNjsL8RfjbYhnD9SFixPBv0CqDjizUm4cdn6oMMYfeoxc+4n2k4fa2UO6AeANuv1IBKEG97
	ZG+2R5bjeAtsuOTDbH47j9gAmx/iHCbDb79PbwChdiBk9UaNklVk6MWpWva9/69codN0gMCr
	TpE5QGv7SpoTIDhwAojzyHWC6nKBMlpQxLx/gDXo5AazmjU6QYb/sqp4wliFzv8ttCa5WJIp
	kkilUknms1Ix+bhgznqqKJpQMia2hGX1rGHNh+BhQgtyBG38Zzy0IaRwV78jrm5S0f4A/GmA
	yLvzF67dd6+cteS+XlMadfmA7+53cscrvVhNqeSrxrLJ0LxXTSfy9qHRjzFldHxFZPKYdGD9
	Ju8eW899Xcsf3/zkThk5vfCB7eyNd2bQmW5EkeaTDcXQE7ufarae8tzLKiCyey7exmd3fKo6
	/VG2cLDpKnv8XsJYCDu+oeO10VlZ4Vt7I+B8ftXf1Iw8fXgw8Qnz1j1D8W+rdtX+tW1qzm7O
	Tc/11b5Y0BZxOCLOMOCNity41IxVmvYT20yJaVimNssrrxMtJN44KdzRrH6jsquat5iUE7vb
	upD0q+Zw05Pr535bbDkSclBet9NOokYVI07hGYzMf39EGGZeBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42LZdlhJXtf0p0C6wbddqhYfv/5msZizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02H5mKbPF3lvaFvOXPWW36L6+g81i+fF/TBbn
	Z81hd+D12DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvTYfLra4/MmuQDOKC6b
	lNSczLLUIn27BK6Mnwua2QsaOSre/OthbmA8ztbFyMkhIWAiMfn3aiCbi0NIYDejxNfdl5kh
	EhISp14uY4SwhSVW/nvODlH0hFFi8dbD7CAJFgFViUPHV4DZbALqEkeetzKCFIkITGKUmDfp
	JgtIgllgKaPE3yNmILawgLvEjH33wabyCuhI9O24yAoxdR+jxM7Jn9ghEoISJ2c+gWrWkrjx
	7yVTFyMHkC0tsfwfB0iYU8Ba4uuV1awgtqiAssSBbceZJjAKzkLSPQtJ9yyE7gWMzKsYJVML
	inPTc5MNCwzzUsv1ihNzi0vz0vWS83M3MYJjTEtjB+O9+f/0DjEycTAeYpTgYFYS4Z3UxZsu
	xJuSWFmVWpQfX1Sak1p8iFGag0VJnNdwxuwUIYH0xJLU7NTUgtQimCwTB6dUA9Ob4KivNZKP
	7IT539id3BNTmb44/LTH39A7Gq0MSZk79j/ffq782rawl1apt3f/vbt1ikX+9jcThbfc5TYJ
	70n7FSHgHJrz1/TQZD4e15zo869j0wTLPyn6iq3uP+8zS6En2Jn5961rJj8Yeqx28l26Xi/y
	w7SD+fqVL7K2+5Zvcu2LcS9zEnjyZH1qj9XLX9vtdm0+ukRjxcXQ7PPfko4Hmtexsss6hl3Z
	ylws/MFzhXLKbKsVe67oWRiaLpxu5za9T072z4NLjXck8ubtljhnFszVrn77afpSy8tr3FcV
	RUlvbHBL0WMVyV4+nTkvT+PsoVcmGXc89XWu8AvX3zxqsfHybjtBRw97HQs+XSWW4oxEQy3m
	ouJEAEGkjKAgAwAA
X-CMS-MailID: 20241017114701epcas5p257951decab3610f0fb7b77a5104ea23f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_50325_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e@epcas5p4.samsung.com>
	<20241016112912.63542-12-anuj20.g@samsung.com>

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_50325_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

> +/*
> + * Can't check reftag alone or apptag alone
> + */
> +static bool sd_prot_flags_valid(struct scsi_cmnd *scmd)
> +{
> +	struct request *rq = scsi_cmd_to_rq(scmd);
> +	struct bio *bio = rq->bio;
> +
> +	if (bio_integrity_flagged(bio, BIP_CHECK_REFTAG) &&
> +	    !bio_integrity_flagged(bio, BIP_CHECK_APPTAG))
> +		return false;
> +	if (!bio_integrity_flagged(bio, BIP_CHECK_REFTAG) &&
> +	    bio_integrity_flagged(bio, BIP_CHECK_APPTAG))
> +		return false;
> +	return true;
> +}
> +

Martin, Christoph, and all,

This snippet prevents a scenario where a apptag check is specified without
a reftag check and vice-versa, which is not possible for scsi[1]. But for
block layer generated integrity apptag check (BIP_CHECK_APPTAG) is not
specified. When scsi drive is formatted with type1/2 PI, block layer would
specify refcheck but not appcheck. Hence, these I/O's would fail. Do you
see how we can handle this?

[1] https://lore.kernel.org/linux-block/yq1ttgz5l6d.fsf@ca-mkp.ca.oracle.com/

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_50325_
Content-Type: text/plain; charset="utf-8"


------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_50325_--

