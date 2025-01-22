Return-Path: <io-uring+bounces-6050-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3E7DA19BA0
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 00:56:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB98016C53E
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 23:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC10F1CBE96;
	Wed, 22 Jan 2025 23:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nG8Qn9E3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7121CAA94
	for <io-uring@vger.kernel.org>; Wed, 22 Jan 2025 23:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737590199; cv=none; b=W8bNZV5nPgaOXovDFm93N9Y64GVL8XwkKi5W4PFBH2/q9e6Zhnj94WEegJ+YDgk8L2CszvPE0DSWHZrl2B1hz50JWp1dr9Qc1UoqT3O/k1T4DClSg7MPojuzf5DwZm1e7OHvW7d0RwVcsIjyDIdsg5BcH0aCctvoI4x2K+1Xxbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737590199; c=relaxed/simple;
	bh=o3f1xuaC0BUUCqiJIAax0xicFFm8hlUljKpczW95/2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oXJkg62lQEa86ZqE2tR8xblUGo8p+7Llo4SvMPhGOlE3xZ2SgsrsvhF/j8BP13xF+9gN7JkRxgIZHzegxa7iOFyFPOqQ5eEIHgL1Xd9fhciROEGDhu3W1khaqhs1wjzfLkJMDEQNsYU+j+6dwQJKLDJlQtuDdgrwlX/WqKZ3vB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nG8Qn9E3; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3ce868498d3so860645ab.3
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2025 15:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737590196; x=1738194996; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vAQ6YbdATEoCPaaYG0nqU5blZwIMJJ3EL+uuStc6gYI=;
        b=nG8Qn9E3nBpvpwQGzkxu9p6YNM7vWH7dpp36G5Wk0QX+Nwi/7416lPXzuQLqOs88Sm
         nCIMSX/gW2xnJQRuITVW93uXOFkArtAAEiliQrnnr2RKJm/cfAI0eVVaLcrqWvkWnIil
         rn101AEoSmz7Z4vxY0ciJ4am1TdMwAt5SNvSFLLIFBbu3aKu7s8CwT3hHf/eIFYD84hQ
         3WfgR9Imoz/EURVWq8jddbEkjIT2XF5hXNJPgGEkbF1vDYf+gCTqbn8tgnfrSao66gKT
         q4Yk0pV7Ax8vyaDejLs7vbzzPV0rBVWQxj+bl8JMbWnZ4GEY1Y80Ec3poFMG9hKCRL3I
         wE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737590196; x=1738194996;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vAQ6YbdATEoCPaaYG0nqU5blZwIMJJ3EL+uuStc6gYI=;
        b=pfIR6/GaXjLdYvrzJp1y+cP+Y2TiDjHgo+vPrIwJBS3L1J+C1JupLIVouuZWkZzF9p
         ifhimqj3MseZpN0Xjlx6qvXpyMIVf5mr0ywKKGs9alNUQvj05HzQXKKHfemK6K0uJmb7
         rNnda8kPDSIbPcajXzmK27T6vnKLUc0O00Y8TQwRS5R8C9IQOW+BRAlfOMBUy2vBkKyX
         RzKWUfG1I5qrnG9RLeUqE9dIhDINeP/0p5VXHdOAapccnBxsEc628DgSFBG+ieW8tQA8
         NG0koXax1bSSRaH2YmGpP+7g+HG+JM8g7HofeICXrEKuA6G50OEl6mUFMNlMHhJ6ZVle
         GnfQ==
X-Gm-Message-State: AOJu0Yy8QnhbHoSvTNFWayl6WH4zCp2CuUpzwAsgtmmhzdmzeJm5nyGW
	is46yO+cDBEnVG8KXDssr8gocfITOTD92B0JBMiH7xRmPR85v5JOdNctMoivOyYvsvxv55CI1Gg
	T
X-Gm-Gg: ASbGnctisRj3uwF9JdTUFns2hjjpNzuxvvvShKBKnom+JZ5ju6yE9hl/4u7vZESndDD
	72MS6HOZClFIJvYp1EwQMPrwJUk3x1j27cgS+3PNoaHnlz5Avj848+B06zsXg8CNtJWM9KIuQz0
	SrWpcYBKl+VUOVYvWsBorlnj4nxZ8oHlQH4CBd9jTawicOqrUDODub274P+5+ICo+1ncJ8CvXe6
	PseMqHN6n7MLzfAeySkdtRW6jqKC0jhgMLWGTIP8sWYQXmNIES8lqEbvHdWti1i094=
X-Google-Smtp-Source: AGHT+IGZ7iU7vKc+RDxziQWoWhvhmEJuWnumDZUbZi+J2N5ixUdSl/CyDiMveTz5qwOWs/1lm6mRIA==
X-Received: by 2002:a05:6e02:219e:b0:3cf:6463:41fc with SMTP id e9e14a558f8ab-3cf74487c3bmr196893115ab.17.1737590196396;
        Wed, 22 Jan 2025 15:56:36 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea753f64b4sm4401677173.28.2025.01.22.15.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 15:56:35 -0800 (PST)
Message-ID: <14b994e8-1e14-407c-afe9-5ed87dfc6abb@kernel.dk>
Date: Wed, 22 Jan 2025 16:56:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_msg_remote_post() sets up dangling pointer (but it is never
 accessed)?
To: Jann Horn <jannh@google.com>
Cc: io-uring <io-uring@vger.kernel.org>,
 kernel list <linux-kernel@vger.kernel.org>
References: <CAG48ez2k5+SpsvWm_Ryj8_F0vHZjYEgJLKa1M2pNpLEoj-0yRg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez2k5+SpsvWm_Ryj8_F0vHZjYEgJLKa1M2pNpLEoj-0yRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/21/25 4:41 PM, Jann Horn wrote:
> Hi!
> 
> I think the following statement in io_msg_remote_post():
> 
> req->tctx = READ_ONCE(ctx->submitter_task->io_uring);
> 
> sets req->tctx to a pointer that may immediately become dangling if
> the ctx->submitter_task concurrently goes through execve() including
> the call path:
> 
> begin_new_exec -> io_uring_task_cancel -> __io_uring_cancel(true) ->
> io_uring_cancel_generic(true, ...) -> __io_uring_free()
> 
> However, I can't find any codepath that can actually dereference the
> req->tctx of such a ring message; and I did some quick test under
> KASAN, and that also did not reveal any issue.
> 
> I think the current code is probably fine, but it would be nice if we
> could avoid having a potentially dangling pointer here. Can we NULL
> out the req->tctx in io_msg_remote_post(), or is that actually used
> for some pointer comparison or such?

Yep that should just go away, I'll send out a patch.

-- 
Jens Axboe


