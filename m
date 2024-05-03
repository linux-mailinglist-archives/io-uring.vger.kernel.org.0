Return-Path: <io-uring+bounces-1716-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7EEC8BB3F1
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 21:24:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D874D1C237CB
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 19:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E37E3158868;
	Fri,  3 May 2024 19:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="gp895mwi"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-23.smtpout.orange.fr [80.12.242.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF43C158873;
	Fri,  3 May 2024 19:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714764282; cv=none; b=T1BGUtEfKtPC/Mb99suigfhRrQp45S3eHnvOERDZJnihQtn6R31TeRnin45kRPpISrWUudT3wDNWgS4E9LKOxjqqfZViutCxQsO3STME91rkV6tmbKRFfUsKPAGaC1wb8x6YGGGaaOXz46vzzPvlY6HVFb/0Bkmk4BoG02WMRY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714764282; c=relaxed/simple;
	bh=zZ2FUv8UH3f3a2CJtgWcnJhZ/rfuVISsRtOo/kp2UWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oSApzknRFwrwu129Fy9b3TIVlBQHqKaOjFyZX9sM1iqmLgjjTE9nLd5Z3K87SFU4/MppIAppT3DdWfF7L1o93oeWdal56m+gM9+6O8uX7rWRXww6vSGiIFre5OF/lZXwsl2SvBvJu2LGwziwQc6PoLvFhOWrjGP122nxHgpxxZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=gp895mwi; arc=none smtp.client-ip=80.12.242.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.37] ([86.243.17.157])
	by smtp.orange.fr with ESMTPA
	id 2yWEsvHebHa8W2yWEs2JbH; Fri, 03 May 2024 21:24:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1714764272;
	bh=Res4pHMGCSsBjpzueSYAGK/V8Lb4XzdEaIsnSoWhc3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=gp895mwi1U7sT9E0ch/3qTMi7Ne8IJKV2ziOUP9XRPigPLXdmNk9Slzh9jvh3IRS7
	 njmnc47DhexbOoSUw1fj1nNcgErhvhpmwndH2eOEhgKvd9rn/wHbImhrtZd+ZOUJky
	 9aE7AUlgEN8jN4SgP9/UFFooe/0hjEk2X+E1VdASxZ6AzBzl5OemDI8obWIt2sOe5w
	 OrL+NinyAMygQ8/LkRXBlvlXlOaEcO7n9cvGX/ZKqXxjUcMfBLGEgppnJGt2DtHchQ
	 lcHw67cakEm3PzloyaroS5Rbj+TJ6ft9rMlQNnEhd3XEdNr15Pwz9eN7zWzgYuyBaW
	 +1B7TrU2VsxUw==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 03 May 2024 21:24:32 +0200
X-ME-IP: 86.243.17.157
Message-ID: <75ae8634-72ad-4c6f-92af-76eaa1d3b1d9@wanadoo.fr>
Date: Fri, 3 May 2024 21:24:27 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/io-wq: Use set_bit() and test_bit() at
 worker->flags
To: Jens Axboe <axboe@kernel.dk>, Breno Leitao <leitao@debian.org>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: leit@meta.com, "open list:IO_URING" <io-uring@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20240503173711.2211911-1-leitao@debian.org>
 <b5f7b99c-053d-4df5-9b2b-aaca48e6f7bd@kernel.dk>
Content-Language: en-MW
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <b5f7b99c-053d-4df5-9b2b-aaca48e6f7bd@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 03/05/2024 à 20:41, Jens Axboe a écrit :
> On 5/3/24 11:37 AM, Breno Leitao wrote:
>> @@ -631,7 +631,8 @@ static int io_wq_worker(void *data)
>>   	bool exit_mask = false, last_timeout = false;
>>   	char buf[TASK_COMM_LEN];
>>   
>> -	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
>> +	set_bit(IO_WORKER_F_UP, &worker->flags);
>> +	set_bit(IO_WORKER_F_RUNNING, &worker->flags);
> 
> You could probably just use WRITE_ONCE() here with the mask, as it's
> setup side.
> 

Or simply:
    set_mask_bits(&worker->flags, 0, IO_WORKER_F_UP | IO_WORKER_F_RUNNING);

CJ

