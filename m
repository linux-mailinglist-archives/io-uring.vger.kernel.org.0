Return-Path: <io-uring+bounces-7304-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB668A75F17
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 08:54:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF72B18880BC
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 06:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156A3198E76;
	Mon, 31 Mar 2025 06:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kHChQPbc"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E755192D96
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 06:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743404091; cv=none; b=POhei8fD21iXfXPlV/vBcqcJv+qxifKHTwKYNWrBsIVvFJg5yrAo0z2PoJCgcKHDyXyH9hFc1VALKw4IGtyLcohZzH6xMYK8UzzRmewli3iI2dHsHbq9QoaJAEEg9lhbH6gGs8sVxYDp3EljYrWF2NGc9ET0wvRQma5cA4euDx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743404091; c=relaxed/simple;
	bh=F0xnPgnr0ipIPPbnwP9KnlTZy6+WfyOzeko7lAPraEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=ZB2rU8uU99y2k/vCU4EEbkMyybcQM8odSv7ZOni1PLXB9f+B1HGLh2qOcKJvHEVXyH7cgcQGFsuk6UEZ+7YFPBQfSo5NA2o1G2oQS+xJYj2Mn7ZRheml1oyDLrOsIsP5EbvXHyUYP/eDqqe1jhFzVxDKKw/3TvU2A3IkKPnXfQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kHChQPbc; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250331064747epoutp040c96e5be2982c633600cbe931aedb476~x0GYiKJIa0904709047epoutp04U
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 06:47:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250331064747epoutp040c96e5be2982c633600cbe931aedb476~x0GYiKJIa0904709047epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1743403667;
	bh=cU8ZjDVrKVfX1VkxH+yC4pcYzBmbmHhNz0/QzzT4Zv0=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=kHChQPbcsF45GT5LLZpQlRbjmJes60WLD21uxwms0+WVdQdth0pNzxOxJZaateGvL
	 vzvGxW5SyrxJVtOsi1pMr+1VRBiTLS7hZU8re5ovj/MICKn4QqJmSTeeVAXW0Es8oY
	 6rq4SzYL86RgWU8dsLLj4EyHOe7/GYuR7X0iL5ZY=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250331064747epcas5p1c73b9c47280486dbd3e073f578e6101f~x0GYHtvUm1024410244epcas5p1y;
	Mon, 31 Mar 2025 06:47:47 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4ZR1sY1SMPz3hhTF; Mon, 31 Mar
	2025 06:47:45 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5F.73.10173.19A3AE76; Mon, 31 Mar 2025 15:47:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250331064744epcas5p246d4fb167638e93fa07f8d79f4894d42~x0GVl0icP1265112651epcas5p2j;
	Mon, 31 Mar 2025 06:47:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250331064744epsmtrp2f15506c5e0a78f1f1b527bede2f89b9c~x0GVk6n2f1429014290epsmtrp2r;
	Mon, 31 Mar 2025 06:47:44 +0000 (GMT)
X-AuditID: b6c32a44-8c1fc700000027bd-83-67ea3a91be53
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D0.74.08766.09A3AE76; Mon, 31 Mar 2025 15:47:44 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250331064743epsmtip1738065b18eb9877c45e9f5459f18a1cf~x0GUF5CfA1389113891epsmtip1U;
	Mon, 31 Mar 2025 06:47:42 +0000 (GMT)
Message-ID: <48b9a876-0e3b-4c89-9aa3-b48f502868c3@samsung.com>
Date: Mon, 31 Mar 2025 12:16:58 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] nvme/ioctl: move fixed buffer lookup to
 nvme_uring_cmd_io()
