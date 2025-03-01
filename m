Return-Path: <io-uring+bounces-6879-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 989FDA4A7A6
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93C3917028E
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 01:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77251101C8;
	Sat,  1 Mar 2025 01:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iK9uMKT1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D919461;
	Sat,  1 Mar 2025 01:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740793554; cv=none; b=QL2GkiCDCWnTc4Eqh6M55h5YE9HQc5ymSq1W4zpuZtxjAZCgyt5dcd/nBoOw2Llhy4hxIYjqV8ptf3Oo+/rCgQNmNpqUwAinkgMZoyXLqOu1MrTmMmFNegMyBV6/G0TB+MXOJy9UHlJnd80090DNA33SVI/800GDk/onI8zHX6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740793554; c=relaxed/simple;
	bh=3TDkV+2SC8MLKusalhQ+6g069yP2i+Xbndn0TmtRGLk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TBF+KmD1eRkal2EI3cmD1GYFkelFMSqQo+HP9ICWWAvSOHhOPWmDHIByPyo6gaZO8aqN24WFIarJ+bo4qncGDsRTc1n7pVNPhG37gkqSeIfr7Vt9/BQKVJZz1aV/7mtujaCDFonX0kKBft6KTVQB4ZDU2YziWrN2O3gB5akZBro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iK9uMKT1; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-abf48293ad0so104802766b.0;
        Fri, 28 Feb 2025 17:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740793551; x=1741398351; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gqZyxdu6NvwN5cQicbg3iM4jvo3YwMEvAbDEez2B+m8=;
        b=iK9uMKT1diBAccYHsC/szD72SkSMPXoCIY5yEsxKNvbOv8stQ80QcMRs8pdG7bUk58
         V9a+NDn9aHh3GG5HFOWTQWfOq2uiMxmVZ5rgdg3chHlQrBuPXLXoGtIos8MQ4u+R8kLW
         jZ2htutd9yH70QoHT4gIvSR1NpRxpE5K2+JBzEftEwrNpVBv+Q2Yy2rxOnrGnMvoHz52
         +P/G9+GO+vut9Snm/cX/y0U8pW80FWGqLgGG7UDoRCBhc2NaVj5qwYtUbx9WMn5Ed3/h
         D+1mhKgzsLzbPw/RABXgE0rOvmwOEcjoa9qDdJzFlDCJONuqZOTEIAGHe35QZ+eTaTZM
         MNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740793551; x=1741398351;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gqZyxdu6NvwN5cQicbg3iM4jvo3YwMEvAbDEez2B+m8=;
        b=Y0geK7XMs8n6CGXbfr/gBlq5JwMd1UAr8/o0Zu4147PGLrTNLB1CYo7L4+UH/DdRwT
         InKwOIogxNe/8aEo/DwujMafQtIuGJiN1JjAtrb/+n3CMS1iJZy/RslR/0F8CaAQWkQg
         G7jbss3r9ePXK36iA2sqNXFZeuyS5KuCro4y48EzD4JD/eMZC5UXwG66NLH4vAQxGJtR
         MrBrAOi+s9SQZBMv3Y7nK9P6frRigMsEGr03+sSnlwHD2wGOemqWkAEFHBbhU/3h4xsA
         SbvSCjIBKFQiqHjM5oUgzPw8iAwUQJOgEbyHVzDbJqj/MpBdZeGRCr9u0TiCu2ef9ava
         jp2g==
X-Forwarded-Encrypted: i=1; AJvYcCVw5pjBOCyf+ALH0m7qgOnuBRg7ByYPZ+OQnjCtejMO852qJQNVjBYopnqD/BlOBK5zBbfTQrXaW6d6xfg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx1w10CuLbdHKmnKf7h/4SxtNaXC0kFybZUKhZuzVkBuIH1fDb
	sD/A89nBmlVhlamNR4yfET7xkEkcoGPKCvAcgPARNRKU6ykYOJ4M
X-Gm-Gg: ASbGncs8aM+rEle4oAuPqYXW04cVMM4cf74t7rUJ+A9s21xWVxZNcVVOzlPcy8MMZtN
	dyjYZcEJ3D4w6jHt0mqDp1q26xADc8yGhCgNlvrEmD5OippSdQzuMO8H2mmaQa/duzBFDtSi/SC
	uXeV/qq9olTqTlfpvo6tJ3FZM6F8Gl3VTdb/N3M9R2IiWbnJYSZol3WxX1lE6syPHaDpj9YGiaD
	5MvHsOZC8p3yReCmPjyey0pCCJBHHF7NnHEGU+lCi2JG8VZkpm/v999YZvvl9MsZMdU3Dcn8bCu
	WWWjHD41o0dfAOAPvEr/V2VvjVLuyX4K8gioH0xl1xcqU54yG0vxtl0=
X-Google-Smtp-Source: AGHT+IG5Mfv6RupWeEFxXVmnzOHffxMoautW2BMU+YRo2ZuUcbZZ42i1X7oc9F9dPx3LMUrjqR4b0Q==
X-Received: by 2002:a17:906:a389:b0:abf:486a:5e0e with SMTP id a640c23a62f3a-abf486a6354mr183904666b.22.1740793550844;
        Fri, 28 Feb 2025 17:45:50 -0800 (PST)
Received: from [192.168.8.100] ([148.252.144.117])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c75e499sm383413266b.149.2025.02.28.17.45.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 17:45:50 -0800 (PST)
Message-ID: <86d5f210-d70f-4854-8ecf-eb771f26685a@gmail.com>
Date: Sat, 1 Mar 2025 01:46:57 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/rsrc: declare io_find_buf_node() in header
 file
To: Caleb Sander Mateos <csander@purestorage.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250301001610.678223-1-csander@purestorage.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250301001610.678223-1-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/25 00:16, Caleb Sander Mateos wrote:
> Declare io_find_buf_node() in io_uring/rsrc.h so it can be called from
> other files.
> 
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>   io_uring/rsrc.c | 4 ++--
>   io_uring/rsrc.h | 2 ++
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 45bfb37bca1e..4c4f57cd77f9 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1066,12 +1066,12 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>   	}
>   
>   	return 0;
>   }
>   
> -static inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
> -						    unsigned issue_flags)

That's a hot path, an extra function call wouldn't be great,
and it's an internal detail as well. Let's better see what we
can do with the nop situation.

btw, don't forget cover letters for series.

-- 
Pavel Begunkov


