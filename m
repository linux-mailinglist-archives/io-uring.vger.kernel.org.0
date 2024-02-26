Return-Path: <io-uring+bounces-735-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF5786798E
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 16:09:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AAD21F26EBE
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 15:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25E6212CDB4;
	Mon, 26 Feb 2024 14:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="S2jkrF3Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40A760274
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 14:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708959172; cv=none; b=HRABfIbcD4NvTzbVl/2WeMTjalzrd++Wwl6siYIwvzS7zz4mOoZIAGDW6RYmo14TYXarIv7VFW9huLXwgLlwX7VcTArsRTCL3wWcvrSbhLw0JNM2V08REOXyCugI+YfYtpxAGm5xyXgK+sHez7fJqhgB/t5nI60vVWUHSuvJfME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708959172; c=relaxed/simple;
	bh=ErvHoco1qnulscSS7KNXcvax/EXBP4RWvSgSfKVox1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RFC/QElbKGtrfpaQtTLy+BqNQCX1RniOPXbol6JIc1SkIJjlNfq9hcwXwtCETaH/6BFyYW8ShpthHyne8NWr8alQnEGJWCs0yhWOG3w/c1+jUyEhR2Up1hCMhLYKvUm5zHsOFI+33YdLdI0J+4ED5Gza1/bSHlgCA5G+yzly2J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=S2jkrF3Y; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7c495be1924so48616539f.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 06:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708959168; x=1709563968; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lnXFvmo78lPuxsh3JgcHz+BBn7RAWjZbjmmyDiaIOro=;
        b=S2jkrF3Y0nKdTMf5ZPw4WjFF5TK2YoQDD3ZpnBXQEqwOtfWEHUNsQKCWRj92MfWzuH
         Wg2HSMWZ4N4HIfBO6W7fn0xtMzE26D4xLmTdYKD7UzRFKtU8xVIBoLQFny35dnMqg3cJ
         cgNAX9/aHPxsvGyw8VuVgNiNVhrbt2KiRvbkICPao3gfqaLPU2eXVJOmLTG61/e41pqT
         UxDBfIY23yXVNr5wbOK60rtX4Y6E9+fSkKiBnIkbhB1uvBxWXFy2xkQkiowRpOZtuQgd
         3Gqb33ShLjadbxME14gMOWIdkHMhwgYF7WrgaZyJgNj+qeK7IpGPZMv0oo1pHikOIBlh
         x1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708959168; x=1709563968;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lnXFvmo78lPuxsh3JgcHz+BBn7RAWjZbjmmyDiaIOro=;
        b=eb32T8HZkDymxk+pQF1H12fJUmUQUkgDk5H1fNrOEnsw8hju+kjq5KyJUPVgv0poG8
         UUCRHBeHShj51+XcM9k9AJWnPd479MXK6CPvChwHiNAZLFVl0KRBf8/amFRFv0rHvR9t
         SzYD5hNDozEQONGJMI7pAPsnAJbX8fbBaDk2xYGFA8qClW60ZIqXgKqNHoMWmYdE8xuM
         o6s8xarkS2X07blGxRUwl7/+4WWOdKJCgvWpm5RRBFHvFFa7RMAfho5XMgxES901oCde
         gRiUv36yW/N1/+Yi+GnvN9nlJPOHtKhuYic0haXztHmd81RGcpV4ADuBYz8ncrC0HQz2
         oQpg==
X-Gm-Message-State: AOJu0Yw3lBSs2Lu8ZGpeQ9nS725wEemDwJmIVC1uHJz5/jcEltFjXjz8
	Qxov4Tz1gOquor5gDZiHvXoUnwQBVf5ezWI1Z4Vr6BC3BmpJQsceFhLceKUluwY=
X-Google-Smtp-Source: AGHT+IEqhHF2NDizByrNZ5XigPkjRG/e9TjEbu52+zIqtAKbu7QC0d1Nk90But2vlscKbVs0AiaCCg==
X-Received: by 2002:a05:6602:38d:b0:7c7:8933:2fec with SMTP id f13-20020a056602038d00b007c789332fecmr6654128iov.2.1708959167962;
        Mon, 26 Feb 2024 06:52:47 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id m8-20020a056638270800b00474420a484esm1292694jav.98.2024.02.26.06.52.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:52:47 -0800 (PST)
