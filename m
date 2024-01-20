Return-Path: <io-uring+bounces-439-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 904438335A7
	for <lists+io-uring@lfdr.de>; Sat, 20 Jan 2024 19:19:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 409DD1F22010
	for <lists+io-uring@lfdr.de>; Sat, 20 Jan 2024 18:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 177911172D;
	Sat, 20 Jan 2024 18:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WGcc8Jl+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4804111A5;
	Sat, 20 Jan 2024 18:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705774763; cv=none; b=JkApTFJLlzIq0TvLm0UwqNMh3of29c5hFKx3wVoHE6a1sYvtMwqgZaEphNFmx/2YfcSWQxOrDx2Ws5k+jFUek4xayvbx7ElNfSQpZ7fUwOVnXNuR/8g5IsmR3kk4eDM4YRp6tPj9JZemY86zgMPX3BWWy9uAPvJ2zi3eqftLoZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705774763; c=relaxed/simple;
	bh=wNAHZ7BQJGIl/nkxvr0xvcR4L7QDszxCr3sMQYA2oyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HaMduoTvqQCU6dO+cHWlcaal8sQvXjJbcQezjy05th3RJfnrZk4+F8m8Ou2/V4iJR7OkyWYiPBHqD3SxRq4IxkW00S+QB2dIyacJDjzFLC2UhGJaUZf6Ah/59UoJT/she4Vr5t19JDRxqo/aLrM24dxl9Q5KPjOLpEmBJz14Vpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WGcc8Jl+; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6dbd0be5f9aso33319b3a.2;
        Sat, 20 Jan 2024 10:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705774761; x=1706379561; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YTRrcFV/jUUF4sC38uPPLRonvSDfiPvNd9MN0RZDRFc=;
        b=WGcc8Jl+cPDtiPnHQ+Xc7UZCyCvdVyZcvjP6Rebk1c21fL3iR6Po78RzzBLD+uhg4r
         6t+z1vdLgF/fA1aLcvRY84zsqFkQDKmGATOF2iOipTXz0OGW9rHDah6TUtUlsMJuzL9F
         YplWXGjw6xSniRoCOcXFHeOR9mZBfa+HZjoYxW5aWPXM1bco5k36qL9Srf/wrUsFy/am
         m96gPJiBYJAP5u7hTsGZFc+mJzS4ZcWZkr8WJqmcsKAPaGr8agTCMsh8X0Cx9sWvb70s
         o+miIK/WEFqEMwgLTEMrvACg9ra7KHf92dFJXN/M/b74x24e2bhnro+Z84y2IomiQYDu
         qToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705774761; x=1706379561;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YTRrcFV/jUUF4sC38uPPLRonvSDfiPvNd9MN0RZDRFc=;
        b=thAlETn16lMU8NlKAaVXmfkS6ivaOT1jrqQ5LulAw6+1H713YokUN4nS92Opu7UgEQ
         j0EU4PftSbxNwUh3L4cLRMa9bC2U96OxtplXcl5e+mdbQUpMkU6wSrY7bU7Kpv3LnKiX
         v9xRkgbU8uv7NHJ4InJH6v0zZUCIE9rglM9GBXxdAyOrkncWeLu1FCb3rjDP2T6ttz/P
         mgB23TpvzTgeDyWSkcIO9/CFFXeRNYFR/arpvFyt9XOLPAF1aUlP0BNArfQvzy1Jz9lq
         Fb62YaK1MIiG0XkjWP2ls94ww+wLIbWY087mfmjaUl5SOEAKDO9AjSQGvLrfwEGQJnnZ
         hbmQ==
X-Gm-Message-State: AOJu0YzPR64cMjDJy1sBXc4dzensYL0uNlnJUVH5j73mFxJV/KAKN3SW
	PHC91w1Zm1XLF+6B1Gr+F9WxaHoOt6GJ88gDyfDchV6b7RI/pm5a
X-Google-Smtp-Source: AGHT+IEFqETe+AEjdKstE9q1UL4BqitOZwIb5KJJK8FpOO5jKwjwxsqH48LIENw8MLMuF+FwIvLV7Q==
X-Received: by 2002:a62:cd07:0:b0:6d9:a658:16a9 with SMTP id o7-20020a62cd07000000b006d9a65816a9mr754231pfg.69.1705774760871;
        Sat, 20 Jan 2024 10:19:20 -0800 (PST)
Received: from ?IPV6:2406:7400:94:ee42:e61e:cfc5:9906:904b? ([2406:7400:94:ee42:e61e:cfc5:9906:904b])
        by smtp.gmail.com with ESMTPSA id d5-20020a056a00244500b006da19433468sm7008275pfj.61.2024.01.20.10.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jan 2024 10:19:20 -0800 (PST)
Message-ID: <3585159b-12f1-43ec-bd85-0253a0534c0e@gmail.com>
Date: Sat, 20 Jan 2024 23:49:15 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] iouring:added boundary value check for io_uring_group
 systl
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, corbet@lwn.net, jmoyer@redhat.com,
 asml.silence@gmail.com, akpm@linux-foundation.org, bhe@redhat.com,
 ribalda@chromium.org, rostedt@goodmis.org, sshegde@linux.vnet.ibm.com,
 alexghiti@rivosinc.com, matteorizzo@google.com, ardb@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20240120144411.2564-1-subramanya.swamy.linux@gmail.com>
 <f48e47b5-0572-4f84-b165-5a9e91788c57@kernel.dk>
From: Subramanya Swamy <subramanya.swamy.linux@gmail.com>
In-Reply-To: <f48e47b5-0572-4f84-b165-5a9e91788c57@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Jens,

On 20/01/24 22:31, Jens Axboe wrote:
> On 1/20/24 7:44 AM, Subramanya Swamy wrote:
>> /proc/sys/kernel/io_uring_group takes gid as input
>> added boundary value check to accept gid in range of
>> 0<=gid<=4294967294 & Documentation is updated for same
> This should have:
>
> Fixes: 76d3ccecfa18 ("io_uring: add a sysctl to disable io_uring system-wide")
  added fixes to commit msg in v3
>> diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
>> index 6584a1f9bfe3..a8b61ab3e118 100644
>> --- a/Documentation/admin-guide/sysctl/kernel.rst
>> +++ b/Documentation/admin-guide/sysctl/kernel.rst
>> @@ -470,10 +470,8 @@ io_uring_group
>>   ==============
>>   
>>   When io_uring_disabled is set to 1, a process must either be
>> -privileged (CAP_SYS_ADMIN) or be in the io_uring_group group in order
>> -to create an io_uring instance.  If io_uring_group is set to -1 (the
>> -default), only processes with the CAP_SYS_ADMIN capability may create
>> -io_uring instances.
>> +privledged (CAP_SYS_ADMIN) or be in the io_uring_group group in order
> privileged.
fixed  typo in v3

-- 
Best Regards
Subramanya


