Return-Path: <io-uring+bounces-3822-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F17B9A45FD
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 20:37:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 139181C2181C
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A006B20408A;
	Fri, 18 Oct 2024 18:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GdkdNWiM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5DC204013
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 18:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729276666; cv=none; b=rfdUD6MQ3cwYrOK/0hAhflvLUJc7rrHV1iMDuFkVPgjlmdeAmyF6zp6IFO1exGFtMnxJIBQupnc9yvCf27E3XbvDYawdQc+dkYCwV7enEpQV2D0dONZ9GBujKZny36PxzCdL+3X/XAsp5XZt4cs2jMVsTeVDaOowE5/i6ELCBz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729276666; c=relaxed/simple;
	bh=z8kDWqhG2fmnZedjpf541nKe3HliQPz2iUenl16evKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gMz4BxJT8lJQ93BCQcvTdBULkw2GzrtZwbUWNU7gpawMQYSwdn7woMRtS44Fh4vCod1m6ZkuX6hFUjohvJkzjxk8PMeujMqISWOFhQ0y2BjKsoDvziL9qsL8lQPDyfGUvTSg+7Trmk+npPrfLjGFScp2NYwX0oKqabZjnZ3oCqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GdkdNWiM; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-83ab21c26f1so84797239f.2
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 11:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729276662; x=1729881462; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r55aFScCQCKYzeuHI9JCFe0M0hPUYU+7y9691CsGG+E=;
        b=GdkdNWiMXQhPQ6vVuxQnIEwkFTnTcFX/VqL13ys8Pnv7L3Hq+GvOHjNtJB65jfkPjt
         A9Tc8n8GP8DFplVx51ZETbEbSFRxAf2KuqhSIvrewFbYoi3aRi9yyvbaP4PP3/hm1IMN
         qeTaBIRL4xBDlLbfBxSoWetVbJRVNtxQHuQq+24IYhXJWy9mUFI/7YHF8QK1BVUYh4Dc
         B9nymh0e+Y+KJPomEG4IEymNoBuLfUlTXps1HFvU1wYGgJpB5hWY66uNpHnOUojPz11f
         d1rj0MgVhlpLiq6mYta9D6tHDH1WVfUW1DuEB0JZbgs5oC3pHEyu7niK0PHZKEDQnbBp
         sN6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729276662; x=1729881462;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r55aFScCQCKYzeuHI9JCFe0M0hPUYU+7y9691CsGG+E=;
        b=NrjSmktxe3UEtx50lE/CmeKY0z53I7A1xlMKWRRsuQEPSa8FxJALqZKgMMT8IOcsV4
         XOyfZKWNqBOAzqGznUKksRwDzHWZrc4mgTXbC7EhFmCOie3MBzEs4rqw9RdG6/pvrkXi
         kW4drV/tqsicxRZTXFrpqzbqMXpAuhF4J/+9NKLPqjmiqRYFomMHBkqN14IvMEgS/8gP
         0LhDWi7iDyIdu7nFVVgaQuDbkzJEaEizwEpJXOpos+p1EsWuGs+K20wJM9n/8D28tRme
         y78J4SvO4oMFPU3ge4/d+RmCd3mEmvWp78SU2L+vSHPRbkLoyHTkKwgypaEQi1j3Coj5
         vMFg==
X-Forwarded-Encrypted: i=1; AJvYcCU2kBYGOa0FIMWGferYMk1yKelmZ/kZl45UGDUg/rbtZzB7PGbxLcz54qcC8FkUUpxSBYn/3Z44kg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxOpD1TisFeRdRgNwzQGx73d5v9+RCGAs1Q8PmW/VkIgGA0xWPM
	82TRbN8v1yaM1WFtuo8hz4fc+Bzkes7pPKzrjynSFs2vTb/7fI8kx3nVk2wkWpL2tmZzz3sP9Yj
	Z
X-Google-Smtp-Source: AGHT+IE7JQ6o6nHEPPiVQjaZeCUeX+uAosWMPjbh09es2FKmyiZvmZCyf8gQ5l035yHNKtbpYhbRJw==
X-Received: by 2002:a05:6602:3fc4:b0:83a:97e7:8bcf with SMTP id ca18e2360f4ac-83aba649c24mr274489639f.11.1729276661935;
        Fri, 18 Oct 2024 11:37:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc10b5b0e4sm550282173.11.2024.10.18.11.37.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Oct 2024 11:37:41 -0700 (PDT)
Message-ID: <17db11b6-16aa-499e-ad2a-da0575aaf334@kernel.dk>
Date: Fri, 18 Oct 2024 12:37:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] nvme: use helpers to access io_uring cmd space
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org
References: <c274d35f441c649f0b725c70f681ec63774fce3b.1729265044.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c274d35f441c649f0b725c70f681ec63774fce3b.1729265044.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/18/24 10:16 AM, Pavel Begunkov wrote:
> Command implementations shouldn't be directly looking into io_uring_cmd
> to carve free space. Use an io_uring helper, which will also do build
> time size sanitisation.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


