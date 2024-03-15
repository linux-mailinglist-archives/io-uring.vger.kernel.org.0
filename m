Return-Path: <io-uring+bounces-984-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D581187D65D
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 22:47:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DB861F22843
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 21:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCC154907;
	Fri, 15 Mar 2024 21:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aM7/Lvaf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA0846544
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 21:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710539250; cv=none; b=dbHTe05lnFxMYlaiTWHHnTe7CkzSHzlBTnrNANcSHW0vlUy3nANLCTDEQ2pcV2u8vhq2fCk+qQKnKA1bascI2bKw5Qvwnr0jekX/2nzmkRmpWqyRlNjhWOg68YynuV0W9FbWxjWhjuS6Hlh9iK9CQ2Q1biUcMN1Zl6gXD9mdE7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710539250; c=relaxed/simple;
	bh=uPE7aV9GefvhX1V4bJNjc1KeQR+qSen/k+wI8JlhyDo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h6W5AZI6pzLmz/RqSEwplReEXWPFaf+lE0pa7ONqcf7uyD0UYx72KB6liwyawn7NQ7ihQMiS5GQL7+VyAJ1HyplLit7mx5aGpFMcvmILv5T8jE7+tK5lzPQHVyL62wQ3X1p23Kd7Ue3qrFC6P6t0C9Z9/uhTRWFh6eyXnrgOj2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aM7/Lvaf; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-414037f3767so5871435e9.3
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 14:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710539246; x=1711144046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=prlwCZjw9WeCq6aRZMxskP83w8JVeeKkc7Hc4ODh57k=;
        b=aM7/LvafmqPpIj9x1575Y1pOQ1Id9GzDLtFXxVpwC+N/x0MMWNNVcF8tVAg1l/Bc51
         8flavZrJOVfZ59fgZ9gS8mnazVxl6keU6lforSmarI4P6F+yT1HzN7kKFFAjE/jlLaVl
         Qrm74SzqlDE0fYWRqTIukU+drGzJafb07NGfIE2j84MpFrQrjsSYShJrqpuN18A/xo96
         dg80W1JU/xISlh7CLETkd09fpd/llvK7yq/5WI4khqT7OCB3W51d/H3fVHkbjYD9E7GU
         2UuqBbGQ0cldvTlhJsn0ZkZzp6HqwJu7xkbUaDb3XxGC8EkAWjWLKvspa3TUhq0yB03H
         SDbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710539246; x=1711144046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=prlwCZjw9WeCq6aRZMxskP83w8JVeeKkc7Hc4ODh57k=;
        b=IztC705afFUgR9oxo9kaGuhcC0Kh1BJImVJ9yFqLC01D+bygFNLX5pHQ6IcMAw1dXi
         F+AMQ8JjpZaQD0JvfFEvkX2QfVzmKFPnyVRL1WhOrM/hM1NJphCzsVHiFiMFcRmejzPq
         A2lAQH1Fd+4ipT8AO7JyM4OjPSSbLCk3TG64we7c9o+AHu/3akHAKCOINw7QlnE6R9SQ
         t3Of9DXQ6YBMJ8vMOHgYXOegC9jBbKnK5IISjXUKZNE3Bw0PEaEzgqfijPOD5hKQpn/o
         DCg8NUI1KlRImPwVgcBTO8X+h7ysn75QDP6tlrThqInFogf7YwgDb41wP969sT6Q65J7
         e5/Q==
X-Gm-Message-State: AOJu0Ywu2iAOCnkXYDMhSvSK+M11A4QQqxlHrbeLIJlPkbUfy+a6tS04
	7CsIpb2SrN4cZ7BNDyPpw3L8+tUwwcyMNDo2uhRaEwv3vpa5IZO/I52BhfsK
X-Google-Smtp-Source: AGHT+IHdzXFAMCPblwKT+EdHyLP8rtjWgTgls/4p/7VK20F2ZzlOL+EUqby/Hkg7lhh2fRiKPUnwmg==
X-Received: by 2002:a05:600c:35d4:b0:413:2308:7d94 with SMTP id r20-20020a05600c35d400b0041323087d94mr5099681wmq.20.1710539246376;
        Fri, 15 Mar 2024 14:47:26 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id m15-20020a05600c4f4f00b004130c1dc29csm7040881wmq.22.2024.03.15.14.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 14:47:26 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 0/3] follow up cleanups
Date: Fri, 15 Mar 2024 21:45:59 +0000
Message-ID: <cover.1710538932.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Random follow up cleanups. Patches 1-2 refactor io_req_complete_post(),
which became quite a monster over time.

Pavel Begunkov (3):
  io_uring: remove current check from complete_post
  io_uring: refactor io_req_complete_post()
  io_uring: clean up io_lockdep_assert_cq_locked

 io_uring/io_uring.c | 29 +++++++++++------------------
 io_uring/io_uring.h |  9 ++-------
 2 files changed, 13 insertions(+), 25 deletions(-)

-- 
2.43.0


