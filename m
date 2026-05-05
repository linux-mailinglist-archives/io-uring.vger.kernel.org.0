Return-Path: <io-uring+bounces-13242-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WGv4DEDy+WmcFQMAu9opvQ
	(envelope-from <io-uring+bounces-13242-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 05 May 2026 15:36:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9882F4CE9BF
	for <lists+io-uring@lfdr.de>; Tue, 05 May 2026 15:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 81ED0303897E
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2026 13:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E15A836495D;
	Tue,  5 May 2026 13:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="YX3iJj82"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8D1342C9E
	for <io-uring@vger.kernel.org>; Tue,  5 May 2026 13:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777988157; cv=none; b=QXiEQWFUUwFdYfYu+bO9dLtNvDUS2CLFoJpPLUynayNZCQ1+dlRqmNA4Ku08Je9ub6pb0ubocc61+JR8r0UYR28TQ9zV5zWiJVL9cDv553onorViEGjQ1Vwk0dW0H74c30YuApKejgUq7pfFeZSmNrQzujWT+9l0pPIG1+x6cKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777988157; c=relaxed/simple;
	bh=UPhUTYPW62gkrcifw1RXyFft7fKtqDMETk1IgiWoHWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qke1rLev+eUg+RwFyja8dRvgjdPE1did8V93yZQ9kuvna9PB6wNqScQsPB6SP6aCxxkwpcyTq638OhfSqwSyAzy3ghPS0zej/Zuu5QZ8bZqJ1sMjYX6z+3JjYAb4/yNnFkmQmAYqhBAuyfA9gMICZXpWOA5jdSoEYVvZDsFmY/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=YX3iJj82; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 645DEDBL229036
	for <io-uring@vger.kernel.org>; Tue, 5 May 2026 06:35:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=WzMsRsHNxtPOYdT3/1ZzAOQHhnuEh+5HKq9GSrKax9s=; b=YX3iJj825mHF
	omflA2NwdpTR6vclpI4IuWNC+0YU1btj8K9oztf3AUHmST3bKBI8b89E1wCDtGDO
	Vu5scxOkGdHZKe5V4ko6zRMp0akNiMofEACWib3fzzJNAdQDXU2EblYjVI9MGhQW
	2nCOvLCy6Ot7oEcN1t3wb7cuxqvsKCLYlWVEq7iugRgGPiZD7eYcUof0GYtxCprp
	n+NhmhoLMua6C6NBsPH3Gh8/yk4tTRXKJwNTE/j2eBAvQfreiAcfE300khjrh3i6
	IdUtWQV9uZbTudob0bmfF0PZEJuMlRJX/r8Kq4brvzW0dxd+6w52IpVXDgiLWCVZ
	g3NKtwm7mA==
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by m0001303.ppops.net (PPS) with ESMTPS id 4dwcx9gnjg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 05 May 2026 06:35:54 -0700 (PDT)
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-488b739e1b6so4710435e9.3
        for <io-uring@vger.kernel.org>; Tue, 05 May 2026 06:35:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777988154; x=1778592954;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AftRhRGHt8QxJpYb1Gtwcw6MNUWTpVGlAHWlPUr25Yk=;
        b=fAK+H8MaExQiGAJWogL4f/4scPgpirHV9qd1r8JHbmxefb1UziiftQdY5ckpdoPcOn
         h1FxC+0uTrdGZDTOz9rPhzRwqHRMLDeps54AH5Rh+SBxPHfd4EB1rZZWrIHUzhdyX+Xr
         0XRp9mwPYagJPJrCW5V+Z33fvS8AyOee4/FwCzRIfGRmnDsdgb53+wZXZ6oHqffsJGC9
         +p30HYQW3VjRBFIjmrLWAvI0ch8MQVNaRXEYHQJVMU/nzNC+VHf9gHdlVUC2zvWhayKd
         wrb2oLnDzfiY00Obr8QrIWwL3u6FTRb+4tTFD2NGGKBZA/WqbtSRy3U57osaRPcwJ45F
         CU3A==
X-Forwarded-Encrypted: i=1; AFNElJ8yhTI9NFH7OW3Sv/sNP+FpAIlZjkXfQ5l/59SHxYpgXPd19qDaxRWgbnSl6epxKTQtqNtLXqyI2g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxCXGJ6lmvHNPP59QM2neDzQgsgdabnfKTLVKVoVZxoM2DlL373
	hSSOTvpPYdPksn1/iJTjjbBXziF0Sl+qGBM1GNxUoD2YtwehB2sg1oSjZxVwVr0DU9US9RTPxjZ
	7rc/0I9w6A/6Z1APx9dHABq5xHcPY2D17HFafYDo0qTSol/i9MJa0w1MSOM4=
X-Gm-Gg: AeBDiet6+wHmTwNArfGEVjUTbgCVn38/c/ZSeMmpmAF9/DrzRs4BfHMZAkpBa/nnRkY
	eITxxvk+8Ed4Yf9vGhYr4iQulNJKzNunGVb24rABLRU/cxtPK3xEPFPpfshQFtWH7glxO5ebght
	6wEClSnkP3vmOV4WHpHgikgkUX2hmKJFhSOHqo802c67g94gug4zCvWylRtIzAkMjoiSJv7MBzT
	AAj98sLmkce5554qTrUH6UWZuCKWQeFDbBkqYMk1cdDq3BNxpgE2pO1OAShNWfoQjZy7MvOH3Hv
	UbflXVhvHOwMW5Gs2RzVvGG0bA8xpYxo0C+cP2uFAkwh7doFsrn9GgRwUTTyEMKz9pXw7MndcJq
	dapxfQoAsldpAjq+2sE7MCzjMr/kV0/8+BsxiSksqYzrp4GS23RS1N2T9liOmByITusb3ow66
X-Received: by 2002:a05:600c:4706:b0:489:6c28:dbb4 with SMTP id 5b1f17b1804b1-48a986631c8mr116692065e9.5.1777988153426;
        Tue, 05 May 2026 06:35:53 -0700 (PDT)
X-Received: by 2002:a05:600c:4706:b0:489:6c28:dbb4 with SMTP id 5b1f17b1804b1-48a986631c8mr116691825e9.5.1777988152936;
        Tue, 05 May 2026 06:35:52 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:3f7b:7276:a343:d339? ([2a01:e0a:e17:9700:3f7b:7276:a343:d339])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8eba8487sm348647915e9.11.2026.05.05.06.35.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 06:35:52 -0700 (PDT)
Message-ID: <4c041d9e-faae-477b-b5c7-7288b07b661f@meta.com>
Date: Tue, 5 May 2026 15:35:51 +0200
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
 <0965a131-ccaf-40d5-a207-9d41c837b278@meta.com>
 <4c976ffe-ae16-4804-9b75-50ffb7288d11@kernel.dk>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@meta.com>
In-Reply-To: <4c976ffe-ae16-4804-9b75-50ffb7288d11@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: p5Dvu5ureugsCPK70w3V0AreId3a0g_P
X-Proofpoint-GUID: p5Dvu5ureugsCPK70w3V0AreId3a0g_P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDEyOSBTYWx0ZWRfX5JUzP3bNZw/g
 zCeZ+/Zz0MPN42e1vlp24tjmEOtbEVkTnP7tNkcsTIXDBgaGdooNGo0JhRa7fWSiVNrI6PHwaPr
 Kwmd2YbzbeNqkyOMiT1usHGDHUiK/JFbPxeco6sIYDogSuCdZfyT66iqa/H9517SZ2xzoOvJPGH
 1k3uZTHMz/JALgQaCpd25qaA8XoFeAMUN4hes6+AnVFxWl5iYdLh/rMS3BDNisteVl/JxLfaz01
 yl+cSCCSXBycfx8L0ckl4n9512nyNpS+z9IbM2VmCzUnUnJ+g4ZUociPkkMlvslW8HIR9mQt+uN
 MbkQHq0uXsGfDgJjwTBe/3rxPGEl3YCEMwnZXvO/l4UQbBRWqqoFUbA5hdcXfo46GjXGsleX6Y4
 3dq8uRdUSomCHcfckEd5RjIZ11tzEkwu3q1MR7+rhkCHiFv8a19J9DNCHHvMsyg/bJG0wA20Us3
 LdmJgKqv3SHU33qLcTA==
X-Authority-Analysis: v=2.4 cv=SoCgLvO0 c=1 sm=1 tr=0 ts=69f9f23b cx=c_pps
 a=IwH782EDBk/vqbJ9rM8UFw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=M51BFTxLslgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=_78whYxrdx1mplLwxq1U:22 a=VwQbUJbxAAAA:8
 a=eJFJiYnnyJXwPChUhRgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Rspamd-Queue-Id: 9882F4CE9BF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.33 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.83)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13242-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,meta.com:dkim,meta.com:mid,anarazel.de:email,kernel.dk:email];
	DKIM_TRACE(0.00)[meta.com:+];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_SEVEN(0.00)[7]

