Return-Path: <io-uring+bounces-3996-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EEF79AEE1D
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:32:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DBC128167C
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD911FC7F2;
	Thu, 24 Oct 2024 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Y1YS+N2M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65CB1EF958
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 17:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729791116; cv=none; b=QwrgQJJgL499DQmHm2ZLd8smrN5uqqCEbO5ZLl+lDZPUsNr/kDRLZk6WnFHrqaXo1uTaeRsSq0GbMZRqvZ0UlmV2eBJ/egS1PDRUKjl/0WZLw5wZpAgE7G/iecR3VxM1LPJND2EPf0pnIzcfmc7izlhMEblgmor0rYiNOdQUxt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729791116; c=relaxed/simple;
	bh=/vyLHY055+1cvn/Kx+/k810xY2Ool6vLXTmvYV5Mvc0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=l6u+yYuh8rjGyiV7GGWdPo/YXrrS03FH6ywjolZcQoia0OlOO9sBX7GGL7FiJUQx/wnI6Dg3jdC5zxWKEpS9IYT5KMCHq4La7m+gJUZKMtX6vY7mJ5yc6pXSvJvtOlnu379I8XcigvxVOwhc0DfJ1FwZU68WK6azO+FL/pLHqW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Y1YS+N2M; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3a3f8b5fc45so7056145ab.1
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 10:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729791111; x=1730395911; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Pa6gpmWAle+NDMRABpgJWn4vH/Z/s4i72LM5tOhcicU=;
        b=Y1YS+N2Mtw6PdnqkWhjqoLEUjf7jhzdnxgeXmZRD3FPZwV4ug9jCebCP7U6v1PjrIu
         BTkbXHQ4PtA1qU7IHtZEzEANSBEwkYFmT8eZubBBw2XgPlp7Lmbm0OkY/FaagNOA+QwT
         OA1EXCozeMXC2OXpQX6tObYzgmlESsVySwIrzYxk5P5XQM+MAUSenaP2aMFcddjbHwPt
         huTtMcIupktayLMbzA/c/MZ81ocpT9KGV7Y0vKq0eAuNsmkA9r/S5uDpCPHOa3dW6uKi
         LoPA8oiT1RbPYnqFYTzfoITeTVN+exby751ENNt2Khbj42D1cf8LTy9Db3C6FJ/clbBK
         N2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729791111; x=1730395911;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pa6gpmWAle+NDMRABpgJWn4vH/Z/s4i72LM5tOhcicU=;
        b=X1XLX4bPH31KZNmxRvpwkoou85Nhkq9vBS8YOK86Or+yLAvJ6GCGJbNJc9DrLAts47
         efyF+mzCK4A6kr9L1r2FRHonnIjNjm/jUBdNIDzFYpQ1WajUKanZKZdfOuuPHvLCWaAV
         plozGxNc8/dmC9wnA1Arup5pBnZjvWqLFLSQpsy09HiyiCfGwiyiA27SN/2wBD50xB+i
         BQ4lijD7Q+YdvT5qdqSwpOIZAaMSKpzl9vhi8CuEzs4bh9tKnLJMY+TYtDcdrxSjJ4wg
         cGPGJiWvuP9pcwN0PcJL1LECUigMzm68E6mIE0njdA64+5w+xuGRU/n7v8L+ZcMmXQJ/
         c8HQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKX5LYFnvP+IK6/j6ux1c4NQGdYnw+17RHRn6E1U1Op2iU2G0lvAr4KuBoLjZRpxrMxgUps2bIdA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDiX6sBlHsSRGgIwxDnu54hL/FCsWwIpGb6YGWE/j7SjR0kbXJ
	KWWdM2C8wRl/TPfiA5xERI9zozcBCcm93vzwWHXtZey4zOmjnTSt9K2fmrwSYks=
