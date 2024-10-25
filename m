Return-Path: <io-uring+bounces-4034-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E0D19B053F
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 16:14:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA8A3B214DF
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 14:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0FB41D435C;
	Fri, 25 Oct 2024 14:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fHElfakv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B823212182
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729865649; cv=none; b=WvxckYMJSP4+bhoXHVw4mGVlyKh2iHIa5GyNRYLtWqfKlXS5aTWaiTxod78zwpWWPEzbo6En1FK0MCf2MV3pc3xvTdDM+jKrSVfl8/x6TxoK8FsZlV4Fjh3PJsZxd2yBk3Dk1hSnZvE7zhu4TqTwdvO47F7JzOP8Ijp+4WUBM/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729865649; c=relaxed/simple;
	bh=SQyGQu7/fgv39xibg0AkyzO5jqsNsrxSDyANtQS1bjE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mqw4RKJ/5F6iRfbweTcULHEMh0ag4MD6TM1UWCUawQ95wlj87G0mPxzyHaafuM0kAp/ijgc9xGu1feir1h2rYwAWJ1RVESXkX9GnLUnXHZl2DrsF8S0JrbkM21HTwtRkGOoiAKJoW754moDXkuW9626MK45yMw9kXp5i9ubMIPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fHElfakv; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-83aba237c03so78711639f.3
        for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 07:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729865646; x=1730470446; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=8BqUeZigMjc3QgK1eKknRBx2+ylgcg3cbQeS2s/N634=;
        b=fHElfakvPNkbDRtNW2wGQMYhwToUvhAcGZdpQ9RWbnPmJjZI+Y0fZarJ5Wf8bQWRxO
         ZT+Dop+4yMj2VgnSqaiGouoUFKVZIyDwTyHmmfsMQT3ez/Z3F6ILkRcYLrhx1YHA0zvi
         P1XODO8GSRMeZEuq48pdh7kENIMrtRyAhkFWLvJ00zliYieeCkwEfbMf8qgUdPDQQAOq
         ZnIoYcBZSs/uQG6UliSZQe6luR5vL41j4Bl1GCAD6mhC8OMknmdzxRIfQ0n0N3VVRMco
         KddgkCn2qVMPFFvGL75VxaCByrtWF2hNfAXDdyhiK7fFBaiJp9KJBj3TGedAXnGkQqrE
         3WrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729865646; x=1730470446;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8BqUeZigMjc3QgK1eKknRBx2+ylgcg3cbQeS2s/N634=;
        b=HqKzFxekBnueoaYcw5MUILnI+9boyyI/+2uJR0tgzslK7A7YDE8JOMnsE6GfG9fdpf
         v5sVz/WTNzRJPyMzrPZEQiLDayqI6box3yJWjak9mZaCBoSbdnqQ8HIykYy7jQfpmAja
         YUJeG23Z2sFQGeJ8dZE7hbnzzC6PMarcSchESD7EdJG0gPiuDN4yFXGGxgAgDAS+j7H3
         D2pZUuPAWLaYf4vdvz+qE6uAXmu5FtXuODGxMYhdt7bCXWupBv6gg311dqhrRXjF976+
         cneKAoPR/21EKvnx2ZBhQn2Qai7l41FFCHdVyLVCuuTd7/YW0f8lkT9rprpRhqqldMEm
         LEsA==
X-Gm-Message-State: AOJu0YwhdixCiGp3o63swhe+pO/8eF8ofd6No1dBamzY4kBjr9loBV07
	wCdbbzhjakih8bY2cnmq1209zj3TR7HNAcyibwoNzpNCWI4yI3xT+NPUp4jvo2clq2eTctQuuXK
	X
X-Google-Smtp-Source: AGHT+IFKBCycg3mZ7ccOkBB3EPskG0AT+xjQ0ZYyedni/u2RGxGA2pkF2eqRhVlriueUHar7uWH2Vw==
X-Received: by 2002:a05:6602:2b92:b0:83a:9e45:cb20 with SMTP id ca18e2360f4ac-83af641b22emr1220383639f.13.1729865645609;
        Fri, 25 Oct 2024 07:14:05 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb673sm277292173.16.2024.10.25.07.14.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 07:14:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v3 0/3] Add support for registered waits
Date: Fri, 25 Oct 2024 08:12:57 -0600
Message-ID: <20241025141403.169518-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

v3 of the registered wait support, avoiding needless copies for doing
high frequency waits. For v1, see the posting here:

https://lore.kernel.org/io-uring/20241022204708.1025470-1-axboe@kernel.dk/T/#m2d1eb2cc648b9f9c292fd75fc6bc2a8d71eadd49

As with v1, find the kernel repo here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-reg-wait

and the liburing side here:

https://git.kernel.dk/cgit/liburing/log/?h=reg-wait

 include/linux/io_uring_types.h |  10 ++++
 include/uapi/linux/io_uring.h  |  41 +++++++++++++
 io_uring/io_uring.c            | 105 ++++++++++++++++++++++++++-------
 io_uring/register.c            |  82 +++++++++++++++++++++++++
 io_uring/register.h            |   1 +
 5 files changed, 217 insertions(+), 22 deletions(-)

Since v2:
- Wrap registration with a setup struct, to better future proof the
  feature. That would allow doing a registered wait variant with the
  sigmask embedded as well, should that be interesting in the future.
- Update liburing reg-wait branch with the new registration API
- Fixup copy for 32 vs 64-bit
- Minor cleanups and comments

-- 
Jens Axboe


