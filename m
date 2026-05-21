Return-Path: <io-uring+bounces-13477-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id II/2LPc7D2rQIAYAu9opvQ
	(envelope-from <io-uring+bounces-13477-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 19:08:07 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 540135A9E4F
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 19:08:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8B8813057B62
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2026 16:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD393C584E;
	Thu, 21 May 2026 16:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="OeboZRvV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAB839D3FB
	for <io-uring@vger.kernel.org>; Thu, 21 May 2026 16:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779382736; cv=none; b=Pro6j6qY7mfdu8xPjZ4HxaOUd3ymwch0618hgAYQp0JQWpAlPtP9hFHS2S2LjYbw/mkJyscNNfsUyXC3O9RdH7ZUW8uW8eVxH3J0vF+yF4YKZtmeERtTWfm35Eq0cxwlE9JWtLSxH2s2fSP+ItngjdEt7nKv72wZG595VuPyUfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779382736; c=relaxed/simple;
	bh=jVcghgvQCu6U9KLKREueXWcHmWVUiKzo7dPbpys4rwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BFbiOAZBrUlmF2+Shq0akC1JjlTOzD8SsIvyjqAkrR6gRCFon/07s8KrT/DUV/R3DCcRtztBifMMcZUfZ/NRbGK4v7V7tmKMH1n/5m1yPI6cf0woPTyaSQCeq/pNn6FSsP9DjtGLYYqrWnR7u0higRRLoMT8z/BwEBRA5ksuIsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=OeboZRvV; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6969c864c89so3570744eaf.2
        for <io-uring@vger.kernel.org>; Thu, 21 May 2026 09:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779382733; x=1779987533; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qhe1MwS0FeB5+AMfjRX2drsY7KBcvPNU9VqmrvyHWOA=;
        b=OeboZRvVVcxizKELIWS6wRF9T1T3Vmfsfpfp0f/37JYPdZybmQdVatHNEIqd8kMDj/
         BRFFi3hghjX/NYhghZboZBtM6JDvdoNXedyEJ5v16Li5Xaz5WwfVXLosan+YUkVz1pC4
         m3QTnwuK6smDbhpRBXc1BPMEM7zyNhDwq8CpNrfV8YE7Pj2WYk1g+xxbd7DxtAA8Hdd/
         Xv68sTi8DSvcxpuEkR+QaD6Qkjx5wfdI5H4ZRNvJAiiYydlGBixHYalpKR+ADuYWUIUL
         QyMsw7T2cMzXq/10Wf04xXoDcsjGqSg+s5N39A0o7nHuCkcJay+u12c4SzB7lfzuSHVQ
         hlkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779382733; x=1779987533;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qhe1MwS0FeB5+AMfjRX2drsY7KBcvPNU9VqmrvyHWOA=;
        b=TAl6LmeS6Dp6DzwAcI+phcLzm4huG+Ogye+4B/WrOFlbzgLR6Y90R/0vEjFl1nOFdP
         z164OWnGliAO5A7+sIeAjU3waVf4wXEHgD5fUxcXWFWMBnO9WGxx+/NSRTluBpwXGeAo
         mi9QokVej0q2FtNcdfFFsRyZB4uz6QGmERjFNyNCtvGjMdUb1oPMyHBGPhSVX6GCpA1d
         5FgC/0pNPpWAjUIzYlFPLYeVtrC/pDvMWJFm9/gPNZRhV4C7FxKFDnUK6cJ58Weh/DgC
         gN9GqfO1vF/EZ5X4FIwG+wPS5+wG56TFn9yfFrxg0KWMw9+fnuo8QV7r6Lu7wvmIt9k5
         In+A==
X-Forwarded-Encrypted: i=1; AFNElJ9lNm/MH8uQo8L/cGdFvABfmA76Cltc4pq+J0ffRaGHQzPCaaHWkvM/c6NG0JgyOScdiHy+dpQq8w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyXiofVW6tmrxz+L1B0heOJoAZ2Dwo8LTNqlnW+0LiOu9QvCZ0Q
	LSGOf48JUyfOYn6uO66DJ9IYt7TFXWnNPQADn7DrGzldQa5/6poI61mfd7x57OZaa4A=
X-Gm-Gg: Acq92OF6AIuxcmCdOjBuoEmrtIOdX7bqD14aJxhmnzgHhrnfMw2ErHxNzq4Y0F4+1Z+
	B1RuDtt0cC2j7D0h9GDSh6M9OmMfzGHzAKo+NKutcuWTZIJO4XFd3lG+DpVT6KqzX6rmPyjja1b
	Qnq+EHkbggxlNmjPlyX8zVLx1359MRZ9qrP0HlGVUE7MuVZf2yv+GobgVuB6hRIXGLIfFyk4ly6
	ACvIXQxplKuhkT6vRzbChDCr1k+DVYGRmqD1mj7zpxVMKqzQEt2l1Mzvvzhol+BJNjfkfawL8U6
	vk0ypeH8pE2SrSvn0V2R+uBtZHuirOj5ZufiYwZVuUA7qHhSaRGCJKm99pIs5S/5+Ts0n/Vofl4
	mz1jtv6HyJROXzPV+UQ4xnCEANL6qFbvoEuftaklnsA4quU+SE2ybIdazf/6wq9CUXSBnmV5/FB
	GPLESSYL4iMs+RqLTxuTXe0v3Ws6g9N1VdbDTX8D4MPkzxNmwWc0yV/abPk6CPc63xk+KDa7cAp
	C+6qY2HDIIHqgKDf8M=
X-Received: by 2002:a05:6820:f007:b0:688:c232:dac6 with SMTP id 006d021491bc7-69d6ee4fb91mr1954043eaf.19.1779382732678;
        Thu, 21 May 2026 09:58:52 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69d771c3801sm812925eaf.7.2026.05.21.09.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 09:58:51 -0700 (PDT)
Message-ID: <469287b6-201a-497d-ac67-03e1336dd81a@kernel.dk>
Date: Thu, 21 May 2026 10:58:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/io-wq: avoid repeated task_work scans during
 teardown
To: Fengnan Chang <changfengnan@bytedance.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org
References: <20260520031221.83210-1-changfengnan@bytedance.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260520031221.83210-1-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13477-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 540135A9E4F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/19/26 9:12 PM, Fengnan Chang wrote:
> We hit hard-lockup reports from iou-wrk threads stuck in
> task_work_cancel_match() during io-wq teardown in syzkaller test.
> The root cause is that teardown repeatedly rescans the submitter task's
> full task_work list under pi_lock, once per matched item.
> 
> Two spots are problematic:
> 
> 1) io_wq_cancel_tw_create() loops calling task_work_cancel_match() to
>    remove worker-creation callbacks one at a time. Each call re-walks
>    the entire list from scratch while holding pi_lock.
> 
> 2) io_worker_exit() unconditionally scans the submitter task_work list
>    for its own create_work, even when it never queued one. With many
>    workers exiting simultaneously against a large unrelated task_work
>    list, this adds up fast.
> 
> Fix (1) by adding task_work_cancel_match_all() that unlinks all matching
> callbacks in a single traversal, then iterating the returned list locally.
> Same try_cmpxchg() synchronisation as before, stops at the work_exited
> sentinel.
> 
> Fix (2) by skipping the cancel entirely unless create_state indicates a
> pending create_work. Since create_state is exclusively owned via
> test_and_set_bit_lock, at most one callback can be queued per worker, so
> the cancel is also simplified from a loop to a single call.
> 
> With this fix the reproducer (FIFO-open + MSG_RING SEND_FD stress) no
> longer triggers hard-lockup reports, and task_work_cancel_match samples
> drop to microseconds.

Looks good to me, nicer way to do this too.

-- 
Jens Axboe

