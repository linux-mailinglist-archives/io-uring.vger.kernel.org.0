Return-Path: <io-uring+bounces-8148-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BE382AC8FF8
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40CC41882F15
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1223376F1;
	Fri, 30 May 2025 13:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VVCiRjpB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8325C20326
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 13:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748611252; cv=none; b=XkzCAdKVLeGGkRXY+6AgDbPUjVZqqrr46y9i0Gae4BcFjT/IIwAt4jk7FeGeAXoeWWyqJZAltKdCHNdiOvu/PElkYGZ+R230LnxWY3TG8Zi3otXGxdqNAA7bjEWjcray9+JaFzE2MoXwTBcggZIHVCWuBlk383s+SKVOH07Fwcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748611252; c=relaxed/simple;
	bh=F2VBlNLtw/5EvZccoAPKin4zDr/wS8+3VPUfjG/cc7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lH8shOHP5+Tpb5qqllgm6iZ/t6dbuRgaLstJXhx7ehZMdlcO4TbGT3y+8+exJj31o2nQfRJvEHTgjanPs4DvUgZZt3phJZYqdR8J6PzXNWuQSAZEqI9zyrS/tt3xOjDRyJmXzH1c2u1VsL6mQ6UKmXSB21yovXlFl82hIn7bfkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VVCiRjpB; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-86a55400875so148324139f.3
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 06:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748611248; x=1749216048; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T4j4I8GLv1RsSoZjDs8OEZFdc+UEs2564WcmigHeyJo=;
        b=VVCiRjpBBOCCKjRMvol4KDKvf/x4A2UU+CtPMc7iyQjzysQsJ0iS2fxx6lMAVdp3EH
         tnecUZxALzn+ID9D040B8esr69G++1Fn+I5j+wQi7cOXEikBwcMnE1F7skwI5kRi45Rk
         7tz9Ykrd0c0lEaje25hAFxi8a3kp7829mYUvXwUYlUct3ImuNBpkJRVbnVqoSrXArmwx
         ooc2OggHP1//tgivY3ZCedPezM3rEOOmTfhkpQM2speVZzXzCiAwTNzkEKkdzp+Hkumu
         8BFHIbV1QX0UmPcdZ6w0YZlaUOKaRD+kMLLFbe+d9SjFQQcTLnARVAhneL+jehlTuzdz
         vE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748611248; x=1749216048;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T4j4I8GLv1RsSoZjDs8OEZFdc+UEs2564WcmigHeyJo=;
        b=nYBoanbqwQ71SKq2tt2qyzmRWa5wjaMKrHLlxLFsHlwvaOgf/pziGnc0tsbQU6FxGl
         nHuOpWv/FV4/ygCOUqul3D0H01FN/pgfaxmpS2pVU62+JVKnvT8bdVeKvgiwfgFo7lCg
         R50MVbSWkuqrIS2KgsFoH2ZzA7QMGeTVaWyIcE+GAEghV1BozVRM3G/TRD/CtzXDPVej
         BRFeGvQuVpY0iWfy7RJqkohOskb4JuItJwx8MNrBgxKqwqd4RLKKHfyuc2mqPHmtcYO1
         MzBNI7LwWYSvj8cDBdihl77+Ig2sZlBVgW0g41BlMz1T0bPeJRLU+Ln4Of/P4jYdb0uz
         VUFw==
X-Forwarded-Encrypted: i=1; AJvYcCVmlr8hNOA5IXOFXQmK9hcmwpIN8VjRuPidsRj1b3Ilkt5gRDWTAAZBYfDbDpKXIIqMazY4sJ4wyA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwyHxEHAcWSKv1RXFW/EqVdWgAKAZcMILLdtcmCP/7cOjLE8XEk
	40eBAw6SGV+nJ9lNE3pr5HXOPGyUzePRwB0sMXBRnQ7bifxvGgHx8e92aTUnMZdYV+s=
