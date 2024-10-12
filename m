Return-Path: <io-uring+bounces-3625-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77DDB99B28E
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 11:30:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29C9428453A
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 09:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80A3E149C53;
	Sat, 12 Oct 2024 09:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Wcpu6+dm"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5454315F
	for <io-uring@vger.kernel.org>; Sat, 12 Oct 2024 09:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728725444; cv=none; b=WG7Yb2nxj+K4d8Bj8FjOkiHVnqb7n/3zQFos9j/sPJWYW7mFJC8fkIu09NJGmDa8ksQ4L0L6ijtyF99wW29oCaxUrAC2+Ts6mznS0hL1tO7WKWnWQZEyVylvz3fZNe1wJ+FNkdDhMYhBV+a0IQnDJgHQhVzX4k2g4DqUqEoTCiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728725444; c=relaxed/simple;
	bh=6Vmd7fcKE8gbR2cCPvAillZIaE8rpwv65M5fM0UFrlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=QLStPC9U+gL3J9mvYnYMm0pahutTzR9liYjbJCb6aDLOvFjcIMciWGzC3pXnc3zyp57CtkXG4AyDk8Ul0NpxHyMxah+xxGaHwJGXoMkbWzSSECN+I96h3hHUSE8VFMUpbi0D4RxHWzhZzW1/G2aTIeCRjusZu/eYuWYSb33j+wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Wcpu6+dm; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241012093034epoutp0349e7d413082000c150e6954b462aecce~9qp_FzVF11363113631epoutp03X
	for <io-uring@vger.kernel.org>; Sat, 12 Oct 2024 09:30:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241012093034epoutp0349e7d413082000c150e6954b462aecce~9qp_FzVF11363113631epoutp03X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728725434;
	bh=vuxMMAliy5LbxYqHOKd1/RK04LojR8G4oTBP4qQR32I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wcpu6+dmpyjT79LpzCgUF09ZtOqb1f4fjajwmwzwVePebWMYBOZxhHZx3U2kenGS+
	 GRAEkSN1ko0Y6YOhY5HfgWsy9PzMK/ZI8fY0exVyFdD8KQCfbOfhltk3nmSm8Aca+k
	 kFkBwkEfL8dt8Hces0GleZhORe7YC8MNP/XmY+dI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241012093033epcas5p470fb210555be3043004d8a7f8e3d4459~9qp9X7nEi3115331153epcas5p4-;
	Sat, 12 Oct 2024 09:30:33 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XQdWq448Fz4x9Pr; Sat, 12 Oct
	2024 09:30:31 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	10.D2.09420.7B14A076; Sat, 12 Oct 2024 18:30:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241012091032epcas5p2dec0e3db5a72854f4566b251791b84ad~9qYfbH0Uk0226602266epcas5p2W;
	Sat, 12 Oct 2024 09:10:32 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241012091032epsmtrp16a917033438099983215da25ec63bf1a~9qYfZf9WP1886618866epsmtrp13;
	Sat, 12 Oct 2024 09:10:32 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-28-670a41b7ecf8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	CD.EB.18937.80D3A076; Sat, 12 Oct 2024 18:10:32 +0900 (KST)
