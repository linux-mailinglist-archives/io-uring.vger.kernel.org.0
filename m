Return-Path: <io-uring+bounces-2484-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DF6A92C870
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 04:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F4831C21A40
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 02:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920FC4C6B;
	Wed, 10 Jul 2024 02:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OvyowETT"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E7A10A09
	for <io-uring@vger.kernel.org>; Wed, 10 Jul 2024 02:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720578242; cv=none; b=crD8QWhBKBKPcfzIecgxcfuX7rcyO3dW3cq6HjyernxXnOsyU3WNBNjOZZRrRrMbu4TvkBSy1eBkoxagKSNenJdCzdhmf/FFb0msAkYjuzNT/uz8IgMVHmY0SUvefJ/bHyvhHpd8VVnW0dI5DiQTZH3mfbkS9ymNt8HzC85E9Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720578242; c=relaxed/simple;
	bh=29TPJNDYsgyESMsym6y283MT2obJsFpiEM+0Mw7GM4Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=tOh3/RiafJXuPdFZZ6RSAlm+i1D0LA5y29y1mvhwIcH4jXHwfUKx9RmRlaGd7IzRYIOGDi9DXhnNXpTjyng+UQmJGFF7Qk/dT69LPkYIw1zuXlwBsHkfEKvAbF62TXytdC5pC1FwhAQdneOS9jZ+fSOG4sJUYJ8SFnwE3XmdS3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=OvyowETT; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240710022358epoutp01574bc651b7b6cb4475843dcc73e4c352~guMrKdY0X2140921409epoutp01K
	for <io-uring@vger.kernel.org>; Wed, 10 Jul 2024 02:23:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240710022358epoutp01574bc651b7b6cb4475843dcc73e4c352~guMrKdY0X2140921409epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720578238;
	bh=2GbmWxuapHBPAbC+s7mADb18z5aJedQlfSikybpedUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OvyowETTfKHmRCpGQaNUz6Fhzqk7eclDsT3TaJjuKjVPwL0/7Q+3o8jf9AqGzCzQR
	 rggkZabXD83a89ItfVB2Y13XdpXI1eIbGzLMHp4SATbj14+9UHr35vEyAzqWPdQl+D
	 tVc9V0p/GhNLqLZXgJ2EEJ3yuSUZaIRA7A7vbnfA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240710022358epcas5p21c38c4b57af68b9da2de61013928f628~guMqzCFzQ2234622346epcas5p26;
	Wed, 10 Jul 2024 02:23:58 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WJhW11r0Mz4x9Pw; Wed, 10 Jul
	2024 02:23:57 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	39.D4.07307.DB0FD866; Wed, 10 Jul 2024 11:23:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240710022336epcas5p2685a44c8e04962830f4e7f8ffee8168f~guMWgQDSj0945209452epcas5p2s;
	Wed, 10 Jul 2024 02:23:36 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240710022336epsmtrp2be33aed92546adfabc952365794dd7d2~guMWfgIZu0723007230epsmtrp2E;
	Wed, 10 Jul 2024 02:23:36 +0000 (GMT)
X-AuditID: b6c32a44-18dff70000011c8b-a3-668df0bdfa63
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AD.3A.19057.8A0FD866; Wed, 10 Jul 2024 11:23:36 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240710022334epsmtip1a95bb99aa5dd07d49145c723660a5575~guMU2F7yi2244822448epsmtip1i;
	Wed, 10 Jul 2024 02:23:34 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: asml.silence@gmail.com
Cc: anuj20.g@samsung.com, axboe@kernel.dk, cliang01.li@samsung.com,
	gost.dev@samsung.com, io-uring@vger.kernel.org, joshi.k@samsung.com,
	kundan.kumar@samsung.com, peiwei.li@samsung.com
Subject: Re: [PATCH v5 1/3] io_uring/rsrc: add hugepage fixed buffer
 coalesce helpers
