Return-Path: <io-uring+bounces-2988-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93EE3966A8E
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 22:32:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C48F28256D
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 20:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F9731B1D53;
	Fri, 30 Aug 2024 20:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kE9sVB4T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5419A166F0D
	for <io-uring@vger.kernel.org>; Fri, 30 Aug 2024 20:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725049924; cv=none; b=Mr1v4aEGiVbLfhG8EfA0q8WElKfIooknrQpWkYtzmZAycgTBJqxAlwTZfC+k0LhRXNHx17de0dWOP0qM5DfyGQvK8/wHHX3UriaJs75Fqdog95zV9GcSCSwW78tPkrOrv55dx5EnT1+HcAz8inNEJrF4s8qsAgFo63rEWLR09XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725049924; c=relaxed/simple;
	bh=JAMZLlsOyLxCPLnxSi17HQpOY/snyG3TELqb3CPzUXo=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=M7qqysufSsEynfehTV9wPsirzYp4jenJ3niFTeCS2KzSwCY1r3+br594lsjz6MHPQ52tuCKus5X16DC4oOo5ajN/gJIk4BgR1rEpLSbhAPTrvs6f6WTwQv1JWWh74zT76OH1uyy2CnVRDjMY3JpzyTvujXXQwkmmC0jL4JLv5Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kE9sVB4T; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-715cc93694fso2085891b3a.2
        for <io-uring@vger.kernel.org>; Fri, 30 Aug 2024 13:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725049920; x=1725654720; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=setTkv06r/hJujm5MXDQzuMoDHXiNhgzyeyXNd2+ojo=;
        b=kE9sVB4T+V/L3cB+z89aW4jOGLi7aRkSUvlYy58U6adRjLTDwUWMxfY7e9tsJysYTy
         3wG9qbL7iSyeQFhSYYUeAS9D8LdALSjlsnN/4C6xFYDWPSdWFFnH6gz053yRXpR2DgOk
         wlsheiUbV2o4cMTCCl7ND7D974wjlIXw3ypviz5pBwwDSC7KZzOPreJ45Ds6z/LGYcpO
         7DE4+QKotIvsxtk8NV2TZzz2mjsZ8YkHEUdofQpHbC8sYiF7fAqNNjUfQm5ObvDqh+HV
         damW8H9MLQCceqsANBATl4+XPilDeIqW7ZVnv1xUmNRSg3xOuryOgvtsjXoMYCcNgq2u
         w7Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725049920; x=1725654720;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=setTkv06r/hJujm5MXDQzuMoDHXiNhgzyeyXNd2+ojo=;
        b=k58UfTSOPwyHEpvs4dwt3d36YFM6uSw0Sd5DZcnPkSyAVWELcbXMVx/wdWVIyQCNQC
         zmpMvpCsbkd1bArhEVUDw6y4n7ewCavDjAg2BApcN3eEvPC3R/hjirAmCBjudPcB2x0C
         WIwUHpkehiDre847LtY05e56ZPPMYX2vV18PG0niZ1sq6VlsbiFt9DZ4vPIysMY0Z7x1
         QAdC6mCtIYTyG3ZqDrmzhQ8ZbWkk7AwNZ90+ArXRdKgwEBGSadOmHfMhJf29VpGJwJiP
         ykpzjOcTUH20B+jxzwces7/dcx1b4gHzn/yOCcqpY9HE9wMhZQg1gzqHrWfj031jM4Dm
         FSOA==
X-Gm-Message-State: AOJu0Yz6izGRgokRVIju2C/aYk1PD62KU0pyKLZmSfEt9ktd7h+uJfDq
	a55wsrwGq6NCTQVV/797n07tTi05a0wnEExc8MOz04Cco8X7pC1zI32TMcuzaiGNshtH8szCuSC
	/
X-Google-Smtp-Source: AGHT+IEgT2k+4+ISTvcDDTWR1PKnpE+YkH7g/JuupiaNYFwHtNHXUlOfLU4S5zP0JGO6LxbmExOY3Q==
X-Received: by 2002:a05:6a00:cd6:b0:710:6f54:bcac with SMTP id d2e1a72fcca58-7173c1e0fa1mr628701b3a.1.1725049920455;
        Fri, 30 Aug 2024 13:32:00 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-715e56d934asm3260369b3a.175.2024.08.30.13.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2024 13:31:59 -0700 (PDT)
Message-ID: <791375ed-d460-4fa4-81da-fffea554de2e@kernel.dk>
Date: Fri, 30 Aug 2024 14:31:57 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.11-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Here are two fixes that should go into the 6.11 release:

- A fix for a regression that happened in 6.11 merge window, where the
  copying of iovecs for compat mode applications got broken for certain
  cases.

- Fix for a bug introduced in 6.10, where if using recv/send bundles
  with classic provided buffers, the recv/send would fail to set the
  right iovec count. This caused 0 byte send/recv results. Found via
  code coverage testing and writing a test case to exercise it.

Please pull!


The following changes since commit e0ee967630c8ee67bb47a5b38d235cd5a8789c48:

  io_uring/kbuf: sanitize peek buffer setup (2024-08-21 07:16:38 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.11-20240830

for you to fetch changes up to f274495aea7b15225b3d83837121b22ef96e560c:

  io_uring/kbuf: return correct iovec count from classic buffer peek (2024-08-30 10:45:54 -0600)

----------------------------------------------------------------
io_uring-6.11-20240830

----------------------------------------------------------------
Jens Axboe (2):
      io_uring/rsrc: ensure compat iovecs are copied correctly
      io_uring/kbuf: return correct iovec count from classic buffer peek

 io_uring/kbuf.c |  2 +-
 io_uring/rsrc.c | 19 +++++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

-- 
Jens Axboe


