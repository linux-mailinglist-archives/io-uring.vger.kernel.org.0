Return-Path: <io-uring+bounces-6962-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 22428A4F240
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 01:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D89947A7598
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 00:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61376C2ED;
	Wed,  5 Mar 2025 00:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CpCkcKn8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF4E17579;
	Wed,  5 Mar 2025 00:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741133828; cv=none; b=dEs2233S2wVt+Cii8hKVbSBYy+V7vXfmUwgJle8I0Q34f4vvyP5qSOW6Diqm8kNWXOn+BuLXF4a8027Wel/9hlErDTZNJdMOvcnlLmqnMn5ApLvBid17V6kcBcgQ5vxBZmRlKtc4E4GEfGUOMGzF8nf1+y7Sw8/LqLt9ulrVyEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741133828; c=relaxed/simple;
	bh=pe7jpsKw+AkR1yQRKc6yq2GnlmLO6YjihyEUbE55Plo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=I1T4GTR0KNKKdZYWzjvLubcPPSxNTyTuk4chOLNZVgoCBJVEQikt4WcldV+eTcC6r81ZUXcW9fWslSj6uhor7YvBe7kq1m9eHwQ/WMaewcuzhHPLh9uGm0A7lpCQQ+B6o3gNvbO/Llw0p7jAJcrdmQgR/mW9XERKdoYTsHlaqzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CpCkcKn8; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43bcad638efso9959565e9.2;
        Tue, 04 Mar 2025 16:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741133825; x=1741738625; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5lkfPm+XksVDf8PR9JwAWpKK0ENfZtx3gZN4oVU5BFQ=;
        b=CpCkcKn87QnCLw5Y2+kNnwPAS//6OmbPiUYlup2nc8Nr8Nz4QrvoUanNMoON79IQj0
         5NjMJheheXymHcM3nYpbwYXYdO+lvqoW33njqGa8PQlAqnmeZmv5j3p999q9w8Q+uEKS
         2IcZAt/DNMsHYa3dauhDxaMarS+WGbd64g+u/edHXi0hNHp+dZTPJamDpNIoBQWHkMLz
         b5UZeZ+HrhXBJYDz5j+j9Rpe8tpT1f+cdenmFTBlyx6XXS0TrY6KmiDGn7eeMG8SHbJC
         mEycKmF0O+N+eCU6QgL3P6TXo2C1ijz9jp79oQ11GpsXiDJFFUF+rGnqapKcas7p0RJf
         QRVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741133825; x=1741738625;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5lkfPm+XksVDf8PR9JwAWpKK0ENfZtx3gZN4oVU5BFQ=;
        b=ckrbIf1ylfBZj5QxwrSq0CkJiJ+zKu1929VoG9bwVr36FZXa60RkAU0BJLKPGlHZEZ
         Xo16Ok21cT0BQ+up1bXGOPQZyGM+tyxOgR/lZDwdeXp6T0s74N+/GjfOHNQM2DGs9V32
         vpdEklWUgEBvqdfxK8GpPg/VPt807Rjb2nZAtX/5gYhNfBeY8fj4cbIkON3Q9bpjCcLW
         4v77LcCKOUB+D5wfqWBJqnXg1GmyZuPpM40Z3t0xjnVU5CEuEFOQkyrpz7g4svUaC+iS
         ejfgfJPE+Qz/kjj/vs5hFY1f55spUqkjnw3koAGXgsDAiiq3SjL6s95/4X67LzeZ+7xw
         iQ4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUqVk2gwmRCTvwJAnWw2GDUwHS0Uv9s6feU9GeE9RtyqPsgv73gK0tEa4LVg53+NGrg7aDoUmd85KGHGme7zw==@vger.kernel.org, AJvYcCWTf3PR00swsojZZY5sR/Abe5HnpCVFkTPekpwqJq5HqLNZkwfMzVdi4zOjmRzxqOz81n03c4kaCg==@vger.kernel.org, AJvYcCWihTZgpbPk3ryDGIaFXSsYtJOeeTYCCjHhnS1jUYMZPZ+B64kIF172Fo5+adopX7ZugXnvWMuAy/s3@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv724ga7qCx384z8YCULZ2XPvAEHp9bJOCQFYeOhZmbQc4nhue
	QjWsXf1jyipTyEz947H8gt1bSvOWOE/m1iUWwZZQS7fkqQx2rf0v
