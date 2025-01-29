Return-Path: <io-uring+bounces-6184-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB068A226FF
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2025 00:41:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10A3716583F
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 23:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFAFC1BBBDD;
	Wed, 29 Jan 2025 23:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DJgymh+6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171E4DDCD;
	Wed, 29 Jan 2025 23:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738194103; cv=none; b=JjJHcBu5x57nH9dIHodPXcj1fxri1Zz80gp8pR7FGhwLqpF8BZ7kzbaxl6dg63nAAoZjlgzP0cv3wfn8KwYgRUy2yFOXe0dU4gJiDq0YGxQn8rBFrtd604GCjXM/hat+juquVuFrQ4zcfJ+UXrppAtUDqb2MtL3BoZhZhA8qdZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738194103; c=relaxed/simple;
	bh=GPNZh4UP344tZoQklzSKVD8xy4FuzDzwE9l+qmh52Gk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TtlPatfY8naG65c4IL5dIaaUUB1uZa11wifJK48rlsnO9aSFcfigMsh3HsoT2GkT6d8tetAV/8av2M2FrohFj17p/BIojTkOxnYNZsjhlBbFHey5jnm8p1SBZKTW0nY6LikC8FcK7Z930HJs/IB0vSFHRpuxzDapWy5l5cKWpQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DJgymh+6; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-38632b8ae71so166825f8f.0;
        Wed, 29 Jan 2025 15:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738194100; x=1738798900; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HUzKH8C0iBNYZ1qqOylyzV3nR3er8SFNRSObwR9d1uc=;
        b=DJgymh+6ufbDat1DRc10cCqhlar5OX7dj97YvmcFUQvSXIhTDtCJBr17BKqYieRSyf
         R09/AZi3FhDgWYarq/3NP+P0+M4fwNof/NZR4gjcgbX9GvGCKc8nJsvm0qbMSSWnTzH+
         mcBfnz4uloZtrx102/GYjQMRm5F1cjCY7z46areLk2nxi/hZQPTc/2GxrOYeQQ/4t94k
         XtbkSFtpWqpRZw8q0iOu7bhgk4Yo+r/s7p4wdmha1Rmh2ERm7giIRv8ih4qcdUNoD6DG
         Qyta+4n3Fq9JgJJxuDCQc+jYMNychZnnmDjfSIXuNsizJ8rfNCFgmtDoX8oM2BTjneJ0
         MNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738194100; x=1738798900;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HUzKH8C0iBNYZ1qqOylyzV3nR3er8SFNRSObwR9d1uc=;
        b=AnP2Z6Tlxerrn7jirLaPX8cwhc+tJYj2rrXa8TXWYaWxx30axzl5pB8eLkNgiigiVp
         PktjyMCvYqQ4077uddI9VT5HyuyHGQCijhS+PC5zYaK3lXogYmUSIWOKX/13taYpx9XQ
         XCYUOSqa3Y1YPBMQzjAktQX+mbKM1h+8yPdKs4xH9fTyJEyui1/KMgBoBQIQrU7doDIv
         tH2OHWC8Pvfg8uKRD8C3ACXP0tGWvdeQ+pPXWkasFwj53kk13ZUKrufNhRi2LmwH+G5f
         Eit7tuC6J1ACVIwVy0kU3C5NHbe8dIY+RZSxsEZn3iXIWv7UrYDWpEceEplgYCeAYrY1
         mgZQ==
X-Forwarded-Encrypted: i=1; AJvYcCV32gbCf8IzPz7jJlG92/GwfZQ2kJtd27M0Rl9HhUtSBEQfNLCfDAaVj5pC9QKIm9l6hwzwEE3y9A==@vger.kernel.org, AJvYcCVO5MHNcBwN2isaYkfgx+RKBqhgWm6mRWTCfEDUmoFT7iUZGFgRDlIVCql4ajgeKCqQpwuntzZ5xOiLxGv2@vger.kernel.org
X-Gm-Message-State: AOJu0YzgOwI+AUJQ+EkECIjCr+MXsnfa5KqI4UAE/yx0/Kbg+sE0Vu6n
	/aSVhGU5VWOOAU8mS0stfRa8gAIMFri7af5Io5aZOscKTgTFIMOaYkULmA==
X-Gm-Gg: ASbGncuzVnnu+x5N7gH1nJ4PR9Y7nva4/L7+XOkfHM4Z9b7C2rF3H4ZcP9ER2mfp1UL
	T89+cALIIyJj/ugKPzIL9yTtbnlDyXn99SzlMS35mGY+scrNg4ItxTE8slDNORa56FZeJOTHhjj
	Pom8T6FiaYHRo7At0G6J77pfPWSXgg70QJHZOkjuldmXF3z8JKqXtpJDGqBUK4TIX/uP7ldRNza
	X1eyOc7CcIxcmMSVIAPU8tkG6FZKftvhj2duWhi/ee7n3Zi0KIKE9eq6pB/MVByy2fnVHehH7zT
	ubMxpG8XoLx97WmhTQOe2B5zXA==
X-Google-Smtp-Source: AGHT+IGbeskgmvzahMW2Xlcd6uc4B+31rODBn9iByed/S2JzjUCO91HFhDaZJnr/8IM0L8DkozWDUw==
X-Received: by 2002:a05:6000:1863:b0:386:3327:9d07 with SMTP id ffacd0b85a97d-38c520bc84emr4150419f8f.54.1738194100201;
        Wed, 29 Jan 2025 15:41:40 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.217])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c5c1b576csm212447f8f.63.2025.01.29.15.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 15:41:39 -0800 (PST)
Message-ID: <19750632-1f9d-4075-ac5c-f44fab3690a6@gmail.com>
Date: Wed, 29 Jan 2025 23:41:57 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] io_uring/io-wq: cache work->flags in variable
To: Max Kellermann <max.kellermann@ionos.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <20250128133927.3989681-5-max.kellermann@ionos.com>
 <856ed55d-b07b-499c-b340-2efa70c73f7a@gmail.com>
 <CAKPOu+-Mfx9q79nin7tGi1Rr4qGGY=y-2OhuP80U=7EtRpfBdg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAKPOu+-Mfx9q79nin7tGi1Rr4qGGY=y-2OhuP80U=7EtRpfBdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/29/25 19:11, Max Kellermann wrote:
> On Wed, Jan 29, 2025 at 7:56 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> What architecture are you running? I don't get why the reads
>> are expensive while it's relaxed and there shouldn't even be
>> any contention. It doesn't even need to be atomics, we still
>> should be able to convert int back to plain ints.
> 
> I measured on an AMD Epyc 9654P.
> As you see in my numbers, around 40% of the CPU time was wasted on
> spinlock contention. Dozens of io-wq threads are trampling on each
> other's feet all the time.
> I don't think this is about memory accesses being exceptionally
> expensive; it's just about wringing every cycle from the code section
> that's under the heavy-contention spinlock.

Ok, then it's an architectural problem and needs more serious
reengineering, e.g. of how work items are stored and grabbed, and it
might even get some more use cases for io_uring. FWIW, I'm not saying
smaller optimisations shouldn't have place especially when they're
clean.

-- 
Pavel Begunkov


