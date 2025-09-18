Return-Path: <io-uring+bounces-9832-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0E04B8411A
	for <lists+io-uring@lfdr.de>; Thu, 18 Sep 2025 12:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C0ED2A4053
	for <lists+io-uring@lfdr.de>; Thu, 18 Sep 2025 10:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D57BF248873;
	Thu, 18 Sep 2025 10:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L774ETIP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2064E3C38
	for <io-uring@vger.kernel.org>; Thu, 18 Sep 2025 10:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758191136; cv=none; b=lr0fJAD0y5i7lAsZftf2PKHTGJbRoLCpCl1eBdGmLLV1QxeILpy41LnnhALfkIz09TF1kl2J0+O2nCuqOz0Qxi4rtAGDxHxapYKVzA2tVNm9P5pbUInJljvP1gTuAKopkXblPRwYBuzmQT9KhMxhFM1nIS2s2SCB3e8j8y23vyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758191136; c=relaxed/simple;
	bh=0unCVXo6Z1D/4kKJegmKAG2e96I0PStnMLF9noXUwdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OqnAX+qF0kxBsQKwUIHcWQiE1cO6Jb2bvPo3XcMkZ7ONDu/WcvbimsT7l1K80HhS1/WYXxNkcX5gjn4cBXkUFzD4BNj1VwYOjtzs1Tl97wsK82UB5YvT9TcydD2bCg4n1dxEOI0rOwiw9ngzAOV+HrzLGug35zs4Rf8Hi0qkriA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L774ETIP; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45dfb8e986aso6704355e9.0
        for <io-uring@vger.kernel.org>; Thu, 18 Sep 2025 03:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758191133; x=1758795933; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ck4RGm/vU3ikcCTM+hC2S6Hi5xalGWYCMbSYDtBRwoE=;
        b=L774ETIPgkbiKXqZ9TI7NHE/igUrqXcwW6fUi/W9CKfLUcBYmrIWHD+D4opXyN/0Vi
         czrUrfWTVApetIO8KvtsIJy2BOCqwy9EobeXPnQjzuJo+ELHlKQ86wweYcGbl1oCOzLd
         NxVzcpLzKXs6QR9qPs+LHjC2UEFS1HJB22vweu8OIvzVSCiEnthhHdN2XcTIPTTBGkxl
         fp0P30b45AcMgBeXlIH4WV16AOc3dwnBDNWw44bY+2Z4OSK7Hx9N0y3TYrNnez9hVrOF
         UwOoL/f9VR9ZuowFot9H4T5kimnRJD/Q1GXaNqUysXofeKwdVeNzvsMDjR/OjTjEXX+l
         5Tbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758191133; x=1758795933;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ck4RGm/vU3ikcCTM+hC2S6Hi5xalGWYCMbSYDtBRwoE=;
        b=DpaOxLKG4hCqdfuvI9YQAsOfSD6DEQhEoOHcXBZwxa2Qct0m2hDkOUjj9GgPLFJmYT
         MufLavC3NqyOTpr+x71T1p8CVa6jWQnepODpP4NzVOVppuLD9hDPJKUgxxD+eq47CPmi
         DAW/uLgIp7IiRNbi8xKeIUYGBwWHsDPVm2pF9aZ7oX/I7Vym2yTPZAQKOfrtHhtopflg
         PXet43ienBJutMD2eoy/q6MTGf/re7WPa/7KTFCnx91ddllObVZ/8nGB3cIwfA270MR7
         onHEcMk+X1Pg3KXnok7qT8pDMgUYg1iX5DuBCQt5vTlbcPjON/CivWeoImWhbo6BbQmB
         qKjA==
X-Forwarded-Encrypted: i=1; AJvYcCUcLS+c7atPFe+9wtlY0AnhpAlVcDG/WHOFPV/VDqoQYNNdMoQgHVPf4aiQfWm3NSjRpTIyKsjxOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1xfVRB1NHYj1mlDkcm5D87TwhoFf/25vzTRty1cAXfrVuOZYI
	idMXKtqW3wfhv6tpxYAj19WLAwL/OHrEG95q7pNNe45DNekmhcrXOtvB
