Return-Path: <io-uring+bounces-6452-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0CFA36888
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 23:42:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE207171248
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 22:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11241FC7E2;
	Fri, 14 Feb 2025 22:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UTnoCiz0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB181FC7EE
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 22:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739572833; cv=none; b=M25IaoR03/pw1SbtUq/+3xBDdV/YqG9wSPRmxxrGarGaDgVffOPzJMxskS1Snfaj+BhmaTmlUh8EsBL91XVhhtRag81xcSb7cYB39AcBmAPVFYhmo/2oV5FnlnApXpxl1kAcckdGn6g6Frz1SqrWZBQ2/KMtX43kpRrYiJf5r44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739572833; c=relaxed/simple;
	bh=+zwJL8W+W4B4VpXmzliet2uecKgQ/IHPH8wpUcKLAS8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bLS93Su3lSoajdYdV88Dd8/gDON5Bykscni3b2IKNvnKHrVAQVqV0hhVGuP+wzoNKPvg7rIVvVnDrBAembixJGh+fyJ43Ek3PYddLonPaG4P9VuCMxFxIM7wW5XBPjRVn3XNIdgnrfzJpuAHQgwkC1E48vdd6GUXQExdrFKfQHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UTnoCiz0; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3d18f97e98aso16608495ab.3
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 14:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739572830; x=1740177630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MVWIWIwOA+nBrN8Be4YRtRW/PWjcinFV4/0Oo3jsMYk=;
        b=UTnoCiz07SrwXY1vwLPTrENehievajz3Ln1HTUeH2dpmC2IRfQAqQs2loZ9AA2zslR
         pCMINFT7DivuJeZ3sb7N64wIVAMbIXTdjHz23msOGn+6rUq7HKndJbMb6rpEwgAVPBJa
         XpNhQiARKh0+GTYrYWUHcXq8oBKKDqd8IAubn//aDVxE/E12zPyvXMjC9AQmMxlyA9Fd
         y9VQmRn5kvHP5rDujtIxMdXJhPmncCa4L7pNzCNbRFyKF2UxgDxTxNGOjuA+aWFbDJnN
         h6xPG0fyzO4B5BZY6reYR/SA7Nxak3cljciQdJJBD+E7ZfGF71gCPdQfePqjYDTciR3M
         GMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739572830; x=1740177630;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MVWIWIwOA+nBrN8Be4YRtRW/PWjcinFV4/0Oo3jsMYk=;
        b=WyIlv7TNzdpWuEKu+cXJocsjl9eiarh7FO7D4mGT3pNSGk6rR7z5b5pZxPnMXlnxY6
         duO3sQrUAum87IicQwoPyeU7g1ZMIr3GN8DaPl0nmkJZF2V8mLVYkdWu5irhk+P6fm6y
         elCbojA+ks3E5NNlM1MiiBe55MI6PjcJacgIr48lt6njJS0bS+07scmizZoCWMO4pANs
         9IuIDwNFhkiBMYfSoT32faLdXpvHRBO8M5tTatZBm3SWBVQNrxwGpMEoGweEP27PFz+B
         rE1OqZyXfJ08ghTw5ROIM+M8t/2i4CFfvn2YMwoTd5dle+twtrNU+2O5Ly5hz7vJvF1I
         trWA==
X-Gm-Message-State: AOJu0YyB8c6vdBGoduKosVnxze5KHSsdPW5EOH2ZJukbFdYSQ2vIC1P6
	TbRN/g2Zj0Tc+ppmNL/idfqdumTR+Rjsp98f+A9dAe0js2FrBSgl5llyTtaqGDLiDxLmDBwqIKb
	T
X-Gm-Gg: ASbGncsSKKyw9GxB4IuLRLjEbYaFMxDbb3+xK1SAmbCo2Vn9CVojrTBgwsPsoEvk9Qt
	+B//VMJXo8Lq9BPb8QuM0CbjlG0VthXoxLArpLV8I76Mt74EqNGsebaAYCvTb2POGfm/rZUOJ9X
	cVjvWnuS4ZZced5c7SZuhgKai9IdZKe8olkjCj8h52vhqJFN42HJRqLEOHlKVVUKF7q1ko7N5UC
	O1M4gj4ZelDrELTbG0zytGGNw5RKVTCKOxzrQFfcNIvNjBYgfIY3svRcBicoKKXZ4YXzPeTTW8q
	t1i6pqc=
X-Google-Smtp-Source: AGHT+IEgxnjWbVgMT9neYHwJhqqho/5cOaH5lfK5xPRyiHNn0lJguac1G9Sx52JNKM0KTK649nulBw==
X-Received: by 2002:a05:6e02:1a8b:b0:3cf:c8bf:3b87 with SMTP id e9e14a558f8ab-3d28076c338mr9465345ab.1.1739572830673;
        Fri, 14 Feb 2025 14:40:30 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed282affeesm1020648173.91.2025.02.14.14.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 14:40:29 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Uday Shankar <ushankar@purestorage.com>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20250208-wq_retry-v2-1-4f6f5041d303@purestorage.com>
References: <20250208-wq_retry-v2-1-4f6f5041d303@purestorage.com>
Subject: Re: [PATCH v2] io-wq: backoff when retrying worker creation
Message-Id: <173957282937.385288.14355164441225915577.b4-ty@kernel.dk>
Date: Fri, 14 Feb 2025 15:40:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Sat, 08 Feb 2025 13:42:13 -0700, Uday Shankar wrote:
> When io_uring submission goes async for the first time on a given task,
> we'll try to create a worker thread to handle the submission. Creating
> this worker thread can fail due to various transient conditions, such as
> an outstanding signal in the forking thread, so we have retry logic with
> a limit of 3 retries. However, this retry logic appears to be too
> aggressive/fast - we've observed a thread blowing through the retry
> limit while having the same outstanding signal the whole time. Here's an
> excerpt of some tracing that demonstrates the issue:
> 
> [...]

Applied, thanks!

[1/1] io-wq: backoff when retrying worker creation
      (no commit info)

Best regards,
-- 
Jens Axboe