X-Gm-Gg: ASbGncvgIOhr+OBKS65LmwIAks11p08fEbTURMFfBvRQk2rpIRiSouDfvXGIRwBirgD
	E90iYnweOXXvmVLI5if+yIKacU8TilxzmaW3pCcTXV0b3rlfGnoA9u7zPMfaTsKnFrr9AxFNlbV
	nAgj2uSB1Yx2gTKSLvtWX8w25wnM038gVFpS+sfH4shAAWbdlO4avhdwsovv0r4jjBU2KjSIq53
	kixWfSKZFt3JySgscfh5lwDWhGKodSTYEA9Z5N/R2k4YckoZu+fW1gls/JNS5n7TfMwlHSMhZ8x
	DLx4ON6b2gaVHSgeRWVux/RqSExJQmHeaok1p7xS/bYx0kI=
X-Google-Smtp-Source: AGHT+IG32Z1/MlXqpVD167brNNJgTiO9I2XJfijC6hnVV482WtZU2DObSzM1sdbQrEIDULL60umjqg==
X-Received: by 2002:a05:6e02:3cc9:b0:3d6:cbc5:a102 with SMTP id e9e14a558f8ab-3dd99c145aamr33255225ab.13.1748611248221;
        Fri, 30 May 2025 06:20:48 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd9353d8fesm7497795ab.16.2025.05.30.06.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 06:20:47 -0700 (PDT)
Message-ID: <9e60b9d1-4f95-4c37-975c-102d2b5ad4a2@kernel.dk>
Date: Fri, 30 May 2025 07:20:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] io_uring/mock: add basic infra for test mock files
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1748594274.git.asml.silence@gmail.com>
 <5e09d2749eec4dead0f86aa18ae757551d9b2334.1748594274.git.asml.silence@gmail.com>
 <f3941c74-5afa-43fe-93c1-f605b4cbeb82@kernel.dk>
 <7518de34-8473-4fa0-9a3f-42769de4c03a@gmail.com>
 <fdb9c49e-b8b6-42cc-8a6e-010d0906dbed@kernel.dk>
 <d367cb31-32eb-4d69-8d71-03ea8c18e11b@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <d367cb31-32eb-4d69-8d71-03ea8c18e11b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 6:21 AM, Pavel Begunkov wrote:
> On 5/30/25 12:48, Jens Axboe wrote:
>> On 5/30/25 5:45 AM, Pavel Begunkov wrote:
>>> On 5/30/25 12:31, Jens Axboe wrote:
>>>> On 5/30/25 2:38 AM, Pavel Begunkov wrote:
>>>>> io_uring commands provide an ioctl style interface for files to
>>>>> implement file specific operations. io_uring provides many features and
>>>>> advanced api to commands, and it's getting hard to test as it requires
>>>>> specific files/devices.
>>>>>
>>>>> Add basic infrastucture for creating special mock files that will be
>>>>> implementing the cmd api and using various io_uring features we want to
>>>>> test. It'll also be useful to test some more obscure read/write/polling
>>>>> edge cases in the future.
>>>>
>>>> Do we want to have the creation of a mock file be a privileged
>>>> operation?
>>>
>>> It doesn't do anything that would warrant that, maybe just yet.
>>> Do you mean from the security perspective? i.e. making sure a
>>> user can't exploit it if there is anything to be exploited.
>>> I'd really hope nobody would compile this thing for non-test
>>> kernels. Maybe I should make it dependent on lockdep to enforce
>>> it.
>>
>> People do all sorts of weird stuff. I know it doesn't do anything
>> that warrants making it root only, but at least as root only, any
>> side effects will be limited to that. I think that'd be better than
>> making it forcibly depend on something unrelated (but debug'y) like
>> lockdep.
> 
> I don't hate the CAP_ADMIN idea, I'll add it, but making it
> dependent on something incompatible with production kernels is
> the only way to ensure it's used in the intended way.

But any kind of dependency like lockdep will mean that I cannot run
testing without lockdep, or whatever else the dependency might be. I
think that'd be rather unfortunate, I tend to test with both a "stock"
kind of config, and a KASAN && PROVE_LOCKING setup.

So I really don't think we should limit ourselves that way, attempting
to stop a weird use case by adding artificial dependencies.

-- 
Jens Axboe

