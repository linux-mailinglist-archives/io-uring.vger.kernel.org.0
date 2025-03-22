Return-Path: <io-uring+bounces-7197-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAD48A6CA0A
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 13:08:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B808A881926
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 12:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C70671EF38A;
	Sat, 22 Mar 2025 12:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EmNOp5Je"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C161DBB13
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 12:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742645328; cv=none; b=rRUxmDSd98lFrkE4eoyqOpuK2WmphjbNNASv0gykT/73buHJuHpj1fUdVS8u8MHwNtHJv7HoI2uyLf+UzOfRyItR7mw5flSzXLxLg+bltAEs7AwPxgVWIgLjjL0NflgDg39KaAElX4gvavUCpGQG18qS0BeZgh8q8+pWsQ+op+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742645328; c=relaxed/simple;
	bh=CNcYBJMd23aY03psEoRwzJHB5lF4vCKvjZuKd8Qo/p8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fg5O3iJzVGZq/sMix4M7HRcM8adh3kQPIk0EbxI9ayG/3NdfRpJEa0cnUWLuvKX7KUcI+qy9qUp19eyCze+jvbPwKnWPjBwrrdw4NLIWpkoPKi0WPfATb6IliD/+EvfUripu3Kfwis3KmvXuJkgZLU30YCzhLoSdB58REYH9H1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EmNOp5Je; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5e673822f76so4616954a12.2
        for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 05:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742645325; x=1743250125; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lK2apKsgfhMr4ac5hEBi4xf5amW9YpVNUxKx+9GX1sE=;
        b=EmNOp5Je8fpTAXIUtgfq8+QxV1ivrSTPVg+Uv9cyS1O0hpFAowv5AN8kT7g6phwe7j
         TIIO7eFxazafZK8rDAjZmwk0uIoHRrNk2Qqnu9OUQuolIF2NCnZINnKZjv6MIJFRwA7I
         lENuWewhfjEo/QUG6lPIanb9ZckEGbGNbK+blDqiI8wmzMwYoTqO4Gv8LUi4tZG4OczY
         pC9OSOA1TECVFISfkeYdYXeSdT9NsKNFrvY4Rtli4Z0gJmwPyyeZLQod6KkO17YxxR1a
         DsZ+RSbtclVJX0rV+xsukMfo8bGf4Opxo+wAIl3RRxwC+wAS8x7xjr2qkOPHsHZagVkQ
         k5NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742645325; x=1743250125;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lK2apKsgfhMr4ac5hEBi4xf5amW9YpVNUxKx+9GX1sE=;
        b=rfmJ31T/fvgoXylnYsYnGUhWZLUMcV91WTdrZ1zwsPH9VETg/1gPtE9QZ9lwhjwpFf
         MIT71bbidCUX61R0qV2i/4UBwX3mzoKgwSq9+n8r/JOGtjYSJIviFqeFJ45mTAXOdnSu
         7r7IYHxL2fRjcw/yefwLlSOuuiTLO/y6gZkVpn0phEfRN5XB+vahbnphuRAqTyfzjanf
         FVxSkQZqg6/uh+mZDZMvOKivZ4e08qoUIr640eQ4ombHTDXWWMtsXjJWJ1TXfru4TO30
         ZXu94km2o3uB54Rx/roCQ6Uf0uTLWd1KNf73v908qG3tmCc0vf8HpHqnMiIBGCVe333c
         4e/A==
X-Gm-Message-State: AOJu0YxClFdiFtlY36AxGgHZ+sy0rNjqDFtRatyoJP1cVYdUYPV0jbTL
	SaPtjr9/BIQSzYt1Ck5oxnA6sxy7AXeHz7LGewKAL6hRsC0KAK2T
X-Gm-Gg: ASbGncsBb4F96jhrXVoPoOpEs0iE7eY9oPPN4r0ipqE1yCqSId5OFsgHaaeD1+5NM6L
	8ng9wsMwEA/7Yc1UbsIWoaI0ovMXKx2T8ZS5BI7EO7M0x3jYxqGVJIn8vNz8DkJWEUGujRN09qo
	8Q4gSCqrlxJAjO5ClwicKNGY/Po5rykVbIsHNBY5hxdVeXb6/kYyjib8o17lBZ2cyVFt8sA9jEQ
	8W2bKi7HFvkaKpF1gvZoRWqz3RakGz3sGRm9AMsihzy78bnnVKOfmBvSycb2IyXhANFTCIFknKl
	fJ6ojjL1khG9hujnHpTwxXAXidp5ez73zthiOKroMvsc8/kjw8pi
X-Google-Smtp-Source: AGHT+IHov8SssTjpdgdz2C64Yq/SnAXVh9ulr3kWQVsc/4Gj25DLegmDHDQbIB+MGcKA+85ngzI3ZQ==
X-Received: by 2002:a05:6402:2551:b0:5e5:bde4:755f with SMTP id 4fb4d7f45d1cf-5ebcd433fffmr6312690a12.14.1742645324928;
        Sat, 22 Mar 2025 05:08:44 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.37])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ebccfb1271sm3140817a12.44.2025.03.22.05.08.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Mar 2025 05:08:44 -0700 (PDT)
Message-ID: <c9adcb02-0ca8-4ed3-8baf-4374dc56bb29@gmail.com>
Date: Sat, 22 Mar 2025 12:09:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] cmd infra for caching iovec/bvec
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
References: <cover.1742579999.git.asml.silence@gmail.com>
 <0c6e6b27-05db-4709-be80-52d0f877d2ce@kernel.dk> <Z96F9J5gixbb52E-@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z96F9J5gixbb52E-@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/22/25 09:42, Ming Lei wrote:
> On Fri, Mar 21, 2025 at 01:13:23PM -0600, Jens Axboe wrote:
>> On 3/21/25 12:04 PM, Pavel Begunkov wrote:
>>> Add infrastructure that is going to be used by commands for importing
>>> vectored registered buffers. It can also be reused later for iovec
>>> caching.
>>>
>>> v2: clear the vec on first ->async_data allocation
>>>      fix a memory leak
>>>
>>> Pavel Begunkov (2):
>>>    io_uring/cmd: add iovec cache for commands
>>>    io_uring/cmd: introduce io_uring_cmd_import_fixed_vec
>>>
>>>   include/linux/io_uring/cmd.h | 13 ++++++++++++
>>>   io_uring/io_uring.c          |  5 +++--
>>>   io_uring/opdef.c             |  1 +
>>>   io_uring/uring_cmd.c         | 39 +++++++++++++++++++++++++++++++++++-
>>>   io_uring/uring_cmd.h         | 11 ++++++++++
>>>   5 files changed, 66 insertions(+), 3 deletions(-)
>>
>> This version works for me - adding in Ming, so he can test and
>> verify as well.
> 
> With the two patches, all ublk selftest can run to pass, and kernel doesn't
> panic any more.

thanks for testing.

> 
> BTW, I meant vectored fix kernel buffer support for FS read/write, which
> looks not supported yet.

Right, you can't use do a vectored registered buffer read/write/etc.
with a kernel buffer (ala ublk zc provided one). That will likely
need a special version of io_vec_fill_bvec() that would account
for bvec entries not being uniform in size.

-- 
Pavel Begunkov


