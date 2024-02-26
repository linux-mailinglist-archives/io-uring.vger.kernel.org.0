Return-Path: <io-uring+bounces-734-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75C66867974
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 16:06:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A76BD1C2AC7A
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 15:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE135131745;
	Mon, 26 Feb 2024 14:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P9XpCL3J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CF312C529
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 14:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958686; cv=none; b=AeeF6jdObQeD0dRUoIIHvyr1OrBWJDcdpMw7DrSkHVYqa8ugcq3KvnF9sxKlwMz+ydmj6hrCwZGT1RDWZLrM4iqvqTRVgK13yEIvFThFLXZy8TJhFZbqJcX0pxcVV28zR1lA6IDnHEDIx3ZdAioRy4uzrWSYw+q7O33jJNTzSio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958686; c=relaxed/simple;
	bh=EsmEg2uMuGV4ZKVNtKjpOdftmQ/083z55m1pa98XKyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FRasC/LTjySLfdQkDFD8tnwosAYIYenZitWDBcIV7aq/0ya4DHvoR9bTU6l+z/1oQgzIlZaIoQK9xSrdlu70NeVzTC75y9RA3fu/n/69SXsXwAO+zEdg0VYUytHu9Lbv0D1SuS194UBVnjYkZNX2moo2FacwDyy/m477eCzvTqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P9XpCL3J; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d22fa5c822so46076981fa.2
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 06:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958683; x=1709563483; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cwN166iRhqX2mf7M/fiVt9ocBdXBhiC51NmTIUy4fPc=;
        b=P9XpCL3JS+y7PgmZ9LfUw0MUm9gLU1CviyTdKpICTX6btwq7AiGvMoXU5jRChjw9Q5
         AONQoefzYvSFekmPoiUo0DOOF8KLwhD2u7eRk6469doAhO55qsA6LGiB/aDoKCHIOgpd
         k8P8ojSvat0dDVVaKmgS5+poeG6O+ZCAAiYGrSM3Xz8zv7JZXA4ofG5xcEEbwXdtNZXd
         i/9pivAKLo7GsHgS3jERPoc6DMZV4FI6PO1wBBBb3FBlqPUIhGUJ9a8dNerB/yWEhS/a
         DLu7FlB3pYUgu4aPQ8xnfQxiOujZ7OATffE+VzaOliWxR+m2HylmjWj6FoUEiAQe1K4z
         0MNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958683; x=1709563483;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cwN166iRhqX2mf7M/fiVt9ocBdXBhiC51NmTIUy4fPc=;
        b=WaSc4ZsHsaE+pfPK2ihyHaXBBHVXOqIPkl7Q5xwVueHNw9Nz03me7FwXviHh98Wvxs
         xwbXJWUDPq0ULRgUr5Nu7qfsoLWxfmzudzrMcxkUTUl+ecuF4ENJxCW2USvlVQArKV8j
         1FbKMgN1m7ebVTkXulwnj4Oqez/zAUcJA734P8tJsbkWV9cTXXNXtoK71x8+jAfOlr4n
         YRehet6uk0d4TsVR+rXy7IlhmE43be0hf14u01NlY0HchJQhK9XScojzdL4x5BsoAxE4
         2W4BNzWl8dgrn3kLxoGBZhSc0dkKltD4zHPvZhBmdZzKtG/StxPbI/euNmxmfKd6vZVb
         KFyQ==
X-Gm-Message-State: AOJu0Yz4iX6KAUH/nfquP1Dh5klvYZ5QgRaDuLljujqnnGLaEAAfOOk0
	k0KloUTMcwvWCtlB4rOjX621QxDEB5t7z4RGKTNBdu10M7EocJ6T
X-Google-Smtp-Source: AGHT+IEWq1DftyTRbeuVBIPA7zY/Um+gBPbVS99CrDac8189X4PTLepsS5Rb3n7IPSVbXIpjS/kg5g==
X-Received: by 2002:a2e:9798:0:b0:2d2:3853:1a61 with SMTP id y24-20020a2e9798000000b002d238531a61mr4537318lji.19.1708958682878;
        Mon, 26 Feb 2024 06:44:42 -0800 (PST)
