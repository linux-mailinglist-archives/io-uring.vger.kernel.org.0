Return-Path: <io-uring+bounces-13068-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KNvfMIjp5WnxpAEAu9opvQ
	(envelope-from <io-uring+bounces-13068-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2026 10:53:28 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BA6EB42882E
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2026 10:53:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 43C343051FE9
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2026 08:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1C3828B7DB;
	Mon, 20 Apr 2026 08:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="CZaAbZcG"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A132E62AC
	for <io-uring@vger.kernel.org>; Mon, 20 Apr 2026 08:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776674695; cv=none; b=cQ2yg55aZvGtsK09PIqwrZKRGYfw2sAs2JwzD/5sJ4yv5OXvXUQ6xmYAxEMuAaZj0bvE5syNWDwrUg4HWjQMZANSQi+2/B8IDJsPlCLKb03yjBjxJyugmaPHGeuad+fyr3eGtWPBJjt/w+U/vxsvH8zMHCaJEAWmY1ImSURyAAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776674695; c=relaxed/simple;
	bh=pJ6qgDk7sd6N9kAvF9RRjd3Y63K8UJKSRkCv1WJBohU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AFgpSgrU26YYa1Z3C2HRnAOmDgiov5wCDKxwPWVz0gH4nZsOJ/+Tq99Z7rIhKK5HjaYpOMm/CtIVqf8FxcuBtez8ub6r2IXxRj4giLs5aQdqO6dttuXe6xV4RIzwuTLc6RCKfKTevW+0V8G+MqHC67n55IFwMjdVQtz7Qg2xblw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=CZaAbZcG; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63K5qXah3147751
	for <io-uring@vger.kernel.org>; Mon, 20 Apr 2026 01:44:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=uha1nFBPQkViHaRFcfULnnan7FZVT8O00oHJxe7VIH4=; b=CZaAbZcGruw5
	+wx2lpBSXisEwXHoyzKzASifJDkR4/BqI0tH47LmCZkkDPO74FFe937CExOyu0a8
	OIzN7GbLeQHfVi+1ugvBqQKUI9EFAsSMNkK9xeHsZEfSH+d0mROpa5yy5DSwauKf
	aM/XsvbYAFLXpbmpShVDc0o+bgNXLOVZcqT/h2EPt9YEO2Eox4kZmkqyiDGNX9NA
	gar/01uV4ESbhMrB/qHapBU/PEHzq0rd2htXBs8VNE7y/zZKQ+KaprR4Vq4gqHc9
	dXAUO17Nev00QGpVKccSqkXXEfj5GPLpSMCgQ+8PrArve7SpnnJZ4pZGGtjg+xny
	e9FO8gtcSg==
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4dm98eq6ka-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 20 Apr 2026 01:44:53 -0700 (PDT)
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4834dfcaa8aso2156795e9.1
        for <io-uring@vger.kernel.org>; Mon, 20 Apr 2026 01:44:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776674692; x=1777279492;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9CDknGT9vdWMt9mdju67KfLdVdNydZViTZMuVXwDA1E=;
        b=CHYyjIkxnaiXCClDuxKL04SKoeHC0NMbBswFWWonFKHOHg1+869RvEW6ufpNNHlB5R
         j5elm5gLaA9+ZSjGT9Lg89udLzuykBNcpdavdlqLlXvcP6K5SvTYarGIYbm5cLOJtY1D
         IOmSOZMUJpT+FAkIJpHP+U0cKe2azcfntDqycOJq2RTRl3td8mfT2wLoZ37Dq0GaiN93
         G5gYRbQYBA1E72HMlTkFda7wLG4rcosXn4TDhhgAaoKEMl57zNmO4xkHSMVKPajKKeh6
         gyyyzk9aEnnByuxemVEDdzVxjV16X/N2V9xVBcEGp2TGScBRZErUorKkGlljhTJUwz/R
         ruRw==
X-Forwarded-Encrypted: i=1; AFNElJ9baZkH6tKZQpRok1NG9cf7oLMljIdbJvqldFMvB5y+fmUyMp0JRv3AGjnCQ6SQjCyz2V0Og/WYiw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMUsQKtL8chf2pcatih3Jw/1XBGzBN74AQ7+z8weDu53KLCeDi
	OGqUjN8UpqjcAUuCDCbOadw4sihi3YqUSaTHNnnoNjHbffguiM2fMWEnnmKSnKsvdBimfw+b3Og
	adUUHghxLsPVzMRQXQ4+u2M3kja5zoMhbHr7POpW9H3Hl/Tsgh3kxs5Z5PpaWsshqUNXK1w==
X-Gm-Gg: AeBDievv0kQKJo/XGAmeolYFdrHqSMV7eEj0313k4nBn3kgdDNMD9nzMjq/h9YoUIVo
	qxPQEWdx++B52qMkTcqnO4VVmqvGMSNOMy/aFsOsbgPsLCHbhOCfhAm2+5i/IYlO90ur1ugojLV
	eQqtMsQhVTlA7inXdBtfDrV5XZtmzi2psAvPte7+9ugH9kP6Yv6L7utbkkUAODugwMLlHdATTeN
	zhGqtpqhDVO7rDQ/nnh4Iv8rhQz2v931Kj7IHqXDUfi02nbqZyQLCa487QyRdbCDq82RKqnElOT
	FE2YcFa3vUfYEg7G6neOWj2WAI1HEmWXnjho1Z/DmNdRKLy5LtghDhJvAu9Y8U1IWB9XbQVUMLP
	E8Oee57snW6eiSdRWn6N9XNPxuDsD8sjSo347WDEfzn1yRuzkcgCqb+DpoIQi575ow1/TC2GY
X-Received: by 2002:a05:600c:4503:b0:489:1c1f:35e5 with SMTP id 5b1f17b1804b1-4891c1f3837mr23498395e9.6.1776674691666;
        Mon, 20 Apr 2026 01:44:51 -0700 (PDT)
X-Received: by 2002:a05:600c:4503:b0:489:1c1f:35e5 with SMTP id 5b1f17b1804b1-4891c1f3837mr23498155e9.6.1776674691143;
        Mon, 20 Apr 2026 01:44:51 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:3f7b:7276:a343:d339? ([2a01:e0a:e17:9700:3f7b:7276:a343:d339])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb755938sm110159425e9.3.2026.04.20.01.44.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2026 01:44:50 -0700 (PDT)
Message-ID: <f43be53b-fb89-4dbf-b20e-d64044fd47d0@meta.com>
Date: Mon, 20 Apr 2026 10:44:49 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/tctx: mark io_wq as exiting before error
 path teardown
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: syzbot+79a4cc863a8db58cd92b@syzkaller.appspotmail.com
References: <20260416200622.831635-1-axboe@kernel.dk>
 <20260416200622.831635-3-axboe@kernel.dk>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@meta.com>
In-Reply-To: <20260416200622.831635-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=ZK/nX37b c=1 sm=1 tr=0 ts=69e5e785 cx=c_pps
 a=Ech0Gv1thIkdqUNjVc2Ehg==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=M51BFTxLslgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=crHB47gyY4rKiduisYu9:22 a=hSkVLCK3AAAA:8
 a=VabnemYjAAAA:8 a=dZA1ZhGdizKVQ8fo5ZkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cZgK7WzY9ta9U-6s7oqD:22 a=cQPPKAXgyycSBL8etih5:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: CdLqEwT7_XScGLPc2m57Lac6kfiQCZSO
X-Proofpoint-GUID: CdLqEwT7_XScGLPc2m57Lac6kfiQCZSO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDA4MyBTYWx0ZWRfX09jLFFtP2EvU
 j63werZs39yUKGktiD6InA6V874ci3CrddJCC1YeXTn20o9GWU7M+fRNH1osI+fycc3jwPwu/Xm
 q9Qwd6e1yVXctAJpUNdyxQjOc9fbC615fsgKtcB19qNzhQfYw9uusFYLcn3rVgZ5ciYmYbE1p3p
 d3XSQLE9Mky7kOxkqHfa0LffvWuiAgyWAOxUffTW9A4XfvD7KDPLHhueVXcakbUz8m4t4K7gWWs
 /LfzPB9PIjzqI/1crcUf9XXWXKBchYrL5jJ5WShgJtEOBBa/mRw7YvFkJHcFOkvdlp3jZGltKVY
 +XTLQmqXBJCSC3WTMwZhfadsl7PLE3lbiO32s+Uv+NiKNv2zFMATXUjNYroHArr61BqHLR3U06E
 YMOSb6HIOjt6yKWjt/LJuD2n2iuDMkD2vYBaoxjE0ZsWQPFYXMMH+oNJw7d/OIONK57m44jIx5e
 Hf0L8+nX6xCfIa7oIfA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_01,2026-04-17_04,2025-10-01_01
X-Spamd-Result: default: False [-1.57 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.59)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13068-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,meta.com:dkim,meta.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,appspotmail.com:email,kernel.dk:email];
	DKIM_TRACE(0.00)[meta.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring,79a4cc863a8db58cd92b];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: BA6EB42882E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/16/26 22:05, Jens Axboe wrote:
