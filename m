Return-Path: <io-uring+bounces-7299-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1554A755C6
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 11:58:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37AA816FD96
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 10:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16211AF0BC;
	Sat, 29 Mar 2025 10:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l7wk2xva"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070CE1AAA23
	for <io-uring@vger.kernel.org>; Sat, 29 Mar 2025 10:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743245926; cv=none; b=t45ABDenF0FGcDh6u/S5/KVX+kAD+kdncOwyF0+91M6bqM3+PAJ0uiAkk0TZ8EXx/X4VzdWrjbO/nzMItwWBfMmB/gZ7en7OKAgOChr4vw5ShLJ/KXBS4rlWrtm+qlaCaZGI1mV2I+4KucB6uYvA9BZSTDh8KIgrKgRwRXF4MPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743245926; c=relaxed/simple;
	bh=AV24VZAedHgd+CrCSM//UN72yadtybCKBO7FXYjWuRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ImVTEQ90yK36u4JFQ1xHVrHM6Mv9YfEkQiSQCrvH/MI4Ea2Cz4m6/6QEgU1zChPzzEXmFdGraMVbBOvFA32P7SJW3WHOx9/gajQpi+v9QrixAn3DkbGpx732qDrxUkfXGk4Ih5KTn3Y27/y/FRLZdsad/qR3S/aSR/OfknnJ95s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l7wk2xva; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5eb92df4fcbso5453480a12.0
        for <io-uring@vger.kernel.org>; Sat, 29 Mar 2025 03:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743245923; x=1743850723; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3B8eYCYuZD1M4vwkveoBR1NESYf659GORoVhce6klko=;
        b=l7wk2xvaxJQhKcjvfbWWFDND6Bn1y3fqXT2/UfTb4tXKzB6YKyQDtgJuE7HJWH6Q25
         ytg4ydAhAlWCAT7YzvKmXtJreDSBnIefguooCoX+JCM+sZF2bihWVX2YtcuiY3gPOm5V
         PEct0EIBkIWL+C5rho4hY8HeYDZoEHlWbT6yDkZZ/xL08ZLcNUhOOAuWJHJ7uifdvfD7
         loxHDxlW574proD9upwl0Io5ZLbcNtINMXtdUZ66CFdIeARPVCOowA4VmoEMx+sNFmXH
         XI9rCZw1Yl/Ku4OcWZEZchJ7XwVXQVZDL8nbu4qBawh2CaCHtj+iBbyeJuKzSCl5Pv4U
         BYmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743245923; x=1743850723;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3B8eYCYuZD1M4vwkveoBR1NESYf659GORoVhce6klko=;
        b=nLWqiH7OtLJPtM1ZDwP6p9J0EEv6YGl1hIYu76Wa//Ysjauaa2f2+UvWzMpBuvr+N1
         wViZqzmmxjsoNmZ0GhQanGOroMPMKhDSvK0RcvisLxnZAnjuM0ZSssAW8zu6UkrVsZgU
         B0kZt7ux8WmSBrORwk+YdBr7bzgmEGlVOr45anZ2VzBmZN8so+jIbqrWohFPcMj6lUv6
         WE3fCLCz4I0GN2zcvq+JvLg4zXg+4x9JHY+6wST/tHZpPDs+yhT7rkoGDrzTxTmWI7aI
         rHgOM6809UGL246Hm+OsD5kQj3lGrCNgPIBR60YZ7L24hKql1rGL0rmdjZAzi2BG8K2h
         sVzw==
X-Forwarded-Encrypted: i=1; AJvYcCW2PcwqXE7Lw+JqJO/PeB4aIRaVqo/xn9j0FU1ac8bWvJY9fSvevRI1wozi27V1LLGiKUmMEJm4wA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7ZECQ7Ou6HGmnqJ0heHcrm5xXDtSZe+utio1fpB1F6ZktzzSn
	D1p/NDScxblDcEWQtEb4HtzG+TRIF/Ro+iAZIsL0HaGMCZCxb0jl
X-Gm-Gg: ASbGncsZnivGZl3/AnoZa+imSP1JiytUgXNEfFvCvRkszZ8Mzpb/u8C/ZDAHMP0EK9D
	RCcJLzFP5Yz2Y5AS2/82Szfg3Puf/ynSTROP2ks9HEw1fiTw43PAs4HZZBaJBq3PtBJfEHugWr6
	EKan+Uf6pkEChLhcOgQ8kC7Q6wffXxFZ6EC4e8Yc3F1ZbOWtPnkXHVBJEf2l+Ll/rf/Jjk/H9P/
	tJd2dbZHSkXX1W6Xg9Jr9lFCsIfnqvCwDseN9hHVd4NnvrsanSj5/fH1tqpP79cNpViphm+2DVL
	/FvF22SRYAxi+TPMAh12G5FllamRfy3cwGoqHU2QKg8RmAexwS0Tr2I=
