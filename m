Return-Path: <io-uring+bounces-7631-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5427BA972CF
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 18:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82B0C17AF1A
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D32C290BDE;
	Tue, 22 Apr 2025 16:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JJ+ErcEa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB851E51FA
	for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 16:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745339559; cv=none; b=EhDAYS8KAUSD7YZZq83jVToGfYif6yV8vVpbFTm9z/yjMkDaLOV+Dm7skNbvLAag74eeqyevoNkriG3Lawo3eDAxXGtiKVmnPGgqQcWU/0uV9mJS2ErGS49W9K8NEgQCvVEsX16ZGctF6x5D914ntdm24d9RStL0jgWx/N+joSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745339559; c=relaxed/simple;
	bh=Hc/a/N/czd1QJv27rjO3dbrnoqAvSzODqlF6TDvG0Ho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gG+6pNzZBSy1c356E4OQBTsiIkoRylCyJMgqErQIUdQ/FZKUXIDxRkgxaeaw69/MFa/eVO0oeOjcanG4BsEnlyZEuoFL1VgHFfgCNhU148AW+xlBjCQAIj8KZ+X9XRKZC1LdT4Bhq84MVXSIon09x+bxTD0txdsmPCQUUm03EQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JJ+ErcEa; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3d7f11295f6so18747105ab.3
        for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 09:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745339556; x=1745944356; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BI9KG26m9xjN9k6dbGw+O0NB/svh8sdwPuBKvebFKKY=;
        b=JJ+ErcEacJcnmCKKdBqYjTgPYOlb3oEIuQYoXzfTrgWjxvznzuKQcZUY89gbNVAV0X
         UStMCUWyEW3CEgXcAkoqxSmOpCO+7JeaSdxMSGFsQpYZwov2gzFuKcBN/IL1yDQQ02ve
         IZSOE+/ssGWpFUhAXojMGNsNpQJUSt8Nlnh2uWOP8fpMFG393SnFoT6N4RmTMPqCJohJ
         oVyIwc7LB1DBrmKXcVY9LR4YJhiNDTkbYBiVwCUaSTXlQ4gqZAdABvedekgKpx5D3PgX
         bWyBKrXzloQQ6379aFoDGBNoDkAaKDRKyVYR+Zm3mSPOlfMaKyBghGOGS3SZoCFGfHzs
         TRhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745339556; x=1745944356;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BI9KG26m9xjN9k6dbGw+O0NB/svh8sdwPuBKvebFKKY=;
        b=OrUKjSsH+W4bCetXArVFPn5qBAtDVBwqpER9GSbSK0lT48ceJ4WhJ2hYQ5p6Oo/vwf
         2iiHx7mnm4bzu/KGoY1KMlEn0iUr6w+7XM56fTOXRKCZVQ8sko78HvHj1NMgEzDSJwgi
         liVIAFfp0M7pOA8m/aO8k265QJlqlCxozLVYsikR4xjtD4n61mJDcZL4oGRqu3WMavR2
         7b8gCkdfmWZcRfVk3uZbKFMTmuynhpYKhOMjbceze1d3wpqmlpVAShxWuS0t0iQcguvz
         wqvaAlejh7q94RMzXWRQel1rHeXa5Uly0LuIHi5I//vtg7M/L/AdMVI8lvfsz0w/L4s7
         276w==
X-Forwarded-Encrypted: i=1; AJvYcCXMwxneWjIuSXV6LF/AVKh/T9ANxtSqQe98O1uI+xZKyWOJqmykLoQIhAW0Zi85filJs+YO7VJjFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHiaTsQdRANwjNrhfQ1j/9X4BwwsI40zrV2qwboZe0ey3iVqMo
	2Vy9udc5guU6/iGpzrntkGh0kAaNaz2uZPa0JDw+HX7/K2nIFG02PxCOZkrcmIs=
X-Gm-Gg: ASbGncsfWpmxgbjjZz3INVNxrMUvO5xY/EoEK3aj6qPVb4nmRxni3vhoLMuD4T6bPHT
	KfjNFh20PnwG5Uedl2SgwtpDw1MAEf/2AgzACdCShIrMRtQ+mnVhUWMHU8GDQIsAHk7nryWSCWr
	Ac3wOG24ATeewIW7LJJ0LD+tgd/6674RgUfcXJi9+pcE8ybFkZGQxxtJ2vNuteYNmtLJX99aE5s
	j6a+QpzVdXX69SB8fOcgiLqdxS9hwtilFy329F6uUh6v34heACre+C8mJHy/w+SoU3TJGDFSFBd
	6PSc6DgBGja/GWsZ/04D8QIDbbqHiIfiih+JjA==
X-Google-Smtp-Source: AGHT+IGFUtqoZyoWSfs3yKraYI/uOz+4B4kDE1UUkceCkMGC1DfmqmAIi/faS6XWXrDcN0tXD6ot6Q==
X-Received: by 2002:a92:cda5:0:b0:3d8:1d7c:e190 with SMTP id e9e14a558f8ab-3d88ed79da8mr170240475ab.7.1745339556060;
        Tue, 22 Apr 2025 09:32:36 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d821d1d7casm23248195ab.10.2025.04.22.09.32.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 09:32:35 -0700 (PDT)
Message-ID: <14195206-47b1-4483-996d-3315aa7c33aa@kernel.dk>
Date: Tue, 22 Apr 2025 10:32:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault
 scenarios
To: Zhiwei Jiang <qq282012236@gmail.com>, viro@zeniv.linux.org.uk
Cc: brauner@kernel.org, jack@suse.cz, akpm@linux-foundation.org,
 peterx@redhat.com, asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20250422162913.1242057-1-qq282012236@gmail.com>
 <20250422162913.1242057-2-qq282012236@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250422162913.1242057-2-qq282012236@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/22/25 10:29 AM, Zhiwei Jiang wrote:
> diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
> index d4fb2940e435..8567a9c819db 100644
> --- a/io_uring/io-wq.h
> +++ b/io_uring/io-wq.h
> @@ -70,8 +70,10 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
>  					void *data, bool cancel_all);
>  
>  #if defined(CONFIG_IO_WQ)
> -extern void io_wq_worker_sleeping(struct task_struct *);
> -extern void io_wq_worker_running(struct task_struct *);
> +extern void io_wq_worker_sleeping(struct task_struct *tsk);
> +extern void io_wq_worker_running(struct task_struct *tsk);
> +extern void set_userfault_flag_for_ioworker(void);
> +extern void clear_userfault_flag_for_ioworker(void);
>  #else
>  static inline void io_wq_worker_sleeping(struct task_struct *tsk)
>  {
> @@ -79,6 +81,12 @@ static inline void io_wq_worker_sleeping(struct task_struct *tsk)
>  static inline void io_wq_worker_running(struct task_struct *tsk)
>  {
>  }
> +static inline void set_userfault_flag_for_ioworker(void)
> +{
> +}
> +static inline void clear_userfault_flag_for_ioworker(void)
> +{
> +}
>  #endif
>  
>  static inline bool io_wq_current_is_worker(void)

This should go in include/linux/io_uring.h and then userfaultfd would
not have to include io_uring private headers.

But that's beside the point, like I said we still need to get to the
bottom of what is going on here first, rather than try and paper around
it. So please don't post more versions of this before we have that
understanding.

See previous emails on 6.8 and other kernel versions.

-- 
Jens Axboe

