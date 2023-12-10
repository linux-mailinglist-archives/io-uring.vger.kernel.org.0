Return-Path: <io-uring+bounces-277-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DCA480B84A
	for <lists+io-uring@lfdr.de>; Sun, 10 Dec 2023 02:19:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59EB5280E4A
	for <lists+io-uring@lfdr.de>; Sun, 10 Dec 2023 01:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EDAC7FF;
	Sun, 10 Dec 2023 01:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AhwGuivc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4061AD;
	Sat,  9 Dec 2023 17:19:24 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-40b5155e154so40700795e9.3;
        Sat, 09 Dec 2023 17:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702171163; x=1702775963; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JIukG+kHZWkz6WnXS3CnUnghvu8rJ6d1MjXFbAIVdao=;
        b=AhwGuivcxyuPNFClVCnNJ8rtytcw8FCLNlIzwfX3iwn/ePKCMqa6D+FVyJTOV6Ax0h
         jzltWkxnj1PUbXbu5FOFuDT8I0Rzyi2CdUL060NjeBvYOIWWFlREwobkSQMLPiH5Gbt8
         qC5x+KCJpI8ARyCPanF38pvtOP/03jU/2kXAGi4KdVWm+faAnTrfrwuWAukUptxqyZGK
         eGT5/tqD4cpEJFq766atuam7s6g9e0Czbh2e17etU0dTyV+yayL5zy/tozPU6QNzRKe7
         hvnZiApBynE9vBUdOZEBkDNlOHtGnGK2GoIOmKuHh/pviNvJ5eHredUYBDYWseYUejyX
         luiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702171163; x=1702775963;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JIukG+kHZWkz6WnXS3CnUnghvu8rJ6d1MjXFbAIVdao=;
        b=M59ZP4TXHeqNWUzT1/Xv9MR0iWt6aAajStu21gu165gsQQf5zMETJBYOoFW3DZetTz
         XWUOlJ1atJ+CI+uxyP6BTY8/TlzvGYMfr+lzOGIGmFSY67tqwSmAlL57e2ciXso8B1U2
         pA8qsUdNpLP0NQzqBPee//7Y8ww1MFz2oXBLecQkUQ23aaURDcCzjAKkZY0s3iR9oZEF
         0teCiSzUt+eCb48SbBOTAnccdn2vl2gsV28yQU2seo0Qd2xypXv1PzfZ3QIGhJ6RKOE9
         j2BizbkOarb0sYNSBHkAPNTr9mIfM2y9KeihwssMEw3qODZz175AS8fXhGAMPnnEQz2n
         dlPA==
X-Gm-Message-State: AOJu0YyPdhmSwZ2iU3NCee405WHztyzCEO6EQjDo+k7gZO5ZWmrnkvwg
	BgfllhaJBDqCrZ1saqIyDmI=
X-Google-Smtp-Source: AGHT+IHsDZvZa5MpLIIVvDIjq6SH6ySiprmTG1+tsWXvyd1qgK6nd3ee10ap6JB9XE2KZa87BNQi2Q==
X-Received: by 2002:a05:600c:1da2:b0:40c:3e43:4179 with SMTP id p34-20020a05600c1da200b0040c3e434179mr715334wms.21.1702171162128;
        Sat, 09 Dec 2023 17:19:22 -0800 (PST)
Received: from [192.168.8.100] ([85.255.236.102])
        by smtp.gmail.com with ESMTPSA id l39-20020a05600c1d2700b0040c2c5f5844sm8126454wms.21.2023.12.09.17.19.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Dec 2023 17:19:21 -0800 (PST)
Message-ID: <c60213c2-572f-47cb-ba7c-812de9a8519f@gmail.com>
Date: Sun, 10 Dec 2023 01:18:00 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] io_uring/af_unix: disable sending io_uring over
 sockets
Content-Language: en-US
To: patchwork-bot+netdevbpf@kernel.org
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, jannh@google.com,
 davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org
References: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
 <170215742325.28655.3532464326317595709.git-patchwork-notify@kernel.org>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <170215742325.28655.3532464326317595709.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/23 21:30, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (main)
> by David S. Miller <davem@davemloft.net>:
> 
> On Wed,  6 Dec 2023 13:55:19 +0000 you wrote:
>> File reference cycles have caused lots of problems for io_uring
>> in the past, and it still doesn't work exactly right and races with
>> unix_stream_read_generic(). The safest fix would be to completely
>> disallow sending io_uring files via sockets via SCM_RIGHT, so there
>> are no possible cycles invloving registered files and thus rendering
>> SCM accounting on the io_uring side unnecessary.
>>
>> [...]
> 
> Here is the summary with links:
>    - [RESEND] io_uring/af_unix: disable sending io_uring over sockets
>      https://git.kernel.org/netdev/net/c/69db702c8387

It has already been taken by Jens into the io_uring tree, and a pr
with it was merged by Linus. I think it should be dropped from
the net tree?

-- 
Pavel Begunkov