> >=20
> syzbot reports that it's hitting the below condition for exiting an
> io_wq context:
>=20
> WARN_ON_ONCE(!test_bit(IO_WQ_BIT_EXIT, &wq->state))
>=20
> in io_wq_put_and_exit(), which can be triggered with memory allocation
> fault injection. Ensure that the io_wq is marked as exiting to silence
> this warning trigger.
>=20
> Reported-by: syzbot+79a4cc863a8db58cd92b@syzkaller.appspotmail.com
> Fixes: 7880174e1e5e ("io_uring/tctx: clean up __io_uring_add_tctx_node() =
error handling")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/tctx.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/io_uring/tctx.c b/io_uring/tctx.c
> index c011a593c0ad..80366320276d 100644
> --- a/io_uring/tctx.c
> +++ b/io_uring/tctx.c
> @@ -171,8 +171,10 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
>   	}
>   	if (!current->io_uring) {
>   err_free:
> -		if (tctx->io_wq)
> +		if (tctx->io_wq) {
> +			io_wq_exit_start(tctx->io_wq);
>   			io_wq_put_and_exit(tctx->io_wq);
> +		}
>   		percpu_counter_destroy(&tctx->inflight);
>   		kfree(tctx);
>   	}

Hi Jens,

LGTM as well,

Reviewed-by: Cl=C3=A9ment L=C3=A9ger <cleger@meta.com>

Thanks,

Cl=C3=A9ment


