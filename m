Return-Path: <io-uring+bounces-4645-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 02FFD9C7048
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 14:08:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85FD61F28488
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 13:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61101DF726;
	Wed, 13 Nov 2024 13:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DXIkyGX4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB68A1DF73B
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 13:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731503324; cv=none; b=UrvWeYrz1hMJKZIvHx9q/HlMfLh/bxeaxsVwKgreYuNvrMFAz81xMVsc3+ms5AxzEMjopuzEKdv2PuGUkQQiSDeOUgKyAF6TDN1rg6RZvu7rj0dCsmivdBF5+jxCTbXjBoNHQ+ZvkB3vmqiUx0m7/VmlognAvH9UyBjAqWHmgzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731503324; c=relaxed/simple;
	bh=eEm37dGxFQmEVA0jZgHcd4uRcHpzfGppU6DvQSFhnZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bu6Phde1/cJe1L0E0qcLmUCTfz3G4qhQAEeAhKi8BpX3Pc5IU+OzEI8ortm1H6+pWixgef2NSvhe6qLfztTrNyMW29qg/iTVlWsnQv/vb8Qld3RLmFJDQ8n8GPhnMfEzhhNjP0Ep3JVaxl4KxTMN6WqRKn27kBMjHjNc+jV4zf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DXIkyGX4; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aa15ede48e0so340373566b.0
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 05:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731503321; x=1732108121; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/u3iHHLefJtMOg1uv9NHYU9JPzMYARU84ayOsE+gsrw=;
        b=DXIkyGX4bDnbrz8BLXuT67yeu94a+aTWSjWPKqADeuoVDIE7sJr8M4ZDAip/IMKOh6
         NuoCPfBP8gCCp3Jv26qBvOAogWpO4kRDHUWJyphE2kKtnkovGG41P2A/dDDUdrgt5SzA
         1JNK1KSnVKn8uBD0Fq5MtvNRWsPPMjt3ylvR6DTIFyY8qcH+bkwWSVS1/f9rsD3dc2Sr
         +5t2Wd5P90wJIhT3R+hjhMdrwWCsh/1EVjJHsXSHUWURE5idRaKKIBAafcWRSgdYF5E5
         3RO9jSAIHdbkC/R5XH/ga0yRKi5W8PVGLfkibsBNJgHKNKRNALWwW80/kcH/uCwHbgAe
         MC5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731503321; x=1732108121;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/u3iHHLefJtMOg1uv9NHYU9JPzMYARU84ayOsE+gsrw=;
        b=iu6Xwei4R4RwS4czte+8XVp82s4+biqkIvWM2eIpjI1pXKmX8v4ZmC3zBIj2UEVGeB
         lVBjQqhbEuaJsvQMWTHfEH/vvhYnSGz/a1xNCsmxWlRbGVNZH0GaC8hVuAk9EaLn98v1
         8UB/ngPGZxzgn/3QLfYb3Mxvs5k14cVcem/EonpGV5F625iVlJB0tYbB4NP7bIFWZfDq
         AiCZSyo9Tm1muBXLDnod1x8LGF8tYUv5JEeitaqP4Hdnl/6BO+sMGXrxrspuKjds6ZxY
         X6WANd8IW9v2k3mE5hYCk0Z0r91iwTAyfjs/V9p6SIr7dXa93Ph/yizkGaPZMgwXKEts
         0kSg==
X-Gm-Message-State: AOJu0YzHExvzofnCHJu26nzXycp1pHhzjuxV+KfREXwMl/MJpoFOHVtj
	fHn2pW2qNcWP8rhgiM7Ito355IWAs9Z6YV15f4JOU2r4qVueL7laoNL2KQ==
X-Google-Smtp-Source: AGHT+IFH9nt/kCO0SCqQlpK/f+1MrFlDjqL2zZCcTwpYvGjyRRvcZ4QjQWouogD2pQ7QvZv6/2+ZFg==
X-Received: by 2002:a17:907:31c2:b0:a99:fb56:39cc with SMTP id a640c23a62f3a-aa1f810644amr262529566b.38.1731503321021;
        Wed, 13 Nov 2024 05:08:41 -0800 (PST)
Received: from [192.168.42.17] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0e2f45fsm861780866b.204.2024.11.13.05.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 05:08:40 -0800 (PST)
Message-ID: <780be631-d4e8-4989-9007-4146be55767e@gmail.com>
Date: Wed, 13 Nov 2024 13:09:30 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/3] Add BPF for io_uring
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org
References: <cover.1731285516.git.asml.silence@gmail.com>
 <ZzRfrbrAvmbcuOUi@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZzRfrbrAvmbcuOUi@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/24 08:13, Ming Lei wrote:
