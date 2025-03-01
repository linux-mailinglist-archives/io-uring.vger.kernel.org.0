Return-Path: <io-uring+bounces-6884-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25897A4A7DF
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:10:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B798176A9E
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E6B122087;
	Sat,  1 Mar 2025 02:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XRU4KZLK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7939022066
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 02:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795044; cv=none; b=peLjw4taVdahrv6O25Cct4nYHczn6j+XcU3KkHEOCbz64FF9PpvRsrRw6vNr8asVxL8HKPm2oiUiWZggopx8kxsy9nrYuDEqD0Mjg6yLXIIOP5GennSEWiF1y3ggx9nv4LFMWammgD1JH94YHLhOp9eCMj9q2p/MPg+KOCKXi04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795044; c=relaxed/simple;
	bh=9261k/JMyMW8MLF5zplasqCezSk3D9hvCAtoOy+p3U0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X9h/+qDsL6U1HpxYdr+n1PGy22VHKqLKp3NE9hcfUE3RXlXFYaqUDXItuOzUWaWu7dJFliNAqBgPIWYrFKJDPl2Q9lCZaeVt0+f4LkFcxvnyA94hWTkD3YoUPAltGTctHaAfxpYu1+6pfAzNeb+v2nAOkiOsbjqb/3eT4+ty6uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XRU4KZLK; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e4419a47887so2104462276.0
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 18:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740795039; x=1741399839; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=09qadItvt5JtrVveWufctzOgK2uYn6wVSZVQ+efA0hM=;
        b=XRU4KZLKLuDB978ql+ps1333wcMpN++x9mh/+H/twM/JxUkj+IjS4J8RQpRoUh9NcY
         tWi5EeeZZ9VUIn7rmbL+r+pl3DMFzz8ZEfoX1qbco8dkNKwtODJWj7Evj55RxxSsgRhr
         RD3YavkAG2IEx0KlUdJ9sbn0KjnwcwVWBY6bdmMNkeL3BsbahSOAXYO4vI1L6PbdtHye
         geARAOu1kaNPkUhsVJ54P4LlVTi3PO+fh8y+RHcJNcnpH+GSCkZ0aJ2YACSQ1GeVXuO4
         LZZe9f+eKa1tsc/kFnIJri1l4IyICyHop2kVnLECE61t9Kam3JIzpqu7RbExCG5kdwWt
         WbMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795039; x=1741399839;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=09qadItvt5JtrVveWufctzOgK2uYn6wVSZVQ+efA0hM=;
        b=fdp5gM2SvD1o7vx9WgwAzgDW2HJYMBvvX7oJOtErTh2sgGtfLBcn1vAfOvLhV6M/WV
         KPqHoJ4Sjpfzrn2Xkh2oBV5qzIgQq5JA308Fi6GidxMVDy4rRvqpVurSM9asBmxSubGi
         K6so44U8+GUNpXrgpopWCKkMtWr8ujxAMF625gcQh4m0kSSmECXbrhMtj4W9ucacNEOO
         CwiELD3R9ROVKDqnIOM8FSCFlICB/QBWEfZKcvKBxqzcVjIq7aZ50fAI7PpRay7UX4wo
         KyX6KakBLX+J29/fLLAFALR6uAGXDPIT/4x644zZz9Ioy0ec4AzmB4zh4dKQjtk+aj4Z
         7Ghw==
X-Gm-Message-State: AOJu0Yy0p2LN2lqLr7YaGUuPRtj3lVL7lzQaEm6tDd9igGol9VF8bWBN
	KY4WI4oOrElwmjv5xjUDBD5jRODqP1aDn0ihu8T0nkpMj/M3IZ3hSf2k1AlTpPA=
X-Gm-Gg: ASbGncvMMQzMhVleENemEHthVOgkSRR0mUYKyWLu1kj3J2as+euFeTOP4pG3wFI00x3
	etGcJPnYeq4I2ZxEHdH6CSf/JxAnv3kd/zRINwIoT6i1fQCpZpOuAU5mM2Ps41wJ797ntjFRnHp
	ie4oLkn2roji00WB7Z3UyW9LsmATzAwleL4FPbgvEwZLQ0enCmynqOGthWLxYBC32ZY/c4mOUFz
	TeqE8zAo3oIW06XLK8iVv4HSO8NjNvsD4+NuNek7KHVf5k90OHkdqSZCHuWQYbivMNHjtNHO222
	T9TeR7OQp6uYdwHRqz0/lYqzziGvgnbskkr66r67tcLJ
X-Google-Smtp-Source: AGHT+IH9ZS5mB8hYizHi/Za7ggNM80bAmQw/GKfYWYtNJtqNYWKMloa36T54H3pi96ujrDDP7626kQ==
X-Received: by 2002:a05:6902:2b8a:b0:e5b:42c7:8f28 with SMTP id 3f1490d57ef6-e60b2f3ed52mr5795140276.35.1740795039077;
        Fri, 28 Feb 2025 18:10:39 -0800 (PST)
Received: from [192.168.21.25] ([207.222.175.10])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e60a3aa4f5fsm1402391276.46.2025.02.28.18.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 18:10:38 -0800 (PST)
Message-ID: <0510edfa-8ccb-4ef9-827b-f7ef9be10b5b@kernel.dk>
Date: Fri, 28 Feb 2025 19:10:37 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/nop: use io_find_buf_node()
To: Caleb Sander Mateos <csander@purestorage.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20250301001610.678223-1-csander@purestorage.com>
 <20250301001610.678223-2-csander@purestorage.com>
 <d4271290-2abb-49ee-a99a-bc8bb6dde558@gmail.com>
 <CADUfDZq43eAJxsnZ71hnPsoJsM9m7UnLWBMavUYwufiTu+UBow@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZq43eAJxsnZ71hnPsoJsM9m7UnLWBMavUYwufiTu+UBow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/28/25 6:58 PM, Caleb Sander Mateos wrote:
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
> lookup. Since a normal IORING_OP_NOP doesn't use any buffer, it makes
> sense for IORING_NOP_FIXED_BUFFER not to do anything with the fixed
> buffer either.

That's exactly right, it's just for benchmarking purposes. NOP doesn't
transfer anything, obviously, so it doesn't do anything with it.

-- 
Jens Axboe


