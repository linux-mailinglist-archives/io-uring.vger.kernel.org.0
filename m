Return-Path: <io-uring+bounces-6316-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F282A2D024
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 22:55:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A06E188D23D
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 21:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874C11B85DF;
	Fri,  7 Feb 2025 21:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bOUR29+4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D861B85F8
	for <io-uring@vger.kernel.org>; Fri,  7 Feb 2025 21:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738965302; cv=none; b=rK5UDEGfMKyQ/Jg1aB0ViYqee0o9DYpmeBFksD2jLFbb9S9KW03mvANw7mAUtsaRh9KvSOx+Xap/sCsXJA7ylxuLAUJh+IdBypXBB1takUEsh4Xzia9tKlK9X5U81GLBS/lRgCejc1VqpRunaPBezjzOIOl+Uvk9ZqShzOxhj48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738965302; c=relaxed/simple;
	bh=1gd0yH30pcxmkVpUUSXoevvZ1wIpN/0PdpaN6tVQ7vM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f0wq/jEVe2DdaEBIE8ZeV6X2yJV3jvS94xt9emnGwR1V29AbdcCaj9W1AkHH8eW95q0vUPobbN39r9sphNXjuKRolkkOEqcsdP2PhhhVvpCzRjwrwY5C6WB8bsBnqzF1ANwyT9d53nvk8pjOhEOV3L/G0uLXMVcqwLTBE/DKcyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bOUR29+4; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-844d555491eso75952339f.0
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2025 13:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738965298; x=1739570098; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5IBqtH4R3jDvL4rKWTD+iWS0bbTvtCiS0BwL590tGJ8=;
        b=bOUR29+4mFYUIO2dUBGytCdkMQbvdNnM3m52dq7b1tfsmzMKvLZBf2aBmNnWfgXbI/
         LyOFDSdXnB9jVjdaBVKkjlcfxrFyy+S7c2fzBEcfNJSBKqBdczx/jkkqTZ5zjwXsJrjd
         VI2tGyDOcD+EZB6FraiWIQrDm0fFnhivbnQUF9VpotAZzJz57IZhz1y901FecGm1T5jz
         NJRXTjKHACHO3YX7M+i3WMZrHSHH1SE5Fdg1YC5H/SwY7IimQxR5RewKW+X+tkY8gDGD
         AR/9R5WwHdgzir8850P8HJacX0qZJ+VUkrSOX9X8gaXTC7c2t0AoGFQ94DD5xXaEiCii
         NSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738965298; x=1739570098;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5IBqtH4R3jDvL4rKWTD+iWS0bbTvtCiS0BwL590tGJ8=;
        b=LpuK25vGKCZ7385oEeetOQKEiPcgWKJyO+tfdJUpA/QkiPpG7Pg8EWX2fqkG6b4Ydb
         9WrQZXAgvc6NnGN9KO4UsUs6nqDNq6Kc12lBeretpyuFO4E5VP8TtBshL84tnVczQrPZ
         EyEAbeBi35UPcl+HvZUXm9c+dJ25v3llRsCChYVZuuTBniBXhpQdnvnqIocyF2Q167hA
         6UVgbFWdK60RrxsrDFtUBqAD8E0UtJTHNSHHE+fsZk5I2mAhrnSYJqmRW3cCw0IqLl96
         4nKGN7Y98alwb7Mga4aSgVU6yLaTbk1uM782aTJB8iWCk0nGLkuVFNhd+JgSVceArc5o
         xi2Q==
X-Forwarded-Encrypted: i=1; AJvYcCW6kYH01bUqpFhHhPGPYGA2jFg4mDqfkfG6ZJXeXbfWDcuCkUIk0dLnzwwWAbuHzaNSpOz+7twNGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yys2SxprLy5vRvu58Q9kbqMwXa04BDZsrDR+CmmlNvd3XycBOsB
	Qtae0bSazPVVzstFBQKDJ4n2hYnk+tOSpEcJTOvG3MEwjY02VRWaHduV4yNYsfk=
