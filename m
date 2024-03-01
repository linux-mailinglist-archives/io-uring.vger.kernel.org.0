Return-Path: <io-uring+bounces-815-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4095986E717
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 18:23:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 708E01C231D5
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 17:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B1C6848E;
	Fri,  1 Mar 2024 17:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LOsV90QX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541955663
	for <io-uring@vger.kernel.org>; Fri,  1 Mar 2024 17:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709313809; cv=none; b=Ys6sYIMJ0wdnuS3ZbVZoVnoJHQnwICouLrqM7lo7KWIP6slYRvT1n6vYHQBesZT1bs5iR94Z6Kbp39zhAAGcDubzhI3/HVpA9VPOIAbn8K8BhqMun0z4fP59reUqO7p0InmYB3RYeetq7dVi6F7zWQbYE8+WGD2lg3tMzCViUNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709313809; c=relaxed/simple;
	bh=ZB41xxYjV5A+nWYJEkfqZuC83VuREIATmp7V3mKC6cY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LEPnq1KF94A3taCuO42wcfnVehNf4y9A0a5oHd32v1jwFeeiL8VirWcs1MGqpWpnvKWlVolRhgXsgo/fw8gjFzCSCuOG5MuPEoFSjhTS5GZnbzTBss8YR6so+FjrZQma5rkJOuzuNuzQZfA8yDQW3sYO1doqE1f/Ia3SkDylqI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LOsV90QX; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-5fc05784c60so3039997b3.0
        for <io-uring@vger.kernel.org>; Fri, 01 Mar 2024 09:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709313805; x=1709918605; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GesJ1JUX6AzHnSVJK5O06OdbpXZSjoyV0Rx4Wyc+lJI=;
        b=LOsV90QXYpin+VPG0pmevGnHUUBTbM+T+45KAW1yzZtty4D3qiQ20d0El2JQbvh3hA
         qKZVoJhOL6t/pr5sWGNhwoWSY8i2jmx2I2LEmqY8334hemy5P++50GqdptEbSJbeGkT5
         D2LlufmFSMMy1aHrTczigrjSyNl9+xYX7z3dGesAJkzDf723Zo72G3vOlZB0Ysufsr1k
         XoC+kd8D5A/XdyA4ffQiFNNKHea68XL+wgyswp+vjID/yfisJwq65reSyEg0MtubB5Cq
         UX+VXS+dlKEJ+EpHQJVoq7ZWPsuPFDa0D97IYP2OYQRaFSfhiub2v3yhWST6jigtIb6R
         9vZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709313805; x=1709918605;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GesJ1JUX6AzHnSVJK5O06OdbpXZSjoyV0Rx4Wyc+lJI=;
        b=FWSb5phCB719XoXVEZ0pjZptdyIgU+FhktxSx3luCJhLbUkhm/o0lfUkAM+9+ugcNE
         qSOv9IvlBj0/S5cR594CW0HgbkFwCoWxGlFs9u+ctHK1/kY/zZTrX1hefVb2G7L99y1G
         Z7yIg02itQExuoKPO7hroHQBHhVLi8kpLF0id3oAeswIGkkeJk+6dOQyX5lXkXKBgU5a
         ciWy1CcY/53nKKehiGVs6obGugGLai1Mtzy2GJPHGMbGNDPVQgk596+aQKmZlYBVgHnT
         Y7362tIv/UevVxvZGFf8fxyD1y26q4Vr5Xjo6G2wibvpHeZcDX8PVzQmW4vnIgpPC9rh
         8x6w==
X-Forwarded-Encrypted: i=1; AJvYcCUSAGLGl+3jhg75e4zAcJop4pMnyLzPgvzvCQbD5ZWE4eLwIeajbk86oEsNyksC84jzqzX5xPiTtBM+0b5yhOqtMpXWb28CbR8=
X-Gm-Message-State: AOJu0YxolPdwEstLH5FfIj+Nyr0VITxMvTk5qLzin26G6gWpJmrvKrmV
	MzITTbYjn3pjqblMCe17dyUC8NIQqgsHNmhO1czGz+CfwTXLJFbO1jWFzHj8ZCE=
X-Google-Smtp-Source: AGHT+IGC0G34ue7Mz6Bxa2+Ac9u3TgFULDTUIHDsYIc8Bej77mS7rq/TVrjQa3q10GvBOOUZsbMEmQ==
X-Received: by 2002:a0d:e248:0:b0:609:722b:1bec with SMTP id l69-20020a0de248000000b00609722b1becmr2246600ywe.1.1709313805287;
        Fri, 01 Mar 2024 09:23:25 -0800 (PST)
Received: from ?IPV6:2600:380:9d78:b2ac:81c:a8a9:d9d1:d5ee? ([2600:380:9d78:b2ac:81c:a8a9:d9d1:d5ee])
        by smtp.gmail.com with ESMTPSA id x2-20020a81b042000000b0060987e4cdfdsm239325ywk.117.2024.03.01.09.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 09:23:24 -0800 (PST)
Message-ID: <8d04d4e7-5d89-4ec4-8069-2b38ab350741@kernel.dk>
Date: Fri, 1 Mar 2024 10:23:23 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/net: remove unnecessary check
Content-Language: en-US
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <7f5d7887-f76e-4e68-98c2-894bfedbf292@moroto.mountain>
 <3d17a814-2300-4902-8b2c-2a73c0e9bfc4@moroto.mountain>
 <da610465-d1ee-42b2-9f8d-099ed3c39e51@moroto.mountain>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <da610465-d1ee-42b2-9f8d-099ed3c39e51@moroto.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/24 9:56 AM, Dan Carpenter wrote:
> On Fri, Mar 01, 2024 at 06:29:52PM +0300, Dan Carpenter wrote:
>> "namelen" is type size_t so it can't be negative.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
>> ---
> 
> Jens applied Muhammad's patch so this part isn't required any more (and
> would introduce a bug if it were).

Yeah good point - thanks, I've dropped it.

-- 
Jens Axboe



