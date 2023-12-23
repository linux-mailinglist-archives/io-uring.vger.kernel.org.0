Return-Path: <io-uring+bounces-358-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF6C781D4B7
	for <lists+io-uring@lfdr.de>; Sat, 23 Dec 2023 15:57:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E41AC1F22149
	for <lists+io-uring@lfdr.de>; Sat, 23 Dec 2023 14:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 670E1DF5C;
	Sat, 23 Dec 2023 14:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kvGKTSnD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D703DDB7
	for <io-uring@vger.kernel.org>; Sat, 23 Dec 2023 14:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6d9ab48faeaso14132b3a.1
        for <io-uring@vger.kernel.org>; Sat, 23 Dec 2023 06:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703343411; x=1703948211; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=twjLyd6fbDDXRXuv6tyxwOTBVrROGRFL5uoLTG7ps2s=;
        b=kvGKTSnD8Opz/2dA1IAKquZUYCbZmGhDPUi0XXsQ5zqO+AUqhAOwrPrBOUWNDSb1iH
         SGhzCYVDSepRKGcIXymuYcZSS4Hy5vGtjMrcwRJRTRUiAKSlhoA/kEd9m1FkDDHG9cFb
         Se/RD+bcZAebRMMDqIOKCJ9OhW+c5HZNc9243HisQcJQABdwT99L9VXBGDH8Kpff1ZqW
         CUsJTWcJc2t2lMF31B1iyshNJ9hpZdvNT03qZYXtWd7xvGTCMRxB8Kcjwmv/9KGmoUSC
         pnPlIQmZyRNTLVzikbiskr111/J9OHY+E1fBk6orI1vvSySunjVOrd8mm7Q97QYpCZ4V
         gCdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703343411; x=1703948211;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=twjLyd6fbDDXRXuv6tyxwOTBVrROGRFL5uoLTG7ps2s=;
        b=lGSbEErja4OjyByBb2cRWwjBv3G1boXr+stf8JTkk5PlDLn4tJtp3iqlNvK/twCwHe
         ZQqI3Qg9LN0pKtwQW1CEW3CteM5XfWg9wq6mDUh7EfYFZ+PeTU2vrh2wHPknX72XPe8K
         f69vIUq1Zr+xLHoy+XqnaIhrqWdYVlk2/hCExhscB/CiLPEPEnTAcU2z+sj5+q4j/PLK
         F+PCnDvdTef9YdaXn2tE1sRHrNiNN8o95ts/gGkoIdHg6RthwsYTxDkjtTWI3KFcpGUP
         vKduNaXLhGLydKY3mZ7nISR+N97ZdiBvvtbLxlC5c88Qw5oBW9EBI/EqtJX5DsvjU/1f
         zWXQ==
X-Gm-Message-State: AOJu0YwV+ZaKwhVN57qVoItoOLAE8WNpefiJEy6msyl/F5EM1xsk/IGL
	OkIwrmPfEMz/pVAA8pfNVOsl2qwdu59Bxg==
X-Google-Smtp-Source: AGHT+IHQk9iNK+ea3/1eZ8pPjG1f8DXhnd1Q86DQWykg+xJ9/FR9zyfmA3WtlCIb6zsTMYeuK4Zj6w==
X-Received: by 2002:a05:6a20:e119:b0:195:735a:44c7 with SMTP id kr25-20020a056a20e11900b00195735a44c7mr1551631pzb.2.1703343411437;
        Sat, 23 Dec 2023 06:56:51 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id a2-20020a63d402000000b005c661a432d7sm5002214pgh.75.2023.12.23.06.56.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Dec 2023 06:56:50 -0800 (PST)
Message-ID: <4a2fb88a-6f04-48d6-be9a-b1888abc0ad8@kernel.dk>
Date: Sat, 23 Dec 2023 07:56:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: KMSAN: uninit-value in io_rw_fail
Content-Language: en-US
To: xingwei lee <xrivendell7@gmail.com>
Cc: syzbot+12dde80bf174ac8ae285@syzkaller.appspotmail.com,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 glider@google.com
References: <CABOYnLzhrQ25C_vjthTZZhZCjQrL-HC4=MKmYG0CyoG6hKpbnw@mail.gmail.com>
 <c64745d9-4a85-49c0-9df7-f687b18c2c00@kernel.dk>
 <CABOYnLzKaMLnuAffjwhsYCt3+j-KisSFpX=-EOpfz=KqGR5BAQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CABOYnLzKaMLnuAffjwhsYCt3+j-KisSFpX=-EOpfz=KqGR5BAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/23/23 2:07 AM, xingwei lee wrote:
> with the patch that you provided make a little change to apply to this
> commit: 5254c0cbc92d2a08e75443bdb914f1c4839cdf5a
> 
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 4943d683508b..0c856726b15d 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -589,15 +589,19 @@ static inline int io_rw_prep_async(struct
> io_kiocb *req, int rw)
>       struct iovec *iov;
>       int ret;
> 
> +       iorw->bytes_done = 0;
> +       iorw->free_iovec = NULL;
> +
>       /* submission path, ->uring_lock should already be taken */
>       ret = io_import_iovec(rw, req, &iov, &iorw->s, 0);
>       if (unlikely(ret < 0))
>               return ret;
> 
> -       iorw->bytes_done = 0;
> -       iorw->free_iovec = iov;
> -       if (iov)
> +       if (iov) {
> +               iorw->free_iovec = iov;
>               req->flags |= REQ_F_NEED_CLEANUP;
> +       }
> +
>       return 0;
> }
> 
> since the reproducer is in a loop
> and I ran for about 30 minutes it didn't trigger any issues.
> 
> I hope it helps.

Yep, thanks for testing!

-- 
Jens Axboe


