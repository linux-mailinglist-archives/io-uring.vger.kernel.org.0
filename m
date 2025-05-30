Return-Path: <io-uring+bounces-8132-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EF08AC8D0E
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55C299E1BEC
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 11:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F7521E082;
	Fri, 30 May 2025 11:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="leBCSN0M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF8B15E97
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 11:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748605461; cv=none; b=HWKZslvr/kQuLHNFJ98g4SbccdwXLbeL+pFqxhYOYLhfFOCJ5pm4YmtVomj2iIjNghCrXCXusixbM2+m3jxlmp5YJW7eECWU3xZLhT/CoKEDpfnotj3JP00FH8LJNyIqwEqQcKA2pa5B2P9FtlGY4Kj4dkcEr5P7CnJEX3eUwDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748605461; c=relaxed/simple;
	bh=ltqrN2SDHsBOTqKaEkoBcYUv4dWZuoZvRYvSEe/gTuc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gmBmFW4hpzAahiaIzJ3LaaaR8lfpTbb9pua8CLoiCab+WRiRvoU9ZdGunbUY3wNFaqs9sIRLERMkLHDvwJWwo+twle9P5K97VSd7lE7jsbTMZmludacXHrKUDzCsHnk3sttIzY/pUHGoucYHj18eU1cHVodn7O4DlvOEuAtXmG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=leBCSN0M; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-60477f1a044so3183804a12.0
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 04:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748605458; x=1749210258; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dplnFU2CxL8XfGV7rds1kckzkukgczs6A+F21HMvonU=;
        b=leBCSN0Mbqb6AVNuKeIHg4dgX2Joc9ZCkbd8cbhCEYAMu+3J2+hrWcvvs0UKDeMCLy
         BqWbSFQy4VQ/zzQ8thRdIN5nB4qbFj2Fpn1AhY3pmxM2OXiofqHN5icMqolAhEyWW43s
         9f3uX+vF/EGKdO05bFroKlv13z+X3T8XhC79I2riCXpj+OUGs0Ci4/nST6SDcppqjdB1
         bJqIJIRyMNu7LVNZDUATkC3L9UHnIohzU30pLXFTwK/F3utOkJ/vNQDrGbaTEjA+Iwuw
         NVD/26296oKo+bmRxSNEXoWKF+VX14hDmhEhEqVtz5Zoz6KB5kWlLp9Ytd5NZOW1dZ03
         53sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748605458; x=1749210258;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dplnFU2CxL8XfGV7rds1kckzkukgczs6A+F21HMvonU=;
        b=jkRD9VAG+/s0eOuQnvZiIVPSyPw+5zQMKLiXEQqIWiPwNmqZGe8PdMzH4CP1EqBZbK
         u3rNdNhV43k0a5yyLKEsUX3+rz81cXY5ZSH5USYoUvi8V55EaFGRdgW8MMM7P0ZG/BZF
         lbUwJNzysbmGCRri7Ncb0SEFBK+AxGcwHAg+eslOXLq54cyudnnGX5dQBpmSEam8XxMd
         3PUalrC6NFicJ7td9Bjt+tp5OmsbfZlY9tJZfNWNeZnOQdY67S3eU072R1yMt8mZulUY
         W7Pgyw5DJiB79Z6qltwyBMeoJBCsJKsa9ow/Z3QtYCXR26BDzOFlUaSW9FnFHt+Y/Onf
         3VBw==
X-Forwarded-Encrypted: i=1; AJvYcCUGiq7VVxclH6bzcrnt/Ay0djhAD4MUzoY2CeLx6JE49xu+714frE1cO9gWITwXR9d+bIVl9KJp3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwDOql++HT78RoFfBWY5pInKt2ETaUEzL++z5Qqs/xoGUk31uKq
	FHOCU+fvOLlI61EBRsrvZ2zxV9/9T9DsBTsxdRJQDGNHSNeHmNl4fj692sinfA==
X-Gm-Gg: ASbGncsRZ0XFWb8aUJvvUj4/f5YlbGgyAChT0nXi12R/5hhpPEOvryFiIj7rvCHLTsI
	nXldLK103bL/fKSLbJwdMlXJFahf/b6Vfe35SlWRdwLMbIMvMCvFLsIGGK2WKN9qihOGwjnxRHZ
	efFu6EY8s0eYTTjt53Tqt+rUvBQDKie0pnwIoFtL9YUeKvIz4V/MPx8e34RfsNfqt2T01ARekpw
	bH5TgDKsna39hmjwG9rU4/FzF/Idtp2AAdq+i43ahAtCjTSGWqy/eDGB/zDePtEgrELAy4rXARb
	9HEyqpZ6uSZvXVCBp+Fl6yEpsv0mhHh7LdGZiToI3WfdXGUblvMspx5pbl/DirXq
X-Google-Smtp-Source: AGHT+IHcfYRBPkcGcwHr87Vkii6tkKiKmw0Lz5xYZcd96UKXuTdfEJjC1TSsm9Nb3Ek9KghI32lNwg==
X-Received: by 2002:a05:6402:50cb:b0:605:2990:a9c9 with SMTP id 4fb4d7f45d1cf-6056ef06c9emr2475353a12.33.1748605457534;
        Fri, 30 May 2025 04:44:17 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::15c? ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6056716909bsm1492514a12.68.2025.05.30.04.44.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 04:44:16 -0700 (PDT)
Message-ID: <7518de34-8473-4fa0-9a3f-42769de4c03a@gmail.com>
Date: Fri, 30 May 2025 12:45:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] io_uring/mock: add basic infra for test mock files
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1748594274.git.asml.silence@gmail.com>
 <5e09d2749eec4dead0f86aa18ae757551d9b2334.1748594274.git.asml.silence@gmail.com>
 <f3941c74-5afa-43fe-93c1-f605b4cbeb82@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f3941c74-5afa-43fe-93c1-f605b4cbeb82@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 12:31, Jens Axboe wrote:
> On 5/30/25 2:38 AM, Pavel Begunkov wrote:
>> io_uring commands provide an ioctl style interface for files to
>> implement file specific operations. io_uring provides many features and
>> advanced api to commands, and it's getting hard to test as it requires
>> specific files/devices.
>>
>> Add basic infrastucture for creating special mock files that will be
>> implementing the cmd api and using various io_uring features we want to
>> test. It'll also be useful to test some more obscure read/write/polling
>> edge cases in the future.
> 
> Do we want to have the creation of a mock file be a privileged
> operation?

It doesn't do anything that would warrant that, maybe just yet.
Do you mean from the security perspective? i.e. making sure a
user can't exploit it if there is anything to be exploited.
I'd really hope nobody would compile this thing for non-test
kernels. Maybe I should make it dependent on lockdep to enforce
it.

-- 
Pavel Begunkov


