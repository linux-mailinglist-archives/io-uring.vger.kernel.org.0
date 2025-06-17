Return-Path: <io-uring+bounces-8400-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A99ADD089
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 16:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4BF927A604B
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CBB1225A20;
	Tue, 17 Jun 2025 14:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="V/uTsTgX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DE0221FC8
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750171959; cv=none; b=UNZ6Fb6eksdg9M9oXfp95jTE/HUjObo7Le4Y4n7xcvESSwLqwsJz4akpTmxmjymVMLFI2rj7ackqYbIwlNKr7kkiyhEP5ZHlt8dXcm/H4FNLV1MOGwk8sihu6WIblpvSpQBUss127WR6F9dT8CRFejpUjNVYMhDSuOwBbCOz5uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750171959; c=relaxed/simple;
	bh=blM95uT8B+cxS5ztOG+k5xAfAAOljYJVM8Ia1mKIbjQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ijTn2NcH1PeCeGdByeDdSjlsnnOlv+vK13GqnAtoOw4GazejbZwyPCmlgzmYGwdElS1gz3l//1NVPmuiFnlU1zRbg30DWtO8+qWz35O+rXRZxLgnUXqUSptVghjzQIKcHzyUbABzSoGxC4OfOh+hju8+eOWwMb5Q+zXc5MvPzY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=V/uTsTgX; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3de252f75d7so5468975ab.3
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 07:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750171957; x=1750776757; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fWCG+sGWx5UUfUHFdKWAfONPLhy8eh9JOvq/qxi8XZc=;
        b=V/uTsTgXs4XPGqt+uWnbUGwAhcQVAfW3YKlte+4gioRxraK/n9MrUEttMyn0AWeJzp
         NQUMFZBOVESoI5SRT1mZc0IwlDiw0oHxDToysS+SxQ5ZRP01Km3kHTnrIT8l4kqUfZeo
         zeezrtM2AAQMurpYCdKMV1T3vSFoHsXF/vgnpvpOGDM0JOv2CuUPo7dwLBP4MRr1CElv
         XReQkLzibkZYbbdS1axSE+7dmaUfNXnDu0d/widU19ERlFUPpOxn4AwkeEmG4MVe1T5F
         RpWMS4kphSxvqtQpQxDVErOi5GziKqqYs4+6a8RzeRNjGbEW6b4R/cj8QpI/986TApYY
         eI/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750171957; x=1750776757;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fWCG+sGWx5UUfUHFdKWAfONPLhy8eh9JOvq/qxi8XZc=;
        b=p6WK1Bu+Gz3LLUO5fJ/vEectcnBqdSfnWwtvp8ldkU+LRqxoFzns7JVq4B3JeGdOL5
         /415J4ky5bZ5AuX/b75hb07j7L272usG6+OhOu2w7uiHo2xty1bYgFEpffHhfJFbAAR6
         Gn7D/YZNq7hwMl1nFcU17e1/YM8FYNCfNeL4ZVyrsd/w7KWGIG3gUoeexKLpft1J2IjR
         T5+S1ehBJiOuHNiyXGeb66gi2KucvQg6XRKAACUQwAiouc8BggrrchwZUJbl1bZ7bhE2
         eDZsf+2jena+Z6hZ508zKCSRPjo6u2uZn4+Z6joBMi3aqNZkcfR8BfK2BUvS55cqBvR1
         +iMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjIO7keJKsyHqbjt1IvVepHz96lTCFnn7Cy1hUQwp/PdAmVBnqEqBpUhOxK2wlfDvKs990OnDjWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8dNoUUIhSUO362jO/krW4ea7oso2w5yB1PTkjHn2nxIAPAooT
	b9xo+xYWq2sXzoDMoWB5YVrqK2MhAIgWE7mlQrMp8btBdD5G4tu33gdgI9xbzucVJp0=
X-Gm-Gg: ASbGnctu5cEbtP6jDUIbgPBgoie3lUWpChpIUCxLMF3ejYswW766v/m04yn3KQFaWvn
	qlyfxXEcHRcP4x+Ns0KNi8rJRvEDAASojTC3vUlc6J1sBL7fJQN3pRCjRLz7AGWqRyUUziIC08y
	Sab3ad8xwuaeuckewnn5SrZgtRbevncSDknn4x47mzWczvcTjiQ+9XaG8vewV6AzwlU+q+tvWXw
	QU3pN4IGMEL7rEZsgAaaFBv0bJ2JxbyCThBAmWJHTFCUJ/dIoW4wLIlRL0TezcFjmyGpI+EgCyo
	fNIuynrl2xo5+N/A67C19XJxHgMPX3GNPj2Y+ZxzmeeLukuPY4oADM3SKg==
X-Google-Smtp-Source: AGHT+IFrpg+Q8bUDAZ3ZY2cXTx7WowWVqfXMIf8DAS6NR2qmDcAVjJmiDMt79oCTODCrhI7JsZloZQ==
X-Received: by 2002:a05:6e02:12c2:b0:3dd:9164:906a with SMTP id e9e14a558f8ab-3de07cc2091mr144104705ab.13.1750171956646;
        Tue, 17 Jun 2025 07:52:36 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3de01a4b379sm23864865ab.53.2025.06.17.07.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 07:52:36 -0700 (PDT)
Message-ID: <efd53c47-4be9-4a91-aef1-7f0cb8bae750@kernel.dk>
Date: Tue, 17 Jun 2025 08:52:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] io_uring cmd for tx timestamps
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing <kerneljasonxing@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1750065793.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/16/25 3:46 AM, Pavel Begunkov wrote:
> Vadim Fedorenko suggested to add an alternative API for receiving
> tx timestamps through io_uring. The series introduces io_uring socket
> cmd for fetching tx timestamps, which is a polled multishot request,
> i.e. internally polling the socket for POLLERR and posts timestamps
> when they're arrives. For the API description see Patch 5.
> 
> It reuses existing timestamp infra and takes them from the socket's
> error queue. For networking people the important parts are Patch 1,
> and io_uring_cmd_timestamp() from Patch 5 walking the error queue.
> 
> It should be reasonable to take it through the io_uring tree once
> we have consensus, but let me know if there are any concerns.

Sounds like we're good to queue this up for 6.17?

-- 
Jens Axboe


