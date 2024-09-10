Return-Path: <io-uring+bounces-3113-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 439AC973AB0
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 16:56:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E17EB1F25F7C
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 14:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292E2199254;
	Tue, 10 Sep 2024 14:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="w3RdYqLm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848811990D7
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 14:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725980160; cv=none; b=oFOu7Zxm2HWq5EhXSYOouiOeBksURwl6Xi4ZGj+YThR4fP6XZ8ooHelwph44yyQDWwsqBne1tlG5ZwiqGmOP+WXcXoI+4Z8hzVk3blyS1Zu5fJZeslR3njBh7MYV7mACXivvVbgtEZf4EA3QbPj/0+Ptz9Ftyg+xUZgssndgzv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725980160; c=relaxed/simple;
	bh=LRKHhEG+UPUrru0gQJA2Slcgr3K1BQ2xzSCLu6g82rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hsBvmrbyq99JCip4rLyXQE4ZwdvofSrXmojFff0ux0W9SbTRNh4dqvkRdvKF28SaLQqbLjOPqxbqt/QkMasTTcpUj+k1MONFgjFiQCjlwAjfR7uLR+R/PAQC8+SKcELQ60SJYHgCQC4sDEoX5JjC72AwU2cBsaJXnQ2dI+hDMBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=w3RdYqLm; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-82aa93774ceso211423639f.0
        for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 07:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725980157; x=1726584957; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w0UcPXNBDPdAI3YKo5hRUr1yzJFMOK3YtStJSZ18Rfc=;
        b=w3RdYqLml4tbdiR27ZqgUGchmFYTY6g7/ck36TEmY6csPLiIQy1wO3zrspbP7/s1t6
         AgMlzLVc3El7VV7PI04ji2roie5VBviP7Aa9nIpJ2xbBM60j9CQ17aMgvmWEYxnnDaeT
         P50awePkrx77nxpo8YRdNLlX3Kcd2qMvcu0ClJ58dS47HCZoX01nvvuQuny4S5tQJ++f
         Bg26Gd4PgdZK8yEn+ahjYBkLc7nhrxVXSAA2EeqKNw/Oqjrh2JFA1XBMM7z6l6LK509R
         JQ0ZyeDXRErSkxqP8dFWv6iWaHaovfVAmgQA3p42Olv54D8DPHyhREfS6EXshPBdU8Yx
         VXVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725980157; x=1726584957;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w0UcPXNBDPdAI3YKo5hRUr1yzJFMOK3YtStJSZ18Rfc=;
        b=OVmvL65iIxDLozwEJ9NI2Er8vnK6NiXGGHCu7QDCbSeuRS7g0pVVSQIyNRoPWxFX7y
         J81H5gCLGsRbd9eXPOvR8MPeXqxTdDlRxuligj2NeVFcs575Nbex/WilGm1BViy6hUTm
         wULI6KqYzYbd35rVRpEmA2PWmhRoxPJhkaCbSDE4tnANvNy2m5YmMSIH/zkPg8mwgKOF
         2+S2lGiA1j96/aFGUEbsGJw9AnJJw1demoxXZ61I7MeYR0hlw+qlA5cmUhEMzuAqwU47
         xyF1xFT6GRFUVICzWX+sppYQBum9hp08BJRElbdHk05vu8T/aTIjtYAS6l4FkSbX8QID
         ZVLA==
X-Forwarded-Encrypted: i=1; AJvYcCWFV/p2mQowrGvsdW2CkvUAXmsd2ES47BIIowJBtfknv/9nH+MJMOUardshzN6d3wLSOiPUdu6tlw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8t8OOZpR3E7ELmQO1EVgUcJnKzKxJlkHEyZvDSJAuFdx5qBhv
	OMmC1fvkIMVbNhOAOcXf8oACcHITbJJk/mWnMoAxLADOcECiatpZFUYH97XJoss=
X-Google-Smtp-Source: AGHT+IFwciO5QAOs/QiVqDCZYsdUuwqBkWFwbfoOlmZLRRbNYyabu5+ctk3jZHmS95EKdBS9715lNQ==
X-Received: by 2002:a05:6602:14c9:b0:82d:8a8:b97 with SMTP id ca18e2360f4ac-82d08a84650mr111604239f.10.1725980157605;
        Tue, 10 Sep 2024 07:55:57 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82aa733a30asm207850639f.8.2024.09.10.07.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 07:55:56 -0700 (PDT)
Message-ID: <03b4c259-ab70-4a61-a428-82b0261752b5@kernel.dk>
Date: Tue, 10 Sep 2024 08:55:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/io-wq: limit io poller cpuset to ambient one
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, cgroups@vger.kernel.org, dqminh@cloudflare.com,
 longman@redhat.com, adriaan.schmidt@siemens.com, florian.bezdeka@siemens.com
References: <20240910143320.123234-1-felix.moessbauer@siemens.com>
 <20240910143320.123234-3-felix.moessbauer@siemens.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240910143320.123234-3-felix.moessbauer@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/24 8:33 AM, Felix Moessbauer wrote:
> The io work queue polling threads are userland threads that just never
> exit to the userland. By that, they are also assigned to a cgroup (the
> group of the creating task).
> 
> When creating a new io poller, this poller should inherit the cpu limits
> of the cgroup, as it belongs to the cgroup of the creating task.

Same comment on polling threads and the use of ambient.

-- 
Jens Axboe


