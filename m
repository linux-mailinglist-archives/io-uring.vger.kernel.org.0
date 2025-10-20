Return-Path: <io-uring+bounces-10066-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A4DCBBF212F
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 17:24:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 21B744F82DC
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 15:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B696264FB5;
	Mon, 20 Oct 2025 15:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UUWionh5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65065262FFC
	for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 15:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760973805; cv=none; b=WqOjZNaLL7CC4tWbmnLJ4wg0ZCtgW7m8qr9ysbXO0dFcvC7lc5zI0rI+FHzHpznTW+F1Uv8Jr//W8b7K6OM/Z1TGUvOGmbXO149Tvjj2SxPycBLPZNkXU0ZzQF5U5yUYcP7mc8HqpdfdOx7swULip10oWc+t9hv8ltmnMvhwQAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760973805; c=relaxed/simple;
	bh=VcetK9Ex6jSTjnEMBQGKqxNSEGsHLuypKwZn6rMQdvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eBhkY1PdwAaveJeqbuZfyeAlMvg6QF+nxQhai7lrWnjncy2YTdqXvO8Ozuvt78NUIqPPIUry8F0e/GoXjnomqjHqzkmbeDsqSMcuYbCe+/n1sMcAFTjVjepcqlse8ZhGPV5PvkAYa3UOlxE4Im5ZPpSKAKoL219eNSXs0JClFxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UUWionh5; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-93e7c7c3d0bso316469439f.2
        for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 08:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760973801; x=1761578601; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bc6Jza1yymLQPvijg8kntO4LKNpLjp9Sl+6tLLwxgfo=;
        b=UUWionh5AzGu0KKV9Z6z9mAInGSDLF1LqMwRvD4Gkjrm1lC7hn12nuWCxRl+NIT5RO
         9iAvXoRU4YTPQ6gnjI7lLhecwMwdsSNzwMBoGtDLW5JwThI+XHzrcsQQQde+Xe9CcPoB
         u9TCeIlVYocS2DQEnNarqTn2S3GOfZM0WCgDxq+JtK62CjuDhUysYqdtLH8NNS7Crowa
         8G2hlzLOa8/SdGryPPjp/Z3gWCHRreu1eSO8o8iJn5H9cW9YKxd5ebvgDuAcunmhdG5m
         ao3ltrRQuyTEfhRahhilYUMsb4cDsO7QdZR+el8S+2cjeGXlNEoP/f52c2nSl1Fe96ky
         zT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760973801; x=1761578601;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bc6Jza1yymLQPvijg8kntO4LKNpLjp9Sl+6tLLwxgfo=;
        b=fC9U7rT9U7PWjtKRVBhBKVPmygMuD+eeRluYAcze22fyOWLP2PtUssyVfe5VyV4G8v
         4+vfcQnfbnWqSJ9OaKBaK6yukcCVO4/Nr1PwEDwfkgO7wxDek94H52KDQJpJxUIgrF0w
         s37bztVycgCEvgDOGdoJMIwIAPITL/6O9rk4AidNCTr3ZsjImIJpj6uo2hXbK+vywRCq
         iLJpdDBj2m2CZ1BPCWzv7TLhe46d2B15NNscoMdgnp/HWD0xDSCVab2s8YOUVax7UJeQ
         s/ijYv5BvKn25wqW2NFKF5i9HeY9o8XJBQfIHUCYfBIm2J5YEFteflJ2XpBvuYPPoEeU
         dYFg==
X-Gm-Message-State: AOJu0Yw88uglmGMiy1ecdmgyKGUwfLSynmDy2bdjNvxHSXADs6HqRg4L
	9sru4ysYnJ8mQsvjx1TKZwThJeDYMNE9yYcGFu7/bU73k4mpN9kI8/Y16R5VXWIBMQtvsLqC28K
	/u5C4lzE=
X-Gm-Gg: ASbGnct+MOIeo9N5BMkCdraZKWMaT2SPElhL8nh/7yv0n09jv1/l1M2058Xw7eAX7LE
	TkAD1qJNcXmVXb1qeftUKI4ul9l1Gd0LjaOVAIJ2tker8rbbDOeUpv77uqzwnJ0TNpOjUrgSOlv
	YiQcUR3EbnAqDtFf8tr0amOzTf0mJBl6J8n+WfW60mf30JPoAGcP9R9COAHRqP7APqxhjIxK7iU
	IcP3LwmhQPftBhuNPIbEJvbdu5nTUqphUOnXr8gTzbl26EbJlkhVIRemKaOi//xL8vlaEu4Xwm0
	mffKPlRykwyeLSHV2XviJGgudA1Bnesvjwdfc72kepL570CJqJ/oDcKUDdP6wDPajkDtjCEa5Oi
	jfFoeEvVmmOrrWDdNw9El8dHBzaBGzOmzhKhHge5s5bDvxqbiTKui2f/DFdxotN3BL5tE8To0
X-Google-Smtp-Source: AGHT+IF8hsQySraaYmkbWMo0FhlSjr1u92m2s94DHWXQqEP/Fr/H1f/elqP4IPyfB7CIipZLXarcWQ==
X-Received: by 2002:a05:6e02:2301:b0:430:c046:5428 with SMTP id e9e14a558f8ab-430c5268df3mr11923415ab.17.1760973801405;
        Mon, 20 Oct 2025 08:23:21 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a95fece2sm3030322173.7.2025.10.20.08.23.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 08:23:20 -0700 (PDT)
Message-ID: <4a56590d-dbf6-4047-99ff-e69279715176@kernel.dk>
Date: Mon, 20 Oct 2025 09:23:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: fix incorrect unlikely() usage in
 io_waitid_prep()
To: Caleb Sander Mateos <csander@purestorage.com>,
 Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: io-uring@vger.kernel.org, alok.a.tiwarilinux@gmail.com
References: <20251018193300.1517312-1-alok.a.tiwari@oracle.com>
 <CADUfDZpGh0HeUDTkRFQVRq8skAKS_OSvSmJ3u+Sb1RmxoHWnaw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZpGh0HeUDTkRFQVRq8skAKS_OSvSmJ3u+Sb1RmxoHWnaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/19/25 10:27 AM, Caleb Sander Mateos wrote:
> On Sat, Oct 18, 2025 at 12:33 PM Alok Tiwari <alok.a.tiwari@oracle.com> wrote:
>>
>> The negation operator incorrectly places outside the unlikely() macro:
> 
> "incorrectly places" -> "is incorrectly placed"?

Indeed, I did some slight commit message massaging while applying.

-- 
Jens Axboe