X-Gm-Gg: ASbGncv6Ns2wZYY2dQYEPlgwow/FXPUoa4AFVtstEULJC8fMShQZPGR/PKoqmx/kv2S
	iAsPdyf8kRrmZZ8f6uc5IHPORF8wJMzKddGsKiFKSX6QZEMu8f91KPDmHW7Ny3JbZqzYAmr+soJ
	Y58/t2G5N3HlLe7tv9wuIVJJPIa7ShVOMRr9ovpnzfEUgv4rnU4MrLCTW93w7jUr7CATzdDkpBe
	EE4lfLtG3knH6zDfHnnE/YWD/4mqHBnF/wJuyHbk0oo1pNV6wevZUCTAMAGnC8pQJO4YGzErZl0
	r8DIEqhNRJg=
X-Google-Smtp-Source: AGHT+IHtZu3iwfSrRceCWPHMvjUaJ4b5MixZUsAk664E4N5LXxNLDuIGyZG7eeJAsl3IlpSL0Ym+fw==
X-Received: by 2002:a05:6602:3946:b0:84a:5201:41ff with SMTP id ca18e2360f4ac-854fd886d54mr481503739f.3.1738965298354;
        Fri, 07 Feb 2025 13:54:58 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-854f67b90b7sm87271439f.40.2025.02.07.13.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 13:54:57 -0800 (PST)
Message-ID: <f4efd956-ebe9-4a02-8b98-b80e16db95af@kernel.dk>
Date: Fri, 7 Feb 2025 14:54:56 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] io_uring: refactor io_uring_allowed()
To: Paul Moore <paul@paul-moore.com>,
 Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Pavel Begunkov <asml.silence@gmail.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?=
 <tweek@google.com>, =?UTF-8?Q?Christian_G=C3=B6ttsche?=
 <cgzones@googlemail.com>, =?UTF-8?Q?Bram_Bonn=C3=A9?=
 <brambonne@google.com>, Masahiro Yamada <masahiroy@kernel.org>,
 linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
 selinux@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250127155723.67711-1-hamzamahfooz@linux.microsoft.com>
 <8743aa5049b129982f7784ad24b2ec48@paul-moore.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8743aa5049b129982f7784ad24b2ec48@paul-moore.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/7/25 2:42 PM, Paul Moore wrote:
> On Jan 27, 2025 Hamza Mahfooz <hamzamahfooz@linux.microsoft.com> wrote:
>>
>> Have io_uring_allowed() return an error code directly instead of
>> true/false. This is needed for follow-up work to guard io_uring_setup()
>> with LSM.
>>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
>> ---
>>  io_uring/io_uring.c | 21 ++++++++++++++-------
>>  1 file changed, 14 insertions(+), 7 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 7bfbc7c22367..c2d8bd4c2cfc 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -3789,29 +3789,36 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
>>  	return io_uring_create(entries, &p, params);
>>  }
>>  
>> -static inline bool io_uring_allowed(void)
>> +static inline int io_uring_allowed(void)
>>  {
>>  	int disabled = READ_ONCE(sysctl_io_uring_disabled);
>>  	kgid_t io_uring_group;
>>  
>>  	if (disabled == 2)
>> -		return false;
>> +		return -EPERM;
>>  
>>  	if (disabled == 0 || capable(CAP_SYS_ADMIN))
>> -		return true;
>> +		goto allowed_lsm;
> 
> I'd probably just 'return 0;' here as the "allowed_lsm" goto label
> doesn't make a lot of sense until patch 2/2, but otherwise this
> looks okay to me.

Agree, get rid of this unnecessary goto.

> Jens, are you okay with this patch?  If yes, can we get an ACK from you?

With that change, yep I'm fine with both of these and you can add my
acked-by to them.

-- 
Jens Axboe

