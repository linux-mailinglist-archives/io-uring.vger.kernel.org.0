Return-Path: <io-uring+bounces-4804-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D61DA9D1D72
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:42:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CC4B282751
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBF21798C;
	Tue, 19 Nov 2024 01:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T2Ml4zak"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2457C8C0B
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731980546; cv=none; b=eYwzyjG7+k9nlcn+5JKo5h2mA/E9DZ8n4sVw9QgtSwhmP3CAxFhZwwQkAjzEwR4tgcdumIU75Zz1PlRcs9cp5j63F09KXGxmqnwhwB4qnXYnMkhENKzJVMmTzPPayRtaV4xtcmnQdhJiLU1UmQR8cAqpSp8KWhxBUfQEus6h0yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731980546; c=relaxed/simple;
	bh=/RhYLOBHkZ6fdLZACl8a7np338Or1ArOOYtloS9gihA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aV8yy7rxs1g7Q7FhN3HxoxRUiux7s3j24jPrRl1HRHYRCjWlg/rE8oDwm8wXEaozfoArrXLV1NkJMvu8NIuk7Ll9DqgTGOhjuMbFeGSGCdGhKJvSEztpcpBu/lDldySG75nkjzM9zRzbjpmQUSvav4erkvQe8z6lDYtLLq6971U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T2Ml4zak; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9ef275b980so618843166b.0
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 17:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731980543; x=1732585343; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=++3w+Vg76wlIRlqlilPn4jF39p9DNqtBJULwHCjnjI0=;
        b=T2Ml4zakY65o2r2Vtdp5R+Q4REjh1b2pEuEtw8Y49HdHbqdGFY008LXG0yff6/zyY2
         0IActMWBc6RPSNVeybpRtgD/wFh5hayUp53xUh6ipg5KpvShkA9r5EucD3i9DgkOrHnH
         J15hWH3OD37LyRVdlXd7PxJFdaOMAWdPit519FAL0lCwYBiI7k7aH9ZVKbf0DjH+66sE
         69wgIrye1XBggJpmL4gKSObzPykBnt3lwbdM1IjJ6OwckmKfC0wfiAEHPr8iSx+4Sz46
         WdWwXwJUUX404eikksS1wf58vgckEVf67NCfMtg4Lrc/witgkOFOAfkQCP1VuuJjnTAz
         mquw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731980543; x=1732585343;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++3w+Vg76wlIRlqlilPn4jF39p9DNqtBJULwHCjnjI0=;
        b=FvYTyPhkmhwF2EP2QjPYFNlPI5ZW5t5SvXxecJ4hSd/o+wyXZjyDHBtm4wdEiH/0T5
         m5ehVtB4WyugrPE6KT7gqAWLiXyxgy98BUsZjbw62zQsKz+2tiJOus1ZsgTlVQsKY+9d
         +kufOnNmeAnJ7GGMdLXc5qLShnbNPjrm1zmMlDEo0H8xpYYfSS1m1L1HDQNpLgE/Pos+
         GMqLvTegvhovoQRbtkpADW2TVpe0+22+KzIQlF0u29eatiSyXD3JpuYJrC28MGHqY0uL
         XiL5tYA1Ff/mIqiw4T31/5eraRZgD4/jFv3R5vwPKAAq9cvf6gik4o5hIP0Mck2MiG6N
         d9pA==
X-Forwarded-Encrypted: i=1; AJvYcCXniQjVQZ9BZ5RUqOMPF1+B+1sJvYA1gL+Kph/xTzgT2Xn+68u48taQiEJwVF0XSy1Eo9PquOkl4w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLdI7aL67MqZQu5kgLI+HDEG1+ociih8lTMf04uktFmCOG7AmE
	4nzUPlTurTwksG6LPTrEn05CYaXxUuh3Fy5LRVLszen5KxYMIu/j4ghPoQ==
X-Google-Smtp-Source: AGHT+IFNAYUfgdTPkUmtmpRW51+IK4X0qZVqfQTwyC/yp5YasOqAtWBh8hXq9WbmFKrcGZShyBoG/Q==
X-Received: by 2002:a17:907:702:b0:a9e:8522:ba01 with SMTP id a640c23a62f3a-aa4835096cbmr1342042666b.39.1731980543436;
        Mon, 18 Nov 2024 17:42:23 -0800 (PST)
Received: from [192.168.42.163] ([148.252.141.248])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20df26a69sm595883566b.34.2024.11.18.17.42.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2024 17:42:22 -0800 (PST)
Message-ID: <d5e9c79f-d571-4f3a-9145-f7e349e532ae@gmail.com>
Date: Tue, 19 Nov 2024 01:43:11 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: prevent reg-wait speculations
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: jannh@google.com
References: <fd36cd900023955c763bd424c0895ae5828f68a0.1731979403.git.asml.silence@gmail.com>
 <0dfd1032-6ddd-49b3-a422-569af2307d3b@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0dfd1032-6ddd-49b3-a422-569af2307d3b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/24 01:29, Jens Axboe wrote:
> On 11/18/24 6:29 PM, Pavel Begunkov wrote:
>> With *ENTER_EXT_ARG_REG instead of passing a user pointer with arguments
>> for the waiting loop the user can specify an offset into a pre-mapped
>> region of memory, in which case the
>> [offset, offset + sizeof(io_uring_reg_wait)) will be intepreted as the
>> argument.
>>
>> As we address a kernel array using a user given index, it'd be a subject
>> to speculation type of exploits.
>>
>> Fixes: d617b3147d54c ("io_uring: restore back registered wait arguments")
>> Fixes: aa00f67adc2c0 ("io_uring: add support for fixed wait regions")
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/io_uring.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index da8fd460977b..3a3e4fca1545 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -3207,6 +3207,7 @@ static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
>>   		     end > ctx->cq_wait_size))
>>   		return ERR_PTR(-EFAULT);
>>   
>> +	barrier_nospec();
>>   	return ctx->cq_wait_arg + offset;
> 
> We need something better than that, barrier_nospec() is a big slow
> hammer...

Right, more of a discussion opener. I wonder if Jann can help here
(see the other reply). I don't like back and forth like that, but if
nothing works there is an option of returning back to reg-wait array
indexes. Trivial to change, but then we're committing to not expanding
the structure or complicating things if we do.

-- 
Pavel Begunkov

