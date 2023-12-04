Return-Path: <io-uring+bounces-216-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66774803C8C
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 19:15:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE767B20586
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 18:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9514E2EAEC;
	Mon,  4 Dec 2023 18:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AurXVlax"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D87AAA
	for <io-uring@vger.kernel.org>; Mon,  4 Dec 2023 10:15:10 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-35d7341be5cso1138395ab.1
        for <io-uring@vger.kernel.org>; Mon, 04 Dec 2023 10:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701713709; x=1702318509; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hNAeyzY5pc7VMUm+A7dLwdlpqS3anz6F45PtdHvureU=;
        b=AurXVlaxJCGU+WWIS37u43+UksYQFaNDSo30KIfbYrXuhWATrw0ShT/4OTj+ZM/9WB
         UOjvStX/LxO7lXiWmtLHANytyR0oXqiKIz4J2tp9sd0maVMCdGvKys94IIir3r/lkm35
         Eky/0V/bEW92pWO53rcsS/qptignr01DH9MPH6RRO3qCyBLLOkO6We/PoNSDyUB8AsJK
         QUjUDB0TDER0zTXDPiN3ee8IAFgGDhREsZJSDef9iAsrv2eo6Xm0FMUKy8BrC7zd1rrr
         wIyRcjAtld35RrjgJeCMoY0WaLI+WvJShQHByUmSTQ4OP5YAnK8foum2tIA7D2qDcmeA
         W42w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701713709; x=1702318509;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hNAeyzY5pc7VMUm+A7dLwdlpqS3anz6F45PtdHvureU=;
        b=f0t5NldyNXqbz+JcZcwiaNaFNDR/iOwkLtmLeMJ63lZemrx3CR5umeh5MszFIZDFUa
         MvOly1YaER4HTqqpryg6i0RG4sWDFDdGxY3cINBs8SoTiExQRdphKbQyys3jWTUOtGRt
         XhXGZi/gW/wPre/VM7qiPSw3C1kjp/Ol6R9LTFqMjmaycDoWGcC8xoVivc6R/urvxFIw
         MYUxBDKMNlHrHyzZf0QbHuqSxZu8tUWHN5k8vM2/Tc/xa3Z3AMMoH/9G1QqcfnhG5o7f
         8K8Cu/iwCLhdI3Edx/OgkIQDPlX5Rp0K+9NsfB8pc3iVLES6TZnWPKm7+Ts1GweGrzqN
         xynw==
X-Gm-Message-State: AOJu0Yye3TQ1eQNaNqYrzEgyk3JVKiYScvke822mujSdBESxrXLK0vgr
	vWlB0TuV/v2h5IcABAVjvk8R3g==
X-Google-Smtp-Source: AGHT+IHpRAm6dzCfsDsfv5H9dsyqYlB3DU0GyLqs0l9tJFjoO/C/Yio27CPRFQOcl8QHSiSxkYQ/Gw==
X-Received: by 2002:a92:dcc8:0:b0:35c:ac42:f9a4 with SMTP id b8-20020a92dcc8000000b0035cac42f9a4mr24092773ilr.1.1701713709521;
        Mon, 04 Dec 2023 10:15:09 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t16-20020a92c910000000b0035d714a68fbsm40151ilp.78.2023.12.04.10.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Dec 2023 10:15:08 -0800 (PST)
Message-ID: <3fbd675b-78a8-4182-8afd-10f2bd15c7b5@kernel.dk>
Date: Mon, 4 Dec 2023 11:15:08 -0700
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
>  
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 8a38b9f75d841..764f0e004aa00 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -164,6 +164,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>  		issue_flags |= IO_URING_F_CQE32;
>  	if (ctx->compat)
>  		issue_flags |= IO_URING_F_COMPAT;
> +	if (ctx->sys_admin)
> +		issue_flags |= IO_URING_F_SYS_ADMIN;
>  	if (ctx->flags & IORING_SETUP_IOPOLL) {
>  		if (!file->f_op->uring_cmd_iopoll)
>  			return -EOPNOTSUPP;

Since we know have two flags that would be cached from init time, rather
than add a second branch for this, why not have:

io_uring_create()
{
	[...]
	if (in_compat_syscall())
		ctx->issue_flags |= IO_URING_F_COMPAT;
	if (capable(CAP_SYS_ADMIN))
		ctx->issue_flags |= IO_URING_F_SYS_ADMIN;
	[...]
}

and get rid of ->compat and ->sys_admin, and then have:

io_uring_cmd()
{
	issue_flags |= ctx->issue_flags;
}

Then we can also drop checking for IORING_SETUP_SQE128/CQE32 as well,
dropping two more fast path branches.

-- 
Jens Axboe


