Return-Path: <io-uring+bounces-1571-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C25868A6A78
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 14:14:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F9C1B20E1D
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 12:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F34712AAE5;
	Tue, 16 Apr 2024 12:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PkY7Xf4x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D3812A17E;
	Tue, 16 Apr 2024 12:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713269685; cv=none; b=WzV0J3SlfqM0Lxiv0n9dr955tkJKXv5oXbNSU5iKdjkilNlM5gPg8R2MPzNQy+hlWhszcGE2qFpSDSOt8Ww/mfdii0RWHESaQi/yPF5kNnGLUw1yse6ldyN1BybWbNVc4HTb5X3DdLe2Mvr+lfzLXRJ0fVoEbirTczBtiXRJVdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713269685; c=relaxed/simple;
	bh=hol50hjM5EWqYjKU4NtTrYjYZ5fzd3INkYnC5xnEL/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=exRYNqGFdWgGIB+xxoY44sAp0SRqa6s0aZL5Jr4VXomCpIpAt45L8tlctifINFE1zYhmZteDKIveLE0hBNCt1S8f1rVshTJQ/leW8t03+/F6V2bfJ20ttnirCLN/ziCprhVTrzlRbA9Bs+JFB64+RP1qySBXrVS802lD0JjvM64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PkY7Xf4x; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-56e78970853so8230398a12.0;
        Tue, 16 Apr 2024 05:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713269682; x=1713874482; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KT7gjx9AcYHcAZTzCmk7R+KsrOIiQIdaN+CkeD30L88=;
        b=PkY7Xf4x/5TDHzcv1RIx26s8oHFDNC5uu1ohymqQll71ccqDJcvkG3hcD7JP1uzsbo
         /DXQqhYZVQDhcrMB1AR/FRk9AsaMNLKUfdemKYiZdd6q/MS/Ee0p2rnJRxxfU4Qm3sZC
         /A2MaoF7pIBpOmEsiBAxK2ZmWZijR/31bjfC2/mn/qTC/cHMD6et6gRpWpxP2dT11AvB
         +maAJ3TWt1f1JGsUAa7od5auvKE9RPJ776j95T83LNjN8J92LQdpsiwYe337/0AsggUO
         7d4z1MvZNtP/fIUwHU+YslmghOjOaqKpz/sYf1RbdgImDhuBvdlqUr0TUvxSIPTvaoAq
         gpMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713269682; x=1713874482;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KT7gjx9AcYHcAZTzCmk7R+KsrOIiQIdaN+CkeD30L88=;
        b=jqLQefQVdYW08QqQGwme4mCZBRFbP3pB5HCDYlcmrDfs4+Wt8pNw0912VlOfLtEKEL
         9Grr9THvPcbH6en+E/jj1K8mD6aP2wuzFwOL05XIw0OTRiT8l95SIwkKhcc5fmir8ns6
         aZhrRJXKTjIwDk9gzHLc/aALnFtuwmst5VVbZ2ndGdMNHNhimnxYEEOXqFQ8H9JLMChg
         Yc8jS+LfU4GFq9GgvvB52qwZk5yhP0DVWj5lgzGxDzMhE6hSUZkYP5lWmn7zSdU8jVFB
         YDyORJsXs5y3tfuxYVupzpsULUGaNOmKxMfZYTOrqMhFQ6FIpXLUcmtP743P+TGWkCYL
         1nBg==
X-Forwarded-Encrypted: i=1; AJvYcCX98FcH3j7yApnmP9ghImJdLhSRt2K42KSA9JQ8a3hjTdqU1dO3SqdOUB480Yrz0T4ZjnWdhYUBdRCojvWdHgwD2dw8UTAszR8=
X-Gm-Message-State: AOJu0YyZBiG8ln0QqewJWOiJKB6bTaBgdBwCMKsXQB0gJOl9eNQQv3oX
	RTNE22RAUBJVcGsQoPxtT2CSy7SonAiDgREL6ZcZ989P+Fcd1Cv4
