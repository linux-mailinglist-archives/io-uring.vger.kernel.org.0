Return-Path: <io-uring+bounces-10398-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F3AC3A844
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 12:21:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2B8C1A478A6
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 11:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA8D12E0916;
	Thu,  6 Nov 2025 11:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ud6B9ndH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291F9309DC5
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 11:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762428064; cv=none; b=Ec+joJWeZfaqXIf+pNRpZQxiyDnP29VdXKC2zwBEPZZNvELakr4BTuOgfZJY3+lPnTxMhGNsMRmaMsBmuTZt2/CO9LrarIHst3NVdRjhrctoVKwDTgf5aj4epqqLZ6uj9JHXws5uSEoWN6jMZJJ5GZuniCe8fyBHqCa2XN22Jxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762428064; c=relaxed/simple;
	bh=MOfVxyEQ072NSg4BP2xgIsHDCPu9OW8wnY2VxStT1ac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bk39GvsuGuoNDlyFZbdAinnpKTF3svUW9x8M65ThbmkPJCAjf6LXYNpOeW9fc6KyJWj/DfutOC5AcooWbhgw9wS+dJRzqNiLY2FuGSfNkhBjMjQAuNjjJUNJvj51q4Q5V8Un9YSsD4k2rlpXvX617bu8zQE1bPzEGRclm3mxA1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ud6B9ndH; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47117f92e32so6651125e9.1
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 03:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762428061; x=1763032861; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q3SRtvHsIYC0vIByUL+88tLoRIu/W5pJn6djXWnnRr8=;
        b=Ud6B9ndHmUMhhXV+N6GjPFXfqwXmzG8iLCUoqdBlFgPK38zmHflYowGKsy4Y5LHT4e
         /3o83xA/kGJaQ3Xi1ie1a3HbIW3t3xWpXs26K0HRJVj/G7XPFaLzI6reaLP7TZSZQJV7
         DAElS6WrpVRQYWSbLLnQYFt1D8P42890ZIgqqMFLhNqr6qERvqpe8u+NnUwqcfLWDVMZ
         AFs1Zqpbe0pFjgRNWg/Balv/K20n5XbN5LELJfNx2lET0su/kVY/JFm54hqToTKH0ckD
         +uikIJrtN4K4iAtp731RXmBBkAIDlnLwlsmBPuhNVa1RTQN4yJpg7pnpAREZu2f5L4Ey
         5EmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762428061; x=1763032861;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q3SRtvHsIYC0vIByUL+88tLoRIu/W5pJn6djXWnnRr8=;
        b=Lm+yL3bqBkKFpW6VM15j+sUMs28jKcVMInlQogg9odjnRIXocdpPJDel0mnBr32y5g
         6vEZQS4KTuUGNFp7eQjObmiiOs15s4PGO6hbXQk6I41w2u6t0Q06wQLlmOIn6m7DwJEk
         vBEpsAJIJ4uU+li5bJYPVu7yP+9PCG0Y37xdD7g0Ou+yWD5EWl5eWFuOmMWGkGj2riUw
         WGoXWW4e3PMLG5BslmGZZ51L/JKag6xbb5chhuuSCWQ9idomAL/cHBim0gHfuCf+DNyF
         WCcZJUdfnxlHKVXS4jpu30RckRtXqT8BNtmmiIAYVEGz1JsSmHeA2Sxxx4mlvCSe82nI
         0hnQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7rDMefH3v9fKOUKa+AbmJkg16CRltg2jEllmN/QJg8mHWpDklMqnGZ/k8wbqD6HdfBjBjOWgSeQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzbjrVNl8YALwhhrPpJN9mA0d2kIlwlignNbgDBOrT1lhNBaONG
	Q8NRA+1n+kxNa+1b/dnDtxNqE1ky2HA8DgLeUzvGPFr4jhiPCLrYTqtQ
X-Gm-Gg: ASbGncs/fvwXuOQs8fDFJBncaDZVroBRrwmReP+K/wd0ErKGO/iP8rjmY5khd82NWtn
	jEQyQ9VWzK7lG3pnEFOhzJm8anmUwSk7u0+HQLYTDOyWrGM5HZ/fYlBya1A8mEJg/C972EXWdDL
	N3uRSGnKr/cTqRIgDiP+r/Qs2x90iMX+FKMcntBHacgyEvYsSqVppqMXzAba4fCN/0Zk1c21nBv
	4t/uXjICMv6lcalMIVceyInwGYEtfp/1kk6XCDNdmc4Dd0HEnjV2V0DuJpeSjUhvGjTJEfTlY5T
	qI3Bz8vWFWKNTSunHThs5rTkTepUKeB3s0h7GHux3BCvrem0C8SIelFJs6PTj5qSgVl4BJmJBeN
	/f5MQ8WF55XhlDKxH/IDRg8hl59xXDyQAo4ZgN1O6ITlaIjjgpmCZ4iBsIDNk3w3vExdF3HtllO
	wfF0MZM3ujgzak8ttBC5iWwdkiX7ez2eXzQGHsVnKAYeWCz61FACM=
X-Google-Smtp-Source: AGHT+IFJmdgV5xNlzlC/wIdZlB2h+f1Q0+jRo/ficTf01tZOf9bAameVlnIquupx8Dy2fBB1WZnh1Q==
X-Received: by 2002:a05:600c:458d:b0:477:598c:6e1d with SMTP id 5b1f17b1804b1-4775cdcf05dmr57240105e9.17.1762428061321;
        Thu, 06 Nov 2025 03:21:01 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb403800sm4307102f8f.7.2025.11.06.03.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 03:21:00 -0800 (PST)
Message-ID: <fb68c19d-d3dd-45c4-a460-589fd246db5f@gmail.com>
Date: Thu, 6 Nov 2025 11:20:59 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 7/7] io_uring/zcrx: reverse ifq refcount
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251104224458.1683606-1-dw@davidwei.uk>
 <20251104224458.1683606-8-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251104224458.1683606-8-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/25 22:44, David Wei wrote:
> Add a refcount to struct io_zcrx_ifq to reverse the refcounting
> relationship i.e. rings now reference ifqs instead. As a result of this,
> remove ctx->refs that an ifq holds on a ring via the page pool memory
> provider.
> 
> This ref ifq->refs is held by internal users of an ifq, namely rings and
> the page pool memory provider associated with an ifq. This is needed to
> keep the ifq around until the page pool is destroyed.
> 
> Since ifqs now no longer hold refs to ring ctx, there isn't a need to
> split the cleanup of ifqs into two: io_shutdown_zcrx_ifqs() in
> io_ring_exit_work() while waiting for ctx->refs to drop to 0, and
> io_unregister_zcrx_ifqs() after. Remove io_shutdown_zcrx_ifqs().

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


