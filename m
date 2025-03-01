Return-Path: <io-uring+bounces-6887-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 423DEA4A7FC
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:21:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D9A7164D4A
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1126D23C9;
	Sat,  1 Mar 2025 02:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pDde5L24"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388A039AD6
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 02:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795699; cv=none; b=eVOTsZuA1JRsCMBdB/HPvJZh+26NviQa2Qr67SFT4N+NFJ/wjexo7NjOp77Yp6qW/JAxvOspGye7FfjgWccALEw83fukpmmOYGqB3rtwkmhT+p/cnLMzxPUyNL7Mf+6QGUYUnhocj3ug6rjrx1mLM5cTmQ2qgP1AtWRBfxQTkIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795699; c=relaxed/simple;
	bh=/opwXwHPTbORZ2kJORaK9qqQ9Ue3HyR7u+RGB+ESrXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mzLNqsCb7y/Y4yh/mgBolqvVoV3Im0VaQAgpiup1fbLnibsHbebNZRQkrL+ZEwrvK/E8JGdBqLm+W9gtaqR+4ZLzaF48YZtVVTKoBL2S5YvBtYxL6wh4KKOVoNBSUxUO0yPSy9DmTrPEBfs6WbsbV4WNqFD2TFb3rX+bQfoBT8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pDde5L24; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e549b0f8d57so2406133276.3
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 18:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740795696; x=1741400496; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CXDfEqs5bj6MzS8eq+bwqUG0f9YhhyrXTU9Lk0Vw53c=;
        b=pDde5L24D2e3cericBRzTfXxJTP7T7doW82lLJsHZ5Y8UQveUDxom+tIcTtMKLaoMK
         BiO83m4WSjT5qwMJ8f7ErfeSobmgtIz1vvJQtY2xtExoKErp1dbEIhQIC37OWvdTTEIB
         x5x1C7hFbmZVRXWHzxHw0irj3t5T7XuvISXAo5R/UtKOm6O+hE2i5n72qPq6Z9IOfiZO
         EsYUPhTFDZiw47js/M/Bpx7hyh/p/0rVf+BeaQiW7jAVyWReTFwy2DaUBGM8Ym0XEjOT
         jdDA0BoFWj+LZPyhmY6uAAgm5/CBLHq9/yPyw4OWtW3FkIk/e3drDeZbCIPJcnbQr7Ys
         aYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795696; x=1741400496;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CXDfEqs5bj6MzS8eq+bwqUG0f9YhhyrXTU9Lk0Vw53c=;
        b=go8/u7wYy54Nkp4fNJHrbBG042NrCzggFfEbt9A5cLGtKHkR78JK+grNL6wcApDvYh
         eh8etn9NOMIKpm6AYdq7a7tk8bPcbPouj5+zZphdillilyP75tJbUV02fvHvxR5ZcvK0
         DEw8a3bCXvjYuSCzTvn9NEpqCuf4xKJ6sZlaVyoykCBy8eFfNc49AWFkO5b5RN3ZSwPg
         9ZFkmzmx/NHKvJVJYBRBktttGsV4IWOd8r7pRVxjXzwRzLNjr2E9huXrff1E6QlAdaG1
         WT1jmLnPNinJqTLPTk22BdesylC1xUHSbsHwVjrzRU/6XXQL6qlQhbDjsQsoyfjq3ifs
         jL1Q==
X-Gm-Message-State: AOJu0YzrNF34Ahgh0JNBH0ulzkpuK5QVwJZpyMBBuI1ad+V/5c47GyHp
	VB++bbCB1B3IkfuqVAv0JT3jSn8/j7MKB5cvObp2pdmoijxNsIY4eYj3LjA3iCs=
X-Gm-Gg: ASbGncvaJO9Byeq6rt8acFevDXxl/USmlmLvZtA/EJGcps8bxuL3BaD494Nhpxtzxao
	fwl+zMVqnk7xsglYPuF0a90mwvVlgIxZdUrN3/UBmx0XxSa+jsdzm7nTHJ0vRlj1ytnSryZmWwe
	B86A4+WSzkdhvoPld5oQzxNwqsedP7+s93qPhQbrg1L0QD53rKTtoCAO/cH/RkiA2Miobz2Gavp
	l06zE5sl10n9t7hzM/D1Nj0Q5qxVIVs3nVaqd1Ftitgr9bCuUCxoaOsEXRavPgkxaMQAA2tm2e8
	pBfqW9uIt+Zq9VH3nMWgWl+H0aq9uEQibPO0tO6sI52R
X-Google-Smtp-Source: AGHT+IG3cQFy6kzsgciT3E02kIQmkAuDt/kRBIBFA/pJ+WXTbfduceKjLTjkiEsjjVpiBnpt+apwMQ==
X-Received: by 2002:a05:6902:1b08:b0:e5b:1453:d2e4 with SMTP id 3f1490d57ef6-e60b2e9e0c2mr6994366276.11.1740795696133;
        Fri, 28 Feb 2025 18:21:36 -0800 (PST)
Received: from [192.168.21.25] ([207.222.175.10])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e60a3ab1270sm1418568276.55.2025.02.28.18.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 18:21:35 -0800 (PST)
Message-ID: <524be10f-c873-40f1-91b7-ae597dadcca0@kernel.dk>
Date: Fri, 28 Feb 2025 19:21:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/nop: use io_find_buf_node()
To: Pavel Begunkov <asml.silence@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <20250301001610.678223-1-csander@purestorage.com>
 <20250301001610.678223-2-csander@purestorage.com>
 <d4271290-2abb-49ee-a99a-bc8bb6dde558@gmail.com>
 <e84d5e50-617b-421e-bed6-628cacc28cf9@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e84d5e50-617b-421e-bed6-628cacc28cf9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/28/25 7:15 PM, Pavel Begunkov wrote:
> On 3/1/25 01:41, Pavel Begunkov wrote:
>> On 3/1/25 00:16, Caleb Sander Mateos wrote:
>>> Call io_find_buf_node() to avoid duplicating it in io_nop().
>>
>> IORING_NOP_FIXED_BUFFER interface looks odd, instead of pretending
>> to use a buffer, it basically pokes directly into internal infra,
>> it's not something userspace should be able to do.
>>
>> Jens, did use it anywhere? It's new, I'd rather kill it or align with
>> how requests consume buffers, i.e. addr+len, and then do
>> io_import_reg_buf() instead. That'd break the api though, but would
>> anyone care?
> 
> 3rd option is to ignore the flag and let the req succeed.

Honestly what is the problem here? NOP isn't doing anything that
other commands types can't or aren't already. So no, it should stay,
it's been handy for testing overheads, which is why it was added in
the first place.

-- 
Jens Axboe


