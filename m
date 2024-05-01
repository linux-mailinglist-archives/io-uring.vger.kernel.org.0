Return-Path: <io-uring+bounces-1702-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD4658B90EE
	for <lists+io-uring@lfdr.de>; Wed,  1 May 2024 22:55:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D44CE1C22F15
	for <lists+io-uring@lfdr.de>; Wed,  1 May 2024 20:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D2B1649DD;
	Wed,  1 May 2024 20:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pahz/zsB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FDBF9EB
	for <io-uring@vger.kernel.org>; Wed,  1 May 2024 20:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714596945; cv=none; b=sXCWSFSf/e5M+3xRgs6FJy6fVIFPj0GESRI4JdDBE6UCQKCXUEfCgBiSv/zqwknhFwxuvW+vkaNRbxkqA5xXS/sMdQDZgLMrER/DOg+Lh73NGuUcWW7PiGqh883dj1rTQrUa5nonCTR4H4uiWLFlYw9iBd6fc2Bp5FRUFAw0Dqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714596945; c=relaxed/simple;
	bh=yN/1ajYUcOhB5Kz7TMu1ICiWu20R2T2bdQOPaDh2PJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HQlLlWunOIHwQBjwi+ZuZUJhgDQhUq7qfA3KvGaiX06AE5Dl/w1iSi/ltKpnyyz+xtuFSOYM5zL+V9Gphnqdma+mEAF4glXFLmUO/Hb5mDoH21MADMrz39OuOksvSm5Mac7vF5RIRk1IVPXwPt0+E+OueNZVw/cfbptsDUmwIBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pahz/zsB; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7dec804bd19so17663339f.1
        for <io-uring@vger.kernel.org>; Wed, 01 May 2024 13:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714596941; x=1715201741; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9TnrLiTDXNkUmnAIcOZ8bDyVlD1MC0t+N/5wcDjWs60=;
        b=pahz/zsB2/LGSl47ZvWX+8Gq/g7JQ5UhrphsMzZLMGZBlTEXqVgjZyFCSYiwykPQnm
         3UPgNlKgzI2dtXI86ZFM8IX74U5isf7pFsEHEAOYZxZiDZhx5N467BCOvXNUd0Tng/NU
         wG0f0nwadirOLkPoeVpdy1lgizritAPZjHHi0iH/BpgnBQtYPeaTsSKciyHWwDKBRbgY
         rT2KTZ9hdrC754kl4EoQDeeA/Gd0qzNNKj7roAhpYKhQ93KfIX4X+x1aBoLQrwEj8jZg
         uxeJ3L2p2gMVaMYpWQch0GvbUQewLpAFnzBYLKkuXGgIKbem0Y6Y+YUloViy+6K6CVGI
         zZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714596941; x=1715201741;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9TnrLiTDXNkUmnAIcOZ8bDyVlD1MC0t+N/5wcDjWs60=;
        b=LZrL/5iZFroDmA0p+DeZ9qii/wSG2tIdgr4qJB5EdMP/24NI0OJTaYOetRgb6s6u7Z
         q5GkUag1N3ZS5asfbOhovNRI2VQNXl5EeuXE+iQp5ZKVGPEMNcwAc8V6/MFe6vMFWj0b
         h87dRBZtMbluTEeyc3GfwGNmCDhZrRI8xV0BGFaI4CvFi3L19Ao+iHyynOPswMPLuEzM
         yJb8bWEBXv4t6mlnQQrwb0HpGhn7qDlK0RIzyGYCvV1oimLfADw7bf7WSO8tKxIsCtD7
         ASbBLEfNxCmER8o79s7zZ4gOQLXIRch9hkfL2Z8L7bMOSx5JWsk6dmcWkE128JlyEMpV
         i6QA==
X-Gm-Message-State: AOJu0Yy0FVFTedxT2Oj+WiDdP5gqhDZDnngANWUlKiDV+/0uSbNyGkym
	vtfITouesXAHl1j4ZsnNDVpekZX3znrnL9iUkSoqovQ7aMK98YduFy+Va4DP56k=
X-Google-Smtp-Source: AGHT+IEUdATwMXFzHIeczbnnyH8JuuUhykCYmjlRG6WgahodhJjcaI16A/hYJYxVq6Cpf0EGtWSMPg==
X-Received: by 2002:a05:6602:168f:b0:7de:dc52:18b6 with SMTP id s15-20020a056602168f00b007dedc5218b6mr5000403iow.2.1714596941422;
        Wed, 01 May 2024 13:55:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ch10-20020a0566383e8a00b00487e69d0373sm1273777jab.26.2024.05.01.13.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 May 2024 13:55:40 -0700 (PDT)
Message-ID: <00839a42-bfba-48cc-be73-22a12a7e2432@kernel.dk>
Date: Wed, 1 May 2024 14:55:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Require zeroed sqe->len on provided-buffers
 send
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20240429181556.31828-1-krisman@suse.de>
 <909e44a9-c9e2-45aa-9eba-fcf10904e503@kernel.dk>
 <878r0tz2br.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <878r0tz2br.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/1/24 2:47 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 4/29/24 12:15 PM, Gabriel Krisman Bertazi wrote:
>>> When sending from a provided buffer, we set sr->len to be the smallest
>>> between the actual buffer size and sqe->len.  But, now that we
>>> disconnect the buffer from the submission request, we can get in a
>>> situation where the buffers and requests mismatch, and only part of a
>>> buffer gets sent.  Assume:
>>>
>>> * buf[1]->len = 128; buf[2]->len = 256
>>> * sqe[1]->len = 128; sqe[2]->len = 256
>>>
>>> If sqe1 runs first, it picks buff[1] and it's all good. But, if sqe[2]
>>> runs first, sqe[1] picks buff[2], and the last half of buff[2] is
>>> never sent.
>>>
>>> While arguably the use-case of different-length sends is questionable,
>>> it has already raised confusion with potential users of this
>>> feature. Let's make the interface less tricky by forcing the length to
>>> only come from the buffer ring entry itself.
>>>
>>> Fixes: ac5f71a3d9d7 ("io_uring/net: add provided buffer support for IORING_OP_SEND")
>>> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
>>> ---
>>>  io_uring/net.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>> index 51c41d771c50..ffe37dd77a74 100644
>>> --- a/io_uring/net.c
>>> +++ b/io_uring/net.c
>>> @@ -423,6 +423,8 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>  		sr->buf_group = req->buf_index;
>>>  		req->buf_list = NULL;
>>>  	}
>>> +	if (req->flags & REQ_F_BUFFER_SELECT && sr->len)
>>> +		return -EINVAL;
>>>  
>>>  #ifdef CONFIG_COMPAT
>>>  	if (req->ctx->compat)
>>
>> Why not put it in io_send(), under io_do_buffer_select()? Then
>> you can get rid of the:
>>
>> .max_len = min_not_zero(sr->len, INT_MAX),
>>
>> and just do
>>
>> .max_len = INT_MAX,
>>
> 
> Mostly because I'd expect this kind of validation of userspace data to
> be done early in ->prep, when we are consuming the sqe.  But more
> importantly, if I read the code correctly, doing it under
> io_do_buffer_select() in io_send() is more convoluted because we have
> that backward jump in case we don't send the full set of buffers in the
> bundle case, and we dirty sr->len with the actual returned buffer length.
> 
> since we already checked in prep, we can safely ignore it in the
> io_do_buffer_select, anyway. What do you think of the below?

Yep, I think that looks very reasonable. I'll queue it up, thanks!

-- 
Jens Axboe


