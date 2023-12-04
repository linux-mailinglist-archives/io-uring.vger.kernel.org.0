Return-Path: <io-uring+bounces-215-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E470A803C39
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 19:05:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FE7E2810EC
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 18:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14DBD2EAE2;
	Mon,  4 Dec 2023 18:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gYG6PJd/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5A4196
	for <io-uring@vger.kernel.org>; Mon,  4 Dec 2023 10:05:02 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-35d374bebe3so3477625ab.1
        for <io-uring@vger.kernel.org>; Mon, 04 Dec 2023 10:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701713101; x=1702317901; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cT+4YC/mheJocNiFQ9dpjgmB7r6hZL7ROf4mMG+AfOM=;
        b=gYG6PJd/CQ3LpQDi/7e8cQ2DcBM6aO+apn9Fu2tC5ez8R1XfGZt2etZcPSGOGdPtWD
         kk3ygkgr5Zem132psH7/BssIDiytWzeo6QH3Ug7FsI3fDE8FucOWfc2/0hdnwNAfW0+a
         /Lm9QYe3Gg6Y8m7pO194Kb4K7YuEdUqQ4L5G8r1CAFcUFbWn0l1SZYff/J8Vr/hme25Z
         dYSxXfBJDDMiuEFNvMVoa+41JXoNlPF6RS0DTdN0QAFaVTjS5zs9mH5wpt1oT8wslZL/
         AXQd8NBSwuESmmbR0O3ZJ+IIZAZc5kib5S/imnpPabM5eKzjbcIw/KQGxwcQ5lLrLtP9
         vxTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701713101; x=1702317901;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cT+4YC/mheJocNiFQ9dpjgmB7r6hZL7ROf4mMG+AfOM=;
        b=tYpoay+DHnjENAUQsY+7lxZU+NeYklNTptXQaxncKHWhnu/rJC35RPNDRuzHPClO9Y
         2TjOibC8l0ez34tu2YgUSOO5hlnDYHPISvsVANcPoAHotxg8l28hmhI2ij2gYoI03rlm
         pN336xFw/sSv6sM1+JslrQ9GyIY0cneJQotVoXiN4FaQio8rz2qlQlHsEwawyceEMtXa
         KEcSfAFOL3G6VkDYGGeC4m6VbZNZn+IN9LZh1FLLPKx5108bIhaJYEZYuW3HXr3Zkucs
         GohWbYwx2sm9/Py/iIJZv6z2sY2m2gnXAxmxF7BEOMSQoNhaPEzhyuD2jAj6tGtGucEn
         96vA==
X-Gm-Message-State: AOJu0YyO+UAbjYHW8F+V264Xw78NXFryPIxiON9G77OE7wOHsy0/+X6u
	m85nvNN0TZ0e9nU0aZVlGqFnwA==
X-Google-Smtp-Source: AGHT+IEvGG2jQ2QiKm4yVfTLz6F1ahd/oETC2RXWCrCdVtSXGsP78J3QfviDMwPQAkwPVUqdn41Oag==
X-Received: by 2002:a05:6602:489a:b0:7b3:95a4:de9c with SMTP id ee26-20020a056602489a00b007b395a4de9cmr32362013iob.1.1701713101320;
        Mon, 04 Dec 2023 10:05:01 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f1-20020a5ec701000000b007b0684e260dsm2910040iop.2.2023.12.04.10.05.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Dec 2023 10:05:00 -0800 (PST)
Message-ID: <a387fd6a-7d4c-49e0-bb89-be129b10781c@kernel.dk>
Date: Mon, 4 Dec 2023 11:05:00 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
Content-Language: en-US
To: Keith Busch <kbusch@meta.com>, linux-nvme@lists.infradead.org,
 io-uring@vger.kernel.org
Cc: hch@lst.de, sagi@grimberg.me, asml.silence@gmail.com,
 Keith Busch <kbusch@kernel.org>
References: <20231204175342.3418422-1-kbusch@meta.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231204175342.3418422-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/4/23 10:53 AM, Keith Busch wrote:
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 1d254f2c997de..4aa10b64f539e 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3980,6 +3980,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
>  		ctx->syscall_iopoll = 1;
>  
>  	ctx->compat = in_compat_syscall();
> +	ctx->sys_admin = capable(CAP_SYS_ADMIN);
>  	if (!ns_capable_noaudit(&init_user_ns, CAP_IPC_LOCK))
>  		ctx->user = get_uid(current_user());

Hmm, what happens if the app starts as eg root for initialization
purposes and drops caps after? That would have previously have caused
passthrough to fail, but now it will work. Perhaps this is fine, after
all this isn't unusual for eg opening device or doing other init special
work?

In any case, that should definitely be explicitly mentioned in the
commit message for a change like that.

-- 
Jens Axboe


