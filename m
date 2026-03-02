Return-Path: <io-uring+bounces-12501-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iMCqDLNhpWmx+wUAu9opvQ
	(envelope-from <io-uring+bounces-12501-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 11:08:51 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A6471D611B
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 11:08:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5832D30A92C0
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 10:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59ADD39449C;
	Mon,  2 Mar 2026 10:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AeQ55TbE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB0629D29F
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 10:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772445788; cv=none; b=EoWFCswDrJ812StZ4WH7Sj2gEDCwua55de7PUNLx9lyfWXxdKL/tFYpJ1OCDUU83u2oAZl/DfNLstQEDWf9+yzUdZwafe2uLzas6ytgTlaF43qQFhd1yN+EghIvSxaj+L4NSAuFAI1bWRuOVyBX6X/rwmqVtlefy0aeKrn4EEEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772445788; c=relaxed/simple;
	bh=57fRY/uldheHXz8pZoqfNhRreb762+PjD5Xu/G23mGs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=qES6GsmduRECPiN4TJJIrBk5J7Qa9caYcAkxqI6TyWtxVBtKXeekRLgj4cS9xdJ5efE/GAycf/nCC1gmhQjPvm+naWsowxxD7Ziv+l4FszIVn0qtUzJ6IMdoHjKTiBgw//h15zzgWb8HXNNnvuSZzbaAcU4ukg3kABJ7V3tfjn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AeQ55TbE; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4836f4cbe0bso35690165e9.3
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 02:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772445785; x=1773050585; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kTyW8POl7cRW2tLQQUG/rmH31BNr8DtkbGHz9hqNo+Y=;
        b=AeQ55TbEJ4+BNiv3stRXgs5A3PNsqv4J+3uGvPgvE9/abEtWwXB7x3rC6Gb7UMlsQ6
         fHP5LJfTSQmY6iAjAFjZhtEtlrKxygz+PUmjsRd3QFSckT9JZdxkI6Ny6PzMkC9uHyWT
         oVUcTaFGtSokkpgdmtlvk9NJOyub/S3Nk3BdfOgjOvLsPIJeOWhsfHEfqgzECs1IjWO6
         VJkLuQGxSNZI8gXsR5OFNxlWfKJsiBqpN3Zk7UnFEOtIC9PyMzy+ddnVpktn/oCDXGFy
         6LCZbTtPjFVTwEfsB8EVWQGwHAeVAoQ2deOGqNT3osJwD+TlzLS1Xrj1nEBFDzFliyi9
         fGHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772445785; x=1773050585;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kTyW8POl7cRW2tLQQUG/rmH31BNr8DtkbGHz9hqNo+Y=;
        b=wA9TbGOSrPQZ1Np0DPg0/PC8Lbhd/yAbQkkg4G+vUYDrK70U4Bar0bFUn+ZVxUQoFz
         IETvgmAZMMkyr4rEJWb1rnpAl29/Ga6ERSNrwMjb4WDv6XvIH42G7r+80D26POSAMcW3
         JaLU7hlaUZMhl0qkGBy1HX3wVCMkXe9kh4ZKMxRpNUCOHlZNLxCm6cj2MQVBHZnBBsCL
         flRJqevNySD4qv49QAG0Dxhl9vpWS1F2TL+E30t49tzswrt4vuR9aaN0IBmHFFO8UsXb
         ax2ypY1HXd+P03BQhSNJ+TnccyZ5vV0RgYqoFPeXrnm0BWQ+GYakuy8OCYWrkyjM3YYt
         w7oA==
X-Gm-Message-State: AOJu0Yy1b3sd7mkUOIgqPKETvWkcxkmO26cJDUVyj6pPEqPt+DIyVymm
	TDopBeMNzUSgFXJoUOt4UhxD5vAduryV7TtKTheIsvbxalm6Fjq9T1HB
X-Gm-Gg: ATEYQzxfx/BOjGmAfCHaLniGf8bk8xyVB7SxqBLo9B2k1mUoNdHv+2Mif3UChgExps0
	66UYHJlIfDorliyelVCG4NI6vSHXYOrF88h8k4yIT4QTSxsA/+8ej97k7m3kJW28/7EAJKqNxw5
	39jHap58twoExEwtuVQlamsPqAKVVnabao0ucAX6REt4eZIvBYQDwd3qq3jssErUIotRko12laz
	fXbDVuujKy6lXfj615/ZyR29SPwjW4t3g+JXsLkgUp36+5KGplO4ZlUqYjD58KTv1nxPI1uO7OM
	3YLoRJyUmxIiQ8GCPZ5yTd3xZBXH+eq1aVPL7Ms1TssmNGAogVa5gXODNPKG9Sa9gKX/CShXWN4
	CI+B1c9eQESuG7RIPIQaWWoG0TQM1LTzHqtNpY97i4HSfvkwmM0kAQOfBphw8u098MSvG9OTFtY
	gPQKfPbx1kn0imgbz3aHcg9efpnFvQUVjYvfpD0wWjpHooHlFAh5jAMNjVOil/J0hd9BHHzcDjj
	wFdETatEDG6t2fCkL4OENi2nMan7SslhBR02hvo8HUNYvzafhqggVkcbi0=
X-Received: by 2002:a05:600c:8b11:b0:483:6f7c:19f4 with SMTP id 5b1f17b1804b1-483c9c0b6c4mr201046285e9.30.1772445785317;
        Mon, 02 Mar 2026 02:03:05 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:773b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c765c67sm28190288f8f.32.2026.03.02.02.03.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 02:03:04 -0800 (PST)
Message-ID: <53896290-9a0a-4822-854f-945595a19fe0@gmail.com>
Date: Mon, 2 Mar 2026 10:02:59 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: FAILED: Patch "io_uring/zcrx: fix post open error handling"
 failed to apply to 6.18-stable tree
To: Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
 stable@vger.kernel.org
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20260301011746.1671806-1-sashal@kernel.org>
 <002c2bb8-3304-40e0-b8c6-8eee7dcb7710@kernel.dk>
Content-Language: en-US
In-Reply-To: <002c2bb8-3304-40e0-b8c6-8eee7dcb7710@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12501-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6A6471D611B
X-Rspamd-Action: no action

On 3/1/26 13:22, Jens Axboe wrote:
> On 2/28/26 6:17 PM, Sasha Levin wrote:
>> The patch below does not apply to the 6.18-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
> 
> Looks like this has dependencies on parts of this:
> 
> https://lore.kernel.org/io-uring/cover.1763029704.git.asml.silence@gmail.com/
> 
> series. But seems easier to just do a variant for the 6.18 base,
> I'll leave that to Pavel.

I was thinking to remove post open error handling. xarray is preallocated
and shouldn't fail. And copy_to_user can be moved earlier. Should be safer
than taking all deps.

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index c524be7109c2..c6ac7365acae 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -625,6 +625,14 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
  	if (ret)
  		goto netdev_put_unlock;
  
+	reg.zcrx_id = id;
+	if (copy_to_user(arg, &reg, sizeof(reg)) ||
+	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd)) ||
+	    copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
  	mp_param.mp_ops = &io_uring_pp_zc_ops;
  	mp_param.mp_priv = ifq;
  	ret = __net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param, NULL);
@@ -633,21 +641,11 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
  	netdev_unlock(ifq->netdev);
  	ifq->if_rxq = reg.if_rxq;
  
-	reg.zcrx_id = id;
-
  	scoped_guard(mutex, &ctx->mmap_lock) {
  		/* publish ifq */
-		ret = -ENOMEM;
-		if (xa_store(&ctx->zcrx_ctxs, id, ifq, GFP_KERNEL))
-			goto err;
+		xa_store(&ctx->zcrx_ctxs, id, ifq, GFP_KERNEL);
  	}
  
-	if (copy_to_user(arg, &reg, sizeof(reg)) ||
-	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd)) ||
-	    copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
-		ret = -EFAULT;
-		goto err;
-	}
  	return 0;
  netdev_put_unlock:
  	netdev_put(ifq->netdev, &ifq->netdev_tracker);

  
-- 
Pavel Begunkov


