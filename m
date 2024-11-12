Return-Path: <io-uring+bounces-4625-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6DC69C5C25
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 16:43:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CCEC1F21DDB
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 15:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A65720127A;
	Tue, 12 Nov 2024 15:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bBHRXVej"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E2C200C8E
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 15:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731426199; cv=none; b=n3dm98Qsp78da2eJuUavs9k4DWIyqFnOHdjkNKD/1rjvv1uUt2NLYHAHjKViy9rGiGeAb8vfc5rIwIbZkhFpGL3M99iiyyerS161FlmY+59gBUPvX+x3CSMyfDMBstoUf7qgf5RUkPZiDFVBaVAS+FSel1b59fCvZzT6lmQ4SAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731426199; c=relaxed/simple;
	bh=jLg3iIGdqUsUy8PbumjydYiC8wGi4ADE4Xjhm44Sa3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GKYCjqy99gxc5vtrBN67yCNcrMVWPbybrVeCyGlOh48tgZNDOxPp43xEN0QA30NmYaSmEBXEr3LD1ZJB5laJ7lHhp675/wo67MUR4y8Qilv7t7IZx0F/v2u6J2rsCeQp1fKHysPjLo3Wy0hrSDScbwMYs0DsUA//v81nGtodLbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bBHRXVej; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-71811aba576so3500387a34.1
        for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 07:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731426196; x=1732030996; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MPGRYVZnENQchqDtOkd6T23ctHQLbROEiqELavnqalk=;
        b=bBHRXVejZpnoYCYDMY+9pgYe9wgOsytNlZ/UTpBm1v0XdPHDywDvIaQIs9malw39Wo
         geOMVx6c46paVNzMWgHX+GB8C8sFiBTDJdycr6c9imXZUlG5uKArt2/yV7A7FEW1KGxF
         nXuubBNCPtBepq8KyXJtkTydNg1ANShRQYApA/+wiEigPH0z3d4TUONDtkPK7X73yGd3
         yHgjWnMA+QM4xpO7DNRogVzcNb5a+IzdQ7y3uPwt0G1hqWvKdOxcRF3gJS31tQiM56Gs
         7sHjX5L5nz/mcfHkTTlCOZGUX/BVHWA74S0jh+IlS41Q9W5T5MCTZTjDao1zv2lw368y
         zAvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731426196; x=1732030996;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MPGRYVZnENQchqDtOkd6T23ctHQLbROEiqELavnqalk=;
        b=MWOzS4LU6PR9yJVH0oeRZzDEasHU4X8o5MbyxPVcYn1CY2Nj8fpMjBkojCT5aUCuWW
         pwWh88mX/YLUOq8ltglRksgcrdziNq0WskblqLOaYP8SFoi1w4XflACrSuGqRTUpQ+F/
         QELiZ0rfyjCTSHslSsVGlRfTod9J+AB2dLiaN5m8Aq59D2OflO8oBo8CcgJ7eCwso/yl
         sf2ZFVEqR3L/XJ90St75Y8XwQgvkDRHKVXTAwKyBF893Gtov4aC3xBup4D4RlaY/Leqb
         FxJg8EVwkt8dxnG4ls3U+uwogxbDEfCKIsv5mYEoVr/xds386/180mn3J1yQmOfp5Z1A
         f5iQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxwMLNr6b7o73XAy72ZrG0Hsxv7APyHXvkxzZU6k2UnyzrnZ9Za234hyXM0Q1/IfqULshNeplmHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxRTvUIG0ywdAffpx0zx63TEV9i4QpnYJ+amPiKZ9Z7g8ykwQP
	2/LnI/GqbYo4ZGQNRdn/Bub3lpBPvMTLHonKiN4kOMBt0M5NZNKXI+NJk8E3Yxg=
X-Google-Smtp-Source: AGHT+IGWRW9zxLPcJ5x2fkal5OOLMH4WIgl8/rLC/lU0qkUAN08LLFyRp5+T7eXmY61Tvha4d7ZdTg==
X-Received: by 2002:a05:6870:450e:b0:277:ca34:27e9 with SMTP id 586e51a60fabf-295603c0c36mr9373068fac.6.1731426196316;
        Tue, 12 Nov 2024 07:43:16 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71a109219dbsm2741817a34.67.2024.11.12.07.43.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:43:15 -0800 (PST)
Message-ID: <c0eb2b6f-1145-4ce3-a2b3-98d32cdfa623@kernel.dk>
Date: Tue, 12 Nov 2024 08:43:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] test: add test cases for hybrid iopoll
To: Anuj Gupta <anuj20.g@samsung.com>, hexue <xue01.he@samsung.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CGME20241111123656epcas5p20cac863708cd83d1fdbb523625665273@epcas5p2.samsung.com>
 <20241111123650.1857526-1-xue01.he@samsung.com>
 <20241112104406.2rltxkliwhksn3hw@green245>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241112104406.2rltxkliwhksn3hw@green245>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/12/24 3:44 AM, Anuj Gupta wrote:
>> +utilization than polling. Similarly, this feature also requires the devices
>> +to support polling configuration.
> This feature would work if a device doesn't have polled queues,right?
> The performance might be suboptimal in that case, but the userspace won't
> get any errors.

We've traditionally been a mix of lax and strict on this. IMHO we should
return -EOPTNOTSUPP for IOPOLL (and IOPOLL|HYBRID) if polling isn't
configured correctly. I've seen way too many not realize that they need
to configure their nvme side for pollable queues for it to do what it
needs to do. If you don't and it's just allowed, then you don't really
get much of a win, you're just burning CPU.

Hence I do think that this should strongly recommend that the devices
support polling, that part is fine.

Agree with your other comments, thanks for reviewing it!

> This patch mostly looks fine. But the code here seems to be largely
> duplicated from "test/io_uring_passthrough.c" and "test/iopoll.c".
> Can we consider adding the hybrid poll test as a part of the existing
> tests as it seems that it would only require passing a extra flag
> during ring setup.

Yeah I do think modifying test/iopoll.c to test all the same
configurations but with HYBRID added would be the way to go, rather than
duplicate all of this. Ditto for passthrough.

-- 
Jens Axboe

