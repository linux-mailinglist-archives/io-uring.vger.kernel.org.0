Return-Path: <io-uring+bounces-1666-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA1B8B56F3
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 13:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B603E1F2622A
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 11:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967AD3C24;
	Mon, 29 Apr 2024 11:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MXnPYWyH"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052C229CFA
	for <io-uring@vger.kernel.org>; Mon, 29 Apr 2024 11:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714390872; cv=none; b=du+U5dc4E3TTAFu04H0Kv/X5Kz2p6DTIIXXk1cx0VotpW1KurLowpeD/lryk5g/dO9CHXc9/o/3xsXab4olxGVrBDMKA72xh/lAByhW1D8m9MA7QLoNO6eic1BCx0+SLVxP8l56pF5cO81p+/mZV+WExGarWmqY+L2K23f69cMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714390872; c=relaxed/simple;
	bh=QMl+9alWhuolLU9QFpGeMAt6hJr7x1H9BJV29HtSuaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=jF3UX+OdHqulQCPg7zYxHN1fSnZkrhBsxTlzW/RFDeqjBqtTTrkTNrepPTIEQi+Hy9C5iD3EznlIWt5UmjwY7ghf2QL7Va8NIVDOeSOKqZ1JS457ly1Bva32kCfruCIlxxBqFaSG3VT1c+xDVyW+BNNrFtW+BHcbrjlNIPDpOxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MXnPYWyH; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240429114106epoutp02c9aad3c95c45f4166fa1b3b9274615a6~KvWjZtjlz2967829678epoutp02j
	for <io-uring@vger.kernel.org>; Mon, 29 Apr 2024 11:41:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240429114106epoutp02c9aad3c95c45f4166fa1b3b9274615a6~KvWjZtjlz2967829678epoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714390866;
	bh=a3pyP4bEemb7d+GsEH/IAcPHJa6isWdF7dp4VsFmFUo=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=MXnPYWyHsdFKOwLZdGqC9RFxFwFghrFJLz1Ijvuj8HMHzoCsohYLwTkarBsJTWYcF
	 TaQTZuZ5xsegenInX5dx4tWCSxt4EKoNwh6xPtUBkI4OpKM/jvsOjWCz8bpRq9Rb7q
	 fCsy6zbMbpHQJNzv5NwNUlTXT2t+rq7SNscb+ogg=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240429114105epcas5p244325fc18a9d4e3ee2a8646140b3796f~KvWi_BhmE1402614026epcas5p2r;
	Mon, 29 Apr 2024 11:41:05 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VShH308Fmz4x9Q0; Mon, 29 Apr
	2024 11:41:03 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	22.E7.08600.E478F266; Mon, 29 Apr 2024 20:41:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240429114102epcas5p3094dcac7397ebe86c6781d8e24b8108a~KvWgAHLZ93237632376epcas5p3P;
	Mon, 29 Apr 2024 11:41:02 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240429114102epsmtrp236fc0c7dff77c9ea554972e332edd9e7~KvWf-J_ny0368703687epsmtrp2O;
	Mon, 29 Apr 2024 11:41:02 +0000 (GMT)
X-AuditID: b6c32a44-6c3ff70000002198-d3-662f874e9121
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	77.36.07541.E478F266; Mon, 29 Apr 2024 20:41:02 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240429114100epsmtip1d933e0a32f852cf9c631cdf645afbb81~KvWd7_s8m2492524925epsmtip1d;
	Mon, 29 Apr 2024 11:41:00 +0000 (GMT)
