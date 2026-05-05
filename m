Return-Path: <io-uring+bounces-13240-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OOQPFaLv+WmcFQMAu9opvQ
	(envelope-from <io-uring+bounces-13240-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 05 May 2026 15:24:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E83AB4CE6B0
	for <lists+io-uring@lfdr.de>; Tue, 05 May 2026 15:24:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A622A3034D4C
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2026 13:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93B7940B6DC;
	Tue,  5 May 2026 13:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="LJB0AHYK"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42F11B983F
	for <io-uring@vger.kernel.org>; Tue,  5 May 2026 13:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777987403; cv=none; b=gspqEHM5GnXdLskqUDiqHZjOdVfMCViMM/SgSnBuoze13pltb0cARvdOq9iZuKvh9pyZurF8dWqtLEF/j9uLQLy2IseFkKCft1yYYB3as2HlKYm7+pH0DtF5lABChFU9ToT+viSMqEv36gHKAFcNzXgNGiowoO+VaZw4P7qwBiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777987403; c=relaxed/simple;
	bh=IqkZVf5tgsvZqIerSXBzFWwT0qoGvqbt02Q8vUA+tBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AP/VqVOk1ZJA8Ucsm4t0ykZMdKR7JzdDKuSx97imqRm0Zj03BNBv7lUpDbfGAYY3E4Eh2XXOI14x5KugHEJBj7xyVrgGiiUp23x3z7LrapbLVw9Svm1+Yl3a+g6zgPyx9sENwMS/4ry27b6ait6sUf8l9oIlXgqE2t7+f682nPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=LJB0AHYK; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 645D1slR791585
	for <io-uring@vger.kernel.org>; Tue, 5 May 2026 06:23:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=mbjdbFLZGUU8lfZHuiUCvPC+kC14AzNuHsxbWhhGfHc=; b=LJB0AHYKnTH3
	rIBI9d/AWpLeFJKjq4PluIoUxG1AVsFCyL5MnV0b0hCdbYdPMIg8OZqx1+lWSsv/
	cFzvFVt88mUoDjvJSnmRiMJx5qqq5PDwke4qoJDBQjB8xi2cFd9SY1YpNlZY7j3q
	Cf2fXTA/4/Il7+RIZAFcY8nZolVwpsT/bhp/Vkf2gbvjTVP1yE8O79BJOI6VhO/r
	3IHxvvJYbPyIz5EQ9Hy1LMi59DmlJZY11Pe/VGBWppMlsq0yXCvFEGfhowaWDC7L
	WvDRhZbCnYuzmau5FF+rFOb7gTLnmE4Wn0Xi8Aeq3RNGMo3ryc+rZSdc6UIgghu1
	fHL0G6vmuQ==
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4dwf3707jd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 05 May 2026 06:23:20 -0700 (PDT)
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-488a8741604so6479765e9.0
        for <io-uring@vger.kernel.org>; Tue, 05 May 2026 06:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777987399; x=1778592199;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M0IFtGSJpMS01UjuQ4xgV0yjZEm4WSH7x6f/5TvpdWg=;
        b=TqSIz//boiM/QZRDI9STEXM1VLQQ/Ajq2/iPp/ZTKSGaXbk4gKfoICYbLBoh+kqauc
         nZnNAtKYS1iv0DjUl41imcAz4y7kRyKPJmOjeT7vg7qVE2qjkqxR5f2pMolksVpkkXjt
         H4e7zHQ3hRZwxmI15gF74q8nzNBFpoEKuAEnYReNlL/dcyWSwdcmq75rAFW0ftaOTK9L
         oiMEwzst7Ub6vVZydFfpOPPC+5pNUg45OTvtPEKMJVJPKgw9iwkLyL0IOTickCBiHFXT
         O4nP+zHVG+YGymdG/6v72X4K4i5HqgPpKV5W2pDCA0BwS6M9hvHREO54DZpymQYiDbeE
         93OA==
X-Forwarded-Encrypted: i=1; AFNElJ8v+F+unSeaMtAe4yQ5HO+Jx0blAheZWwSti3TDe7LvTqHrJbfXFwleB+VpFaOj3jyzwt+oush4NA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGp0OuGLxqNl5xCTkkjl+dD5YiPN2uWvRW6n3R2EPTKCjwpqa7
	uD/FD4TxBG7cOVHj1vakNAOgAsdBASb33CAS1JUXGPU7+TkunEQd6bFntRdjrsxz5p/j2tETiMs
	0TB/7Wy2+gXhD96U0cGq4sbzC7+T9d2g/XFbSE8Fvd2lTZ/yB8Fnbt85oB2I=
X-Gm-Gg: AeBDietmDhTftzsy182G6xIdP9gO6Ab0AKEmkR5YcxPiOldlQtAA+sfi+Je8M4qTCwq
	7KoHLknv30d9X4fytlv/vyjADDNygHt50dRSYJbwuH3qnyhTlFb3LxfdjeeKHYln9zIDschK1Lf
	iLghKlvK0weC/ONOrbazGGwV0cceZEvICfarFSEZggIzW4NUEZYXnP21Tns6+BVerZ101qUH9hX
	z3ILgnv97Cq82XefO741Frng3I7DnJ3/WLlwG1pJ2OAER8CmGAARhJ8QRhj/WBEGpQKMI/AKCK7
	lfLm3ew2sE2+MQhB7dHBnXzV2OcGKsuQ1OUqU7yc/qTd0hbQpJ0j1bbNGRTvlDo0STpF26CAlUY
	JfLe7CE7ceHKE4TBkZoR3rB4var1I5nTR6/MUrDyYcslG5siSrQhOvEaaLUwy/Wnrkxpjwcku
X-Received: by 2002:a05:600c:1d21:b0:48a:5758:7999 with SMTP id 5b1f17b1804b1-48a9865e099mr118105945e9.4.1777987399249;
        Tue, 05 May 2026 06:23:19 -0700 (PDT)
X-Received: by 2002:a05:600c:1d21:b0:48a:5758:7999 with SMTP id 5b1f17b1804b1-48a9865e099mr118105575e9.4.1777987398807;
        Tue, 05 May 2026 06:23:18 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:3f7b:7276:a343:d339? ([2a01:e0a:e17:9700:3f7b:7276:a343:d339])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a82301b7bsm473121305e9.11.2026.05.05.06.23.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 06:23:18 -0700 (PDT)
Message-ID: <0965a131-ccaf-40d5-a207-9d41c837b278@meta.com>
Date: Tue, 5 May 2026 15:23:17 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: remove registered buffer 1GB limit
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc: Andres Freund <andres@anarazel.de>
References: <6de5d329-9162-4992-85cb-f946f2d5c0b1@kernel.dk>
 <3a19966b-229b-495b-966a-5018fc615a8a@kernel.dk>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@meta.com>
In-Reply-To: <3a19966b-229b-495b-966a-5018fc615a8a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDEyNiBTYWx0ZWRfX0kVxsubvkT/B
 OKJsXQ7HUdLLTZeihvVku0sLY3Zr/SHkmdrVzW2iCgK4uh3XMAIkQdvnb1Wnonk8qm77KgRL+ME
 Cg4Mcpw+GOH3JN+dK9XIbGJWCs5NBw81a5B8qa1asWQR0D6w8LKWOHPJUZwctGyYinWPBp5l61U
 krCn98RN2H4HQOfFNP4o5Jc3XhSX7wzKIluTF9ZomSAANrxxOBcipN4qHfJIyvwoQ3y7EURcBpN
 L0qhmfyzktYfJ50QUfWMSFXhs4ADaG6C8AG7BsS4DqcnvNveaIblFMlAhVxi3TcgVzp5/TSLFNQ
 BIhX3OtmMjLKbYCdw9U6Weji0YqnmBi15nEyV07NKig5h9nioPs/9uWQGe/dKPw16tQr4NMtAX1
 9mb0n02i8OXRrKryq885wfMRTpR5XlUfDoKam/4tuN3PcSuQ+rHVl86ZrxF8N7D+fFAhLgZ7ejZ
 +aWoYf6e+JGXy4Hf91A==
X-Proofpoint-GUID: GPtrjWwV_MSCSJ0nkf-rZyUBKmPN-WjR
X-Authority-Analysis: v=2.4 cv=GKs41ONK c=1 sm=1 tr=0 ts=69f9ef48 cx=c_pps
 a=IwH782EDBk/vqbJ9rM8UFw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=M51BFTxLslgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=wpfVPzegXHpEFt3DAXn9:22 a=VwQbUJbxAAAA:8
 a=iaFi8TtKhGdbX_SpOFsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=Ng9YvVcppn9CIdWre3nD:22
X-Proofpoint-ORIG-GUID: GPtrjWwV_MSCSJ0nkf-rZyUBKmPN-WjR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Rspamd-Queue-Id: E83AB4CE6B0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.33 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.83)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13240-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,meta.com:dkim,meta.com:mid];
	DKIM_TRACE(0.00)[meta.com:+];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_SEVEN(0.00)[7]

