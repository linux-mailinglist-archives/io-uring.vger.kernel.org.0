Return-Path: <io-uring+bounces-8487-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D639AAE89A5
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 18:23:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D38B7A4036
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 16:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97D72D23BA;
	Wed, 25 Jun 2025 16:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Szd/YdVJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1631C2BDC3F
	for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 16:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750868612; cv=none; b=CJpc94beWTHpfAWNyyqBIxM12dq4rWu5C5TgQVfYAIiPmi/CTXFodt1g3vc4mDRTvXYmTUlhvejyOCwB9GO6CYq58erYEtQwp5Qh50eW1XlzSdj2o2sl8G4+gMZ69zv0ZYzrbfbUwHdqN7JAs2rTlQm2c/BcaoYceWl3z5T09HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750868612; c=relaxed/simple;
	bh=F8KUMtIX1wnFGduZrWuPhcB8OsUOJ9mv4ZiSYAQVJms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RasuhEBoDA7xQkoupPAGMbYXSLeVWa4t7xnukcQ5VTSyF3s+Bl8D51ltAbfLodfQEA1YlXJjwSaWOokQ4yBjlwKOf/8QtgrmCOQO/Zt8nz88TU2XMTyAPm1jQ16bbAmtTYfmXmBfaEvIm/qA6ldzJ44tlF8uzPty2Hmi+EaDBmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Szd/YdVJ; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-748d982e92cso117523b3a.1
        for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 09:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750868610; x=1751473410; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=243ghOWDW8QKmlk6MHjN3D/0bW68lyTiXoCAzItZvXY=;
        b=Szd/YdVJO+rsPkFCVvH9RJA0S6dP219Q2Mk3g35n1gfvQFBSgLZudu0Yhj+rB1iLy8
         PxKt6BHa4snjxUsa90FtYb+2PifU1IQ/FjUNS7j6rHI/vwCK8WmLdfmGe3N2smo/IsLf
         3qFmijx5hAFIVDxcV3p0TbBQVvgeQrmgKHNooC0RwLX2inuStPF79jBAIp8zPfWDXJ+e
         LvEAocvwP9BpuutgOCilZrxxs0k1sV0OLnE4cPCWO/B8tul8ysfBYiK5v//vcp4tcXa4
         Kx1SeVeZa0KVWj0uC4W21f2a7oxrd4HQb6mdvOCuSPz0MA6EvEx2t7hALVTk9VuMFDMk
         I8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750868610; x=1751473410;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=243ghOWDW8QKmlk6MHjN3D/0bW68lyTiXoCAzItZvXY=;
        b=ZGedSFpJWjPn6S+DQTvgA1Bhi5qen9tZTJFtpLV0QUbv7BjKbgJGeAl5y4lWmX5Pud
         V+qfkA3YUKHRC2rqOaz4gGDyo96lcTqd9eiiw774XY62xRXh7XbOViAnpFXK9IDXXcWE
         eWVzf7seJROjiZKqOk/Y2rOsMY2k12hjQVqkyipDf/cLAxiAFh5QPf15leiumpr0c3W4
         PeuqXtjrgbLC1fHullVWmUqJmYun09lnXkPnPwyP9XjRtZp09pLGZn6ByGZ+pwySjUYE
         6HZrRskbxlDU5+BkYBhUS4RXUxOMHSmI4eKxs03inz4fBqZpYlAeMoibwTfpkssFoXWm
         99eQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjtXhBzbUn82EyCmPOwdn9XLGQFmqj2ICM8pwusmvIzVLk7cEVzyr1PSDUkd8nvFw+/9YXNi9e8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyAU9FpxH7SWfb1SDgYUEJ+bed14sQUb/RukQfZtF+dccmuW9G9
	iv5A1kPyLYBHUb0/EFcXSm6TGiaYpjQAIahV0IYPZIiGVAU6ph87EMmHXAXxrkjZPb/fGSt/X+b
	ZblJT
X-Gm-Gg: ASbGncs6jQMaZWHTknBsPTZVE2/gcd8z6aCPDNNeBRy8uwtDPxYdjl7MB9IV4+7Bg5J
	tS3e26o0B/c1pEGd13VRYK26iz98aHeSBBLHvpOBJ+yG4B+ZTxh9KK4FY/WohOGADxDLQSJfxyH
	v1ApSzhW/96M4Rzca/AhUcnthp4ugMHEKjA6PiZ6unDwo3Oumrdie6I0R4ALDrfdKEWFRvel8tx
	e6L9/FgMKNyH8VBgUOBpW+JhCyhVz8laGQ0kAI5+8PwdhkKepnl09gZyZfCvF0uc7VNOJx8tkQE
	QiJS8hB24MC2gVz1OiK9jcOdKuaNx5l56L/xIm0kLC8rcEZfovlMyCOpQw==
X-Google-Smtp-Source: AGHT+IEWirD92xOfaX5dKFE9Gy5xV94S8z/6fVeuyftt2KEz3xnXFXkk2TQevRl4ng7MclYwxeEutA==
X-Received: by 2002:a05:6a00:1782:b0:748:e1e4:71ec with SMTP id d2e1a72fcca58-74ad44b03bfmr6508044b3a.12.1750868610306;
        Wed, 25 Jun 2025 09:23:30 -0700 (PDT)
Received: from [172.20.0.228] ([12.48.65.201])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749b5e08d1csm4871339b3a.13.2025.06.25.09.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 09:23:29 -0700 (PDT)
Message-ID: <80e637d3-482d-4f3a-9a86-948d3837b24d@kernel.dk>
Date: Wed, 25 Jun 2025 10:23:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] stacktrace: do not trace user stack for user_worker tasks
To: Steven Rostedt <rostedt@goodmis.org>, Jiazi Li <jqqlijiazi@gmail.com>
Cc: linux-kernel@vger.kernel.org, "peixuan.qiu" <peixuan.qiu@transsion.com>,
 io-uring@vger.kernel.org
References: <20250623115914.12076-1-jqqlijiazi@gmail.com>
 <20250624130744.602c5b5f@batman.local.home>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250624130744.602c5b5f@batman.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/24/25 11:07 AM, Steven Rostedt wrote:
> On Mon, 23 Jun 2025 19:59:11 +0800
> Jiazi Li <jqqlijiazi@gmail.com> wrote:
> 
>> Tasks with PF_USER_WORKER flag also only run in kernel space,
>> so do not trace user stack for these tasks.
> 
> What exactly is the difference between PF_KTHREAD and PF_USER_WORKER?

One is a kernel thread (eg no mm, etc), the other is basically a user
thread. None of them exit to userspace, that's basically the only
thing they have in common.

> Has all the locations that test for PF_KTHREAD been audited to make
> sure that PF_USER_WORKER isn't also needed?

I did when adding it, to the best of my knowledge. But there certainly
could still be gaps. Sometimes not easy to see why code checks for
PF_KTHREAD in the first place.

> I'm working on other code that needs to differentiate between user
> tasks and kernel tasks, and having to have multiple flags to test is
> becoming quite a burden.

None of them are user tasks, but PF_USER_WORKER does look like a
user thread and acts like one, except it wasn't created by eg
pthread_create() and it never returns to userspace. When it's done,
it's simply reaped.

-- 
Jens Axboe

