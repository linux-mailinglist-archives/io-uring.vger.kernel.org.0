Return-Path: <io-uring+bounces-10700-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EB8CFC751F5
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 16:50:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id F05322BA9E
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 15:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A03E435F8A8;
	Thu, 20 Nov 2025 15:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ajwgUQyZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2535B274FDF
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 15:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763653703; cv=none; b=QyNHdADlsjDyUPmG+Px4xc9tZaCZKeowmajkcehSCV7L7dHJnNdPgSt6549MRvfZfEmBHzvSQ7/NohCU/cjJBxmL/HYcNXZFyEqqoWnIShVRB8N9cCCq40p4LAlw2HRA493wInrLX5M5W+C6WzWhovqZ2HZk7KpZaOnWAdkWD7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763653703; c=relaxed/simple;
	bh=aCn9gZaQVzumD6IQjqIbMMJUqGd/yGdawIRwj+FUhxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gR9XjzdwhinCRe7kLl4RpcDwNiXjXDQkIBDpkQ5nlkru98ee1TgMa0ZHFMYKoS8rqH13zXi8GmA27Lnhrv3XgKjeDXXH9p3zp1jbDbWY3SXOR7hxxchw1OqiqQu4AFbdpFlGLW8lcy3j57V1xxz/aywpllwoK1n3ORNl4/Urw8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ajwgUQyZ; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42b32a5494dso618083f8f.2
        for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 07:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763653699; x=1764258499; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZTQT/Ft65l/vtNgvHrqGRcFmZM/IEadU1h3kwzC8RRs=;
        b=ajwgUQyZXyNUzjuN/nDCMF22LJehqHMCrS+lpk7JB7ML4LPfhQAhg/jU5fMNajJVDV
         6rvg+XoYepKwQ7gJ20B8VX0xMkae1NbD0cT/GycXZ3sQi1aQQuzd1fjzY11o2k6bKe/Z
         fJokNilaAoni/1UoNpLwaGoG8pnab5Z2cO2UyLw7/d4hQ4RL65MGWXP3C1pX9zM8fhGl
         lq2D5N+JtMeVDNqdOWdqQGMCmrtiHMpBYZp6kk6sApnTBAJtN6z2VRpk22Wjhox+GE2V
         pK3a97Tv1C3AKQgcOENv8KoYDxsSdSIhnvtEN2GhUVDKL1Y4Fn0RREWxkMiS4DU/SYDC
         ZTlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763653699; x=1764258499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZTQT/Ft65l/vtNgvHrqGRcFmZM/IEadU1h3kwzC8RRs=;
        b=rA2bYQohKvbcsjpnih66e+1VnjKwIToklnAbiMbqtprgX52VICpyX8DPpl9zLa/GNo
         ddXESrcyPG4AmTjXd/Um+GNpzIlFBtIf0n5hBEos0aFUdr7/ofiYE95qfUXbHb8CeUmB
         INK6vYgz9wXrEkPOwPmRnFoALxz+D0zfz0yvEIrqKAalSsHMqc+/URCCFqV07bbwBGz7
         5jlZYJACv0ndmIPZKLkvP0vxuGz5DHyyGG9tzX7eN4W8K/PtVh7fyBHVc/RNpmRrvUlT
         Br2sLke+JFBxgoc1O8kknJKEzQIajBqRDqmMPAnrXvzy+Le9kv0hNfdnTo2IuYFmqtGI
         Ps4A==
X-Forwarded-Encrypted: i=1; AJvYcCWFH4q1PoFJDPDyK5JnLs78xbAe+EXuIvoxe+T5rSN6DS7cxFJsGEeAFOtLoD5d7NnJ1d/jHs9SWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFanUJjHoNt27PhRDUcc1BE5XheKIeRvkDPvCo5sBq++ezTYAq
	HflH5t1/3uTKzQsu4Sh0fNSsWfggj0MfJctFEiuk1114D+7CUjtQe//C
