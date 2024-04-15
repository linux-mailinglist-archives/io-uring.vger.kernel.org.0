Return-Path: <io-uring+bounces-1546-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA738A4FEF
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 14:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 067441C20F6A
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 12:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 730DD1272AF;
	Mon, 15 Apr 2024 12:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8BAxX89"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB4A86AE5
	for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 12:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713185413; cv=none; b=J9ay37mAFlKSThaz263sFs86ULnIDq2Qaninq2h8gEUDk4/F9S/fcUe57MOZyHRJiD/BMKoN2ygHqEJcU1rA0LrwKWPlrN99PuOmlGdIqRBLx8Zhy5AG2Sk2B33F1Ufsc40q8KijweIVVNVvZmnUcJxYmXeZWfPZb4H0O3PlI6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713185413; c=relaxed/simple;
	bh=VMBy32ykBU0GOfpo83TvBnSzn8qgU4VJ1KGWwE37FNE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ahv+1CqvpqnRfixCl0nZoehUB0jVhRP+qAmTLRssyGmmY4A8G7MKysPuBHyZ+spWjNLA/z3iRJAnhAlk8l5dad7Hh99Ifnh3KtWmNWes4Y2aOLj1h3PB2/L1bE9MKKpI6koYTCDDhuu0UzR88DY/uzmab174DEotmaW2A/ODbwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g8BAxX89; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-516d2b9cd69so3720435e87.2
        for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 05:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713185410; x=1713790210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D+jqCnhI+Ec0n/cAxn3kiKtq4pZRj4GjpUjzbbntS5Q=;
        b=g8BAxX89LB79gqPJX0Mct1OSMC6zJqeI/r2jSmZo4R/Bkc1pQsYtqTX3QZMmHBmm1v
         NH8wQ7q+EjTakpQxH9mQAvsZkjPEUmDbSxPVcpCx23ij77Oev8sz6J1JsKOHr+6j7km1
         /8ckdk6sXRwqhKMCC27dPy1ZP0EkVmGc4GOPfm3jL2qtgTtbufiiA5EP1w91xW61OGlu
         HN/K3V4QeuBdkQRIjG+QyPsLLwOaRJVLSaN17cmj6FbPzCBVLn4dJtzXMdH7iBcrm0gw
         89WQ1nUo7xUcQCH1Z0Mxv6+bpgwBZHA2Nqq94O3JXr0n4Cat+zXEM0HjCzlwM6qYw9rM
         ghnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713185410; x=1713790210;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D+jqCnhI+Ec0n/cAxn3kiKtq4pZRj4GjpUjzbbntS5Q=;
        b=Cfk1EeZ1EVthvvV/yvPyHpyGqcZQU50wQWqCJM5hLHJS1GK0IdCqT8eHMrWMd6UAI2
         jOBcnO8ZDLe0FdcSr+8108ubqipcC78Y48FTtppawq6JoMeKlmBwARGS8OI0uNY7W2tt
         1nhyGzcx/t3aHoFliAuSypbJ/wBukwYFPuppmX+6TPmehFbUJr4826ZHaiqB5wwlBIBN
         bdce9+nHC92NYYKg20pQ05dDelSNV5oYl5+wEHTBlI4Bt7PdhTnZBqp/TQeLa2tLn3+b
         ZSpr74YP7RU4SdTKx+QNZDuEh1OWsAr0BhaLvvaMGfN24wjwdtqE4JXxsWAEDW8sL2BB
         oYNQ==
X-Gm-Message-State: AOJu0Yz7n9otftMgi5Jd/7Geuh5e+aUGZsP230X+d/WwQRksGZkXLQB+
	EN/DoEOIbdQMHqDP6/IKxqYFsa9w//v1WIuVj59EETH3kKvX8F9tl5Ux2A==
X-Google-Smtp-Source: AGHT+IETf4atcALa78G1FN7b2bN7kozJXIHw7wHUQbWG7aBZ/aLMZS88rsrNLRYeDbuBEFrN3ZNhJQ==
X-Received: by 2002:ac2:483b:0:b0:517:61b1:45a6 with SMTP id 27-20020ac2483b000000b0051761b145a6mr5514096lft.53.1713185409698;
        Mon, 15 Apr 2024 05:50:09 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-213-93.dab.02.net. [82.132.213.93])
        by smtp.gmail.com with ESMTPSA id h15-20020adff4cf000000b003432ffc3aeasm12022170wrp.56.2024.04.15.05.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 05:50:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [for-next 0/3] simple sendzc cleanups
Date: Mon, 15 Apr 2024 13:50:10 +0100
Message-ID: <cover.1713185320.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simple SENDZC notification cleanups that make sense by themselves
split out from the notif stacking series.

Pavel Begunkov (3):
  io_uring/notif: refactor io_tx_ubuf_complete()
  io_uring/notif: remove ctx var from io_notif_tw_complete
  io_uring/notif: shrink account_pages to u32

 io_uring/notif.c | 14 +++++++-------
 io_uring/notif.h |  3 ++-
 2 files changed, 9 insertions(+), 8 deletions(-)

-- 
2.44.0


