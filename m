Return-Path: <io-uring+bounces-5174-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD169E1DA3
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 14:33:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1182DB29BE3
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 12:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1011E47BE;
	Tue,  3 Dec 2024 12:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IRvg8noI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A351E0493;
	Tue,  3 Dec 2024 12:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733227470; cv=none; b=RMXm45w6zwhsQee3YYpPzFBTmwtkG5gkDd7tacdCBCRfxOnjuuK++P4fUVJqVQv99KQ8mlbxGNT8L0wQtlH4wqGOoaUpvX8aAtOc5/gADATa/VawdXbWcYookixDHO7gYVP7LQR93Q1A7UrdyciCkJGJNxVZAyLohBPZQ1NEs+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733227470; c=relaxed/simple;
	bh=FEiLx00zqYf4+51Ik7ASoOyO046tjcnO+cRI+fUxJlA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WlZL5ZEH/UD3Iwbp2ZgHcO7CAq0uz9MTOryvDGgk0z6Al8j+XBOH2v8nqcYWeO0qODFDcK4JmWWKaCa2R6vkKh2psEJNptdTpcTjCyf+2wQA7yphPiaWVyY0tgYv2OkSzxdbFB5J7+btnWy/YQaECCzuUMYXwYwVbDOdG0Ao7aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IRvg8noI; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aa549f2f9d2so669717766b.3;
        Tue, 03 Dec 2024 04:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733227467; x=1733832267; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DdFGz1GNvwzX3FJYNRanwNsMLzriIeqibMElvzGNDoo=;
        b=IRvg8noIVekIE5KeRZ38qkRm+8niaBlikr0R1tyO9r1GkYbVlfMfV5k7+sEG9mSfzg
         KcV5oh0sGmxa1NlMHumk4GGJHaURugxfkflFkSglod8b+b9BlRNIajWgCnX3EP3cXhtj
         X9z83Q8IOXybcd/xhdKJW5g/9iGCD0RA+s8fokj6uh6NzIB9HPuZIMfOUkQt2fsiQa0y
         BoJjKLAZRwfKVD19H4ksTjHEDOSizlqqkB7AxpJDMpPQS1lpIwrzKVvaO6EgT06U5fOC
         xdIQTdIrQAJLRgkZ5p+pVTN2KKsYSIEcNRFBP+0/g3pCQDErYh0J2V7rHO0YmZktZTln
         HRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733227467; x=1733832267;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DdFGz1GNvwzX3FJYNRanwNsMLzriIeqibMElvzGNDoo=;
        b=PoSGXjPbZ1RO1Orxs6Bl/ZitiZB4lzCgCmDrdZWVAilqle35ewZjVm/vJpnR6LSvrj
         CLM9M6VY0LBDf54vgM6b49FajCHUsd1TiC5vh7mReK/JPI5G4ws9hASyrHhhNJC0rLwZ
         LQfDPlIysNtfJ1slM7WvKnh8BNQ9Wbcw0ss7OEIppk0zlADZjCq2+hRmOeh5y/Xi7XJY
         msbmQS8wdk4xxX55Z9tFCsDyK40AUCuIKycJglDiPU4zRCpo6++9UviUgFn+SuyVxNDR
         IpclAGmA/i5UqiRsLTjj/GPyUGHgAoHzRUeyf1DbIlZEbpRQM0n7b7Ed0QWtF1iEwT/I
         O/EA==
X-Forwarded-Encrypted: i=1; AJvYcCViT7nNBsOoFmCHYYDvU2VymWDUk4nU5bqCU58C5J3xN1AJJnXHMg+AazP1QUYw5LlI9IvzbZA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxO9xJYDRXH4KLZzrDTcqG2WdxCZhrLzTa0K3HWfoeDm4bmJEhw
	Lix1jD/5r0un3ffjdq4HBdz7bnTGt/pA9URhvdK5ch1DK7TJQHN30wXZYQ==
X-Gm-Gg: ASbGnct/KDnCg3OIGf7Zb4+dP4YRQTNRXoT/hZ8LJkF6PS8bbbNDfqt7hqrasE33kqw
	Vm8ogwp17dWJlW+5JM4cK36OFbvt6Q1iZB2Gvy3Qs3tNGSk8Jz5fEyaPm24t1nqFps6sQhbB2EX
	HEoBKBuVcvNhDHBRQNRjsOnuWzFuQxz6LbJCCMd92uocPQXnOeLjv0jPXG1QMymYNKvPv/4d5Ap
	7UrpqNqTTM+/BDpOiHF0ylPr/PpL7Ma2nQMrsBgDOlE/ETFGQH9fmYsFcMUDg==
X-Google-Smtp-Source: AGHT+IFFAQkr1ErihNvl9V76tIRJQVSJ3c0SYsmQ1aGe2ujcXBz43wzm1KQfi/ymtbdHl5j/Q22log==
X-Received: by 2002:a17:906:bfea:b0:aa5:3853:5535 with SMTP id a640c23a62f3a-aa5f7eef1fdmr162439966b.38.1733227467171;
        Tue, 03 Dec 2024 04:04:27 -0800 (PST)
Received: from [192.168.42.213] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa599953d53sm611295766b.181.2024.12.03.04.04.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 04:04:26 -0800 (PST)
Message-ID: <b21af3fd-09de-48e2-a21c-318f23344528@gmail.com>
Date: Tue, 3 Dec 2024 12:05:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: Change res2 parameter type in
 io_uring_cmd_done
To: Bernd Schubert <bschubert@ddn.com>, Jens Axboe <axboe@kernel.dk>,
 Kanchan Joshi <joshi.k@samsung.com>
Cc: io-uring@vger.kernel.org, stable@vger.kernel.org,
 Li Zetao <lizetao1@huawei.com>
References: <20241203-io_uring_cmd_done-res2-as-u64-v2-1-5e59ae617151@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241203-io_uring_cmd_done-res2-as-u64-v2-1-5e59ae617151@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/24 10:31, Bernd Schubert wrote:
> Change the type of the res2 parameter in io_uring_cmd_done from ssize_t
> to u64. This aligns the parameter type with io_req_set_cqe32_extra,
> which expects u64 arguments.
> The change eliminates potential issues on 32-bit architectures where
> ssize_t might be 32-bit.
> 
> Only user of passing res2 is drivers/nvme/host/ioctl.c and it actually
> passes u64.

LGTM. We can also convert all parameters to match the ABI, i.e.
io_uring_cqe::res is s32, "ssize_t ret" is just truncated.

-- 
Pavel Begunkov


