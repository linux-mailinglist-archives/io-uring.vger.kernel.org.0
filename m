Return-Path: <io-uring+bounces-78-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5E87E6AFD
	for <lists+io-uring@lfdr.de>; Thu,  9 Nov 2023 14:08:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43CE31F217D4
	for <lists+io-uring@lfdr.de>; Thu,  9 Nov 2023 13:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6D312E76;
	Thu,  9 Nov 2023 13:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OCli+W5z"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CF21944C
	for <io-uring@vger.kernel.org>; Thu,  9 Nov 2023 13:08:16 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EDB1720
	for <io-uring@vger.kernel.org>; Thu,  9 Nov 2023 05:08:16 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-53e08b60febso1331953a12.1
        for <io-uring@vger.kernel.org>; Thu, 09 Nov 2023 05:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699535295; x=1700140095; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/0zQRCCN9zQpWRrvhYXkgDuv1qxtr5Uv4eFQMmsfzLw=;
        b=OCli+W5zxb5h2NY8+ipG4vD7ZFK8woTRYffL61G+AAbA9bV4vMwss404zeYTgd/ZAj
         TZxh/t38bUD6scA8tVmfW/E+6wTbzFR7c0aYUG+NouUQ6H9xPP5Wt/irZJ3wd3BHv/Az
         E3v7UxGKX+mvD/gn1PxERHlckuobDplkvZR7aPk7PBmuohsC6YrNYPEhAV2+K4WDX1Ca
         /PoU8k5pFkExcIQUuP2+bKzjiq+QmuyXX8lbPsq+yoC7D4zHEgvRSHxenX3K1YsLoyHW
         kYDKxtuNmmqlBET/FGcyHDOhhT6aBrh+txeXrlXjo+OPNRG905DOrUVVhOVGXLAJhf0N
         /+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699535295; x=1700140095;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/0zQRCCN9zQpWRrvhYXkgDuv1qxtr5Uv4eFQMmsfzLw=;
        b=Ku64hckiLGsJkGUJ8AijHCwcJ7P7UHX0Ni7fo1wEOUBjT+uS48FhaDbmhmsZA7daSx
         1ObkTWUqrC/rg3ohtnx53tQx4X7dl3L3qQlL8dUne/EClb39OrRED/angmOnptWDLAxu
         LrbMw3xSTtVeYgbKjPTlnr3JHGG5LwU4gi8oGnT3n2LJtIy6xu4FQNPlLCIuc2qwwW+e
         miHWN1hsX6yvcLoOluRlbpW7oRq0E8w0dSEpn/FJBmlpcVMk/ck6P0GDn61x00ZBD93A
         /joO5jqXiyf6SAY8fAST95xJzZiKbE46UdRenLV1Qqqo/adwIUf+fS0LHrnQJ6hdhcnf
         L7Ww==
X-Gm-Message-State: AOJu0Yz2Mp91jsqoF9sHDx+itBt3x9K16YR0hu9vlosw6Vv58lu3y8Nh
	y3XIxHXE8NW7ovIOX9fqk3xUuUSjg3A=
X-Google-Smtp-Source: AGHT+IHp0wjItiiwqeqNt3UsQC0/Y9BGzh9IgBTlO59vQs/uiuuGCveA99oA9X30JbRuhpDk5BxAkA==
X-Received: by 2002:a50:d54e:0:b0:540:bf39:bf72 with SMTP id f14-20020a50d54e000000b00540bf39bf72mr3955070edj.25.1699535294235;
        Thu, 09 Nov 2023 05:08:14 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:7ea6])
        by smtp.gmail.com with ESMTPSA id u17-20020a50c2d1000000b00530bc7cf377sm8229563edf.12.2023.11.09.05.08.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Nov 2023 05:08:14 -0800 (PST)
Message-ID: <afbf1ca8-5586-9abe-931b-25b0bb661e67@gmail.com>
Date: Thu, 9 Nov 2023 13:07:03 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: use IOU_F_TWQ_LAZY_WAKE for wakeups
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <e6bcdcb4-8a3d-48a1-8301-623cd30430e6@kernel.dk>
 <55fe5c04-f3c2-5d39-0ff3-e086bf4a13cc@gmail.com>
 <faa79714-a894-4f19-b798-176e12fbf96f@kernel.dk>
 <bc86e6cf-1c15-466b-a4f9-074af944d7da@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bc86e6cf-1c15-466b-a4f9-074af944d7da@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/23 16:14, Jens Axboe wrote:
> In the spirit of getting some closure/progress on this, how about this
> for starters? Disables lazy wake for poll_exclusive, and provides a flag
> that can otherwise be set to disable it as well.

I'm not that concerned about the non-multishot accept case specifically,
if anything we can let it slide by saying that backlog=1 is unreasonable
there.

A bigger problem is that for the purpose of counting nr_wait passed into
the waiting syscall, users must never assume that a multishot request
can produce more than 1 completion.

For example this is not allowed:

queue_multishot_{rcv,accept}();
cq_wait(2);

So we can just leave the enablement patch alone and say it's the only
reasonable behaviour, and it was the indented way from the beginning
(hoping nobody will complain about it). Or do it via a flag, perhaps
SETUP_*.

For the multishot part I described the rules above. As for the problem
in general, it come from interdependecies b/w requests, so the rule is
the vague "there should be no deps b/w requests", but I'm not sure we
can spell at the moment the precise semantics.


> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index d3009d56af0b..03401c6ce5bb 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -431,6 +431,7 @@ enum {
>   	/* keep async read/write and isreg together and in order */
>   	REQ_F_SUPPORT_NOWAIT_BIT,
>   	REQ_F_ISREG_BIT,
> +	REQ_F_POLL_NO_LAZY_BIT,
>   
>   	/* not a real bit, just to check we're not overflowing the space */
>   	__REQ_F_LAST_BIT,
> @@ -498,6 +499,8 @@ enum {
>   	REQ_F_CLEAR_POLLIN	= BIT(REQ_F_CLEAR_POLLIN_BIT),
>   	/* hashed into ->cancel_hash_locked, protected by ->uring_lock */
>   	REQ_F_HASH_LOCKED	= BIT(REQ_F_HASH_LOCKED_BIT),
> +	/* don't use lazy poll wake for this request */
> +	REQ_F_POLL_NO_LAZY	= BIT(REQ_F_POLL_NO_LAZY_BIT),
>   };
>   
>   typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index d38d05edb4fa..4fed5514c379 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -366,11 +366,16 @@ void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts)
>   
>   static void __io_poll_execute(struct io_kiocb *req, int mask)
>   {
> +	unsigned flags = 0;
> +

Why flag when you can just check the exclusive flag
in the poll entry?

>   	io_req_set_res(req, mask, 0);
>   	req->io_task_work.func = io_poll_task_func;
>   
>   	trace_io_uring_task_add(req, mask);
> -	__io_req_task_work_add(req, IOU_F_TWQ_LAZY_WAKE);
> +
> +	if (!(req->flags & REQ_F_POLL_NO_LAZY))
> +		flags = IOU_F_TWQ_LAZY_WAKE;
> +	__io_req_task_work_add(req, flags);
>   }
>   

-- 
Pavel Begunkov

