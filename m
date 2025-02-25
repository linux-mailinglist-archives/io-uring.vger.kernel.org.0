Return-Path: <io-uring+bounces-6752-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BE4EA445D6
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 17:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1E8E1886575
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 16:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1152118C91F;
	Tue, 25 Feb 2025 16:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NU2yMg7d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686CE15383D;
	Tue, 25 Feb 2025 16:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740500326; cv=none; b=k/thz4qK5p8I36oDXZrf1vBz8hqYzlTTxcVRSxTqlJ/MGjMKxUTpMkBWycJc0W1aPnq9Cyw5gTXaYlk6fKMhbYhDp1e/FfsvQumbQ20T3OeD0oURJc1QktI7TnHy5L4YMwbzr4GkBfmw6ftZAq0/Pte79EfI/HertE8bNXV1kkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740500326; c=relaxed/simple;
	bh=8v8UKAGXq+W7nJT7HlIkcm0ufnw9Nv7ENI381/ona3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZZM2A46yi0bCwa3VsYWWLAzJmOudLFlEK+fE+EMOD0y9s4ThhojEyiu7Nh/6isMNT+uYH2ZAQYk8RUJEJ/OghPyMNj52mnPjnxBZOMyfaXkvD+g+OMQ+0XKPBuzqR/qPPsEUQUwJKIFzYrHVF4x49rHTrE4hfeggI7fXfTuL/vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NU2yMg7d; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-abb7f539c35so1124165466b.1;
        Tue, 25 Feb 2025 08:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740500322; x=1741105122; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R5403nDpNdvU+ycjcrJ3fYmrvyLabL2UBsaIetOx6N4=;
        b=NU2yMg7dHwUVi3Q9BSRIN8vnWn0fop7Nebq30eYDTtIXrEPvt51ezwGcYd1/HKqivy
         VwfLvcxTNsQXPQywzcmaYTigfBs+5tNIQjKYUvtEGPUevYgVVrrJfCILa96Hdx02EHGz
         BFpy8hCMJx4gRCymqcX6Ez0NfDYD7wptMlpZRXwEKKbMTZDs/A2d6Ga4d/CmVJRFjJhl
         ZfErDueZk/UGX57kzRStU+qLLw5TQXofvazdOK7Ur6eZM4F5pqPc6eRn4Oo5S5WQ+LnR
         92KzwDhK8y1wfhqN7HuTqDkzYT6s03wXSedsgFOM8ZeCEFpFn+TpquiYkObAavQUgw1V
         5olQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740500322; x=1741105122;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R5403nDpNdvU+ycjcrJ3fYmrvyLabL2UBsaIetOx6N4=;
        b=chUs0CaGHYmrOgqllmcWRprX0smEuXPXHdNBA140ulMsi+nDYpvWppcAHRyIYfVIGc
         aAMvivbWvQznS9jiWMxttQvgMac56Orijk3yDiy/dT8vECccr432J0dq4G6mGdLs7m7D
         nGwnAG9GcmXMvoeuWhY+U2yhvbYKyASzc3ifYQFGcxWVCO6izhRKcgngWzXDhU8hZRHc
         Cj1FKp1mMbWYbnluhrEadgIUvsLgoVJtPlKzp6Vh0+SgnDtqA5qYLY/PNZlDonJE7hTC
         3uC6qlW/xDRMsRo1Ahl3fvhufea0T5eZDAEAi6/7GsEbNbSITqDTQti/6fyReOfIXXzC
         gVvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFXLWQEZQbAMu/Ileehfkrgb4BzIBXTxRE/x7vAZc6UjGX3Nfu9IdYtkNhz2yKh718C3mHEvDXIw==@vger.kernel.org, AJvYcCXUaGC6GBcF3BFpxWF5EDYN8RFiKlU30W1Mj/lFCsX0XO8RNmmAJ1tPGl0LOQG9ZQ3F+Ps44YtR0qr47ZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvjlt0QYwHjAjtatFDr6XERi2sDbyu9kuKiYcTPF+e4wilJO7K
	qXyFwY8EgIuhMX4GnjdB3halMshUUqCcraZcbn53T+QVZnQk4mOD
X-Gm-Gg: ASbGnctMiEJltNSlnTmr66PP1WRWB//GdzHJqxiQ5me/UNFzhDOir+Ye3QQCB1elhep
	lB9s1CEGo7bl7KglkC7lJQfv0cvJxD/so4aynQ02w47LDOIyasfph7Mj6AZpA2bFnhO/xkjprfX
	85fhBNt3P54tpUL6R3/e2FH5C9z27ZnHrX7DP4FOGRHM5PsTjvaTMn3VNVtlN2ZSGMbeEwk7bHt
	hm6taaHVf/a29rpaEM+1d3sQ3n222Ppasj2IiGVnjPD/lRuQZaIOfpaFxhUAWk8hLkQwkfnvNss
	HCa5tqxtKIERa/o+SGkp+pKNTJl1SNp1EmQBZL4ZDWBYYKqFGL9E0iT/EtE=
X-Google-Smtp-Source: AGHT+IGU3EvK5+wO5zA0RWMDQHFsf+psOvbgNkOS4YK6ddabQ7w4DWpL6QgO58ycaFbD2uA9JZP+IQ==
X-Received: by 2002:a17:907:9408:b0:abe:cbb7:d941 with SMTP id a640c23a62f3a-abed10fdcfemr400077066b.57.1740500322543;
        Tue, 25 Feb 2025 08:18:42 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9e08])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cdc52esm167298866b.13.2025.02.25.08.18.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 08:18:41 -0800 (PST)
Message-ID: <90747c18-01ae-4995-9505-0bd29b7f17ab@gmail.com>
Date: Tue, 25 Feb 2025 16:19:37 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 09/11] ublk: zc register/unregister bvec
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-10-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250224213116.3509093-10-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 21:31, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Provide new operations for the user to request mapping an active request
> to an io uring instance's buf_table. The user has to provide the index
> it wants to install the buffer.

Do we ever fail requests here? I don't see any result propagation.
E.g. what if the ublk server fail, either being killed or just an
io_uring request using the buffer failed? Looking at
__ublk_complete_rq(), shouldn't someone set struct ublk_io::res?

io_uring plumbing lgtm

-- 
Pavel Begunkov


