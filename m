Return-Path: <io-uring+bounces-6489-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A26AA385A6
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 15:15:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D12511888256
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 14:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BD0E21CC54;
	Mon, 17 Feb 2025 14:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8RzEXE5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5623EEBB
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 14:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739801499; cv=none; b=bT5a1qP9hn5qoI75sqmOCd3M2nAXTyDiWsqBwYBe1XFVi5yK1Gev5rBX/KithCbdI+IvPE9QGVcWhId6saF6PlsOJh9X1n6PhfMX+vPFhF250U8826xmIFsvYDtK0B6LYfXi/ApK7oTBi/DJoArmkTNJ1ib0/84RfWFMofsa3iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739801499; c=relaxed/simple;
	bh=B7WxwtJol2EVjSTM6S8/N3AJYm1mqwR55BEYUmRY9x4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CjxWTiMQ2JpUqX9olzIiPXj0tQPytK9RP31y500iOnRlFo1iwIpLIT3z84f9VcGmqk8R8x1y9M4mS2Jzz0QYx+g8O6cPkXBE/umrMOPmZETjHd+GNkB12210iwlaIfQ0upSwv/nBJTsNBpubvz3hYPdTCEBRKO1+3uCmQHQv92Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j8RzEXE5; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-38f265c6cb0so1971604f8f.2
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 06:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739801496; x=1740406296; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DRz2x5ZPMiTnA2E16agGVN/KKkkHYKGKNYlOfRhVH+w=;
        b=j8RzEXE5a/Iw22JkmyaTQeWNOoBn1ZWgFQrWQtFDemg/Wph+m7K5OZoAr6JzmLf7JY
         96kwNyPkdFmHelK6EaS6yq85kXVKxg1fWEuQig52LZrXwWlRJG0zJqdo+mrrGWn0R7oO
         pwFAIivqzz189xSOMhad0wlv9xQgR6TwkI+PKQq7KBVpdrLk2CdXKkqCwvQXOp9TMn3H
         z3PgPigfP/8J2uYxo2jF7vQZokpfxuTuTw5fHPgWklvIIdJ8MuQm6C9l9DtSZJ/hNzx4
         SngKZ4TnSyn8OQp9LQ78j+w6jiAVK5rDm8Mzh+jaxDWRDpQAzpqMQ7QXhpD63rLfycv9
         /eUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739801496; x=1740406296;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DRz2x5ZPMiTnA2E16agGVN/KKkkHYKGKNYlOfRhVH+w=;
        b=YAZdvEUGHCaOO3924iWKsxhlBE7cml+N9MfNpMZXRy+oICkZ3HJzd67uSeF465t7Fa
         b5//4s+18b5MQ/4spLmzcouSg9WVQ+V35W3BN04uR8fEJOXp/wFrIBrSRe+MIsMOJFb4
         NY2qRnD2MZInTtFGrus76qEBvb3N8jTS6zF/do2W293fTFC/reTYot9MrvSRvYy1aV0F
         Uyg2cYmQe/5RMtDeeKsbcn3xaEADvOVYfMbRrGZ9qiByhwyWoswTCmcwpVQUxpMrfxqi
         OoZbX7g6tb/rBAlVMwtiKIdn4cUxOvQlU62r009QROhtDzVqJkBpRCQmRPvbfiRxXwKQ
         EF4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXkKIyMXnEBZV6ofL6oLlt01r9u9GVtZ4d/JdxquBSkExaPl9bzCnFliEKw9hPpqaB7VxYXLFuQSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxSPi63jaALwbmgWVy8ItrfXPK5KWGMiN4pY9s1DJCX3YHB6e4K
	STP0Uhvubnlr3tgy2mYVYAVcx2ZY2Ya5OMXargGGBlPqNCmnNjRz7gfz5Q==
X-Gm-Gg: ASbGncud7UA/KyiX/xIVvJm8xQOeVdqvsLeWvP2fj+KE/5pV7e2QX2GlyCGD5rJnUpc
	fqBFQxcXuyGQg/h4SnuhqhjH7dG2XOucS5B8nH67/H7XEDg3bi+fugJ5Nq2v6RCB5+V1Z7FHyYM
	4lMb1hnKyhfKidQCKeQ1tV6ochSGBdoYXlHFkMwe+MbC34Kh3mpgTpZACQwMLUNIFn6JvdY/Mor
	9oCblr2x5rMB5SMmoPcYCXIgUwtDsHSr+6herkoiCAeQIq7xqH1H0ADfoPuOx+7sczV3XOe16T8
	++90304uxDeM0MKRKIzTGgjO
X-Google-Smtp-Source: AGHT+IGInm1ZxUpEfxX1vgHbj3imFU5YlvyZihkR44vHbH101LZSH+za4l3cLF471UPfVmU+6F/vDw==
X-Received: by 2002:a05:6000:401f:b0:38f:4531:3989 with SMTP id ffacd0b85a97d-38f45313c69mr3587252f8f.51.1739801495504;
        Mon, 17 Feb 2025 06:11:35 -0800 (PST)
Received: from [192.168.8.100] ([185.69.145.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258ccd2csm12673805f8f.30.2025.02.17.06.11.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 06:11:34 -0800 (PST)
Message-ID: <b89b5ef0-9db9-44e6-9ae3-aabf39a70759@gmail.com>
Date: Mon, 17 Feb 2025 14:12:30 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: forbid multishot async reads
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
 <cd42f912-df8a-4c9d-a891-1c127f6b6fa0@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cd42f912-df8a-4c9d-a891-1c127f6b6fa0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/17/25 13:58, Jens Axboe wrote:
> On 2/17/25 6:37 AM, Pavel Begunkov wrote:
>> At the moment we can't sanely handle queuing an async request from a
>> multishot context, so disable them. It shouldn't matter as pollable
>> files / socekts don't normally do async.
> 
> Having something pollable that can return -EIOCBQUEUED is odd, but
> that's just a side comment.
> 
> 
>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>> index 96b42c331267..4bda46c5eb20 100644
>> --- a/io_uring/rw.c
>> +++ b/io_uring/rw.c
>> @@ -878,7 +878,15 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>>   	if (unlikely(ret))
>>   		return ret;
>>   
>> -	ret = io_iter_do_read(rw, &io->iter);
>> +	if (unlikely(req->opcode == IORING_OP_READ_MULTISHOT)) {
>> +		void *cb_copy = rw->kiocb.ki_complete;
>> +
>> +		rw->kiocb.ki_complete = NULL;
>> +		ret = io_iter_do_read(rw, &io->iter);
>> +		rw->kiocb.ki_complete = cb_copy;
>> +	} else {
>> +		ret = io_iter_do_read(rw, &io->iter);
>> +	}
> 
> This looks a bit odd. Why can't io_read_mshot() just clear
> ->ki_complete?

Forgot about that one, as for restoring it back, io_uring compares
or calls ->ki_complete in a couple of places, this way the patch
is more contained. It can definitely be refactored on top.

-- 
Pavel Begunkov


