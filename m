Return-Path: <io-uring+bounces-2638-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F15AC945D15
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 13:17:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FB001F226A6
	for <lists+io-uring@lfdr.de>; Fri,  2 Aug 2024 11:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 822201DE876;
	Fri,  2 Aug 2024 11:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G2jHWev0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C333215AD9C
	for <io-uring@vger.kernel.org>; Fri,  2 Aug 2024 11:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722597438; cv=none; b=r9Lrhmxgnm9qeshX0SIh1RRtKnKdzx98Jk7537HHBH9l1IaKXmoE4Mflcpibic9HBplGZuv0DI89c9myQAQe/1tNLjppTrgFWhx8d/HCRVRI6CLj3jxjACF308y6Oh63BHaOHB6A/frDVT8icl9+npPuTAXGgZPBlVmbRKYO7J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722597438; c=relaxed/simple;
	bh=TrNxREV2G3Fvv2hoSWi53L5ZpBLHs+8hDkDf/Lo+lFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VNGsNfxxYxAYAEj2mFORp4R2l/TRhjGcEeelf5vzIbNSiOoS/JTPHD7A/rRnzBvkiLFEebb2Fbg7PHiHDiJ7Y0HMyN3dxBoMy2ZH6R1R72Pl4pi+yAadEA4pIyXdxN3LT9r9YDQ9DZHlLYGlxXOSHT7+YJRbRiPAcHGh4b7Le6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G2jHWev0; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2f149845fbaso44571881fa.3
        for <io-uring@vger.kernel.org>; Fri, 02 Aug 2024 04:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722597435; x=1723202235; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EzvCbXgl3zCnkI4NQ841vaJDCaDC9jhpiXD5l8QF0TQ=;
        b=G2jHWev0KLjQ6Z3Ge7cYHf0bwbHMnHwmx/Hd/Klz6rOShQtens7YF1KM+lGIut5XG6
         aOIsW972NYsfbNhPuHegG5Fbl/V6PsAKDJYYfim7eIgyM6GS1Ogmtdn2nlWYWiacnyxV
         EjCp5U5YEoHyDyf2/rGKiMhWM/NxXLGuc5TvRk95Dk4rgRPajn9liPk5W093D/NMgXy3
         0BXDB4OSnUpXbtYOzlBzdNTVG24/KboHqXUGNDNos7eVWo/iicTtQYDXA2T7/n6TmFBB
         4frMGDtbi1CdLzRDGx/0Z5y+/uzPC22KFgL5sFVdmrqQ9uSLXPZdLi3Xk9NiOULzCASn
         wjhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722597435; x=1723202235;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EzvCbXgl3zCnkI4NQ841vaJDCaDC9jhpiXD5l8QF0TQ=;
        b=m2W+HtIUsFmzGWIaNx18COGnj8tgijUxuLRszST+IbaYO8V0372JxEsTZLgS2O+yfa
         zK5XWJhRO744g97VgdICgtjVMnB/DzSKY9LzrJiX1pCbdZN4TJKOnmNDu8izVYNwWRao
         ZRqB5Y6+ZqX0fUBA3hmVysT/yaX4+WFbENlWdrk/1mLfYYFASYLgLgXcDXO01s8gHxot
         ZXfM9C3uq1IWy87OIAGpZskpHE/rezp/OnRfnYoAIc/SmKERLyj9zQEQdrU7HblAoFZM
         A93h/u49ajsbdQb3rXA3IDaSPmFQMrsuFhODRX3KNGEjZKZ9kbOkH4awv2EdFjv7TVH/
         heoA==
X-Forwarded-Encrypted: i=1; AJvYcCXR3EeCJabKlVihDnVi05HT4vI5PCOHCVdyGKcxcGh3tehY5nUi7Nj7MXV9FGh8tzDd3j/b263jkKrV7+A2AJFqOJuaS+dwOfA=
X-Gm-Message-State: AOJu0YzR0ZnbX2ALaPupFxMrrZ1hu1XncIG8JOpXKdvVPLqzkoo2q0tc
	3CxGKenJs4gFXZmnBAXpuJFo+C34N0TlGkpD34FAiL4tKfXgR7Q8
X-Google-Smtp-Source: AGHT+IH+nW1hh+gYesJx2rbrWpSSKeXwaQvcQK3Hlm16Xb/KnxhFKjQ5fpOaqhLDuc1MjMBRsPbpPQ==
X-Received: by 2002:a2e:824b:0:b0:2ef:2e6b:4105 with SMTP id 38308e7fff4ca-2f15aaf662cmr21961471fa.34.1722597434090;
        Fri, 02 Aug 2024 04:17:14 -0700 (PDT)
Received: from [192.168.42.220] (82-132-220-64.dab.02.net. [82.132.220.64])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4282bab9f7esm87675845e9.21.2024.08.02.04.17.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Aug 2024 04:17:13 -0700 (PDT)
Message-ID: <4404dcee-9479-4340-8b88-bc4554f57fe2@gmail.com>
Date: Fri, 2 Aug 2024 12:17:46 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring: micro optimization of __io_sq_thread()
 condition
To: Olivier Langlois <olivier@trillion01.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <cover.1722374370.git.olivier@trillion01.com>
 <052ca60b5c49e7439e4b8bd33bfab4a09d36d3d6.1722374371.git.olivier@trillion01.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <052ca60b5c49e7439e4b8bd33bfab4a09d36d3d6.1722374371.git.olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 21:56, Olivier Langlois wrote:
> reverse the order of the element evaluation in an if statement.
> 
> for many users that are not using iopoll, the iopoll_list will always
> evaluate to false after having made a memory access whereas to_submit is
> very likely already loaded in a register.

doubt it'd make any difference, but it might be useful if sqpoll
submits requests often enough.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>


> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>   io_uring/sqpoll.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index b3722e5275e7..cc4a25136030 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -176,7 +176,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
>   	if (cap_entries && to_submit > IORING_SQPOLL_CAP_ENTRIES_VALUE)
>   		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;
>   
> -	if (!wq_list_empty(&ctx->iopoll_list) || to_submit) {
> +	if (to_submit || !wq_list_empty(&ctx->iopoll_list)) {
>   		const struct cred *creds = NULL;
>   
>   		if (ctx->sq_creds != current_cred())

-- 
Pavel Begunkov

