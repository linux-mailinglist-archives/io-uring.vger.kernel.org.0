Return-Path: <io-uring+bounces-9846-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FD13B89A0C
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 15:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAB5D5858A5
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 13:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 698B022A4D8;
	Fri, 19 Sep 2025 13:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OqENmkVP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8E0242D90
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 13:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758287724; cv=none; b=WZwCHrgmc3rgZ/dVbvZqd/cdYENymwtYAW/XrWUgQ35fTgQdbCNtadVrW0ZZbJJfOHEtk23kRLNawa9nXJGw0ukiJ4OcHB7BF9YibpVCnyzA25AXk8q6i0ojI/9XUx/jIVkG0StfhDrVMfQ2JD1Q6hWBoKOrWfvAmz7OxvzfzeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758287724; c=relaxed/simple;
	bh=gOTfkR7U5kHk2CFeMwceAfJSX/QNmGqr8cE081l+B6E=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=SLTV+7gIkE6bvgEw5gUU96HdFtleIYaRbba3ydGpooAOz6KioXWSdQ/L6Vd/YB5U7auwqFft9Dm7jano/ii/ZvhtUFteX+M6MzYlwj+pMQk+P954/NBhopVDqaInXFP+6owSjdL0+KUgWAzLFW87DDSRVH5ztQ5gCbJ3uLg0nZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OqENmkVP; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-887764c2834so151617639f.1
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 06:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758287720; x=1758892520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l1mieQilcBZ2R2kMzYcrFZou5oKDM1c1wbVoX0iZyw0=;
        b=OqENmkVPM/V9Bg6dYfYymzJbdw4HD+UlWm0RRkHbEZyyN2O4NzK4TB5Il3FX3oJDU4
         6CB4I9gPOmgjCBVmip/pUuK2jMTAv1IjDofAwEVXO8MRQXXUBAbfWYVGg0Q/CJnYPySD
         OxbBowNPx9a3bBOdLQ+X3SpW+6l0tiFwYeIqDWE3o0/tr6Zh8wqU0Evo3zO7/jgjSOme
         S/pElztD9oJNk1zi4zSRaoBWBigCs3VdydVNZEJErbAzes1NwX3sG2Ocbu4GQ6ggpoSL
         xryAG6MHJlVPS8/vzg2WWwI0+V1vgvR3PDgb1HrqdJBZkVazFFBPRWPdXIq6Kfby2Tjd
         oYyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758287720; x=1758892520;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l1mieQilcBZ2R2kMzYcrFZou5oKDM1c1wbVoX0iZyw0=;
        b=pq6WeC0YZ8zjrf8KcBZIRQVQwJk9R2IMAoJqffThYK7t3oAVZ9KAnWzy95w1GZFQG1
         jH1LwhhvJ1k/Zpm6fRgL12ThaWOXCtXqStgMtVxH1U1gdPDqcKIM13psoEiSnCENYqbb
         RY1u95dnXqWrc2pMHY0gDy30Z/3CAVfpIJSy6DBDsk0fOVCz1C5pTorzuSgWWM5uLqkk
         0HIc1S8ORuIWfW4qk2eyksAuSnc5/v5Aq0LCJsoWZcXA4pCYeAecYze1AzhBtMPe9sYE
         IvVNBdbJ/f/gi86PETyB1Q1uJN50gjtOfwmbqSyJ/qJSN783jYMGpwjoU4G2efyHpX5q
         i6PQ==
X-Gm-Message-State: AOJu0YzDqNI846hoYP3mpb8A/7sZErqVdIq9d2maOs+5XpQ466Iy2+mx
	mPXqqGkLP39K7guKnQg7HobGC/EAis1tvGB26ZtlPQ1/d2XpjfT0VhYygR6xnozCe9s6MunXLZX
	7LH94
X-Gm-Gg: ASbGncv+6LbCNtoFoiTNUW2vBJWpZdLXqKRjzRhnSLlp132KWDPKwP9M+BRscaOkU4t
	Iff4wJb4OnPy1OnEtIN7g4Yma7hRfNQAfsaWJcrRZQIkmrqeaTdy3wUMwaS37DQy3ZkxfTbzOVd
	s41HpXM0pgDp9zqO7FzvrBFVkB1BhUAEADpJrx20+TPs+Y91gGEAz1HBt8A9x+qqJUKwmZlisOP
	Gy1mBdyiDwlIgG3pF2mh+P9V3GNPbaM/OagpI5I3t9sH9/j1cC9dHg2kdlSxf5UL6BkgpjR0CV3
	NYkgjAju1RrGzlpWeNy8lyhwihDpgP4yLCToSMOtBn2tXSDZjMCmqkPCk/o8cG7sqaLALIrGeNf
	zg4TOQBfbsCm30A==
X-Google-Smtp-Source: AGHT+IFxBULscX6f/kByWiqbTL1686T/6ecEcpq91M7C5oI/Wmu6rBfPpZW7SZw4BicQ2pkJfl34TA==
X-Received: by 2002:a05:6602:4897:b0:8a6:d20a:ee1 with SMTP id ca18e2360f4ac-8ade0ed8ff3mr416184339f.18.1758287720426;
        Fri, 19 Sep 2025 06:15:20 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8a47d925092sm173251939f.17.2025.09.19.06.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 06:15:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1757589613.git.asml.silence@gmail.com>
References: <cover.1757589613.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/6] Add query and mock tests
Message-Id: <175828771958.850015.18156781064751353661.b4-ty@kernel.dk>
Date: Fri, 19 Sep 2025 07:15:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Thu, 11 Sep 2025 12:26:25 +0100, Pavel Begunkov wrote:
> Also introduces a bunch of test/ helper functions.
> 
> Pavel Begunkov (6):
>   tests: test the query interface
>   tests: add t_submit_and_wait_single helper
>   tests: introduce t_iovec_data_length helper
>   tests: add t_sqe_prep_cmd helper
>   tests: add helper for iov data verification
>   tests: add mock file based tests
> 
> [...]

Applied, thanks!

[1/6] tests: test the query interface
      commit: 7e565c0116ba6e0cd1bce3a42409b31fd4dd47d3
[2/6] tests: add t_submit_and_wait_single helper
      commit: f1fc45cbcdcd35064b2fbe3eab6a2b89fb335ec6
[3/6] tests: introduce t_iovec_data_length helper
      commit: 7a936a80be37f50a1851379aa0592eeb3b42a9a1
[4/6] tests: add t_sqe_prep_cmd helper
      commit: 7d3773fd9e5352b113b7d425aa5708acdd48d3c0
[5/6] tests: add helper for iov data verification
      commit: 9e69daf86de39c9b4e70c2dd23e4046293585f34
[6/6] tests: add mock file based tests
      commit: d5673a9b4ad074745e28bf7ddad3692115da01fd

Best regards,
-- 
Jens Axboe