X-Google-Smtp-Source: AGHT+IFoJPyc93FfOcCuKyRHDolqmsF5n909q/bZwVA/cgkDKJKx9rhaQM1CN/Ct5+qtW26+8mdXew==
X-Received: by 2002:a05:6e02:20c8:b0:39d:3c87:1435 with SMTP id e9e14a558f8ab-3a4de6f6b3dmr22700555ab.1.1729791110859;
        Thu, 24 Oct 2024 10:31:50 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a557294sm2793140173.45.2024.10.24.10.31.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 10:31:49 -0700 (PDT)
Message-ID: <5d288a05-c3c8-450a-9e25-abac89eb0951@kernel.dk>
Date: Thu, 24 Oct 2024 11:31:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 RESEND] io_uring/fdinfo: add timeout_list to fdinfo
To: Ruyi Zhang <ruyi.zhang@samsung.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, peiwei.li@samsung.com, ruyi.zhang@samsung.com
References: <CGME20241012091032epcas5p2dec0e3db5a72854f4566b251791b84ad@epcas5p2.samsung.com>
 <e8d1f8e8-abd9-4e4b-aa55-d8444794f55a@gmail.com>
 <20241012091026.1824-1-ruyi.zhang@samsung.com>
Content-Language: en-US
In-Reply-To: <20241012091026.1824-1-ruyi.zhang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Sat, Oct 12, 2024 at 3:30?AM Ruyi Zhang <ruyi.zhang@samsung.com> wrote:
>
> ---
> On 2024-10-10 15:35 Pavel Begunkov wrote:
> >> Two questions:
> >>
> >> 1. I agree with you, we shouldn't walk a potentially very
> >> long list under spinlock. but i can't find any other way
> >> to get all the timeout
>
> > If only it's just under the spin, but with disabled irqs...
>
> >> information than to walk the timeout_list. Do you have any
> >> good ideas?
>
> > In the long run it'd be great to replace the spinlock
> > with a mutex, i.e. just ->uring_lock, but that would might be
> > a bit involving as need to move handling to the task context.
>
>  Yes, it makes more sense to replace spin_lock, but that would
>  require other related logic to be modified, and I don't think
>  it's wise to do that for the sake of a piece of debugging
>  information.
>
> >> 2. I also agree seq_printf heavier, if we use
> >> seq_put_decimal_ull and seq_puts to concatenate strings,
> >> I haven't tested whether it's more efficient or not, but
> >> the code is certainly not as readable as the former. It's
> >> also possible that I don't fully understand what you mean
> >> and want to hear your opinion.
>
> > I don't think there is any difference, it'd be a matter of
> > doubling the number of in flight timeouts to achieve same
> > timings. Tell me, do you really have a good case where you
> > need that (pretty verbose)? Why not drgn / bpftrace it out
> > of the kernel instead?
>
>  Of course, this information is available through existing tools.
>  But I think that most of the io_uring metadata has been exported
>  from the fdinfo file, and the purpose of adding the timeout
>  information is the same as before, easier to use. This way,
>  I don't have to write additional scripts to get all kinds of data.
>
>  And as far as I know, the io_uring_show_fdinfo function is
>  only called once when the user is viewing the
>  /proc/xxx/fdinfo/x file once. I don't think we normally need to
>  look at this file as often, and only look at it when the program
>  is abnormal, and the timeout_list is very long in the extreme case,
>  so I think the performance impact of adding this code is limited.

I do think it's useful, sometimes the only thing you have to poke at
after-the-fact is the fdinfo information. At the same time, would it be
more useful to dump _some_ of the info, even if we can't get all of it?
Would not be too hard to just stop dumping if need_resched() is set, and
even note that - you can always retry, as this info is generally grabbed
from the console anyway, not programmatically. That avoids the worst
possible scenario, which is a malicious setup with a shit ton of pending
timers, while still allowing it to be useful for a normal setup. And
this patch could just do that, rather than attempt to re-architect how
the timers are tracked and which locking it uses.

-- 
Jens Axboe


