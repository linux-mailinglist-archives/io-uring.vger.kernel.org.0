Return-Path: <io-uring+bounces-47-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D1067E390D
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 11:25:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8702280FCC
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 10:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BBD313AE1;
	Tue,  7 Nov 2023 10:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="C/lZpXEj"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F06DF72
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 10:25:24 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01E9F7
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 02:25:22 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20231107102520epoutp03f70109e0289d74fa3ded901a03ee7470~VUEu84vs91942719427epoutp03L
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 10:25:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20231107102520epoutp03f70109e0289d74fa3ded901a03ee7470~VUEu84vs91942719427epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1699352720;
	bh=l9+nqALNvgS2e3VhhHqIFbejhxk5Xtdy+ePOfXRPj9E=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=C/lZpXEju96c8HUOnmqqyDUwdqP/Jfh6taz2Xp37LfB34YqNRu329Y8jtDvjEKL7W
	 rJXQNegxhdskJD3PU62iqRpeIcjg2NyJu4w21zef1CkNphSYLwm/zPRwQlajgfU3xx
	 vTSeGPI0J2drz4MRNA537YAlMnYX1WozrkKzwvZ0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20231107102520epcas5p4e2b6305bdf694794affcc9d3f005a516~VUEunhQcC1558915589epcas5p4B;
	Tue,  7 Nov 2023 10:25:20 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4SPkqx1g9Rz4x9Q1; Tue,  7 Nov
	2023 10:25:17 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CB.4B.19369.D801A456; Tue,  7 Nov 2023 19:25:17 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20231107102516epcas5p4eba405b7fe0ab3deb5286c36ef4e44d3~VUErbRGiD0520905209epcas5p47;
	Tue,  7 Nov 2023 10:25:16 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20231107102516epsmtrp1e04180ed0999c0306e3ed9c2fc9fe77c~VUEraZ9Fx2891428914epsmtrp19;
	Tue,  7 Nov 2023 10:25:16 +0000 (GMT)
X-AuditID: b6c32a50-9e1ff70000004ba9-a6-654a108db3ff
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6C.67.08817.C801A456; Tue,  7 Nov 2023 19:25:16 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20231107102515epsmtip1341bef91daf5aa842339591f871cd878~VUEqN5hZ_3269332693epsmtip16;
	Tue,  7 Nov 2023 10:25:15 +0000 (GMT)
