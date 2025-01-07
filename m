Return-Path: <io-uring+bounces-5742-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 193FBA048CE
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 19:00:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E1803A6B69
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 18:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA39219883C;
	Tue,  7 Jan 2025 18:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HsEjY7GP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED40A1F37DA
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 18:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736272832; cv=none; b=VxQbLcdZmqef+Tc+FKY63ZqbO7x9paN6rFV1o8lRpH/+LhDyPYwv0eaHH9axVzkMznqkWzcg0F9/W5QIgsW7Ort8R24/WwJJ29rUvmHRb7F3+u5RzLq2gEiO5VG9SCFiPLJKG6d92liJVuaTAiFK8xwKUyogwbiXVnTrUTjivNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736272832; c=relaxed/simple;
	bh=SylAn33hs2HJ9CMked7Db42/rfJkW18uobs9TO0qbPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FGDvNl6LD5ykNc83QYLQbazadjjw0SKvqOeqm0Vp19k/VzY+keSFfbB0G93GdlJ+QKbOuhRk+yF8S84RmFba1h4ijRButAV+jPEaFuZQXh6jKok6M1k9rC4SMk6OIRYdkO/v8mWr1AmSzQ+8S2bU60Gq5zARaFl5wGtRPZ06GhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HsEjY7GP; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d122cf8dd1so27686134a12.2
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2025 10:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736272825; x=1736877625; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Tj1jtjXVIU7lLo7fiOZqYPaplm+Kw6HMsGozkDkiwgM=;
        b=HsEjY7GPsYbx+ktIiR1OXLAEXX84O303fUTm483Iadc8XF+zdVcp5MmlZ+JB+XIiK0
         qyc/45GRn1giTmmn3zhIt1leq7oG/NiSABBJT5QvFCnGzny75wksxQomcGhKb0jxyJOc
         91lUVSozWLQN6AsiEHTbZn6Uq1DHmfzvOfFSowKX9yPlUdL25xx4FNpoMupKY/qMIRVi
         BlO1nFrlmiVjR/29MjS3v33PKg0sX0Iimvbhj1DXkVgqyhIcwkFiZSDA60qBmlqClKxW
         AXOyAe/f0Ed3Aq4UpDaPD+T94Pm10QyB5zNmLcwNn89s+/4dY/FrpBafLIBiTnu9zBBF
         fZoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736272825; x=1736877625;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tj1jtjXVIU7lLo7fiOZqYPaplm+Kw6HMsGozkDkiwgM=;
        b=qvVvxEg7IS8iK5MxfH0DM0oG+ncLjRtnY9QO+k0mkTAqQd0N2SHNU/aQkNO2v74mAA
         lc4lMxQc64SYuYoVjD4COnfRELvwnHCHnMvCT11XYauT5UnfyU0JnI01Z1Sw7oQiJ2vv
         jTZseQZNWtHlqT9wpbwdr11LIGOF2Wr4MzOXXlesmHRfsbsJLsWQuZ9OlbzbaiW+OtlL
         gJbnKd+MJqrsBzawSoEqj/54Zei6IQ5lbdjHE19oTlQDKA7lN5B5EKwutC+ADOMJIxo4
         jek6O5f0PK2srTOfvamlHUTT4QibBSVADoy+sBfoQUdTBZiLSk5+kWCFDtn6q/CCpis8
         aOLA==
X-Forwarded-Encrypted: i=1; AJvYcCVg/vr6dISABMs+oKdNzSutc9Cie3546tktAcy5clNC8qwZVAQIn3HFY6vzsDDnE7dWXO3w85DiHw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3A9YUpeFaHQ/PK52KmQLtEvHECF0UHa9eaQifqcd4z82ol68s
	5zgwAGYDuSW73PKkVYkJka7T02neHjphi/3yYM90ZHgjk9iJvWbCy7WEmQ==
X-Gm-Gg: ASbGncsGdMt/q2SIOyQYCZs5zyjTxcDBIyGymOnVQ/3BMJjQ/KknwzfL1dqkJApOXRY
	i4NBbfKOfE5ae77KL2RImWtqjHNGaatE5dorLcVYmV2AaA/FMvK3tIZic3rAGShNerljRdzybWV
	I7RVo64ypwcmatApEuIrU1Atw3Kt92dBijwhlrKXusR8/Q/gZ9zgIAeEdgrRroVX9sai2RZG3ci
	JKaiCkF5pmFWhLFg75h3OSK/pN56at87S6zqtp27FwBN3j360CmTiWWoWJ6BJl2CQU7
X-Google-Smtp-Source: AGHT+IHwTyD2TrRV6tiG2JobJHVSxanpFFFQJvUFM0x417CQhB3oH3Po8WF4RxW4ZA6nWmf3DJ8pug==
X-Received: by 2002:a17:907:84a:b0:aab:9842:71fe with SMTP id a640c23a62f3a-aac2adbd17fmr5315138566b.13.1736272825286;
        Tue, 07 Jan 2025 10:00:25 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325::46? ([2620:10d:c092:600::1:2b66])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e82f2fasm2403530766b.9.2025.01.07.10.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 10:00:25 -0800 (PST)
Message-ID: <1dffcb9d-855b-4d25-b364-98f6216dafe6@gmail.com>
Date: Tue, 7 Jan 2025 18:01:24 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: reissue only from the same task
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <e769b0d12b3c70861c2144b3ea58d3f08d542bbc.1736259071.git.asml.silence@gmail.com>
 <66a3fab2-dc5d-4a59-96a0-3e85c69fad03@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <66a3fab2-dc5d-4a59-96a0-3e85c69fad03@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/7/25 14:31, Jens Axboe wrote:
> On 1/7/25 7:11 AM, Pavel Begunkov wrote:
>> io_rw_should_reissue() tries to propagate EAGAIN back to io_uring when
>> happens off the submission path, which is when it's staying within the
>> same task, and so thread group checks don't make much sense.
> 
> Since there's the nvme multipath retry issue, let's skip this for now
> and focus on sanitizing the retry stuff for 6.14 with an eye towards
> just backporting that to 6.10+ where we have some sanity on the
> import side with persistent data across issues.

Agree, and as mentioned the patch is troubled anyway. And something
tells me it'll turn into more of a rw request "lifetime" change rather
than iovec / buffer persistency thing.

-- 
Pavel Begunkov


