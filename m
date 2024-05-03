Return-Path: <io-uring+bounces-1713-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0EBE8BB35E
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 20:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CAA11C20AF4
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 18:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C639502A1;
	Fri,  3 May 2024 18:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Eee81c0C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1846979F3
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 18:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714761703; cv=none; b=bHrohPmRcTUpfbzVE8SlorvYlmbjDkBuh4dmJSa+O42f8r2UEaayykP3FjGf2CCkTqskhiOi8FmyNL4v7Y748Ug8aBFjwjV4aQqeR4AgkT1F2PoHBROeENf8bFU2Qlu3+WiJZhxZ9Bwonzwv/2V61giWHkKEXajWuC3bdepu8JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714761703; c=relaxed/simple;
	bh=71pjptQeomC726ly7T7i6i2tgcntzZ5e4dZc/Q8d4b0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f8AhbBETOIPIwAUuTqTuoY9GENBklVUphb9NRI4n1Jk/FjCbx7oHHWdPyPGi80a3laY6bKC9L1Tn/w5lPPzgp/lIeI4P5bHM4/S+2deHhIVGhTQPakZ6RVFJKiQdIhqybzag9BCh7GvdlckZpv2hwcu+TnW2v7HebkFMUiKUDSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Eee81c0C; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2b33953a163so7239a91.2
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 11:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714761700; x=1715366500; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bQj6b6uzNq4Run0h1mfKtbYDm8JqGmwqI0puPCQ5+lM=;
        b=Eee81c0CQ28YL/GsA3aCRcvkP8wuyUDjkgEhl0iziZkVJe5u7oAOthLa6LzBIvKcQg
         SGF2iXSe35mYfAtSd9Owadth7Yf5Ji5LoDLQWIl4vL/+4TDaGpWEg0oudp1Hj5kxrtwn
         tEXJaRZOMJ4VgtO29yZ0qZoxXFp6SSjYFgvJ1ZoiQuxqi9ixlIPUGwAk7+DCn46DQnbt
         LlgE/+eNrMHF2cvuWFrzg/lq3WRsJLj77h3pCteyWRPcYIDzUcsuj0ZUwpPUMeiW2Xan
         wyqyfEQWG33ov5VyPRgpjaeB9E8di1FoC5F0Gvr4/cAivYoV4LgParxfS2vnOhkt+RWg
         lUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714761700; x=1715366500;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bQj6b6uzNq4Run0h1mfKtbYDm8JqGmwqI0puPCQ5+lM=;
        b=ThovzmFgEd7fAEe0hGe+0Hg8J59mFHXHs+Jfr9Acd0LkDItBJru/A+3qlHGsGuenLX
         TCWEGllCLxxhfFoh/mVfKpL+T5vssb2Y+e/SA5e6p5QFKkt0IcURPZDVESzkHacefNBZ
         RaIRzRvCf9cgddrMJbRmB0fmLc7ovMl6uAqJb5//9O2Qd9faISKV3+1ZopJkCTSRjkpn
         OM3kiclwHRCoEfFCXjqNhl3HQhKaTO9juitF7fvnU2MBKl22Z7+DXzgKLN5iLzzE1WEc
         /DbZO0PM+ik9nzHE+alPpCh8tsdWcAqTOzAeN8cpwW4I564C2VB/qfDXluQX/aC1br6Y
         TgvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZPIrp0sZgauopSAMi68GWUp2fq2+HjW9PxTdnNZz0gv8c7L5q1seluSnDl4i5Da2hBzuPZT2Ina7lioPwurBuTnYYQOT2S+A=
X-Gm-Message-State: AOJu0YwdLKxps4odNkyDRB85pV8ehd23Lc47K+9byE8iA7FnF9CoK2rT
	IYmMY+baO/Bqg1gpbpf+KJ7PFGGqIjGist5G9KpaV311Z7Im+iw/vJthCNkfMzs=
X-Google-Smtp-Source: AGHT+IHb7Hdo5qDQOw7BxTCL3qytUodWG6lrDud2MpwU6hr8AIQkEHW5ufSHsJY2Sdlarf5SGaznHA==
X-Received: by 2002:aa7:8d82:0:b0:6f4:4021:5596 with SMTP id i2-20020aa78d82000000b006f440215596mr3473710pfr.3.1714761700032;
        Fri, 03 May 2024 11:41:40 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id c11-20020aa7880b000000b006ed045e3a70sm3378730pfo.25.2024.05.03.11.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 May 2024 11:41:39 -0700 (PDT)
Message-ID: <b5f7b99c-053d-4df5-9b2b-aaca48e6f7bd@kernel.dk>
Date: Fri, 3 May 2024 12:41:38 -0600
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
> @@ -631,7 +631,8 @@ static int io_wq_worker(void *data)
>  	bool exit_mask = false, last_timeout = false;
>  	char buf[TASK_COMM_LEN];
>  
> -	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
> +	set_bit(IO_WORKER_F_UP, &worker->flags);
> +	set_bit(IO_WORKER_F_RUNNING, &worker->flags);

You could probably just use WRITE_ONCE() here with the mask, as it's
setup side.

-- 
Jens Axboe


