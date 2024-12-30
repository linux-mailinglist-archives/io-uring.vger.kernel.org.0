Return-Path: <io-uring+bounces-5630-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65BB49FE66E
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 14:29:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1602916144E
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 13:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076111A4F2B;
	Mon, 30 Dec 2024 13:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KZeg64sg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47480EAD0
	for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 13:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735565386; cv=none; b=VPCgdhbFxgMf4V3aSTChlOUcW3X9P/YPisxCWG8Kig8rGrG4Wn7EU6pfQ49+MM5iq/N8ajZ2raBCppY3+6ABVwDwnZJZkSBEpUEMl1mMkp3pZ/dJS8QbkQv/+XL3LATh0P2MMy3kCfuqa3Gufv53ynT/c0h0iWGwEfhcjScLE/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735565386; c=relaxed/simple;
	bh=nSjy4AI23g2UtCd+AQW6v9m5aBdxZ/qI/407c4NOols=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N3dE12G9oT/L4IwqvQ6a1Y5jJVp/If6sN/s87o8TUxW5MbHwiVQzCeIbx2ZzVrXuCKTleYHtVh9CqXCuKzNyfQcNwHNIQXuN3kAxhZcR+quU+Gf+LC2kIWM8wAoZ1GlvrjWY7mSipp6ZqBB+qcAM662Y3uu2rc4DUkcnXb6sn0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KZeg64sg; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d3d2a30afcso16439103a12.3
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 05:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735565383; x=1736170183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9pWnMOP3rfyoq3n9xZKdD4FphJo3XQD7HoHXbRzWi5I=;
        b=KZeg64sg5RryBZLKzKgHrwcYQ28ACyGZ4yZtD6UhlmCutm6V/ip+Yv5Rg85xHNyeAW
         vvBBxLzarhFzFg2ausSlrrq1MHPyOt8z1s+wIWpW6HZg4J53mZmbqowXrvqRkNkpE9rF
         i64sDiKsECh4g7GVy5Yn0uvSUm1MDB0pvz1gDR+w3zXBG278qvEDt9Md5iQtCP+C6yEL
         vNCe3pnqJ6VirCfI2k/aKiuwOzzXT0wya5pgC5faPf/WvCFdpWlZo17qXAJzvJM3Nfcm
         DMXD/Z95jMoH3Fl3RqM7oAaYvWszpO0UxytQ6Y46AdTW6QKb5SDE5niARN1HolZxWmPv
         0Q+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735565383; x=1736170183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9pWnMOP3rfyoq3n9xZKdD4FphJo3XQD7HoHXbRzWi5I=;
        b=LDzXX1wF8Hb8bjt/96nYxxmO2ClL2qHF4HVKUeOCrBEfuS6RtO2bACZdjaMxOdA7RZ
         s6aqlxCSTi6laCRIrOrjynZ+bFf7jTv5fF3O7j4qPQYiPphlLYtZvEqsZVBjKRlibX6f
         PRSIPzv6BL+mSqRUmsI3Fejc6sSaLqyFxkrar+QV7qS2QxOWXAFXke/I8o5tpNGqeTP0
         3hxy08HSorwDCVFoNzFfvnaPkgCm99LwM7cXwhg585hC6rYtmAuc9f35KbI0fuR1D6l5
         LUemRgjUYNX4iMGoe7X3ndY5gyPa7rKNWShM/wiE1EEMN37dxeuMpMYYbhl2liRvp7R/
         LzwA==
X-Gm-Message-State: AOJu0YyQQq395cdpm5+zLfIH4i1GRfrzsWybEFPaWVkJqrl0xsoE8jMY
	qOHtwMoSSOh7O5uVO1Jn10m+NDfVMBdWWMcW6xuQIleYECUYTIXXPAsu5w==
X-Gm-Gg: ASbGncvj8Dfpc0IBjSIXhABjjKHbVeppfyXJ+GXg4/keOzNVltHgA+0L86zr7V64RRN
	WPz3kC+J7zUJ39+Iemz0K9TvDzZB5xxfOlYjOdeDGB0i3Mu66LyCMqFXAIKrPzEXiJoHIX0Lckx
	wkp2mIQScWbjLwrzSqJrXKwRs0CDO2RMkfpRJDo4F8C1HuHIkhXBq7VcLpLw3erCS/2G7680BIv
	ia4V4OEtlHRKY3p709mg6WvZqCIvbVL20AY7XaDze3tCfs0pyqfD0eVK3GWOcgX7+VFOA==
X-Google-Smtp-Source: AGHT+IG6asWF1f0MwF1mF/65acyHBawJ51ssheOgvS7p7s4QAEgrHefwbhBHLKxEcQdFPtkV8WLTMA==
X-Received: by 2002:a05:6402:35c7:b0:5d2:728f:d5f8 with SMTP id 4fb4d7f45d1cf-5d81de16998mr38627269a12.27.1735565382666;
        Mon, 30 Dec 2024 05:29:42 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.209])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80679f35csm14694286a12.51.2024.12.30.05.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2024 05:29:42 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC 0/4] pre-mapped rw attributes
Date: Mon, 30 Dec 2024 13:30:20 +0000
Message-ID: <cover.1735301337.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

warning: not properly tested

Follow up on the discussion about optimising copy_from_user() for
read/write attributes. The idea here is to use registered regions
(see IORING_REGISTER_MEM_REGION) for that purpose pretty much in
the same way registered wait arguments work.

Putting it simply, a region is a user provided chunk of memory
that has been registered and pre-mapped into io_uring / kernel,
but it has more modes like mmap'ing kernel memory. For attributes
the user passes an offset into a region, and the kernel can read
from it directly without copy_from_user().

The other alternative is to store attributes into the upper half
of SQE128, but then we might run out of space in SQE for larger
and/or compound attributes. It'd also require SQE128, which has a
(perhaps minor) downside when other types of requests don't need it.

Pavel Begunkov (4):
  io_uring: add structure for registered arguments
  io_uring: add registered request arguments
  io_uring/rw: use READ_ONCE with rw attributes
  io_uring/rw: pre-mapped rw attributes

 include/linux/io_uring_types.h | 11 ++++++++--
 include/uapi/linux/io_uring.h  |  4 +++-
 io_uring/io_uring.c            | 23 +++------------------
 io_uring/io_uring.h            | 16 +++++++++++++++
 io_uring/register.c            |  7 +++++--
 io_uring/rw.c                  | 37 ++++++++++++++++++++++++----------
 6 files changed, 62 insertions(+), 36 deletions(-)

-- 
2.47.1


