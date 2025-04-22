Return-Path: <io-uring+bounces-7602-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4241EA9604C
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 10:01:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1674A189A64E
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 08:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F45238C1E;
	Tue, 22 Apr 2025 07:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y5Fu2Bye"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C21F1EEA40;
	Tue, 22 Apr 2025 07:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745308743; cv=none; b=LMKvbFkIjzkF3hz3s095Pc91OKxJZCcLz/qikZv8UqHxpx4r5hIoGwi6A3Q6j/U3rk8uJ7wep8sj6qqIWtgmQvPTRIWrfWtFxHC0A5324+sUhAqmeGr4BcxM7XccHzejx7k5XmbyWV4cKIZvCYxQlUv+U1RGZWtQhBtFmW4dAB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745308743; c=relaxed/simple;
	bh=U1NSlMKH2Q4QiOM+gX1bIuX+5W3KYfjTCa1ADvz2nCk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dt7emZPvndCoe7lIhJ8IfO5MH8PmnWpU2PUJ7+75HgXMmAwNu+gpdAKcXtpLOEsGYG+3sUITlTgPrfCEMf05/1x4+xXbCnf9GLlq8XlukB3hmqJCnpQxW04sXCOI19OEJineZO0dLsp3fIsn6xJNsOrOcegkshz9ArLvAayvZ2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y5Fu2Bye; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5f5bef591d6so8252472a12.1;
        Tue, 22 Apr 2025 00:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745308740; x=1745913540; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L/lN4gz+2egV7k5JlUuUM2b1n/evNrqq8ZZ3C9Kek9Q=;
        b=Y5Fu2Byec2xYXc55f/QvIaS2/oHBVmwM+gB4VYBbOOYCtjueeeek5h5mnYfw4Pj6di
         fNhUTBpRarHLv5R1t+svNVfe/1xPKC5n46OxTK4Plje2tVAUr9Iws227MXsUnMoC99cE
         mayi/8SXo0ehmO1uOkovZ2xsiEHQrogdvSrkX1D+SaxxpaxH4sZFnIqGZMUdCBeJ5kQB
         e2DkNoe3fumfhbYbVppVfqtnI/ZVXmirr+C2HeO/Qk8jS6xIOc7lpB068XA/WEEkfPUv
         a6h45VFpNsgOcxSXsVpf5W5wXLPxS6S9hMcuAjDWXlj4rSEQtqrbdCwhXo43NBHGDl1+
         vzDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745308740; x=1745913540;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L/lN4gz+2egV7k5JlUuUM2b1n/evNrqq8ZZ3C9Kek9Q=;
        b=TP5XIK8PlWh5EA6R+sapoArLao/W9Sf7HiOnZwYpNKLYZQXB/yPPjOvMcc7VdBK8Mj
         RXjJEwOaQEXB/9NyrgPaKtjZwPjRfi8wbTqRXyfA1fLvoQtTmOYJidDZtLU3zCc0Csjy
         zQQvpuS8AujHPdCPUSZEtIOOtH4sEe/gJ8gS066ppQnY2t9SORf8Ha8CLYgv611IDIRf
         X3h60sz+ItXZKIroIbk335k7pHJHAW09V4/t+AGVVfPNIDHnmyjGk+r5X0T3E+TDwwNu
         3ERInCBLImC4zcE8f8jzvylvGoRRgo7nzc8wy3MTJbGZ+s/M9EpElgD+b6y0ZeNcrPP6
         Swaw==
X-Forwarded-Encrypted: i=1; AJvYcCVZJfwsDw2QasgKg2aH+MQvyoC1sqQCNXunzMPMxloWUeed42ZokuVyEc4h0kvFFkJn74rrSNagoQvauls=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv8o4r+n+AQZE2SFgTCI97yQO/hIrl57sjnm9simeO21TceDxn
	QT6klfkf5ZqmqpTjvtYKqWVIYrLQB7Jvvk7TYIaV3FKbB08umjQR
X-Gm-Gg: ASbGncs32Ahck5KgUA2dubh7UYe7d0wrBroudbThgOqGa7oVQDfbUa2k11YYgSwq2C3
	vQ9CXigGfohsjigvepYgJX4fCEJkJBUUhHSpHnJ6hvyPqSZwqKEda7uCtzyy+OYz8tIaoNu2wQM
	B+oitN+f3fD1+l2ldU25uqq9VRJyCj1xSf46hd+CRwH53wQOB2jQwYixuhP4hhIkJJG8LRgeYWn
	PXl9SfydcGhra84fu4z4gaEO5xKVaal3lMivOWnZF2FtPdY+DZeeo/BAEWL+KkgvcNiD5gf0W1P
	t17IRxszV1E5DVNvFdXSaVxYCDj7D/Umf7dE1x9UbM695kjo65QjAw==
X-Google-Smtp-Source: AGHT+IFvpIcLDY6F7tda9PqHwKLcSMUx565gU6GKa5rJkI682BO1i9+d+z+pfGEJYtvXfllstDVdxQ==
X-Received: by 2002:a05:6402:27cf:b0:5e7:c782:ba94 with SMTP id 4fb4d7f45d1cf-5f628545bf1mr12637873a12.13.1745308740050;
        Tue, 22 Apr 2025 00:59:00 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::158? ([2620:10d:c092:600::1:558d])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f625833be4sm5818271a12.50.2025.04.22.00.58.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 00:58:59 -0700 (PDT)
Message-ID: <1c141101-035f-4ff6-a260-f31dca39fdc8@gmail.com>
Date: Tue, 22 Apr 2025 09:00:14 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Add new functions to handle user fault
 scenarios
To: Zhiwei Jiang <qq282012236@gmail.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250422030153.1166445-1-qq282012236@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250422030153.1166445-1-qq282012236@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/22/25 04:01, Zhiwei Jiang wrote:
...
> I tracked the address that triggered the fault and the related function
> graph, as well as the wake-up side of the user fault, and discovered this
> : In the IOU worker, when fault in a user space page, this space is
> associated with a userfault but does not sleep. This is because during
> scheduling, the judgment in the IOU worker context leads to early return.
> Meanwhile, the listener on the userfaultfd user side never performs a COPY
> to respond, causing the page table entry to remain empty. However, due to
> the early return, it does not sleep and wait to be awakened as in a normal
> user fault, thus continuously faulting at the same address,so CPU loop.
> 
> Therefore, I believe it is necessary to specifically handle user faults by
> setting a new flag to allow schedule function to continue in such cases,
> make sure the thread to sleep.Export the relevant functions and struct for
> user fault.

That's an interesting scenario. Not looking deeper into it, I don't see
any callers to set_userfault_flag_for_ioworker(), and so there is no one
to set IO_WORKER_F_FAULT. Is there a second patch patch I lost?

-- 
Pavel Begunkov


