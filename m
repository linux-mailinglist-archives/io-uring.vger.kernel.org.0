Return-Path: <io-uring+bounces-737-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 827B98679BF
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 16:13:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B46DE1C2B1D5
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 15:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FEC912F597;
	Mon, 26 Feb 2024 15:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBNOwgFA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8032F12B175
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 15:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708959678; cv=none; b=PvidOEoYvsLgQNIJiagPaMpOlfZTJPILj3PgJeSpXemfddxsN3apF1517nx3+ZsW8iIGYIKvz4ZIkHN0FL2n0MwEQAu/G3luYbv/Kt+GjQOE1RPMvVwLQJXqBZ0UQ10KWKVfAAQ3jYsyqm0r0oKoPBRbDuZQd07DSUHDpR4X+4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708959678; c=relaxed/simple;
	bh=W0zw+84JaivVhSokhiea4NLmRAhDl26VzySZC19a9a8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=E6BWV7EP4EWOczF+NwsrVHrU47CQRv9XjQN4kNrR05F7THhmO3YQ3hFOz3XI9qMA95L4qlohS+jO6pvJBzzQoC0SO8vw0DzczM2iI3xYaFnIs80oDQe0z0RrqbCH66EdBlOA7ofOV9e4xz+/5W5oOXhUctu0l/r3eIC1IxEL4AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBNOwgFA; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a3ddc13bbb3so473065166b.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 07:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708959675; x=1709564475; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jcw+cChi9Ckm1LuUX4xbIdp5Gr4ftafds9AhySewUbc=;
        b=UBNOwgFA00gxdTfqBUnjG43UhJaKrxKc0NycA6tPwhKPl8xEWMgbKqeDs+1wTCZ1OM
         8x6q58kbsqPOj2nQvsCOEE905+RTOEcmSVfPSYWPUGXeqm2PPfl+gei9VRg0ZaJUFh4A
         K5FvtFGUoG5AP75vq+2/XPTLEUtU2EzqrBjCtwsdBU1UrxHIVStjX0lOreRvC/GdqWaQ
         xYtQpt+hbs6bkT5odcxljyDoW44NwN6YK1ElB3nrO6T9/LdGZQTN21LSXEH58bkIZUFk
         0GOz5Emtz6+wz3hx924R5t0D2+qBqjPadliEHwUGVduum657s62KZJa/+rIkiTi7gmSb
         zedg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708959675; x=1709564475;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jcw+cChi9Ckm1LuUX4xbIdp5Gr4ftafds9AhySewUbc=;
        b=C2whSmjHORZ7s4+AQ6GxYPMbnWWRQClqtBoMPkTexzqDVnwPcqOHr5XRTKIJGArZhY
         xWCC8F7+A6HV0N2dGJybQrT25YxwqqVPYL1PpY//bluTzM9ZA/ldE5HJvCcSrVzpOhYo
         uv+2iulrPtTqyq18dIbV6WT54SsxR4fDXexOqnZCQ0pYSd9PGjodtWi3jk/DizQwisFI
         9gMjTpTKct6ZwRdum5f9Z7s7WxGBPrpr6bdaAzMv93FXE4A0CgJ5TgWjDz5JIHTE78gw
         h0AtV0Inmk+Gwn13pb11TZpw9hB2Ke0GWyUUBqaFYRJGPcZHoO3/kgqBqT8L5cvhF9YN
         oZBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXy88lD9ixHdBOYXO6cKvC9Bw2qnaXfFmU49cm5G+bPBpV0o3Ptz7kz4ya5mUnsOt8Wh4ii/CkI4hRTRghtY368nZZ7PAiE9/k=
X-Gm-Message-State: AOJu0YxDSxT9fzzNF62GPg7KD+79sLpOboc789OQoH5/0jXPoRcJT/ik
	wzxTLFFTom8PhYCdA+IyU3JcBS8CJr6vCkFsMRXNRVQyLmmwbLb+0ls5c8tM
X-Google-Smtp-Source: AGHT+IFn+iFXuZ82vRzWusS6bEdsHjLeH4jjhspoW1paGeRskUxs95ELL/Kd0TGWoeyqiauQHlMYRg==
X-Received: by 2002:a17:907:78c6:b0:a3d:d201:25cb with SMTP id kv6-20020a17090778c600b00a3dd20125cbmr6209813ejc.6.1708959674473;
        Mon, 26 Feb 2024 07:01:14 -0800 (PST)
Received: from [192.168.8.100] ([85.255.235.18])
        by smtp.gmail.com with ESMTPSA id vu2-20020a170907a64200b00a42fa8c207bsm2287508ejc.94.2024.02.26.07.01.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 07:01:14 -0800 (PST)
Message-ID: <88b9251a-b195-4a2e-94ba-f81e17d9de54@gmail.com>
Date: Mon, 26 Feb 2024 14:41:20 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] io_uring/net: unify how recvmsg and sendmsg copy in
 the msghdr
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240225003941.129030-1-axboe@kernel.dk>
 <20240225003941.129030-2-axboe@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240225003941.129030-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/24 00:35, Jens Axboe wrote:
> For recvmsg, we roll our own since we support buffer selections. This
> isn't the case for sendmsg right now, but in preparation for doing so,
> make the recvmsg copy helpers generic so we can call them from the
> sendmsg side as well.

I thought about it before, definitely like the idea, I think
patches 1-2 can probably get merged first.

-- 
Pavel Begunkov