Message-ID: <03cb6ac3-595f-abb1-324b-647ed84cfe6b@samsung.com>
Date: Mon, 29 Apr 2024 17:10:59 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 04/10] block: avoid unpinning/freeing the bio_vec incase
 of cloned bio
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	brauner@kernel.org, asml.silence@gmail.com, dw@davidwei.uk,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20240427070508.GD3873@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmpq5fu36awdW7VhZNE/4yW8xZtY3R
	YvXdfjaL14c/MVq8mrGWzeLmgZ1MFitXH2WyeNd6jsVi0qFrjBZ7b2lbzF/2lN1i+fF/TA48
	HtdmTGTx2DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvT4vEkugDMq2yYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GAlhbLEnFKgUEBi
	cbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGy+2vmQpm
	clf8v/+FuYFxDmcXIyeHhICJxL7L/YxdjFwcQgK7GSV275rNAuF8YpRYt/EhlPONUWLnxu0s
	MC2PJk5gBLGFBPYySixvKoYoessoMW3ORGaQBK+AncTCzn1sIDaLgKrErBX3oOKCEidnPgEb
	JCqQLPGz6wBYjbBAjMT219PB4swC4hK3nsxnArFFBJQknr46C3Yfs8A0Jom1PVOBijg42AQ0
	JS5MLgWp4RTQlni7rxuqV15i+9s5zCD1EgJnOCRm3D3BBnG1i8T+Na+gPhCWeHV8CzuELSXx
	+d1eqJpkiUszzzFB2CUSj/cchLLtJVpP9TOD7GUG2rt+lz7ELj6J3t9PmEDCEgK8Eh1tQhDV
	ihL3Jj1lhbDFJR7OWAJle0j8fDSRHRJuNxglXjy3n8CoMAspVGYh+X4Wkm9mISxewMiyilEy
	taA4Nz012bTAMC+1HB7fyfm5mxjByVnLZQfjjfn/9A4xMnEwHmKU4GBWEuHdNEc7TYg3JbGy
	KrUoP76oNCe1+BCjKTB6JjJLiSbnA/NDXkm8oYmlgYmZmZmJpbGZoZI47+vWuSlCAumJJanZ
	qakFqUUwfUwcnFINTM/upJQue7Wn5uJ+98vH9UP6Hs8wrWz9tOwS04WbAkHrI1fJKq48JKkv
	9OuWS0SH5qWYv7p7A+fJb+aalayWuUK5N/Z6xYGNEQ1RVS6XShK8V6pMdq/Ys8FOhb9s8auN
	nvyfn//cKJgRee1Pf+7XubHHct/uO+mkcOPuzg+v9+cLHJgdt2S//YkzGy2Cr89zltqWrCy3
	lN9h9jG/XoOYHWV2x9yUrl2LmNl5inP+rr5rH6ec76tKsdmy8dY1L/XO02sk3jKuf+O44UL+
	xY3rz4ULtNSnVQquEOC98eUCr9np2qN/zApPBPq9OXfHd/Fjjh3Ri8onfz36JLd8XkhhQ5g0
	1+JvG3/LLVbQLtuVfZFBiaU4I9FQi7moOBEAj+HV9lcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWy7bCSnK5fu36awdKpUhZNE/4yW8xZtY3R
	YvXdfjaL14c/MVq8mrGWzeLmgZ1MFitXH2WyeNd6jsVi0qFrjBZ7b2lbzF/2lN1i+fF/TA48
	HtdmTGTx2DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvT4vEkugDOKyyYlNSez
	LLVI3y6BK+Pl9tdMBTO5K/7f/8LcwDiHs4uRk0NCwETi0cQJjF2MXBxCArsZJS7dX8gGkRCX
	aL72gx3CFpZY+e85O0TRa0aJKUf/MIMkeAXsJBZ27gNrYBFQlZi14h5UXFDi5MwnLCC2qECy
	xMs/E8EGCQvESGx/PR0szgy04NaT+UwgtoiAksTTV2fBrmAWmMYk0f9zMyvEthuMEu1904A2
	cHCwCWhKXJhcCtLAKaAt8XZfN9QgM4murV2MELa8xPa3c5gnMArNQnLHLCT7ZiFpmYWkZQEj
	yypGydSC4tz03GTDAsO81HK94sTc4tK8dL3k/NxNjOBo1NLYwXhv/j+9Q4xMHIyHGCU4mJVE
	eDfN0U4T4k1JrKxKLcqPLyrNSS0+xCjNwaIkzms4Y3aKkEB6YklqdmpqQWoRTJaJg1Oqgany
	p4D2SkvxHe9u+X+bOfHzwtXfZlZt37ZA7ugmRde78Q6CNl+e7rrwOtH89b5kSZvl+Td+r5ft
	XvJz3fmCJd5eS430FOW3dIept7K+2HZoxUITvUe3faP3LQkuLow4en199NOAtg0+n66yL66Y
	mufSuf3qaraLi9I1vQIC/+3//37+Ec6KZmPN0B+bWz+oT/uQYpS9aP+8fdeq5pzcsUbzth3f
	2s9l2mIR55XOTXuneF1+VcyvPTt079gaz7619PqLy1daWuu/fTig0LY1U3eag+Lbz+7vbc91
	ttlE+Xw1Sku26IgvU3hnOOX8x+erW6e295vsfpS00E+1obLulUVdVdSELVu9vl/66SV0wPDI
	GyWW4oxEQy3mouJEAG6RL0I1AwAA
X-CMS-MailID: 20240429114102epcas5p3094dcac7397ebe86c6781d8e24b8108a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184658epcas5p2adb6bf01a5c56ffaac3a55ab57afaf8e
References: <20240425183943.6319-1-joshi.k@samsung.com>
	<CGME20240425184658epcas5p2adb6bf01a5c56ffaac3a55ab57afaf8e@epcas5p2.samsung.com>
	<20240425183943.6319-5-joshi.k@samsung.com> <20240427070508.GD3873@lst.de>

On 4/27/2024 12:35 PM, Christoph Hellwig wrote:
> On Fri, Apr 26, 2024 at 12:09:37AM +0530, Kanchan Joshi wrote:
>> From: Anuj Gupta <anuj20.g@samsung.com>
>>
>> Do it only once when the parent bio completes.
>>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>> ---
>>   block/bio-integrity.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
>> index b4042414a08f..b698eb77515d 100644
>> --- a/block/bio-integrity.c
>> +++ b/block/bio-integrity.c
>> @@ -119,7 +119,8 @@ static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
>>   	ret = copy_to_iter(bvec_virt(&src_bvec), bytes, &iter);
>>   	WARN_ON_ONCE(ret != bytes);
>>   
>> -	bio_integrity_unpin_bvec(copy, nr_vecs, true);
>> +	if (!bio_flagged((bip->bip_bio), BIO_CLONED))
>> +		bio_integrity_unpin_bvec(copy, nr_vecs, true);
>>   }
> 
> This feels wrong.  I suspect the problem is that BIP_COPY_USER is
> inherited for clone bios while it shouldn't.
> 

But BIP_COPY_USER flag is really required in the clone bio. So that we 
can copy the subset of the metadata back (from kernel bounce buffer to 
user space pinned buffer) in case of read io.

Overall, copy-back will happen in installments (for each cloned bio), 
while the unpin will happen in one shot (for the source bio).

