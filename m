Return-Path: <io-uring+bounces-265-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D86F80AB25
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 18:49:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09579B20AC0
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 17:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5624D3B791;
	Fri,  8 Dec 2023 17:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jmtHpTh1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4497F10EF
	for <io-uring@vger.kernel.org>; Fri,  8 Dec 2023 09:48:51 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-7b70c2422a8so10192739f.0
        for <io-uring@vger.kernel.org>; Fri, 08 Dec 2023 09:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1702057730; x=1702662530; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CC+RMiA1n/fCn48F/utATfW6uQyA26SHbo1tGbywNo=;
        b=jmtHpTh1PkMam3M/559vZODnNcLH0wAIEGMnVtn6tTr75Up1ilN4gEWlVqAgCRwAb+
         RiPjge3Jg0ST32aO+fBunNVvqIVX/n3na8QKCX0GKM1e+qBd3WOq6UHxkDoCuMEAAYCt
         YXW7Zkrdj8bu978B/tVhsdKrG3f3IlLuJWGQj0BEX8Un72tyGv8UzJKh9b6ChY8JGhW8
         7KpQC4LZjkY/gPhxgyQNWSNXHcSu8D+bCMY8ZFeBMEDzrAnVMB7qiFn6RSLpZnVUpMfi
         D1quBLsEgvQphFhfLDMnxlEZ8vgeix/5l5LqhE7yDNqCkS/Cs/8Las0Avezsk4qkHKuE
         NIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702057730; x=1702662530;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+CC+RMiA1n/fCn48F/utATfW6uQyA26SHbo1tGbywNo=;
        b=TLC645Mej151Dxrta7D+fuirE+YmXqG/XPNRF9nk0HBatHQkKXxipRTX6E92s+y6xY
         ++qKBY7C/AIQLzSvi6d53W/1gzBa+m1MqSHb99geViR4GqlYwqjCg66zk/8por+pNnd8
         8/AN5+xdgN0Txm0rJREE59zCjYQe6oxzYBrQWVFkStpfph0pjouNXb0uU2ULlfVa70ST
         jxIcVj8pn5smvT/nEMQ4DoS9tkcQ4byeBKDo0B4zl6v2BeZwOvxBnlCYJbySc+/FGJEq
         evkNL2OxDruyOtHnTiAvn1v8SHFAc/fnBDuA86pqSVPGsy3LoQmSKH2a/SVRvypbrIpl
         VV5Q==
X-Gm-Message-State: AOJu0Yznf/jzTyKKqCEOaUdQwLElFWxW4+UougHYzm/oXIIj9RINVIZl
	PSgxjomyHFgVBLVBa9EIl0DCfTo+t/YxcvLzaSziKw==
X-Google-Smtp-Source: AGHT+IGVIzECUdlEtSWcEtLlH9W25J5kqYmsRq6fP9+CKBEUxnCYm5FNVmAT3svN90W94UuyHBUBIw==
X-Received: by 2002:a6b:ea0a:0:b0:7b4:520c:de0b with SMTP id m10-20020a6bea0a000000b007b4520cde0bmr967557ioc.1.1702057730640;
        Fri, 08 Dec 2023 09:48:50 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l12-20020a02cd8c000000b0045458b7b4fcsm538082jap.171.2023.12.08.09.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Dec 2023 09:48:49 -0800 (PST)
Message-ID: <9ab83827-12a2-4e63-a557-ea8a837a988a@kernel.dk>
Date: Fri, 8 Dec 2023 10:48:48 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.7-rc5
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Two minor fixes for issues introduced in this release cycle, and two
fixes for issues or potential issues that are heading to stable. One of
these ends up disabling passing io_uring file descriptors via
SCM_RIGHTS. There really shouldn't be an overlap between that kind of
historic use case and modern usage of io_uring, which is why this was
deemed appropriate.

Please pull!


The following changes since commit 73363c262d6a7d26063da96610f61baf69a70f7c:

  io_uring: use fget/fput consistently (2023-11-28 11:56:29 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-12-08

for you to fetch changes up to 705318a99a138c29a512a72c3e0043b3cd7f55f4:

  io_uring/af_unix: disable sending io_uring over sockets (2023-12-07 10:35:19 -0700)

----------------------------------------------------------------
io_uring-6.7-2023-12-08

----------------------------------------------------------------
Dan Carpenter (1):
      io_uring/kbuf: Fix an NULL vs IS_ERR() bug in io_alloc_pbuf_ring()

Jens Axboe (1):
      io_uring/kbuf: check for buffer list readiness after NULL check

Pavel Begunkov (2):
      io_uring: fix mutex_unlock with unreferenced ctx
      io_uring/af_unix: disable sending io_uring over sockets

 io_uring/io_uring.c | 9 +++------
 io_uring/kbuf.c     | 8 ++++----
 io_uring/rsrc.h     | 7 -------
 net/core/scm.c      | 6 ++++++
 4 files changed, 13 insertions(+), 17 deletions(-)

-- 
Jens Axboe


