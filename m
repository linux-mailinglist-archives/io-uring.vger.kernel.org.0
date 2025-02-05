Return-Path: <io-uring+bounces-6265-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DBEFA28964
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 12:37:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F7D13A2F8E
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 11:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 254FA22A4D9;
	Wed,  5 Feb 2025 11:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YYwieu3c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB8922A7EF
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 11:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738755410; cv=none; b=M0YCi5xxr99RlIGMrlFu1BHjp81nMa/XONYGwaxZSrydC1PLlo4kENpaggz1lfvcIr8bx+57ONG1K7A4Uad6T+ff1CR2WqXKm2+86lZUPDAvWKKRShCb0yyytRAxptz6kfzf5yYVYXHiMIkSfjWhHSm4jNreLtuyvuOrbMoEOGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738755410; c=relaxed/simple;
	bh=qTH0SjGlbe3aOU+esQzuAfcSSsWENvn49qJyxgW8UHo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UQssIaJd47ssvDpIOSYnbhHv87ssiwEAiE5BP1FB+FDcXva1V1hzIO0KWRFuetdcFPNO5aUlYgmYO/G4qKPOGFAaSythSAlXOUJmwQsJsXslh31mzN8adMDcCBhsUQcRfOgrkCSNoIlE0iUYh3vqpUQ4xa9UKtTHmP7cZ2Z/xVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YYwieu3c; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-436341f575fso77820055e9.1
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 03:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738755406; x=1739360206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e3jHzYlnSKckuW5m0wmAZmEr1GYN50/m33tZu2EOpqI=;
        b=YYwieu3c04Vb95+HGvxs+fvYePkgyT6iUMid+hAMATQdfsL/ouKvIpJgjGP7kDFqb9
         B91gYE+TuPpTF8xvZlHBkUNdExU7ksk1iXRQuVtpaV3lBjlXz/JYn9PfSQ3Zx9qzCHso
         sjgFqqh6S/aO89u2+0upb0zj7vGMh9D+HkHRy5lqIRClF209p6kFFQ8ueLkj3CpJDdPQ
         3IThWyiv33/Y1qOxlYpG7+iyHutRALV/XTGbUrOxXnnNXN10MjyFgyg6q+/wZcgCdA/K
         5D8yr3qqOnVOJ0QAXM86xV/UUOpjEzrbqjCJ2hXEHIcFcjDmvEUXxU0lirwO0Id+7gVx
         wopA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738755406; x=1739360206;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e3jHzYlnSKckuW5m0wmAZmEr1GYN50/m33tZu2EOpqI=;
        b=U7i1h5uk8H2q5a+d44o8ypIgo2Rpd2ZwIEj6alCyd4Fkl4XoCA6NYAkZDYD9FmmCUd
         IAyEEovEBAEIlJj0kPOInoniR6MzVRhY+BVoVb4clN7+EEPOPllup1VNMwA8UPmgXLNC
         uJC4LHwyG4uoC0zYGrwPhlDV21jAqvowUM21tYv3xnBzzP7Am60ho3gxXiYi+aHHKahP
         5qOZ0DNCjSKJF+eHVWgBrW+BxJruJQIZvacs/qu3HQtegTMrgp1bAnoJs063iYrj+pAv
         6nyEumGGhEh3jrXRl7ZK5qkgYsD6Rma9q8iLrCAmPlvoQlf1eL4jBQ9zzEwQ03G/fEx6
         RIvQ==
X-Gm-Message-State: AOJu0YwSMFUkUYBe0l60dlECP63nqACyf8JieWqMudRHQqHZ5lOix8hc
	c17XzCYFTWry5RkfdujQiN0Nbg50O7tvmcMk0sOXhCp9BmvW6NICa0ewOg==
X-Gm-Gg: ASbGncvKsJSK+UmPDlhDX9V1m25PLcsXkKxvIXpRnJySXTh+/qjA4Hvx2q8f6RTrLRK
	VDNmQDI4kx8piESV8eoDY0Co+S2pzZbP2TzXZLi62Al5uHkq13emRC434tMWK8k6ABYrrcKjUqH
	JGUalvoT/2F1/hvy0NuegzwPdGXV0/nxwY7A5iNhycnxuCR9p/0OK5sr02LJHM3R/3Fz/oP1iMN
	AFj/zWUm4Yh+DUPIUo/2qg8jKFSJsOmuVsV6mkchHAj6VJYWhlUBdFswD9W6Sp7/1+/CqDKxYoG
	UKNZ8/LcvWCXTnibNvUFme9eUpE=
X-Google-Smtp-Source: AGHT+IGPUTHEygcjbAePlMgod0S11y5rSjn8St/s17LyCOf2gs2WxgP6rpoc2p2mjhEgTa63I2vayg==
X-Received: by 2002:a05:600c:4514:b0:430:57e8:3c7e with SMTP id 5b1f17b1804b1-4390d576214mr18874685e9.28.1738755405792;
        Wed, 05 Feb 2025 03:36:45 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390d94d7d4sm18514505e9.10.2025.02.05.03.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 03:36:45 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/8] legacy provided buffer deprecation / deoptimisation
Date: Wed,  5 Feb 2025 11:36:41 +0000
Message-ID: <cover.1738724373.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Legacy provided buffers are slow and discouraged, users are encouraged
to use ring provided buffers instead. Clean up the legacy code, remove
caching and optimisations. The goal here it to make it simpler and less
of a burden to maintain.

Pavel Begunkov (8):
  io_uring/kbuf: remove legacy kbuf bulk allocation
  io_uring/kbuf: remove legacy kbuf kmem cache
  io_uring/kbuf: move locking into io_kbuf_drop()
  io_uring/kbuf: simplify __io_put_kbuf
  io_uring/kbuf: remove legacy kbuf caching
  io_uring/kbuf: open code __io_put_kbuf()
  io_uring/kbuf: introduce io_kbuf_drop_legacy()
  io_uring/kbuf: uninline __io_put_kbufs

 include/linux/io_uring_types.h |   3 -
 io_uring/io_uring.c            |  11 +--
 io_uring/io_uring.h            |   1 -
 io_uring/kbuf.c                | 172 +++++++++++++++------------------
 io_uring/kbuf.h                | 100 +++----------------
 5 files changed, 89 insertions(+), 198 deletions(-)

-- 
2.47.1


