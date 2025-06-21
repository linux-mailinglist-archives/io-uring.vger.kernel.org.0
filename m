Return-Path: <io-uring+bounces-8444-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 630D0AE26AC
	for <lists+io-uring@lfdr.de>; Sat, 21 Jun 2025 02:45:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BC224A329E
	for <lists+io-uring@lfdr.de>; Sat, 21 Jun 2025 00:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97318539A;
	Sat, 21 Jun 2025 00:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aZz1hkPT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1487D3D69
	for <io-uring@vger.kernel.org>; Sat, 21 Jun 2025 00:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750466749; cv=none; b=BWdPVDCTgigvaQNPLG5l/Zgr3Wz6BoBxRhopP36dORqbvq1X6QqpX754HuPVa1k62QDnE0RvILvhei34v67o6bf4+dnf3o/wYqGjQCoH/uvRf37Pm9V1aavnTegg2FlR7WlKWcr50Sa/BE3aJa2bIJxXuVR0W9klH6UezTtV+bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750466749; c=relaxed/simple;
	bh=/vXicv0zO8Xh6+Arf/Ygx7TcZEN7xXN5Wb93qZ7YgIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JMlLZfGOWu3ezqA4CohcUhVZMMM6utP7tEvyjsx8F3n+O6Pfof/rsqg/sn6CGo5BlrGC9dbcXryJjTRijVe04u7yzvBdaCg4BBt/pmMCtD0blsDfNgryHSVJnYZEQeulVvGsVTRZvybSNPMP61nDICqeRK0z+Quw/kwZ0gkJmNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aZz1hkPT; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-879d2e419b9so1957418a12.2
        for <io-uring@vger.kernel.org>; Fri, 20 Jun 2025 17:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750466746; x=1751071546; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/sbdXbeY2/eaugiOA42ampKhNLipC3GxlWN6lfAE8ZE=;
        b=aZz1hkPTkamJJmwE4WW+Vq8gq7KwUaFSJTyyidkiRVJj5UVkzFo8m3u8xua4xKWzQM
         Lbs6K4I18BKHnlQ1uZxcl5RrGWzVsqVaPnXIUu+uLTpoAm7KO6Ps7Lg0DaIyOz3JSGNr
         R/UoBRxSyx0C3k1ohhxb3vTkYXeXO8/cc5AJiD9eTCwkVv/2qrpV8rEHqbGOwFM2jsp3
         ++4Y/V4hQZwMltAuv9SLY/qqzydJuBfbaOvHGca0VPisai2TAAzhCvwQmHaORf9xFm1Z
         06IVSWx8lbEo3DjcPpIdQpH+iWG3zZQkW/y5Cim0QcxJiw0c3FrnlG13FNgf3djMw2IA
         KDuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750466746; x=1751071546;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/sbdXbeY2/eaugiOA42ampKhNLipC3GxlWN6lfAE8ZE=;
        b=IQjUCFPcdk0TOmX8rYhn/NQLGciI9F2ZIU4Rt5BAmTxJusu1d5qSxSHcbRBx+yFrd+
         ihd+Hqf5K8S4AoOANt6wzUPVDFlsX85hnhTZt9/CLcY0IdBIKmjCE661m5+mQq1BPhbW
         9UKbe/TWqoyFV7ByCWGCN4z+/g0cbjEiZ1Y3I580wH+eqEJI7qJO8QQh7cApRNLI6gqp
         HJyKfthUyUcDquc4e/KkFwIAmjq8urgxL/m9MXZi1eVEKoX5KX3Ei7j1Ir1RWIw2kb7n
         VgicFWVpyd3wAzAUWTAmHZlXwzhKgxy9m4iWu9JP7LLdm4NlqrP2wUZV9CinODy3gWtS
         xsRw==
X-Forwarded-Encrypted: i=1; AJvYcCX1GTGdeP/iGgmsLG1+Oe67LEwl3EtcHAhLm5R6NgGh6fRULcY2PO/rLtZRxoIFKDLwkUsPufqwbQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzEJEoukctm065X0Tp83iw2fP69CBno1doC+8bNepdecqEm0lmx
	jXGVTESMMkHBfCDpoyObd5AT/QalrFJTfzs3BcIFdPkxljVIr9dPy7DXrkIwCCXbh+L2QVKMRcl
	9cX9P
X-Gm-Gg: ASbGncv2g5w5BlrHRslZNt/orNtTwHvLUWxbymaEzz580ZacGiVgWFpBsJpQqOxq077
	HH5NyJkZ5R2pzc0omhmhVbhFjsbJATR/OCvxTizxbHn/wICdDlPkdCmIW4FWFLOk0W/PySj+xDP
	glJBAjCPz/VQ0LGoFaQvBW9fPZM3b0nogDg6+3WJ4ozPxUpV+XPisAizB8yve/WV+glYtu/JLwf
	DNHFab70x3WV70JxJZW9sa4zDQHUN7XBgzsp7W34p4hdxrgqEQAxSBnaE2ZxFIB6LXfRFRZQsQ+
	HrxGKi4dV79xy68bTqUoDisHYnVsKOYQuf/cUzBN/FQjoDtDQdnzXnz8Zpr82F3YgNH27ZWSwS8
	rxLxoGce/3P459GucWbJFfLYNI2X2
X-Google-Smtp-Source: AGHT+IFGe58Aajh183xb+xaVI4y6HjhTaPO8NjgjrfTnTmp/ptzBvH8aNWnz3q5vexwIUkQ0dtm5Ag==
X-Received: by 2002:a17:90b:4c42:b0:311:ea13:2e6a with SMTP id 98e67ed59e1d1-3159d6487a6mr8071680a91.13.1750466746099;
        Fri, 20 Jun 2025 17:45:46 -0700 (PDT)
Received: from [192.168.11.150] (157-131-30-234.fiber.static.sonic.net. [157.131.30.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b31f1243092sm2165142a12.42.2025.06.20.17.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jun 2025 17:45:45 -0700 (PDT)
Message-ID: <65868bf0-a210-4f5d-a18a-bd779e824de8@kernel.dk>
Date: Fri, 20 Jun 2025 18:45:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] io_uring cmd for tx timestamps
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing <kerneljasonxing@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <efd53c47-4be9-4a91-aef1-7f0cb8bae750@kernel.dk>
 <20250617152923.01c274a1@kernel.org>
 <520fa72f-1105-42f6-a16f-050873be8742@kernel.dk>
 <20250617154103.519b5b9d@kernel.org>
 <1fb789b2-2251-42ed-b3c2-4a5f31bca020@kernel.dk>
 <20250620124643.6c2bdc14@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250620124643.6c2bdc14@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/20/25 1:46 PM, Jakub Kicinski wrote:
> On Fri, 20 Jun 2025 08:31:25 -0600 Jens Axboe wrote:
>> On 6/17/25 4:41 PM, Jakub Kicinski wrote:
>>> On Tue, 17 Jun 2025 16:33:20 -0600 Jens Axboe wrote:  
>>>> Can we put it in a separate branch and merge it into both? Otherwise
>>>> my branch will get a bunch of unrelated commits, and pulling an
>>>> unnamed sha is pretty iffy.  
>>>
>>> Like this?
>>>
>>>  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git timestamp-for-jens  
>>
>> Branch seems to be gone?
> 
> Ah, I deleted when I was forwarding to Linus yesterday.
> I figured you already pulled, sorry about that.
> I've pushed it out again now.

Thanks! Usually I would have, but waiting on -rc3 for that branch. I'll
reply here when I've pulled, should be on Sunday.

-- 
Jens Axboe


