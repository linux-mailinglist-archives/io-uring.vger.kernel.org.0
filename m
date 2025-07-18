Return-Path: <io-uring+bounces-8717-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82E2DB0AA77
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 20:57:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DB23188D85E
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 18:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAFA52E764B;
	Fri, 18 Jul 2025 18:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YqlWN/z3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1862E6D31
	for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 18:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752865061; cv=none; b=BTdA7A5YcYzK0g57U8mG0TRaH7R4f60hbvvIQ6LJlGs8BqKpmP7qq9z22lh+DYheBj+xnGqWogxJpuzQqKUB5CVmLT3d8CJLfRao/8Pv/0MkyvGnMa8i5QYOiP7o90Jrf4Ya3M0qCnG2Yk6gn4IpffGQZlsj0diTm/MOUOrssQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752865061; c=relaxed/simple;
	bh=jAchxrQOksu95TzuM3jELCNUaXIBdju9tZx77Dm8HjA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=txuLDDprGcvtK8oIew8DyC1Gu28QiPj+/XFsJsEtT9gr32HEfX4yaWeJiVV+Uu4B9Lqs8Yd2JE68gyzvnFRURm+dU+NHikG5239oNo8CNzFmMyQoNINVUeOChbl/PeaREh0n9DNZagUbwzpgYu2DnNmMny3zIAqMhBLMyvwYK98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YqlWN/z3; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6097d144923so5287642a12.1
        for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 11:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752865058; x=1753469858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=USmDGOlKYxG9DM3KWkEp6x/8GjcuvVFZ1V0+QmfSS7E=;
        b=YqlWN/z3AtXFqU0f6IYvdaQiJ59KsmKnnfN/ndgLhII7dSqEMKrewLKJISvTkkH/sb
         MuxB+iosoPcW5yNCH4Oh+pY9Fa+PEkiWn5gj0yjsdj7gXzyJ75nekx/3L3ZkK2hvQNJW
         yvU/Q/l4qlqoOebK7UfYmjODqBGnl6wnwOrZd44JzUpyHAbZjergeiClIjkRwW/HOFbp
         d8uQ5t9j2U9ZwUaEyrMFdUMcNQe+8BvUCiu5OrIuraK7bveROiBDMUJUTxA7rlFjyHcA
         IvVyxHlWNtb/cPdSoXPTg0bL2q2oy+iAjzvzh5+Wvnh72MR7wmeQIXadgmWz9lRpcPwh
         9rFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752865058; x=1753469858;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=USmDGOlKYxG9DM3KWkEp6x/8GjcuvVFZ1V0+QmfSS7E=;
        b=wxnjK4s0GvS+ocv4xBcUo8AZHwWeDO8QLhp1XcQE4Tl970nX0TFV01iJ0dIfy7YMnp
         DcjmwzOyHo+iAywBo2ieOCt/QZU+Uf+X7/WvEhEQCR5DtKmcc/UeETFwqWt0Nc3Khhrx
         xX4ecD5227JyOongew1nLn1KqofxaO76g4epcy+q5nbhByx/E2hkfILT/HN3aBBYlo0X
         q/eaK+m4NEf4DmqANIeoq+xZvsZcpGo1LwA0tw5x97KEyPcHbEs/io3Nl/om4y8sbkkB
         HdRt8kIJWx2PQPsPtY5YF2rmzg6d55S+M4ZOX2ffVZEyqwQ25lCDKIXG0AuTBjM1UA+w
         3e2A==
X-Gm-Message-State: AOJu0YzpT7gy4tvhBawX1iZvo5z91K5hl01zjwSWQEYw1bHADCsDKZDG
	e2FBkBH9+A5IM/Rvgz+8UZ1vfNz/9Zc477C78jQqpNQz3O5ubZBPg9bmQG9xMg==
X-Gm-Gg: ASbGncvu9n8SDW+kApJdvpPq4WFl72CxEealqD5jFEslCg7k+qWYSGME3/NwXly6tTw
	vMIhrn4hsanNrjZGYzn32DDmrKIZ2zircTubV1Oy0ZFfLVlVrU0LVv8Xt9qugJiKpPftcjhTyuV
	2J2dn5vrpDCEiChsup8Qq7mrhaP4uiVFWhGBb/mFMR06egL1XiG0GkIO/KG4SMygQJChIqlp6Je
	4S5tdDvBztIO0dl+qbkMvp8VUP5YagOf3ehaIK1wlj6KIZyrrxZ97iAinjj21fCPfLcHkOlxPxZ
	b6LZdG4lYylTOcPkjUXhAa1sHW0dgWq1MfOfEzm3kQDdpxv7QmiSdOW5JCmlOh6MTLMkXuZsJ5G
	jMZLxxNx1xTU1XrGvCEGNjLiUGTYyJV6OOyVU
X-Google-Smtp-Source: AGHT+IHL69XQUh8gyyOQ4+uN4U9Bzue7VlUec7fX+6E9uV26cOV3Yj2yBwVF+Ftu4fIlTB2AOMgXLg==
X-Received: by 2002:a05:6402:913:b0:60c:6b2a:d170 with SMTP id 4fb4d7f45d1cf-612c0efa713mr3915047a12.13.1752865058004;
        Fri, 18 Jul 2025 11:57:38 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.246])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-612c8f09dbcsm1379130a12.12.2025.07.18.11.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 11:57:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dw@davidwei.uk
Subject: [PATCH v2 0/3] account zcrx area pinned memory
Date: Fri, 18 Jul 2025 19:59:01 +0100
Message-ID: <cover.1752865051.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Honour RLIMIT_MEMLOCK while pinning zcrx areas.

v2: Fix null ifq on partial destruction
    Fix page leaks on io_zcrx_free_area() failure.

Pavel Begunkov (3):
  io_uring: export io_[un]account_mem
  io_uring/zcrx: account area memory
  io_uring/zcrx: fix leaking pages on sg init fail

 io_uring/rsrc.c |  4 ++--
 io_uring/rsrc.h |  2 ++
 io_uring/zcrx.c | 36 +++++++++++++++++++++++++++++++-----
 io_uring/zcrx.h |  1 +
 4 files changed, 36 insertions(+), 7 deletions(-)

-- 
2.49.0


