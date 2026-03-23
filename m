Return-Path: <io-uring+bounces-12801-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IJKgG0pCwWmqRwQAu9opvQ
	(envelope-from <io-uring+bounces-12801-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 14:38:18 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id F38AE2F3129
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 14:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 67A1D3019098
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1BDF1A4F3C;
	Mon, 23 Mar 2026 13:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GuoJJeKo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FDF18FC80
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 13:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273048; cv=none; b=epAKSr9p/XevDnpiFU01E2H3DAdMrL45CLRMniQewB5xYROm7AHodSo0gGU1RE2DV2fmOd7uFpgyysplZJcgu5dJD01+l5pv0zifqQ4c461Ofzh/OyKLdkdjDg00KcKcaE0B4XgYHjFqSEmIoGDTjkp8AfU7j4c7XsSiKUaZ7uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273048; c=relaxed/simple;
	bh=cuqf5WKEOeSBvl5nCWR95sghaIdZAB/uyQOlk0lWsBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S3YWGiJVw/09sNi/OF5Ez3ZfAa6rne5mQOWNCtSVyaIWKc9arQh3Gns++yUpCofbQ2R8XytGU4iCbMn5aUdTOcdMarIfgWnaYOlCZgI4vABt+SlpB/0ZMI2eo9R8ekcdRh+xTv1w85X97ltGyndnq4qFPjbcldFdHhNEtFuRPXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GuoJJeKo; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7d7f9285560so1169521a34.1
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 06:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774273045; x=1774877845; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jr0xfFxyDLcn1eSxu2mPqEreGtCiMmN42izltshk9hE=;
        b=GuoJJeKoRGTMpbffh6cfLal7modHZRLYB3Oy5bCZCcbW1t4Rj/yzA8nIQh//NJIdCk
         PSWc7+IlkhjcA+mj7cUkATZt1RYEIcQD+leVjaW7nCjZazp3jVTs/3rH6KwM/iE9st3K
         /lc2grCjzw2PPRmUJFmKLTky8QzNMcn1uIhl91uRSTXitpWX3Z0LYMHyif+A+dxGxaiy
         Y/RjCvGAtOm+gGCBBsUpaEmu8lFusQQeQuTox95+9+Pnh4Z7bUIeRKYjcoN2Sk6HmlY2
         2CMRM2xsZCBk1/XGOrvP03S9F/mc0QWXGIh2e4DAol0iJmub2GFQgT6ZZnI87NpFQ6xm
         oAVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774273045; x=1774877845;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jr0xfFxyDLcn1eSxu2mPqEreGtCiMmN42izltshk9hE=;
        b=PKpNhnSTT5b6nwmJChZP1JFbbQT9yMVFGBBj8HQZGshCTrtO30sCR2EEwYtAYThDeO
         Xd7krNpW+2Bn8EkD7YlOSwbHJkypEGzF4fe16QWOmm70VKihRIlhd+0BGZXCp+mmrQmU
         eFTLSlhnU9VgPhBx4S2TR3VsAk8b4VlEGI9US3JAd/1oC6guw/cymAATKdNm5Op2E6at
         OG/lZhA3e3wu9xtPcNXRwk3hzLDsmapm5u16D0HGJM7eQ5ePy3kot14uFSA/wBpsfmFr
         8VyNgEAdkQ7+oaufLd3V2WsyuQIk2Wo+J9kxr0rr09YRSH9V2OvWVeMat6+AQ1jGP9Pf
         4PUw==
X-Forwarded-Encrypted: i=1; AJvYcCXx3mr1ACuF+1ZMzlQDXTJFbteeF5X0LUVpmYQXU03HK3SusLRIUSdQnRKGlOtv6I/JFy3tRrdJ7g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvin0IeV2oTMx/I875r5sUeDQFPUQAuYIz4rZjbRsJFME/nRZb
	tj89QFh4fzd0pEJe+FjKbimaJ8v2udtgOAZC/wWq7AZwBfRmagkFm3f0FGBw58qr7bs=
X-Gm-Gg: ATEYQzzjCZss9zE0Bt9pwSDvR6/p4MUQLdSqyV02NXOBInbpsRxQIn8i0Mopfc+TPU8
	IV7IVOr3HIpcedUJHJV/L+VXKyGhxsLnKQ36k1mIfAlTNsnRQe++rsGbOGw/ptXxVo9NU7DtsVu
	eTdy1duR0YmySS+iPTWTJ273eRMJvQ6GGGE4z+pOTD6upHiYVAh8tXAhvGIfz0V7uykZZr7LRna
	BtU99SSnT90xMdbV+vA7UyWi+y+APi/QmVyi1uPV8Mo2ENw//HgnoMalaysvNm5vyX7qzAu7iNA
	sxKNgSOhcvFhqBCryW+pJFLV2Juhfl6DiaClrEN1/B9b0j9ny0GnRtd4fWAgfldW8u/smqbjAaR
	MmBeD2Em3GNQvfmx3iiNCtjKyI35jduVftWL9u48AZV50P6TMmVXrs2vFAGk3zUPCx20MZR1hfx
	xziP2IRzsHjLpU5p9AgeZZ+MUBsKQj/QpGNPb+OFdSn4j+rcE7JBwPystcYCZRG2XbrfGE1FIWD
	WO94r6VGQ==
X-Received: by 2002:a05:6830:82cb:b0:7d7:f700:fec1 with SMTP id 46e09a7af769-7d7f7011e61mr6635086a34.32.1774273045411;
        Mon, 23 Mar 2026 06:37:25 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7eadfc678sm9323570a34.19.2026.03.23.06.37.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 06:37:24 -0700 (PDT)
Message-ID: <c0e7718f-7bec-44b5-966d-46149fe30507@kernel.dk>
Date: Mon, 23 Mar 2026 07:37:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15.y] io_uring/tctx: work around xa_store() allocation
 error issue
To: Robert Garcia <rob_garcia@163.com>, stable@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260323081930.899697-1-rob_garcia@163.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260323081930.899697-1-rob_garcia@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12801-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[163.com,vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: F38AE2F3129
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/23/26 2:19 AM, Robert Garcia wrote:
> From: Jens Axboe <axboe@kernel.dk>
> 
> [ Upstream commit 7eb75ce7527129d7f1fee6951566af409a37a1c4 ]
> 
> syzbot triggered the following WARN_ON:
> 
> WARNING: CPU: 0 PID: 16 at io_uring/tctx.c:51 __io_uring_free+0xfa/0x140 io_uring/tctx.c:51
> 
> which is the
> 
> WARN_ON_ONCE(!xa_empty(&tctx->xa));
> 
> sanity check in __io_uring_free() when a io_uring_task is going through
> its final put. The syzbot test case includes injecting memory allocation
> failures, and it very much looks like xa_store() can fail one of its
> memory allocations and end up with ->head being non-NULL even though no
> entries exist in the xarray.
> 
> Until this issue gets sorted out, work around it by attempting to
> iterate entries in our xarray, and WARN_ON_ONCE() if one is found.
> 
> Reported-by: syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/io-uring/673c1643.050a0220.87769.0066.GAE@google.com/
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> [ Modify the function in io_uring.c because it's located here in v5.15. ]
> Signed-off-by: Robert Garcia <rob_garcia@163.com>

I'm find adding this to 5.15 stable. However, this also need to go to
5.10-stable then as the io_uring bases are identical. Greg, when you
queue this up, please add to both. Thanks!

-- 
Jens Axboe


