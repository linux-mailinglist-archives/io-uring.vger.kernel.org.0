Return-Path: <io-uring+bounces-2604-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AE969413E2
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 16:07:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2777BB20B45
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 14:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE5CC19F49E;
	Tue, 30 Jul 2024 14:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V4vbdiKl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420B61A08A6
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 14:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722348456; cv=none; b=tFZ9JGWXgalSCjIAuqOlHJPlgPo+2mSyocN5/8R4xBOS43cdXYyTxqCj4TyrUbC7vO9BXT1mq73gboS/XaTfK2OEzq+Uj8lP5Qkw5yjW/gY+MymDyKleLTc2eesneM604em+9lH4wk7QUqjEvtyeGOTUt69xZ62DhRR5pja3GB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722348456; c=relaxed/simple;
	bh=BkBzxvRCX2PuSdtCWoxuII2njFz+JlgVnqT9IvkObqk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CrodIXOlGWjBgD/xj6Hxd//oWKYrqG0gVe+1L3lpTEnIdnWEXpeuOj0k49sv/zL0JAqvEIdYVA2wpcLQV39Ufj+K7SYlfzNH+aVcO9fi69wGR5NDnZyEwnCz5To8gvzxgeb8nrHORbcm6XmL9koCMfMYeJVkPrh+Hprvr3/4cjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V4vbdiKl; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5a10835480bso6840736a12.2
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 07:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722348453; x=1722953253; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=53pHMUFqRDjFy7RupUhyIiWvpncsryEbhIuy/BFeiMU=;
        b=V4vbdiKldbTMKrmigMapgH6dPaDMrsS6krUgJEwYu6Qd/62FWQ00NuZgCdlDi8bFwx
         P7YwGedQgEybZps2n5Eg/h9aSw+7tEbJy8Hqywe2C8Hzjf6bu8abb4E2+tLGAN7Kxzas
         sfqYsOc2ngx1XnivJiUbk0pdTmzD3cDNKkVBbtIzHMUKp+0GI9L8hE4Q8GNdrjq356Pq
         f/Ad4q9KkZJFAda7Sh3q4Cu6gUwHRmNzPH+XwmjtqgEmFPFEdUp9LWW6+PD3BVf+waQC
         2caY81m8Cj9exTnEwykh8ltj+2oMqefKeh9s4uF4hYhAj4H/rd8uE32h3XoGJITpZTXk
         GLHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722348453; x=1722953253;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=53pHMUFqRDjFy7RupUhyIiWvpncsryEbhIuy/BFeiMU=;
        b=M5gGWS/+tjNdCaBgEh62bT13LTWjcdlEns8KakSoyPv6Ws8XY6dRex5c+Ixmc02Lxu
         0dNEJUHLW4fsCQ3lwJEPFk1Fr6xYTrda6DtcFG958ABSWIRP28eQNh5do5it2mkUfTHm
         VvIOwDr6hpdjKN7Ehnrg/yTaWYtKBVA4btpKthjjt4GmDZh2/9EHbQZMpC1OLEFkZUiv
         ok8r0hq3NvaJe65Rrc7iXqLcZFFPu9GH3G5bGRUFXghj25XLLQvxeJmkeAdmSZRgeNlr
         izeNF/vtlZeUIjvIB87f1qK+f0wABpxPGrY/7YTieorYiQHQGYtsdK47gFLtR3LfYEzo
         d8gw==
X-Forwarded-Encrypted: i=1; AJvYcCV9+pAqwluW76e39kRU8VtT6z+hv0/QdeyGiq8mvJkHACkNDwbusZJkI966e+3hVE/kQDHT7pM8ijuhhLHV0l5u/zWlnKhZnps=
X-Gm-Message-State: AOJu0YwKmCwho5KGsnJx018KWNeQivRs26O6u7gQLWwfDFCiLClLRQ69
	9vw2ogAU/DXaBry3OM/4BO8jLTQ4uOGpbcqpskraLYOyNPFqVF7NXFynGQ==
X-Google-Smtp-Source: AGHT+IG0YnKXpN/94LahD6Rnmuc4jX9mQVIeS3CLFqSFH3NpMm6Ufe/o9+JIvS2ZfD9p8qhcJb0OmA==
X-Received: by 2002:a50:ba8c:0:b0:5a3:76e3:1dc with SMTP id 4fb4d7f45d1cf-5b0208c200dmr6605234a12.10.1722348453126;
        Tue, 30 Jul 2024 07:07:33 -0700 (PDT)
Received: from [192.168.42.28] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac63590aa3sm7295413a12.31.2024.07.30.07.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 07:07:32 -0700 (PDT)
Message-ID: <0de84f6b-bf13-4c96-9788-1089d4c3a959@gmail.com>
Date: Tue, 30 Jul 2024 15:08:04 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: add napi busy settings to the fdinfo output
To: Olivier Langlois <olivier@trillion01.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <bb184f8b62703ddd3e6e19eae7ab6c67b97e1e10.1722293317.git.olivier@trillion01.com>
 <99aa340f-2379-4bdb-9a7d-941eee4bf3bf@gmail.com>
 <0ad8d8b1912f5d3b1115dca9ee229c6f6c0226b2.camel@trillion01.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0ad8d8b1912f5d3b1115dca9ee229c6f6c0226b2.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 15:04, Olivier Langlois wrote:
> Thank you Pavel for your review!
> 
> Since I have no indication if Jens did see your comment before applying
> my patch, I will prepare another one with your comment addressed.

Jens saw it

https://git.kernel.dk/cgit/linux-block/commit/?h=for-6.12/io_uring

-- 
Pavel Begunkov

