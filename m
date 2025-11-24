Return-Path: <io-uring+bounces-10758-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 759CCC8058F
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 13:05:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D2593AB5CD
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 12:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EC873016F5;
	Mon, 24 Nov 2025 11:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IXO6yPJV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7B430170A
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 11:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985440; cv=none; b=rLgGte0HP5+MQFF7rO0XrL9LQGQZsLyr2F4hulGdv/b3AUT2PNmLe0VH85XKPM5fkd0GN4ISaiZjJBFvS8gWzUG1xXFEeFP6g0CHuOEJh9QmAfcthvKc8vsqC4uknQcBJccAAMryS3dWfRQCBW+bN0Rvtzdjx+bunai1LG4fLDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985440; c=relaxed/simple;
	bh=e+v7CdcV1TaYkT5kdyH2QFzOE1VmsFJEbzHKYsR48Z8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eUE2rtMV4IANMYTMtBuqNlSK7YU3y1PjTXKt1z/htO+v6QvISJ1FeVHxpxhwQt0S+aRULCao+QhB9SIZsJA34CB+Ucy0rrn7yhqQfrD7+0vTfAytWaUwDtEi0XhJPO1TkXlYdq7y4HCJ5SBmexrQCIR92U/ZYuwppG9IwsZPsMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IXO6yPJV; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47798ded6fcso25716035e9.1
        for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 03:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763985436; x=1764590236; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+6K646kVMCKHQIyUwaCd8T41DsNbqTmzztejn5C3rxY=;
        b=IXO6yPJVpsPxV4vZSNb0AII2tisvZbojJPQCJ4s40bd0LxrN6vUBU9Jdqixuww+Vgg
         dsv4UYfmnXUGK/wWRC3es0/5L5nnS8P40qWfSUlPB99vfnKUUMQpGlx+7PPylLlbE/Yp
         gaikspbksbOW2vAGYZJZhjBvEVtp9LdiPQWj7tLfy42f0tkeO0K/RAnpmks0BnHD4cB6
         Q9t1Gk1/k3jSL7FkoInd/dGqhO1kfHgbLpCCcXKVyc+PMaz1o9eN+IFXC1QoosxBJKj1
         5kLABclDEYbLwXfAGfOs/lKX+WjJKHgZWgZNEEJgVSs12CWG6RWKjdRAFVVk1vpzFkH7
         3KbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763985436; x=1764590236;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+6K646kVMCKHQIyUwaCd8T41DsNbqTmzztejn5C3rxY=;
        b=ihViPQS6DGLMhQIfMOAKpiwnwQN/yaT5KN9LyXD2LZggs86FEAX5UWTCDxl3kuFMNW
         IGqzT3FwpK5sb7/FvPXyafup+Y3E5v4kWJUGPTma0R2+z0DEbjRBlcbAiQBb2artI+ds
         0cHX5FSfl8X9aXpp0kbWE2fbulkmTV2V60uQ7KxDvW01Ykcb+ZbGY4HuYWjiyqhGU/sF
         9hxlC+tt90JYMGh1wFTL0mjmd9bV5+Wea/E7A6uZ3WffozHLeJJy4nOjqCzLfAxN8sfb
         2XJAJ+iN2rb3BszayrsnBs86b+WvO6a9FX7djmLOsbhTltsE/hDyQalMvKFLAJHBVqsS
         ySwA==
X-Gm-Message-State: AOJu0YyGgtZnb8tXZx+/3Sp9WnPj8iQ7+JwldYFB7VKcl69oweQRfYYK
	cKdu99IAmjnDu/MeAoT/FZ4P//dwb/tcADnoAjT1qbm9ApCcr6CkXdy3
