Return-Path: <io-uring+bounces-9707-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 784E0B51BE0
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 17:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2FDA5E4812
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 15:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C1A42609C5;
	Wed, 10 Sep 2025 15:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hkLAIciQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BEB322A3F
	for <io-uring@vger.kernel.org>; Wed, 10 Sep 2025 15:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757518592; cv=none; b=a6pUuSuMpZMjObY/3gYiAdbpClfHt0cWBtjEtEZ/ZtslWYdoPtjHmhKwY5/oNgz23h+KD+jcmKOFimW2MohNWW1xAqXLnQPeV3JN05rsrXzwBfmqkYTG13gnnAJ2unhcb/cuPKII0iuXB0Kd05VmnHDbIrqcbZf/v2a8wMgF+mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757518592; c=relaxed/simple;
	bh=zkOizcnL3u2QyclsxwdhEzs6yCf0V1XIYt1ZjGU5oxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FiVh/JId+o+KINhna8Gd9otb3a4IH7Z5RXpqrhbaXFwMjbqvtx1KKxomnmv51rAAZ2+ofYF7xmaHVG0hJ9AhLtWcvoh8wnf7yMGk0V7wp5xgsxsB4b6aatktd6efgMcpEUeVIUWDS4NXA1b4LoREsycPJiRU6kYulfV2mxiALT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hkLAIciQ; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-88762f20125so541856839f.0
        for <io-uring@vger.kernel.org>; Wed, 10 Sep 2025 08:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757518590; x=1758123390; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=47rPTIRnkqkB3dhDRMh1IVTnxFun9DN1W/UXwl1XtH0=;
        b=hkLAIciQPLCwlrEjCswDlUBHXrV3z5mhw9sE8gRPdzsE4dQEPMVfA7hm7E6uhJsIMy
         PKinMck4HB6ipwrikjg7VmEElTXrIlvmefxYkZuux0ZHaec9Ss3qe2SovBlKnr4HaUr5
         pu2t4g/kk/Mrl3MIGEpUIpx4MAjMp6O9eCAssaXu68y1kEHvC8pnH/DpMUud+xPWmx9Q
         9yfCwBDmQjmS0GhJ2LKHYWhUIeNYrPldsIPnqGHp3POoRmjcK0g0FgivF6jFVE8MRofV
         qTD3A5E2fO9Wc5NMDG3E/UINXG9aNh+9Hr91IniructPBGQ+VuUDFubDhSTa7ZXtSfaT
         9mPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757518590; x=1758123390;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47rPTIRnkqkB3dhDRMh1IVTnxFun9DN1W/UXwl1XtH0=;
        b=bK66+qTmhjIuM61E91cejQPDgANcy0um8EsUGqxNid9zKHIfLrsVJvSt/pM+m8aUU6
         eXB79hKS9hE35H9JVJ9YBVcY+Oz2EEqwd/DvxnWGD1xbKyiF35QCS+LKKOgyNsRH9xSG
         /CBAI8lzec9pJM4T0le7Z0+taLfUoin8QYB++6RehCd9SO/1Mg90iksZDEyjGO211HMS
         3NXAnGrYOroEOFrAccPTyNA5ZT534gb/oy15YqW6JeXMe/VEfSzwu8C5nwUKRMS//zvs
         O0wq/JvvSb310xh0Tnzm0MSc4aKoLmmFrWqAVpA0ZOv/D202TRVUjfhrA4SRDJ+O0zS5
         T+1w==
X-Gm-Message-State: AOJu0Yy1bmNbcX+8FOPJ9iCZ+cpul8eI8zEeza54iAQUO2v/0uPzYYnN
	GymPpcHNm/l8XBvLj0NevqGHpa3v6LhYsTTijgiTaaIbAz7+N4pCWlZ7RgJ6bxZywWI=
