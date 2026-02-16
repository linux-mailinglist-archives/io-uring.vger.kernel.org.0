Return-Path: <io-uring+bounces-12268-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QB3+MJFTk2kz3gEAu9opvQ
	(envelope-from <io-uring+bounces-12268-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 18:27:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 21FAA146B2D
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 18:27:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E286A3019511
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FD012DAFCA;
	Mon, 16 Feb 2026 17:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e6S4KtaG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA162DB7A4
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 17:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771262841; cv=none; b=fkF/XOvzSI/YvBL6qUFFagj73Dqm4SU3oa9c4fW9whOtsiYj7mGtTIMHmbVj3Xxqq/J2saCxVOsNvWfrplsvHotr/JxG6RTbMJyd7YhkyrfVzs2UEeXcCvUrlANedtuu+3LFNEUs+u8ceDwpLEMN9Svf+RtNuN/vRkExX79LsO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771262841; c=relaxed/simple;
	bh=lkSI9RGlbLnByM0RCwP2ADIqbsYGc69x7eexKmXkOio=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QSk07AOePUCTCBMWgiCOwWfJooh16duNMi7Cp0oX7XBLopZUfuPAlcPFOHPmnU0SnNGwqiK7bPKOpHPl0OpJ6pwBnWAWPSVC4gOl0lTr49op5vvZGEmEFS6NgsurlP7CdmAP99IWn+ai/TJky4iMXKDZnKibRAy81MvShCQCJOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=e6S4KtaG; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7d4c1d2123dso3162093a34.2
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 09:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771262839; x=1771867639; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TCGLTQb7fVcQB08dpjVglgdj8SFl2dt6Tfjhoxco3WE=;
        b=e6S4KtaGptbqO0Ic1JIIltUqKeiwffpCDh7eST0aHnay3cpm7bjjIMgMiVr9Ov4RW1
         pVi+tpe5rYTFxNNvTW2z2GoTKv6GCT0w0OVXnbENhc2s3pwygOjEAjJVXNYqTUPAIlu7
         hH4cPQdd5v+S+KyKZZcH15Z0HE2UxCB3J/Q1+lj863dOLFdmB+mV4736CQ0pH1IV8Lyv
         654md7F/LYKTm37hiJu+NDClhMB1gebM9FXpgMhKz/IkQUHbRvqX1h1SIHwHBWNdR+ez
         /FDdQaS9HNqVlglPxyXkXwNEu0bS5lkuyWxt2F9AeftWuOoXSZyVqbMVmnw5ochJY9AW
         1mMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771262839; x=1771867639;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TCGLTQb7fVcQB08dpjVglgdj8SFl2dt6Tfjhoxco3WE=;
        b=MHpfKcAyNbpcSmbDjXNyQhPaQzlkcygd5QS+rWwiJbXjeXCOEhTiJ156xUtHmOi6fP
         rr2vwiyDo3rm8DC/omwzlabCiB4F5Ijhv9u3pfxawVTu53cJoUcYzUCYLFLPi9TyPDw0
         Cy/QT+fCLP+OnLKhUz6IfOgEOGhddU4e41hj+smffHM1cSF9tD76KS46q/zNnnKw0Yq3
         oaxnGeXuwvZjWgZAwGcS1+vn+fE57VTYqyoHuWUlrjZkqgXlvWcUBkmjPZFu5X6nrylx
         8NmIbiELJIQznAKzOGWMGCaQfThRQW60z5B57yVxVuf4wtFl5/DvWrZSpGKyBxaQXDeq
         MKsA==
X-Forwarded-Encrypted: i=1; AJvYcCWqB9SkqKdPH6u+LAkXNzoZIZpBlqYKz1/Alibq7SpyeGsDM3knvLNfCH5XvZFyeN1TAoqFeJZtwg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw229E1P/H9RBMugDGxlcfUiCbieiJcIE8EMlYnYnm+v2MQtibM
	eIl83FlHHV8e9I8SVtxS3WLZchV1i51sEJeyphe+AZrhP4jgmimLeaKU0tLLObxukpw=
X-Gm-Gg: AZuq6aL40Kud56EKQ0uj+bPVRZEgHzGZ4aEWHPEQxpYSplakZd9UdO59Fxgjr3eK3qQ
	vF9H6DGP7HU6FozTVmedly+4qPWYR1w9YZ8KeqBISGWgOkbJE3QCw04A8uU2h6BJncanq8Bzaye
	44CPiZGjvZrX0knrxfh7L7MZmR/WbESpigO/FWCUuj0srlHaCsNDLDsYMqcsZ6yBhtc1Fj/vKU6
	EtqJ1dQI+tCS6LPzRnKVm3XXNZ2EX19dcj8dBnND8iukxIvUF3f/ls1yAXhUqi7q1SdJYkiusX0
	9C1eCv6yR3tlWBRlbUmKz4BE+50a0qGhYar7mmLJgYeDSIloWFPnSxx52Ejxd4YCXWPb+foL9MY
	BetGqkc0/Nf01GrhrNdepR1GhBVFP5EZ4Otgk81VMZTn71eMrpbbi8HFmN20km3SdUkeu5vtWZC
	BpA9yR0Vuj4xSAK08Q5CQ4ZgcY961uSfUIRrTVrpbusQwjdH0LWDmR8dNDGnDy1+7LblaK73PJY
	W0bdq0yjQ==
X-Received: by 2002:a05:6830:6584:b0:7c7:827f:872f with SMTP id 46e09a7af769-7d4c4b71cf8mr5860160a34.37.1771262838901;
        Mon, 16 Feb 2026 09:27:18 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4a76f98cesm12950152a34.22.2026.02.16.09.27.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 09:27:18 -0800 (PST)
Message-ID: <133c27e8-7b5f-4754-9f8a-17d96e736621@kernel.dk>
Date: Mon, 16 Feb 2026 10:27:17 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/zctx: separate notification user_data
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Dylan Yudaken <dyudaken@gmail.com>
References: <d099d8d0d7526e4eb59f5ffd0e890888a46b21f7.1771242479.git.asml.silence@gmail.com>
 <025de231-a6d2-4fa8-91e5-f4ab81d16e7f@kernel.dk>
 <5fa237b6-420d-413a-b7b5-9f85d9f1e8ba@gmail.com>
 <64ab6b3e-3746-4076-9c0b-b2edc2de92d1@kernel.dk>
 <69a2d3ce-5c77-44f9-99be-1b558cf4c4ca@gmail.com>
 <fc217246-2397-4ae4-8354-7ed0c498d23c@kernel.dk>
 <e59d8887-d908-463b-ad31-3bf10d977de4@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e59d8887-d908-463b-ad31-3bf10d977de4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12268-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 21FAA146B2D
X-Rspamd-Action: no action

On 2/16/26 10:20 AM, Pavel Begunkov wrote:
> On 2/16/26 15:55, Jens Axboe wrote:
>> On 2/16/26 8:53 AM, Pavel Begunkov wrote:
>>> On 2/16/26 15:52, Jens Axboe wrote:
>>>> On 2/16/26 8:48 AM, Pavel Begunkov wrote:
>>>>> On 2/16/26 15:10, Jens Axboe wrote:
>>>>>> On 2/16/26 4:48 AM, Pavel Begunkov wrote:
>>>>>>> People previously asked for the notification CQE to have a different
>>>>>>> user_data value from the main request completion. It's useful to
>>>>>>> separate buffer and request handling logic and avoid separately
>>>>>>> refcounting the request.
>>>>>>>
>>>>>>> Let the user pass the notification user_data in sqe->addr3. If zero,
>>>>>>> it'll inherit sqe->user_data as before. It doesn't change the rules for
>>>>>>> when the user can expect a notification CQE, and it should still check
>>>>>>> the IORING_CQE_F_MORE flag.
>>>>>>
>>>>>> This should use and sqe->ioprio flag to manage it, otherwise you're
>>>>>> excluding 0. Which may not be important in and of itself, but the
>>>>>> flag approach is expected way to do this.
>>>>>
>>>>> What's the benefit? It's not unreasonable to exclude zero, it won't
>>>>> limit any use cases, and it's not new either (i.e. buffer tags).
>>>>> On the other hand, the user will now have to modify two fields
>>>>> instead of one, which is cleaner. And you're taking one extra bit
>>>>> out of 16bit ->ioprio, which is not critical if it's all going to
>>>>> be flags, but it wouldn't be an outrageous idea to take 8 bits
>>>>> out of it for some index, for example.
>>>>
>>>> The benefit is that it's weird to exclude a given user_data value, just
>>>> so it can get used as both a key and a flag. IMHO much cleaner to have a
>>>> flag for it which explicitly says "use the user_data I provide". Also
>>>> easier to explain in docs, set this flag and then the value in X will be
>>>> the user_data for the completion.
>>>
>>> Ok, I'll respin, let's go with wasting bits for nothing.
>>
>> It's not like they are a scarce resource, and if we need more than 16
>> bits to modify send/recv behavior, then arguably we have bigger
>> problems.
> 
> There are already 6, it'll be 7th. I also have one or two more in mind,
> that's already over the half. The same was probably thought about
> sqe->flags, and even though it's twice as many bits for net, those
> are taken faster as potential cost of redesign is lower.
> 
> Fwiw, the code is nastier as well, more branchy and away from
> other notification init because of dependency on reading the
> flags.
> 
> @@ -1331,7 +1333,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  
>      zc->done_io = 0;
>  
> -    if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
> +    if (unlikely(READ_ONCE(sqe->__pad2[0])))
>          return -EINVAL;
>      /* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
>      if (req->flags & REQ_F_CQE_SKIP)
> @@ -1358,6 +1360,13 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>          }
>      }
>  
> +    if (zc->flags & IORING_SEND_ZC_NOTIF_USER_DATA) {
> +        notif->cqe.user_data = READ_ONCE(sqe->addr3);
> +    } else {
> +        if (READ_ONCE(sqe->addr3))
> +            return -EINVAL;
> +    }
> +

I think just remove the else part here - addr3 is valid now that
IORING_SEND_ZC_NOTIF_USER_DATA is supported, and if you mess it up in
your applications, you'll find this via development anyway. Since addr3
== 0 is a valid value, it doesn't make much sense to check for it being
non-zero. It's not like a flags field where any value set would be an
-EINVAL case. Doesn't even exclude having another flag for using addr3
for something else anyway.

-- 
Jens Axboe

