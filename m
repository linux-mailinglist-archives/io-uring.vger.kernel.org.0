Return-Path: <io-uring+bounces-4389-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F271C9BA9F4
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 01:28:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 25695B20C0B
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 00:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D976FC5;
	Mon,  4 Nov 2024 00:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GYY6Mj24"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8A023A6;
	Mon,  4 Nov 2024 00:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730680114; cv=none; b=IRONwVoVsnzK4vL1KH3U+0GlkK8c7vaxnGCa4epD9a+nn9y3KTUhP2zx0w1zZdj/OUq5fj+Oid+1dPgC4pDwX9wKQLqg9/HxQ8glbIZmMxmA+uI/hShKzGUkCMWanlV36OE30AoaJ3nL008iVruECw4GAaLVHsAkbUvLbNDnRRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730680114; c=relaxed/simple;
	bh=pDflJAvLfnizQqLP0xc7e9K5i/Vmz7PawEvaq78Fwqk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qgF6CEz35wazN/8U49DFdsFAx4i+upiEHkvvBfwTUB9syRdOelAOpQWZA/VT+OU54FENhjkb03ruhA484ktR9AxRhFj/2M2hXoP4CmN1gdzQkv0Y0rkHWO4kSoL4hIF9DLS79IBTCxfc1dZpnb5USyLjH6PO5UZUae2GDw7364I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GYY6Mj24; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4314c452180so27305045e9.0;
        Sun, 03 Nov 2024 16:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730680111; x=1731284911; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hBEyHBCATHVozUkykaf5BcBcJxSSLx7yvPj8ZCt9BiQ=;
        b=GYY6Mj24f4ue1TVkbVv99e/qpUaupvN5pUctbjnNlcSUvnR54Fxa1jLfD5jttwnmbR
         wTTY0ryTE86q9MV5ttooHpYoO70roxZeohuG+6C7l+fgr5Ogw6S1P3Iej7le1lSdWect
         wDC2Bc32eZECQGvwuwgBeap57XnTCF+tthiY6S1zMwc3qQxuC8XLLwN9oAU8hI7V+OrG
         SqTs3hFWafaGf5NLjbQgn2IKQX5nMBaHltgz/WERGD0Z1fukSJrvasbir+OFurSZtzgA
         gPm7ere5aAgDH9b9gTlr44J+QF2qOQIpg+fycegiNfnw/1BdMF3vlSEQQlSsKs0AVkhe
         Fr/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730680111; x=1731284911;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hBEyHBCATHVozUkykaf5BcBcJxSSLx7yvPj8ZCt9BiQ=;
        b=a5/PR5nZuSWr+fGm/T3t/cxiPkYn4s16GDfGnpbCgQBQeScFc7jBkIycTcIYbBFYJt
         sLO0uG5P/+U0+SXUFsSDNJnxgEYgYlPwDQ3NSTOwDVLy6Xtdjghr3jsjmxHxzT9qoKzG
         6Ylj/2KASEhi3GEv0p6C2Uj0fO+a3IyhF6l55pcnhONPh2N2Zh0jBGVrulI47ArZ1KRB
         SCaV/y+nT+YjT4GjFG5PF189IJ3LWqbN57Me76jXudJrVzHMSIB5b1lcbz4WJQl10uDM
         ObiLiQLr4pSWfsNCNsR1oIUjkNnMi4zXtNRBdJaRLI7qCxxDOO3D3lpmpJnG0+IvMpnu
         mccg==
X-Forwarded-Encrypted: i=1; AJvYcCVg7X7zMSCTwe2sM9DupSVOiwQVG5I2sh9JyNUrXr4lJVCyP+k74T9qDEYunU2XSmE4cECf0fzzgw==@vger.kernel.org, AJvYcCVtFkjkzWsosBmbA0zytCoqO5ySu0BaWpDqrJQKgjXukQyz9C6EXrtMO+kqjScjs8bgXPKh9Vl33jLOhvsLEA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg/3xRn4r7vQNfeBSxe2fi+AAPLsWn9NLa6u/umEr33ULq40zg
	C/IzfH3Qm2MA2M6+YiCXvy9e6JDr5yml4QFOGhZISi46AJEOG7r8
X-Google-Smtp-Source: AGHT+IGL9/bevJFdpw7GkGJU16YdaQZDjEHQoz/uXVculEBqUxl124E9x+ImSs+eaWzTPwQv2mVO6A==
X-Received: by 2002:a05:6000:718:b0:37c:f561:1130 with SMTP id ffacd0b85a97d-381c149f129mr10457923f8f.18.1730680111248;
        Sun, 03 Nov 2024 16:28:31 -0800 (PST)
Received: from [192.168.42.207] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10d4991sm11813991f8f.29.2024.11.03.16.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 16:28:30 -0800 (PST)
Message-ID: <b4e388fe-4986-4ce7-b696-31f2d725cf1c@gmail.com>
Date: Mon, 4 Nov 2024 00:28:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 12/15] io_uring/cmd: let cmds to know about dying
 task
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c753666e@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c753666e@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/24 01:05, Bernd Schubert wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> When the taks that submitted a request is dying, a task work for that
> request might get run by a kernel thread or even worse by a half
> dismantled task. We can't just cancel the task work without running the
> callback as the cmd might need to do some clean up, so pass a flag
> instead. If set, it's not safe to access any task resources and the
> callback is expected to cancel the cmd ASAP.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   include/linux/io_uring_types.h | 1 +
>   io_uring/uring_cmd.c           | 6 +++++-
>   2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 7abdc09271245ff7de3fb9a905ca78b7561e37eb..869a81c63e4970576155043fce7fe656293d7f58 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -37,6 +37,7 @@ enum io_uring_cmd_flags {
>   	/* set when uring wants to cancel a previously issued command */
>   	IO_URING_F_CANCEL		= (1 << 11),
>   	IO_URING_F_COMPAT		= (1 << 12),
> +	IO_URING_F_TASK_DEAD		= (1 << 13),
>   };
>   
>   struct io_wq_work_node {
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 21ac5fb2d5f087e1174d5c94815d580972db6e3f..82c6001cc0696bbcbebb92153e1461f2a9aeebc3 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -119,9 +119,13 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
>   static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>   {
>   	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
> +	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
> +
> +	if (req->task != current)
> +		flags |= IO_URING_F_TASK_DEAD;

Bernd, please don't change patches under my name without any
notice. This check is wrong, just stick to the original

https://lore.kernel.org/io-uring/d2528a1c-3d7c-4124-953c-02e8e415529e@gmail.com/

In general if you need to change something, either stick your
name, so that I know it might be a derivative, or reflect it in
the commit message, e.g.

Signed-off-by: initial author
[Person 2: changed this and that]
Signed-off-by: person 2

Also, a quick note that btrfs also need the patch, so it'll likely
get queued via either io_uring or btrfs trees for next.

>   	/* task_work executor checks the deffered list completion */
> -	ioucmd->task_work_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);
> +	ioucmd->task_work_cb(ioucmd, flags);
>   }
>   
>   void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
> 

-- 
Pavel Begunkov

