Return-Path: <io-uring+bounces-3172-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B69FB97698F
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 14:50:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B617282057
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 12:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA7E71A3AAA;
	Thu, 12 Sep 2024 12:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZDpATQum"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9493C1A262D
	for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 12:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726145429; cv=none; b=gvHOEnjAs27pzG3kLYw7a7NtJOgexh/E1AYaqFZDHVGTR1gReLP5H7kxvwhAy4GEuc25ngz1L1KuEEotej8DWXPun6pHCHtYNdg8vprcGPQEV9cvpCtFePHkMF1535cgi3sH3TnGfAi2MuxfIJUlpBs9ItLwte7LVwFAjuhj7r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726145429; c=relaxed/simple;
	bh=9CZEcnfXeiHaa8hx6aC4eZB57Bt+d4PHyUZ8rQP6OAA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Yscctws9euwIh27pxC4yTbUpc1miP3MyttWh36n662e3n0R1IqvGLUaWgtJ6TWYJU6icAbnKQOHIISTz+B1Z3IwIqdPntI8+bcqjcZtLqJd9g7zlvFDtVmUZEDIjVlm3yWBtNd7p9/lvzI9ezVbt/BtPUzQIsHJRUjdci1fN0kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZDpATQum; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240912125025epoutp042e809b261d5c18e8108c53d46f46792e~0gB5_YCwe0612706127epoutp04b
	for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 12:50:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240912125025epoutp042e809b261d5c18e8108c53d46f46792e~0gB5_YCwe0612706127epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1726145425;
	bh=9CZEcnfXeiHaa8hx6aC4eZB57Bt+d4PHyUZ8rQP6OAA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZDpATQumntOwu2d1gOaCuPxY+Usa3/eb606Kc7EAATULpdihE0elcoNTyil/PokZV
	 0Ev3x6mFR/oQssz0545JttgkwLR3VA/Pdry+dRlxnvfunJ6CNYE7S3ptcy151uGbIS
	 NuLpKTofnPxoYJ37zbxFDxU1RDAbGkaXFxaJruy0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240912125025epcas5p2c83b488bcb08e71fb16b73ad9da5ee67~0gB5cNu721633716337epcas5p2h;
	Thu, 12 Sep 2024 12:50:25 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4X4HNH2b3bz4x9Pt; Thu, 12 Sep
	2024 12:50:23 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D8.DD.08855.F83E2E66; Thu, 12 Sep 2024 21:50:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240912124747epcas5p334d82f711967922d4ed4402589849a15~0f-mQzX7m2649726497epcas5p37;
	Thu, 12 Sep 2024 12:47:47 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240912124747epsmtrp2e133501257290eef4637cc2061a97fb8~0f-mQCBPU2092520925epsmtrp2X;
	Thu, 12 Sep 2024 12:47:47 +0000 (GMT)
X-AuditID: b6c32a44-107ff70000002297-c1-66e2e38fbc6e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2E.49.08456.2F2E2E66; Thu, 12 Sep 2024 21:47:46 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240912124744epsmtip29ff54c9d43495a0aa2cd652e320ef056~0f-kWoZNy1934919349epsmtip2R;
	Thu, 12 Sep 2024 12:47:44 +0000 (GMT)
Date: Thu, 12 Sep 2024 18:10:11 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Anuj gupta <anuj1072538@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi
	<joshi.k@samsung.com>, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	kbusch@kernel.org, asml.silence@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 07/10] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG
 bip_flags
