Return-Path: <io-uring+bounces-1442-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 925CD89B4CC
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 01:55:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB8EC1C20B0B
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 23:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E117F1E535;
	Sun,  7 Apr 2024 23:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GEmeg2b/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C89944C85
	for <io-uring@vger.kernel.org>; Sun,  7 Apr 2024 23:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712534105; cv=none; b=uTE2DErISIbPxl8heSlsIecsdZ8cjCIEo1JOAN+4/j9Sq56Mc6hauayLqCp9oxT4C6/naYnTKfs5j/mWPtFNThU3Czte7ejmehIgHTPnuDhTnxWIX+JdR3tdwZ8zyJ8ZFL2aoitbbPhnm3RYfBSsi4GjJYKuSI1Bg19Y0uPU3fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712534105; c=relaxed/simple;
	bh=TfrJ1yWXBwXR28fTrAcz1xFtU+2jHlAoEtQonFIUZUE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pxz+lhsb1PDiCYG3yuutwVKiwt9pvjsKv6ZBenCkDnJoi/Luhww0ufXpFyRHGnm3FK+AK8rblsE8TwBNkA5gKNur/V2vFQU3nNr9U10sb5mIVKTHYARmmWUKn4O/AfxVdqiicn3qz9W1yZYAQBLzN8tOgVvmmfX0Ykjn66gjuD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GEmeg2b/; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-416664dbee1so2502195e9.0
        for <io-uring@vger.kernel.org>; Sun, 07 Apr 2024 16:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712534102; x=1713138902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kXxlt1L88FQomo3TodYQneDFssODIhM2BeTxZYU/xOw=;
        b=GEmeg2b/rM8pGQinl3Udd+WF4pQd4cPTX7Az+/Os4A6cIuQKp2nZzmX+lLj/6CfVZH
         R54KF4+lNlgmP7sZr+lm6jrsKBdlgXkbW0/prsXW2ef9S3vke1GCxMfU+uStca7blw1R
         JOYlFxZhOZrGH0WV44q47Q2W7KHIDhxSVBN/WOhUDE3yaFyGHjjjPu2TgfJoKZAHOc+C
         /otTYvkB0snxoa27us7OmrMcXxZWtUsKul67nvKORk78FAmqvz0ti3B4a+j8KGVzUrrt
         VG46AY2U3cj3NZWJtRUaBJLv+uIYYI9LJlx1z0ndDtJuQ6L1sF+8PYoiouKWw+IRb0Bc
         1oYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712534102; x=1713138902;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kXxlt1L88FQomo3TodYQneDFssODIhM2BeTxZYU/xOw=;
        b=tjbvBuiXfKW0uIdSoOMtvH+UUWvAluqstgcun9Xvp1qvsD5kp6aHpjMzH3nuWzCVWV
         cwVD1jGQwCwb/hYcr1pK5qVytaNCsfZsiFgonlzn/aaOebakUmtMG2qXGKAHFOC8NcYZ
         0WeM3Dbf893tJYqfrVZyC24Szdmh1BrQtK9BFyg9XlqKh2xsFggAke9hAo2H+RFAjgfn
         GfDiXJCAuv0tw7Iw8lHkQBfj/Xvrrojm+qhz6dHSw1diurbA3Ak/w/wYKj/SoNjUxydG
         H6mSey4qEqwaOL0pCxqxERqjeoftxziasreYU1+jHbpWwDnVdEFBWvyI/C6szhG7e/Zd
         HZDQ==
X-Gm-Message-State: AOJu0YxHGKZdS72n/xmtktnsXvPa4/4nwhymIC+B5QAIF5A7QfrUgpAl
	no7HoMqZ+TEVwLd7Vhf5+/mt7LSUzxqXp1hFPWZuAFOC4cBhVDvQNpZcEdUU
X-Google-Smtp-Source: AGHT+IEbLbvQbNMsPyaCVsf+Ve9Lpq95ATrkI91sn5/ppN2xiUVcYCZSjpftmxpBXpIMMbRQ78hGuw==
X-Received: by 2002:a05:600c:3149:b0:416:8091:ba4 with SMTP id h9-20020a05600c314900b0041680910ba4mr71548wmo.6.1712534101868;
        Sun, 07 Apr 2024 16:55:01 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.79])
        by smtp.gmail.com with ESMTPSA id je4-20020a05600c1f8400b004149536479esm11302917wmb.12.2024.04.07.16.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 16:55:01 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next 0/3] sendzc dedup / simplification
Date: Mon,  8 Apr 2024 00:54:54 +0100
Message-ID: <cover.1712534031.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consolidate two pairs of duplicated callbacks for zerocopy send, which
was a premature optimisation, and it's cleaner and simpler to keep
them unified.

Pavel Begunkov (3):
  io_uring/net: merge ubuf sendzc callbacks
  io_uring/net: get rid of io_notif_complete_tw_ext
  io_uring/net: set MSG_ZEROCOPY for sendzc in advance

 io_uring/net.c   | 16 ++++++++--------
 io_uring/notif.c | 32 +++++++-------------------------
 io_uring/notif.h |  6 ++++--
 3 files changed, 19 insertions(+), 35 deletions(-)

-- 
2.44.0