X-Gm-Gg: ASbGncsr2EVKES/6R7yirm/DmLePFGUcCA+NG2M6MKBdENl7BdbR3NZxI9wc0MLUwxL
	gAuc6+lTVfK2YTjU2VdVIBguvDQHNi7sVoB759ZBWktCQPnGw0zfVz96IEmNvb6U7CUxxgKDRFf
	tGpizpK3k65kEz3g5HVuwPRf1y4KFsmdio1gEDr5ECzu7czak1wBK7Nz4IcE4xJSCaRzEfwodFV
	uP0KMmHWwph4IzS6W4Genun2k2z4ddwRZ55DS/9ysLy/eg4I+zKFCCvLPkBltcnd0PS6SYdSnsp
	6ek1WbcihOjBh1gQb51qO860NxTI5TzVAvBs30TsBg9CNLQ9lrJ7iqWThDMdfj1hPtY75SRDY/+
	nnfQEzECzSQUMhMh1uOzJDd+Avg4lhMNkdxrHXcbDHybNU6vRXBufDFLaqq0aqk9dbYvs17J41C
	CC2EeGmgk95jllmbJBmMczpWFobIlW1TLLl0cGxsBNbCa/Jbrs81RJS38mnDtFo0boAwwes48e
X-Google-Smtp-Source: AGHT+IE0OSj8JqZ05GjF3Oefxk9wJ+p5QyMka9uBLVg7fNTS2Gs36AgHP69SB66QxOT2H4cSE1QuHA==
X-Received: by 2002:a05:600c:4f82:b0:477:952d:fc11 with SMTP id 5b1f17b1804b1-477c11175a9mr128273385e9.16.1763985435881;
        Mon, 24 Nov 2025 03:57:15 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf227ae2sm192385605e9.9.2025.11.24.03.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 03:57:15 -0800 (PST)
Message-ID: <f1db3be4-a4a7-4fd7-bd5c-0295a238b695@gmail.com>
Date: Mon, 24 Nov 2025 11:57:10 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/10] selftests/io_uring: add bpf io_uring selftests
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk,
 Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>
References: <cover.1763031077.git.asml.silence@gmail.com>
 <6143e4393c645c539fc34dc37eeb6d682ad073b9.1763031077.git.asml.silence@gmail.com>
 <aRcp5Gi41i-g64ov@fedora> <82fe6ace-2cfe-4351-b7b4-895e9c29cced@gmail.com>
 <aR5xxLu-3Ylrl2os@fedora> <1994a586-233a-44cd-813d-b95137c037f0@gmail.com>
 <CAFj5m9KfmOvSQoj0rin+2gk34OqD-Bb0qqbXowyqwj16oFAseg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAFj5m9KfmOvSQoj0rin+2gk34OqD-Bb0qqbXowyqwj16oFAseg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/22/25 00:19, Ming Lei wrote:
> On Sat, Nov 22, 2025 at 12:12 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>>>
>>> `thread_fn` is supposed to work concurrently from >1 pthreads:
>>>
>>> 1) io_uring_enter() is claimed as pthread safe
>>>
>>> 2) because of userspace lock protection, there is single code path for
>>> producing sqe for SQ at same time, and single code path for consuming sqe
>>> from io_uring_enter().
>>>
>>> With bpf controlled io_uring patches, sqe can be produced from io_uring_enter(),
>>> and cqe can be consumed in io_uring_enter() too, there will be race between
>>> bpf prog(producing sqe, or consuming cqe) and userspace lock-protected
>>> code block.
>>
>> BPF is attached by the same process/user that creates io_uring. The
>> guarantees are same as before, the user code (which includes BPF)
>> should protect from concurrent mutations.
>>
>> In this example, just extend the first critical section to
>> io_uring_enter(). Concurrent io_uring_enter() will be serialised
>> by a mutex anyway. But let me note, that sharing rings is not
>> a great pattern in either case.
> 
> If io_uring_enter() needs to be serialised, it becomes pthread-unsafe,

The BPF program needs to be synchronised _if_ it races. There are
different ways to sync, including from within the program, but not
racing in the first place is still the preferred option.

> that is why I mentioned this should be documented, because it is one
> very big difference introduced in bpf controlled ring.

That can definitely be mentioned as a guide to users, would be a
diligent thing to do, but my point is that it doesn't change the
contract. SQ/CQ are not protected, and it's the users obligation
to synchronise it. With this set it includes BPF programs the
user attaches.

-- 
Pavel Begunkov


