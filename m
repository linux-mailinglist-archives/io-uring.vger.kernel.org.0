Return-Path: <io-uring+bounces-7271-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F0F5A74D49
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 16:03:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05D3F7A441A
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 15:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF53C1C84A9;
	Fri, 28 Mar 2025 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rf1pJWx6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454651C5F29
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 15:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743174196; cv=none; b=H70h1Vt7BWO0vkn76ROrbP5YfG9lQHPL3i+JGPee9C04e+gMj1mrJCDsutidiIALnguF7T9y6IlEDttvcpeDrJUbKYSukm37enZA8W5trCQ0TcWMfe/pDy5LYJsrOvxc56tBYMvyY8g+iZtYF/s+JuqwM/8Fz227tCp8rS4l/aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743174196; c=relaxed/simple;
	bh=mmkekYoxBImyft3w6keX+52W8yg9Ky3aQa4IH1CCqos=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ka0ZJ6ogLxl3zXt9ediAapWEUPisrZ9cKp76AuED6X0vP91AgzahqzTcTtOmgibDMW3ObSaUPpdVbH9ULj8ImXjTa00MwFR9b6JqH/kap39fejEk4gkuIkNe6Iph4fJ8l5sEdYlR24t4Y8dIYHTyQBG6JMphYCtV3flHELK7AWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rf1pJWx6; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ab78e6edb99so283665066b.2
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 08:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743174192; x=1743778992; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=B494ZOsFmjWmHyFym9cCvJ5Fd2BYVVH/8s3Rx/2tejg=;
        b=Rf1pJWx6cvgRhRBr03DEAPa3ymBUdxNKhP0FuBbE6oNKsxaCPIr0LIjD0kkLj0sss8
         ztNCPHp7XfkjmRs9hnyxWEjBNzNqms4XbcU8BkghSsYEN8CTJnHQijYXAdfI2l/2SNk2
         YpgnL2uyJaC+ZnWEooyGoEiFBmGyDSUL2rs0dl7hhk90jA8eqLD4N6BrXc5TE0E7dDXl
         FljaHj5EzS+TwFR/NGfiY+WYZWmP9q8+qTbAQ8/ozcuZT6s1sm+P5ThJuhy+w7APOFP9
         OEw7xe35BFXcT8V9KLH8ZtQ/IBYGsmXkk7Bh1nsk2FZxYa12hzT58kw56xJac6xvI8UA
         ckjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743174192; x=1743778992;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B494ZOsFmjWmHyFym9cCvJ5Fd2BYVVH/8s3Rx/2tejg=;
        b=uqlNIB06hExx2eGh7nwLjj2zq98AcJnI2sAdl+RbLla2gAJawupnyp2iY2OIBvNTba
         j6YGQnLoU5ouJaCnjYvkIt9KBcUpImMXCKh9giQ93V+rIXdrk06yR7fkrXU+nFqISfGW
         ucNiPKYz7bFpGZOw4/qyijX05pSwCpV/WmatZgtWCIZK91M0kW5jB0D+KT2b0GGJgqJU
         gntRskFx3aAkvdXmSKKRz0T4sJHUdO5+8T1iCue4ZJeHG0zwcu5DgeAABEcVZC/nqWxw
         Lk7MOigt1seBDgJYVqFwAAp390aYy4F9HgYpprfM5WCl5biM96HGWho6LLBioLMHzfqX
         k+0g==
X-Gm-Message-State: AOJu0YyEK3PKIolk7OoVZQXHtV8kvB8kTWjdrBJMx2kLqkkCybXV1OpV
	HjHLzBWEXPrJmE6dIcRcT/K3/9P5I0Oqaq2+zglX5LmG8KumpWX8
X-Gm-Gg: ASbGncuxqdaCZUFwCwAy1/0SFgOTqXocq9JCCyWwcTiCRP+KIoT7ODyJq6lhYqx7tn5
	Rx31Rgj4RWo4CltHvzGVeWHmLsXrXiR7kqguwrFG6u2qkDxZqrLdIsjxcXQYnHMJLufJBlaqcZ4
	T9nWwGrZo3SWAbV/X2diDVLp1INU/AZQsBjI1qw8VhA2GPZ/UhiAB7NwIkdgFINMyZAke9zc2Z7
	QlMpu2m1P9Em4OupZ2TjV+lRtk4lkXNYhu9TYSBQgFWsW+22JvfQMx91yVr5qQ5OlPX5/dt1MTR
	D5tyiNKpbdF6GHYQaYzw/pjkMH7/zo3swLI0cyW60mwpcPlPhv4vLaDq9TbpbrLYAns=
X-Google-Smtp-Source: AGHT+IGixhUoDYlpwo+2Md+2QPjUeZKBcFQt1VdDffY726u4Gp50VIn8aWat2eLWn+wA64zWXZSKow==
X-Received: by 2002:a17:906:7313:b0:ac3:898a:f36d with SMTP id a640c23a62f3a-ac6faf0a6bfmr785939466b.30.1743174191865;
        Fri, 28 Mar 2025 08:03:11 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::ee? ([2620:10d:c092:600::1:f2cb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71927afe0sm176164766b.52.2025.03.28.08.03.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Mar 2025 08:03:11 -0700 (PDT)
Message-ID: <e560527a-4efc-4e10-bd37-3a282516430a@gmail.com>
Date: Fri, 28 Mar 2025 15:03:56 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SOCKET_URING_OP_GETSOCKOPT SOL_SOCKET restriction
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>
Cc: io-uring <io-uring@vger.kernel.org>, Breno Leitao <leitao@debian.org>
References: <a41d8ee5-e859-4ec6-b01f-c0ea3d753704@samba.org>
 <272ceaca-3e53-45ae-bbd4-2590f36c7ef8@kernel.dk>
 <8ba612c4-c3ed-4b65-9060-d24226f53779@gmail.com>
Content-Language: en-US
In-Reply-To: <8ba612c4-c3ed-4b65-9060-d24226f53779@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/25 15:02, Pavel Begunkov wrote:
> On 3/28/25 14:30, Jens Axboe wrote:
>> On 3/28/25 8:27 AM, Stefan Metzmacher wrote:
>>> Hi Jens,
>>>
>>> while playing with the kernel QUIC driver [1],
>>> I noticed it does a lot of getsockopt() and setsockopt()
>>> calls to sync the required state into and out of the kernel.
>>>
>>> My long term plan is to let the userspace quic handshake logic
>>> work with SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT.
>>>
>>> The used level is SOL_QUIC and that won't work
>>> as io_uring_cmd_getsockopt() has a restriction to
>>> SOL_SOCKET, while there's no restriction in
>>> io_uring_cmd_setsockopt().
>>>
>>> What's the reason to have that restriction?
>>> And why is it only for the get path and not
>>> the set path?
>>
>> There's absolutely no reason for that, looks like a pure oversight?!
> 
> Cc Breno, he can explain better, but IIRC that's because most
> of set/get sockopt options expect user pointers to be passed in,
> and io_uring wants to use kernel memory. It's plumbed for
> SOL_SOCKET with sockptr_t, but there was a push back against
> converting the rest.
> 
> The implications are not the uapi side. For example, io_uring

s/not/on/

> get/setsockopt returns err / len in a cqe->res. We can't do
> that for SOL_SOCKET without the kernel pointer support, otherwise
> io-uring uapi would need to get hacky. E.g. you'd need to
> pass another user pointer is an SQE for socklen and read it
> after completion.
> 

-- 
Pavel Begunkov