Message-ID: <bb41b293-4b7d-4d12-a991-8b76ed057cee@kernel.dk>
Date: Mon, 26 Feb 2024 07:52:46 -0700
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
To: Pavel Begunkov <asml.silence@gmail.com>,
 Dylan Yudaken <dyudaken@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20240225003941.129030-1-axboe@kernel.dk>
 <20240225003941.129030-9-axboe@kernel.dk>
 <CAO_Yeohfx1d1Hdopu=0-b3-dKVM1By=unnhHFQHsqCwH=HJSvA@mail.gmail.com>
 <d6d4052c-8461-44c9-a207-ebcf8cff52ab@kernel.dk>
 <e0a32c54-07bc-4f12-ae76-021a4d17e84f@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e0a32c54-07bc-4f12-ae76-021a4d17e84f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/24 7:24 AM, Pavel Begunkov wrote:
> On 2/26/24 13:42, Jens Axboe wrote:
>> On 2/26/24 3:59 AM, Dylan Yudaken wrote:
>>> On Sun, Feb 25, 2024 at 12:46?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> If we have more data pending, we know we're going to do one more loop.
>>>> If that's the case, then set MSG_MORE to inform the networking stack
>>>> that there's more data coming shortly for this socket.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>   io_uring/net.c | 10 +++++++---
>>>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>>> index 240b8eff1a78..07307dd5a077 100644
>>>> --- a/io_uring/net.c
>>>> +++ b/io_uring/net.c
>>>> @@ -519,6 +519,10 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>>>>          if (!io_check_multishot(req, issue_flags))
>>>>                  return io_setup_async_msg(req, kmsg, issue_flags);
>>>>
>>>> +       flags = sr->msg_flags;
>>>> +       if (issue_flags & IO_URING_F_NONBLOCK)
>>>> +               flags |= MSG_DONTWAIT;
>>>> +
>>>>   retry_multishot:
>>>>          if (io_do_buffer_select(req)) {
>>>>                  void __user *buf;
>>>> @@ -528,12 +532,12 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>>>>                  if (!buf)
>>>>                          return -ENOBUFS;
>>>>
>>>> +               if ((req->flags & (REQ_F_BL_EMPTY|REQ_F_APOLL_MULTISHOT)) ==
>>>> +                                  REQ_F_APOLL_MULTISHOT)
>>>> +                       flags |= MSG_MORE;
>>>>                  iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_SOURCE, buf, len);
>>>>          }
>>>
>>> This feels racy. I don't have an exact sequence in mind, but I believe
>>> there are cases where between
>>> the two calls to __sys_sendmsg_sock, another submission could be
>>> issued and drain the buffer list.
>>> I guess the result would be that the packet is never sent out, but I
>>> have not followed the codepaths of MSG_MORE.
>>
>> This is true, but that race always exists depending on how gets to go
>> first (the adding of the buffer, or the send itself). The way I see it,
>> when the send is issued we're making the guarantee that we're going to
>> at least deplete the queue as it looks when entered. If more is added
>> while it's being processed, we _may_ see it.
>>
>> Outside of that, we don't want it to potentially run in perpetuity. It
>> may actually be a good idea to make the rule of "just issue what was
>> there when first seen/issued" a hard one, though I don't think it's
>> really worth doing. But making any guarantees on buffers added in
>> parallel will be impossible. If you do that, then you have to deal with
>> figuring out what's left in the queue once you get a completion withou
>> CQE_F_MORE.
>>
>>> The obvious other way to trigger this codepath is if the user messes
>>> with the ring by decrementing
>>> the buffer counter. I do not believe there are any nefarious outcomes
>>> - but just to point out that
>>> REQ_F_BL_EMPTY is essentially user controlled.
>>
>> The user may certainly shoot himself in the foot. As long as that
>> doesn't lead to a nefarious outcome, then that's not a concern. For this
>> case, the head is kernel local, user can only write to the tail. So we
>> could have a case of user fiddling with the tail and when we grab the
>> next buffer (and the previous one did not have REQ_F_BL_EMPTY set), the
>> ring will indeed appear to be empty. At that point you get an -ENOBUFS
>> without CQE_F_MORE set.
> 
> A side note, don't forget that there are other protocols apart
> from TCP. AFAIK UDP corking will pack it into a single datagram,
> which is not the same as two separate sends.

Yeah, should really have labeled this one as a test/rfc kind of patch. I
wasn't even convinced we want to do this uncondtionally for TCP. I'll
just leave it at the end for now, it's a separate kind of discussion
imho and this is why it was left as a separate patch rather than being
bundled with the multishot send in general.

-- 
Jens Axboe


