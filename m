Return-Path: <io-uring+bounces-4315-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B437C9B961F
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 18:00:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4F9E1C22375
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 17:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 865461B4F30;
	Fri,  1 Nov 2024 16:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NUKO+7WE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2D119D089
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 16:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730480342; cv=none; b=gpmGdfqKxBg3IiZr3dsplY0dpq2zyB82Y3loAFpJTcKKwZSNmFpgYHlPVRRmWPor9H5Lgj2VrUsA7+HXD8xNj7unyIgPkr4XBSuRPNw+JuXJWBr2yjlKfOeC7SYL1iNNYxIRKahKs7yEe/YdeJQmno5dX+8rBk+EbzN9LKxNh+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730480342; c=relaxed/simple;
	bh=cuyaa30XDmtjBOebnjksadyhHm1UJiF6a+xxY7YnFk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b+7LdMwOxykHHfGFbYmpnC9Vw8D9GkOvKS6w9Iqv7NaSt8huG4J8JwHhrVXOFer2zLu5E0AlvKpKMkVX9TVrBcs7I8aM42LDq9NpZj7w2A1KrHThyqHRgQeVU5ly65Bvg1h9jNivAz6gMogYCoGirZTO4+v3i0vVFtzzpzAVmPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NUKO+7WE; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4315baa51d8so19258815e9.0
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 09:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730480338; x=1731085138; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BSggGpMNicAtVkDR+23W7W9cPOu5cio8nUxZ2ioUANc=;
        b=NUKO+7WEodS2WHaG0J1gXewfeDSNoNlPCW9rs1QexgXdXnU/Lkek/iAjbIIHMHfVUA
         4KogLQq8JmSoTMjIf7FHAIFWtSdBJRVHMd43sLTHiKIqWk4y6cRRXTGypR7ZRD7UWH1Q
         EchoxLazyWO+ZgJOcpxpzVsov3tWOPzprb2470cRpTrF693WcgV4GtSaoD3PrH7Bfo46
         pkkzYHXW1j5yTibzTQwyLvjB5oFYO30PyLcJ4ib9YbRkFLMj0ZDH1YAaJSVpzPa+SFqq
         qlZtxCRxi0IKxMBWGgvIhOAljqSSPK1VYXVrPJuLOcnkZQA4EXAlA7y1HWNSgEBDukdu
         86Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730480338; x=1731085138;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BSggGpMNicAtVkDR+23W7W9cPOu5cio8nUxZ2ioUANc=;
        b=rMJHJmLKdvi37+6jvMMiR4Mx1l3gk42k6ej97TkX/NuG3jt78pJ0T7lhnELpexFry6
         1KIKRYP8a4qAyX93oXjLWMyKjR0T35ddgQ1T16Xr5oPPXbQP3XZdTD4x/bBOb200f78B
         lusYTjORWCYi2Mkcfs7fv46b7QuORc98F3S0EYXCOjmJIiBPi/yLYkjxZOg8UYAulBGt
         GAhNMVOpdZ/UZXdZMkPafzq+hX6k1Ig/UwM6eAEuwO8kxsRsreYRahUgqv38dkCPRaEy
         Aq7Ni93sxE3jx6GRmhTwjEdItZfcHW2lyOgmMzRXuruitc/EBjZyzwrtXHDmpWZvPXMe
         GxDA==
X-Forwarded-Encrypted: i=1; AJvYcCVJKCRqzivrGTBrrIyblB3KN9BIXD0mTo0A2gp60qiRINXRyPQ5CWquzjTbPosY0atOdWiyxolU8A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzyYCjg/aPg4aKSpSxhDt2D9uYcV+RfH2GCMab6gSMsIcl4Vu9Y
	2o7oRs+dZPAo7VwmSeaCndkk2h7d2rLvISX4RnjqnZYA+86EQeiSMa//nw==
X-Google-Smtp-Source: AGHT+IFvnASXy1f6WlMehGwiyc4lmmFfKlIbejcFsT0fVnoPSNsjLD8lB2Eu//sxQ1rC8m+VCqTv4A==
X-Received: by 2002:a5d:59a5:0:b0:37c:cd1d:b87e with SMTP id ffacd0b85a97d-381be7c76f9mr6323000f8f.18.1730480337398;
        Fri, 01 Nov 2024 09:58:57 -0700 (PDT)
Received: from [192.168.42.19] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4327d6852efsm67934935e9.30.2024.11.01.09.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 09:58:57 -0700 (PDT)
Message-ID: <f375e5d0-e870-47cd-b3c0-7a0a7ce99657@gmail.com>
Date: Fri, 1 Nov 2024 16:59:10 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] io_uring: extend io_uring_sqe flags bits
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
References: <e60a3dd3-3a74-4181-8430-90c106a202f6@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e60a3dd3-3a74-4181-8430-90c106a202f6@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/24 21:22, Jens Axboe wrote:
> In hindsight everything is clearer, but it probably should've been known
> that 8 bits of ->flags would run out sooner than later. Rather than
> gobble up the last bit for a random use case, add a bit that controls
> whether or not ->personality is used as a flags2 argument. If that is
> the case, then there's a new IOSQE2_PERSONALITY flag that tells io_uring
> which personality field to read.
> 
> While this isn't the prettiest, it does allow extending with 15 extra
> flags, and retains being able to use personality with any kind of
> command. The exception is uring cmd, where personality2 will overlap
> with the space set aside for SQE128. If they really need that, then that
> would have to be done via a uring cmd flag.

Interesting, I was just experimenting using the personality bits for
similar purposes I mentioned but in a different way, and I even thought
if anything it could be used to extend sqe flags though I'm not a huge
fan of that.

-- 
Pavel Begunkov

