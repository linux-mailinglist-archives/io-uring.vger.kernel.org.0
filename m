Return-Path: <io-uring+bounces-6883-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D46C7A4A7DE
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:10:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AB8D18983BF
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1486022087;
	Sat,  1 Mar 2025 02:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mp6laf0W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6716D22066
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 02:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795026; cv=none; b=ESUrGOU23MGYlVJv0hdFeOSxOFqhc8R6IqPhypBKbtY5FQ+w4pY+uCMIIZcpACn2fWj1ANQPiz8yE92WHW1Ty3DN2F9800H9sCHyOXZSngTw4ppeR9wiVFYMFxV03g1alHPG4YympCsFQ0KyVza4IwI7ehhRKSmILYp5Y0hhTr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795026; c=relaxed/simple;
	bh=cOqR/qGcS7+aoTuth+4VWwF280pMk6Npby2RKTfkRMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FNCFutnyk91UknD4v87gfOXex4TCkzpR/MFY1iNP4qFL1jhkHJf7fBDNMvh+uI0jd+IwfwhpedIF2SReWX8V3kLZtfL3xMalQ2hbq/YcU5mkx/wS9xDVFlZULUq6+EmcbHlU4AN0GYPg+IMh7WjNrUFWz7ilIBaBUVgm41KC0Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mp6laf0W; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5e51e3274f1so184453a12.0
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 18:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740795023; x=1741399823; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0mahqV3piLkX91uYcafXIPvrIgqxY0UElMaISteuUBw=;
        b=Mp6laf0WDe9IOFrzr3S7VCWICFdkygu7/Ds58OIzW4v/8PAcSGYsxOseuxswgcBZdE
         8e/66e0rUG7YyUV2np8Klg3KtI4WiyFq/miCCHpSwDGUABHpQaie6ozL+dc3SWo9tRpN
         Q/Uhys/jAE+oaZ0G6YqEHVu4OlozJLRMghZH/hCRJiNyLFWlhtcu7JiCFVWJhwkaUqYT
         bsRgCL9h2C9+EWNkiY1Uk9c+8mbgTGB3cNNneFWNnxZ7cPbhj07+FIW+wYxPTDbKI4dx
         mkfEwb9HvnWJ7gGxFBHTfE9Cw322W/gkyvx0vybHSa39E/fQ2ASi6qqkV3FW7QnbLKD2
         jEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795023; x=1741399823;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0mahqV3piLkX91uYcafXIPvrIgqxY0UElMaISteuUBw=;
        b=c8dAsGTWFdsaVArWjHE3k9BgdPOMqZfXfiHpcnvCIekc5nfjGDjn5UTsmZuvJP5UNi
         Nf9KR6IiFOaaKLspDoEYbPNtHxuwMZZblrk/SqwfVcT/VXRhm6AIGU0aXhJeBK309RRX
         q0l770lSRpXOMSh89q9fE2zd9kDN59hVWMZPNDoH14rdzzASNnXY426YVdD8Lb234hC9
         XYOxYMLXH3nPcAK2jK+j/5cEwY+STH5NYW0M3jYDHJIOFDuIUlvNIBeqmdYD4dwmiyt9
         61wNNf7HUYkcjZ9E2fBg3IzKQI7eKJYrzepiNotRHtGgXlVbCmZDGO8hJsnBft4mZ6eR
         ty9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgO49hYfaG3QkGdiZ6NxWesDD7rTl2kDAQGsgE3XENwJJtOiboV1YLp8gkWgzX0FOVG1f9tW8H6w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7ZcRwxqviHbOdxRqt9jlu/yTWJOuMjAEEWUPRe2W2P7HposXL
	zCEZN2+XDnL1vpMZ2otkoJhf8dffv0vhI9X71l0vTidZEpf8LDtI
X-Gm-Gg: ASbGncub2lRIFXRKJ+cQrvR4z3CTDdITauc43DquVpPPIhqXSn27TTLyCG2ti6hqHE1
	D7XyWrw5YbCjLQ/kHFIgLW6dlFLB5Y4+7pYoOGyXWQm5WoDYbGMQHhD6Ka3KuVQcDLUtCVTFvik
	kz6cyPXSElyAZcUhL23m8hf5iCIcnVUYGtoxXFHrABfAN7rAZTCPK7uaC4OgI+HygoJCbZUnY69
	h3TaDEBL7IjK24kfVcDDCo4qqdf8A5IvazrYovYm71YprpssPibK1u7F/OHkrjfGN9FJKzwPrLI
	3DXUG6/3VdDWVr/ISaAI6fspcZDQxjBudxRoHrs2NnyCmGTPOlPeQVE=
X-Google-Smtp-Source: AGHT+IFqRhsEduqiaNtTPfwXJtQ3No4OFtI9lz40lG//nwqK28wDoOZ4h4oY+JBSxQtSlFepmIDsHw==
X-Received: by 2002:a05:6402:51cb:b0:5e0:3447:f6b7 with SMTP id 4fb4d7f45d1cf-5e4d6adeba9mr3636405a12.8.1740795022539;
        Fri, 28 Feb 2025 18:10:22 -0800 (PST)
Received: from [192.168.8.100] ([148.252.144.117])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e4c3b4aadbsm3300326a12.6.2025.02.28.18.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 18:10:20 -0800 (PST)
Message-ID: <8df34da9-2a35-40da-8923-a90d2d02b594@gmail.com>
Date: Sat, 1 Mar 2025 02:11:27 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/nop: use io_find_buf_node()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20250301001610.678223-1-csander@purestorage.com>
 <20250301001610.678223-2-csander@purestorage.com>
 <d4271290-2abb-49ee-a99a-bc8bb6dde558@gmail.com>
 <CADUfDZq43eAJxsnZ71hnPsoJsM9m7UnLWBMavUYwufiTu+UBow@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZq43eAJxsnZ71hnPsoJsM9m7UnLWBMavUYwufiTu+UBow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/1/25 01:58, Caleb Sander Mateos wrote:
> On Fri, Feb 28, 2025 at 5:40 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 3/1/25 00:16, Caleb Sander Mateos wrote:
>>> Call io_find_buf_node() to avoid duplicating it in io_nop().
>>
>> IORING_NOP_FIXED_BUFFER interface looks odd, instead of pretending
>> to use a buffer, it basically pokes directly into internal infra,
>> it's not something userspace should be able to do.
> 
> I assumed it was just for benchmarking the overhead of fixed buffer

Right

> lookup. Since a normal IORING_OP_NOP doesn't use any buffer, it makes
> sense for IORING_NOP_FIXED_BUFFER not to do anything with the fixed
> buffer either.

That's a special api that benchmarks internal details that no
other request knows about, no, that's not great.

-- 
Pavel Begunkov