X-Google-Smtp-Source: AGHT+IH4LAD5RBP3yBTLhH6zZ3U1I6MTyMKMYfZjU/OjRnBTo09GO8Lyhce79GFl9bh9OBzfnCyM7Q==
X-Received: by 2002:a17:907:844:b0:a4e:946a:3b0a with SMTP id ww4-20020a170907084400b00a4e946a3b0amr1982808ejb.34.1713269682092;
        Tue, 16 Apr 2024 05:14:42 -0700 (PDT)
Received: from [192.168.42.121] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id jw10-20020a170906e94a00b00a523be5897bsm5378459ejb.103.2024.04.16.05.14.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 05:14:41 -0700 (PDT)
Message-ID: <d56d21d5-f8c2-435e-84ca-946927a32197@gmail.com>
Date: Tue, 16 Apr 2024 13:14:48 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] WARNING: CPU: 5 PID: 679 at io_uring/io_uring.c:2835
 io_ring_exit_work+0x2b6/0x2e0
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
 Changhui Zhong <czhong@redhat.com>
Cc: Linux Block Devices <linux-block@vger.kernel.org>,
 io-uring <io-uring@vger.kernel.org>
References: <CAGVVp+WzC1yKiLHf8z0PnNWutse7BgY9HuwgQwwsvT4UYbUZXQ@mail.gmail.com>
 <06b1c052-cbd4-4b8c-bc58-175fe6d41d72@kernel.dk> <Zh3TjqD1763LzXUj@fedora>
 <CAGVVp+X81FhOHH0E3BwcsVBYsAAOoAPXpTX5D_BbRH4jqjeTJg@mail.gmail.com>
 <Zh5MSQVk54tN7Xx4@fedora> <28cc0bbb-fa85-48f1-9c8a-38d7ecf6c67e@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <28cc0bbb-fa85-48f1-9c8a-38d7ecf6c67e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/24 12:38, Jens Axboe wrote:
> On 4/16/24 4:00 AM, Ming Lei wrote:
>> On Tue, Apr 16, 2024 at 10:26:16AM +0800, Changhui Zhong wrote:
>>>>>
>>>>> I can't reproduce this here, fwiw. Ming, something you've seen?
>>>>
>>>> I just test against the latest for-next/block(-rc4 based), and still can't
>>>> reproduce it. There was such RH internal report before, and maybe not
>>>> ublk related.
>>>>
>>>> Changhui, if the issue can be reproduced in your machine, care to share
>>>> your machine for me to investigate a bit?
>>>>
>>>> Thanks,
>>>> Ming
>>>>
>>>
>>> I still can reproduce this issue on my machine?
>>> and I shared machine to Ming?he can do more investigation for this issue?
>>>
>>> [ 1244.207092] running generic/006
>>> [ 1246.456896] blk_print_req_error: 77 callbacks suppressed
>>> [ 1246.456907] I/O error, dev ublkb1, sector 2395864 op 0x1:(WRITE)
>>> flags 0x8800 phys_seg 1 prio class 0
>>
>> The failure is actually triggered in recovering qcow2 target in generic/005,
>> since ublkb0 isn't removed successfully in generic/005.
>>
>> git-bisect shows that the 1st bad commit is cca6571381a0 ("io_uring/rw:
>> cleanup retry path").
>>
>> And not see any issue in uring command side, so the trouble seems
>> in normal io_uring rw side over XFS file, and not related with block
>> device.
> 
> Indeed, I can reproduce it on XFS as well. I'll take a look.

Looking at this patch, that io_rw_should_reissue() path is for when
we failed via the kiocb callback but came there off of the submission
path, so when we unwind back it finds the flag, preps and resubmits
the req. If it's not the case but we still return "true", it'd leaks
the request, which would explains why exit_work gets stuck.

-- 
Pavel Begunkov

