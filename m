Return-Path: <io-uring+bounces-1254-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 276A288EF0F
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 20:19:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD94F1F284A1
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 19:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5686F14F11F;
	Wed, 27 Mar 2024 19:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="REyPKVTz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B0A14E2E3
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 19:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567182; cv=none; b=E6RZOqCfx9SJwdLalVN39SzleksDCo3OoYgmrHuvjqdWXsmbnCpesMBe37H2hsd1Lmgz0G9VnXGeNQKWfAR98Gyq6fEwI5SczD3zp86Yp1Gqu7ZugTYknBxXB3QMsrNgwYks6n3qvouURAbmI3vWE0T5pw2R/6IEokWpwumktto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567182; c=relaxed/simple;
	bh=oVKUYwpQYN2TkFfzcKIkAdVMxSafz03fI3bpnebSsPw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=XsjTI2HmA4/z65O6hO+Mm26Y1GUzNvrViztce7dvwp5uKdiTLBkR4xBkZT/61Bz1+SPP/0isU9ZRjs81E7+K1/nVVkf7IijAZalUuLY3mPRex8875LsN8VfOqVogc1WJWAvIPN/B60OL4ryfcdnzo2rrn3qVAoZMj/L0NO5G10U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=REyPKVTz; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so48803b3a.0
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 12:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711567177; x=1712171977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=1gaK+hqogzdxSXfcpGcirTaCHp2gy3nmyjI/ahqQX6k=;
        b=REyPKVTzMpilVivmR+7evk1sOpvvN55SJh3NhY+ADj7T3R74e58Ult5yn/FRrGkboo
         YXQQbv4YQDFE5fEcdgbvfdD0QSyPM+1D8i92qF8q21ZdSJE0l+0biM2xOXPHQRWQ7YNN
         +NfHLKUDkvT8Iwo4tVPBFEw/mqrQhld3Dr71MZ8EqNOt9sGnqkkgjh9gNHLLf/kSWK+M
         N3nnWYl5G+4aGvGcxjEaIdoNM1oGuxvIeSk8ZjmcEBfCAYhfRd/UflyE2pP13iu77QA8
         8pT8nvim8XI3sA61IMEFzy6rdLiS6TDxR/UDJXk7d1P7gHLHHmLN1XmG12Aks69wTbfK
         +Thg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711567177; x=1712171977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1gaK+hqogzdxSXfcpGcirTaCHp2gy3nmyjI/ahqQX6k=;
        b=ptRqnIuz8L8doMZKsz2MwsH5R5bjsWBCQ9W4LeeGOleMImCOQyPoIdowyukZtdPi1A
         ApvtfyUZPvdlH83fTFBuqk/6yI/DfSOwkzhzXC/la39+y1P0jrvWqOipMlQL/K8h3MGo
         oZDUcEBofVMpVaX2kuRnMoAKk/ofNgqY1ijAHU0gzM0F4RdSSiH7mgaTkqn/CPHAsGHP
         8k1vILtrw/ucJ10xZw0HY0uKVQBT8vsfK5prlK0kFPCXL8wErsu9W4EX7agRDzpUqlGv
         8fdH9ePPHLYQKW2uQLR2L69jbyGRBIfwUVpmhu3OzWNhi1xF3gjkCiOZfskcwC2H7xtP
         Icnw==
X-Gm-Message-State: AOJu0Yxks4PEaxI6wMVi1F11/hE6ByGZ1GpVOea8wdSthqxrnwDECOis
	BkQPNQVIn4g7QfRRRtEo6NzTe2dPAZsHbUNz70SlUkR/9vNmfTdKpwlhS7mqD8LG6SYCR7VXKWB
	k
X-Google-Smtp-Source: AGHT+IFPoIiJFCreb6bSPIxUb9jMVFY6QhDc3JcCiUTFtDmVPQeikYT4eXZcD/ItasIpKXp3DBD77w==
X-Received: by 2002:a05:6a21:998e:b0:1a3:6f51:378a with SMTP id ve14-20020a056a21998e00b001a36f51378amr1028495pzb.5.1711567177241;
        Wed, 27 Mar 2024 12:19:37 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79842000000b006e6c3753786sm8278882pfq.41.2024.03.27.12.19.36
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 12:19:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/10] Move away from remap_pfn_range()
Date: Wed, 27 Mar 2024 13:13:35 -0600
Message-ID: <20240327191933.607220-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series switches both the ring, sqes, and kbuf side away from
using remap_pfn_range(). It's a v2 of the one posted here:

https://lore.kernel.org/io-uring/20240321144831.58602-1-axboe@kernel.dk/

and includes the ring/sqes side as well as the first few patches, with
the idea being that we could move those to stable as well to solve the
problem of fragmented memory in production systems not being able to
initialize bigger rings.

This series has been co-developed with Pavel Begunkov.

Patch 1 is just a prep patch, and patches 2-3 add ring support, and
patch 4 just unifies some identical code.

Patches 5-7 cleanup some kbuf side code, and patch 8 prepares buffer
lists to be reference counted, and then patch 9 can finally switch
kbuf to also use the nicer vm_insert_pages().

With this, no more remap_pfn_range(), and no more manual cleanup of
having used it.

 include/linux/io_uring_types.h |   4 -
 io_uring/io_uring.c            | 261 +++++++++++++++++++----------
 io_uring/io_uring.h            |   8 +-
 io_uring/kbuf.c                | 290 ++++++++++-----------------------
 io_uring/kbuf.h                |  11 +-
 io_uring/rsrc.c                |  36 ----
 mm/nommu.c                     |   7 +
 7 files changed, 277 insertions(+), 340 deletions(-)

-- 
Jens Axboe