> On Mon, Nov 11, 2024 at 01:50:43AM +0000, Pavel Begunkov wrote:
>> WARNING: it's an early prototype and could likely be broken and unsafe
>> to run. Also, most probably it doesn't do the right thing from the
>> modern BPF perspective, but that's fine as I want to get some numbers
>> first and only then consult with BPF folks and brush it up.
>>
>> A comeback of the io_uring BPF proposal put on top new infrastructure.
>> Instead executing BPF as a new request type, it's now run in the io_uring
>> waiting loop. The program is called to react every time we get a new
>> event like a queued task_work or an interrupt. Patch 3 adds some helpers
>> the BPF program can use to interact with io_uring like submitting new
>> requests and looking at CQEs. It also controls when to return control
>> back to user space by returning one of IOU_BPF_RET_{OK,STOP}, and sets
>> the task_work batching size, i.e. how many CQEs to wait for it be run
>> again, via a kfunc helper. We need to be able to sleep to submit
>> requests, hence only sleepable BPF is allowed.
> 
> I guess this way may break the existed interface of io_uring_enter(),
> or at least one flag should be added to tell kernel that the wait behavior
> will be overrided by bpf prog.

It doesn't change anything if there is no BPF registered, a user
who adds BPF should expect the change of behaviour dictated by
its own BPF program. Unlike some other BPF hooks it should be
installed by the ring user and not from outside.

> Also can you share how these perfect parameters may be calculated
> by bpf prog?

In terms of knowledge it should be on par with normal user space,
so it's not about how to calculate a certain parameter but rather
how to pass it to the kernel and whether we want to carve the path
through the io_uring_enter syscall for that. With kfuncs it's easier
to keep it out of the generic path, and they're even more lax on
removals.

  And why isn't io_uring kernel code capable of doing that?

Take a look at the min_wait feature, it passes two timeout values to
io_uring_enter, which wouldn't be needed if same is implement in BPF
(with additional helpers). But what if you want to go a step further,
and lets say have "if the first timeout expired without any new CQEs
wire retry with the doubled waiting time"? You either do it less
efficiently or further extend the API.

>> BPF can help to create arbitrary relations between requests from
>> within the kernel
> 
> Can you explain it in details about the `arbitrary relations`?

For example, we could've implemented IOSQE_IO_LINK and spared ourselves
from a lot of misery, unfortunately that's paste tense. No code for
assembling links, no extra worries about CQE ordering, no complications
around cancellations, no problems with when we bind files and buffers
(prep vs issue), no hacky state machine for DRAIN+LINK, no trobules for
interpreting request results as errors or not with the subsequent
decision of breaking links (see IOSQE_IO_HARDLINK, min_ret/MSG_WAITALL
handling in net.c, IORING_TIMEOUT_ETIME_SUCCESS, etc.). Simpler kernel
code, easier to maintain, less bugs, and would even work faster.

By arbitrary relations you can think of a directed acyclic graph setting
execution ordering bw requests. With error handling questions I don't
believe a hard coded kernel version would ever be viable.

>> and later help with tuning the wait loop batching.
>> E.g. with minor extensions we can implement batch wait timeouts.
>> We can also use it to let the user to safely access internal resources
>> and maybe even do a more elaborate request setup than SQE allows it.
>>
>> The benchmark is primitive, the non-BPF baseline issues a 2 nop request
>> link at a time and waits for them to complete. The BPF version runs
>> them (2 * N requests) one by one. Numbers with mitigations on:
>>
>> # nice -n -20 taskset -c 0 ./minimal 0 50000000
>> type 2-LINK, requests to run 50000000
>> sec 10, total (ms) 10314
>> # nice -n -20 taskset -c 0 ./minimal 1 50000000
>> type BPF, requests to run 50000000
>> sec 6, total (ms) 6808
>>
>> It needs to be better tested, especially with asynchronous requests
>> like reads and other hardware. It can also be further optimised. E.g.
>> we can avoid extra locking by taking it once for BPF/task_work_run.
>>
>> The test (see examples-bpf/minimal[.bpf].c)
>> https://github.com/isilence/liburing.git io_uring-bpf
>> https://github.com/isilence/liburing/tree/io_uring-bpf
> 
> Looks you pull bpftool & libbpf code into the example, and just
> wondering why not link the example with libbpf directly?

It needs liburing and is more useful down the road as a liburing
example. I'll clean up the mess into submodules and separate commits.
Eventually it'd to be turned into tests with system deps, but that
wouldn't be convenient for now.

-- 
Pavel Begunkov

