Return-Path: <io-uring+bounces-9958-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC50BBCA688
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 19:41:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F7FF188BEAB
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 17:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E75824676B;
	Thu,  9 Oct 2025 17:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kslhRm/W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EC4EEC0
	for <io-uring@vger.kernel.org>; Thu,  9 Oct 2025 17:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760031712; cv=none; b=H7jp85ChJJnrs7StRSRUmD7CEhrmRYUbnsGg++9OWfvMtk/fzlrjFC3AT77gUZsK430y5KhgwSeXDxkSvIHl2rFEim6DJsmMMgPZJ//QzEUr3EwoD1oqwwLftY9yhBaXv2WwISQKLCQJ0y7y2Ffxx6XeeDKLMd6hmHJmVxk5d0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760031712; c=relaxed/simple;
	bh=4iHVHCvJs3bmZ1m5TdsYrCGBBsu2PPAAa36Uzbmnbwk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LdMyfsivfhGcVMAMVpofpWAqEvDoCP/IK8LkOQ/YsJyknsMaEOcLfBYIVFN0rg6g1g7MLumOkoNQGKkgZsthHGJisfjmWT8MdeIov/fB8Hun+5hhoUOLb3D6npe3kvOnXXBKocVOcQL1r6f5HsTom+VOfhSbUSJLh9th7pTkzqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kslhRm/W; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-92b92e4b078so51089639f.0
        for <io-uring@vger.kernel.org>; Thu, 09 Oct 2025 10:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760031708; x=1760636508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=NVKPee4RWOtuVyy2z8NZvT5JOwQyUJs+3jrDvZyNJZA=;
        b=kslhRm/W/9BWVIn/LBPQPd09Y5ay9d9WrdO1Lr3zyLUJYY4b8TiUuTcvnDrcsesilo
         e3xM57yPKlRxqpZtx9TVjcRByH5Ddy9DoxpZwUU15G7HJ8fHmBWzrdkzDUuHFL9taZUV
         nJSHN9XOaIjgP8ZIevKTW2o/S0jVrqUc+xTkwxVywucidCXEWenJzl1U3A2mj6NCFvrm
         tYlBvNAS/7T4PYZUP/EMgFF7cfm0OxnQrwjDfoAL/12O75jL/N1pGyVkcXm3/pBHqpWH
         q/KggMKofCXee3VSha2j1E5kk+BIaB2p0VD/RiEeLBw9Ln4qL78HcwxezNoPWldO3Fdg
         s9PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760031708; x=1760636508;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NVKPee4RWOtuVyy2z8NZvT5JOwQyUJs+3jrDvZyNJZA=;
        b=YP0+V5182PFJcn8wt7fDHXLkov1cSp1qtoEuRYSq4ElYnd7RFUaGq2m3TPgZNqBgWn
         F+eUzwNWJo5sksDpaHoSIcb6vXfYNPz2bxp4A5wOAFfXnGJetgwv9uKiikARtMgaDBqP
         KXY5d9VJNhStASfOrgSO3pOHGqAkQA6R/itJuuRCfN27oBG99HOFxOcNntR0PWFZooW/
         DpWXxAr3zhMIlm+eU3jAYlvchsAHbgUp40od3650At0BjBoipfDMliWsdOToccORtL/p
         OWycMYr2UAlorcjXzrpSoB9F3MDMGjCeNAybm3J0OvZuZYGnN6rnpYvW40+X8S04TXWz
         7FSg==
X-Gm-Message-State: AOJu0YzqErJHFADJf0YSXs9cGv+ZTcG7kpJS8ruuV69jF448KfbF1bXw
	qyk8Sl200a0PBRE7tyqusbdqWXQN0HUAkivmhCAGcHUEGnO2r8xx5Tg/Q3PmaBh9uKens4JfquV
	9vuSD51I=
X-Gm-Gg: ASbGncv0AI9L09Oaz4VXa9kFYgXoVQCUM14LNUV3+n3MAMbCJl+iFyktYALHKbsA6kf
	rLAAwQszjMDL7OuS8jq80ttXITh7EUIJd9qz2ushIq972MoogPSjvQFMkYkpw56xcoeXps4ihGZ
	KbeXtooRMzkHTIJ0ztg58DX7wu1Dy2cZxiybICfvrw6WmKnAGxPuPoz6jCOsFOg7ZSOcls9NeqY
	xiWodPXgarJA80G9vjhhDqc/cNmcODyhSnaluNuSwlnUAcpBRjU3V8DulV2bB8xPiH3C77eEowa
	jLv76wM90+Gj8KpNYdtNSIMerJSozep/gICJ9ie1Ra8dFprjslVrtzUXhENqdTlsDZ51u3xlzRs
	2QooAxjFHUA20dGp0tVHGDwRlXCm7b8C5nCWVCM5p
X-Google-Smtp-Source: AGHT+IHB7Ih+589/YZpRfiufpFWw7JH4VZRTRHHrldpogbI7zjW3AC6P2FD8RhYEkvk8daCePBE9zw==
X-Received: by 2002:a05:6e02:4711:b0:42f:8a31:10d5 with SMTP id e9e14a558f8ab-42f8a311201mr53568465ab.16.1760031708294;
        Thu, 09 Oct 2025 10:41:48 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42f9037c631sm12955045ab.33.2025.10.09.10.41.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 10:41:47 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET for-next 0/2] io_uring waitid cleanups
Date: Thu,  9 Oct 2025 11:39:24 -0600
Message-ID: <20251009174145.2209946-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Just two minor patches cleaning up the waitid bits a bit. Not fixing
any bugs, just making it a bit easier to grok and ensuring that wait
queue entry list status is consistent with iw->head always. If not on
the list, head will be NULL. Also makes the removal consistent, by
using a helper for that. This avoids IRQ saving/restoring, and it
leaves the entry always in a sane state by using list_del_init()
which remove_wait_queue() does not.

-- 
Jens Axboe


