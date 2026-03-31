Return-Path: <io-uring+bounces-12896-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IOenFOzNy2luLwYAu9opvQ
	(envelope-from <io-uring+bounces-12896-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 15:36:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5101636A58D
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 15:36:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2818130215CC
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 13:36:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 067DE27A477;
	Tue, 31 Mar 2026 13:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MEL6H0aV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F05317162
	for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 13:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774964160; cv=none; b=dl2gGVxhs8UnuPK0TgWgaK05Eh07VmxNGVo2NrXi9zlci8C7oYOEO7sFjm/xstbZMf8j/lGMJx6mlLq4z075uTOCIZDyuT2gy690rGLIoqjNe8+tHvVRi02OJG4G/K/02qDDLeFyFv95BpcJpFYrATctDRFpE7apEGaIYrbYUMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774964160; c=relaxed/simple;
	bh=sWglElRjfNURNCsnCDfZIrixMm6uTp0HUm5hRJhYvQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pSZ7MADfqOHHXVISqs6q54oZrZ0pf/SRpzmIRNUFpx148qgSrtUbCSt6XXTapX11v4XFptbc67xNyIi4bwuKWJxmYLz2noNsb7kWcvi9z0Z2poqgA1JNeLZjdWGCVqbjMA9ZLvkzPz6AOtN9MXmfNCWloZNcVst7NVPUhYdd4cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MEL6H0aV; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-40ef10ec84cso4361850fac.2
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 06:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774964158; x=1775568958; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fib7tk5k/HCmJrUGhJ92VsGJhQJp1ptj73W5e+vznqs=;
        b=MEL6H0aVtuG+EN8Ak7sL6TyB3d4r/jbucnbKT1KmcMAcmphM1UBA2ca1ju4kJ6KeqZ
         V5OHw0nnpLM6C0hFMyKHmXmzNzKZuXotYRgeHtwF/QZBP93YzZedJolyDONLPckrHptR
         K3d+YH13CFUWqIzbldUdtfjVvCjulh9eIAVYOinpwrbd8eocI4RMzP/aDaW0ELl+ZHGQ
         bEizLDXUvkPlyu/HOctKwWrHg5nHtbjMsH5DhDFknfoJXBUQBEQDlOQvaTZtc6oOjJZh
         pHbbk18kxyUmaKTqjkClXpz6LZlXJLzUHIihb6+yul95/nW9v4xaZhU6MbU2/IpaddMc
         MIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774964158; x=1775568958;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fib7tk5k/HCmJrUGhJ92VsGJhQJp1ptj73W5e+vznqs=;
        b=j3AQzO0iiJpLpg3pMrQji5qGS9mwgeI4YKe7C+BdHmgmXQlM4q+kM5MQmldAzCTXF3
         N7uHB1V6x79YfXq0DkUGjZ6OD1YdIP2O1IWVYTdHu6zXQucvZVNEuXiVXiqYfNB2E0nB
         hOvLx/QtwZQKs/saDkle3bQaHNwuaIn0qWKB1l1dWYthf188nxDLtjeNwwE/HrD9Hh8n
         Z6ba3I9WPIwv4sSWaZ81z/LGNY4ZL2cxf6TFNV7y+gII3p5NjpFmVBTznqCD5NZ4aVDK
         qxIOzl5un7rMV+zJIUZEi6oEYfRQwnelFnJEGP2pMMUNIvksKS9LXAPL/IHW27bXBDOL
         uoug==
X-Gm-Message-State: AOJu0YyskeEnznzH+KAMgs+EYw1oEErvSZlXkHeo0wkGKcnEFPB/kii/
	i/6E0FzbVp6QDlx1vdjG6DbbEzXaohEYE+6rnU4FMS94zd5CDXksYXp7oR+VO+4E/74=
X-Gm-Gg: ATEYQzzuuOsrwZt/u2PwzsL69c1LrXEGaBln6T+8TIM7RkMg/F+TcTRAP1901VTGzX4
	eDk4uIdKkP6dniiHQVVezYh4a0FgS4o7OQjgDgjNqPAEUXA85qifL2+rk6Uq5G5BrxNGrhVUuPs
	pM01cBkpatGDV+1mvmmq8ckCQB6s0xoxCEalt1EbpKAhD0zwMmDOTJBWakdpmcAmveroGgnf1xV
	DU5JBkMxXeGS8v/5RJRoQxD/rup8GYeo+Z/g41d6Zfi0UYR1sY823eixQUf4W3QOFCWPd/pSDCc
	/dVtCTIqjtnT2s1IX0vMPA4KRgDdGGDqCMg6b4llNuohI3eNRMNO28Mv7V8Pm460pEgwbc0zefI
	LDIe/50JI9an43ahH7pbxgSkcFahcLPqiUSszA22L9fR9N/fHkOpfU5FRxpN8Qfk+ed9X4eUZEF
	PL0EEZ9/lD9kOjq5qMv+ssbsHkwldHM0BfhTwA+efB1CCCUMUkj6GE9YKu/CDi1UrLyzlWnXa8V
	wBeRNaq+1v5/x7/e3xV
X-Received: by 2002:a05:6870:9d08:b0:417:4f7c:4ec with SMTP id 586e51a60fabf-41cec253d36mr8853632fac.15.1774964157959;
        Tue, 31 Mar 2026 06:35:57 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41d049523a6sm6646416fac.6.2026.03.31.06.35.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 06:35:57 -0700 (PDT)
Message-ID: <b826c51c-4d5a-4e87-85d2-69b551a7e5a7@kernel.dk>
Date: Tue, 31 Mar 2026 07:35:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: use io_cache_free() to free node allocated
 by io_rsrc_node_alloc()
To: Jackie Liu <liu.yun@linux.dev>
Cc: io-uring@vger.kernel.org
References: <20260331104509.7055-1-liu.yun@linux.dev>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260331104509.7055-1-liu.yun@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12896-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim,kylinos.cn:email]
X-Rspamd-Queue-Id: 5101636A58D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/31/26 4:45 AM, Jackie Liu wrote:
> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> Replace kfree(node) with io_cache_free() in io_buffer_register_bvec()
> to match all other error paths that free nodes allocated via
> io_rsrc_node_alloc(). The node is allocated through io_cache_alloc()
> internally, so it should be returned to the cache via io_cache_free()
> for proper object reuse.
> 
> Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> ---
>  io_uring/rsrc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 4fa59bf89bba..c4a7b29a327c 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -961,7 +961,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
>  	 */
>  	imu = io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
>  	if (!imu) {
> -		kfree(node);
> +		io_cache_free(&ctx->node_cache, node);
>  		ret = -ENOMEM;
>  		goto unlock;
>  	}

People have sent this before, but I usually just dismiss it with being
an error path and it doesn't matter one bit if it stays in cache or just
gets freed outright. But might make sense to apply it just for
consistency's sake - and so I don't get it sent again!

-- 
Jens Axboe

