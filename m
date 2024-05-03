Return-Path: <io-uring+bounces-1712-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFD238BB34A
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 20:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CC571C20A62
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 18:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4D61586F5;
	Fri,  3 May 2024 18:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZiuTpCTb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2953263C8
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 18:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714761163; cv=none; b=enH4VTWs+nAOKe5CeIlDWsI3OIjc+A1oVMvx5f90ZtJDPrHuyEQ1RPZ1Ic0reSt8919qqmTPiy5FmnFGqodsnwi2KSpSK6ovfc1xACMzwXAYEbfz6nBucUFozEBZTb4E9oFrflFP6XZK54A5QUp02hSRSgbf2x91D915fShQvxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714761163; c=relaxed/simple;
	bh=thQpcx3ofwBl2NapX2E08oLI5uycUtew15h9Dl7Vjx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sp1hQ35ISEoOsXpIXrZigMQyVLqZoKpxlpVrVFzU7/O9gXnvfam9rlKWz2UzQxeeqam/JcEd20k0UK76o65xdDLfPUe0bS+cXN/YJ6d/0coJNDdLB8Tp3aVNCYSG+Inm1jjJ6tCfvOhCa/Io1E7ISTVGYdct4r1O3UXWDSpFc6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZiuTpCTb; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5acf5723325so585eaf.0
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 11:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714761160; x=1715365960; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AuIK4pZtZQgSebm0oMTfA9X2mUf1bKnvaBi7DXNsL8g=;
        b=ZiuTpCTbyyWPxNtz8DYYpWObK+C9VXY3724K6rfuJSnr1SHJcfRGTx4b6ENehDhgH1
         8MXaMS2eAVi1LMg3IhSE8i0iYnqO55AGAWQ3KwlzgWRknHoFdEwy56eJVfstBK5JsTev
         KRy/ITwVf/VYl+OHnm+DLn97+/Ktblsnp47FLjOdI9DDf0VSxv4q6LInoo0jermcBnYU
         8o9kgUyY4kM27hDhl8sZrJTBY3WToiBfjaygoggAVYXLvY0nCLu6i+lD2mCt43G9e2hY
         5/EUxGrgTV3cTXfUvMuEQfOw1SQMNIXDiNSfMRmFbTmcxtMv1Y96Ecs5nfQJmkN6YE2H
         Ng5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714761160; x=1715365960;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AuIK4pZtZQgSebm0oMTfA9X2mUf1bKnvaBi7DXNsL8g=;
        b=Hx/v07qh3RE5gQBttlqOSHU82zPLP64Pb2soF0LZdfQvgiZsJIPdnbx8Ur9SX5Uh5d
         9PG2XiH4P3x6ycZl9i76LuUq0/yy91sJwYE/z4aOO3yzXg+JBviReC/eEOgTAuL6uqG4
         Shpuu3RB4lLEbLiC+zwSOCHFm8aLRRBfIVoXmlHW1TQLN2rUXs+AEU1BFUJqJLnriiJ9
         5zeocPrL0lSUVjaP7Z16cJToVjS5PXF9dbjO8o9gVec6YrCRg96s6Tj9DpB32VeoEa00
         R53n8g1dSvKmbgvqKFOLCAdVtCZM+hZbeAqj3p/J27mBFvkXbjdDaMHZb0PCsOq/uTYB
         rkZA==
X-Forwarded-Encrypted: i=1; AJvYcCUshSDr4NzXRlbyBIsAOSgciGhWDVcozYTJxAwIIGPYkF5l2bjNeSPEhuZid3JyB/FbZ1oFAoOZohhaEiUoykISw7ACzeXWjMQ=
X-Gm-Message-State: AOJu0Yyh+WnoTn9TaGQ9NLX4Cpu1WZ7RhzwjgG8D6JSIZJQ3UvYFffaI
	L4OFRzyY94xoWAk/nPEXk5Y4+6pSei6LuWu/C0d340yK7n4Jk7RLzOz5+Kzneto=
X-Google-Smtp-Source: AGHT+IFKeYOKGgDrM+UpggQYwnhkK46+gkjObUufaM/CkkckVM9hySHo3EPx+BdI0zv/jlzHwFkQIw==
X-Received: by 2002:a05:6359:4c9f:b0:186:865e:e34 with SMTP id kk31-20020a0563594c9f00b00186865e0e34mr3684870rwc.0.1714761160152;
        Fri, 03 May 2024 11:32:40 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id by22-20020a056a02059600b0061cd470b63esm1603302pgb.32.2024.05.03.11.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 May 2024 11:32:39 -0700 (PDT)
Message-ID: <d05aa530-f0f5-4ec2-91ae-b193ae644395@kernel.dk>
Date: Fri, 3 May 2024 12:32:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/io-wq: Use set_bit() and test_bit() at
 worker->flags
To: Breno Leitao <leitao@debian.org>, Pavel Begunkov <asml.silence@gmail.com>
Cc: leit@meta.com, "open list:IO_URING" <io-uring@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20240503173711.2211911-1-leitao@debian.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240503173711.2211911-1-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/3/24 11:37 AM, Breno Leitao wrote:
> Utilize set_bit() and test_bit() on worker->flags within io_uring/io-wq
> to address potential data races.
> 
> The structure io_worker->flags may be accessed through parallel data
> paths, leading to concurrency issues. When KCSAN is enabled, it reveals
> data races occurring in io_worker_handle_work and
> io_wq_activate_free_worker functions.
> 
> 	 BUG: KCSAN: data-race in io_worker_handle_work / io_wq_activate_free_worker
> 	 write to 0xffff8885c4246404 of 4 bytes by task 49071 on cpu 28:
> 	 io_worker_handle_work (io_uring/io-wq.c:434 io_uring/io-wq.c:569)
> 	 io_wq_worker (io_uring/io-wq.c:?)
> <snip>
> 
> 	 read to 0xffff8885c4246404 of 4 bytes by task 49024 on cpu 5:
> 	 io_wq_activate_free_worker (io_uring/io-wq.c:? io_uring/io-wq.c:285)
> 	 io_wq_enqueue (io_uring/io-wq.c:947)
> 	 io_queue_iowq (io_uring/io_uring.c:524)
> 	 io_req_task_submit (io_uring/io_uring.c:1511)
> 	 io_handle_tw_list (io_uring/io_uring.c:1198)
> 
> Line numbers against commit 18daea77cca6 ("Merge tag 'for-linus' of
> git://git.kernel.org/pub/scm/virt/kvm/kvm").
> 
> These races involve writes and reads to the same memory location by
> different tasks running on different CPUs. To mitigate this, refactor
> the code to use atomic operations such as set_bit(), test_bit(), and
> clear_bit() instead of basic "and" and "or" operations. This ensures
> thread-safe manipulation of worker flags.

Looks good, a few comments for v2:

> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index 522196dfb0ff..6712d70d1f18 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -44,7 +44,7 @@ enum {
>   */
>  struct io_worker {
>  	refcount_t ref;
> -	unsigned flags;
> +	unsigned long flags;
>  	struct hlist_nulls_node nulls_node;
>  	struct list_head all_list;
>  	struct task_struct *task;

This now creates a hole in the struct, maybe move 'lock' up after ref so
that it gets filled and the current hole after 'lock' gets removed as
well?

And then I'd renumber the flags, they take bit offsets, not
masks/values. Otherwise it's a bit confusing for someone reading the
code, using masks with test/set bit functions.

-- 
Jens Axboe


