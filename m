Return-Path: <io-uring+bounces-2485-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D32892C88D
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 04:32:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3EC1B2215E
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 02:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47FBE1803D;
	Wed, 10 Jul 2024 02:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="I7gM6qwH"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7C422075
	for <io-uring@vger.kernel.org>; Wed, 10 Jul 2024 02:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720578713; cv=none; b=MbcMUM4hncKEnBJtaC1vS/Mg4izfwSxaouz7pWVHAcyiL3kFpcFyZavRcmFX9LCgtOvLY0zeYJfjLAQloHqzCkeHmF4oF0wsu+JRQv67IMvZOl2JFTpE8wIGNuBXJyAYlQe/dc2ZsAw5POLVrWdi7AWB7XQ1VUmBKX5jDyMlSPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720578713; c=relaxed/simple;
	bh=3ZiXEEQsN0Sutz5uTFsHCp8jFY4n11NMj2yIWHsik6w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=cuyi8fUkn+ySGfWpFnrk4V0DcH5Fg8wqZ1nAoXojZKV5qkdifPLK58mH/rBHDvAsj67KChbhP7ittXJ/0KknTJkYQjiMviip3jU8dXFZjsQfUZFZjbJHjJFZBvyWxz8k7RDNNDA7Zy4HCV4VO3AColPWUChS4I7XXhLPpOoXLYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=I7gM6qwH; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240710023149epoutp0206428c43cdbe211572bb6c9cbbf1f14a~guThp1w-41666916669epoutp02T
	for <io-uring@vger.kernel.org>; Wed, 10 Jul 2024 02:31:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240710023149epoutp0206428c43cdbe211572bb6c9cbbf1f14a~guThp1w-41666916669epoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720578709;
	bh=my3156mbzvOUICXqeLwg8dr2Dwl9jQz2aLaz/uOfsv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7gM6qwHpZKawofQdxSMpAKQg0sX+2fIwD8waqmRNJsTrtN6XAxcBVwEpz36Rrub0
	 9jg2PBYWOSyACmllo4zmV8NfYBVR5d0Fb9KFRM+UX2AUTRn2w7VQThNrJcX9cQDTTF
	 HLiw5SgTKC70xiw4l1hn6x4h8M8d7DRVVd5eaqOI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240710023149epcas5p1a178c0dc0d92d21268ab7849ef769490~guThOk0X60092500925epcas5p1j;
	Wed, 10 Jul 2024 02:31:49 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WJhh36TD6z4x9Q1; Wed, 10 Jul
	2024 02:31:47 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6C.A3.19174.392FD866; Wed, 10 Jul 2024 11:31:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240710022900epcas5p368c4ebc44f3ace1ca0804116bd913512~guREDqJet2697326973epcas5p3g;
	Wed, 10 Jul 2024 02:29:00 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240710022900epsmtrp23e0c16e97df71b8c1d36ae38a58e430a~guRECT1E-0997309973epsmtrp23;
	Wed, 10 Jul 2024 02:29:00 +0000 (GMT)
X-AuditID: b6c32a50-b33ff70000004ae6-9c-668df293ad8e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	5E.6B.18846.CE1FD866; Wed, 10 Jul 2024 11:29:00 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240710022859epsmtip2507655848ab740d65df7d44f2b4cac56~guRC27GnI0815908159epsmtip2e;
	Wed, 10 Jul 2024 02:28:59 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: asml.silence@gmail.com
Cc: anuj20.g@samsung.com, axboe@kernel.dk, cliang01.li@samsung.com,
	gost.dev@samsung.com, io-uring@vger.kernel.org, joshi.k@samsung.com,
	kundan.kumar@samsung.com, peiwei.li@samsung.com
Subject: Re: [PATCH v5 3/3] io_uring/rsrc: enable multi-hugepage buffer
 coalescing
