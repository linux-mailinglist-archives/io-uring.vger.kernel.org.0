Return-Path: <io-uring+bounces-13314-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IHRSFDWKBGoxLQIAu9opvQ
	(envelope-from <io-uring+bounces-13314-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 16:27:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5B953507B
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 16:27:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7C494307B64A
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 14:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B75B3E51F4;
	Wed, 13 May 2026 14:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="HyPK3lEZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE4238AC72
	for <io-uring@vger.kernel.org>; Wed, 13 May 2026 14:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778681886; cv=none; b=VVKY4OoAz08swvX9/Wh3CEQBszt9I4YzOJ+BgWfA6K8D83NwsIDs1PGiYvuvettEQIErcwSAALgxghpZFTFz9kYmCW9pxfLtqXWcHsoGu17tsMHctuNhEKMuGs3ZDJA0g8IOSzJpZzl+fsS+qD9LVrP/P2zFtwLAXd4skvxApms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778681886; c=relaxed/simple;
	bh=hLJZpGw1TT4jbenILMoumfMtn/sBA7GJejqhTn1Uk5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QcetyhQ4axhstoEHmh1p8qRV4qEQihY8tCVgxYMAyNyu0/OBLRaUOs7zhGNzafKRsrBqzmVpK11O5tuaUyDctWhjgzV9PE/BMNqqQJuoP6q/9PQp1z02GqXu+WIsFQ9QdfXrZegMBXSoiqJRvAlcowpUpiT7q08lGc5QmaeYf40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=HyPK3lEZ; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-439c00ed7e0so1227563fac.0
        for <io-uring@vger.kernel.org>; Wed, 13 May 2026 07:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778681882; x=1779286682; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CQwtfQTbtV4sWqtTbJqDHeHrOkNhE/9q+N68X0hv4io=;
        b=HyPK3lEZUT18/sOYIl2fVnxPdLorHCMuTfTythyKWNRRl8tXQRnkScYXsfzAoosM8l
         vyIM1BY72AHufRf95/12XRT2COaWyRRqYQW1MWV+1cGJivteNkvyboFh5+RRqPnSVR65
         zEOL1AFpUn47VIgXaJYme0/KDU2Rsdu5QAeO7LgA5nhUQp69Ybpi0u12dWcTNKHnTLlK
         JXbAhW5hi+VvHDT2r1LVkB5MoEAx7V1LCQ4OzN+sMVPBLtwrZdP3OXrwS+Gkimb8Qr3c
         NrABzC03iyCO44F73cuXXAROZoj+6VoW3SLZbCl+8+yUh1k3bHqQEKPh8Ahzy84SayrB
         Tb3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778681882; x=1779286682;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CQwtfQTbtV4sWqtTbJqDHeHrOkNhE/9q+N68X0hv4io=;
        b=Ta2GIBl86kN2BPMtaEDNsgvw0ziKWJ1T8zB5EMb+zaHnisVF/boESZgabjXqifzDRU
         qLEHytG40DC90YNh9p4Lzc34vfxNeh9LYJuQFEQOBHQA6J3kUamBbH7VGl1DCo1nGpH4
         z1D5h5NtNqD3ifj3mtLyLMy4D3tDOJNA1QphTVXr3SkDp2sL1P6RkoEBzYs52W3cN5Rn
         3Q2HxTqWWB1gul0HwixwpQgmi4qWx5ZjopdxtARZCwNpPPTso2gp5c2du1dHaaMSUeAU
         rknlRGtJNn8xLOUxTguRAAk9L9AYCYwju1E+XcAGMJEtYOtoNspHITAdssR1U79hc6zd
         D2VQ==
X-Forwarded-Encrypted: i=1; AFNElJ9NZ8r5A1feiUn0XUsqXH7+NOK0+kG9ieQyIGaz9zan9dpkIoIPjMXE6/6XKOB7XEymoq20VfqF+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn20XV0oueA/Tl2LGzb2dq7Ntcbr7fWmdRnra/24e0O0TWdXgw
	rDOFfWnNfFisBt9BiYju1N/0I101fKRniF+knRvOmIoBTBBq/Nw6rWHUN7z2uTWcZJs=
X-Gm-Gg: Acq92OGEMv8IaSvXn5ou4G0yGOhyftpccroogGPA/YGgzCy4/a6E4tQSsRyrsHnHzax
	osGyx+lnOH56mZlAM8cyhfJUng6282tpds/Fae3us84v/G3ZTVGDslTHyAgynMDBF4c2MPAYVRJ
	r1CGeHRz8qesb2Af2+zJ8PYj6fjrgmO3Y83jNuaHTj8mF2NFutSMnWNSR7zeQ5Yexn2tIjgENSr
	/+w/fhP81J/eNZ3wyOKjacPfRMcJgVEjgekqXx8itAck6OV8HTPiyytUBfzhg+fozg7lEJM65V3
	i/yQAkZon+K0YhJf4Cg1paQHmq2EojYanOMXgRVL0v0wL9uzmIQW4KMH7U20oFzAZdy/K5fXqBn
	5acBMGQk8Cz/5+xXuE60fCC/ruXSfavuaJMuCSDWg96w/6kBHI4IukS+zCeisZab/YbJDHBcf3k
	/BousQOI27S1pW+T+v7/plorbkroXj2MEx+Z0W5AL0BIekRtZhBeUqVsrASVsq6MvLvHRmyGYKA
	CqBFmSAKQ==
X-Received: by 2002:a05:6870:8303:b0:409:5560:72f8 with SMTP id 586e51a60fabf-439d2801e42mr1653076fac.0.1778681881754;
        Wed, 13 May 2026 07:18:01 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-435574490b0sm15847586fac.17.2026.05.13.07.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 07:18:01 -0700 (PDT)
Message-ID: <f8dc69f8-7191-4c60-a2a3-2fa85a089927@kernel.dk>
Date: Wed, 13 May 2026 08:18:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: validate user-controlled cq.head in
 io_cqe_cache_refill()
To: Zizhi Wo <wozizhi@huaweicloud.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yangerkun@huawei.com,
 chengzhihao1@huawei.com
References: <20260513063254.1122354-1-wozizhi@huaweicloud.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260513063254.1122354-1-wozizhi@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DE5B953507B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13314-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[huaweicloud.com,gmail.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/13/26 12:32 AM, Zizhi Wo wrote:
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 4ed998d60c09..92e255e9e08f 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -710,11 +710,13 @@ static bool io_fill_nop_cqe(struct io_ring_ctx *ctx, unsigned int off)
>   * fill the cq entry
>   */
>  bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32)
>  {
>  	struct io_rings *rings = ctx->rings;
> -	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
> +	unsigned int head = READ_ONCE(ctx->rings->cq.head);
> +	unsigned int tail = ctx->cached_cq_tail;
> +	unsigned int off = tail & (ctx->cq_entries - 1);
>  	unsigned int free, queued, len;

This looks wrong, as you're snapshotting 'tail' while it could get
modified by if a nop fill before the refill happens. And fwiw, looks
like the refill part potentially suffers from the same unsigned issue.

-- 
Jens Axboe