X-Gm-Gg: ASbGncv0+kbp8UHdHCMpuuiUK3GMXA7UuwSJe8HdJaf+ZfnGLpdFOoEei8h54R+m3uk
	2pPhZCiL+bI8chQAoaEQyBRiB3G8EDXBaFzdoaGMbmsInIXBmJvwNgj6J9YU4VGPKICg4ZL0eg/
	YWwVKcGNdZBZwWBEB6kMXX1M4v3eMDIRbVIWEYH1nM+9RyN11CYTz47bGJYQTP5xtChYkuD05dL
	lC5F2K1+twcMQg/rcC3BRRvqM8MjBYSJMrIlnHSJoijft/SMdMdb1wWizitReeIqiAqeVtNJQxW
	bqIimVdnNjtBdkGxoPT1F1WVe335wFpAdipA0QSvhAMRw1h6pgbOLQ==
X-Google-Smtp-Source: AGHT+IEzFTiScWTrPVk1WALXAm37MaKq2F20iXlvaZ/Pyz6tCJsXwzjy7lNTfXM1kpJdVE/FBgq2Hg==
X-Received: by 2002:a05:600c:474b:b0:43b:d040:3df3 with SMTP id 5b1f17b1804b1-43bd294de93mr4968375e9.4.1741133824706;
        Tue, 04 Mar 2025 16:17:04 -0800 (PST)
Received: from [192.168.8.100] ([185.69.144.147])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e47a6739sm18825826f8f.22.2025.03.04.16.17.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 16:17:04 -0800 (PST)
Message-ID: <d1a2948c-06fa-49ec-a5f7-0733a64d9be6@gmail.com>
Date: Wed, 5 Mar 2025 00:18:12 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
From: Pavel Begunkov <asml.silence@gmail.com>
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 wu lei <uwydoc@gmail.com>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
 <Z8cxVLEEEwmUigjz@infradead.org>
 <1e7bbcdf-f677-43e4-b888-7a4614515c62@kernel.dk>
 <Z8eMPU7Tvduo0IVw@infradead.org>
 <876fa989-ee26-41b3-9cd4-2663343d21f7@kernel.dk>
 <Z8eReV3_yMOVOe3k@infradead.org>
 <0113b102-2bc9-4f0a-817b-54a6f2fe0a3c@gmail.com>
Content-Language: en-US
In-Reply-To: <0113b102-2bc9-4f0a-817b-54a6f2fe0a3c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/5/25 00:14, Pavel Begunkov wrote:
> On 3/4/25 23:49, Christoph Hellwig wrote:
>> On Tue, Mar 04, 2025 at 04:43:29PM -0700, Jens Axboe wrote:
>>> On 3/4/25 4:26 PM, Christoph Hellwig wrote:
>>>> On Tue, Mar 04, 2025 at 10:36:16AM -0700, Jens Axboe wrote:
>>>>> stable and actual production certainly do. Not that this should drive
>>>>> upstream development in any way, it's entirely unrelated to the problem
>>>>> at hand.
>>>>
>>>> And that's exactly what I'm saying.  Do the right thing instead of
>>>> whining about backports to old kernels.
>>>
>>> Yep we agree on that, that's obvious. What I'm objecting to is your
>>> delivery, which was personal rather than factual, which you should imho
>>> apologize for.
>>
>> I thus sincerly apologize for flaming Pavel for whining about
> 
> Again, pretty interesting choice of words, because it was more akin
> to a tantrum. I hope you don't think you'd be taken seriously after
> that, I can't, and not only from this conversation.
> 
>> backporting, but I'd still prefer he would have taken up that proposal
>> on technical grounds as I see absolutely no alternatively to
>> synchronously returning an error.
> 
> The "You have to do X" hardly reveals any details to claim "technical
> grounds". Take stable out of the question, and I would still think
> that a simple understandable fix for upstream is better than jumping
> to a major rework right away.

That is _if_ there is a simple fix, but your argument was that
it's "not very accurate", which is not very useful.

>>> And honestly pretty tiring that this needs to be said, still. Really.
>>
>> An I'm really tired of folks whining about backporting instead of
>> staying ontopic.

-- 
Pavel Begunkov


