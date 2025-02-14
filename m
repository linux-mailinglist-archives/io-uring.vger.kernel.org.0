Return-Path: <io-uring+bounces-6450-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E19F8A3684B
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 23:32:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8DED165251
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 22:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4728E1519B5;
	Fri, 14 Feb 2025 22:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Oi2u5M0u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1071993B2
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 22:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739572320; cv=none; b=UWfQOczgJfxNADdceQlNoIQlgDnrjN5vPiWAX7splah7FpnFT+04OEyRFmB3hj/H+exMwQ/vSos1OI8HZ6d6yT542LYWuz0i2PPuuhacK1f9ozgUi87DxFgfgb+hWN2pJEFrMXIIqVxiTL69iyKyWkImEtwVXOZF500I5skPMQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739572320; c=relaxed/simple;
	bh=c1h2hRgJS3kjd+SnqnXwc1u4byG/djiZjt5dv1afl4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dFiMHM0VG5LTHNRFpyjVXxhaVw/C4wmEHO2F3Hf6PpFGN5VzSJAOXLDHyy9TXJAAPlh1sb6HYS7V+YcNsEwIIgdONuLvzndUQtKS0IjbE/K//8/+C2qnuCPSAPQvckJ1PbPuledAIyJ5Ge2jAEuPUUPDm1GDtc8x9CG/4wUYdxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Oi2u5M0u; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-852050432a8so65221839f.1
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 14:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739572316; x=1740177116; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AV4CFwjgCRqBaz6Hw40zOzOJDxxfpO+EDYk/iOnh6Qs=;
        b=Oi2u5M0u2t2evWT5BqCiyGRssDv+j52Pvpyc2frdVCYPpdQhc20BW2twJ/ObJrdDtf
         7S2DhCfR2/S7F1tU3ohY68FSMsR6JzY06tenwFLPIn56RybAEPXfMJdNpM903eAOV4Yx
         qvVxhRZrTyXNUctBOBWPQ/YfJ6jgaMBJMLICBh25/FckZh4pWoF3M+konMJAUMJ8f0y0
         FhmlENr7tiDzAT6lQcG3Q9bKSgwbMnFQvOLPqPvLeOirdlhp7zyVugG6YkmKbp8WMTml
         0neQG6Cgq52GJf0d9fb8fCr67dDWKLr9+CAwmmJxJAu6cDn5qWUf1czLlXRUya1mmGG+
         Hw6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739572316; x=1740177116;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AV4CFwjgCRqBaz6Hw40zOzOJDxxfpO+EDYk/iOnh6Qs=;
        b=XoCHm/BuHnaLVJo5YZ52eu3MK99K50OpE6Xz45DeHmODaduqN6VjFOY8JSgwYbcn6D
         NHG5pTXKoJ17Lg3n4IkIUW17g2YBQDcv2tSOPEVrhzpK8ZlUDFTY+Du+foQr+QfeIWpW
         IhNfcIYRVBxsp8qoOCYCl/3M1oHKMuxZNl/Z+Uz6q56vpqfcaREzbWWm5H5YLq6P6LUu
         Ms2tcV39AEGYKXaeWfmUbhaT6Dzhk111l/yZsgvOj1t/9b1wJEiVlx7mt0sW9+PyzKPN
         wNcQgceo6VJYYNhanFwU+3td3g/nPEzM4XdZ5CDb2JBxRdP8ErOb+1mylq9mfAc8/Uo0
         JJ6Q==
X-Gm-Message-State: AOJu0YyEADoe41JacU7WfuQOIRrZj0nDmmCbh0tC4C+KYuziA4/OI7Nj
	8jgwB28uvgy+rn6evysXERHRNvDzK8wgOpfzVKaIGq1n9Ssuabc3Y7cilTFGG5U=
X-Gm-Gg: ASbGncuO5dUNJmWdVMeOO7px0zUKTraW7mcVDtcsJqnfbaHQp8+LUqRhkoblbGCdHR5
	sW5IIiGnnlg6g7wSCt4Pn8L4IXYKHFgQpo1EiBuhTwD2joQNKjNQgQhr/AUSGsls/ZazbaiSh1v
	fmSfOol+CRTn7QEZ4f9quJ6QGqNigSRt+0EL9JjhctOrjiw7N5xnFDaDkoACsD1lKZU3qAhkI3u
	gAs1KmU2ZiLSoA8u29UC9samULQK0mIa8LxSPD5kKmy7S+zFbnDq5sK3VzxnZbkc3BVcLXmLvVW
	HExbRvvgYUVV
X-Google-Smtp-Source: AGHT+IGLkMb5A0ZDgY66/GPXKKbGf8UQH990VZHkQjHV1Mowz/xFleeizEtGVdBciGOAwdsBnF5a7Q==
X-Received: by 2002:a05:6602:6413:b0:84a:51e2:9fa5 with SMTP id ca18e2360f4ac-8557ac70ecemr68869739f.3.1739572315817;
        Fri, 14 Feb 2025 14:31:55 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85566e621cesm85661239f.22.2025.02.14.14.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 14:31:54 -0800 (PST)
Message-ID: <ea9a9431-8e8f-48c0-82b9-8b1abd44cc0f@kernel.dk>
Date: Fri, 14 Feb 2025 15:31:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io-wq: backoff when retrying worker creation
To: Uday Shankar <ushankar@purestorage.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20250208-wq_retry-v2-1-4f6f5041d303@purestorage.com>
 <Z6+sXQrSYRyGEScf@dev-ushankar.dev.purestorage.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Z6+sXQrSYRyGEScf@dev-ushankar.dev.purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/14/25 1:49 PM, Uday Shankar wrote:
> ping

I'll get it queued up. I do think for a better fix, we could rely on
task_work on the actual task in question. Because that will be run once
it exits to userspace, which will deliver any pending signals as well.
That should be a better gating mechanism for the retry. But that will
most likely become more involved, so I think doing something like this
first is fine.

-- 
Jens Axboe

