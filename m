Return-Path: <io-uring+bounces-8990-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E34B29582
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:42:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 887597AB4FB
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5EF42253E0;
	Sun, 17 Aug 2025 22:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sx99Juzs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A38C21767C
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470558; cv=none; b=hF3EwpakilzdI4FTOgXFu6tavbFYAHpaRZpjg8q3qEc3dcpPcaXBVeH+gUVOPMSiunhjk5UdmEJ51cM5Xk9wdhYZKNk+6HIQ/zVpfOGCFLw+2BAFc0jyV9IXk7Nkkwm1mim62XHzjbVnoqlkXh7IYWQk9KXmhGwwYZztapHnUA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470558; c=relaxed/simple;
	bh=Aj+M/lfNj/FLQUvZzrLdt9JjxMalsrlHntQfRr+X6is=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=phYlG8T/hjOrXuJ6De+eEOKi6WShFD89v7wrrt+NLryQR/ew7xAsKw/XAfTCJ39g71ibESWOgHGZjgv2zv7Ie0TL+gDkz6AvQe1wFYKR7JPTd+jr/P7Cb3nbBfjZ9w2teK2r1AMuAxgbwg/6qWEh6F5KWT8TTWARvsZCxsSZtUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sx99Juzs; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45a1b065d58so25504435e9.1
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470555; x=1756075355; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HhWt7LtF0M6bw+TCP3W/aGOEsHK4tqG6IwdFORMt4a0=;
        b=Sx99JuzsEEysBqvUaP9/GIWre0Wm8rZqYqJc0N7AB3oHwA75REv5F9f+U0eBymzKt5
         U97rz4evg4V+qZSpqRXyrSsP/KbgJ1wUfWIdlrH3qsKKrcgW/y4b9bZlavLAbERypR/1
         nUoMSA1ULMjPCjNBBKtcAq11kWd2pggLbVNFfnQgRf1NTovzxEos88F1WMs/hOGqT4uN
         lVPTcBFvPyE8qkx6F1nEgiGgmI6nIAra5OjOi6xl6533aC3xzTLsy0FYQvdj5dqfWixy
         RWUIM+RlbdIEpVrZ2dv1FD5L85Out4GsXE7D7y4Gkg4JaVLn8RM/WJHMPJG4jd8oDDSq
         3HeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470555; x=1756075355;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HhWt7LtF0M6bw+TCP3W/aGOEsHK4tqG6IwdFORMt4a0=;
        b=ZDB+sZlNw4eqtISpxX51fefeQSrt8gTXLx+pdTFZUtuGIJKHtS5wIa08TYyyt3xcAW
         WBfs1HmJU1PMgGWvqmPhVk2u9hK3YBM4o4v3lsbov9eVbMRimp9e/4r/PXBpDrGOlVNs
         FZLtWcRKYbZO9+9RKiNBI9aoQNk33TOTsQ+yYBJEgiiAj77ddGVTAOkYWzh3k8WghUse
         pHLuj80pgaKZRvq7o7clP5akWiC6fMpXJ7PgMHhMA6R7zcXgzVhh5w9s5bqepRlhfOKA
         MzAr/8jNiSYo13yAZXK8JDayQKSbe1XRksPcKYlflDFiLRYTjpBHOZTJeOXibGkRuQ4R
         ojfg==
X-Gm-Message-State: AOJu0Yxq8s3iYlihOL9pb40iAyjnT9K3izB0Deo0LXFzRxwHgC1Oqm1G
	AT3yviowMV+L+LqsjF4RPnXDGjl+fuNNdb3535cj45aGFQTPfdbtlfkhMmkhjQ==
X-Gm-Gg: ASbGncuGP5iECcT8GiZYgds1VMbKPlSkhGD5B7Q7BHqpvn8tSCw5vI88lcPTLv7EUKD
	OXZGspnqKCCNq/VnAlnfjPmOtx5QP4MzR3OUmXAGOyrrelFh10nvotbR28t5Rv+o9NQOX7LQ7Sw
	zpgRsLvJUUEcWxjN67/m1gA02DaBCc1PCAMJehWbSJV/VXfAXCDQaywFf4I+AISL4lvGuj7sOs+
	HgVhrd82z8pDc/flXWh8dV61XmP/nshi00ScaLUQBYBHdLC7eIydf/yRlzX5yb89sjsTzp+dJhx
	q04/WjWvyt5QGG/lxIhe0TkXEJtife2Uqd7zhunTJOG+d5YPVj0yu0y8wQOev107BdtiMoxxLWQ
	sLxFkPejBoxWqrRv00lgHXf50GFbsGzSBTg==
X-Google-Smtp-Source: AGHT+IGY/H1AGIO1fql+/+yJji2lbIQr+Ag1C4t4B8k2Mb2DoQFfEZU9ycvK5ILA0K7TJ+ECsGZETQ==
X-Received: by 2002:a05:600c:5250:b0:455:f59e:fdaa with SMTP id 5b1f17b1804b1-45a21839dcamr67323315e9.21.1755470554688;
        Sun, 17 Aug 2025 15:42:34 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231f7e8sm112001565e9.14.2025.08.17.15.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:42:33 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 00/10] next zcrx cleanups
Date: Sun, 17 Aug 2025 23:43:26 +0100
Message-ID: <cover.1755467432.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Flushing for review some of zcrx cleanups I had for a while now. This
includes consolidating dma sync, optimising refilling, and using lock
guards.

For a full branch with all relevant patches see
https://github.com/isilence/linux.git zcrx/for-next

Pavel Begunkov (10):
  io_uring/zcrx: replace memchar_inv with is_zero
  io_uring/zcrx: use page_pool_unref_and_test()
  io_uring/zcrx: remove extra io_zcrx_drop_netdev
  io_uring/zcrx: rename dma lock
  io_uring/zcrx: protect netdev with pp_lock
  io_uring/zcrx: unify allocation dma sync
  io_uring/zcrx: reduce netmem scope in refill
  io_uring/zcrx: use guards for the refill lock
  io_uring/zcrx: don't adjust free cache space
  io_uring/zcrx: rely on cache size truncation on refill

 io_uring/zcrx.c | 92 ++++++++++++++++++++++---------------------------
 io_uring/zcrx.h |  8 +++--
 2 files changed, 48 insertions(+), 52 deletions(-)

-- 
2.49.0


