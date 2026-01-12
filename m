Return-Path: <io-uring+bounces-11589-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B0FAFD13A69
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 16:28:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5279130158F7
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 15:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC73C2E093F;
	Mon, 12 Jan 2026 15:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SIQ+hiyn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057CE17B418
	for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 15:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768231152; cv=none; b=ICooE8iHqW9VS+pBqTys3IgToFp4Cu3ZTi6uoy/w0ot9fTeEY515tjPu1Xyu6OTMqwB9MWD9Epf5RqEZWkz8wwRwvmFE3yW4xmih79D9A1S/PXPQ2U2yyfTXeOfiziVBz9lyqBa464eRsQcot/Aze3XH7eyZJp0K8DSy4Qrhav4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768231152; c=relaxed/simple;
	bh=5ihOPI2PLiCKWznxYzOqR/Ylkc6EjdZ06J//U+b80nQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=BaSTiRAFJy6N62z3tk7tHEjtIxh5X4bNkSzYuIZdvWAQSjPRDPNBtJyT4dsEykJ3j9bFdIZCU5C1vLkk5fhMiPp1czejy//lDOoG3QYixCV9Dh+2Rfh6rZ10b2uL/kLLMCqu2YPo0iQeoI9c8iHP54FzNop2tC3aLCWwIyqdZDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SIQ+hiyn; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-45a815c1cfdso1296300b6e.0
        for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 07:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768231148; x=1768835948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=7mF3iWx4UE5vPcF0pIQey1oB1AcQ0exyrzmIOAMBjoA=;
        b=SIQ+hiynWXU2en+xgd4pgSZw2+iPe3+KN25W0F3qi2uVMQkHfER8AYn2bQSN09i2fD
         gBKwihA0oaeiBkLExmSinEnGiQd4EOEFUqPidbJbQUBx3jDz/cW0Q4C7x0M7aT0ZWFFC
         PBjyKdyDRREtSIOhwJNqhikov9ogVpDLGcnyK6pwQsvadNmRDTYRMOvpG5G/3DipdvGs
         TlCDEQAx8+PpwYvCAEXRLpXL0pVetSR2gSTAw0P2SY/Y5aU+Vmp8HSXGwWzu2xpAAPbK
         fQbivkrVvIHib9NNZErppycjmot0Wjbm/vUPGAWtudbXIPoc+A5iknai5ZcCQJtP1CIv
         kmPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768231148; x=1768835948;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7mF3iWx4UE5vPcF0pIQey1oB1AcQ0exyrzmIOAMBjoA=;
        b=UeONHEgrwQUNx2zFMNlBQzH/s51Q4nZUIhUjAfaVutVZcKrDmgoFIuw0c/+LGWDAsq
         Y4LMEf4Zcrvt8DcvXgCBmhj+nCH7OKRiHkGfTgen4VDZc95mhz78ZfDUjcu9zQhSeJ6F
         d4wrVbQTfTY8Daq7D7GH+PBPrI7yhorfdDmX2iDLOrVNem7XvNK6DmmHGI5t2BjwyYhA
         Ez5sBUPXwIn8hpgG85m8lzx9HPV8amN0Qo8P+2Jp/qCWF/OVkVm8movgrTbTdyUvjJQD
         12e1SG6XpAd5sm5o32q1hHE4NxM6n0V5Y+R0DrtWkDAjjCL4sXy6XFheeNVxzUFeS6qL
         VhYw==
X-Gm-Message-State: AOJu0YxAFVjZlkO3nnKHgeif6s9/Jrdoosmyvkuc+1r5D0kQLywAOzGE
	FrUKforXyMJMcSj//8aX34eSyqmSuayDv4ZaB9z5DMhc/RWQRWMz5wc5QAG9KxmA+M3ezUiHzeN
	ESoPr
X-Gm-Gg: AY/fxX6NURcfgCQyVZ6ce4e7zfDBU46MWy06Nf2Ejhqs/Lu5geVDhTtduScgUcBFVFd
	Yo6IBJajRcmIU/nTPK2u4bb35fUCeEEA7HaStdGfi1nlRana3RAbwRSzevPdxDhORstt+oob3e5
	bXJk2KePJm2vANzopLK1hcBb7s5NZLUiVWlfZu2CC2xHvpAqcBDBqYya7QpxgDnZRxs7mZ/Y9Jk
	zAjuti5yeMAa7rT1HU5++ihfuitncesO3vDVab4JMdt8JnAo71SIUFyK2QaLx7f0S758ecqAjXn
	0hIyxG7yL/n4a7PAcigiS38SzLogU82D7fFnvAj5gYf8X1dJ9Q/lP9jh7d5NwbYwJGY0Yi08LXC
	+avRyz0pfXCAlaE5fl6MLPyoALS3jztIP++jinpwH3qzAoRJ74V/4exASgBVJcSofWtXwkQQ=
X-Google-Smtp-Source: AGHT+IGgm3p4N/HsFeXx6811TeRgWOzyXKoVQaV0ua0axs7eApV9lBbsA5jdZwvlxX1rlMHZLm37xw==
X-Received: by 2002:a05:6808:4fd1:b0:450:c7b5:23d0 with SMTP id 5614622812f47-45a6bf118efmr9411053b6e.49.1768231148324;
        Mon, 12 Jan 2026 07:19:08 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a8c6b3fdfsm4210561b6e.17.2026.01.12.07.19.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 07:19:07 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/5] io_uring restrictions cleanups and improvements
Date: Mon, 12 Jan 2026 08:14:40 -0700
Message-ID: <20260112151905.200261-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

In doing the task based restriction sets, I found myself doing a few
cleanups and improvements along the way. These really had nothing to
do with the added feature, hence I'm splitting them out into a
separate patchset.

This series is really 4 patches doing cleanup and preparation for
making it easier to add the task based restrictions, and patch 5 is
an improvement for how restrictions are checked. I ran some overhead
numbers and it's honestly surprisingly low for microbenchmarks. For
example, running a pure NOP workload at 13-15M op/sec, checking
restrictions is only about 1.5% of the CPU time. Never the less, I
suspect the most common restrictions applied is to limit the register
operations that can be done. Hence it makes sense to track whether
we have IORING_OP* or IORING_REGISTER* restrictions separately, so
it can be avoided to check ones op based restrictions if only register
based ones have been set.

 include/linux/io_uring_types.h |  8 ++++++--
 io_uring/io_uring.c            |  6 ++++--
 io_uring/register.c            | 35 ++++++++++++++++++++++------------
 3 files changed, 33 insertions(+), 16 deletions(-)

-- 
Jens Axboe


