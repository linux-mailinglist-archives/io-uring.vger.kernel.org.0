Return-Path: <io-uring+bounces-1231-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BDA9E88CC3B
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 19:46:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7498F1F83271
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 18:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD0D113C9DA;
	Tue, 26 Mar 2024 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ixU7//Wk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9348613C91F
	for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 18:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711478781; cv=none; b=pLyACvBeibXYdGsSry//nI3SuX0javm1vjHimnyLz12629Yz0FyjZkyx/yWPhrwwqM3Hv0M3fFL8C9OU/OaQGDgaSRbOevMFue1C3z5Fl0zAEIf1KNqC39hftr+ld0Jgt39/mmtXSdfsokv6+3RARl8oS89HkopGdfBddJPCawg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711478781; c=relaxed/simple;
	bh=LNM9eptEiIH+wCn42GzDF6jmYc8EgUh4SnRWvSw/xFU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PQt920PiGIKnH2dgOdSnKk5yTVCTyB4U8uPav4DRXyS5KWNg/VjPQDZFq6ofwyTLqbPpQ+X5BlF2Ix6yj+af81uNMdVnbuldpcmx81Ow4FsriK16rutQU6AdVTjy/BGRhwGP0lzooTc34wF3Mn/opdFYzyJfd5rLEG8zSrlzDWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ixU7//Wk; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5cdbc42f5efso115329a12.0
        for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 11:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711478777; x=1712083577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=d7LbJFUpzhVbesxAxfQF0zSIzFQDvHf5YiOXesJOORQ=;
        b=ixU7//Wkvvb54j/T+pwogsct9BJ95Y++6v4XUDTaJBBJ6YfafWJKiAuveMDmz10TuP
         H8F6hasiT3sNax3OaPJjPS4mdftzPtB1t/vY7jmZfxz0p/r06cTR32aTZ8LDLWwe+rGd
         2PPRZ/2Pektt+K7MyTQ7vKEwbyvTx442cKDU0ApBqbbGCWzhIGE2zq8DdHJbgKbsVzmc
         mE3UNljhXxkpKhDmar9zdABpmixDYpbl9HwKITsedcsZmUpv27mPD+kvwKfywwkW6Py3
         GhVTeS9XGmgj5N/w3hmtBjBSIPDlTVlCZbTkR/3PbCgGk9bdYR1/X4iqaY9efva9ZFoe
         ZF4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711478777; x=1712083577;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d7LbJFUpzhVbesxAxfQF0zSIzFQDvHf5YiOXesJOORQ=;
        b=tonsiJPixkC6/WIp0eYitJa9ASTISYt9oQdK5ntXUZKmMRtnYEOJPrCpRbMbupNh+E
         OJdi7vYw9uCTFQiYPUaGH9gZmgnNFw+WQG4ZpmMasWEBvclru4akqlFTB2iLIp5don4+
         4ejkRDWkFbIUqIouBgmmKiPCkVM7anA4lC++FMiJDYIe2DmfWujzGHu/jIiUB4v1blRP
         3urs7gK6ilXv3wMq56mK72DxD5i1JsJ1Q639Dep2qWq7RmFZElh7TL5TJD9aEvEFKxuy
         7cTb8aoFJ6zRJLif5MBuF4wxZewPaS4mYDI90qisdqpqY7azHzsPfAq3BcfhD7l9K7Ws
         INzw==
X-Gm-Message-State: AOJu0Yxx+H5UeYaMwWuk5KYAz1M017n/MvWvLBDmA3QvfdhuXYk2Yz5c
	z3zsc/0xOFpvUKkp3VCP9oIj7S9Ey5XpN8UM0MMWLnB8CrncVFF1e1Z1W4RW8z2M8aTkIpwVS5V
	r
X-Google-Smtp-Source: AGHT+IFSBLpFzD/uZuPiyJgx0gltUleT85/eUKUXRD+ELn86NiqxGvnhzLVxFMZ7XYqRHs9of2KDGA==
X-Received: by 2002:a17:903:50b:b0:1dc:82bc:c072 with SMTP id jn11-20020a170903050b00b001dc82bcc072mr11835733plb.1.1711478777385;
        Tue, 26 Mar 2024 11:46:17 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:163c])
        by smtp.gmail.com with ESMTPSA id lg4-20020a170902fb8400b001dede7dd3c7sm7152833plb.111.2024.03.26.11.46.16
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 11:46:16 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/4] Use io_wq_work_list for task_work
Date: Tue, 26 Mar 2024 12:42:44 -0600
Message-ID: <20240326184615.458820-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This converts the deferred, normal, and fallback task_work to use a
normal io_wq_work_list, rather than an llist.

The main motivation behind this is to get rid of the need to reverse
the list once it's deleted and run. I tested this basic conversion of
just switching it from an llist to an io_wq_work_list with a spinlock,
and I don't see any benefits from the lockless list. And for cases where
we get a bursty addition of task_work, this approach is faster as it
avoids the need to iterate the list upfront while reversing it.

And this is less code and simpler, so I'd prefer to go that route.

 include/linux/io_uring_types.h |  13 +--
 io_uring/io_uring.c            | 175 ++++++++++++++++-----------------
 io_uring/io_uring.h            |   8 +-
 io_uring/sqpoll.c              |   8 +-
 io_uring/tctx.c                |   3 +-
 5 files changed, 102 insertions(+), 105 deletions(-)

-- 
Jens Axboe