Received: from [192.168.8.100] ([85.255.235.18])
        by smtp.gmail.com with ESMTPSA id fe3-20020a056402390300b00565a9c11987sm2307089edb.76.2024.02.26.06.44.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:44:42 -0800 (PST)
Message-ID: <e0a32c54-07bc-4f12-ae76-021a4d17e84f@gmail.com>
Date: Mon, 26 Feb 2024 14:24:50 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] io_uring/net: set MSG_MORE if we're doing multishot
 send and have more
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dyudaken@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20240225003941.129030-1-axboe@kernel.dk>
 <20240225003941.129030-9-axboe@kernel.dk>
 <CAO_Yeohfx1d1Hdopu=0-b3-dKVM1By=unnhHFQHsqCwH=HJSvA@mail.gmail.com>
 <d6d4052c-8461-44c9-a207-ebcf8cff52ab@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d6d4052c-8461-44c9-a207-ebcf8cff52ab@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/24 13:42, Jens Axboe wrote:
> On 2/26/24 3:59 AM, Dylan Yudaken wrote:
>> On Sun, Feb 25, 2024 at 12:46?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> If we have more data pending, we know we're going to do one more loop.
>>> If that's the case, then set MSG_MORE to inform the networking stack
>>> that there's more data coming shortly for this socket.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>   io_uring/net.c | 10 +++++++---
>>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>> index 240b8eff1a78..07307dd5a077 100644
>>> --- a/io_uring/net.c
>>> +++ b/io_uring/net.c
>>> @@ -519,6 +519,10 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>>>          if (!io_check_multishot(req, issue_flags))
>>>                  return io_setup_async_msg(req, kmsg, issue_flags);
>>>
>>> +       flags = sr->msg_flags;
>>> +       if (issue_flags & IO_URING_F_NONBLOCK)
>>> +               flags |= MSG_DONTWAIT;
>>> +
>>>   retry_multishot:
>>>          if (io_do_buffer_select(req)) {
>>>                  void __user *buf;
>>> @@ -528,12 +532,12 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>>>                  if (!buf)
>>>                          return -ENOBUFS;
>>>
>>> +               if ((req->flags & (REQ_F_BL_EMPTY|REQ_F_APOLL_MULTISHOT)) ==
>>> +                                  REQ_F_APOLL_MULTISHOT)
>>> +                       flags |= MSG_MORE;
>>>                  iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_SOURCE, buf, len);
>>>          }
>>
>> This feels racy. I don't have an exact sequence in mind, but I believe
>> there are cases where between
>> the two calls to __sys_sendmsg_sock, another submission could be
>> issued and drain the buffer list.
>> I guess the result would be that the packet is never sent out, but I
>> have not followed the codepaths of MSG_MORE.
> 
> This is true, but that race always exists depending on how gets to go
> first (the adding of the buffer, or the send itself). The way I see it,
> when the send is issued we're making the guarantee that we're going to
> at least deplete the queue as it looks when entered. If more is added
> while it's being processed, we _may_ see it.
> 
> Outside of that, we don't want it to potentially run in perpetuity. It
> may actually be a good idea to make the rule of "just issue what was
> there when first seen/issued" a hard one, though I don't think it's
> really worth doing. But making any guarantees on buffers added in
> parallel will be impossible. If you do that, then you have to deal with
> figuring out what's left in the queue once you get a completion withou
> CQE_F_MORE.
> 
>> The obvious other way to trigger this codepath is if the user messes
>> with the ring by decrementing
>> the buffer counter. I do not believe there are any nefarious outcomes
>> - but just to point out that
>> REQ_F_BL_EMPTY is essentially user controlled.
> 
> The user may certainly shoot himself in the foot. As long as that
> doesn't lead to a nefarious outcome, then that's not a concern. For this
> case, the head is kernel local, user can only write to the tail. So we
> could have a case of user fiddling with the tail and when we grab the
> next buffer (and the previous one did not have REQ_F_BL_EMPTY set), the
> ring will indeed appear to be empty. At that point you get an -ENOBUFS
> without CQE_F_MORE set.

A side note, don't forget that there are other protocols apart
from TCP. AFAIK UDP corking will pack it into a single datagram,
which is not the same as two separate sends.

-- 
Pavel Begunkov