Message-ID: <20240912124011.oa6zs7bbnnn4zzcm@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CACzX3AuX9FkxPoBRLmy_HEmu6Ex63jHLyz9Z8fhUd_Y5_MdJyw@mail.gmail.com>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA03TfUwbZRwHcJ+763GQtJ5sDY9sOrzETYaUdpZ6DHDT4VJkAmPZ1MmsN3pQ
	oLRNXyZsf4AuTOlgBZItvE3QCQSIjLUbFJE5Ol4UZjMl8pZUI9DNsElWGBPFgG2vM/vvc9/7
	/X7PPffcEWjoL3g4kasxsnoNo6bwEKz7ZuRL0Za52Wzx6l0B7VlZw+iG9m5Ad7gsOD19oxeh
	2zqGEHqx1InRQxt/4nS1YwLQPbeaUbp/JopubHEH0Wcn7TjdOrKO7OXLe+tcQfLxH01ya3sZ
	Lrd9VSzvmy7B5R73DCY/d7UdyG1jp+TL1ufTg4/mJ6hYRsnqI1hNllaZq8lJpFIOKfYpYmVi
	SbQkjn6VitAwBWwilXQgPXp/rtr70FTECUZt8kbpjMFAxbyWoNeajGyESmswJlKsTqnWSXUi
	A1NgMGlyRBrWuFsiFu+K9RZ+mK/qrfDwdBshhbW2a2gJqAw2g2ACklJ4+Z9Bns+hZB+Aa56X
	zSDE6yUAPRV1OHfxCEBb1RVgBoS/Y8j1Opf3Azh7vTRQdAdAu8PlH4WRL8LJ/mrEZ5zcAQfv
	lgKfN5Pbobu7x9+AkjMI/H3+vv/GJvJd+PdEOc+3Ap+UwfYHH/hiPvkM/KF2HvM5mDwI5x7O
	oT4Lya2wpnkF9c2B5BQBL9U7UW4/SXCt5QLCeRNcGLkaxDkcLi/245xz4Oq4O1Cjg6eHrwPO
	e2DpqMU/ByVVsPWONTDzOXh+tBPhcgGsWJsP9PKh/fPHpuCnbQ0BQ9jvLAlYDs2j94O4N7SB
	QNfwEloJttU9sbm6J9bjvBuWPfiEx3kbPH2t3psTXm+BresEx0h4+ZuYJoC3g2dZnaEgh82K
	1Uk07Ef/H36WtsAK/N/3ziQ7mGpcFzkAQgAHgARKbeZX47PZoXwlU3SS1WsVepOaNThArPfg
	qtBwYZbW+4NojAqJNE4slclk0rhXZBIqjH+v9KIylMxhjGw+y+pY/eM+hAgOL0G+X7yBH9Gl
	tBResF00p8bX32oYrEm896Yg7o+RbnsJOZFRjiRk7tvTaC7sVLYgKU+7K5+KWHZUq4uYF/7K
	E+scemdS1OJ7LkuzR9G343D8WwR2Llm7EhYWRKr6EitiTqmL8o6Vf2k7lIfVRE2k/QoKW/Ye
	Cxnoaj6z4fntjaYB4RaPecIuKn7blobBrs86NZlViiE08sTRk8cVD/d/Z7TOTut7yq640x59
	bBnvsvIORxkG309toLKFo1sHdt1caEp1CmY6ht2Z70iKx3jo7fJwi3AqQy1QVH2dnBIXX5t8
	6Vv89sa/WNaZn77oStWf/3ns+MGBlIyF6bYjyGTRkmiVwgwqRrIT1RuY/wDXA3PaaAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWy7bCSvO6nR4/SDNYfN7f4+PU3i8WcVdsY
	LVbf7WezuHlgJ5PFytVHmSzetZ5jsTj6/y2bxaRD1xgttp9Zymyx95a2xfxlT9ktuq/vYLNY
	fvwfkwOvx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+vcXi0bdlFaPH5tPVHp83yQVwRnHZ
	pKTmZJalFunbJXBlzLm5i61gAkfF/V3vWRsY97F1MXJwSAiYSBy969jFyMUhJLCbUeLqmmlA
	cU6guITEqZfLGCFsYYmV/56zQxQ9YZToWbuKBSTBIqAqcX3vJCYQm01AXeLI81awBhEBNYmn
	27azgTQwC9xikni1+DdYkbBAhMTPaz2sIJt5BcwkVn2IgxjayCzR83gx2FBeAUGJkzOfgNnM
	QDXzNj9kBqlnFpCWWP6PAyIsL9G8dTYziM0pECjx+MtjMFtUQEZixtKvzBMYhWYhmTQLyaRZ
	CJNmIZm0gJFlFaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcDxqae1g3LPqg94hRiYO
	xkOMEhzMSiK8k9gepQnxpiRWVqUW5ccXleakFh9ilOZgURLn/fa6N0VIID2xJDU7NbUgtQgm
	y8TBKdXAVH9k1kOjOJm4TY1XkluqLjXu2yY3o4rDouMN8+fX9+IYSpW1D9xLZtV9c2jaDZEN
	t9/IuT8Pqtka5+Mp5BPmcVTpxSyFtB8TGu8d0nWouBx3lfHl/CffTKYsn1R6MOPba6Fpv649
	Wj4/o6wpz/rB288lWdK7zk+v2TGn8PD2dSHnHBLWc0W9mnA/+lLkQr0+t91nLkpvZhbtDZf9
	p5o0oTvyQ9esXU2JwScKmK+3H0p+ljdH7Wnu6bgDlrM5RUXWbNFfu9N8RfPSKwuqJLZWTj/B
	vaXmv9Hfox0/mMVO8R1KDL0ht7D4h8z2F7FJKx3feUg/raqxmTDdVZdj4s4/H2W2lSy5eDYn
	q5OB490fEyElluKMREMt5qLiRADkCJZHNgMAAA==
