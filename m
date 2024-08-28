Return-Path: <io-uring+bounces-2962-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF1E9628F6
	for <lists+io-uring@lfdr.de>; Wed, 28 Aug 2024 15:42:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4AED1C21DD5
	for <lists+io-uring@lfdr.de>; Wed, 28 Aug 2024 13:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20961187FF0;
	Wed, 28 Aug 2024 13:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JZC8Drhk"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB65187859
	for <io-uring@vger.kernel.org>; Wed, 28 Aug 2024 13:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724852554; cv=none; b=f4qCNrzwd4o2t/hQI/L+/4NJfQrmZkqVcUvlcz37bpJEhuj+yRyjQGaO0F5yuPbRVFfUS0DLQiQBWn9nWk25a1xS1Q2N1AibJ/OA+2oS3XobdAcnaML8/Ht6cuQFFgm105+nblcHwPD+L/qlX7j7Dce/zlaCa1ZU7ODZqrb1DlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724852554; c=relaxed/simple;
	bh=bCJ69UDxmXGm2VFPIAxCXBcdPsECokjgmfWk7+5BQKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=VVUuq5pZjTwJq0XrZxIWQ4M+OXPcEGKGbsIOcpGbggNv7M3NO7i8rNfZxC80ZnLMOiaB8eguGnMeDBz7RjuHVcwQjE3j49wl19df6Km/RW0KDEoCiETdR3zg6TAIYaH++W3o3jC0WBZyWRKJmU7J7kc/0hgLpXMwqQCXnlkUbV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JZC8Drhk; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240828134229epoutp0371561e8464129ea2425d18267ec55250~v6EFeNzPZ3123631236epoutp03f
	for <io-uring@vger.kernel.org>; Wed, 28 Aug 2024 13:42:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240828134229epoutp0371561e8464129ea2425d18267ec55250~v6EFeNzPZ3123631236epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1724852549;
	bh=pupbnGfWeNRdoCnvuS0X6cju7U4buS/r8MZGN0NqYmw=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=JZC8DrhkC8tdYS6Nz6CyX+s45Y7NminfGYX352iX8NlucjOlDg6mq/9q1+sOIk3qv
	 TLXLjCRmkNSKZa+SKRBhgn8nozeUCjms11x7piW+tIbLbKSCkCbrdS72auN5Gx1fU4
	 e5lbtCcxdF6F5ZvpnoULqTVpOzPj4XN0L1kqJW+A=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240828134228epcas5p3f510b3eab13dbc4bb4c2b55d9f96d65d~v6EErr3zP2724627246epcas5p36;
	Wed, 28 Aug 2024 13:42:28 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Wv5FH1hzKz4x9Pq; Wed, 28 Aug
	2024 13:42:27 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4C.0C.09642.3492FC66; Wed, 28 Aug 2024 22:42:27 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240828134226epcas5p3a5b9111def9d3467e80a9d0cc1db8c88~v6ECbszA72725527255epcas5p34;
	Wed, 28 Aug 2024 13:42:26 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240828134226epsmtrp1bb066930072ca3411f44ced6a1c38b64~v6ECbCfR_2641726417epsmtrp1V;
	Wed, 28 Aug 2024 13:42:26 +0000 (GMT)
X-AuditID: b6c32a4b-613ff700000025aa-83-66cf29434ec2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	B0.DE.19367.2492FC66; Wed, 28 Aug 2024 22:42:26 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240828134224epsmtip1195ed1d55737a47d10223d8238267584~v6EAMBTNd1110811108epsmtip1b;
	Wed, 28 Aug 2024 13:42:23 +0000 (GMT)
