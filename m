Return-Path: <io-uring+bounces-10571-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A2D3C56FB8
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:49:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AA89D341C9E
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D343375C2;
	Thu, 13 Nov 2025 10:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="du33CBkH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BD13370EB
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763030787; cv=none; b=BqbdcE9568wGJnDpMz7lLIQFzynurinA1Hi5TAq4c7yFeqtLrwvUmvXWpceiM4CrMohFKZflLReLPdt3UNzTKsNRZajwX3kAOXLnN68IN7kB5FX1kvbsi8AAzS582+H+V7xhbHqgOH5Kj55csqujsAIhG2x44FuTMHRLcHOzwsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763030787; c=relaxed/simple;
	bh=RChdl1eJd7KY+noSvCnJ/Qu2STwchfhjBNa5XjsTWJI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fFN5yu09INVrsAD9vdt4IZPsWJUt4n9+9jHdk2xd+lMNbvY5lXbkRr5crpDEGYae1qsEx4x4l7OPIiksWpZC5xX138qKVHr/Igmw4Bf2igLio9UCHqaz+QF2CSnliFBflosLMADcLX1dP4cpD897l4JTwxtIgteJNrcgMa4SMxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=du33CBkH; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4775ae5684fso3377625e9.1
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 02:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763030784; x=1763635584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4qOs4GLQJ2VFbWu//EYJrZ/inCwLhP336M8hfSCkQ8A=;
        b=du33CBkH8GbN+b8pAi1eSHVK8rQe0MUpF3Pb25i0Dj112YB9iBGX30nKpajvtC57fE
         icgP1xgn7dmfCKUFQexgoZ28Wuq2hlL9bDvnLYoLkeRR4Poa/OgXYr4z6YYkb7JSYKuG
         96hKHYX/9+yaDwnT4oRkC69JHCfmI8j7Y7uizvZ/6eqlJf2mRmcOIEoQ76QApOEb/0k3
         QVldkvfbKKQBAfpZtEY1F5/3W6x9yBYDZzbsj+5AK+le6kUjW+B8Z+IZFol7iMxlQulG
         YEz+npArF6c4QTWNnCzUrijnHw16oHBr2Ucb/Kjc5OmMW0pWauo9v5gf2GZRhB4AkPEb
         AMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763030784; x=1763635584;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4qOs4GLQJ2VFbWu//EYJrZ/inCwLhP336M8hfSCkQ8A=;
        b=jlRunKYzdHHP2DhW9n5jz9OFdcjVT5HfhLigC/txqck6Mk3EIMBPIhl6y6n+jDjCNy
         mdqsFQvJrebtoQjD2QV4MjV/wXl2msAX4EdCrl/X3hdvO3CaKhnmTfwIvzI4NevHBepM
         eduIf/LujmmhBApHcpRojiLrUXWIIoxLLjcvD3GYb+uAKdL6jn5vRHhklhXyoaArJ8YE
         K7nE5Cqeodb+2w0W12N2PgNa59W5MdJaSpans4FLQax6pcFtDnRLKZlfB4tM9zgC+BD/
         yHjczVFga2J62aWeGFpk3dSWcAnDuDsrXRuZMDMVL9lZC00nLYbkSR1NKHWOr84RInOK
         rNKw==
X-Gm-Message-State: AOJu0YzgmbzE1QGQsTu1oh7SnnK5eeihPkaSzGolMYDveXkIZNznTuFA
	M78rrUfb/TZjLboqDTPsFxs+gQI8k5DM2FPO56tHdmaF3Erpj9L5YDgFYDyVsQ==
X-Gm-Gg: ASbGnctXGLoSNhhqvcNsbc2teRxI5zH6Xp/dJHD73v9u/HrronCqjhjck/jqSPShWzb
	bbpt+3+9RHicUJocfvuGhLnqgdMTt45+fqlHCDzsCMROtCZSG8vghfseF1p5GD/tBisrxdWgUem
	XyX9owMnh1SrE5l5zeP4xs+jfDG9pi2YBxV60zkNyL0esmscMrS8huc6cdEOtFXc9B7oolCoaMm
	cQVPEze2IoKZsZY335+r05lpFjq2Iv9ZHR4tqQItVZGyGgcwr4+mP33dmwUkPq9VcBeKG5E3TsP
	/+9ev9R+c4ebYSPifDNBek9cJjsLSWoHYnrBwRjpkiCxEbeHKy42M6avDWjmzBSfk1N3+BJgFB6
	RjkIrjLcaV0iwKZ1SZH+rE92xjAwc2R2kfRqPHW/RHZLeW/T3MyTai0dGyQk=
X-Google-Smtp-Source: AGHT+IHJ4zr/CWZnlRsOE13f6bVCWWIvaDS08niPPy91dFQIoYsEP825VBFnjCRpzlHR6+C6tBlJZg==
X-Received: by 2002:a05:600c:1f91:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-477870c657emr57235695e9.19.1763030783588;
        Thu, 13 Nov 2025 02:46:23 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e7b12asm3135210f8f.10.2025.11.13.02.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 02:46:22 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 00/10] io_uring for-6.19 zcrx updates
Date: Thu, 13 Nov 2025 10:46:08 +0000
Message-ID: <cover.1763029704.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Note: it depends on the 6.18-rc5 patch that removed sync refilling.

Zcrx updates for 6.19. It includes a bunch of small patches,
IORING_REGISTER_ZCRX_CTRL and RQ flushing (Patches 4-5) and
David's work on sharing zcrx b/w multiple io_uring instances.  

David Wei (3):
  io_uring/zcrx: move io_zcrx_scrub() and dependencies up
  io_uring/zcrx: add io_fill_zcrx_offsets()
  io_uring/zcrx: share an ifq between rings

Pavel Begunkov (6):
  io_uring/zcrx: convert to use netmem_desc
  io_uring/zcrx: elide passing msg flags
  io_uring/zcrx: introduce IORING_REGISTER_ZCRX_CTRL
  io_uring/zcrx: add sync refill queue flushing
  io_uring/zcrx: count zcrx users
  io_uring/zcrx: export zcrx via a file

Pedro Demarchi Gomes (1):
  io_uring/zcrx: use folio_nr_pages() instead of shift operation

 include/uapi/linux/io_uring.h |  34 ++++
 io_uring/net.c                |   7 +-
 io_uring/register.c           |   3 +
 io_uring/zcrx.c               | 326 ++++++++++++++++++++++++++++------
 io_uring/zcrx.h               |   8 +
 5 files changed, 317 insertions(+), 61 deletions(-)

-- 
2.49.0


