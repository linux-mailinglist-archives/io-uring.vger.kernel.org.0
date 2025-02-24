Return-Path: <io-uring+bounces-6686-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82AFAA42785
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 17:11:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D79011887AC1
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 16:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A25254857;
	Mon, 24 Feb 2025 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HPmjmAQD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C989D18950A
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 16:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740413511; cv=none; b=DMhjJnUzdM7qWqcLe8huw9grF4XdtrWkZtqvZanzSQv45QP8309qEej5Gta4jp6wyi2hFyB5KFIsnCSbQmCx8VEK7QOV0gvLKdFZv1hqal5+T6L9kA/BCRWK3RNHJ09mkGBdFPsEJ6efYnJMT14pXmf2NkUYliZng6+j0BSfvec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740413511; c=relaxed/simple;
	bh=y9CAE5Xg84RHvsVqAGn2zc4LOLcA5uxIhf03Av7QwUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vGCUa+t3GX1TdB6pd/f8Fsq0jIOO2q2gvc6wfABWgmkqp1kswenTWz6rbswq7QeC4gBcKqRe5yqy11byyMsGdaaA25hMdyh0vHh70TOUaltlLClqNIG4vg6DbJh3gwrhzmbrJvqF8RYjh/LQ5g8AwQ6I+D8I4yj6hgxzfFJB8V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HPmjmAQD; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5deb1266031so8391640a12.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 08:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740413508; x=1741018308; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qUM38K9j8r1Fy9p1Cdq7HgZ72XA/ay1Sot9LLkw1qfE=;
        b=HPmjmAQDWpSaqJybc6w6/lkTaaVx/zo2wzHj27yT8n43IBrs8T4KxyDulXv5N221C2
         m78GI5cIOn6QUVSxTdX5qleBbj9yVhEMmnDHS048o/+FeSGzoJTn/yM68U6A6OSdUjAp
         HKQSGlynpKHZgzn43SLlKMAs/a08AcRPESJ6J+plV7V2lDIZVZ+A+XznxFghCM67E+jv
         KPDBPaHlVSVbsQKh9dZ8S8x5zADvM9+147czIBHvXWUSUUqDXU2VIMGj/mbAyEtXr/Cz
         NjdQ4vNuxp2+kJSayfm2jziSsfH36zwaGsue8PaIieMmv6pn2mDal+lT59X83hcEarlU
         BQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740413508; x=1741018308;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qUM38K9j8r1Fy9p1Cdq7HgZ72XA/ay1Sot9LLkw1qfE=;
        b=L49F3P/j+2VR1UY8YVx9E6bqDvXjQrbfrBne1y38150U6Y8yK5eCmfTKPU80Ya7ENu
         a3MRjRGTqBPQYPK2N4qPHSCoTnBFjJL3H3FlOFQul1J0FmdqbSoGw41JcsaHUihLW8zj
         MJGRUbhWMr8s9FgbIgTD/RZbef+8+FpyP2PJZnvnd2E3WzCdkis4RQvb7GUZPAZxgZR0
         8UrMwynzmKToAErSy+CkWnbHXB7Dl9K0Izjw1i3LkzDBTL34yR6/qA733SZQOlyWwGAc
         aNtaBuKEZVeGnljD8EuM5biEMi7vbEFymfILopd7kVsXLmQ7z3txI6sR4LwbDPvOGt8+
         uQgg==
X-Gm-Message-State: AOJu0YwUBEOdgZK4SjmdSd4RGHqoTBTv8s9o8HqVMVVM6yj7v4Jjh2uv
	Nu300/4m3zVqd0dIdqcK+y7SJ+MrK4uddRCCJzrojEgTjGZTIjPM
X-Gm-Gg: ASbGncvBTyunT/42f0pzLPw+Ceckkf7qszt7dmS0uohaHrROmP9WMqGuxL6LxY8XkR+
	iouSf5c15O3+RgsTLjlpFLmG2YuwLw5kpbbnpXtJhduqR4pqYByb2oKVI1PWv9gDaZvu3t4OMsn
	BkAkkL1am/HU8OXdd2rwmI51y3YTXSRilSAMpRRpKEPcAJvXJQdOeEKHYXI5+E4l2M5NmnWpi40
	COGnVjTy0TlL7GZG7967L0LTBR4xCeAjgrfVKX/iKTG6elzCar4hfJF+MfyDsjgBknSm9+d7eAX
	V6IOlxexN4T3GSwxKZIAiA77yjYSnU0Gdo+kUHkdv6/DzwCFf3vplMHexdU=
X-Google-Smtp-Source: AGHT+IFzhI/NmMKS+9UWTGECP1yWanqyNGGViQyK9J89JWTv6YmgDr4Pk/Xlk+yM4pZxFkFTx5DYMw==
X-Received: by 2002:a05:6402:1ec9:b0:5e0:8c55:501 with SMTP id 4fb4d7f45d1cf-5e0b70cb891mr12724724a12.7.1740413507727;
        Mon, 24 Feb 2025 08:11:47 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece2709e7sm18377012a12.64.2025.02.24.08.11.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 08:11:47 -0800 (PST)
Message-ID: <da109d01-7aab-4205-bbb1-f5f1387f1847@gmail.com>
Date: Mon, 24 Feb 2025 16:12:42 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] io_uring/waitid: use io_is_compat()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, Anuj gupta <anuj1072538@gmail.com>,
 Jens Axboe <axboe@kernel.dk>
References: <cover.1740400452.git.asml.silence@gmail.com>
 <28c5b5f1f1bf7f4d18869dafe6e4147ce1bbf0f5.1740400452.git.asml.silence@gmail.com>
 <CADUfDZqjL3iG1j6pv=EKa8goQE7A21sotwyZmnK_26QY=_ZtAw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZqjL3iG1j6pv=EKa8goQE7A21sotwyZmnK_26QY=_ZtAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/24/25 15:33, Caleb Sander Mateos wrote:
> On Mon, Feb 24, 2025 at 4:48 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> Use io_is_compat() for consistency.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/waitid.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/io_uring/waitid.c b/io_uring/waitid.c
>> index 347b8f53efa7..4034b7e3026f 100644
>> --- a/io_uring/waitid.c
>> +++ b/io_uring/waitid.c
>> @@ -78,7 +78,7 @@ static bool io_waitid_copy_si(struct io_kiocb *req, int signo)
>>                  return true;
>>
>>   #ifdef CONFIG_COMPAT
>> -       if (req->ctx->compat)
>> +       if (io_is_compat(req->ctx))
>>                  return io_waitid_compat_copy_si(iw, signo);
>>   #endif
> 
> Would it be possible to remove the #ifdef CONFIG_COMPAT here (and
> around io_waitid_compat_copy_si()), like you did in rw.c? The compiler
> should be able to optimize out the if (false) and the unused static
> function. Same comment for the remaining uses of #ifdef CONFIG_COMPAT
> in net.c.

Likely so, I hinted on the same in the cv as well, but it doesn't
have to happen in a single set. If anything, I'd prefer to flush this
now, so that the dependency is merged and everything else can
be done independently.

-- 
Pavel Begunkov