Date: Wed, 10 Jul 2024 10:23:30 +0800
Message-Id: <20240710022330.2260-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <e7bfaafa-f890-4e5e-a9b2-95787c60473c@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmpu7eD71pBt8mc1k0TfjLbDFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAlqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE
	3FRbJRefAF23zBygm5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWl
	eel6eaklVoYGBkamQIUJ2RlLFvxhKZjKWbHjaAtjA2MvexcjJ4eEgInEjq+HmLsYuTiEBHYz
	Svy5vpkVwvnEKLH50DYo5xujxO6l+4DKOMBaNi0pAekWEtjLKDH1kSSE3cQkcexlFojNJqAj
	8XvFLxaQchEBKYnfdzlAxjAL7GGU2Lh4ERtIjbBAuMT23g9gNouAqsTbuXfBbF4Ba4mpK/sY
	Ia6Tl9h/8CwziM0pYCux+P1OFogaQYmTM5+A2cxANc1bZ4N9ICHQyCHRu+oaK0Szi8STizC2
	sMSr41ugXpaS+PxuLxvEL8USy9bJQfS2MEq8fzcHarG1xL8re8AeYBbQlFi/Sx8iLCsx9dQ6
	Joi9fBK9v58wQcR5JXbMg7FVJS4c3Aa1Slpi7YStzBC2h8TLf3sZIeE5gVGie9lj9gmMCrOQ
	/DMLyT+zEFYvYGRexSiZWlCcm56abFpgmJdaDo/j5PzcTYzgVKrlsoPxxvx/eocYmTgYDzFK
	cDArifDOv9GdJsSbklhZlVqUH19UmpNafIjRFBjgE5mlRJPzgck8ryTe0MTSwMTMzMzE0tjM
	UEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGpoWBBzV78qpMdn1N2CKw88mt+/6fOF07d//c
	LX77EvenoHvGJtLzDtZa1Xqf2OnGUncvUoaxwLuYIfnc7ISYlGUatWdinP7+1xZm+ulnpeiS
	w974fHPSdz5Rkz/7hGSmaPvEK+/9GJzc/+fwFkWPDibvspqkP69t3k7b9UDruM8J8/ATXWFH
	dll+NzEpfHO9IZep6majd4LdzvlLUm3nfDomvfDH8kdyaenn9b1+7d3A1NsZ05sXMPmY90vz
	5UdSOln8pu9kbz9sdf9y6aznXRNOanWeSWS2WtP4/5zHnk1zGq8fnfm4buKO8hkd98NZQi2i
	721bdUBP/9+dT4/FLzfuu39tm7WT4eYPr9KueyixFGckGmoxFxUnAgAZqXrBLgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWy7bCSnO6KD71pBu8Xy1s0TfjLbDFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujCUL/rAUTOWs2HG0hbGBsZe9i5GDQ0LA
	RGLTkpIuRi4OIYHdjBJ7v35g7WLkBIpLS3QcamWHsIUlVv57zg5R1MAksaZlF1gRm4COxO8V
	v1hABokISEn8vssBUsMscIxRYsa3uywgNcICoRKr7zcwgtgsAqoSb+feZQOxeQWsJaau7GOE
	WCAvsf/gWWYQm1PAVmLx+51gvUICNhK77vewQ9QLSpyc+QQszgxU37x1NvMERoFZSFKzkKQW
	MDKtYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIDnctrR2Me1Z90DvEyMTBeIhRgoNZ
	SYR3/o3uNCHelMTKqtSi/Pii0pzU4kOM0hwsSuK83173pggJpCeWpGanphakFsFkmTg4pRqY
	1kx7fCKUa7ur3eeGoLdsfCwllvWfjyrN6hV/fTEqRU6+P3BC7BpPC5XKHTz/DWQer350d0Xh
	++LWJY/3XWMJlN1z1fLQbesZLJ//izKo8lm8DAhmnXI09faqCVuP8DmL39ogtzLPvyDj/GG7
	KLFrt7fsTKrc4nbBjd9nicxSbe5ZKUJlbBw9/xpnzTsXM+Px6+iPs3zreLo9LpfphyxO2a96
	4sjEsMUnZbeqiT7p7HAV8V0SFJTeLSku46F6ZupXg57DPPkmOQc3zXKdb8SrNNvaVNybW/63
	5joF3ucvj0t13TN5+WYrd4ZmMXtxnefs1afCRA9nH+xcMTGot3219gWeNQ8t9/8+cX3Ko2V3
	lViKMxINtZiLihMBVB2E/uYCAAA=
X-CMS-MailID: 20240710022336epcas5p2685a44c8e04962830f4e7f8ffee8168f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240710022336epcas5p2685a44c8e04962830f4e7f8ffee8168f
References: <e7bfaafa-f890-4e5e-a9b2-95787c60473c@gmail.com>
	<CGME20240710022336epcas5p2685a44c8e04962830f4e7f8ffee8168f@epcas5p2.samsung.com>

On 2024-07-09 13:09 UTC, Pavel Begunkov wrote:
> On 6/28/24 09:44, Chenliang Li wrote:
>> +static bool io_try_coalesce_buffer(struct page ***pages, int *nr_pages,
>> +					 struct io_imu_folio_data *data)
>
> I believe unused static function will trigger a warning, we don't
> want that, especially since error on warn is a thing.
>
> You can either reshuffle patches or at least add a
> __maybe_unused attribute.

OK, will reshuffle the patchset.

>> +	/*
>> +	 * Check if pages are contiguous inside a folio, and all folios have
>> +	 * the same page count except for the head and tail.
>> +	 */
>> +	for (i = 1; i < *nr_pages; i++) {
>> +		if (page_folio(page_array[i]) == folio &&
>> +			page_array[i] == page_array[i-1] + 1) {
>> +			count++;
>> +			continue;
>> +		}
>
> Seems like the first and last folios can be not border aligned,
> i.e. the first should end at the folio_size boundary, and the
> last one should start at the beginning of the folio.
>
> Not really a bug, but we might get some problems with optimising
> calculations down the road if we don't restrict it.

Will add restrictions for that.

Thanks,
Chenliang Li