X-Gm-Gg: ASbGncs6RL46H1B1X+PG46q/cKS/NlhxZ8VxvWE65mu5oPu/G7MPqG/FPpl5yy3c6C8
	8l3Eb3ECikNg9LArHqg5mXMdNMNy1Mpaem5Zfv0gqPK4WBqGRPZvuC7f6AC4bNkbvBMmpHnvzLE
	hzdMr9P/PJhH18jZMugUQw574QHqtobbe0iyEMM7bb3P3cotDD3PLejn7zh0X3UIxwJVaDbEijJ
	8UJdTpdrnn3yevuguaIA0X+nUdO9sbgkClBZRdUnkuf3uX8MIz7FUObjmXNiQB+8XRizWiJsClS
	04NiPlO/1rQiUXAdmgmvd0yLJmhyhS45jJ+g5gSEvBR21KAyMCkQIdk3ekyKZW9gHCmvtRaKfue
	xNpScXQhMMzVh80H+3TGCVEGD3xIklLT/dy89MvGWqSOmJSKRqFs/9PwNaFT4w8LvAN1J044UBg
	==
X-Google-Smtp-Source: AGHT+IG8gYWb6DCyoY9ItvHq8nJhaLJ9cCXkPBhg8qkwBq00YGbMqmRMtbCx1Y9ehn5kEqYZ5mdvHA==
X-Received: by 2002:a05:600c:4451:b0:45b:7c4c:cfbf with SMTP id 5b1f17b1804b1-46206099dcfmr53917685e9.23.1758191132733;
        Thu, 18 Sep 2025 03:25:32 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5265])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-461eefee9f3sm68786645e9.1.2025.09.18.03.25.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 03:25:32 -0700 (PDT)
Message-ID: <253ba871-8795-4788-8db8-af743228b2d2@gmail.com>
Date: Thu, 18 Sep 2025 11:27:03 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] io_uring/query: check for loops in in_query()
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <2a4811de-1e35-428d-8784-a162c0e4ea8f@kernel.dk>
 <a686490e-03f0-4f21-a8d6-47451562682a@gmail.com>
 <6e347e14-9549-4025-bc99-d184f8244446@gmail.com>
 <3acf3cdc-8ace-42e6-a8a8-974442d98092@kernel.dk>
 <437ebe86-3183-470a-b5d3-1d5ff8557e01@gmail.com>
 <da6a8cb0-d726-48ea-8f10-2e5852e5acd3@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <da6a8cb0-d726-48ea-8f10-2e5852e5acd3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/25 19:33, Jens Axboe wrote:
> On 9/16/25 9:05 AM, Pavel Begunkov wrote:
>> I'd rather delay non fatal signals and even more so task work
>> processing, it can't ever be reliable in general case otherwise
>> and would always need to be executed in a loop. And the execution
>> should be brief, likely shorter than non-interruptible sections
>> of many syscalls. In this sense capping at 1000 can be a better
>> choice.
> 
> Let's just cap it at 1000, at least that's a more reasonable number. I
> don't think there's a perfect way to solve this problem, outside of
> being able to detect loops, but at least 1000 can be documented as the
> max limit. Not that anyone would ever get anywhere near that...

Fwiw, I don't think the limit is strictly required as long as the
task remains killable, even if it's a nice thing to do. It's that
kind of problem that'd rather seem to come from a malicious user
and not a honest mistake, and in case of the latter it'd be hard
to make it nondeterministic. IOW, if the user tests the code, it
should be able to easily find and fix it.

>> You was pretty convincing insisting that extra waiting on teardown is
>> not tolerable. In the same spirit there were discussions on how fast
>> you can create rings. I wouldn't care if it's one or two extra
>> syscalls, but I reasonably expect that it might grow to low double
>> digit queries at some point, and 10-15 syscalls doesn't sound that
>> comfortable while that can be easily avoided.
> 
> Those are completely different matters. The teardown slowness caused
> 100-150x slowdowns, doing 10-15 extra syscalls for setup is utter noise

Another worry is the possibility that the number of queries goes
considerably up. E.g. a query type that returns info about a
specified req opcode, and some library doing it for each opcode.

> and nobody would ever notice that, let alone complain about it. But I'm
> willing to compromise on some sane lower limit, even if I think the
> better API is just doing single queries at the time because that is the
> sanest API when we don't need to care about squeezing out the last bit
> of efficiency.

If you have a bunch of them, it might be neater from the user code
perspective as well instead of making multiple calls. I guess can
be abstracted out by a library, but struct layouts would need to
be smart.

-- 
Pavel Begunkov