X-CMS-MailID: 20240912124747epcas5p334d82f711967922d4ed4402589849a15
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----luG4lI1MrmVRcozwbZt.i8.9tT3-_3NlzspW7tFyRzm0-Xz8=_20fba_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240823104629epcas5p3fea0cb7e66b0446ddacf7648c08c3ba8
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104629epcas5p3fea0cb7e66b0446ddacf7648c08c3ba8@epcas5p3.samsung.com>
	<20240823103811.2421-8-anuj20.g@samsung.com> <20240824083553.GF8805@lst.de>
	<fe85a641-c974-3fa7-43f1-eacbb7834210@samsung.com>
	<yq1plpsauu5.fsf@ca-mkp.ca.oracle.com>
	<CACzX3AuX9FkxPoBRLmy_HEmu6Ex63jHLyz9Z8fhUd_Y5_MdJyw@mail.gmail.com>

------luG4lI1MrmVRcozwbZt.i8.9tT3-_3NlzspW7tFyRzm0-Xz8=_20fba_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Martin, Christoph

On 29/08/24 06:59PM, Anuj gupta wrote:
>On Thu, Aug 29, 2024 at 8:47 AM Martin K. Petersen
><martin.petersen@oracle.com> wrote:
>>
>>
>> Kanchan,
>>
>> > With Guard/Reftag/Apptag, we get 6 combinations. For NVMe, all can be
>> > valid. For SCSI, maximum 4 can be valid. And we factor the pi-type in
>> > while listing what all is valid. For example: 010 or 001 is not valid
>> > for SCSI and should not be shown by this.
>>
>> I thought we had tentatively agreed to let the block layer integrity
>> flags only describe what the controller should do? And then let sd.c
>> decide what to do about RDPROTECT/WRPROTECT (since host-to-target is a
>> different protection envelope anyway). That is kind of how it works
>> already.
>>
>Do you see that this patch (and this set of flags) are fine?
>If not, which specific flags do you suggest should be introduced?

While other things are sorted for next iteration, it's not fully clear
what are we missing for this part. Can you comment on the above?

------luG4lI1MrmVRcozwbZt.i8.9tT3-_3NlzspW7tFyRzm0-Xz8=_20fba_
Content-Type: text/plain; charset="utf-8"


------luG4lI1MrmVRcozwbZt.i8.9tT3-_3NlzspW7tFyRzm0-Xz8=_20fba_--

