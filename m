Return-Path: <io-uring+bounces-11362-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B86CF4878
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 16:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E78A230CC031
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 15:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B23033A71B;
	Mon,  5 Jan 2026 15:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qeKnswjP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f66.google.com (mail-ot1-f66.google.com [209.85.210.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B80533A6F4
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 15:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767627937; cv=none; b=rGFv32VmV6EZfSyJk4soF6ABxAZETF8MHWOOIZsquTM93yIY78uyYgZQlaGAD0sU8nd7UmgaYMnQUNHmT28B3NUeHtDUZf3Y3s9YQ9hvZXxyh353pr4Qo71OpvCsn+gqMASNJEC6buH59xNZ18NvvuNYskRyFgjsb2VmAnt8h7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767627937; c=relaxed/simple;
	bh=kJvNFuRinYSiZfSueZ+GsbOTYncf4g5dkrr7Hekf9fg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:Cc:
	 In-Reply-To:Content-Type; b=tPbYM5Qq+XODDa//6grcYfkdIeGYpWe5EL4HM80s1jm9qhvbKc3ENjDFewWTcdeR2tGBdXD+g7ghsXTOt4dzUgwEQoirfrjmVoJVx+unnIHDxHrI5jaW+9bY7cpxMRxZAcUIzvBAQASZltRNdjRRoUtEPLkVH9o7OqDTu/liGoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qeKnswjP; arc=none smtp.client-ip=209.85.210.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f66.google.com with SMTP id 46e09a7af769-7c6d13986f8so43598a34.0
        for <io-uring@vger.kernel.org>; Mon, 05 Jan 2026 07:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767627932; x=1768232732; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XvlkxbXGFxXfGjfo1Rqw+tiKBUGv9C5vE0LWRd0pU5I=;
        b=qeKnswjP6l1HC0wnbguK8AVQS5+uuiqH+qxkJmyNiaH2ryKNp8q4YtSuLl8BPrWuar
         igvhV70mDvWWWWaTTAgJoEjNdVWuUEr2qOrhyf2TeiLQtU7bSuxSUoWHdhoZ0cSmxAoZ
         I6GBTHrMpoVxE/PrQ6XWbR/CQp/l1sUv+nBO5sULGgW16DDsBliU1z90QdJMNQD/zoEg
         GtKuhCAR43WyBJjGcsCKeDfC5p/je9jAeLyjEjVAijovQ06jmzOGKU9GeGmPH5DOCrC0
         Ycj+C8SjEclDTjDGQbs4igU4ubbdIpXp8gOJ4F/V88DV7/3Qd4OS/RWScNstunyiLr0+
         g1/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767627932; x=1768232732;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XvlkxbXGFxXfGjfo1Rqw+tiKBUGv9C5vE0LWRd0pU5I=;
        b=dvvyC5qfIFQLz3NDw3Eu2vmBnF2LK7LpCLhC7y+E15Mc7g0VjDrNl0kGHZEes+18nU
         n69wzkV1FBk/bjMZEKqNpg8hjkdK2IwRzzyWp69Gp1XgsUUBvcF7Z0UVF8qG0nYSOzg0
         7wO0mXmGjQKVYQPbbF2YuyN56m5SysOorPPMkDG8NiSyW3wJ3OGwx9OISRpe0K/zrvv9
         LjNNcCbDtmD7UNIJPJEUVtBOeHiXpDniVlzmbqnE4Ixht3FUUtewJUuXzagmsEI/AuPI
         HuMMHpWC2Yfcx+ARBggmz7zL5Tgz1sF8LMeX8Neh8HZ4x9JplXiIG5B85/d1QoWjdh9c
         kDiQ==
X-Gm-Message-State: AOJu0YxAvkLuU4ybZJ3XrTEwFzPnY6KdV9JTOZWBDHYBLMeQOn8TNa5C
	Bz9LplVWQRdsjxiwwYWrRTJbFpSeycktat3i09WhSBwdIEwC1YheZgUZjIjP4gbuscEfrl042rL
	fMr1LMUE=
X-Gm-Gg: AY/fxX4YT7wYTVJl+r98mD+10Tv63tXVJ9hKsH6YMy5RqfnWgbXaUT2ShZOYALbhVvr
	Tg24H7yDHbnMA9uVSinOM67afgTj7cipirVsxS0B7lDYdtqjm/aduiVc6EhTdZEMRh/w7sDrAgY
	Fk+VgexmRGrsHPyxY+qvjALw59rH0i+1mQ+UmkYm0nO8uRIoD+/W7M68c4wPZbJS2Mr8uuAtw2t
	6bdDqv+/tRY3YwQ2VZnuLhr7VYDEUfBvC7Oi4dy8Id7RrngluZgdLayirLgAFuPjeJ55DVOQgTw
	SNE2yGn4m0UkwVMqtL/OYuyzJ1OorVoHjhZLd9ifp7t4LVRxa1VDe4OlmYR7p2Goouc4xD8CSfF
	C1Q8cy7xd/jBgCIwRlVPNl3QFdEBVzD7MvqOnJiYbCeU1R60yaRD+2y341dBlY3fen1JX5llw1m
	Yzeq3yrTrW
X-Google-Smtp-Source: AGHT+IG7z7+jgpeTkjaT+LqWv6Xk0VKNd0xIV9iViG5RXaUMHcw5qcly3RU536cnBrj/N3N6wGgm5w==
X-Received: by 2002:a05:6830:6b08:b0:7ca:bf30:26b1 with SMTP id 46e09a7af769-7ce2bf3dd75mr4538523a34.8.1767627932310;
        Mon, 05 Jan 2026 07:45:32 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce45ffbfaesm67285a34.24.2026.01.05.07.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jan 2026 07:45:31 -0800 (PST)
Message-ID: <01086100-4629-4037-b084-a9534d315d9c@kernel.dk>
Date: Mon, 5 Jan 2026 08:45:30 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/io-wq: ensure workers are woken when io-wq
 context is exited
From: Jens Axboe <axboe@kernel.dk>
To: io-uring <io-uring@vger.kernel.org>
References: <79dbdfd9-636d-426c-8299-7becb588b19b@kernel.dk>
Content-Language: en-US
Cc: Max Kellermann <max.kellermann@ionos.com>
In-Reply-To: <79dbdfd9-636d-426c-8299-7becb588b19b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/5/26 7:45 AM, Jens Axboe wrote:
> When io_wq_exit_start() is called, the IO_WQ_BIT_EXIT bit is set to
> indicate to workers that the async context is going away. When that
> happens, any worker alive should be woken up. If that doesn't happen,
> then io-wq worker exit may take as long as WORKER_IDLE_TIMEOUT, which
> is set to 5 seconds by default.
> 
> Cc: stable@vger.kernel.org # v6.18+
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Fixes: 751eedc4b4b7 ("io_uring/io-wq: move worker lists to struct io_wq_acct")

-- 
Jens Axboe


