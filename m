Return-Path: <io-uring+bounces-1802-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 150678BE440
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 15:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA7E91F24CCE
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 13:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6CB015ECE5;
	Tue,  7 May 2024 13:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="06xNZPG5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AC415E7F5
	for <io-uring@vger.kernel.org>; Tue,  7 May 2024 13:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715088529; cv=none; b=V+q8+3fGgD0Td4CsdABNKkZmscmLXksDczdyd65eDX7ZKKTkg9qXtrGfReQ/ljWojeozFl8e19Scr1npn4a6SPiiQkDPYk2ViroiexYDPZTvFTvQ3+Q9iAmioo2NLl/AtxsNTni6Jyf3nG6sNJSl9lZQYMvP8JHh2UGuweWhGyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715088529; c=relaxed/simple;
	bh=5w7dG/mRuXFY0HOjXJUszy9l9SlV5dibC5t6Y1Bibr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kvCdHyQFpqRWKUbUaYJBeR/PTFYak6biFwMi7mA4mJzX7gkbno+y+tQ//w7bRBR8BjVK8zxKJ68r82DBPTxlWp0mMyI0SutBbfpIhyPp5PSD39evaYB9RBEeS00eVOmp2eqkNk+A1ohZk/Ju87zdb6ugE7k3h41hy7OBaX8+Rjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=06xNZPG5; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-36c2cf463e3so535205ab.3
        for <io-uring@vger.kernel.org>; Tue, 07 May 2024 06:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715088525; x=1715693325; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MFxMsf5ko3JpAlwfgW8Pyhp9O0KIdjFS3Z63HbqP8S4=;
        b=06xNZPG5ZLO3TaqsdkSrJ0FQEVzJ4ls5oAA9Bc1EVrzwFrY4lHLmQaFj9vGaT5umeG
         4DTcFEipYJumg849YS7sg1mWTFMNfZyNcd5Y5kIJvtu2aYojFMaB17aGhWwTC4gen+9E
         5ek2YiDrbnGreIwUK8ou6c8Un6JCvAdcWGmbuwYILzBDJBKNq6Me8096I/3aONF5k4kG
         CHmXZSMGeBK7Ptx+mrU04fv75XsS6gBO7FL62n3Z1TPz6drm202xq/1u9MQmtQwEd+6i
         8KdxzJ8qbBcAE9sbLI+IFm81FsHi7g63O+4TRM/FGMBXaZI3zDwrvwnLCHTYHnLySglV
         5mGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715088525; x=1715693325;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MFxMsf5ko3JpAlwfgW8Pyhp9O0KIdjFS3Z63HbqP8S4=;
        b=pPKBWasMQq/Vz7WuU5DRFrS0YC8cKaOgvwKp4Zf7KRscn3HtbNuYNMoDNN+CtF8mAc
         y/XIEBD6zEt7gaSDh9ilpbD+A3yQzH+k4Vn2fBTKzN+qgWhdOjU5uFs9RyPFdOMil6iH
         Z5qj45mENxfYH4orJkn0bJAonWlLJTNcbjySFb5hNpXakY0kYGIYRnYHadiepy/K+PhC
         JgFpX/zVAmXVz9jvTXwpBJZxNfiCDpAoWA5weROa/j6YaS/EFx97DW4K/l9md9GjnRkP
         Z6DoPdWExGmmZtMBNotixukPFCJ4MO3n14SIC0TTme+dwJY4yV+hMRpvYMv0zvGEWtgq
         R/4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWPPYdR72NeH7fcuFkn6MBsnrePN8BSmFbGxRwZ9a58YgdzgkFokxzBQzVFsWfh0BFE+nGivLOJskJoA+Qg2UZUJL/CUXDwT3s=
X-Gm-Message-State: AOJu0YwOemL/NlHxIXNxCb5MxJ0TAk8tY+7oH1CUENIRbwJVkYeRJWHN
	+WvfvMa7sm8YWcEiLvCkQPjdJrdt8hvJY+ual92E9nCPiV2JW14T+ogmaonRwD1klO49qaHi/Jn
	2
X-Google-Smtp-Source: AGHT+IHAYlz3MyK+6BYxDU2VRpmk2kCKMCT/o+YynBqo3rDIWdC+EfBXKXYA7Y+Zjbaam0pdS3/v1A==
X-Received: by 2002:a92:cdac:0:b0:36c:4b9d:7d99 with SMTP id g12-20020a92cdac000000b0036c4b9d7d99mr14788263ild.0.1715088525093;
        Tue, 07 May 2024 06:28:45 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ds14-20020a056e023f8e00b0036c89e78f6csm1803622ilb.3.2024.05.07.06.28.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 06:28:44 -0700 (PDT)
Message-ID: <ccd9b28f-8e5e-4dac-920f-746439c50d6a@kernel.dk>
Date: Tue, 7 May 2024 07:28:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/io-wq: Use set_bit() and test_bit() at
 worker->flags
To: Breno Leitao <leitao@debian.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, leit@meta.com,
 "open list:IO_URING" <io-uring@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20240503173711.2211911-1-leitao@debian.org>
 <d05aa530-f0f5-4ec2-91ae-b193ae644395@kernel.dk> <ZjoGJH1CEk+f+U7n@gmail.com>
 <ZjoKM7ro0wDqsdWP@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZjoKM7ro0wDqsdWP@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/7/24 5:02 AM, Breno Leitao wrote:
> On Tue, May 07, 2024 at 03:44:54AM -0700, Breno Leitao wrote:
>> Since we are now using WRITE_ONCE() in io_wq_worker, I am wondering if
>> this is what we want to do?
>>
>> 	WRITE_ONCE(worker->flags, (IO_WORKER_F_UP| IO_WORKER_F_RUNNING) << 1);
> 
> In fact, we can't clear flags here, so, more correct approach will be:
> 
> 	WRITE_ONCE(worker->flags, READ_ONCE(worker->flags) | (IO_WORKER_F_UP | IO_WORKER_F_RUNNING) << 1);
> 
> Does it sound reasonable?

Either that, or since we aren't just assigning the startup bits, maybe
just use set_mask_bits() like Christophe suggested and not worry about
it?

-- 
Jens Axboe