X-Gm-Gg: ASbGncsFDL+CZUeOOHVcKVmHbgEuT1hkPCEHuQJ4yjT3HuQBYwzsn+/4fu7Ojsw7may
	i3aAAakOflqjwYh1i0bs3wqDyVa08Y9RmUpJe6DH2Dt7r/US5rKPapfKEloIDCg+WwwZDAJada/
	hO7F2K6ER2VwYktoTAqZyfyEAuvzUyVIF87xSbhRAqB5ZQUWe2X3wn9yoPUA6SzkNF6iM3srQb5
	BdIRotl38SctIg39Y7BhfVwZM/wry5RK1c5B3RMRHfjkfJRi0wr0LACL8qaLnQ7QzVriRs7Vt4a
	JfBo8/TBuDSvg5YjJ2tTjOv6XQPHuocYdsw3MOVq/4Ae01ldxXC2cYdKnwDIiIp51HEZ120U8+p
	CLrCvCJvv5/qYtKn2AsBaZhVDjwtT2Y7Wq2EULUDQFMc8uhyAU3H2NqqVftMfuqmr/zrexedzhW
	EfwzbJPvuTLLaWBRF2ZAIw99/weP9mICFjxTQrjBdrxaeA2W8T4H0/
X-Google-Smtp-Source: AGHT+IG130IcFcxfmIIxu3a8dkYSnRNnzVoOyx2r/mxKGHgE1JL1U38dzXHLcqVCEptCGKDtv+9lCg==
X-Received: by 2002:a05:6000:26d1:b0:42b:3978:158e with SMTP id ffacd0b85a97d-42cbb2a4303mr2783685f8f.30.1763653699224;
        Thu, 20 Nov 2025 07:48:19 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fb9022sm6072019f8f.36.2025.11.20.07.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 07:48:18 -0800 (PST)
Date: Thu, 20 Nov 2025 15:48:17 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 04/44] io_uring/net: Change some dubious min_t()
Message-ID: <20251120154817.0160eeac@pumpkin>
In-Reply-To: <3202c47d-532d-4c74-aff9-992ec1d9cbeb@kernel.dk>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
	<20251119224140.8616-5-david.laight.linux@gmail.com>
	<3202c47d-532d-4c74-aff9-992ec1d9cbeb@kernel.dk>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 20 Nov 2025 07:48:58 -0700
Jens Axboe <axboe@kernel.dk> wrote:

> On 11/19/25 3:41 PM, david.laight.linux@gmail.com wrote:
> > From: David Laight <david.laight.linux@gmail.com>
> > 
> > Since iov_len is 'unsigned long' it is possible that the cast
> > to 'int' will change the value of min_t(int, iov[nbufs].iov_len, ret).
> > Use a plain min() and change the loop bottom to while (ret > 0) so that
> > the compiler knows 'ret' is always positive.
> > 
> > Also change min_t(int, sel->val, sr->mshot_total_len) to a simple min()
> > since sel->val is also long and subject to possible trunctation.
> > 
> > It might be that other checks stop these being problems, but they are
> > picked up by some compile-time tests for min_t() truncating values.  
> 
> Fails with clang-21:
> 
> io_uring/net.c:855:26: error: call to '__compiletime_assert_2006' declared with 'error' attribute: min(sel->val, sr->mshot_total_len) signedness error
>   855 |                 sr->mshot_total_len -= min(sel->val, sr->mshot_total_len);

I'll take a look, I normally use gcc but there must be something subtle going on.
Actually which architecture?
I only tested x86-64.

	David

>       |                                        ^
> ./include/linux/minmax.h:105:19: note: expanded from macro 'min'
>   105 | #define min(x, y)       __careful_cmp(min, x, y)
>       |                         ^
> ./include/linux/minmax.h:98:2: note: expanded from macro '__careful_cmp'
>    98 |         __careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
>       |         ^
> ./include/linux/minmax.h:93:2: note: expanded from macro '__careful_cmp_once'
>    93 |         BUILD_BUG_ON_MSG(!__types_ok(ux, uy),           \
>       |         ^
> note: (skipping 2 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
> ././include/linux/compiler_types.h:590:2: note: expanded from macro '_compiletime_assert'
>   590 |         __compiletime_assert(condition, msg, prefix, suffix)
>       |         ^
> ././include/linux/compiler_types.h:583:4: note: expanded from macro '__compiletime_assert'
>   583 |                         prefix ## suffix();                             \
>       |                         ^
> <scratch space>:319:1: note: expanded from here
>   319 | __compiletime_assert_2006
>       | ^
> 


