Return-Path: <io-uring+bounces-12979-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iEGAGoET1mngAwgAu9opvQ
	(envelope-from <io-uring+bounces-12979-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 10:36:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 278EC3B9252
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 10:36:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9D177301726D
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 08:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0752F3A6412;
	Wed,  8 Apr 2026 08:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ehVqOdBE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928FE3A6B62
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 08:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775637356; cv=none; b=k8BVejDhjoFpJC/MWWHwcuLpf3EBluEd7sU5SYYQ8QIN72A+rXuf/0Tj4vmSWZefZBxsTA8vIDWe5uInOWWzB9Poko7psQ/N+zxnCyKXIEb5Y1IiYiJ8mgiKprB62SfW7oHulpyB+8oBv6TqBdlrp9gatoN1VoIh9wieiBvuN2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775637356; c=relaxed/simple;
	bh=/j/mCKzNC16wLgMFAQX3HI7G9C2VVWHKb4dZodwbG30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DdtNhh3ZQ0zTBILawhc9GSlyVA0LkJXFwla49hDXgS27TRjeToxkMxqiakmx/cPksB0MOLKGMCl4Rd2pDk1smfeB5ISXePHrnyxQwXrV3ZZLoPYFGPQ8q2SKhneccLnE8AyZHmAlI7/D8J4o9X+TBbemYVUhF93Y72Pn1gFX5Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ehVqOdBE; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so54997735e9.0
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 01:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775637354; x=1776242154; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v3TQJY5IlXJsbG9+wxNqKMgJ09GA4sRxRbi0tKG232I=;
        b=ehVqOdBEr1OP0RKwOob8OvZVNt5QHEkq93+8FZehX/CBNGzd3jrNcELBvZMnKj2CP3
         /+BUiexQ4qBlFnELExQfwwpum3KRrjGn459QdSgTCuL3mT6lQ9+5qnCa1nE0mLyuYqX2
         C0bV5DX2FIsC+3O5T+M4yhmbYi7MDuZUsw7y8k7U76Fmv8peYaDMhKuUvGHsEhlopANZ
         Bxnk+Fx9l8FZze5YXtObBQiJ4GTxoD5AAjlzBrQQu7wuSdv+7EOOcij34wYYgnv7K0ca
         S0o3tnjc1+x+t/lmVN3moYQEf57YQjftnae/4PVLsoO6gZnnZ1hUhkQf4v85ntCrbzli
         L5ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775637354; x=1776242154;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v3TQJY5IlXJsbG9+wxNqKMgJ09GA4sRxRbi0tKG232I=;
        b=CuNjF/Knb9zmpeswZGbPD1F151cxm4OSg1Y8QkytcHra2xzKoPIzmCjNDFPmwAw6l1
         0SHZu1GmN2oGUzGDv+ho+APzszK21pphmiVKdJeBEwRmsGzZYOCVdG5wEnYcXO9Fd3lt
         GY6WxD6RS8ibWzAYGRbnxxLUQMz+ZhPIOwThdPZsSBeXviyfUZ0ysXxtgVSxCbh6PGNH
         xYx8wWEB6JvifAiVG12CH9W/TBJ70iAnDfTRUj3/N6b+TWliGcrItgEBkLvR7+nlYk49
         uatg2qpk5xbKSObJMapIUpuRZ3an2h4Nbug5+pUW9LRJtSXP90uEgLUuQ9YSs626fLQZ
         ANdA==
X-Forwarded-Encrypted: i=1; AJvYcCUwsw394/71VxjNbHt/AXkpjgItCJJ4Wa/eOIT3IUFpaS+SIR0sjxawVFOSc/G0Oso0+9QLGOJtVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfJVOdf640kRYAICMvde5d++rZsgNcBQR9oqzLT10j1POjnUaR
	mo4TRFltOA9yKBtYmKtqoxrbOI2N09NIiSlLeXb3LsnqDaUyzH00/TXn
X-Gm-Gg: AeBDiesJC+GvMp1vO3kbKWF7/t+/BjLLljp8aBnvgeuFsxffuN8RyvUGTjFLgIGluS3
	XzpL0ed8JovXy300MBlTanfeWLQuGVnRhF8nQRtcHVQRd8qPm11k/EeM44a2otIh1PnLAICBDy/
	UIf/Ox3vQjFHyfnaVUbvOX09nboDazXW5XuHbnvfT3c7JSMfITJPox0I67dBwtxwFMGgsOFY6Ok
	3nku8ThtN17XeMd533IRBNVWweLARJuVM+OfrLbelJEv6Vyn/9i4ZwW9CzCqPOkJLYUrIFUzJn2
	01Y7Z/t+DeXNrIoyW6I79hnhZW8QHC+k/zM7kOpxMVjPlNa9LvVs2CGRRViOH3TLbb7pQKLWZWY
	A8ZkspmgNBOIoGli+lOc0hBTtnVkDuMVKUB14Eiaun30pghwW63pJhQL4YWm0pkJPVotJG9JKwW
	YWeSw+HWMb+om5oK1iQyWaOUqD4Vze8nsLQmyxjhXUMtdAXt1RT5MaOQ4f0Rdik9rfQonAkgfAD
	wjuqlaVK7ohWkPRYslBH6ohClnPOX8QcSHZHf/kHb4gWRo3P4SdVAXKtUA=
X-Received: by 2002:a05:600c:4b23:b0:488:a723:ea53 with SMTP id 5b1f17b1804b1-488a723ebddmr118522865e9.7.1775637353943;
        Wed, 08 Apr 2026 01:35:53 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:eaba])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488be75215dsm119684505e9.6.2026.04.08.01.35.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 01:35:53 -0700 (PDT)
Message-ID: <b3ed9023-3211-4f1f-a264-e71df5ba898b@gmail.com>
Date: Wed, 8 Apr 2026 09:35:58 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/rsrc: use io_cache_free for node in
 io_buffer_register_bvec error path
To: KobaK <kobak@nvidia.com>, Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260408065408.2017967-1-kobak@nvidia.com>
 <20260408065408.2017967-3-kobak@nvidia.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260408065408.2017967-3-kobak@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12979-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 278EC3B9252
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/8/26 07:54, KobaK wrote:
> From: Koba Ko <kobak@nvidia.com>
> 
> io_buffer_register_bvec() allocates the rsrc node via
> io_rsrc_node_alloc() which pulls from ctx->node_cache. On imu allocation
> failure, the node is freed with raw kfree() instead of
> io_cache_free(&ctx->node_cache, node), bypassing the cache return path
> and wasting a reuse opportunity. Every other error path in this file
> correctly uses io_cache_free for nodes.
> 
> Fixes: 27cb27b6d5ea4 ("io_uring: add support for kernel registered bvecs")
> Signed-off-by: Koba Ko <kobak@nvidia.com>
> ---
>   io_uring/rsrc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 1b96ab5e98c99..6f46cf9cd13d7 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -961,7 +961,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
>   	 */
>   	imu = io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
>   	if (!imu) {
> -		kfree(node);
> +		io_cache_free(&ctx->node_cache, node);

Looks like it was already patched a week ago

-- 
Pavel Begunkov


