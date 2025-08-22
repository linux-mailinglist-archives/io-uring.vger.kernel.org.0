Return-Path: <io-uring+bounces-9257-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CABBB31937
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 15:20:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5057016BA10
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 13:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 988902571D4;
	Fri, 22 Aug 2025 13:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pvCsLk33"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025A32F6575
	for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 13:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755868639; cv=none; b=peS77lMjX/x5sj2RIwyh4qIclFPzq10x2i+/mA2sySq/2EuSCpGkXGKwdRSHRrI7z/oxFDtS2rKvRn647w/O+T+qJROUsmYcABUUZlxnsbKbfwPnFMjHftBATEmVwyrILAf7X20j0Fqtotef9rPdOEsWRSKTNIXqpXXn2/58gAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755868639; c=relaxed/simple;
	bh=i3ImefrQTdzsKVGX5GItXtdrghecVlixYsaMWpAIRBY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=TJktpDoCw99u9dnJcRxVYkq6iYDjsJq5b30m152qmuGIy3Z8GzWPBMpBqJal2RQQvJTz7cojNPBp5nIRQmYD8c/wC4gDfy7Qz48ijl4VRkmyhf37NFgUH3/xmTlQZHiydWSMSFeiTCUkwxPjyFENwbmJ4VV58d582hi6GMcs1JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pvCsLk33; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-88432cbe172so22015939f.0
        for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 06:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755868637; x=1756473437; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BIy5V84eM2aiF0NjcXQDhw18FjLOEcCawYSvufdpw1o=;
        b=pvCsLk33jtK0XVHZDy3u1jDQnOSP1n+kRIJQUbWXP561qOel5RsJUVZyF0WVJDzqQI
         v8k0lofH9AfZbDeqoH+8D/+LhBcb+rGuxhUWkuNyty03Q3Lz0ig4eFQ4wi98cAyLZp2g
         gtBsdRx/5Jdso+ammc/BYcQPetUOi1UpVSxG+BVjFNb/qVFRZaBHt6d8rVX7BOiYBW6F
         QMdNnFPRpyU5vTutYt+juxjSrgPy7vlX286uWqCxyub4oWCkaDgiTY7xmKvwayJ6ECI7
         f12FZkVb+mfXyGUQvKpIaxvpkQgaKsb86eY2597gYTBsnWU4r0Ggy/mbn5V3Gi6FRic6
         WN3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755868637; x=1756473437;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BIy5V84eM2aiF0NjcXQDhw18FjLOEcCawYSvufdpw1o=;
        b=ert97HtUgeyefPzRhL4BYhwLRXOV+tHsp+8q3NMEXwdpTKw+i2Sz2J9WakKw0y4Y/5
         MDrHh+jlkDjh9mu4lzt76sk5/Iq1jQVGsSDCSYa/zPd8VKhqK9t4vqti5937dwVMAQdi
         U2dGu9cNKn9QBi4Ct3Hst7n/EtJjiVAMQ8Ib2Du0eUX6WWzuISC+EmYjZEKD2qlhIF+J
         hen7DCd44hhq3GUjzqP3SgG1pnc1Et0Yb20eVQdJGXYCCyZG7euLlmsBHsWjMrWKBPOB
         vWwCr5q2lC2oJrT3MneurbMbH4oubv69cyvzaf1clexB6oUowWY+ohVmvzevDoLuAdUA
         W6cQ==
X-Gm-Message-State: AOJu0Yzk81z4LP9Rsbh7IQ2iF9YJH40l/1qpjmQ/KrbBijIvWaHlTMQm
	HmQUC8frd7uNjxFb4VqlmKdsY68RjS+pZB0oCXKgQwKnuPN62kT/5XRioRkbRdB3Vnhh16una3T
	W0dAK
X-Gm-Gg: ASbGncsSxHxW2CehsrVB6lBxnWJ0OfKdfHNE8ti+JOsW57x79O2qXh9N+vYOFZoecvD
	GjA+vodypkRf+tgYJzCBPeyEV5C60Z1rNhvgLJri2snFWxAhfTzrl2NTi+GphXl6EdAf4rMERqN
	gm8JT/dyZtg79wQHb7x0oDWErhoNykMRWFoW/E57LMF8Y7YiUZpoGlUP9vTHcnQxsfeMnQBpZw+
	47YEd6DZcYfytvFj9KYSnSZYwj5gf6NNKC47vyEnZ4RYx1OTNn4HDhi50oTq/QY8eiCFtPZf+sc
	J3FiGe2TsyRR/rm/cx5MG2+/kcatwQt6wXccbukd2N4xKY9+InDBElRo69284eNkF/1hz8eMam2
	goAiO6PRuRLJqCaBArls=
X-Google-Smtp-Source: AGHT+IECLqx9VOHVnaVvRg4lFJ5T1BH0pWTpONXMXy+8MtkK0xk16Zo3eF5ZxWCsQ/Yvoz2hLhRHYQ==
X-Received: by 2002:a05:6602:3c3:b0:86d:9ec7:267e with SMTP id ca18e2360f4ac-886bd155520mr554921539f.4.1755868636963;
        Fri, 22 Aug 2025 06:17:16 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8843fa1787esm811689139f.31.2025.08.22.06.17.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 06:17:16 -0700 (PDT)
Message-ID: <9eda00d9-2316-49c4-bdb7-af1e20546e7b@kernel.dk>
Date: Fri, 22 Aug 2025 07:17:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.17-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just two small fixes for 6.17-rc3 - one that fixes inconsistent
->async_data vs REQ_F_ASYNC_DATA handling in futex, and a followup that
just ensures that if other opcode handlers mess this up, it won't cause
any issues.

Please pull!


The following changes since commit 9d83e1f05c98bab5de350bef89177e2be8b34db0:

  io_uring/io-wq: add check free worker before create new worker (2025-08-13 06:31:10 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.17-20250822

for you to fetch changes up to e4e6aaea46b7be818eba0510ba68d30df8689ea3:

  io_uring: clear ->async_data as part of normal init (2025-08-21 13:54:01 -0600)

----------------------------------------------------------------
io_uring-6.17-20250822

----------------------------------------------------------------
Jens Axboe (2):
      io_uring/futex: ensure io_futex_wait() cleans up properly on failure
      io_uring: clear ->async_data as part of normal init

 io_uring/futex.c    | 3 +++
 io_uring/io_uring.c | 1 +
 2 files changed, 4 insertions(+)

-- 
Jens Axboe


