Return-Path: <io-uring+bounces-2612-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AEEE094219C
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 22:29:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65BD61F255CE
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 20:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A067D18DF7E;
	Tue, 30 Jul 2024 20:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KzJI0f2P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD8C18CC1E
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 20:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722371366; cv=none; b=G4sYOQJ/jYklcefXF+cxbjtCnpnRgUutWY2hp5KepQAVCa54nFvL6mdlpy9aC7lS5jAXXgTDh/t8M5cZj3C3VUzGiGKIbN/uknR6UiBn+pfIxsvgpD+Fl1wFHSkJ+UBDzt7NDc5ofyCOSChRRGOcyWj8wMAxo7fXjhG1oGJDEno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722371366; c=relaxed/simple;
	bh=c3801jLdH/1RbBABKsaSiWaWIvp5PrQ5FvH8vDiIjIk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QlLNqgwVB8rMaBIkKSTM4Yy0AYtJ3S4bxfGZmw3GvNx2iz2NeaBzkr0CInCURyYBIqsrJaZDm2umW2KVGoQXFYDWrxRer6CvVaXX/YvtVCUqn1lcmxvzqiyACGaRx173Yj5fXt4cSWYCOlTOUusGqNu1vFYQT6a+XnKsuY6lOmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KzJI0f2P; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-427b1d4da32so1410735e9.0
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 13:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722371362; x=1722976162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4sHjJzHlm5Y8LAQhsTsASgjiaAZ1/NqQKB6IobJPuGo=;
        b=KzJI0f2Pd6DIeCqPAmIetjjXbg0qyPvbD3yWhVVRWGwvbIIC2eYR78V+Jlnge/Ag/L
         89EbgYtHxY3uXzoChXJD8sFaGIVLTMIkteqBsvOiepF4VQfCmOhz1Bgdh10b9Vje1R0C
         PATMHEWzc6yLnK1qz+h9U0pbyNzMkMWQ5ggoujtMeYbMbHrMLEVst+FSnO9nlJw3z+e5
         xHve6owjJQ+ymvj9cLM9RTDY6648kK9v68cDjVMQt09z2r+AsKhaDyE+zK1NFmzkzwPT
         wCCWwgZomRqJ678JluTiqrAV0I+IJnSiUS0Bw4pvsOr6FhrjS/hfH7eruc+ibA5/LUA2
         8rsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722371362; x=1722976162;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4sHjJzHlm5Y8LAQhsTsASgjiaAZ1/NqQKB6IobJPuGo=;
        b=BFnl2umFT/2Ov0unCiuA4sD+/Nh1duOwsW+r3LEBbsDdtbonSQdsUS1SFDvuL2gS7F
         kYwqBUb6oZzYYszf41c/kx3iWajsgrgs1J3QXq+aHBzKI4yWRpsfNDgf2gf47dgstuPW
         VulS/K9PxBbOTFc4AqaBGaq1yrYzM+eYjIe1AlY4CR/jCxYSdFGGhPFDwy5ln92DdgqA
         JR6gDkwmbDTWZ/uI+d/iN/cPu1wW7TJPuUKzr3oszruinV4m4Q/pc2EPHYYX516LDrGh
         AFFnRIbcENFex4To93qP4sssxqH2VovGc56g/91Zq+5Y387QC1AVNBl0f5AqF8WF1T2h
         Fp+A==
X-Gm-Message-State: AOJu0YySzjt8rxPmLUJ1J5fWTnCSq/JwdXMkNhx4BnkWHnDO835RhrR4
	Xy1DSfW6lQ+9PrKlIra1+DQdiiqOaAnd5N1NzTvmE0V0I47K9ky4pMwl4g==
X-Google-Smtp-Source: AGHT+IGgfCo6veuX3qjGxiCPXC4XkUnIMatt/jHdJoUDtV9WuPYzWfqw+4avRn1P88Yvrs8mvwfVHQ==
X-Received: by 2002:a05:600c:198a:b0:426:5fa7:b495 with SMTP id 5b1f17b1804b1-42824423ba0mr20340145e9.15.1722371362011;
        Tue, 30 Jul 2024 13:29:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42808457c7fsm214488065e9.32.2024.07.30.13.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 13:29:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Lewis Baker <lewissbaker@gmail.com>
Subject: [PATCH 0/3] Implement absolute value wait timeouts
Date: Tue, 30 Jul 2024 21:29:41 +0100
Message-ID: <cover.1722357468.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patches 1-2 are cleaning up timing adjustments for napi busy
polling, and Patch 3 implements the feature.

Note, if we proceed with removing the busy polling adjustments
by the wait timeout, it'd make sense to merge that first and
then I'll resend the series.

Some tests I'll be sending later are here:

https://github.com/isilence/liburing.git abs-timeout

Pavel Begunkov (3):
  io_uring/napi: refactor __io_napi_busy_loop()
  io_uring/napi: delay napi timeout adjustment
  io_uring: add absolute mode wait timeouts

 include/uapi/linux/io_uring.h |  1 +
 io_uring/io_uring.c           | 14 ++++++-------
 io_uring/napi.c               | 37 ++++++++++-------------------------
 io_uring/napi.h               | 16 ---------------
 4 files changed, 18 insertions(+), 50 deletions(-)

-- 
2.45.2