To: Caleb Sander Mateos <csander@purestorage.com>, Keith Busch
	<kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig
	<hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Pavel Begunkov
	<asml.silence@gmail.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>, linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20250328154647.2590171-4-csander@purestorage.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNJsWRmVeSWpSXmKPExsWy7bCmlu5Eq1fpBpv/sFrMWbWN0WL13X42
	i/8L57JarFx9lMniXes5FotJh64xWjy9OovJ4vKuOWwW85c9ZbdY9/o9iwOXx85Zd9k9zt/b
	yOJx+Wypx6ZVnWwem5fUe+y+2cDm0dv8js1j28Nedo/Pm+QCOKOybTJSE1NSixRS85LzUzLz
	0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA7lRSKEvMKQUKBSQWFyvp29kU5ZeW
	pCpk5BeX2CqlFqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGfc+KVc8IitovXmTLYGxlOs
	XYwcHBICJhLXlwl3MXJxCAnsZpRYv+0YG4TziVFi+uQZTBDON0aJrxfesncxcoJ1bJx+gBEi
	sZdR4sDDFWAJIYG3jBKbluqB2LwCdhLnth1lA7FZBFQlds6HaOYVEJQ4OfMJC4gtKiAvcf/W
	DLC4sECkRE/3RrChIgIPGSW6lm1hAXGYBRoZJVZuhJjELCAucevJfCaQw9kENCUuTC4FCXMK
	2Eu8Xt3IAlEiL7H97RxmkF4JgQMcEp9+b2OFONtFYtbvuVC2sMSr41ug3pGS+PxuLxuEnS3x
	4NEDFgi7RmLH5j6oenuJhj83wAHGDLR3/S59iF18Er2/nzBBwpFXoqNNCKJaUeLepKdQneIS
	D2csgbI9JG72PmOBBNxxRolph/azTmBUmIUULrOQfDkLyTuzEDYvYGRZxSiZWlCcm56abFpg
	mJdaDo/v5PzcTYzgVKzlsoPxxvx/eocYmTgYDzFKcDArifBGfH2ZLsSbklhZlVqUH19UmpNa
	fIjRFBhBE5mlRJPzgdkgryTe0MTSwMTMzMzE0tjMUEmct3lnS7qQQHpiSWp2ampBahFMHxMH
	p1QDk+Y/hXN7o17seW9XeJbL0XDrIbMpzO9yvMpuqu6VnL70+A4V2/L3534uPe3d8HUL98Ky
	1/+1dMtVzTz+ML38qyu09dGD/du/vmB4fLjqR++GBIajma82xV6dNTXI1urmi/7jT1ctbFEq
	darxPN1/zuFIckfZ9NiLSu1TEqdr5L1oLNtleV3Onf+Sa4Gfm3Fp4hypxbyV91T/XarOk+Wr
	OrDsepLwzQr5ckH/3L3vvzQedL0kyJk+/+1RtczvlRFvZgV+eujP6nqB9VKw1yaG93XpppvM
	d9y6XeNVs3fXsdulR+yZZjhJvrRL/vD9ecX1sqDi/Znv/1xkEuK+wdOfqPX2qf6TdNs/5595
	TdjIJKPEUpyRaKjFXFScCAAaGeHyTgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsWy7bCSnO4Eq1fpBv/Wq1jMWbWN0WL13X42
	i/8L57JarFx9lMniXes5FotJh64xWjy9OovJ4vKuOWwW85c9ZbdY9/o9iwOXx85Zd9k9zt/b
	yOJx+Wypx6ZVnWwem5fUe+y+2cDm0dv8js1j28Nedo/Pm+QCOKO4bFJSczLLUov07RK4Mm78
	Ui54xFbRenMmWwPjKdYuRk4OCQETiY3TDzB2MXJxCAnsZpS4197HDJEQl2i+9oMdwhaWWPnv
	OTtE0WtGiY7+m4wgCV4BO4lz246ygdgsAqoSO+e/ZYeIC0qcnPmEBcQWFZCXuH9rBlhcWCBS
	oqd7I1iviMBDRonlX/hBhjILNDJKzN4J0gCy4TijxNYrEB3MQGfcejKfqYuRg4NNQFPiwuRS
	kDCngL3E69WNLBAlZhJdW7sYIWx5ie1v5zBPYBSaheSOWUgmzULSMgtJywJGllWMkqkFxbnp
	ucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMGRp6W5g3H7qg96hxiZOBgPMUpwMCuJ8EZ8fZkuxJuS
	WFmVWpQfX1Sak1p8iFGag0VJnFf8RW+KkEB6YklqdmpqQWoRTJaJg1OqgWml09Q+hnLXJeYc
	X9dqn91VJTyxcYLSWpUVvMdF/ld+1crnTM23KF1zYtrXuvPCL/XaLZcbyS5baFcSmHT2j/Oi
	l35C2gETk7Xnpq3ecoH5Q1jR4ZCQ1B92Nnk3jI3tr2gt7vYN6GZf5Vn6oSQ9Z9mNDivtXqlb
	C7ZM/fDKcve50hvMvNK3ffY/tHvzmvfr/B/C542/nX3X57UySWvv3pf6/+5wfppl11X54/rE
	nb+XtVQnlgoEbY78/Li0fa7kPV+3gwsVs2829Pn9vvb6lTcLq278vAyxaY8Kdsqs3cA2dUaV
	DrP3Vo9VXHOrf6zg/GriYvHpYUVqYqtwm/SF6Y/3TpbVt3+mtP1k6JYdve1KLMUZiYZazEXF
	iQDQ+iznKwMAAA==
X-CMS-MailID: 20250331064744epcas5p246d4fb167638e93fa07f8d79f4894d42
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250328155548epcas5p2368eb1a59883b133a9baf4ac39d6bac6
References: <20250328154647.2590171-1-csander@purestorage.com>
	<CGME20250328155548epcas5p2368eb1a59883b133a9baf4ac39d6bac6@epcas5p2.samsung.com>
	<20250328154647.2590171-4-csander@purestorage.com>

On 3/28/2025 9:16 PM, Caleb Sander Mateos wrote:
> For NVMe passthru operations with fixed buffers, the fixed buffer lookup
> happens in io_uring_cmd_import_fixed(). But nvme_uring_cmd_io() can
> return -EAGAIN first from nvme_alloc_user_request() if all tags in the
> tag set are in use. This ordering difference is observable when using
> UBLK_U_IO_{,UN}REGISTER_IO_BUF SQEs to modify the fixed buffer table. If
> the NVMe passthru operation is followed by UBLK_U_IO_UNREGISTER_IO_BUF
> to unregister the fixed buffer and the NVMe passthru goes async, the
> fixed buffer lookup will fail because it happens after the unregister.

while the patch looks fine, I wonder what setup is required to 
trigger/test this. Given that io_uring NVMe passthru is on the char 
device node, and ublk does not take char device as the backing file. 
Care to explain?

