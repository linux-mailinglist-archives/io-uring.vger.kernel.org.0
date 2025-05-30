Return-Path: <io-uring+bounces-8141-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F70FAC8FA1
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:17:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF763A4793D
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5575C219A8A;
	Fri, 30 May 2025 12:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SwQsIxeR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE9F22CBE4
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 12:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748609459; cv=none; b=aDljRX3jy9fnKWMOwzZa8JpomnvjQwK60x77SIrsw1tv5Kr8onbyaJ4Y5mEMq5CMl/lxHEKDEzMBMN5EM0mv07d4eOtEKJFxwbgyEnvrti+a6DizpEdnTO3YfKUrHm5/8gaQvgs0nwyq95C3V4jalY+fv/s5MWtwUWLSOEg9p+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748609459; c=relaxed/simple;
	bh=1ZeSnoMyG3okdxq7slET9Fv5JWQr0Z3J57aALuG5k1I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eEvaQEFMism8g2df7gY7c6zcFamfApWLcvlh0s8aII69HyHG7fnEnqm5rm4e5qJmSu0ctrqxvtFobt9RCKUNaib3NKFl6qzqLnYXlF5CiRxjtY8G7oVklDKzFVJfIX5LXcx2hTicHW7OgkXzI1PLyQ0o3Z73jvnSx9toyZwU88I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SwQsIxeR; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ad93ff9f714so358096766b.2
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 05:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748609455; x=1749214255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jVPwRdEfFL3f1UU97mNUAKyg3zFFlGo7wXc/MeOQeys=;
        b=SwQsIxeR6bA9+e890jU1ijNg44JO8gUcr8DgiX01bTyo1VLiFG+6ebvpDZUnFUSCww
         8edDGntdqFSrkRiMkeHhEPmfZO8tqYh4kkSp1dOcMDay+msuOGuJhNdTgVkxd/7oSibb
         SYnrBNBJhh1N1jav3zYUT6pcNnONTiF6wqA3Z+oBdtICAJgPH5fF5NRcOOYV+VXh9ke6
         OadpNN+KI4eLr7XAfpTLLbwi4ajy3bvXuO44O0+US1AmMtij3nQ9Xn+KIqGEdUAO16s6
         SzQzcWFZ2M8efNh1q2hY/H2zcNXoQbrhFwJYakNti3qgiSvyXPfFndDe6hlY6MWMi/EM
         VY+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748609455; x=1749214255;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jVPwRdEfFL3f1UU97mNUAKyg3zFFlGo7wXc/MeOQeys=;
        b=M6B47HHq7qKfu+76TcSWQtzWmseDpLbiO4q2aHOwxOoyNoswYeR+1T7XzUvmRWabek
         WpohHvwuQFj7ZGum/p77Jj8ABUL7NA/OceZH9oRoDJhTAJMhabOge42MFViKqVewKa1+
         xsMsLMM7EpxVBC6itsW6xqzXbY1fM7Z90nWWKYNfqCJIJsDS6IoKIemUHhw22wqGzKxS
         E8LgWhDvZSK35bmhPjX1QBhJxccN6pvzy7oH/OTpdXWkNoI9pyTbrfZO7bS9JY3Agxve
         zvOkIPOEt45fGPej+neZnFY/fIgAlGTpQ2lTcDrev6cT8xxeb21SGdZ79iA4CN2Of/3R
         Gh3w==
X-Gm-Message-State: AOJu0YwJ1ptjv6XfXVpVxPrSyAc14/V3fngodNwNCZfhQ5GSdthv6wC/
	9HVUHNQVoCgH9t/dYpq07WHeuCyjn/76DK1YSUl3pRfP5zMclzOqVDVAvjXeNw==
X-Gm-Gg: ASbGncsRDtH1thA2tzAkndIdL7gYldD6zngJhqMOpIiER09Lj5ZbwGTm/dV43jKJvB1
	+BbkkFouNgFau4KsP9hkoo0YRSQBDf57z643fxp2goTv4B9lt+tH7Syq3/beAemhUm8uVsP/8fv
	mDKl6KoyLAwFO4xDv89TffMK8V7mbs+QDSry3tjHuzM0qceFXRqvxiSgQJIwOSXj68/OkW5cUF6
	ctKZiF/PiQVtW2YwbTQ3ZN611Sn2sUXfUUfdV2hs+GH6yu5BPNF8GEx7mtWXfwq6sX7bPn7X8Jf
	wEdIojZg07FBCKoE/S68Hg6rmHpeRA9fNjc=
X-Google-Smtp-Source: AGHT+IFpc68PZi6Ai8HuLFpTxd/WkXYrQ7KRodMUo8sifymhC7cZ+gtlEpx0s1t7LpD7h/5vZHZrnQ==
X-Received: by 2002:a17:907:2d25:b0:ad8:a4a8:1040 with SMTP id a640c23a62f3a-adb36afcff7mr209855866b.3.1748609455277;
        Fri, 30 May 2025 05:50:55 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad39420sm323234266b.136.2025.05.30.05.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 05:50:54 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 0/6] io_uring/mock: add basic infra for test mock files
Date: Fri, 30 May 2025 13:51:57 +0100
Message-ID: <cover.1748609413.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring commands provide an ioctl style interface for files to
implement file specific operations. io_uring provides many features and
advanced api to commands, and it's getting hard to test as it requires
specific files/devices.

Add basic infrastucture for creating special mock files that will be
implementing the cmd api and using various io_uring features we want to
test. It'll also be useful to test some more obscure read/write/polling
edge cases in the future, which was initially suggested by Chase.

v4: require CAP_ADMIN and limit to KASAN builds
v3: fix memleak, + release fop callback
v2: add rw support with basic options
    implement features not as bitmask but sequence number

Pavel Begunkov (6):
  io_uring/mock: add basic infra for test mock files
  io_uring/mock: add cmd using vectored regbufs
  io_uring/mock: add sync read/write
  io_uring/mock: allow to choose FMODE_NOWAIT
  io_uring/mock: support for async read/write
  io_uring/mock: add trivial poll handler

 init/Kconfig         |  11 ++
 io_uring/Makefile    |   1 +
 io_uring/mock_file.c | 357 +++++++++++++++++++++++++++++++++++++++++++
 io_uring/mock_file.h |  47 ++++++
 4 files changed, 416 insertions(+)
 create mode 100644 io_uring/mock_file.c
 create mode 100644 io_uring/mock_file.h

-- 
2.49.0


