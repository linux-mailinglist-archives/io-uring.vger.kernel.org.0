Return-Path: <io-uring+bounces-5671-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E799A01663
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2025 19:40:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FF76188205D
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2025 18:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA421CB53D;
	Sat,  4 Jan 2025 18:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TgniofSo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F441CBE87
	for <io-uring@vger.kernel.org>; Sat,  4 Jan 2025 18:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736016004; cv=none; b=plbN9GYbrPbg3MR0yKH5/TEQ7eNYYuYI53BVAxT4juDkt8Aaty0dnpOcsH3i/MLD/wbXdM3mZr1lc8KN08dr34rmVtQLO+8GdbDqq/DWZXxW6lgEf0fm/Pdijux1X16PyqXdi7AfXpbf6WQkKtpr+j/Ev0DSzLeUlN5ECtksDPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736016004; c=relaxed/simple;
	bh=ajkV8VMyEaesFAzHNrrTKSbsOUmZlPI7cI5BXNEHgvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y38hwsEGnyVb5XYF29yjaDDJufxPZD+MfIMuZ0kDal8c8SwcyeZNfJEcjIGXLiyrlRvX9QCa6O4U2lo9f/67uA6goEeA6Um8q2ZpDh9OsUdSexG4R02Gw+X2ybBDvtihRoBPpEEkCniG17OkUlcCB9AA8wwabfBDMYyYz2yuB4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TgniofSo; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-216281bc30fso215144175ad.0
        for <io-uring@vger.kernel.org>; Sat, 04 Jan 2025 10:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736015999; x=1736620799; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4RsIqOSVpebSeeJdRG3moQ3XdCWCAFmQ48yB3phlkxM=;
        b=TgniofSoxtIrJHM9AW03NDFIax9syBXhAkqYgefVGUIkbRCfhf0RXDSZffngMKDRCX
         xvPMYNzCFXvV1Zkw0x8FQ/9S7SvtF2EXdhrYVFaDr/YwiSJTYWYyulpwc1qOZNAjeCbS
         fQqMRPwyG2lCh5b+Y5ZTvU856isgQk3YA17rVnKle4wqcPTm4NXSQyy2EjcNzOYw6eyF
         BixTvo5luhXNYbDvy5BMJdz9k/3/JYDFtg9XDGW4VikTO6o9i3geLDQaI8ZRh/VTRBGk
         uLBe90/jGU6EpOKf7Dc7w/vrDVWEgKaQqK9CfSMww/7kXYGVuPDojToGr9Xx7DjwQpzg
         KJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736015999; x=1736620799;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4RsIqOSVpebSeeJdRG3moQ3XdCWCAFmQ48yB3phlkxM=;
        b=BSh6Dr2gXGtV5Mkz2sGIdXrVnWdXslpaM3RVf00AjNdbIMfkig8FfA/xJT6BlSHGQW
         5unNoCl2lFk99H5QQeRtXB6rKWD1WCLP0Q8KR7qKUlp8Dzj4zjEvvZYQEsX9Jz0M9kdf
         zdW217gXvFRvs4ts+iIUdOor3MQUaOjsDn9Ox5fw0I/lRJFUojBv+Zs+pBsdbe5mgdE5
         kwt7/v5YCmWeKH61C8gXNiOzCKgr8rY9coTOotRavjWVVeKREWI5H0c6Q36SHxP1Nv1I
         NJU7apeCmuLeWirAhTJLA+hB+J1xUdgAyJHqakcqTWtJpEi4lnfGfTrg8Daja8IqkMZQ
         Y3CQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZ5MnJgjVdWxkwg8F/NaibcSN5GG0E++hP2O9qPmZ39Hb4/l6PWkTe1BGcs+8OTPo/SeT8hZzxGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxmsHljmMaI8GDLjZhL27awGAL/kbvKY3kZTf/ujmR1WVIoHL6w
	4CRyWxU3n9uJ4XWZFDkXsJPO77wyK3GdoOWcYS4svG4u6tozemX2s6z2GOpzOq2ybZiexyYgRSh
	5
X-Gm-Gg: ASbGncsHcwJ7vZfcyHrQJYYTk7UswNKy7f+blEu8JnRbOeXbnktybLxhNyA7x5frdHH
	PpF9ZCiAPKIJ0Qjk06NTlZmPlqCqp1TD2txzTwZnrqKbr3R8UMsxecbsqhbQeLq9pRlYQ2RaoTQ
	rCfi73GzKtop6vaFv6KLCrUj5uSwiuNygvJJnwHb3XYTNtxwrcBKfe5SxK561Z5Ck0jzWWT1JyT
	QQnZ52+NUvH6sV8VeG7AGAP7wiTNxO0X71eLnm4Kjoij1edf9Nw+w==
X-Google-Smtp-Source: AGHT+IHg8+N+FltKlcBNLHbpXcE8qy7mbRqbMlAhoXNycFb/7jGYTIWzWCVItRkZr0ehBoyhnDeQeA==
X-Received: by 2002:a17:903:3203:b0:215:5d8c:7e43 with SMTP id d9443c01a7336-219e6f497b3mr722640745ad.54.1736015999412;
        Sat, 04 Jan 2025 10:39:59 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842b85f00f9sm26245664a12.43.2025.01.04.10.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jan 2025 10:39:58 -0800 (PST)
Message-ID: <e37db82f-6ed0-42f1-bbe1-052c64c4dcd3@kernel.dk>
Date: Sat, 4 Jan 2025 11:39:57 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/timeout: fix multishot updates
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Christian Mazakas <christian.mazakas@gmail.com>
References: <e6516c3304eb654ec234cfa65c88a9579861e597.1736015288.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e6516c3304eb654ec234cfa65c88a9579861e597.1736015288.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/4/25 11:29 AM, Pavel Begunkov wrote:
> After update only the first shot of a multishot timeout request adheres
> to the new timeout value while all subsequent retries continue to use
> the old value. Don't forget to update the timeout stored in struct
> io_timeout_data.

Nice find!

Do we have a test case that can go into liburing for this too?

-- 
Jens Axboe