Message-ID: <fe85a641-c974-3fa7-43f1-eacbb7834210@samsung.com>
Date: Wed, 28 Aug 2024 19:12:22 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v3 07/10] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG
 bip_flags
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20240824083553.GF8805@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEJsWRmVeSWpSXmKPExsWy7bCmuq6z5vk0g55PbBZNE/4yW8xZtY3R
	YvXdfjaLmwd2MlmsXH2UyeJd6zkWi0mHrjFabD+zlNli7y1ti/nLnrJbdF/fwWax/Pg/Jgce
	j52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8eovFo2/LKkaPzaerPT5vkgvgjMq2yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6V0mhLDGnFCgUkFhc
	rKRvZ1OUX1qSqpCRX1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQndHTdYW1YD1r
	xZI/xQ2M01i6GDk5JARMJI6sWc/WxcjFISSwm1Hi5rQuRgjnE6PEtMWTmeGcHc+uscG0zFg7
	gxUisZNRouX0MVaQhJDAW0aJXX1WIDavgJ3EwolXwXawCKhK7L54kB0iLihxcuYTsLioQJLE
	r6tzGEFsYYEIiZ/XesDmMAuIS9x6Mp8JxBYRcJU49eAi2BXMAr8YJZZN7wNyODjYBDQlLkwu
	BanhFNCWWHRwAxNEr7zE9rdzwOolBI5wSHz5fIoV4moXiWmnfkPZwhKvjm9hh7ClJF72t0HZ
	2RIPHj2ABkyNxI7NfVD19hINf26wguxlBtq7fpc+xC4+id7fT5hAwhICvBIdbUIQ1YoS9yY9
	heoUl3g4YwmU7SHRdeoNOySobjFKrD0ZP4FRYRZSqMxC8v0sJN/MQli8gJFlFaNkakFxbnpq
	sWmBcV5qOTy6k/NzNzGCE7OW9w7GRw8+6B1iZOJgPMQowcGsJMJ74vjZNCHelMTKqtSi/Pii
	0pzU4kOMpsDomcgsJZqcD8wNeSXxhiaWBiZmZmYmlsZmhkrivK9b56YICaQnlqRmp6YWpBbB
	9DFxcEo1MNUpKHveSFurK3tPXlqNa7XEYcFoYatHl7L6dH48X7km/Wpgwbf9qyWTU3TluLf1
	t5zimiQnoC20s1Mu5ON8qVm2YYFnzjSYBnzieTort/qDyFK5GfO1LjFOkOB0vlbwO++j8MK6
	Kzaaa6d7/svboaxXNJVxucyD06wqojd9ladk/vq+eI45k0RKgozRnbSQuQx8Tf2zAr7PM9wt
	IdP5YVljg7N/yZyeGWq/hHjPLnJ4/DigYdlKYR2jJTFf3LpSrG5NeiTVfoiLi+NHiEyM1JG9
	YZ1lU843751V//eWxhGPd5PKxL7If649FM3h9Xj3A9b8RKGCGUrV51h8ZOd7SKwzF7rl2bv5
	qfJNpyhuJZbijERDLeai4kQAnNcDRVUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSnK6T5vk0g3uLRSyaJvxltpizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02H5mKbPF3lvaFvOXPWW36L6+g81i+fF/TA48
	Hjtn3WX3uHy21GPTqk42j81L6j1232xg8/j49BaLR9+WVYwem09Xe3zeJBfAGcVlk5Kak1mW
	WqRvl8CV0dN1hbVgPWvFkj/FDYzTWLoYOTkkBEwkZqydwdrFyMUhJLCdUWLni49MEAlxieZr
	P9ghbGGJlf+es0MUvWaU2HvhJStIglfATmLhxKtgk1gEVCV2XzzIDhEXlDg58wlYXFQgSWLP
	/UawocICERI/r/WA9TIDLbj1ZD5YXETAVeLUg4vMIAuYBX4xSry62AK17RajxKXdn4GqODjY
	BDQlLkwuBWngFNCWWHRwAxPEIDOJrq1djBC2vMT2t3OYJzAKzUJyxywk+2YhaZmFpGUBI8sq
	RtHUguLc9NzkAkO94sTc4tK8dL3k/NxNjOAI1Arawbhs/V+9Q4xMHIyHGCU4mJVEeE8cP5sm
	xJuSWFmVWpQfX1Sak1p8iFGag0VJnFc5pzNFSCA9sSQ1OzW1ILUIJsvEwSnVwLT72d5rU5lZ
	PDb6qLb3yIjFtfxU7t/zfd4y02kfDj446bSv5X3kZg6toGD1Tv5v5SeMb0isfuq/3Spl6het
	NXf3tH4qWj6l/3a0zgN34zxvUd3gCtnpz+5rH+S4LbbnQ9gPFtayQ/0CibJh1i88TJe4O9s1
	Wp3dHzux7IVwy+tU3tqqzyv+c7Y++56WGTHJktNL623KljVrawTOLdq8O+qtaKdPTXW3v33Z
	9s0X1x2IlQ07mPDrzIajP9c0Loj+kcBwSLC5f/e98nNcV0707Lti7fKqMvq924JblmEKKyM8
	Vt9ZqxT3/FDDytdclw/v/rVI/YMn/+u7XEeesDEqh3jv5vO+cWTN0QChIL131d+VWIozEg21
	mIuKEwHirIN/LwMAAA==
X-CMS-MailID: 20240828134226epcas5p3a5b9111def9d3467e80a9d0cc1db8c88
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240823104629epcas5p3fea0cb7e66b0446ddacf7648c08c3ba8
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104629epcas5p3fea0cb7e66b0446ddacf7648c08c3ba8@epcas5p3.samsung.com>
	<20240823103811.2421-8-anuj20.g@samsung.com> <20240824083553.GF8805@lst.de>

On 8/24/2024 2:05 PM, Christoph Hellwig wrote:
> How do we communicate what flags can be combined to the upper layer
> and userspace given the SCSI limitations here?

Will adding a new read-only sysfs attribute (under the group [*]) that 
publishes all valid combinations be fine?

With Guard/Reftag/Apptag, we get 6 combinations.
For NVMe, all can be valid. For SCSI, maximum 4 can be valid. And we 
factor the pi-type in while listing what all is valid.
For example: 010 or 001 is not valid for SCSI and should not be shown by 
this.

[*]
const struct attribute_group blk_integrity_attr_group = {
          .name = "integrity",
          .attrs = integrity_attrs,
};

