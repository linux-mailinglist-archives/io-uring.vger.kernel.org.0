Return-Path: <io-uring+bounces-13067-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ALKgEaHo5WlkpAEAu9opvQ
	(envelope-from <io-uring+bounces-13067-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2026 10:49:37 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D105428704
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2026 10:49:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 52F9C3021FE9
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2026 08:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E1DA288C08;
	Mon, 20 Apr 2026 08:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="dQlG4t52"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1CB389107
	for <io-uring@vger.kernel.org>; Mon, 20 Apr 2026 08:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776674577; cv=none; b=NwdMnMeQTpNQY/S4MJdSVWDM5N7QZqUHG+1reFIq3bFwD7E1oRmLyRzrDCb/kOPvo4dd9yQcR0r686Xq6QAk2/wZl/9RabBD3uP/pqxkb1061OYVKV1Yhn5REkUJSUaWbCdOaHWsMn2XAWOnADuNaTarhmRr2Ms5QJSlIU72sCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776674577; c=relaxed/simple;
	bh=Ttefzn/x4q1sFw8vVVcC6yYX6ej876agobk+9xXjfQo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=q2c/hpKburUMZjBjEMQ4gflneY6eDb3byBdgsyF6K6EQYRAUHgyS+Z3tZGaMZlVvvNZz5Iezmp2irGcugKuK/bRy4EB78NvJGRDP4A+G7xwlCi+x7EVDmDWY/A9Ea5HAxBn0Q6E8A+2lu/K9tEIITzWRz3kG6JqogYcZgo4pvd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=dQlG4t52; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0528008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63K5kKvT3517639
	for <io-uring@vger.kernel.org>; Mon, 20 Apr 2026 01:42:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=h5zUCpaO/Md9p1Z78LMOBDq/CL0xh8jhHeNEVm9m/ho=; b=dQlG4t52pm/D
	0xRlbXdZJw9xMiHDzfaCjpByR415cn3O1AC0bWL/+oY4JyCrnA0d38uWOs7DJIFy
	6APkS/634paAu8Z799V3+dLKukCy0C1vHXe4GB2BseFPXwcIEmoKIdGu4UCcpcjl
	T1ZNBEKBtA72IfimaSBljEPCO1J5hfn4HxpTIkZdepQ3rz5JYz2tluM8+NXQHTBe
	K1ElwLPgF/aqry0ECmQmp3PQjKrEn3U9RBar5Z75aknB0eHzvLmirfVhScC6+ufJ
	2iJ2FJT54jEKtwc77xmHQrogCAxSRlAWNIYSyOu8MGM+bcuHljPKoRA+Lt7zm9PO
	y47qvN30TA==
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4dmxjgkgnb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 20 Apr 2026 01:42:54 -0700 (PDT)
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4398d3945a7so197390f8f.3
        for <io-uring@vger.kernel.org>; Mon, 20 Apr 2026 01:42:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776674573; x=1777279373;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wv4ZNN9pC4kBswUggpouwxrcTopjNNLcPaeYY825HXY=;
        b=hO8u3qZ4G0fq+0FzC7wMNJuDMvRue+jYFLC18axIP4VWru1H05byp78zLDPMqaMAji
         tH4nrqM6bRcXIrB4lAwDTvylEbNEFrJtpKVWpguhTqaFf/rgoU1a6/XJlfV/mYtE/9ef
         gdpIIEdFJM+TUvt5iGTht4f10+61t99lbW7U0UATMBC4gKgRR1SyLoKYclK/q4nw7mE1
         xgZ7ksSYFtt9Feqx0K5ikAg6gylnmJIseuyPjEvNy/3AFDWZRS1SJQqxlL1n9Y5z5Uw3
         JkH+SWXLcvYXlcxPY4NRGu9NPj7QHkH4jzwYWDewY5ksQOIPWty8yxl9T49UQTpEMbpy
         7Jcg==
X-Forwarded-Encrypted: i=1; AFNElJ+xingJj1D55UUnYzplJwrCOtUDCGL/Ym5zG3QbtD3eo1v/pK5aIBrlnvpB4V0yPkxAK7kteKlYXw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9uIxo5HqH0g/CqDyUjz/Zx17SRMekXTax2ej+RTcEjcij1r4p
	HaR1EPJbrTvj38i+nmZNSj8gZFOqsjhb1RnzsXxPOokLQrC7EC5ODsEcUK+UZWV0NEPLNSQIBbh
	yVzMB+DTQaGRTT1YJkBm/8FUjmQdeswMlQtOhjIiOriWxomkJGbWslnaepVY=
X-Gm-Gg: AeBDietLBf+fP0o6eGWxFBvz57+vgps/ja8YKVdn4OE6fa++RTWjgh1744l0Al0tZg3
	KhiRP9rKj1DsasnOmXp3M/9SM+7jezBZ9ihYU4fXEt9w/WkQEYw/2LXw7CenR85tb9zMLo0w8nf
	9iB8T3vUn2mQFK2vzkRjZcCH1rTulASq/B/K+vP9WmilO0SffrWfoYUn9o04bTIMjmwppoI+X8H
	nP4Pf833KUqbfJWZisLIeK8D7kTi4PudTz2bEyDOTalCy7Gh7qn/nX6r6hPvGvoye9sVKPau7y4
	7pBBP7cV5X4UdS1+xp1qy8yV1jX15xvzC+HmoyXaedT1wL6IhIdrG8ypcG5ZuAptn5Qhg5YGLP4
	gVngJjCtbveVaCM8tx7a6zIHtQsKt4jwq9gg9xCB6bvk4+HKfhvttl51DYgGjgJiWw81l2o1v
X-Received: by 2002:a5d:4573:0:b0:43d:7a42:54ff with SMTP id ffacd0b85a97d-43fe3f361demr5283595f8f.7.1776674573152;
        Mon, 20 Apr 2026 01:42:53 -0700 (PDT)
X-Received: by 2002:a5d:4573:0:b0:43d:7a42:54ff with SMTP id ffacd0b85a97d-43fe3f361demr5283575f8f.7.1776674572540;
        Mon, 20 Apr 2026 01:42:52 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:3f7b:7276:a343:d339? ([2a01:e0a:e17:9700:3f7b:7276:a343:d339])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1176sm28315186f8f.3.2026.04.20.01.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2026 01:42:51 -0700 (PDT)
Message-ID: <d8214fb9-69eb-47fb-a79a-8e14cb5d913d@meta.com>
Date: Mon, 20 Apr 2026 10:42:50 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@meta.com>
Subject: Re: [PATCH 1/2] io_uring/tctx: check for setup tctx->io_wq before
 teardown
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>
References: <20260416200622.831635-1-axboe@kernel.dk>
 <20260416200622.831635-2-axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20260416200622.831635-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: xCiR1h-3JHoKGTvjuYmvj6Z-ckjeH_Rb
X-Authority-Analysis: v=2.4 cv=WsIb99fv c=1 sm=1 tr=0 ts=69e5e70e cx=c_pps
 a=CsXZvLRfiTx/ye2xXAwb9g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=M51BFTxLslgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=_1IyUuN4QrATX339ibzo:22 a=pGLkceISAAAA:8
 a=VabnemYjAAAA:8 a=CtlmjFealbz7NDNXljsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=F7q00xkr9EfWfQvbdVXI:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: xCiR1h-3JHoKGTvjuYmvj6Z-ckjeH_Rb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDA4MyBTYWx0ZWRfX3kXl9ALipY3s
 evktv4GqwPT9QOVcah20NultI1Ps1UdPqG9+xBDcpDUGRvBWLLkZEbYLgYIODDpwD2xwaDNl+EB
 pk/qCj8r8bbP3Auw7SMQp+xEq/iXmkjl/D/BytN5i1gH2UbRHuXYSS+7h9Crw17r50Dblg4X5mI
 OPlQ+B2F4sT06vkeB+BXutN3i4TwjcxIOZxyukVz5uLZzUoDblUyDMUrVA5VNwrQltHCudWF/P9
 e7zPAE5+Vg2TmLmTsVLUPOcNwVVAwvhUxcgvoL7lcF2UBfnMxxDR0v3ngQh1Mcc4iQwaBLXAO0B
 d79/7EM9VpXQrYBFDeHBdj9/qaOOTsKixgh28GbNCU6SdALVboTuIZrifdg0v7P25UcscNBUtIq
 y2QhhEjceepK4DHBs73dzslsg/rgHYd/mFFYQLF4noIynSkSak3/vW2DwWKfAi/HSwDDej79R0r
 GZ2T4ccnbamIVYNt10w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_01,2026-04-17_04,2025-10-01_01
X-Spamd-Result: default: False [-1.54 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.63)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13067-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[meta.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,meta.com:dkim,meta.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 4D105428704
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/16/26 22:05, Jens Axboe wrote:
> >=20
> As with the idling code before it, the error exit path should check for
> a NULL tctx->io_wq before calling io_wq_put_and_exit().
>=20
> Fixes: 7880174e1e5e ("io_uring/tctx: clean up __io_uring_add_tctx_node() =
error handling")
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/tctx.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/io_uring/tctx.c b/io_uring/tctx.c
> index 61533f30494f..c011a593c0ad 100644
> --- a/io_uring/tctx.c
> +++ b/io_uring/tctx.c
> @@ -171,7 +171,8 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
>   	}
>   	if (!current->io_uring) {
>   err_free:
> -		io_wq_put_and_exit(tctx->io_wq);
> +		if (tctx->io_wq)
> +			io_wq_put_and_exit(tctx->io_wq);
>   		percpu_counter_destroy(&tctx->inflight);
>   		kfree(tctx);
>   	}

Hi Jens,

LGTM,

Reviewed-by: Cl=C3=A9ment L=C3=A9ger <cleger@meta.com>

Thanks,

Cl=C3=A9ment

