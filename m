Return-Path: <io-uring+bounces-3889-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 634499A9675
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 04:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 183FC1F232A3
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 02:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C542E12E1CA;
	Tue, 22 Oct 2024 02:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="t3gMiINU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42DB84D34
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 02:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729565976; cv=none; b=P+ueuvfNnHaF6A63ngEN2nG9Br4KfgaszqA0XxseFIh46Cx/8rI9Z7tgfj1Gick/ETHGBKcqZyNhggu6OmXC/g+wWHu96qjG583jc4uYL8Hm9DCIMkAbhfcosldyPeVuC/BjIyJ2vwysmlk8P0I1Fq/qZzhZXGZ0Xto0hAh+PSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729565976; c=relaxed/simple;
	bh=y2/u7D0Dk8ncqWnYZgn6dKkuom5rGZ43HNcGoPVZFso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A0YwKFWi54EqZVc/fkqmCn/04u0kcHG+hPmLjiNTF+qYgFC8nSzTpBwEkgYuJNTLAQkBvv7nQioVumEcsgnSAju92x6HFfHLwk97waoa6UWrRBms18IyjyGK/usJYRYpdeuIpj+KZD43m7mEXIMVlB1VGHVeUrozm8dgLPzyNoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=t3gMiINU; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7ea8ecacf16so3503138a12.1
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 19:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729565973; x=1730170773; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4UHkio6LhuFgufIqFjO/VBjBb3Y3Ie2pthcJVLO/wEU=;
        b=t3gMiINUNX9w0eQX3rbnvHpkYQ6pm3nYPNwZ1e0ZOSon8wK0IskOX6YIs9RsICambK
         5Y2mzQOQCwlDVQNDiMdFvyjEZZZLvpEZTWqVUeeR5jpDK/Rf2IqUPl+cfPf53xWP3kt9
         XJ6Np1tdNEcRBqCpJNpuRe0sAJ1ru/BEcT2PK4EleaeUQ247St8yY9WHcBNi8L8jisSn
         gPNd3jsqm8bgBXaNeT/RUxlr0LZG0Yh2/WvqPhjDIDy+Xr2W7rYkSHYSypTF7cknrNIV
         FQa89V/JTtvXzocq4RIZmyv0J2KrRU2hydcFc+4t4+07KJtEGhx5DPGFDnaD0/DO99UE
         CKGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729565973; x=1730170773;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4UHkio6LhuFgufIqFjO/VBjBb3Y3Ie2pthcJVLO/wEU=;
        b=dUjzakl3s8SWK+hld4SfmDz3lgZhs0u/w3nhoCQcPlk35LKfgQy0vjtfbImbs/U+Iy
         TbeJvWJwGM7Gzaaz+R1qXqeh9tSqQEoiAG7hYR33UPylTg5u8II6Fb7VrrBSwoJC1zHW
         YPZ4vUm4l7Z9EW2lfs8I+KUiyP0Z0QotH0x5N+mzO3Pp6rfvWx7SBDLWCryXLA5qS2To
         2uT0AbN4xYquOMZ3uKAlF/K1fkMmJ5gbXd2reAVm8QEG+xd0zUDdqprtQePHP8ki1uDk
         bvYDsVfQM3RN3GL3LxQLKErLuuocdO0ksjmr9pKbc13xDttJEg+0R6laTqAhoSMBNXhy
         I9ag==
X-Gm-Message-State: AOJu0Yzfui1xT7+CcA7bXMeqYoY0gixRolRGEEf7p5YrYuI+Khm8Ugbz
	CrtADUlBBqRNeSfn9vJLkOeC6E1LdPQZhHgi1U/woHT0xCc50qX2ylgBu+7NcsnptvME+Gt1Dys
	V
X-Google-Smtp-Source: AGHT+IFh9AiqZtCaM9RyF2DoCqiYX9vueXXzf43f9sslCUSB+xEhIBEU0z4zqGyJ45tgDsG/Xd3IxA==
X-Received: by 2002:a05:6a21:1349:b0:1cf:38cf:df92 with SMTP id adf61e73a8af0-1d92c50d9a9mr18074191637.30.1729565972982;
        Mon, 21 Oct 2024 19:59:32 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec1312c8fsm3760869b3a.14.2024.10.21.19.59.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 19:59:32 -0700 (PDT)
Message-ID: <f29d4778-b5f5-4f3c-a2e6-463c5432dd65@kernel.dk>
Date: Mon, 21 Oct 2024 20:59:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] io_uring/uring_cmd: get rid of using req->imu
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org
References: <20241022020426.819298-1-axboe@kernel.dk>
 <20241022020426.819298-2-axboe@kernel.dk> <ZxcRQZzAmwm1XT3K@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZxcRQZzAmwm1XT3K@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/24 8:43 PM, Ming Lei wrote:
> On Mon, Oct 21, 2024 at 08:03:20PM -0600, Jens Axboe wrote:
>> It's pretty pointless to use io_kiocb as intermediate storage for this,
>> so split the validity check and the actual usage. The resource node is
>> assigned upfront at prep time, to prevent it from going away. The actual
>> import is never called with the ctx->uring_lock held, so grab it for
>> the import.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/uring_cmd.c | 22 +++++++++++++++++-----
>>  1 file changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index 39c3c816ec78..313e2a389174 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -211,11 +211,15 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  		struct io_ring_ctx *ctx = req->ctx;
>>  		u16 index;
>>  
>> -		req->buf_index = READ_ONCE(sqe->buf_index);
>> -		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
>> +		index = READ_ONCE(sqe->buf_index);
>> +		if (unlikely(index >= ctx->nr_user_bufs))
>>  			return -EFAULT;
>> -		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
>> -		req->imu = ctx->user_bufs[index];
>> +		req->buf_index = array_index_nospec(index, ctx->nr_user_bufs);
>> +		/*
>> +		 * Pi node upfront, prior to io_uring_cmd_import_fixed()
>> +		 * being called. This prevents destruction of the mapped buffer
>> +		 * we'll need at actual import time.
>> +		 */
>>  		io_req_set_rsrc_node(req, ctx, 0);
>>  	}
>>  	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
>> @@ -272,8 +276,16 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>>  			      struct iov_iter *iter, void *ioucmd)
>>  {
>>  	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +	struct io_mapped_ubuf *imu;
>> +	int ret;
>>  
>> -	return io_import_fixed(rw, iter, req->imu, ubuf, len);
>> +	mutex_lock(&ctx->uring_lock);
>> +	imu = ctx->user_bufs[req->buf_index];
>> +	ret = io_import_fixed(rw, iter, imu, ubuf, len);
>> +	mutex_unlock(&ctx->uring_lock);
> 
> io_uring_cmd_import_fixed is called in nvme ->issue(), and ->uring_lock
> may be held already.

Gah indeed, in fact it always should be, unless it's forcefully punted
to io-wq. I'll sort that out, thanks. And looks like we have zero tests
for uring_cmd + fixed buffers :-(

-- 
Jens Axboe


