Return-Path: <io-uring+bounces-1431-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31C5889ACF3
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 22:55:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62C301C20924
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 20:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E56381C4;
	Sat,  6 Apr 2024 20:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Et8dZF43"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DED1EA6E
	for <io-uring@vger.kernel.org>; Sat,  6 Apr 2024 20:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712436898; cv=none; b=hui4s0g2qo34pHz89o/hZgoJuoxo5ecDbxCujo4MwFp985VOPb13Q9ifmsnDfpO8TEz1mikcy2RmMFg+Yk/Yof2rCqzU3DS7kgRyUBVfI+SuGZohzewmJM8O8x0gnHURnlZqF/bHxp2ilLAdHLsAQ8u97O9FxlTaambjZdbLE04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712436898; c=relaxed/simple;
	bh=2FyaaKiPSmIv8ebuEXojFHZGLVybe1O1Z+ggoGJE7dY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=X0jamOQapQKVpcLHHLJQkSv6qqyleF5eKMqVAVyj7XPAGTiNQl7Jaey1SeRubQkk0RKsxIhBdKHx5yTYnCfPPNOm3IS9Qti3XXXsrY0QkjDr4Qp6Ra7M4KJbAlNogcegh85BZ7GYIGl8ufaTFcU0IRPkxzj+/ru11QVKpFf8l+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Et8dZF43; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4162b7f18b6so18519765e9.3
        for <io-uring@vger.kernel.org>; Sat, 06 Apr 2024 13:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712436895; x=1713041695; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vHnccp47Gh7nUYZbOdTCVvxGpR16CA4Wv9NI38+nJ/c=;
        b=Et8dZF43SiX+Tw/putCfjLOU/b3GJ9hHXEVV2ubfmwqajCoMZMnK51A3HnyqNl9AZL
         D0pqE0eEfjk19IKnYRFxoDx0gLVClHm2pgFaMZy65cU3nNGKnSb7AYkRJQKszove420I
         YZDF2oTkTKw/K6kodrDrI4BY/TP9BlaQMTb+21omHFnjD84DRJkINBcAdCCAzIYhJ/6F
         G6kF2B7qI7I3xdHdt+7ppxvU0P5H4qToiu/SKOCemiSuFKZV010IcflaBbL1QRkjfwgA
         QC+SLyGHBptr0Tat+yUkmmVGFydvRezMfcmWUoFbJqJa9IesLgVpZQ9LAII+Ib/ZZj4l
         FvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712436895; x=1713041695;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vHnccp47Gh7nUYZbOdTCVvxGpR16CA4Wv9NI38+nJ/c=;
        b=CxsSdVMnzxKcmF+23Gs6jtF/QjKcGpUb3MjDOKbkBqWhHbBTH5SIOzr4fAxUpY4M0G
         qFtjaOfa8KkXL54ylXGd4rIvpQPuTmb10RnHeu7VpHXB9FStirtUdDV8jwlkoszrpOGj
         jut6UwI22PtIcHe3HjHU/EAwpoSwjtqlFguJlOvnHCKnyNDaXjKlgcS+Zb8U8Qbd6GMK
         3XDaNj2BOTVsMTsPmdm5kq2dt0JGu9agy+NcIbPQ5aoSrT3gk1Bz+VbwuG6DgVlM9E3S
         sZ3qmm07katJeznVBhjaxQXhz95ICIldxeDx4/yZbkdmJH2eA7f04ODLzRlsLUaD8/gy
         GQLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFPumcVvndahoUFoDBbPJF4lVb731Xy26aHYNOAzbFrngnz6W8tfcTyndPEBI02yy149MOg0aY7/c+YunsTyR+Tsh0QEQipsg=
X-Gm-Message-State: AOJu0YyoDnKRIW92UbpelgdwPjJY6q+vHpAVNl3DvmLrq1eeOmN6LLXK
	HHhe/4zCnlOAtjYFwwcF3umLgzikppx5gHZNC7qeYOLF75H6RFD1P8cpoXL9
X-Google-Smtp-Source: AGHT+IHyMbWcYWNZpOMZMijE4e7pRp5N+q6rfWVElNBCSdAsFahWgQ8jzeF/PiQ9Vqfd5u3ex474QA==
X-Received: by 2002:a05:600c:4ece:b0:416:3383:227a with SMTP id g14-20020a05600c4ece00b004163383227amr2199585wmq.0.1712436895261;
        Sat, 06 Apr 2024 13:54:55 -0700 (PDT)
Received: from [192.168.42.178] ([85.255.235.79])
        by smtp.gmail.com with ESMTPSA id f14-20020a05600c154e00b0041552dbc539sm7773682wmg.11.2024.04.06.13.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Apr 2024 13:54:55 -0700 (PDT)
Message-ID: <86c8ac48-805b-4cb4-be05-0e3149990ff7@gmail.com>
Date: Sat, 6 Apr 2024 21:54:54 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/17] io_uring: drop ->prep_async()
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240320225750.1769647-1-axboe@kernel.dk>
 <20240320225750.1769647-17-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240320225750.1769647-17-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 22:55, Jens Axboe wrote:
> It's now unused, drop the code related to it. This includes the
> io_issue_defs->manual alloc field.
> 
> While in there, and since ->async_size is now being used a bit more
> frequently and in the issue path, move it to io_issue_defs[].
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
...
> @@ -252,6 +260,7 @@ const struct io_issue_def io_issue_defs[] = {
>   		.ioprio			= 1,
>   		.iopoll			= 1,
>   		.iopoll_queue		= 1,
> +		.async_size		= sizeof(struct io_async_rw),
>   		.prep			= io_prep_write,
>   		.issue			= io_write,
>   	},
> @@ -272,8 +281,9 @@ const struct io_issue_def io_issue_defs[] = {
>   		.pollout		= 1,
>   		.audit_skip		= 1,
>   		.ioprio			= 1,
> -		.manual_alloc		= 1,
> +		.buffer_select		= 1,

This does not belong to this series

>   #if defined(CONFIG_NET)
> +		.async_size		= sizeof(struct io_async_msghdr),
>   		.prep			= io_sendmsg_prep,
>   		.issue			= io_send,
>   #else

-- 
Pavel Begunkov

