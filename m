Return-Path: <io-uring+bounces-13436-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OPP2NyWGDGo1iwUAu9opvQ
	(envelope-from <io-uring+bounces-13436-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 17:47:49 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 52CEC581B5F
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 17:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7175D305CBB2
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 15:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62D3B408001;
	Tue, 19 May 2026 15:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="BwDs7SwC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E380C40801F
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779204423; cv=none; b=GdLXawPVgjn3nIbb6L/Gewpc75oz2zCTVLusr82yWlfJgmh7JIrCYkn74cm4/zqPmeIJ/QkTnWnLvZKuC7gFvVA51vO16+m8+v6G0b4oSkhxZ4wG8CENv/be4d6bLsJsWw3wBou1eZ6+NptfhflTT8PDmTIHyeNp2Uk+09fVbHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779204423; c=relaxed/simple;
	bh=mcCiwEdL/4N+uKhN98EHjHskm5rIyNuC85F7WV3iSeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LJSyahn0tiwMqztwbYz3ANtTPfRerTaGBFuh+JKHDyRKHRTm6hcK/mOFhyEdFqmxNa+mtERAQ+DSW3+RJxttQTJVw2Ne2rEHotlC6wleBRz6Q7HwBOt417wNi7czOxPvb4RwxicQpZoG27EF3D0h55DeR7bHF/HtlkM+qlg8aNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=BwDs7SwC; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-69b747a8984so855857eaf.2
        for <io-uring@vger.kernel.org>; Tue, 19 May 2026 08:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779204419; x=1779809219; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VWaUx6uYgh1JNysTgxghxLddStbx1OJmn9whh2c8WMo=;
        b=BwDs7SwCkq1Pu0vDX5NyMkGdjkwfWSXkYHhiOiOXoyR3ZsQkogmL2aBku2pOO+eHyL
         KG4S/ZMztW8EzAIvsclmA799ZifPhCWINWWsQdgPEm7tIMwUIzNFLXC1pTD1Llcxt6Uw
         rSw4rDjN/KN2jMc0+6h1fhcgnPXMBkmz1qWynhrjw6Cu26hS+TL58w6TQWT0j2fl66FF
         IUOvwtQbqQBM2KujNDma0ne9t3SN8RDasYJC7IpjCViltMaLh/yDD6UfTTm102yvxz4j
         0WC8LfJT617whbUT+wUU6dbZm3rsgasapgSkwraTR3RNQaAk+byDaOFVVJfOcvEath9u
         g7FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779204419; x=1779809219;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VWaUx6uYgh1JNysTgxghxLddStbx1OJmn9whh2c8WMo=;
        b=hsPfxn3/SO6NAgRTOz1i9j5uwVWq//yQFlEdhGUhBLbrqi/fPaTzwIj53G1wD67F2h
         BWehaHqZaQdn5r1t9a3j/xh1T7LGqWGrTzOwhDPtQHmwaZe4uovCrHo5eINLkdyEvQVs
         LbWIQbO1uq/HHCVX9g3uH3U9xarcF8ZkYLfEzpAi9DwTdFIqKv///c0RZ+16hIEaXwpV
         ajFNydfNH7seHi30ZELUEIGVtBZctMCv3qldq/o57bAtbawVM0MPMwTWzdUWNv02vWdU
         bBjocAx/9Ld1M+dOwj7pwD3t6jgBNsnnQQ4KYxf/nEQnFwHPSnlZdPOaJWfbA+TnHJR3
         Qglw==
X-Forwarded-Encrypted: i=1; AFNElJ+ouTWncZ2kTJ5Tq49Crbgunc/lHGTJQhdsTrVXN1a8GbtDDgWivPmNtZoAdheB/EJu3FHyHwP9XQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4z+mVyUZw25g7YP1dpLQgtFEHiyxK5pg3wmuwaQTRXrgfOESe
	P8hjMlN58RnB2FIVd2BmDMtIpTU4aI1TDmiP0NKPTljPGos6WTh5ML1+d5Qp0pQUJj0=
X-Gm-Gg: Acq92OGEOE6W7e13vDTjd1hPKbw+lOuOfewoBiD2sHfSIf+Zy5MPqzbgjdRASg0K/aI
	S99kJWN+AEU8Bnz2gJBf5ts0Uw9uoxZNdOj6a/G0Mgdnl5E3w+cfXmxDqjMhaUmXdczDNKHDmga
	UpEvkd25ekoOnQaXYxNsRKzb0e0Jj9N3lysfLcgLMYiVMu67kLd09Dj+20EkU24KPjlFBbKgZFA
	MuMd7ov3Qvh+KPbMaULbeLXzmBlZKF5kGURs4Xfrm/aeyVpEi9XAIJyIJBUl+grkbX6uUKJJL43
	Zkd+cz9DKbT9IYneCpxGpn6jFiQpTtp5ccLiRwhajU6YfHJ58Ay9IK6mblCHml48c9Mn0C+KETz
	99Yx445zskk687ZVlF4g9sZrUz/4GQpnK7ubCFICAZOtqavV0iRICttxiI4bQKzwIaxouYBSWZ6
	7qAzXZrSAHParSjB1mTF6RH16oignBn6f0Sfe3VddA8yDrmaOLjdtanQ731XXcz5D81LPGv05oa
	Gk+gbXN4rxefYQeea0=
X-Received: by 2002:a05:6820:178c:b0:67b:bd89:90ed with SMTP id 006d021491bc7-69c954d3c42mr12537741eaf.41.1779204419508;
        Tue, 19 May 2026 08:26:59 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69d041da4basm7138946eaf.0.2026.05.19.08.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 08:26:58 -0700 (PDT)
Message-ID: <7bfd707b-1e21-413e-a2e7-71e8df3e43d7@kernel.dk>
Date: Tue, 19 May 2026 09:26:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] io_uring/zcrx: notify user when out of buffers
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
References: <cover.1779189667.git.asml.silence@gmail.com>
 <35cd307a03a43583838a2e151fc641c69abd786f.1779189667.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <35cd307a03a43583838a2e151fc641c69abd786f.1779189667.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13436-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 52CEC581B5F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/19/26 5:44 AM, Pavel Begunkov wrote:
> @@ -1126,6 +1142,48 @@ static unsigned io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *if
>  	return allocated;
>  }
>  
> +static void zcrx_notif_tw(struct io_tw_req tw_req, io_tw_token_t tw)
> +{
> +	struct io_kiocb *req = tw_req.req;
> +	struct io_ring_ctx *ctx = req->ctx;
> +
> +	io_post_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, 0);
> +	percpu_ref_put(&ctx->refs);
> +	io_poison_req(req);
> +	kmem_cache_free(req_cachep, req);
> +}
> +
> +static void zcrx_send_notif(struct io_zcrx_ifq *ifq, unsigned type)
> +{
> +	gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO;
> +	u32 type_mask = 1 << type;
> +	struct io_kiocb *req;
> +
> +	if (!(type_mask & ifq->allowed_notif_mask))
> +		return;
> +
> +	guard(spinlock_bh)(&ifq->ctx_lock);
> +	if (!ifq->master_ctx)
> +		return;
> +	if (type_mask & ifq->fired_notifs)
> +		return;
> +
> +	req = kmem_cache_alloc(req_cachep, gfp);
> +	if (unlikely(!req))
> +		return;

It'd be nice to avoid an allocation here inside ctx_lock and with bh's
disabled, which looks like is also the only reason why GFP_ATOMIC is
being used here.

Maybe opportunistically check ->fired_notifs early? Might also avoid the
lock in the first place if we get back-to-back of these.

-- 
Jens Axboe

