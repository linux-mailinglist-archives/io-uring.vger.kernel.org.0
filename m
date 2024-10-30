Return-Path: <io-uring+bounces-4201-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F0D19B63C0
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 14:10:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 565F3281658
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 13:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A3721EABD0;
	Wed, 30 Oct 2024 13:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="njkWoBCm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004EB1E9097
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 13:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730293792; cv=none; b=u1J9KkVhf4uo9HTkE4V+68x4PDdcokpnc0CwjI8J0GYh2Rc4uT5yz19jY/VVC0e6WaK9EwsELw905YuegEu9RPS1WoR20xaIv6kiMnmBqLWKefDdvPFqaXCqBHlkzuoHpMey9U8mhkvJPWqZJj9FqHejXz5uIhe+Hso9xclzlas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730293792; c=relaxed/simple;
	bh=l8Vaqm8vvg2grcGZZMWtn8dZK5+rrhiM54tx+OtEKpQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=c8VLztgNPpB1xNeR0Ka3mJHR7CqOFFf7VyM71d+XIL6Sxes3U6zabVwa9xQ4oojWQXOBMWddPa4yC8qhqmXzuKs+FZU2Gs9xjGs/yVzCpkQEavtLF6z6QjyDd8C+febVyjmLJF92pQrpwvbjiAFh/tSaLN1Jdl3QNlec2nB/pQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=njkWoBCm; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-8323b555a6aso353974139f.3
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 06:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730293788; x=1730898588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N5uFWxZgbqN465Uc4jqzPSiXE3iBEC7P8OPuQ7oSz94=;
        b=njkWoBCmtdDPdEkJI8oxqxwFx6XFnq97pWyHXt479kujWINxtzgugnn+p3Ktl5N1qk
         TAz7jZELMX1oiR7fFO4QlifXhSyuOna8421DIODNoXDcIcCO3XA+p9q59RizcBKdDN3t
         GJ7uo1FDI51aM51MEGg+P4ZltEihVXWm8blk8PRFWNflgNpq/WqrJdGXSPxkvf1JxCnS
         q4uNdRmfe4MypsGwV64HV9WIKcZLOUKrqSmy85nRV7UyUVuS7gjuXcijW54VZvsnszpb
         ZFTQ67BHvTGPwMgl3JNl03k4SQRsdQOyDl+zWZBTHojojCG98bT11SHkXGCEAyOU4T8c
         I8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730293788; x=1730898588;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N5uFWxZgbqN465Uc4jqzPSiXE3iBEC7P8OPuQ7oSz94=;
        b=UpnnzNlacUZyDmn6aJDD5mcrLviMUeTdycQXYlsqc8l9/nTVS0c8B+oFkzxDISczgS
         VNeN85r4zqVIUkUb96YdDwCLSlg2WA6JPu40tlQLlkJOnGiy8HijN50zyxqbQfKUOsVT
         jk7KxQX1MGcYaq+yMfOPKl/entxaAxtjnm5l4Mshmk4fYuKQO1UHQmxew44TVXs8uPKE
         L8U+0KLoVAsCndp7HaKWC/fsZoOjC3mRZQ+x6h9+zmOPY1AvAWlqQV879ErITFj7ioiE
         YM8a8+6iongVCTflRs3WkXdydYFgI3R7mTY0Gb9r5ZJ6URVIjEdL8CFu1KZRIHZU41Cq
         u1VQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVrslzzZd39Z6J2aCmwjXWXUUOu7d1CM1MaOe39XLYHv9VLHw56cwGajEf3UZrhyAh+lTG7gME3Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyDJTpaPaphrhwzvNEMknIgs3rOyeTJJShe1ANWT6T5nGKG4IWN
	tiiCbyFp9UoukBhZG+DLxnTo443wun9LALT3v5eKGnoRnatn6iG5ck5JTxfjTosDfIecDRz+9BS
	Q
X-Google-Smtp-Source: AGHT+IFQb4lZiBi+1U1zfzQLBtmJOfTwNZe/OueVbEgtpfPH0xKP6fFxVkr3LuD7QxaPgDfm7eVnKw==
X-Received: by 2002:a05:6602:14cd:b0:835:4d07:9d46 with SMTP id ca18e2360f4ac-83b1c5eb908mr1288945239f.15.1730293787146;
        Wed, 30 Oct 2024 06:09:47 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc72751298sm2872855173.91.2024.10.30.06.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 06:09:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <762b0c95-f4ce-4fb3-8212-01e216f683ad@stanley.mountain>
References: <762b0c95-f4ce-4fb3-8212-01e216f683ad@stanley.mountain>
Subject: Re: [PATCH next] io_uring/rsrc: Fix an IS_ERR() vs NULL bug in
 io_install_fixed_file()
Message-Id: <173029378597.7840.16771277924370009156.b4-ty@kernel.dk>
Date: Wed, 30 Oct 2024 07:09:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Wed, 30 Oct 2024 12:54:52 +0300, Dan Carpenter wrote:
> The io_rsrc_node_alloc() function returns NULL on error, it doesn't
> return error pointers.  Update the error checking to match.
> 
> 

Applied, thanks!

[1/1] io_uring/rsrc: Fix an IS_ERR() vs NULL bug in io_install_fixed_file()
      commit: 9b79509ce43370ceaf582bbf752aaeee9d40c9e0

Best regards,
-- 
Jens Axboe




