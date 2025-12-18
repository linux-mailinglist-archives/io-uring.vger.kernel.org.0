Return-Path: <io-uring+bounces-11221-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C8BD8CCDA6A
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 22:12:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 14C6D3038962
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 21:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB5B3352F9B;
	Thu, 18 Dec 2025 20:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="26V+nrVJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f67.google.com (mail-ot1-f67.google.com [209.85.210.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4532352959
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 20:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766090704; cv=none; b=kyCYDS15pnsqwjbsN0SzgqPdmF3GZ7Xkjl/KQavpM4O41qMxw56D6iaHhfw695e8WIA8wyNI7OZu3RuBgleplhVPpHAHCLKI3/n7LVB39gJJSgQx5kxL/mAtQF+obclYS/tdgpma29ZHF97jbbjh+nnmx7B72/NxECJFzvOwDU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766090704; c=relaxed/simple;
	bh=hxdyEoRAt3GAfwhKgxiNv1wl7oVIYwsDbSGze+lKbBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l4oppuWKnKpBYCdnFGN4rVscvkA6BB+9ESb8CE+Z1bBPLTt8ZDF7PPpNRcPZN63wF4k4Yp7O35ckcGYwE2SihsobLtTewyqV8L7Z2YT5H9dCCb04T1NUeJQpOqirlwDpUGQmM+2f4rrIhvOvnTDPbHEeadrMTmltak3OyJi/1Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=26V+nrVJ; arc=none smtp.client-ip=209.85.210.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f67.google.com with SMTP id 46e09a7af769-7c6cc366884so477058a34.1
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 12:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1766090699; x=1766695499; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fBCUu4u/Yok2HpILA3UQoQtwdHQIiMmu2UId7ekcYW8=;
        b=26V+nrVJxiP+w/zAw1caldDWE03MKBpMk6JZP6PyBspw5zyQagLSfK48DHZaAex2Ro
         HlfjYsBUK+E10MwhEM1KQ6Qv6/zWzxLqEmU8jM8d4smefiQzD8s9iF1oJzIBuRI88MiD
         qZUrYWBgE8WaJV7TVlYS+yGPtKf4ooNMJaNzeAxLpLIvvHxANKUojSeH5JbPnS4hM+qV
         kt+RI2zg+ocGo5sKRsOUtNUdUwatBKCyK8qaQnXEeN11E4V+CcbErbbrJqOs8ZIom9CO
         9RVgWapbeRLZ87SnIChGNWJT2w+p+R+gJDpXkyDBgE4N5cm0UIgrmPuQSKrafsrqiWs4
         E3+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766090699; x=1766695499;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fBCUu4u/Yok2HpILA3UQoQtwdHQIiMmu2UId7ekcYW8=;
        b=gWSpOJBJ37cV7oHz4vprrXpFPaAQtcqNUbKBnaaP/frXkZKQ2XjyyJ3CcdVwF97yzN
         v/ZqH/d/TKl4dDGoBNJzTQxZro8gLbb8MMKW6GHeNLyCIab+e8qh4INAiC15Myw8tf4x
         wm46Z8a0SQU/zmLoW4IFdrXridL8eJkX31twR5FdTdHM56a6Nh8ZlKaikB2KJJaPjFIp
         gh27wy6zDGdQwsCZ9pyHJoAnkxDpaoDRIPv1JhP35cqKB5nN7PMSGQaE9mHcUkKg+c0I
         160swPUQ27fMJSWGtuCj8CyoPmklqgq88XV4itDg/L3+6P40IpuQ0bDBUZBUSl18Jywh
         HUZA==
X-Gm-Message-State: AOJu0YwYHuKSJkZMvwsLN6Xe/DEPf1BmvFV6tSBuLhx2wsLB1wY7YvL7
	Fx9LBFxU7VqIN6kJIui9P8I5CWnajm3z6eq1l2nf7ixXuuLcmYwBOxeAa52cG+p50Ck=
X-Gm-Gg: AY/fxX7rL3pjMN6b7kpJ3AcWlhR9C5M0HlLjP8X3o3XKYHeMNmP6Qpc1R4Mle9Vr4AN
	rkOfkam54NgEQe+rc8e2Po5fIkCFEZRmzYNawUMOWRTcFfi4O2pNE1gCiNyNExZL/8LVVyZI8aC
	LDGW+kiujBbdOF2DZwyirCztS64ISAulLO5J/ASfMZkRXEe1lAcfrNVoJ1bR/mBNMd6ipvoklPy
	PZ9Vq/2OKTtylLcuOt/S8ZVGoDnkqVmNvMc/Kj/HM4kS8wg9SPePTqak9TEYJWHF14iNKMDD/AX
	UcUa48DCqsd3PTs3gpzrd0EjBrPbz2WeOVEa2rbRznZtc0g+Ha42yH+IdxatXK5NFExCNcmUUC4
	o54aGX+62xBxzZOYa8tTBYixixUCpRHrnC31SEyt2PM1ObX+2m8OeKIGJxck/7q+BcXBYLjm6e2
	9K/ROWe/a6