Date: Wed, 10 Jul 2024 10:28:55 +0800
Message-Id: <20240710022855.2281-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <4e6d1195-3073-401c-91ad-a1f3adc45a77@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsWy7bCmhu7kT71pBgd/GVk0TfjLbDFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAlqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWl
	eel6eaklVoYGBkamQIUJ2Rlnli9hK3jJXnF/8QnmBsYOti5GTg4JAROJvW1vWLoYuTiEBPYw
	SsxsnALlfGKUWPPhDSuc83ZZD3sXIwdYS/PtDIj4TkaJz+97mCGcJiaJ/Qd3MILMZRPQkfi9
	4hcLSIOIgJTE77scIDXMICs2Ll4EtltYIERizdZ7rCA2i4CqRMPz9UwgNq+AtcTFu7NYIe6T
	B5p5lhnE5hSwlXj4/B8LRI2gxMmZT8BsZqCa5q2zwY6QEPjLLnFpyT9miEtdJLZOM4GYIyzx
	6vgWdghbSuLzu71sECXFEsvWyUG0tjBKvH83hxGixlri35U9YPczC2hKrN+lDxGWlZh6ah0T
	xFo+id7fT5gg4rwSO+bB2KoSFw5ug1olLbF2wlZmCNtD4sOzl4yQsJrAKLFu32nWCYwKs5C8
	MwvJO7MQVi9gZF7FKJVaUJybnppsWmCom5daDo/l5PzcTYzgdKoVsINx9Ya/eocYmTgYDzFK
	cDArifDOv9GdJsSbklhZlVqUH19UmpNafIjRFBjgE5mlRJPzgQk9ryTe0MTSwMTMzMzE0tjM
	UEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGJvWJ9bcjE2qDzk7rUOuYms8iu+toSdKMLX/r
	orlvBPPNzjPle2WTcnLG7U+Ok3muS98/kPLKevl/8VWTndpX7ZdlYdaydGKcEr4xc3PONMZl
	Zqpd19bU+r9J5mAX8vJ8eGSfh05pXcisT7a7l4cVvbD1Suy+H8FrfljdLuGPtPSfub2K7Sve
	ZHt3KG48rHGJ4YjK6Wtt8+PL5vTH7UqoPT+pXmDfdkex161z7HPOebeoNJdf0A8usJhwd21w
	ZGjn+1qWOoGaGV9OT1ufzy++aMmf348lr5fFszfmrPEXf7JtZ/f035+MN3Jl5xx88KK/o1E5
	1GPPwj8HpUQOfL3lXLUi9PmM0q3e89TePe/xVGIpzkg01GIuKk4EAMVvyvQwBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWy7bCSvO6bj71pBrP/CVk0TfjLbDFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujDPLl7AVvGSvuL/4BHMDYwdbFyMHh4SA
	iUTz7YwuRk4OIYHtjBItk6xAbAkBaYmOQ63sELawxMp/z4FsLqCaBiaJQ683MYIk2AR0JH6v
	+MUCMkdEQEri910OkBpmgWOMEjO+3WUBqREWCJLYv2I52CAWAVWJhufrmUBsXgFriYt3Z7FC
	LJCX2H/wLDOIzSlgK/Hw+T8WiINsJLZ+ecYIUS8ocXLmE7A4M1B989bZzBMYBWYhSc1CklrA
	yLSKUTS1oDg3PTe5wFCvODG3uDQvXS85P3cTIzjItYJ2MC5b/1fvECMTB+MhRgkOZiUR3vk3
	utOEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8yrndKYICaQnlqRmp6YWpBbBZJk4OKUamAz4LLWm
	d8/cKnMsQdWX6aP73hrLyrkHnKt8HE0+F1U9mu7yfunErX+k3n5Tvbzhney73x4Rzx+7THGa
	H5995Nkq1ryTB394aMwSl+9658jpPKHksdFz5Rtrjs/p3r13fs+6U009tpUzX646ceBl0Ic1
	pZmOnI7t6Tx/5s5y7HA6ceDSGnfW6gur/p68bMrLqDxZykT08b8zZtXPbh3dyFK/RKP7nsrK
	2emc4qzTPUIWOM5jXCgjd9Hi5O+Nv44nPDz9Kbm3YJLovd1nlL/P0E1n+dUdGz+d72/iK5vm
	r3zuzAz3Nefq32aNKhc11eFZwKmygrWfKWuZY8uzr9brr8WZ5FSmn2VxOfpOY1Vv9GIlluKM
	REMt5qLiRADmo3af4QIAAA==
X-CMS-MailID: 20240710022900epcas5p368c4ebc44f3ace1ca0804116bd913512
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240710022900epcas5p368c4ebc44f3ace1ca0804116bd913512
References: <4e6d1195-3073-401c-91ad-a1f3adc45a77@gmail.com>
	<CGME20240710022900epcas5p368c4ebc44f3ace1ca0804116bd913512@epcas5p3.samsung.com>

On 2024-07-09 13:17 UTC, Pavel Begunkov wrote:
> On 6/28/24 09:44, Chenliang Li wrote:
>> -	if (folio) {
>> -		bvec_set_page(&imu->bvec[0], pages[0], size, off);
>> -		goto done;
>> -	}
>>   	for (i = 0; i < nr_pages; i++) {
>>   		size_t vec_len;
>>   
>> -		vec_len = min_t(size_t, size, PAGE_SIZE - off);
>> +		if (coalesced) {
>> +			size_t seg_size = i ? data.folio_size :
>> +				PAGE_SIZE * data.nr_pages_head;
>
> When you're compacting the page array, instead of taking a middle
> page for the first folio, you can set it to the first page in the
> folio and fix up the offset. Kind of:
>
> new_array[0] = compound_head(old_array[0]);
> off += folio_page_idx(folio, old_array[0]) << PAGE_SHIFT;
>
>
> With that change you should be able to treat it in a uniform way
> without branching.
> 
> off = (unsigned long) iov->iov_base & ~folio_mask;
> vec_len = min_t(size_t, size, folio_size - off);

That's brilliant. Will change it this way.

Thanks,
Chenliang Li