X-Gm-Gg: ASbGncupmYNyKpBhXCiaQjh6XgrLdKCl30295lfu2FxyPUn7L5Wpz5DZp/x/wOSgHun
	7CZzS9/wGocCxyS4R92qyeVZOkv8gji2hH5CGJ2LkDa7tCxB/IH2rx81scMSN9bWP4JhEqRVQdS
	wUQK4vSxBnbsJIZ2ftL4Gsrj2b0peUQtfeJzw6/kk3ietkn60mX5gpMwfy6y7FrAeaMhgETrrTI
	d2Yh9FVURYvpDaHwvzG1vARQCMHdrVLR65JOLb6NN4y8sb0sk/SKR4XHdaKNcdeDhAAvXsKhTsU
	5gx9143zJZmbEmvMfMQ5leVRzlWBwiGQG+BOzR/67WVhHOyPN99mc56Eht9kfCTWlrZ0GNWOT6z
	c+qv/l1lJevriiTiktE6E6pjinitTZA==
X-Google-Smtp-Source: AGHT+IHPG8otLmKYXYss8TokH/egaHb8q0iZwY8WDEYZMQsQmIOSmU2tuP+1xUb4DCsi8EMkLLhLFQ==
X-Received: by 2002:a05:6e02:2385:b0:415:fe45:3df9 with SMTP id e9e14a558f8ab-415fe453ebbmr62746975ab.17.1757518589448;
        Wed, 10 Sep 2025 08:36:29 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d8f31c91asm10767260173.39.2025.09.10.08.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 08:36:29 -0700 (PDT)
Message-ID: <5d41be18-d8a4-4060-aa04-8b9d03731586@kernel.dk>
Date: Wed, 10 Sep 2025 09:36:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] io_uring: avoid uring_lock for
 IORING_SETUP_SINGLE_ISSUER
To: Pavel Begunkov <asml.silence@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250904170902.2624135-1-csander@purestorage.com>
 <175742490970.76494.10067269818248850302.b4-ty@kernel.dk>
 <fe312d71-c546-4250-a730-79c23a92e028@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <fe312d71-c546-4250-a730-79c23a92e028@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/25 5:57 AM, Pavel Begunkov wrote:
> On 9/9/25 14:35, Jens Axboe wrote:
>>
>> On Thu, 04 Sep 2025 11:08:57 -0600, Caleb Sander Mateos wrote:
>>> As far as I can tell, setting IORING_SETUP_SINGLE_ISSUER when creating
>>> an io_uring doesn't actually enable any additional optimizations (aside
>>> from being a requirement for IORING_SETUP_DEFER_TASKRUN). This series
>>> leverages IORING_SETUP_SINGLE_ISSUER's guarantee that only one task
>>> submits SQEs to skip taking the uring_lock mutex in the submission and
>>> task work paths.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/5] io_uring: don't include filetable.h in io_uring.h
>>        commit: 5d4c52bfa8cdc1dc1ff701246e662be3f43a3fe1
>> [2/5] io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
>>        commit: 2f076a453f75de691a081c89bce31b530153d53b
>> [3/5] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
>>        commit: 6f5a203998fcf43df1d43f60657d264d1918cdcd
>> [4/5] io_uring: factor out uring_lock helpers
>>        commit: 7940a4f3394a6af801af3f2bcd1d491a71a7631d
>> [5/5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
>>        commit: 4cc292a0faf1f0755935aebc9b288ce578d0ced2
> 
> FWIW, from a glance that should be quite broken, there is a bunch of
> bits protected from parallel use by the lock. I described this
> optimisation few years back around when first introduced SINGLE_ISSUER
> and the DEFER_TASKRUN locking model, but to this day think it's not
> worth it as it'll be a major pain for any future changes. It would've
> been more feasible if links wasn't a thing. Though, none of it is
> my problem anymore, and I'm not insisting.

Hmm yes, was actually pondering this last night as well and was going
to take a closer look today as I have a flight coming up. I'll leave
them in there for now just to see if syzbot finds anything, and take
that closer look and see if it's salvageable for now or if we just need
a new revised take on this.

-- 
Jens Axboe