X-Google-Smtp-Source: AGHT+IFawL3v6fvfLFMk3e/U9FU/svP0NWIIO/mFK6ctWIhTbkl//sTKeQF17gtp45rMIWiu0Tz81g==
X-Received: by 2002:a05:6830:6609:b0:7c7:69c8:2ce with SMTP id 46e09a7af769-7cc66a12323mr274721a34.27.1766090699664;
        Thu, 18 Dec 2025 12:44:59 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cc6673bdabsm327468a34.10.2025.12.18.12.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Dec 2025 12:44:59 -0800 (PST)
Message-ID: <2ed38b2d-6f87-4878-b988-450cd95f8679@kernel.dk>
Date: Thu, 18 Dec 2025 13:44:57 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] af_unix: don't post cmsg for SO_INQ unless explicitly
 asked for
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, netdev@vger.kernel.org
Cc: io-uring@vger.kernel.org, kuba@kernel.org, kuniyu@google.com,
 willemb@google.com, stable@vger.kernel.org, Julian Orth <ju.orth@gmail.com>
References: <20251218150114.250048-1-axboe@kernel.dk>
 <20251218150114.250048-2-axboe@kernel.dk>
 <willemdebruijn.kernel.2e22e5d8453bd@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <willemdebruijn.kernel.2e22e5d8453bd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/18/25 1:35 PM, Willem de Bruijn wrote:
> Jens Axboe wrote:
>> A previous commit added SO_INQ support for AF_UNIX (SOCK_STREAM), but
>> it posts a SCM_INQ cmsg even if just msg->msg_get_inq is set. This is
>> incorrect, as ->msg_get_inq is just the caller asking for the remainder
>> to be passed back in msg->msg_inq, it has nothing to do with cmsg. The
>> original commit states that this is done to make sockets
>> io_uring-friendly", but it's actually incorrect as io_uring doesn't
>> use cmsg headers internally at all, and it's actively wrong as this
>> means that cmsg's are always posted if someone does recvmsg via
>> io_uring.
>>
>> Fix that up by only posting cmsg if u->recvmsg_inq is set.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: df30285b3670 ("af_unix: Introduce SO_INQ.")
>> Reported-by: Julian Orth <ju.orth@gmail.com>
>> Link: https://github.com/axboe/liburing/issues/1509
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  net/unix/af_unix.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>> index 55cdebfa0da0..110d716087b5 100644
>> --- a/net/unix/af_unix.c
>> +++ b/net/unix/af_unix.c
>> @@ -3086,12 +3086,16 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>>  
>>  	mutex_unlock(&u->iolock);
>>  	if (msg) {
>> +		bool do_cmsg;
>> +
>>  		scm_recv_unix(sock, msg, &scm, flags);
>>  
>> -		if (READ_ONCE(u->recvmsg_inq) || msg->msg_get_inq) {
>> +		do_cmsg = READ_ONCE(u->recvmsg_inq);
>> +		if (do_cmsg || msg->msg_get_inq) {
>>  			msg->msg_inq = READ_ONCE(u->inq_len);
>> -			put_cmsg(msg, SOL_SOCKET, SCM_INQ,
>> -				 sizeof(msg->msg_inq), &msg->msg_inq);
>> +			if (do_cmsg)
>> +				put_cmsg(msg, SOL_SOCKET, SCM_INQ,
>> +					 sizeof(msg->msg_inq), &msg->msg_inq);
> 
> Is it intentional that msg_inq is set also if msg_get_inq is not set,
> but do_cmsg is?

It doesn't really matter, what matters is the actual cmsg posting be
guarded. The msg_inq should only be used for a successful return anyway,
I think we're better off reading it unconditionally than having multiple
branches.

Not really important, if you prefer to keep them consistent, that's fine
with me too.

> 
> It just seems a bit surprising behavior.
> 
> That is an entangling of two separate things.
> - msg_get_inq sets msg_inq, and
> - cmsg_flags & TCP_CMSG_INQ inserts TCP_CM_INQ cmsg
> 
> The original TCP patch also entangles them, but in another way.
> The cmsg is written only if msg_get_inq is requested.

The cmsg is written iff TCP_CMSG_INQ is set, not if ->msg_get_inq is the
only thing set. That part is important.

But yes, both need the data left.

-- 
Jens Axboe

