Return-Path: <io-uring+bounces-11570-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D29DD0BE92
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 19:44:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6D79A303369B
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 18:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1292D0C98;
	Fri,  9 Jan 2026 18:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VKQr2E86"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735952D47E3
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 18:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767984272; cv=none; b=Hzx/Hkp/J7sdVx6h7BJgtO1+tmNlRl1Zj5QXX2wqqXJ/iAuQxBozs8Ny/4yF/wzKpSlccQ9zDQ6MW8eXObktrTt+ZBeoJ2PX7u22D466UdSNF06sFXlIgoH9Ay/SI85nhwtq+aC8LKk+ogbMmMnQlFRnzlaRHdyI3JOgeLgKCwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767984272; c=relaxed/simple;
	bh=rFr+IUAUHZhC5Vn21OVdDaofQqwKYK0YMsE5hA9OYtA=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=hWjaFR2Dz+P9mVLKFu9ue5cNPEKgHpmEZ35lEmXnFEtIlvsDkwEOmuGcatmljprLaqAoPKyJSrNASfL8CIBIVjCZxqet0jEh39XESGAAmYvPzG4zfFccRT8NI4zVHGaQmh8KnWC44Rg6GGhV6SQW+7G7rFlG7SUN57zuHUa4QsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VKQr2E86; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-450b3f60c31so2275715b6e.3
        for <io-uring@vger.kernel.org>; Fri, 09 Jan 2026 10:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767984269; x=1768589069; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kFqWR2/px9bj7c+Vz3cCpP2sSX7Mq0jwCkcImQEnfPA=;
        b=VKQr2E86z+jxLtwh8xHROk3ttsq9lIS0idjvL8UwElYWIwdZuaz2WE9kUKknu2ENeW
         sV++XXaVvPFcKTP+wsV/O1MZzpBsOU+zhVfzXaoxh0m+nzgcC70hXIoppwZ/N/akll19
         UXWZgOLF3JJg7jkGIP4VsRR9j43mqmsoXL5ogmmB0JIYoHN4YvdGXi3NmwoWQpE+3wjJ
         pqYjPEdoBxeldIov956UVAe1JANs8ZsXXIsuALg/ZXNqErr5L/fR08blNbY1MEMfTDNM
         sj7okmMx2MliDfstuKUswzgWNIu3falQGvdugA20URSeVkuzkp86f+oAdr2AnHzAl7iC
         Pb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767984269; x=1768589069;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kFqWR2/px9bj7c+Vz3cCpP2sSX7Mq0jwCkcImQEnfPA=;
        b=TlKNET4JWxcHidUqsDCCFCTDxiudUyAgY8cjLmVDyI+MNBb6wQDH+XKQHpsQb5dwXu
         KXBjJ4itncFpS8TYRekE2y2le10CQlCW4SJ1ZjGwKU49aRzwsE6HqufM7e+hftYDhogV
         lcPeEBx4WTWGz5+YEzfouTtAb6QUXQdGZ7JQ22+HW0dTw3dMqC6Z8239NeJTJd/HDQmO
         Iy5Fp1aBAVGbKeLPdP6nU0M/bp3TG+VV/8L2jwjwcv4AVskNQu44JF3fXPjVa9eTs23a
         h3GFInxTDoZ9xaggG9NB/3tkrTibMHhp7Mpzxu5EXxuHSzLPXU+va69CBT73O+lR72CR
         C80A==
X-Gm-Message-State: AOJu0YwRD9gMKBTaLiHcF6qBuZzIEVWbB7279ykL4C+Xo1igx+Yva0hK
	ZexzycrfouuVin+pU7Mts9M4D8wd3TjRC7M3u6US+Dh/7vIN8OIR/HCAdBcrpDmWI66/vIpADp9
	huvZJ
X-Gm-Gg: AY/fxX72UbznZ3O055zHE8Y/hEfSr2TZhedyGPQUN7Uj12ng7GzssIpQisrcMuH50Jt
	Nn3Jl8ht+CaVqju8DhPUjknvRXq09s/aD78xoHb6yU9e+ZmiiQDrfHUr2JUyUmcWP3K4wshLXRz
	DeXhaCqhSREMjEHdc8wH2kP3KP/seKNhDEdIeNIKZy5Xn44BJpwJq0vFdp37WLIM28d/nGNmuz2
	uivVQFPSIaTA+rthwoLZiuoLdK2ttLFykkA7rc6c9YExzp4EEhhIhpnVaCRztM01rAu2EfhqRaO
	CVBskmXuHSPHMW4jZ57l9YjIsSfT15MGHpY8DxPz0/E7Hn1mQpKGBpauXrJ7P+GPkiCi6oYKT6U
	4uIN7lOvh3nU7tOR2/Tn3mHVjJfJJPvoNa9pWHryy3qx3l7sDCxUK36JW4qJ9Jv8vlwTB0J0i8Q
	7K1vxAC8Q=
X-Google-Smtp-Source: AGHT+IGoLkdoEOShkbFCqdInGm5ZB6bY5276fS3AKaFkmkbg9bmEwi4N1lzz9DwHnIC9U4xDURxaPA==
X-Received: by 2002:a05:6808:5149:b0:450:aeba:97b6 with SMTP id 5614622812f47-45a6bef3feamr6788166b6e.66.1767984269312;
        Fri, 09 Jan 2026 10:44:29 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa50ecb58sm7303843fac.18.2026.01.09.10.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 10:44:28 -0800 (PST)
Message-ID: <107197ad-1de3-4773-89ad-a3c1977dd7eb@kernel.dk>
Date: Fri, 9 Jan 2026 11:44:27 -0700
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
Subject: [GIT PULL] io_uring fix for 6.19-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Single fix for a regression introduced in 6.15, where a failure to wake
up idle io-wq workers at ring exit will wait for the timeout to expire.
This isn't normally noticeable, as the exit is async. But if a parent
task created a thread that sets up a ring and uses requests that cause
io-wq threads to be created, and the parent task then waits for the
thread to exit, then it can take 5 seconds for that pthread_join() to
succeed as the child thread is waiting for its children to exit.

On top of that, just a basic cleanup as well.

Please pull!

The following changes since commit 70eafc743016b1df73e00fd726ffedd44ce1bdd3:

  io_uring/memmap: drop unused sz param in io_uring_validate_mmap_request() (2026-01-01 08:16:48 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260109

for you to fetch changes up to e4fdbca2dc774366aca6532b57bfcdaae29aaf63:

  io_uring/io-wq: remove io_wq_for_each_worker() return value (2026-01-05 15:39:20 -0700)

----------------------------------------------------------------
io_uring-6.19-20260109

----------------------------------------------------------------
Jens Axboe (2):
      io_uring/io-wq: fix incorrect io_wq_for_each_worker() termination logic
      io_uring/io-wq: remove io_wq_for_each_worker() return value

 io_uring/io-wq.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

-- 
Jens Axboe