Received: from dev.. (unknown [109.105.118.18]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241012091031epsmtip118325eee792670ef8b0ee3765a24c30d~9qYeYORfK0849208492epsmtip1j;
	Sat, 12 Oct 2024 09:10:31 +0000 (GMT)
From: Ruyi Zhang <ruyi.zhang@samsung.com>
To: asml.silence@gmail.com
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	peiwei.li@samsung.com, ruyi.zhang@samsung.com
Subject: Re: [PATCH v2 RESEND] io_uring/fdinfo: add timeout_list to fdinfo
Date: Sat, 12 Oct 2024 09:10:25 +0000
Message-ID: <20241012091026.1824-1-ruyi.zhang@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <e8d1f8e8-abd9-4e4b-aa55-d8444794f55a@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42LZdlhTQ3e7I1e6Qe8yaYs5q7YxWqy+289m
	8a71HIvFr+67jBaXd81hs3i2l9Piy+Hv7BZnJ3xgdeDw2DnrLrvH5bOlHn1bVjF6fN4kF8AS
	lW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SEkkJZ
	Yk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE7
	Y39nacEOgYqOk7+ZGhjf83QxcnJICJhI/Fp4mqWLkYtDSGA3o8TNL3eZIJxPjBJfNvxkg3MO
	TdrEDtPysaMZqmUno8T9zVehWp4wSpw9+p0JpIpNQFPi8swGxi5GDg4RASmJ33c5QMLMAjUS
	12ZPZAOxhQW8JNp/LASzWQRUJU69PcMCUs4rYCWx+Sc/xC55icU7ljOD2JwCthK3115hBbF5
	BQQlTs58wgIxUl6ieetsZpATJATusUs8njeRGaLZRWLFknWMELawxKvjW6AekJJ42d/GDrJL
	QqBY4mFfPkS4gVFi2+86CNta4t+VPWDnMAN9sn6XPkRYVmLqqXVMEGv5JHp/P2GCiPNK7JgH
	Y6tIvF/xjglm0/rW3VC2h8SEQ5vBThYSmMAo8el+6ARGhVlIvpmF5JtZCJsXMDKvYpRMLSjO
	TU8tNi0wzEsth8dwcn7uJkZwotTy3MF498EHvUOMTByMhxglOJiVRHjfT+VMF+JNSaysSi3K
	jy8qzUktPsRoCgzticxSosn5wFSdVxJvaGJpYGJmZmZiaWxmqCTO+7p1boqQQHpiSWp2ampB
	ahFMHxMHp1QDE8tzM97VsjsmHBdpPnLfO+ZulIDD37XNivdP2at+bnxanvP1256W4yYvAlm9
	8icuSiut/Gj89Nu7tv35/zOKNThL3domMFfk7+hxn8SxJ7zteSxHxlLeA5L8jxfcc5/zdVVf
	rQtjwAW5pRxyPs82Ty4VDv7+wal3QtTOey1Vn2TbQyZvqntn7126WWrz5feeySeDpz978GBH
	z6SkS+KNuimcz9asXbvg7Za9E6rSly1M07jgKGgSe256C6+JU/C7A86Lziz+uEXrfZXOD7VF
	V98YaZ+qXfGz3C6UfXZ2kOzbLc8vhHh8lePKnxdhb1e2Sag30OrZn7+zXzHNn77uzjQVuyMm
	u9aeu6p5Q9VM4pkSS3FGoqEWc1FxIgD3sU7IHQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsWy7bCSnC6HLVe6wfINJhZzVm1jtFh9t5/N
	4l3rORaLX913GS0u75rDZvFsL6fFl8Pf2S3OTvjA6sDhsXPWXXaPy2dLPfq2rGL0+LxJLoAl
	issmJTUnsyy1SN8ugStjf2dpwQ6Bio6Tv5kaGN/zdDFyckgImEh87Ghm6WLk4hAS2M4oce7t
	LBaIhJTEzaZjTBC2sMTKf8/ZQWwhgUeMEveWKYHYbAKaEpdnNjB2MXJwiADV/77LATKHWaCJ
	UeLNvS1gvcICXhLtPxaygdgsAqoSp96eYQGp5xWwktj8kx9ivLzE4h3LmUFsTgFbidtrr7BC
	rLKROPHiJJjNKyAocXLmE7DTmIHqm7fOZp7AKDALSWoWktQCRqZVjKKpBcW56bnJBYZ6xYm5
	xaV56XrJ+bmbGMFBrBW0g3HZ+r96hxiZOBgPMUpwMCuJ8L6fypkuxJuSWFmVWpQfX1Sak1p8
	iFGag0VJnFc5pzNFSCA9sSQ1OzW1ILUIJsvEwSnVwMT3MrYlnFfY5v3+FRcYFCRsJopMCa2r
	ydc44PF5+QXtSbNzutT7NuVGLe28u7qNsdguePGxg3t/s222CAm0OXetwVria7C0T79g9KWJ
	scKBoiKNaw/cf/s1f7lEQDuz1Tafo/nhC24nW0bY1smZhlmJ5al+bOg7Y/9GXcfXmLXfxr8n
	ro0zeN0fs+SiHGXvaevnrk58aTNhakH/9RNy/GGNMWfbp2krZz1dIdF7z156Up2JyUSOU74n
	u+v81nocnS9qlcJzZcvu3KJp0R2PH9ZcvfOkiKfucWQt40TePdcctF1X7o4XcPTZFnSRN+PV
	1/8Pr8/atlTn+80V9Rtnz2n5Ubzi+abQc30NB/V3KbEUZyQaajEXFScCAL+PZ07RAgAA
X-CMS-MailID: 20241012091032epcas5p2dec0e3db5a72854f4566b251791b84ad
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241012091032epcas5p2dec0e3db5a72854f4566b251791b84ad
References: <e8d1f8e8-abd9-4e4b-aa55-d8444794f55a@gmail.com>
	<CGME20241012091032epcas5p2dec0e3db5a72854f4566b251791b84ad@epcas5p2.samsung.com>

---
On 2024-10-10 15:35 Pavel Begunkov wrote:
>> Two questions:
>> 
>> 1. I agree with you, we shouldn't walk a potentially very
>> long list under spinlock. but i can't find any other way
>> to get all the timeout

> If only it's just under the spin, but with disabled irqs...

>> information than to walk the timeout_list. Do you have any
>> good ideas?

> In the long run it'd be great to replace the spinlock
> with a mutex, i.e. just ->uring_lock, but that would might be
> a bit involving as need to move handling to the task context.
 
 Yes, it makes more sense to replace spin_lock, but that would
 require other related logic to be modified, and I don't think
 it's wise to do that for the sake of a piece of debugging
 information.

>> 2. I also agree seq_printf heavier, if we use
>> seq_put_decimal_ull and seq_puts to concatenate strings,
>> I haven't tested whether it's more efficient or not, but
>> the code is certainly not as readable as the former. It's
>> also possible that I don't fully understand what you mean
>> and want to hear your opinion.

> I don't think there is any difference, it'd be a matter of
> doubling the number of in flight timeouts to achieve same
> timings. Tell me, do you really have a good case where you
> need that (pretty verbose)? Why not drgn / bpftrace it out
> of the kernel instead?

 Of course, this information is available through existing tools.
 But I think that most of the io_uring metadata has been exported
 from the fdinfo file, and the purpose of adding the timeout
 information is the same as before, easier to use. This way, 
 I don't have to write additional scripts to get all kinds of data.

 And as far as I know, the io_uring_show_fdinfo function is
 only called once when the user is viewing the 
 /proc/xxx/fdinfo/x file once. I don't think we normally need to 
 look at this file as often, and only look at it when the program
 is abnormal, and the timeout_list is very long in the extreme case,
 so I think the performance impact of adding this code is limited.

---
Ruyi Zhang

