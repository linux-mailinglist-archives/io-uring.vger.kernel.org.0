Return-Path: <io-uring+bounces-2531-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD26A9377F3
	for <lists+io-uring@lfdr.de>; Fri, 19 Jul 2024 14:49:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB7241C21358
	for <lists+io-uring@lfdr.de>; Fri, 19 Jul 2024 12:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E3A84D04;
	Fri, 19 Jul 2024 12:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d+BDvzqx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89FF39FF3;
	Fri, 19 Jul 2024 12:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721393345; cv=none; b=ogzgDpSTF/KNVpGhCb0piyzCbkNemOl6jyHm8RqMnn5/F2tuTNEHElh+tvR+17gYrv5e8+fRlYRkbeVzbLHlvrRKGcL3hQFc0gkFiiEqGKgIrFqyExdhi8PRT4bKPagEGDKW6B61tQgJv3STHwt8gPh8i2qPiW0T3DWlGSEdNGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721393345; c=relaxed/simple;
	bh=CR547d0HU3Yr1vkRs5KLOoYxVdbGwaxCEvBo7DQcwjQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=foSXvybeEUpGL0oWlKpqqJe3nboU85pMfMjG4ZYx6PpEq9Zcuj82Rmj9rGSy9GPyqZCvQf/qW+wIZLVj2RzZhid1KGh7E5AaUQYR/udK06Pso71j77Kp1srLXUPHn/DXicYKRwc/wB2kkR25DJsvNh+NstTzr9/Nss11PvXfGxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d+BDvzqx; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6694b50a937so8353367b3.0;
        Fri, 19 Jul 2024 05:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721393343; x=1721998143; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1zOiWf4HUZC9iZgipXdXMnDc6Pes1HPab9Jv7CaWdn0=;
        b=d+BDvzqxz9zeVogqZ0XCOfzIh4ld9ewB4N7vuiHF3WcqxFO1JzAoX3w4ef7PwOKZn2
         12hBD2Gw/641fQbmE/WISzhV3MPcapfjVeN9YEFrYMtsV998AvmAghqlF+2OSP/Tu/sA
         nGAFnvVAJz0Xb8uOvXVWAtsDS1746KR++cSgy8VuAG2Wma9mfaAGCV7216SGhq4L4FS9
         JOhXYywnnqJxazzyrDp+Wc94vNHZ28LyZmbDeWlnQlpKkT15KzG0AKjKbR0IhTtE3gjp
         TtszG89uldM/715/5/rPYzOR5SjlFPKvflP9gmLU42QclZXxhakCQ69iwmsBuL3Dp4D6
         OWJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721393343; x=1721998143;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1zOiWf4HUZC9iZgipXdXMnDc6Pes1HPab9Jv7CaWdn0=;
        b=pAuQ70w/R5HPqHjqVy9ccNTGRAICx5B8gf/B9lKCYjZgL0+Bcm3hesomjHR+skDSPi
         qbwg56CN+ixU+gfjPGUIcCiBfSsUt+TY2IKxh3SteXjXFMDXVWGWFeBswMKMX+gQZZcI
         Gvro1W06DmvhRr5ivT846nuLmpvkrwfIZoZtZjRQ6xzgayzxRl7nraVWjrEg8vt1Dr3p
         MjmKTmm6wuSoXyLmB2Hzq2pFKW9GIJEK5tNK8qGJlS81zKH7zvyl00ReWpNYhKvFJR4D
         MfKV+EZ7VEOQdfgcru+2DwJnoSVqaiS4X7WS/RUrz7d75SMFDPAlEIS3Co5pgoGdsGKn
         60fg==
X-Forwarded-Encrypted: i=1; AJvYcCXcGn95S12YdY3BwdpaTYx565aQY1+ngupGcZv5n6PsT9Gaq9YerChyjHkUnu2lMEZQEgONsDI5sNNVjbDmZsTvJAGmv8V58FM=
X-Gm-Message-State: AOJu0YxyFD/AwU+qAEoFKCZ6IPH2eSEvqIp2vfLVA0rMZ/leP6cHiIaD
	mCITDDh+cTtYAaTRJFbU8K+JWMDjC3b9uKtMS9Af7agaibuWsLmtMZRIZAtI
X-Google-Smtp-Source: AGHT+IE6y9RT84bevPH+bDmcrPYHaGvxqxjMhsoRM8WPSbnHFvTBIz+bG2/79Orvn2hk1sDK0gnyKw==
X-Received: by 2002:a0d:f345:0:b0:664:7b3d:a53f with SMTP id 00721157ae682-66603ce747dmr53801157b3.45.1721393342682;
        Fri, 19 Jul 2024 05:49:02 -0700 (PDT)
Received: from [192.168.42.233] ([50.239.92.83])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-66953fc8571sm4585977b3.104.2024.07.19.05.49.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 05:49:02 -0700 (PDT)
Message-ID: <ef46054d-e657-4c8b-a9dd-c61dcca8ed45@gmail.com>
Date: Fri, 19 Jul 2024 13:49:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 0/8] io_uring: support sqe group and provide group kbuf
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org
References: <20240706031000.310430-1-ming.lei@redhat.com>
 <Zpm7fLVsZHpFRWPq@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zpm7fLVsZHpFRWPq@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/19/24 02:03, Ming Lei wrote:
> On Sat, Jul 06, 2024 at 11:09:50AM +0800, Ming Lei wrote:
>> Hello,
>>...
> 
> Hello Pavel, Jens and Guys,
> 
> Gentle ping...

Hi Ming,

I'm currently away, will give it a look when I'm back next week.

-- 
Pavel Begunkov

