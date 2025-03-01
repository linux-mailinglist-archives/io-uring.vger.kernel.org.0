Return-Path: <io-uring+bounces-6895-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7E3EA4A819
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:30:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65BB8189A045
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B785128819;
	Sat,  1 Mar 2025 02:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q85dqksK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5983A14F11E;
	Sat,  1 Mar 2025 02:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740796213; cv=none; b=Ga16lkufb2r59q8nT/X1Ha4KDRwXi121Rtlf6MgfPYkIJgI+UY/wIDebqLbsDzTIeE/g9crGOequvF4FBpGpwZNlBWitF2psc7Ox1snXAxPzHuiKqsQIO66TCFPboCyjNCsDffYD0oiMPAXuIWYF5WpObGZM1eH5wYnlVu2ZmtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740796213; c=relaxed/simple;
	bh=9tIX5thhpYwh28z/2Bwjdyep7WK8WiTG2cUxUzY8/8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mguLuNmjC5lKoDbPOHI/Nj4y3KxUIN+cAxIP/EGLy3GqkW2fCLgb3le/mX0E4YWrcRI5sdWkb5GsZ2IYjgeLdE2cjVWlGFINU4dPXs+1IM1Xdteo2Dpn05S7pphZUQVqAng7VfGRJwT4R2VvST92240ZWFnZspMr/1xsrYH+YLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q85dqksK; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aaf900cc7fbso482522266b.3;
        Fri, 28 Feb 2025 18:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740796209; x=1741401009; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eGoFze/haLSNG7MuxPQWfgouNX1yDVGtlhX94dlm3Vo=;
        b=Q85dqksKb3of42jvPlBfukgAQBUcDhKsAslUK4F2EUmLiKqDaOlOnzWl4X0JzbHs75
         IYvjJAIb3wx6AlRzvlZl1s4CgoxUHIPoQkOUeUhCGDuoUg1WYRkkSIrxWNlHT2kcBzK0
         MUvJVk8iRscOBZzYOM4EKplrXrHmSt8nFybRvvU7ibb6oOFmbuqbWLKB4/NuDUZqv9Ej
         zYOWkxzFLTCPJ8UaJGo8tEGIOrfxpUsSsRGiy1d3a+ngZDTdSEOkBrNA0KD9JTT5MV9Z
         A5yZcTojerF4ZBsL0FOpwYM3B+J0FVrWuMAGfs7ccQvoFJ7/tzIMaaQxBWw8JZfp4F/q
         0jVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740796209; x=1741401009;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eGoFze/haLSNG7MuxPQWfgouNX1yDVGtlhX94dlm3Vo=;
        b=lfGHzPpESOhJGUxRlVjm7YNrzefaH1jvyje2IViWusN9Ei0zISvYizsIor5dKebxA6
         pV/AztPsZJjkYA437UEeV64WrKH3z/BTM9+/eA8KQlx1qNEUZnPbNdNGzKs9ZvEuH6LD
         EI32DTatWRBVVQ64cGEmesEohPzM/qb9CkCvE5VKok8KoNj1UqfpHAOMZSai1dxfAY7f
         HS5uzhV1za1PiGVBIYGBistSdaGYMYrCTW0+i0wLtzOJ46bkHXqiMZDGTcjoGru4rutO
         QjK6iM1kWYBYdP3xYStOz9G2LwZ7QXnKcXqSu6OTBqieCllZh5FsVPpGdISPVYNCoUEn
         W9Og==
X-Forwarded-Encrypted: i=1; AJvYcCX75R9Ohmf5Gmz79vm1IjHFBmfPvYNBHc9ttnX0f+HdSRMv1yWV31eABlFdwfdWg3tKyywYAMLOfamS0rY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEkowVAmEFeSwZqTTV9pe30dTdEiZwO++pkCpYij9hq5tWHj0T
	xE1BiIQNEAU5n0gWscSfD8BPXPgAX84EzmDHhGJttlnJLW5fv8fO3aYKcA==
X-Gm-Gg: ASbGnctL7nbmK+V1NFevVXtoIZ0aQTWdc3wuMz3aFWqMmebhqY87WeEjDCWDnbRtUod
	cjVrMYvKSJcDPR7q+viRT72iTs6imciLHKXj+iLdu1spwDfFGPX9ZAdzuCmsPXITnVUmCle/iJJ
	UcQAXzIQSutBjNzgta6QGwywR0/PUE6H9DvyPs/QEjod7xvOSYWFaYN0U/GVMjiGbZ/TpH5CiWs
	ICsW4xcXBOKLTknHdLsvSzH64VijZs4UkBRv1xs9EU+rprQWcnNC0M2s45zZcsVPvNqe8YMIvu5
	+YAlM/3HwxzVYOsbom2WrEamiTVEvfOw/8dgMMmc2gnVJHwCDJ24Jec=
X-Google-Smtp-Source: AGHT+IHd7E18Z/swSSl1I3t85oHgsp3SyTLuApXdSR64kx/HrNHepkL1Xw9YYHf2HOWfakmUUEubww==
X-Received: by 2002:a17:907:60d0:b0:ab7:f245:fbc1 with SMTP id a640c23a62f3a-abf261f9dffmr550078666b.3.1740796209515;
        Fri, 28 Feb 2025 18:30:09 -0800 (PST)
Received: from [192.168.8.100] ([148.252.144.117])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf4b7385ebsm76224866b.106.2025.02.28.18.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 18:30:07 -0800 (PST)
Message-ID: <f3033c30-8a0e-4a18-aeb8-82fa97020bc1@gmail.com>
Date: Sat, 1 Mar 2025 02:31:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/rsrc: declare io_find_buf_node() in header
 file
To: Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250301001610.678223-1-csander@purestorage.com>
 <86d5f210-d70f-4854-8ecf-eb771f26685a@gmail.com>
 <CADUfDZrOoSgT5n51N5=UFSum96mj2MAytQbJNbBVC1BJrmNVtA@mail.gmail.com>
 <76a9617b-b1c8-44b0-8355-948758f6e70a@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <76a9617b-b1c8-44b0-8355-948758f6e70a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/1/25 02:22, Jens Axboe wrote:
> On 2/28/25 7:04 PM, Caleb Sander Mateos wrote:
>> On Fri, Feb 28, 2025 at 5:45 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> On 3/1/25 00:16, Caleb Sander Mateos wrote:
>>>> Declare io_find_buf_node() in io_uring/rsrc.h so it can be called from
>>>> other files.
>>>>
>>>> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
>>>> ---
>>>>    io_uring/rsrc.c | 4 ++--
>>>>    io_uring/rsrc.h | 2 ++
>>>>    2 files changed, 4 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>>> index 45bfb37bca1e..4c4f57cd77f9 100644
>>>> --- a/io_uring/rsrc.c
>>>> +++ b/io_uring/rsrc.c
>>>> @@ -1066,12 +1066,12 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>>        }
>>>>
>>>>        return 0;
>>>>    }
>>>>
>>>> -static inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
>>>> -                                                 unsigned issue_flags)
>>>
>>> That's a hot path, an extra function call wouldn't be great,
>>> and it's an internal detail as well. Let's better see what we
>>> can do with the nop situation.
>>
>> I can add back inline. With that, there shouldn't be any difference to
>> the generated instructions for io_import_reg_buf().
> 
> Yeah, in general I don't like manual inlines, unless it's been proven
> that the compiler messes it up for some reason. If it's short enough
> it'll be inlined.

It will _not_ be inlined in this case.

-- 
Pavel Begunkov


