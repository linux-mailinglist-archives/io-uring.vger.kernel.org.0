Return-Path: <io-uring+bounces-11817-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E2DB0D3B519
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 19:02:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1C43630399AB
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 18:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE07332FA2F;
	Mon, 19 Jan 2026 18:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rlUA4eoc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6621B32FA30
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 18:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768845752; cv=none; b=nosXQrV6JiAiZ2uxKg42b9pUmTtM+45QkAnUgZ4qzpWaemyQtfI/ULg8+cLUR322Xpq22o5l7ymo7rThtci2z+abN2bz3POczKzjRDz6csMOyqc1v9KrOudQUuQtwxPdlPXHsmbplE1zQP65gefZ1z06bNr2BDDGEDevsh/66bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768845752; c=relaxed/simple;
	bh=LiGCiLDf/RlbsDulcMW6C8nXQD1+AZWvpPFGNAgVy2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GaxLtoBSCQiAFDsXKBb/xaLuUnYNmkzxlpq2QTF0QFKk96nDzMIJEEarKBEraj+Cs1DmhhlQx9WIO+3L6XShEHBgT+Yp2/3CVX4srWwMw3ZEA5+I7BFQv2SqtqLUfdE8WexdpMxQ/Kdg6MI+DNTSEmyfwVI8WqAKcLBnyWxF8MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rlUA4eoc; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-45c8984fac8so1359856b6e.3
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 10:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768845749; x=1769450549; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vKbONOhcEoJfGcWBiD/iLPrJd9tam6EVdsnHhM0fcxg=;
        b=rlUA4eoc53GEfv1puhHAnoWSt72SofK+rwzBKX+/ZEwO4R7lHuS0KdILwI9DrItRZx
         YI7xUxyHSgfmr1qphRAlF9AXnt4HNhmL9eSj6fmhVVz2rgIU7nVckhV0/Bh8L8/WVZgR
         Qr6udT5DQhURMNl7awjGyqt/94YXfD3BgLvj5cgL2jtxYXjOmj8ju/d9PpBSh7KaxW+G
         Y3wo/OT5Cto0EgRGgpA8hnyKZgRGDHTXIcktIjbrArrpKbhHMeCTASuJFOkvqDhR5g5F
         uC/yFubMDM/9THppV/3e6eYjDlmYOwYj/vJCGItLji28QoU8c5VMGFMRxcVGg4imhvuW
         jQtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768845749; x=1769450549;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vKbONOhcEoJfGcWBiD/iLPrJd9tam6EVdsnHhM0fcxg=;
        b=Qi7YJ1iQAlkJSwlT5/EPwoDg5NxpZM/+mOjtN5AJ48u3Mkzg0dtXb5lz24QtxlZh1O
         DT58c7eOXDX0s5X33Lgv3VjkJlij5T2d/FXnx3NBsye7YfSN1nHg7ws8f/Q+5pqyt3f7
         In1EzLiUoHi8i+C7veBJwrUoktZ9P+jClN4gQCI3LiGa1A5p4gkerLIeB3wVLLYGsKhn
         79PLZ8y5DUbXzSIuBY104nvNVXefFtAvp+paV/eMsPDW+jiaZZkWDBpcf0w5yaf9Wmsl
         TG7AAFZQwlPccJGhHkAMRoGtGm3ZBQZqXs/8jtMrR6qIO9Ugy5lNgk7yOubY4iH3omfE
         QVcA==
X-Gm-Message-State: AOJu0YxzhRpevrdyjqtLWsXqxq2/1OBASIgIB6tb3Y2WjeShL+3Z5WeC
	mKrtgINxk8BUoNTCsr9Av1j+1ejG5St1cmSu8cSypYNSetMhu7Smy9j4MNzFr2nKv9o=
X-Gm-Gg: AY/fxX5LY1fM5csQ34ocd1N/O3zL8IzBcHT1EhL+5bop0NIUxrT7qzm2xqG+0JnFi4M
	mSG/J4d1lL5/ZuAFjbQbkyoOov4fGI43XLUGE6bBEn2NA++nUYlqEEbw7N/tEWqJLJFP6Q+kmHm
	wAM4MHCw46YfpMHaCkhcuHRDzC25vVzeklEFjAuFPd/ivHJIcj7totp/zv2TiwUJr5xh75BAbC8
	9M6SqegIX8avVRVVYbd5qlSElraNapDgkjcFCEP0lKTK0owrKVZBeIJldgRuHuTc8XgsX1urqfS
	E9py/eef7L3d/9e3a2AHA9Qb2on85jBZeuDybkmrFG74EWvCDx74dBMFGvBMkV5nvD2mtG/3foA
	RAjkUBBNDNSEDN49o0646rvRLEd8z0sawlvha0gwW1YhJbxe6UrEvc/I9HZfmpzyxhOzQ8vUlCH
	XHmfMjDodDc+bqvtm1RCHAa9YmiLXs7GDJPPrqQsJEZbJ1bOXu+wPFj/6lAZvLGV4sYzVzLw==
X-Received: by 2002:a05:6808:1207:b0:45c:8c9a:44eb with SMTP id 5614622812f47-45c9c14fd52mr4492017b6e.36.1768845749171;
        Mon, 19 Jan 2026 10:02:29 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2a5f02sm7034398a34.25.2026.01.19.10.02.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 10:02:28 -0800 (PST)
Message-ID: <f945a5e2-74e9-4d20-b777-788cab3d8db0@kernel.dk>
Date: Mon, 19 Jan 2026 11:02:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] io_uring: allow registration of per-task restrictions
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: io-uring@vger.kernel.org, brauner@kernel.org, Jann Horn
 <jannh@google.com>, Kees Cook <kees@kernel.org>
References: <20260118172328.1067592-1-axboe@kernel.dk>
 <20260118172328.1067592-7-axboe@kernel.dk>
 <2026-01-19-undead-spiral-scalpel-grandson-R0Uhz9@cyphar.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2026-01-19-undead-spiral-scalpel-grandson-R0Uhz9@cyphar.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/19/26 10:54 AM, Aleksa Sarai wrote:
> On 2026-01-18, Jens Axboe <axboe@kernel.dk> wrote:
>> Currently io_uring supports restricting operations on a per-ring basis.
>> To use those, the ring must be setup in a disabled state by setting
>> IORING_SETUP_R_DISABLED. Then restrictions can be set for the ring, and
>> the ring can then be enabled.
>>
>> This commit adds support for IORING_REGISTER_RESTRICTIONS with ring_fd
>> == -1, like the other "blind" register opcodes which work on the task
>> rather than a specific ring. This allows registration of the same kind
>> of restrictions as can been done on a specific ring, but with the task
>> itself. Once done, any ring created will inherit these restrictions.
>>
>> If a restriction filter is registered with a task, then it's inherited
>> on fork for its children. Children may only further restrict operations,
>> not extend them.
>>
>> Inheriting restrictions include both the classic
>> IORING_REGISTER_RESTRICTIONS based restrictions, as well as the BPF
>> filters that have been registered with the task via
>> IORING_REGISTER_BPF_FILTER.
> 
> Adding Kees and Jann to Cc, since this is pretty much the "seccomp but
> for io_uring" stuff that has been discussed quite a few times. (Though I
> guess they'll find this thread from LWN soon enough.)

Thanks indeed - my plan was to distribute this wider for a v6 posting,
which should be coming shortly.

-- 
Jens Axboe


