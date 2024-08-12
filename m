Return-Path: <io-uring+bounces-2720-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D443294F6C0
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 20:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12B501C21E1A
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 18:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D50C917A584;
	Mon, 12 Aug 2024 18:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iIUdBKDd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25C1184542
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 18:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723487429; cv=none; b=sGI7GEGwnnAtTwZaZp7vE/nWRptXt5YGaXQvdUMaBOk5HamrwaiaSf4SWF0ZRstaFo/es73z3kl/0gFTNb+0f/dKpKd95+uUVSsyW966QU8BpAxzH2m6XKciovJJVS+OJzYxNpp3Z4lUwQ2F8+dQKl7BXxuXsv/7FoJgKaldvwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723487429; c=relaxed/simple;
	bh=spoaQUvphxs0HUYOInfgvoRVHEq5RKRuwFv7GNqv7xU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=n6hk4hqzKCQs6szSElas8VMZ0xoczROZWauci8B0mLCQAo6I+1/TrZ7+mqtl/hGr8cwA45DfcBeS8sHAJaX8APolIIOHRhrgh5rY3H0vtBKhJ2Ha5WIYkjLWa1PDw+1WwI79pWaGBHwAEui1UNmJ+2gK+55/ULtQ54xfNV+MBlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iIUdBKDd; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1fc71a8a340so1933805ad.1
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 11:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723487426; x=1724092226; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=om1FZ7HCS9akedafE1UwwlrI9EjtRRNda0QxzIm6N/U=;
        b=iIUdBKDdMGKyBXqAv0kKILC3WUiY7ETVWv2YbxWMJPUMKTlcVtmyxwnXtm95A9o3v1
         P9ppozt5no5FUL4GUadgw+CXwPAlirOuinv2+1X5dFCME9m+L2AjkskH+XmbEfzINIRx
         D+E0VnOL5JGaNzDDnGFHr941ds9yXYgjAXTUzWNpNQnzYb8TmwocPRVW2qTETXjK9R9p
         /EnHeWAAa+hOxpZiD2GWFh9MJsm56GelJ1JX5q1QAG7L2P6qB3jbQC7xzD8tDEec646D
         l7d68+cVdA1QSXaPhaKv2I2i7i4Me/4no0NHYfhEfakuZikjGzrSN3TMAMsUtsiacOwW
         D5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723487426; x=1724092226;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=om1FZ7HCS9akedafE1UwwlrI9EjtRRNda0QxzIm6N/U=;
        b=TX0xAL3srrnskc5cfbJE1G5KDiJLt1dcV8h2/LP5iWpEHcicRWMUT1H2s2tOXYxWCb
         B5AGkamqigIPubz6pEVqsu7OAOWK2EAv+S0v4ThRhwVeFTHmI67GNl9aBS02JRneCQwK
         f5y2tnOCExiq7ZKnjorRf1VesLOm+e32ILMBgooE8fZf+1FfW8vVSiXuG8vh1t+pz8+L
         r3fyCfdrI5WDjrcR7gl4dLihv0ocbKnnyD6Ovx8nJjQRXjC6hfyxGIqKiiX089oWQJm0
         y6oorw1j4oIKkM1VuSJRS308b1a6W8wlmvKoqFNuAYm9J18RuFDjRoAE85jev/arww0Y
         VMfw==
X-Forwarded-Encrypted: i=1; AJvYcCUpQ7MAro8MmyrlW7X/E7nkF+8fQ8aOU2U/R+D/xWUWf68kqSqZaT+cqsvgvo4R26kAyeqqytEpGXf3P1s+Dc7o/dbqO5RY+tk=
X-Gm-Message-State: AOJu0Ywy7L9j/XxjNskLgEvOVwhEexE/+wl84qkAiHXUQsDujz+k+ZSx
	4cMFYE2T98HcxSVfYCUweUVSWPm7WjYdcKEr0/Zq0Scuuj6ZmFAt6QHLeiioHLI=
X-Google-Smtp-Source: AGHT+IHkRhTZ+EVjtyOnJ78xXqNWI3ffVupzvGbmsYnWCOaL87ZxTNERpWKYintZj8v1NhVdYZah1g==
X-Received: by 2002:a17:903:41ca:b0:1fc:5377:35ac with SMTP id d9443c01a7336-201ca1db620mr7828175ad.10.1723487426077;
        Mon, 12 Aug 2024 11:30:26 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb9ffe3esm40936285ad.219.2024.08.12.11.30.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 11:30:25 -0700 (PDT)
Message-ID: <6ad98d50-75f4-4f7d-9062-75bfbf0ec75d@kernel.dk>
Date: Mon, 12 Aug 2024 12:30:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] clodkid and abs mode CQ wait timeouts
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Lewis Baker <lewissbaker@gmail.com>
References: <cover.1723039801.git.asml.silence@gmail.com>
 <98f30ada-e6a9-4a44-ac93-49665041c1ff@kernel.dk>
Content-Language: en-US
In-Reply-To: <98f30ada-e6a9-4a44-ac93-49665041c1ff@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/12/24 12:13 PM, Jens Axboe wrote:
> On 8/7/24 8:18 AM, Pavel Begunkov wrote:
>> Patch 3 allows the user to pass IORING_ENTER_ABS_TIMER while waiting
>> for completions, which makes the kernel to interpret the passed timespec
>> not as a relative time to wait but rather an absolute timeout.
>>
>> Patch 4 adds a way to set a clock id to use for CQ waiting.
>>
>> Tests: https://github.com/isilence/liburing.git abs-timeout
> 
> Looks good to me - was going to ask about tests, but I see you have those
> already! Thanks.

Took a look at the test, also looks good to me. But we need the man
pages updated, or nobody will ever know this thing exists.

-- 
Jens Axboe



