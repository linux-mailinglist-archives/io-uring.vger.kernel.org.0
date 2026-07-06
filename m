Return-Path: <io-uring+bounces-13904-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 10v3IYIITGpnfAEAu9opvQ
	(envelope-from <io-uring+bounces-13904-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 21:56:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D36597152F7
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 21:56:49 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HrPvhEk6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13904-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13904-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B91630D1B48
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 18:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A7E3A5E67;
	Mon,  6 Jul 2026 18:37:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7288E3BED78
	for <io-uring@vger.kernel.org>; Mon,  6 Jul 2026 18:37:58 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783363079; cv=none; b=bsGewTfCawYF/0pHkIqVsp34MAE4nHBpQNerZgdQZHF0FnTSZtIiLfyTh0XWoUeg73kd5hX5P3CCxpVjOhZYjORkbt/fBdL46qTqsvQtPt/HCeZbMiXEr7TX6TCIeFkpSoImA23pwQSxvG4JoauMCLRtYHfKBog79HGW3mANccQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783363079; c=relaxed/simple;
	bh=55yN85cw90+o0hRVGqsNRxeb7+abU3L5wa63uUEPATA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fjDF9uI2dBkFl8i5g9m5QhBBvKhNJ/t6UNLRGV/+z8DOr3ISzN/sQqUPeBqmW5lTBJEYo27P8+QgQoeLFoE2t9Pz0qp1xdSb0y4H8z+yoh0/ELNDDVDP3l3zgwSSyC431k90In0g1OAQOyT3DQCcIvNkPgb0mxF2WTpyGrRk/Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HrPvhEk6; arc=none smtp.client-ip=209.85.216.41
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-381ed661712so2954776a91.2
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2026 11:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783363078; x=1783967878; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wXFl1J23FMwzlY1CMcKCc3sOmCJ6pQvr2qzqkl88R7k=;
        b=HrPvhEk61bbPGdUY1U/OtXBdHalnlKkjzOCKZi30H+dTXx9uXNdtLFH0yN4Re4cxTy
         o0hqLYT+jeAFTxfeZl+ZwYbDYoNxjmXYpqGB8JtQ4Mpev3Ijjfsofngk2aV/DEy/0coU
         LpuKE+pA62pRrRIEjX65UgptNa90W0SRwX937SHfyPxPOLb/qlmbSWN7VSy86hsQ1hWJ
         kG60D8v4XXQprGP228HMm1lbgNClsE1VNORf2Fth8n7DY0Czk40Aq5u/eH4SAhF/LZXd
         4zW7+1dWRn/iwcfrfsMOqHe/X2F1PzTSVDdqxbwtIbojkDITQnQ3I75gjrTnOOnfRgyW
         w3IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783363078; x=1783967878;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wXFl1J23FMwzlY1CMcKCc3sOmCJ6pQvr2qzqkl88R7k=;
        b=UVEwZ5E3NmGQgqoaqbuh2uK1X3db0vkK/gxdsqn+jMVGaw1UmUJXrdcxfFQcvPK6di
         uJsaobKheF0uUqosiks6zd8KM0tSI6rm9lUtFTLbxGmNahJ4NEC3FaubyuQ8pRkq1LJn
         N49la6BOkAMsI3I5jJbyYv1rrQdFdpZO1gW4zQRVh50S5omTA2bauqrqxOE1YJY3K8qV
         r4RngLRZuD+k3iLp0+LC4A5wRGMHgkwIYtFjKHlRj7ParwV4gdPpyt2M9xlxz8l0NOH7
         NgY4efhK0B+p0BfASZe1P+YITly0XcVZOSN1UI/EIJpnRuqVWbFNvzRG6ZvCBPvQL6qb
         RxPA==
X-Forwarded-Encrypted: i=1; AHgh+RqZzoezLxx0cbL6F3xXdnnQjtEdwR9QkV3l04cQ6LPlBgeAVFxX8tM4rYhcLQ8MKlael8uO0agJtQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbazYh5Zy51bmfppEj5be1GtlKeEkWjgYh4sEtSOLydgmd9TUM
	6yuDPKqeWckuE8cG1SStT6bKXBNBKsFMruyMnNyhnjyWNl3qxUKYynD5qEGnypw7rf8=
X-Gm-Gg: AfdE7cksw8V/CDPXw3qQKyDemDLLqlOgPqXSaBJhIzxhOPb//u5OMQuESJ9S7rmFD56
	OtYb+0/zK4bKbBJGC+K8M2FqWvYk1jBCNDhgU4BzXGW94UXVVW9gd21jO3j8IysU8JgejKU/4JH
	IFlwxUoM4Ur0T+mtMX75zwbR74PohbDviGKBzzUy/9Ae9oBqjs2HKn/vudeeGIj/9AiLdskAHN8
	g4NnR85dCHVvR35jAeS58GWFEihAZrpew6+Pi1qD2p16s4ZNQ05lR3XWDyRoGDyo+AfO6iwrroW
	jjvQCFamBT+yoXYoAonjJfnyfA7kMtW1BPdixEBjRU6Oxnd8lkPZyYiWvIHgVhcW4Ila5UzreMK
	ErbxbfcEigq+tSvfSeuwCyQP40vZz/+DNxfvTStz1PKVbKm93mEY9oRPGof/ZEqNOwrCDmX+a1t
	S9/gnVYEaPD0fPE7dwbdEVvFJP3wlLKPYqQcj6yhU=
X-Received: by 2002:a17:90b:2652:b0:37d:f206:a2ac with SMTP id 98e67ed59e1d1-38755573a58mr1829818a91.7.1783363077842;
        Mon, 06 Jul 2026 11:37:57 -0700 (PDT)
Received: from naup-virtual-machine ([140.113.139.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38127c0c17csm5570510a91.6.2026.07.06.11.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 11:37:57 -0700 (PDT)
Date: Tue, 7 Jul 2026 02:37:54 +0800
From: Hao-Yu Yang <naup96721@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] From b1014148d31468e2dcd8f237740ca1643571e875 Mon Sep
 17 00:00:00 2001 From: Hao-Yu Yang <naup96721@gmail.com> Date: Sun, 5 Jul
 2026 11:43:02 +0800 Subject: [PATCH v1] io_uring: fix dangling iovec after
 provided-buffer bundle grow failure
Message-ID: <akv2ArSEO+qR1lz8@naup-virtual-machine>
References: <20260706182534.918737-1-naup96721@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706182534.918737-1-naup96721@gmail.com>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.21 / 15.00];
	LONG_SUBJ(1.87)[249];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13904-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:linux-kernel@vger.kernel.org,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D36597152F7

On Tue, Jul 07, 2026 at 02:25:34AM +0800, Hao-Yu Yang wrote:
> When growing a provided-buffer bundle, the old cached iovec is freed
> before the new buffers have all been validated. If validation fails, the
> request still points at the freed iovec, which can be freed again during
> completion cleanup.
> 
> BUG: KASAN: double-free in io_vec_free+0x2c/0x90
> Freed by task 73:
>  kfree+0x104/0x3b0
>  io_vec_free+0x2c/0x90
>  __io_submit_flush_completions+0xc03/0x1e40
>  io_submit_sqes+0xdb5/0x2310
> 
> Allocated by task 73:
>  io_ring_buffers_peek+0x559/0xc60
>  io_buffers_select+0x1c1/0x460
>  io_send+0x770/0x1050
> 
> Fix this by deferring the free of the old cached iovec until validation
> has succeeded. On failure, free the newly allocated iovec and leave the
> request pointing at the original one.
> 
> change log:
>  v2: slimming v1 patch
> 
> Fixes: 46800585ae04 ("io_uring/kbuf: validate ring provided buffer addresses with access_ok()")
> Signed-off-by: Hao-Yu Yang <naup96721@gmail.com>
> ---
>  io_uring/kbuf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 3cd29477fff2..b6b969b55e12 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -287,8 +287,6 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
>  		iov = kmalloc_objs(struct iovec, nr_avail);
>  		if (unlikely(!iov))
>  			return -ENOMEM;
> -		if (arg->mode & KBUF_MODE_FREE)
> -			kfree(arg->iovs);
>  		arg->iovs = iov;
>  		nr_iovs = nr_avail;
>  	} else if (nr_avail < nr_iovs) {
> @@ -330,6 +328,9 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
>  		buf = io_ring_head_to_buf(br, ++head, bl->mask);
>  	} while (--nr_iovs);
>  
> +	if (arg->mode & KBUF_MODE_FREE)
> +		kfree(arg->iovs);
> +
>  	if (head == tail)
>  		req->flags |= REQ_F_BL_EMPTY;
>  
> -- 
> 2.34.1
> 

sorry, this patch have some problem. I have been sent v2 patch again

