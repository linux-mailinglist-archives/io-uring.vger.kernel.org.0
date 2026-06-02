Return-Path: <io-uring+bounces-13595-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id CaslD1k7H2rmiwAAu9opvQ
	(envelope-from <io-uring+bounces-13595-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 22:21:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C7A6631B59
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 22:21:44 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=uDwSU0mK;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13595-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13595-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D3DCE3018D65
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2026 20:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53D341FC8;
	Tue,  2 Jun 2026 20:17:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5CF1C84BB
	for <io-uring@vger.kernel.org>; Tue,  2 Jun 2026 20:17:16 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780431438; cv=none; b=jf17/GVTT2eN6ke17/pBzWpBQCyZvss2NocZ9yVBRbhRTiMuyTp8ONml7oA2pOmurWkHNEByofpoMcM+V+TZdhnVrT9TyFuUAbSXxC2doUit3nnJpPKo68jXIsviDCLx9i/X0gaAHw4wJIZW8i+JUuaO4l2FqqQ4vsS6BeNoxUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780431438; c=relaxed/simple;
	bh=Pptq3nmuun3YXPUQlgjiH24c2qBwhXHWFpl/a8uw48k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RbC3n7YFhmBy3/wLFlJ4Q7cUURHXgDQo8qaeW0bVN8SNgkTIJk/OGfKnUfBAMaFbFpZ3dOFzQjSR+7TJ06ixcpcSqkkmrhWWtBCimlzLj/j4vuWg480mJMyXiwaS+Z95DECp9doBjC+Y9r3FBtziTlj6bByxEBaA+3Cuat0YEzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=uDwSU0mK; arc=none smtp.client-ip=209.85.161.49
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-69e43b02308so325201eaf.1
        for <io-uring@vger.kernel.org>; Tue, 02 Jun 2026 13:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780431435; x=1781036235; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1o91wHh3dO4qssJ9n8UOKkFk+HYpWlMA4PQ+MEG9OYs=;
        b=uDwSU0mKMssxM9Vx3Y9IaspocHs7OD3NFqrhGtaVObJFAUQgPgLONcm9z+tq2bImpX
         p3hfSBKLaz+hQyzlLsLCSCrb/abOuDiZvie+RQ4mVgR+3PnaQ0pmGwkVGgj9FdQp0CzI
         vbScRMFGiHS3dGeJyYtKNjlWvBxtxWqW8+uMo72rGWU4yS9dVIM33qDasTB7LNR5+m6l
         KJEN9hPdGpzFwbYsVFKjNgoVpTWtaTvT11TXo9Ac+lIF7Dq5v18JyjKOlj37iDeVwRVv
         XkjWo3DsfsLqQ4CqVrMuyJjSce5qhmU14emsMJRSOecWjiF435x1CLMOyUuM3Pj8Az/R
         0ZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780431435; x=1781036235;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1o91wHh3dO4qssJ9n8UOKkFk+HYpWlMA4PQ+MEG9OYs=;
        b=GJlcLr52i+qFCsHP6do0RLlysWdHcqc1HvWyjm2WDsll5yb1IoByYYaSyKvFg1lhDz
         m+OPvM+sQev69W+H37KhAp4UduXM5vwyODlGB+xSJY6rW+uxZw1Zntu8rK0RzkjtjETT
         lAPcZdXApjPvPEa6vzO1k1CjamXevfXU8tK9z/ScYu0AKFi/mhtN0yPhHSL+3bgs146O
         xfF+HldJCyavBgyfMw8489Ltl2EtQdsiZyem2pO96I6KatnMhg+SVFEYiMy0mIzOfT2Y
         8dw3r9Pk3NbMY/qVdgRSowVTu/lwzczDuVBAE/MHrNuIUg8zZfq3C62AbGvP0ks/+VKe
         urxg==
X-Gm-Message-State: AOJu0YzZ+NVmXqXl9VhdYFxHxxvclX2is36WC2oV1EvJsnep9GK867t5
	eu+hpguolCE/weLOFmtwvHBxtcrX+FqKH98gdrnIWijX0TmygbX0Hu0zi2Ct8/qYGcpcVm3BPWQ
	9Zzfn
X-Gm-Gg: Acq92OFdjAwUXEaP3bcwqrqsuTaMdQFJbwZEPMgACXAezVh7hkevh1JfZ9lBFwqrIY4
	1Yivt2yPzPpZKKBBBiGo4Oy0XqwNySVxdR2xQUKQ+09MFQWr7xMjqdncIl0286z7dSdq+p6v6Yw
	7LW/nhNybMocl+KfH4NhNWeKDZP53MUl+YWoh+WALteRJMysoVw2iCTI435hiopv5x2l0Z7iXsp
	6iZBJiSe7vjBQ3NmIOH4TMc8PeZHXZzFwgJr+pP23qPvUWrBKmFrx+n3CcGzJhEiw6ksXQghmUe
	GU8xrvRz+jmYSzH9i2qKRPDkfJlLJmwJktdMRyunuo2jsMtAXWuwvnFxOUQUlCOrL2Q3N2hWfNt
	De2R5kuEP5BgJfGSjtCqjln62eFumZkKU6FyCH17bdH105d5ypYfUZ+AGT7tBOdQiO05Y6VvbJA
	gYjQfiGMwhyt1Ypm9Qb4M1hWJ28LhviSIJU6nZgSykR7c5XHAmDgamDHhGQCyi+QlRm+MC6PJMV
	wXcfmMZSWbhJ32FuaAAKKPU+FrDDg==
X-Received: by 2002:a05:6820:8184:b0:69e:3e6b:c07 with SMTP id 006d021491bc7-69e47e77bfbmr368495eaf.5.1780431435132;
        Tue, 02 Jun 2026 13:17:15 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69e46404817sm551686eaf.11.2026.06.02.13.17.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 13:17:14 -0700 (PDT)
Message-ID: <d825292b-7d1d-4681-9d81-301477c864e2@kernel.dk>
Date: Tue, 2 Jun 2026 14:17:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: Avoid msghdr on op_connect/op_bind async
 data
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20260602200315.1761983-1-krisman@suse.de>
 <20260602200315.1761983-2-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260602200315.1761983-2-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13595-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:krisman@suse.de,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:from_mime,kernel.dk:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 7C7A6631B59

On 6/2/26 2:03 PM, Gabriel Krisman Bertazi wrote:
> Both IORING_OP_CONNECT and IORING_OP_BIND reuse the msghdr object for
> just to store sockaddr.  Beyond allocating a much larger object than
> needed, msghdr can also wrap an iovec, which will be recycled
> unnecessarily.  This splits the sockaddr into an async type.

Note: please prefix things that are net related as:

io_uring/net: Avoid msghdr on op_connect/op_bind async data

> diff --git a/io_uring/net.h b/io_uring/net.h
> index 51fda715d3c0..b296ec4eefb2 100644
> --- a/io_uring/net.h
> +++ b/io_uring/net.h
> @@ -5,6 +5,10 @@
>  #include <linux/io_uring_types.h>
>  #include <uapi/linux/io_uring/bpf_filter.h>
>  
> +struct io_async_sockaddr {
> +	struct sockaddr_storage		addr;
> +};
> +

Why not just use sockaddr_storage directly?

> diff --git a/io_uring/net.c b/io_uring/net.c
> index cceb5c1409ca..1da811100132 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -1677,7 +1677,7 @@ void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req)
>  void io_connect_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req)
>  {
>  	struct io_connect *conn = io_kiocb_to_cmd(req, struct io_connect);
> -	struct io_async_msghdr *iomsg = req->async_data;
> +	struct io_async_sockaddr *iomsg = req->async_data;
>  	struct sockaddr_storage *ss = &iomsg->addr;

and if we did that, then this line goes away and it just becomes:

	struct sockaddr_storage *ss = req->async_data;

instead?

Other than that, looks good to me, whole series in fact.

-- 
Jens Axboe

