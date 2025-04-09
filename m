Return-Path: <io-uring+bounces-7435-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2C38A820CD
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 11:15:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52978464938
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 09:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE3525D531;
	Wed,  9 Apr 2025 09:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TkP3ZIsd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507AB25D524
	for <io-uring@vger.kernel.org>; Wed,  9 Apr 2025 09:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744190077; cv=none; b=PXMKRqF+1C1snDtgeOr476Y4ZPVr49dPKUcnAAKFUZcO6aUlimoaul6OdHWMwJWsuGveBQTTmyNDJJ4Yq3WkMLEunaeDG8lR5qMOOwUpzLJp7LY4am3PuPTu2Sv+YRrpi/dt3wekl0ynlDgKTJNwo/9OM/tCwkfx6kIqlu0MCK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744190077; c=relaxed/simple;
	bh=sPpL66boZ6o4WeoYyBoKQHH37xkutX4pwZNROTBXp3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IokmfHE/36tQuNuiV3r8usOQdsE+lawXZu29zPBHivMCttvxf+DBFOZKQMfNPP/87ssjdDQ138udignhLPkKIUMYvhfBAe4lhHcGjv1f5UmtLQJlZF61xIdXLdNOWDJ0VX3RIPKNr4LkMEWgUKFJloIcLkoq2sCQ2ZyogR7VZOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TkP3ZIsd; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac73723b2d5so1333133366b.3
        for <io-uring@vger.kernel.org>; Wed, 09 Apr 2025 02:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744190074; x=1744794874; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GzD85fDh1Wo0r2Gm0sjlh15ahKvdwokkc82X/VIPfvo=;
        b=TkP3ZIsdoOtUYL9rf3ihHMnqPZIXNGwFKNbm9wwkANHmnSpO/+p7KzxnVx1u51E/Uf
         ab8lbvQyTYtHaU7hWnciOjPrF3VTI29kZ34U0CIlcckFJwLCcMhbmKRN0mBLf/k+EV2G
         fnJioZwfam4oijTrUn4s8jzJeQguQLbmwxsW2utte05eIShmPwFpW7cZPysMLJcEuqXw
         1XS/9+HD/Inyot8icLLHCf1P/sSk1NbgOlIy0zYL4ipWxy3nim2ALEektxVS/0DHz2M8
         Np4jS6RKkJTsyXZx1Zu+ktPhwlZjb5XUSxdO14u8ofD5Ve9aSA5Bs4/Vhwmy0LoOAqTy
         qLAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744190074; x=1744794874;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GzD85fDh1Wo0r2Gm0sjlh15ahKvdwokkc82X/VIPfvo=;
        b=UUuBenrAJPDGoyiyKwZDfnEg385kIO6By7PQf+kacugBQMeXLbCawKy9m8BTe/xwDQ
         narSmCZDMCoq5b/DS65V4uDMXw/BRPA7jkYpu9OIPpKhinxC8GbNvVO7NPb7QOz9XUUQ
         VE2ZVBhUU8ep5LnauXwLfDMbeKZhCAnYVb3ruM90MkRTsF5t/nmJFUQXVlwS0AjYqb/c
         8WbidJ82Glbzto61UNCzolIGqIrJDNDLVjVzi2R1AQZS3Tb+cfGFoYfWua8fXd7vVA4X
         VQiVK3MfGSHlDvgaywl2g4bPEYijgOCUW4w/9h+VwwHAP/iJx84IbBtaiQ3HgesaqKXn
         espA==
X-Forwarded-Encrypted: i=1; AJvYcCWT1ZJIygoynC+YSQlYGU4fOukplZ2ZdYCCu10MhJTuOAM4Srlc+gULu9h9i/XxMRV0xePk3uQmKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSM5BiluDe76FV2LhxX4gKOyhermhjnHwdF0y/Hhdq8EynLvXb
	oXU2l/oQCI3fXpWm1dvIXjQr3LE4xfsLJCCIr5eGUq8wljlvJ8FeildywA==
X-Gm-Gg: ASbGncskaSUkkcV0HAe2Ylbn0caQRh4uIo0Cnr8jz/AHN3EZfwbIBYXNEMLrMYC3/RI
	L1ECvwBdWgHjgiPp7i2cIW1puqa/Yd3cg9HC0z3vB9SkEQDO63usiWAtPS5uDVgO1WttXpYwe4W
	G36MOWtzSYN9lE4CfaoZtIn8tPnf4rgSLSNIlXvvGyqF6JiQJBCE9NIJx321BczhpWDGqJCxO5i
	ds9OkIeXe952NPB6guvnrelBhf4NMhvhR00RNnhiWnh0c1QDn94wMrFTxuxShjZ9AHq/biXyLwP
	nCGv39UureILkdRd/5HRQbCWYyEhBgiU6odlFeQSo3yEC3DcKKdb
X-Google-Smtp-Source: AGHT+IHZSjBVdG3FRuwrtL8oR5kvmmATkeJcnnrgFxjxOfbCZMiVNkIar958gXPXTaL+gQ0+HtkI6g==
X-Received: by 2002:a17:907:d8c:b0:ac7:3918:50f5 with SMTP id a640c23a62f3a-aca9b79c761mr177598966b.60.1744190074375;
        Wed, 09 Apr 2025 02:14:34 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::5b? ([2620:10d:c092:600::1:f00d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acaa1c01e25sm62805466b.79.2025.04.09.02.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 02:14:33 -0700 (PDT)
Message-ID: <07b0ced0-cbf6-44a6-add0-e0cb1854cde2@gmail.com>
Date: Wed, 9 Apr 2025 10:15:39 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: consider ring dead once the ref is marked
 dying
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20250321193134.738973-1-axboe@kernel.dk>
 <20250321193134.738973-4-axboe@kernel.dk>
 <c84461d9-3394-4bbf-88d5-38a4a2f6dccd@gmail.com>
 <27a391b1-80a1-43ae-9550-73f48c1b8fea@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <27a391b1-80a1-43ae-9550-73f48c1b8fea@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/25 20:22, Jens Axboe wrote:
> (getting back to this post the merge window)
> 
> On 3/21/25 3:22 PM, Pavel Begunkov wrote:
>> On 3/21/25 19:24, Jens Axboe wrote:
>>> Don't gate this on the task exiting flag. It's generally not a good idea
>>
>> Do you refer to tw add and the PF_EXITING logic inside? We can't gate
>> it solely on dying refs as it's not sync'ed (and the patch doesn't).
>> And task is dying is not same as ring is closed. E.g. a task can
>> exit(2) but leave the ring intact to other tasks.
> 
> It's not gated solely on dying refs, it's an addition.

Right, which is why the commit message stating "don't gate on the
task exiting flag" and leaving it gated on the task exiting flag
is confusing.

-- 
Pavel Begunkov