On 5/5/26 12:09, Jens Axboe wrote:
> >=20
> On 5/5/26 1:39 AM, Jens Axboe wrote:
>> There's no real reason to have a limit, as the memory is accounted by
>> the lockmem limits anyway, if any exist. io_pin_pages() will still
>> restrict the maximum allowed limit per buffer, which is INT_MAX
>> number of pages. For a 4kb page size system, the limit is 8TB.
>>
>> Reported-by: Andres Freund <andres@anarazel.de>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>=20
> Forgot that I had a prep patch for this one... The branch is here:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=3D=
io_uring-reg-buffers
>=20
> and notably the patch before this one is below, which bumps the ->len
> size of the io_mapped_ubuf. I'll send this out as a proper series later
> this week, this is 7.2 material obviously.
>=20
> commit 381e736515173a1fb78d2a86983d3ebfcf263597
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Mon May 4 05:40:16 2026 -0600
>=20
>      io_uring/rsrc: bump struct io_mapped_ubuf length field to size_t
>     =20
>      In preparation for supporting bigger individual buffers, bump the le=
ngth
>      field to a full 8-bytes with size_t rather than an unsigned int.
>     =20
>      Signed-off-by: Jens Axboe <axboe@kernel.dk>
>=20
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index c2d3e45544bb..f0ff4bd01b6d 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -223,7 +223,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx=
 *ctx, struct seq_file *m)
>   		if (ctx->buf_table.nodes[i])
>   			buf =3D ctx->buf_table.nodes[i]->buf;
>   		if (buf)
> -			seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, buf->len);
> +			seq_printf(m, "%5u: 0x%llx/%zu\n", i, buf->ubuf, buf->len);
>   		else
>   			seq_printf(m, "%5u: <none>\n", i);
>   	}
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index 44e3386f7c1c..03521b50926c 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -34,15 +34,15 @@ enum {
>  =20
>   struct io_mapped_ubuf {
>   	u64		ubuf;
> -	unsigned int	len;
> +	size_t		len;
>   	unsigned int	nr_bvecs;
>   	unsigned int    folio_shift;
>   	refcount_t	refs;
> +	u8		flags;
> +	u8		dir;
>   	unsigned long	acct_pages;
>   	void		(*release)(void *);
>   	void		*priv;
> -	u8		flags;
> -	u8		dir;

Hi Jens,

This seems like an unrelated change.

Thanks,

Cl=C3=A9ment

>   	struct bio_vec	bvec[] __counted_by(nr_bvecs);
>   };
>  =20
>=20