Message-ID: <1067f03f-e89b-4fc8-58bb-0b83b6c5c91d@samsung.com>
Date: Tue, 7 Nov 2023 15:55:14 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCHv2 1/4] block: bio-integrity: directly map user buffers
Content-Language: en-US
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org, axboe@kernel.dk,
	hch@lst.de, martin.petersen@oracle.com
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <ZUkAH258Ts0caQ5W@kbusch-mbp.dhcp.thefacebook.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKJsWRmVeSWpSXmKPExsWy7bCmhm6vgFeqwZRZbBar7/azWaxcfZTJ
	4l3rORaLSYeuMVqcubqQxWLvLW2L+cueslssP/6PyYHD4/LZUo9NqzrZPDYvqffYfbOBzePc
	xQqPj09vsXh83iQXwB6VbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtq
	q+TiE6DrlpkDdJGSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9d
	Ly+1xMrQwMDIFKgwITvj6eWqgh6Oiukv+hgbGOexdTFyckgImEhsW3KdsYuRi0NIYA+jxJ6/
	75khnE+MEp8fXWeHcL4xSlxfuoYJpuX57O9sEIm9jBLHNtxlB0kICbxllFjwzAnE5hWwk2h4
	1ga2g0VARWL+rNnsEHFBiZMzn7CA2KICSRK/rs5hBLGFBbwkbjd+ZwWxmQXEJW49mQ+2TERA
	WeLu/JmsIMuYBbYySmx4NReomYODTUBT4sLkUpAaTgF7icebHzJB9MpLbH87hxni0JkcEscX
	OULYLhJn162G+llY4tXxLewQtpTEy/42KDtZ4tLMc1BPlkg83nMQyraXaD3Vzwyylhlo7fpd
	+hCr+CR6fz9hAglLCPBKdLQJQVQrStyb9JQVwhaXeDhjCZTtIfH44VVosC1kkrj7YT3zBEaF
	WUihMgvJ97OQfDMLYfMCRpZVjFKpBcW56anJpgWGunmp5fD4Ts7P3cQITq9aATsYV2/4q3eI
	kYmD8RCjBAezkgjvX3uPVCHelMTKqtSi/Pii0pzU4kOMpsD4mcgsJZqcD0zweSXxhiaWBiZm
	ZmYmlsZmhkrivK9b56YICaQnlqRmp6YWpBbB9DFxcEo1MAV27v0p8mVXwW6BWynfjFacEzfb
	q6/Qpm/UoKUqquzJneEh2ax11mB+7EZR+bD8hWynrvO0+fCc/bij2Fn9xgFBo+QZ+9a4bv81
	T62ha93/4pDlGYH+pqVs+qeeeDEuzOpzKdBOaJsqcOn84+v3fV0kds7w9p2Qet79Zl7vYlEd
	D441PsvW8vFe2jf9wA1xNuENDo6aIoxnTmwQOB5+2OtNmNCUfQYrGeSb83bbrBTKDLrkvFbf
	RkkyOktD9Enlolla6hys+9ODtFYeyxKUDTvxNv2vo/yks9XfuHv/Fxf+/XDnKIemwRPeIrEn
	OYfkjSJ0pPZcf+PJ/aBcfsLL17+mLW6VZY51it86/98UJZbijERDLeai4kQAwgBfczgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJTrdHwCvV4F2fnsXqu/1sFitXH2Wy
	eNd6jsVi0qFrjBZnri5ksdh7S9ti/rKn7BbLj/9jcuDwuHy21GPTqk42j81L6j1232xg8zh3
	scLj49NbLB6fN8kFsEdx2aSk5mSWpRbp2yVwZTy9XFXQw1Ex/UUfYwPjPLYuRk4OCQETieez
	vwPZXBxCArsZJa583c4OkRCXaL72A8oWllj57zk7RNFrRolTP1YwgyR4BewkGp61gU1iEVCR
	mD9rNjtEXFDi5MwnLCC2qECSxJ77jUwgtrCAl8Ttxu+sIDYz0IJbT+aDxUUElCXuzp/JCrKA
	WWAro8TyU3tZILYtZJJ4+vsG0FQODjYBTYkLk0tBGjgF7CUeb37IBDHITKJraxcjhC0vsf3t
	HOYJjEKzkNwxC8m+WUhaZiFpWcDIsopRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzia
	tLR2MO5Z9UHvECMTB+MhRgkOZiUR3r/2HqlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeb+97k0R
	EkhPLEnNTk0tSC2CyTJxcEo1MF1WervL/n/F56Oij8LEijR0n8/VuH+W/993rYLT68VPcWhP
	KriXwK+6+tbihw42XA6aiZW6WjO9TnBbxM66r8GY5/ZV0++Kvwbv7Zq2tJMzXv5P1P75I/2U
	zD49r8dO+d0emVFHFpvLF7cZbDNSrft5+U9RK3f0/aMeRVoZS04qCDT7r8++F+NcvSxpd/Hd
	/AQW9TYztrTfXytzGc2MPT8tqRPZUzHX3yF45rndK04Hzkor3BiQ/D2iZtnFQk+/ue/C5oUX
	tq+JP8dVfOTD4ptvE34alui9fqjmIK/yP1OQVZnV7aODZLOTwOXtq3h2vNk7V5GXc2LV5LOF
	1fvOuDv5CJqHz5nY4WS47vpDJZbijERDLeai4kQAPrjlkhUDAAA=
X-CMS-MailID: 20231107102516epcas5p4eba405b7fe0ab3deb5286c36ef4e44d3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231027182010epcas5p36bcf271f93f821055206b2e04b3019a6
References: <20231027181929.2589937-1-kbusch@meta.com>
	<CGME20231027182010epcas5p36bcf271f93f821055206b2e04b3019a6@epcas5p3.samsung.com>
	<20231027181929.2589937-2-kbusch@meta.com>
	<40ac82f5-ce1b-6f49-3609-1aff496ae241@samsung.com>
	<ZUkAH258Ts0caQ5W@kbusch-mbp.dhcp.thefacebook.com>

On 11/6/2023 8:32 PM, Keith Busch wrote:
> On Mon, Nov 06, 2023 at 11:18:03AM +0530, Kanchan Joshi wrote:
>> On 10/27/2023 11:49 PM, Keith Busch wrote:
>>> +	for (i = 0; i < nr_vecs; i = j) {
>>> +		size_t size = min_t(size_t, bytes, PAGE_SIZE - offs);
>>> +		struct folio *folio = page_folio(pages[i]);
>>> +
>>> +		bytes -= size;
>>> +		for (j = i + 1; j < nr_vecs; j++) {
>>> +			size_t next = min_t(size_t, PAGE_SIZE, bytes);
>>> +
>>> +			if (page_folio(pages[j]) != folio ||
>>> +			    pages[j] != pages[j - 1] + 1)
>>> +				break;
>>> +			unpin_user_page(pages[j]);
>>
>> Is this unpin correct here?
> 
> Should be. The pages are bound to the folio, so this doesn't really
> unpin the user page. It just drops a reference, and the folio holds the
> final reference to the contiguous pages, which is released on
> completion. 

But the completion is still going to see multiple pages and not one 
(folio). The bip_for_each_vec loop is going to drop the reference again.
I suspect it is not folio-aware.