On 5/5/26 15:26, Jens Axboe wrote:
> >=20
> On 5/5/26 7:23 AM, Cl?ment L?ger wrote:
>> On 5/5/26 12:09, Jens Axboe wrote:
>>>> On 5/5/26 1:39 AM, Jens Axboe wrote:
>>>> There's no real reason to have a limit, as the memory is accounted by
>>>> the lockmem limits anyway, if any exist. io_pin_pages() will still
>>>> restrict the maximum allowed limit per buffer, which is INT_MAX
>>>> number of pages. For a 4kb page size system, the limit is 8TB.
>>>>
>>>> Reported-by: Andres Freund <andres@anarazel.de>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> Forgot that I had a prep patch for this one... The branch is here:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=
=3Dio_uring-reg-buffers
>>>
>>> and notably the patch before this one is below, which bumps the ->len
>>> size of the io_mapped_ubuf. I'll send this out as a proper series later
>>> this week, this is 7.2 material obviously.
>>>
>>> commit 381e736515173a1fb78d2a86983d3ebfcf263597
>>> Author: Jens Axboe <axboe@kernel.dk>
>>> Date:   Mon May 4 05:40:16 2026 -0600
>>>
>>>       io_uring/rsrc: bump struct io_mapped_ubuf length field to size_t
>>>            In preparation for supporting bigger individual buffers, bum=
p the length
>>>       field to a full 8-bytes with size_t rather than an unsigned int.
>>>            Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>>> index c2d3e45544bb..f0ff4bd01b6d 100644
>>> --- a/io_uring/fdinfo.c
>>> +++ b/io_uring/fdinfo.c
>>> @@ -223,7 +223,7 @@ static void __io_uring_show_fdinfo(struct io_ring_c=
tx *ctx, struct seq_file *m)
>>>            if (ctx->buf_table.nodes[i])
>>>                buf =3D ctx->buf_table.nodes[i]->buf;
>>>            if (buf)
>>> -            seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, buf->len);
>>> +            seq_printf(m, "%5u: 0x%llx/%zu\n", i, buf->ubuf, buf->len);
>>>            else
>>>                seq_printf(m, "%5u: <none>\n", i);
>>>        }
>>> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
>>> index 44e3386f7c1c..03521b50926c 100644
>>> --- a/io_uring/rsrc.h
>>> +++ b/io_uring/rsrc.h
>>> @@ -34,15 +34,15 @@ enum {
>>>      struct io_mapped_ubuf {
>>>        u64        ubuf;
>>> -    unsigned int    len;
>>> +    size_t        len;
>>>        unsigned int    nr_bvecs;
>>>        unsigned int    folio_shift;
>>>        refcount_t    refs;
>>> +    u8        flags;
>>> +    u8        dir;
>>>        unsigned long    acct_pages;
>>>        void        (*release)(void *);
>>>        void        *priv;
>>> -    u8        flags;
>>> -    u8        dir;
>>
>> Hi Jens,
>>
>> This seems like an unrelated change.
>=20
> Hmm, how so? It's required for removing the 1GB restriction, as it bumps
> buf->len from a 32-bit unsigned to a 64-bit size_t.
>=20
> Oh you mean moving flags and dir? That's just so it packs better,
> changing int would leave a 4-byte gap. Might as well move flags and dir
> near the 4b refcount_t to avoid bloating the struct.

Yes, I meant dir/flags but indeed, that makes sense !

Thanks,

Cl=C3=A9ment

>=20


