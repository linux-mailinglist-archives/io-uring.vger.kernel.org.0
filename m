Return-Path: <io-uring+bounces-5438-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7C979ECDE4
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 15:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80C881602ED
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 14:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057B1205E06;
	Wed, 11 Dec 2024 14:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knjcsei4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46296207A00
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 14:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733925690; cv=none; b=cb9WYeB+lB2h0PAE7EIZjEz+jG8UNzyuwwbaHar+NJV1mO4WJxWlNzHkyhcTD9xf1YOp1ukC5IdiRyXmnMJcxGovJYvxZSxCZehskRRKlCETw13nxEUNNW3pfJhAK7+4RZ/QYH3SQuOJKM9eFhcUDVdJbBtBZhSQllbTmlqIa4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733925690; c=relaxed/simple;
	bh=3sQPCsvhHFAL3oOHge6uvHTxkpjCdBCmVJOf+mIxFMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aP+Lmg9rxf4lVpG2kRQLqdQnBxRmqmpmv6I9VxwdKki9LaGyI6QlQeAn8Q5WiVpns8FdGvqhJRP00crT9fq9GLPV0iZpxghglkuYxmkOFrBjOwacMPfZ2CnWUuccUpaamozEXrV/LvgKI+vFJTvLdptWxoKrE1AdNLJftugLEGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=knjcsei4; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aa68d0b9e7bso604267366b.3
        for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 06:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733925686; x=1734530486; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Djm1Lud/o/i7MXZI6SQIsMn30J9xgzCYRDHYYqehBIA=;
        b=knjcsei4y1m9KL5CZhdoZAvPV4N+rrl7dJ4TabEvdRx458z9LHpBINZzFawzWFYaY6
         +DcWnuxPEH43rfc4oGjUMOL/p68Ic7sUgu/gWlfO7PNQ4ADiuufc1uCwEitv4/ErCPBA
         KqFS6tFLYWEELnS8o7no1TayJyPswmoZmhnh45B/qe/e3GZWJF514Xo6MG6et/5DPTR8
         B2fb6g4YZTiQ6rX3Hc/iTXj/SaqP3ME64EBJ6uk/yu8tcY6WJlFGvQppU/rPHApBYa/S
         KYE40VmTgoRxdggwLSlvrIXdr+eabjkNjyTfGqhZxKP0V2icBUZ3ruMNm8TUlqijS22d
         WyQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733925686; x=1734530486;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Djm1Lud/o/i7MXZI6SQIsMn30J9xgzCYRDHYYqehBIA=;
        b=jLQcjBYuD5KRqaZnYYGwSiFEUpWdevBI5/7yOWwjXsjqIYTgZaqj5tYDfsei9qI/Qt
         EpZb6+5iDCCGCV7GhbwpkA55ze8cvG/+vGCOQFuoASdT1rWtXFK8J5L1+LFdeTWtPHN3
         VwQkzqgq8ic8/D1OnYRMVqoOMIiYeStH0BF2NbEcaNNzFGnvK4OKqDyiUKbgLtt38mIJ
         z4MxdF6ZybSJ6yZjLLl/iOvNAWej+351nfvRcZr7xfMHuYICcGMDeozhp20qZTHql8Jm
         dqCbJnFOI/qe22NzvGUvQ4NMcJFl4zkr0+16tLXYj2xzF5xV5nA1sIyPRqg0x7k6xfuL
         tRLw==
X-Gm-Message-State: AOJu0YxLXITKb4RRnMGf9VevVmPA8PwqcVr6WLVurkALfKLKmVRO+I/p
	sFYc9gve3w7LxKgencfaDMrCkQ2/2cSo3bnHMjvEQFpSyNbVvTWT
X-Gm-Gg: ASbGnctjAQQ/hq6Ah9gTom909iY7n8yh9czmG3QgOq0k/Ttb0x+haUvqTEMoPXO8dEw
	nJJ/Hjceygym8o1m1MkSms8M1IDeqDif8hitITU8qijLIqpo70N7MoAQ/4d5m71rSezbojLVs/K
	P3zAh4mWWdBsX+IwB0aiMRT+sWzz+GQAGNy71gyuFz0vgkpmS716hEz4NXJjL2EIZFvUx0pdj3o
	JtUklSJmJsdWz/Y6s0RnXpXBUNPEPLIiC9qSSuHByjLqgB1iErzQm9b5yuYXgeVbA==
X-Google-Smtp-Source: AGHT+IGCJW9/3quOYu1RRbYB0SeyPE9K3cPZe4Yj3eT+9RL0p16sYwYQ8Tv+kC9r3pHA7m6RcHiiSQ==
X-Received: by 2002:a17:906:3289:b0:aa6:800a:1295 with SMTP id a640c23a62f3a-aa6b10d65f7mr239006466b.5.1733925685429;
        Wed, 11 Dec 2024 06:01:25 -0800 (PST)
Received: from [192.168.42.162] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa677c4970bsm563102166b.112.2024.12.11.06.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 06:01:25 -0800 (PST)
Message-ID: <fd219866-b0d3-418b-aee2-f9d1815bfde0@gmail.com>
Date: Wed, 11 Dec 2024 14:02:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/9] Launching processes with io_uring
To: Gabriel Krisman Bertazi <krisman@suse.de>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, josh@joshtriplett.org
References: <20241209234316.4132786-1-krisman@suse.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241209234316.4132786-1-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/24 23:43, Gabriel Krisman Bertazi wrote:
> During LPC 2022, Josh Triplett proposed io_uring_spawn as a mechanism to
> fork and exec new processes through io_uring [1].  The goal, according
> to him, was to have a very efficient mechanism to quickly execute tasks,
> eliminating the multiple roundtrips to userspace required to fork,
> perform multiple $PATH lookup and finally execve.  In addition, he
> mentioned this would allow for a more simple implementation of
> preparatory tasks, such as file redirection configuration, and handling
> of stuff like posix_spawn_file_actions_t.
> 
> This RFC revives his original patchset.  I fixed all the pending issues
> I found with task submission, including the issue blocking the work at
> the time, a kernel corruption after a few spawns, converted the execve
> command into execveat* variant, cleaned up the code and surely
> introduced a few bugs of my own along the way.  At this point, I made it
> an RFC because I have a few outstanding questions about the design, in
> particular whether the CLONE context would be better implemented as a
> special io-wq case to avoid the exposure of io_issue_sqe and
> duplication of the dispatching logic.
> 
> I'm also providing the liburing support in a separate patchset,
> including a testcase that exemplifies the $PATH lookup mechanism
> proposed by Josh.

Sorry to say but the series is rather concerning.

1) It creates a special path that tries to mimick the core
path, but not without a bunch of troubles and in quite a
special way.

2) There would be a special set of ops that can only be run
from that special path.

3) And I don't believe that path can ever be allowed to run
anything but these ops from (2) and maybe a very limited subset
of normal ops like nop requests but no read/write/send/etc. (?)

4) And it all requires links, which already a bad sign for
a bunch of reasons.

At this point it raises a question why it even needs io_uring
infra? I don't think it's really helping you. E.g. why not do it
as a list of operation in a custom format instead of links? That
can be run by a single io_uring request or can even be a normal
syscall.

struct clone_op ops = { { CLONE },
         { SET_CRED, cred_id }, ...,
         { EXEC, path }};

Makes me wonder about a different ways of handling. E.g. why should
it be run in the created task context (apart from final exec)? Can
requests be run as normal by the original task, each will take the
half created and not yet launched task as a parameter (in some form),
modify it, and the final exec would launch it?

-- 
Pavel Begunkov


