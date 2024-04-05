Return-Path: <io-uring+bounces-1410-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D4C889A1CC
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 17:50:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86B3CB25F50
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 15:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C511D16FF41;
	Fri,  5 Apr 2024 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNbJ/1PB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1C016F27B
	for <io-uring@vger.kernel.org>; Fri,  5 Apr 2024 15:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712332215; cv=none; b=iemG/OIPhCmDdYdE8ranTxRyRcZSVizn2bLa3n4EZuyGATwkvAM2q6lzU0Z/L1lXPXMrlULaSxJI5ymsoqeMaeyvr2yrcmXwRNsvqZdxi0qIrnqQYsqGnf5g8MNUlsF5kDwmEI8LLHw/7ovEzAuNC9rcqKYFacPjhERunRn9Qnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712332215; c=relaxed/simple;
	bh=ouQRkUZxCQ+1jWPvwJ3aWMfkBA6ne+mwW3u20T/+XoU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qDQC4Fu9SiTeBpixYWzhhyDU/siTG7FXKSoo4Kk8X7jWZas3D5Ho6xg7B/zEzsmZu5bkDbeUUnsVqYYN4XO8WcHpUMvzOv8QWjKflYpvKQaZErFofTRALBc1b7uJNdUVYrUiCzXrJQR/rxzEjm4P7vEt3P9yidNjfiGwTho4UUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nNbJ/1PB; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-516d15d72c3so2094158e87.1
        for <io-uring@vger.kernel.org>; Fri, 05 Apr 2024 08:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712332212; x=1712937012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/yb/3t4fqgk3FniNK9V1ZBjJZnFv2+TwwiJo3XLwvG0=;
        b=nNbJ/1PBXADCJ4T3Bz/V65EwBD/Rf521InsVqSFjJWB0mGPVo3A0GVFAEgv5irqCC/
         lV47UvmOGl6Hwi5RglC6pfGi60Vnpl7h5IcMq1kxqJ/elIZfiLz6M1uvvkRZrQ8/jdXW
         B+YHGqY1ghrfPcpgQZnGaFe+6Z7AQrlxaUBDSf2BW11eBplJK+yMOQ+WbMAEBZtHvjzQ
         HoWeOqchS4iFUB6JT6KlyTIZWZ+NY6/lxZdgfxuQ2iMXwQFmuFc7/6hbXAV1DEN08c7K
         8ecGwbZucMaicPJdOBIOhxMtnik16XtUh1Z7oiXgrXus9QmgaueTUC9bKoLDMDGmLD7o
         UFtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712332212; x=1712937012;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/yb/3t4fqgk3FniNK9V1ZBjJZnFv2+TwwiJo3XLwvG0=;
        b=eAbluxJYrOIkIg1kBlKOIx99DLVXDdqKBi5xYtMmVluiqXTXIaCnJNretl/VDtA3xC
         gRfP9MI3ADp/FdbJ4Z6ahLq/3LzyMwyYNoUblizZ9OIV6E2xzx27lw82zn6bmJbPESn+
         3elKoegR4kF8JdsKlgwlfuS01N95YxQSeX6/BdakDHZtX3KlLKegGaQsxJ7rX0Yj/Pxv
         p8Vqy1CdG/6XbyZScIvEcyaNqYgLiFpHg6MmMWkHx467lsems1NNDjuPrfE+5GMsvEcD
         fYC+QDFA0fPJFY4+ynXQkBZt18AsjVf0m86MuexCkNx50zSgcb92E5I6XpTvQ7VuwFC1
         uqDg==
X-Gm-Message-State: AOJu0YyOR73vzJcprYBT9Tu5Z10leV5QsZhREX+Mb7KEVveeEJmbws4t
	PzTWyeMH1LrexcZZbVg9PRL/WWTWiDKymHQaPRl7RCjwWx6eWvFif0AvvmXP
X-Google-Smtp-Source: AGHT+IH4TKOuvQhXrABL14Ef5AwqAUWD56pMFFAVQBUPSzK/2tyav6MZbUHCM/2PdO09LJUzZbGCtQ==
X-Received: by 2002:a19:9112:0:b0:513:2c56:f5e2 with SMTP id t18-20020a199112000000b005132c56f5e2mr1410651lfd.60.1712332211687;
        Fri, 05 Apr 2024 08:50:11 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id lc24-20020a170906f91800b00a46c8dbd5e4sm966105ejb.7.2024.04.05.08.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 08:50:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH for-next 0/4] clean up io_req_complete_post
Date: Fri,  5 Apr 2024 16:50:01 +0100
Message-ID: <cover.1712331455.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 from Ming Lei removes a good chunk of unreachable code. Add a
warning in patch 2, and apparently we can develop on the idea and remove
even more dead code in patches 3,4.

Ming Lei (1):
  io_uring: kill dead code in io_req_complete_post

Pavel Begunkov (3):
  io_uring: turn implicit assumptions into a warning
  io_uring: remove async request cache
  io_uring: remove io_req_put_rsrc_locked()

 include/linux/io_uring_types.h |  4 --
 io_uring/io_uring.c            | 72 ++++++----------------------------
 io_uring/refs.h                |  7 ++++
 io_uring/rsrc.h                |  6 ---
 4 files changed, 20 insertions(+), 69 deletions(-)

-- 
2.44.0


