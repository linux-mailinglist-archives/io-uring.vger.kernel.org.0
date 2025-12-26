Return-Path: <io-uring+bounces-11312-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D518CDECDB
	for <lists+io-uring@lfdr.de>; Fri, 26 Dec 2025 16:51:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EDF383002A7B
	for <lists+io-uring@lfdr.de>; Fri, 26 Dec 2025 15:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B5821CFF6;
	Fri, 26 Dec 2025 15:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pS3p5zp2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C281D5141
	for <io-uring@vger.kernel.org>; Fri, 26 Dec 2025 15:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766764310; cv=none; b=cjRvoMjOFVpgHdHpJ5RbNL1fWfQRHp3NOSE67AwHWySt7j24aIsD+dzEhSzJjwRabs06yytrmXoXdIbTMfvblmJqjLECYgfStfz+cmautWrMeBrUNwSnlgTKpiBFwwi/h7jC7D/CTa41VpedkBlAIq1D4CFqBrp1NvzGJ0dW8n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766764310; c=relaxed/simple;
	bh=PfjWb790qtagjcKEYSicDCthr7KYiINvFTdKNwcq0uU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=pMNQ4j6nywQ0UzhyOM+tvnHnPx48Lt++lj9G7WS2SUgsN+XbkMmOBgvCNfzQdzvsvCrDKek0RHU/r6NsCJ8nWsbq1M0CTGpMBW+z/2MGGwkALka9bSKOLLkJJxjkJHLXbuMgq0KSdCCUezfeGCjSYx1mePF/lVwsaYxNhe7plv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pS3p5zp2; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-3e89d226c3aso5210226fac.2
        for <io-uring@vger.kernel.org>; Fri, 26 Dec 2025 07:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1766764305; x=1767369105; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AM4V42ZoIToy8yE9bbtfGSpKts/x/HFTewSeTSQP/vs=;
        b=pS3p5zp2B2vpUo5U9+2ngn9cDv+FNsaVhlhFT50t2sX/Tfid7yFaZkmZJ17wzjW2U3
         1d4dA8rWXk8+D73gsQdA8J6HjyDtrUm/bmMFm21V9Qk3Z718nFzH3DCxnHmkMvobcp9l
         Ap+XH+IQoFnRl9oWUZ7KdDdbrO0rJoaMNfmviUcM4KHe08H/64mD4m+wZhaXGTAkEcdY
         uqHR4hyEtAzo1B4Qe6KMRq6FJdcwDRihcRXtoe0D+H/RKXAaW6gNQZVPhFOj8Lr0pdi5
         wW5ZJv3i/N2zg2YKWCjKuwwb9VYrNmEKyAklGrnV2x2UCvQD5GepQ30Y069gELGjFDfY
         SNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766764305; x=1767369105;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AM4V42ZoIToy8yE9bbtfGSpKts/x/HFTewSeTSQP/vs=;
        b=ajUdrM4xL89MDYk8oFbLQ1OUK5LEL9exSMjqasQ0Ni1iM3VESU4xIm7l1OruzknrPg
         jnD9YpuuPMS0bh3ItON0NuzP+5RH+MCFGckcm07KY5E7tUY7Q5sYR1fUcq/LaQuluYjb
         xHbfotWzh4Ofxpgp8UtXY2q8/EoHcm7qWbnp0F4NZRepCdH+egbbPhknNwD7KNRk4jrP
         JWLJWSfevaWzGUXLi+ATN7o+pAHcrKIprKhxOW1p8Akz/5N10BSxiprned/ChY/Ep1KP
         cyp79ebcn0WYluR6WYkmdOv41/VwVZMVlW2zj0sHzW3em45iGh+PxvZB3z6QaTdXqL8j
         HZMg==
X-Gm-Message-State: AOJu0Yys731H4UFYZRG6LKjqX01zxZfj6uk6lk8xYVbiULImbzwUOkGW
	rMvi7AzpeUq9tw30OCEpxsLVhDPOhcJ7YXoFBYvWDSBx12vafq9xYN4UXCOEPVZxPK6T9ac5mR4
	FqmfW
X-Gm-Gg: AY/fxX4nqOpRvkye1pGVI2FMwboTW3EfeALmBSjsEtVHZqS6sbJzEZa3RQWGshPlDkz
	U4JgAtLrnnqwDpN9wHOfXVNVZH9VEGgDsCH4a5vKupeKYKECETyzr1LuEW4aBhk0Fv77VWb/Ai5
	GENcpiZmB6j1P+RUZN0LXdm/w7PwjbGIROmN5xvo1yQdAb/7Qd5jg3cM0Nqa50+ccfM0UbBf35q
	fitV/vx55dX7Z4mAIfI76kJsqqyuuvECzktcbrhQyoQZvc+++iVMSbIqfpGGfrjVP2UtDng1FU0
	BioYvTJGeUi6MldxTXXGqZBCztrs+xEmT+IB633QsIcj84ATfQbeHPby2EE8gQWIWJw74KnDw1o
	UDY3jL9ZGRKzOXzTr39PHgZqW+R+WEu39WWzupn6s82eq7Dwyhu+chmpxOj87eMWepRbu7y66Wo
	cuJrYA9TaxMakHFGl8idU=
X-Google-Smtp-Source: AGHT+IG+oxV82HQbXi5TZU+oNX5g8vLe4oR51WbwAU5rRFI+Xi8yZmn7OBXL8va84t+yysb5GfOUhw==
X-Received: by 2002:a05:6871:3326:b0:3ec:a336:f2c7 with SMTP id 586e51a60fabf-3fda5241ccfmr12971648fac.20.1766764305095;
        Fri, 26 Dec 2025 07:51:45 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3fdaa931b0esm14526071fac.8.2025.12.26.07.51.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 07:51:43 -0800 (PST)
Message-ID: <aba6a23d-6b91-4f51-86f9-cbe26597ab04@kernel.dk>
Date: Fri, 26 Dec 2025 08:51:42 -0700
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
Subject: [GIT PULL] io_uring fix for 6.19-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fix for a bug that can cause a leak of the filename with
IORING_OP_OPENAT, if direct descriptors are asked for and O_CLOEXEC has
been set in the request flags.

Please pull!


The following changes since commit 114ea9bbaf7681c4d363e13b7916e6fef6a4963a:

  io_uring: fix nr_segs calculation in io_import_kbuf (2025-12-17 07:35:42 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20251226

for you to fetch changes up to b14fad555302a2104948feaff70503b64c80ac01:

  io_uring: fix filename leak in __io_openat_prep() (2025-12-25 07:58:33 -0700)

----------------------------------------------------------------
io_uring-6.19-20251226

----------------------------------------------------------------
Prithvi Tambewagh (1):
      io_uring: fix filename leak in __io_openat_prep()

 io_uring/openclose.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Jens Axboe


