Return-Path: <io-uring+bounces-2586-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B9193D50A
	for <lists+io-uring@lfdr.de>; Fri, 26 Jul 2024 16:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB97E1F24819
	for <lists+io-uring@lfdr.de>; Fri, 26 Jul 2024 14:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D908101E2;
	Fri, 26 Jul 2024 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YGH5Z2ee"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642AA2582
	for <io-uring@vger.kernel.org>; Fri, 26 Jul 2024 14:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722003847; cv=none; b=HGvEMFzyK6OEgAnNwL5B59ro4/NyXasrrTPEXiX0snIpzACLP0cPsS1huRZVbIrBhh7+UxypJWn0o7tdPj0xZkGOum+VVTHaROLurHf5Qf6w87BU1klLw00qjDGoFZPcbW6Xqh0cgHkGSxdyr8tSnMuy2h/teH8S1BWpXpN15W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722003847; c=relaxed/simple;
	bh=G+tvjnVTeAdZxt/YRwm0sfqsp7J3uVSRBM+Zt8mf4kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g6lAwfAa0ybIortFdiCtGGVXRYVx5MeWHIhN9WyVGre6zKfJvU3jFWo5F6CrqsCQ2qo+NB8BZsRd34hnWniD+H3BbJ1xGht+LHmJMv9KudQAdjP9WkxzlBPYNiGBwaHBZBDUl1REHlhY7tCzWHm0ZsFxNYKoBs1aBOd17bdDHbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YGH5Z2ee; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-36844375001so1234222f8f.0
        for <io-uring@vger.kernel.org>; Fri, 26 Jul 2024 07:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722003844; x=1722608644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tQCknSRJS+aIykaaZA4K0WlehaYwyWJ0RWLx5m3TVxg=;
        b=YGH5Z2eeGt263fkzsfj6QeBPsBhvWTgbOUfxZ2trRWdz23k6vYUEosL3fAePZRB5wk
         NCkqIimqoFvXnhLHx2MphX22h8OlFFExba3LPowhp2kUtRlTKIT2yy+A6vqfJ6oD2sT7
         K3Y4Sva8DA2RlPUL23WxW/LwVCOifoy9dDVOpn67/sPuOmuM6QzQNhjfHXBDIHU0mbGd
         zTNanqHwYLLHQjKHlJRUsieDf4qG7rPQs1etIKTObvYKLtCtHbSPkPcXeFTE8uTPp9fg
         BBC7Y9WOg2LrYJq6FLnOvXlpO8c/OcX7xUtYs0M2ZFh2ZoiLdqUKIEfKPCn0dyP1/D4/
         06cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722003844; x=1722608644;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tQCknSRJS+aIykaaZA4K0WlehaYwyWJ0RWLx5m3TVxg=;
        b=wchERdGkBmHMYor/QOu6Mszn9ZqsTUkqAUpI78jMagSGp+YWkSMdyppUrWS4XQlmTH
         v0OQn1TgJf0iHZfz+VhPNID1JleoEy7mBdXpmtgGmH8cv6XG0ptovhDZI57QbEc0z/5i
         53naLiHoE5eWXN8KnRA4XZ0m4R0VTE/zyxV712wPfhj+R6gGWXrvo/k22QOrj9UEUni9
         052E2yC/+37gybDDq9LpZnSxlZvN8qMNzOxktRue9ezO4KKuygtyCkiECiMDt82Q9vff
         o1w8VEOXQHW+oMvPvxPqk3zdgI9rO1w/TNdN1gK0+WMQMQ5c0pVmWKYBdyGeOGvKbkCq
         rksA==
X-Gm-Message-State: AOJu0YxGk88riZeocqI2yPvo+M2/T39YUQH4BVB2mUioxZNJhTmDfV9v
	xVf+7YV2cBBXaO42j8cqnPo97gWS42087PwPE3mc0x42WxLPCkpYdACCzw==
X-Google-Smtp-Source: AGHT+IHcvuebavMoSSvCv5BAYr8Q1nZTk3jYAJ0Awumgm2nS0sn9hDwBD1Rf4w3GrAHZPouBJZSL1g==
X-Received: by 2002:a05:6000:1868:b0:367:9575:2820 with SMTP id ffacd0b85a97d-36b31a417eemr5668324f8f.45.1722003844265;
        Fri, 26 Jul 2024 07:24:04 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.204])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b367d9859sm5263706f8f.28.2024.07.26.07.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 07:24:03 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 0/2] improve net busy polling time conversion
Date: Fri, 26 Jul 2024 15:24:29 +0100
Message-ID: <cover.1722003776.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Time conversions in io_uring/napi.* is a mess, clean it up, get rid of
intermediate conversions to timespec and keep everything as ktime.
Better than before, but still can use some extra changes in net/.

Pavel Begunkov (2):
  io_uring/napi: use ktime in busy polling
  io_uring/napi: pass ktime to io_napi_adjust_timeout

 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            |  6 ++--
 io_uring/io_uring.h            |  2 +-
 io_uring/napi.c                | 58 ++++++++++++++++------------------
 io_uring/napi.h                | 10 +++---
 5 files changed, 39 insertions(+), 39 deletions(-)

-- 
2.45.2


