Return-Path: <io-uring+bounces-8517-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94EC8AEC828
	for <lists+io-uring@lfdr.de>; Sat, 28 Jun 2025 17:06:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01F2A3ADF5D
	for <lists+io-uring@lfdr.de>; Sat, 28 Jun 2025 15:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66BBE17A30F;
	Sat, 28 Jun 2025 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fX+s7CQf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9203E1E51FE
	for <io-uring@vger.kernel.org>; Sat, 28 Jun 2025 15:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751123196; cv=none; b=h+Z5lVkp72RrRqYlWbOXJ9zEBIlPgltb88iGrX9rCQyncDSGZvJuv5Vam+w8vOsn20oazjY2wEeZwCPkCLBs992tjbVkTKz1Dtjx8Xty58NHb5l/oestAM967j0V6qvxQXDZjzBApzLKXOfM74SzUBEJVu9VTq+eHXVlbCpkfvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751123196; c=relaxed/simple;
	bh=Qf+7k7aWYtcB+iOkY2j9vqpefq5AHkXnoonhqF6nETs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ph8ribxBDHb9SEzlswfKYnQX4T6vlBoqcnaCje/Cn5ABoMNRCP0Pjqtwel0x2kZbYPqQnJ17+x9rrvciUy2xuuLSaEd3DtVxocN+/pF7D686vX37k10f/1LV7MjLdGrJb1tZSXsDyqOd8c/3JXLYmksrf2RMpiLaTU7io4ViaIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fX+s7CQf; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-235ea292956so4508505ad.1
        for <io-uring@vger.kernel.org>; Sat, 28 Jun 2025 08:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751123192; x=1751727992; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z3oAp2VspiWmlyMi4G6w/yOG3muk4pR0IM7HMSmu5Zg=;
        b=fX+s7CQf3GhAZHTZPxed41ru8kMfQAhjkzLUVdtVCxJQSBiqITRoPtgTkZydXGsaL0
         Cbs2KAy/9hAyRIzGkICA/Zzp6C4daSq3RGmMvtxNvxAzIVVqHOhulRbVxsMFHXcpCV/Z
         iDFDw7IXrCcyerIcsYXOOMk4e4Nb5CVB4zpIO7avoRFktImDNG735VYak7N4s7e2CPq4
         jjazcQ5VbDPIStT8hDqqzh4I/bpFCFsIV73lFZE/BfcYID+sD2uFzT/If7S9Xq57UJej
         iJ1nzdifLJYBnlmRbLWZQdltVWuwGeKqqvTMJAIpW6a/QfFO+D9uwlAzh53UsnYLMyI0
         jfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751123192; x=1751727992;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z3oAp2VspiWmlyMi4G6w/yOG3muk4pR0IM7HMSmu5Zg=;
        b=g7NiSbJKdtOWxTvIhJxCJHlYOfK7Yh4r+w2MQ+ZKCZTAbT6yF6bJtopvpXUBe/R2pZ
         dI9TZXxHecvl0OBLZXw26RlctwQymu2L0qEbxK8i4+/NwQhUuaA323mnUKJh+6hjyqmI
         BUJrYrdlu5yL8CD1x0LU77+Lt7WGnuuk6QK4SR+1RsX5zbRmEaoO8cjXsjzSGJ7HaNiN
         V6b3KdRA1lyqYKz7/4Ggj42aLkTuBPCypM78/icDcxRqouMsMMlPjMl0IZFIRM6HpFOf
         tn2C2+ta/LVb83U7vNb/gJDdErOsk5BkbOpzzY3YOkgE2BAy5MjEW7W7HTZwNORbUZow
         ISkQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8zNfsOGuqWf2vrkazSPGdd6R30rapkJObSvNjOpDNKPajxV/69ODMPFzzR5W/42z3ls8keipG7g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9Nwe/oQFSE12n6hg3vd3afKjVBHZccMm5YpmUYvy0GLmXay/u
	A9sb335Mp7kMyDOOgxHVVbuT/N1W/QUhONBzlEbr7vXbAsXkHy4PzvUeSIhow+7/8prhxvqcbUl
	zJZu4
X-Gm-Gg: ASbGncs5T8kk3Iawf5HQJytyxVg19BvZwsvg8cThXiVR1PPPNyeXJnZ9wB5USBrkWwy
	tQOpIL9qfqktBPhlyYh+VkFYsZBOIfC4nRwMVAbSQ9VKz+VAJNr1hzeapw9eKrwIcCAy6wCg3v9
	x/GZvUOMOAzruSehA1SdjYvVRAvFhyq7VXcVh7y26e1mvRLEG8zxpYZngpJ5M7dWt7O7yEtbYvM
	8Iks+6tgKxu7jko0yA3Rc64MvN7OqshP3rMHk+OgrcidkKcjJEecjPIa1iXRxX+UvrXyqu+dF1/
	mLA37HqLDzcIviTXuy5P6XIAODAtKvSFqIl3mFwdW6Co9hqYT8JBrA6Nbw==
X-Google-Smtp-Source: AGHT+IGaJp3wZ5Vwcw8JnM1Fw3qkBZVaW3tlbctbVp5/va4I2gWGuWNNqQd9S13rOB0jnMO6QmT1jw==
X-Received: by 2002:a17:903:3c23:b0:235:eb71:a37b with SMTP id d9443c01a7336-23ac48833dcmr105416945ad.46.1751123192244;
        Sat, 28 Jun 2025 08:06:32 -0700 (PDT)
Received: from [172.20.0.228] ([12.48.65.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acc9efffbsm38945405ad.42.2025.06.28.08.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Jun 2025 08:06:31 -0700 (PDT)
Message-ID: <4512dee7-e37c-4890-9983-f8a1591bc47c@kernel.dk>
Date: Sat, 28 Jun 2025 09:06:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][TRIVIAL] io_uring: fix four comment typos
To: Andrew Bernal <andrewlbernal@gmail.com>, io-uring@vger.kernel.org
Cc: trivial@kernel.org
References: <20250627232726.58700-1-andrewlbernal@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250627232726.58700-1-andrewlbernal@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/25 5:27 PM, Andrew Bernal wrote:
> Fix minor spelling mistakes in io_uring.c:
>   - cancelation -> cancellation
>   - reuqests -> requests
>   - discernable -> discernible
>   - cancelations -> cancellations

As I've replied on this list before, cancelation is a perfectly
cromulent spelling. For the rest, not sure it's worth it. And:

> @@ -1162,7 +1162,7 @@ static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
>  	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
>  
>  	/*
> -	 * We don't know how many reuqests is there in the link and whether
> +	 * We don't know how many requests is there in the link and whether
>  	 * they can even be queued lazily, fall back to non-lazy.
>  	 */
>  	if (req->flags & IO_REQ_LINK_FLAGS)

mechanical changes like this that don't even look at the sentence
(there's more to correct here...) are certainly less worthwhile than
making it more coherent in general.

-- 
Jens Axboe