X-Google-Smtp-Source: AGHT+IGlEcB7RwJCh7dSG0owMPT+1UUW3RpCWIRyiDuGtLBv93j5EovmmmKfzQA4dArUI5Y9XKp4Ig==
X-Received: by 2002:a17:907:da6:b0:ac4:5fd:6e29 with SMTP id a640c23a62f3a-ac738aebfbfmr194743366b.26.1743245922929;
        Sat, 29 Mar 2025 03:58:42 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71927affasm315703966b.64.2025.03.29.03.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Mar 2025 03:58:42 -0700 (PDT)
Message-ID: <c97c1d57-ab3c-49a0-8c08-7160ad66ea88@gmail.com>
Date: Sat, 29 Mar 2025 10:59:28 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SOCKET_URING_OP_GETSOCKOPT SOL_SOCKET restriction
To: Breno Leitao <leitao@debian.org>
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
 io-uring <io-uring@vger.kernel.org>
References: <a41d8ee5-e859-4ec6-b01f-c0ea3d753704@samba.org>
 <272ceaca-3e53-45ae-bbd4-2590f36c7ef8@kernel.dk>
 <8ba612c4-c3ed-4b65-9060-d24226f53779@gmail.com>
 <3b59c209-374c-4d04-ad5d-7ad8aa312c0b@kernel.dk>
 <e5cac037-f729-4d3a-9fe6-2c9ba9d55894@gmail.com>
 <876b1590-0576-40f8-af9a-bcd135374320@gmail.com>
 <20250328-monumental-taupe-malamute-d1c54b@leitao>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250328-monumental-taupe-malamute-d1c54b@leitao>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/25 18:22, Breno Leitao wrote:
> Hello Pavel,
> 
> On Fri, Mar 28, 2025 at 05:21:06PM +0000, Pavel Begunkov wrote:
>> On 3/28/25 17:18, Pavel Begunkov wrote:
>>> On 3/28/25 16:34, Jens Axboe wrote:
>>>> On 3/28/25 9:02 AM, Pavel Begunkov wrote:
>>>>> On 3/28/25 14:30, Jens Axboe wrote:
>>>>>> On 3/28/25 8:27 AM, Stefan Metzmacher wrote:
>>> I remember Breno looking at several different options.
>>>
>>> Breno, can you remind me, why can't we convert ->getsockopt to
>>> take a normal kernel ptr for length while passing a user ptr
>>> for value as before?
>>
>> Similar to this:
>>
>> getsockopt_syscall(void __user *len_uptr) {
>> 	int klen;
>>
>> 	copy_from_user(&klen, len_uptr);
>> 	->getsockopt(&klen);
>> 	copy_to_user(len_uptr, &klen);
>> }
> 
> We have a few limitations if I remember correct:
> 
> getsockopt() callback expects __user pointers:
> 
> 	int             (*getsockopt)(struct socket *sock, int level,
> 			int optname, char __user *optval, int __user *optlen);
> 
> 
> So, you cannot copy the memory content and call ->getsockopt() with
> kernel memory.

Right, I'm rather asking about changing the callback to pass
a kernel pointer and make the caller to do the copy_to_user
if needed.

> A solution was to use sockptr, as done by setsockopt(), but, that was
> discouraged.
> 
> Another important thing, some getsockopt() callback changes the pointer,
> so, doing copy_to_user() directly in the getsocktopt callback, which
> would break your approach above.

Do you mean writing to it? That's why the snippet passes a kernel
_pointer_ to length. Did I misunderstand you?

> I understand that the next steps here are:
> 
>   1) Make getsockopt() operate with either userspace or kernel buffer.
>      a) This buffer needs will be written and read on both side. I.e, you
>      pass data in the buffer from userspace to kernel space, and kernel
>      will overwrite that buffer in kernelspace.
> 
>      In other words, this is a read-write buffer (which is not something
>      we have in iovec IIRC).
> 
>   2) Call the same callbacks from io_uring subsystem using kernel memory
> 
>   3) Regular syscalls will continue to user userspace memory.
> 

-- 
Pavel Begunkov


