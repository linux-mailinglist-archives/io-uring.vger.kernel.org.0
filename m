Return-Path: <io-uring+bounces-8404-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E1700ADDC1C
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 21:16:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5219C1940632
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 19:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98D3925392A;
	Tue, 17 Jun 2025 19:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="a9W//7J6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9647A25178C
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 19:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750187814; cv=none; b=XvC6NhZFkwEgCRFI5JZZrw6umiJplm0dQm7zM3wqq8NZYfaNhu7AcqW8DBnjED9xG2TYgAKfVcb6RmjTuoyk6tbdQtiXIkbCkF6WElgfiUGIo/3R1yvOftpKiWD7A8pCZXR9zTONFJhkxW5i7TTIXJeMkJedycHGRAOklp3liZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750187814; c=relaxed/simple;
	bh=cETCCyzPy9hFE+u6eC1pUhF4X0HBKJZTcSp8FaPlN4k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qzqnWSnej/agPofgEbdu53pTsX3A2kbfeJjaaIwKMZPxHJGVo0Lectk5VwQ3WJ8qAhm2hZUZ/opvqSw2s+26ltjr5Or1jShOjytSP0iMHrpd6m4fgVAG0Q+4mVNG0nJNr/vsc7wIP+I5lufYV6GEwMant2bvcvVLqg4R88/9iqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=a9W//7J6; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3ddcf0edef6so23100185ab.0
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 12:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750187808; x=1750792608; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TGZaJ/Cvg6in/V9y2savh3bnkZfVAwIKjIQHzYORKHs=;
        b=a9W//7J6nxQz2DJEkNInh3jD637XcGC6glVPhd6vbAoMC3YQGiIdlt7XPXGnEgWmMz
         4aw5/8mcv/oRwohArMXK9912HTGlusX+UidsHd1EdjkTDArYsHmrOg29BZRc/4ExJI0G
         AqaN2ufYQ2Flzwz8MYFnQx49GXN+CvwC8PuKE8Q3Lil/GdkcfKphwyTncaI/z4fNaSUL
         T1DHL4J9gTwlzkbBqJyZ18DSY3WaVHcGjx7O/l2twX90igx/55JC/8BD8Y7f4hHgAcxN
         y0OOuG+h5Dwl7L8T+4MA4qUdSKqWz9tzuinb6ohvZzSIOQvEjh8TL8GYkqgzSGyJsHmZ
         AFJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750187808; x=1750792608;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TGZaJ/Cvg6in/V9y2savh3bnkZfVAwIKjIQHzYORKHs=;
        b=pTHqymRN0PlUG7YGbB4/LQePwb7qdr3xcg5iitNfzNhP5pw2Zc1W0voEkIWyMwyoTr
         YZ66Cb0S0odXwbLTw6LAnYWTUA0Bboc8rj/1y14DYJ78GIJEG3yffiaI2CzZ2RkFXqSl
         nKC6mOExXzCvKw9eA0EF3iL9S9/pbnBKXqIqSKnYZUdPQXrdTXUBCoJqf70KlwD/nx2a
         7Uh6M97FEdmfjkYFUxXmv2FZVN67cscj1COCbaAlhzMK3+y8bljqFHJS3CoZadhNm5It
         BpBLDnnuw665A6mSTDCTAvda9s1ChDzx/HNqzspeTWXEJwqs6aPmEgKhQhRiqJjnLmm2
         2LrQ==
X-Gm-Message-State: AOJu0YwocXn5H20CuNJkNhbppAuYoZMyIaVTWbwhDFY1TN/yHvxV2mp2
	SKXzhGt0dhd+7HJ5G5cHnQ27vkDhC7iIXvIAGmLATQh3fuX8dqT+SCF2BvDa3xoYDoUcNUZtMyf
	3cS1g
X-Gm-Gg: ASbGncskZiu0jCcQZ9qCs0iY8Uk3dLdtfEs8F2wTvgKbRdvAbrJx73KfSJ4cpIvYbzm
	34bhCGPn3zWTNkyV/SbkjumjSlwEPnyN5PcwZYG1wyMNzrsQc2kQf19IJcapxJWmGAtVngnlrPd
	OxQO5AT5jzW7mYYPQE0zqIIK4/R0DPoK2qFwc/xeUFrhKsL5PAlfELfq8k9SDPbIkwZrwDfOVjH
	yLQ4MGUQ+B1mZCpuVxZcj2XKN5mo9vYVp2kjAZKmVLtqavH3Vn7KGTts+xgCCrGFaN23ZT0+UUj
	c9EqHxRl6GRmTp2aoj+ljZK9oLFHge+dgQH2XpydI9109hAhMqktJqtUspc=
X-Google-Smtp-Source: AGHT+IHZb/xHZN8aIMEnsrhDl0t+MUeuRXxywDBfTT23tEd8eUGtnebje/5gNn9701m5xQqUcY8AGA==
X-Received: by 2002:a05:6e02:1a06:b0:3dd:d98c:cca9 with SMTP id e9e14a558f8ab-3de07c4c2d9mr190318385ab.3.1750187808396;
        Tue, 17 Jun 2025 12:16:48 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3de01a453b4sm27723395ab.47.2025.06.17.12.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 12:16:47 -0700 (PDT)
Message-ID: <3fedba95-7a5d-45bb-b289-a2edc3d690e8@kernel.dk>
Date: Tue, 17 Jun 2025 13:16:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: add header include guards to all header files
To: Vishwanath Seshagiri <vishs@meta.com>
Cc: io-uring@vger.kernel.org, Vishwanath Seshagiri <vishs@fb.com>
References: <20250617185001.1782992-1-vishs@meta.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250617185001.1782992-1-vishs@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/25 12:50 PM, Vishwanath Seshagiri wrote:
> From: Vishwanath Seshagiri <vishs@fb.com>
> 
> Add missing header include guards to all *.h files in the io_uring/
> directory to prevent multiple inclusion issues. This follows the
> established pattern used in io_uring/zcrx.h and other kernel headers.
> 
> The guards use the format IOU_<NAME>_H to maintain consistency with
> the io_uring subsystem naming conventions.

It's quite on purpose they don't have guards - because they don't need
them. These headers are included by only C files, the ones that need a
guard would have them (eg ones potentially included in nested headers).

-- 
Jens Axboe

