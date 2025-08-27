Return-Path: <io-uring+bounces-9303-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CDDBCB38398
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 15:20:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9ED11B65D0D
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 13:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A998F2F9C39;
	Wed, 27 Aug 2025 13:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jFrN6FsB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FF31BCA07
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 13:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756300798; cv=none; b=HIGru01PAKEz/oQGFdVphMFUW5gr9xQVCJ9LVGbTeShumPr/3j5TwsJvDNHQNlCHKNpwk4GOrkQgjbEyooN0A6IjEL1lB2qbL+o+u/8DmSkdgOMIiiZlbP1flnVid+xHHevj9NYSCphpcU9umvbihEDGqGhfb/RD5zqOJ4AopxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756300798; c=relaxed/simple;
	bh=y3kSDpwuIuxUDIH6lWM+N9+ojWvzdn6aqoG51IfsK8g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kB34UvFGVDRTkZ2By5yiLnuDX+vSclcJvjuR8BD6PlpIQZ/2u9sRWZOyE57ACuW+tISbPtwOQ9W1+WFj7bMS7vy6C98PxdmvU5KYacENzH+sOKwyEfRYM8dFGTviDAWAplHNyXFkgG0a8ypMA+7NhxXp3g1irWYRaCfE8ZsYjSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jFrN6FsB; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45a1b0d224dso36132635e9.3
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 06:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756300795; x=1756905595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FIgkQULK45FX4ksgaBL3inMv5m/PqfcqdOHKVOvyVRA=;
        b=jFrN6FsBBzWzjpUszSEqCG4QvzTD3nvta9GDtJk5r54k2GsCNZ/xgg3NlU+Up3zCz/
         UwuVOnSZX4EOCoLkt841v+qUY0LwCqwm5TxFFLKxdLryEr+Qa7hJgCPMaSx0UwDicARD
         e0tlhQje+0iifiB0pCnBoTiNAaw8zmFLRAaBgSRlFdPlNMAIjjm2Kc86Gjuu2cZhOoJJ
         AfwZpk7mWQDQI3YuSwKrNKudrMbT28bqj4Jp5T31AUXYENke6OuKI2KwdTQwreJ3vFmY
         uSRxq7hrx5MKRCG8Rh/CrIjuX7Z5Ae0WalJUHk1xkCctXTpAYj/x8RKJm6pCinF1P0BU
         1LBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756300795; x=1756905595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FIgkQULK45FX4ksgaBL3inMv5m/PqfcqdOHKVOvyVRA=;
        b=pWTgZyM9IMeQra6cVl0n4AwdKw7dQnzbAQhtd4bWcL/r0VZwJPIzFuK2knUvH5LA3z
         hsA9wnSYowk0LhGNIC5TIYr6/1sI5dOX+Qm6Mg/Kjjc4cSrpHkqkgxSnGY3r7G/+/3LJ
         6EponcbUI7l63RN48d7tC0ZHwYidg+ZY+nLsRgirbyNGDEj4UXiwyaBbZRhDpL45zBFH
         w1pCcUznOcSPbh1rWft0E05b6tFuQzm2gh+qpWr/yqzbHpUAmBQ2tq4udsi3RHx1Wguf
         OLv/b1f8khRqxDDGo0JnCkt6T5O6pFCL8JHZgYPYauk0kUJ5pzOdUSapnC+mzaCGNw4l
         OIoQ==
X-Gm-Message-State: AOJu0YzUlR4RRMXl3NOuPWnLI2PBcj1uEi0OtuUW3c6RqvtIoQgvLFvH
	ih6KfhMq5vifn1L7zNZzDti3zf2IeV9sIc7g4nrnSgyQlXJBx70j0p5/Q2IR0Q==
X-Gm-Gg: ASbGncs3rApzoH3e9D1MdtXvPNMpL6saXdAl6MLvIon4VGMMQ6G0d7cokule6XNF3IF
	XlOzm6blWgWOm6zYUTxQzWYNgKfhpHRgnGlZq3fyTFZZ7ONeyB14nt2MryeNg9IX7Yo6xHI+Esb
	kRImUc+KNkO1Va4rsJ96/JMFVQEEoCwXDFd5gRAuf8Gps3NcH65lttfZ8WhD3CjYAdAnLWbPNdR
	gnqLpJL5VxXi/RoiI7vvZEr2NRpkSrHlRm/UjhNttV9AJcdEG35EBKFU7PvKe+C3/9V7tJwWKqj
	Itg/rAex3LVZmc64rUfKv9rlecwpObKUrR4sNJ1AIdKhkwDZjNMF0aHrEWNq+dVqOyWh8D4zr6F
	R8JbAyA==
X-Google-Smtp-Source: AGHT+IHlk5V1aEjdquWkLtInckrejpgqWxJRv+tl5P6i8+NBqj2WO43sIWJ8wCLjtpuMNcXkJ7EblA==
X-Received: by 2002:a05:600c:3144:b0:45b:64bc:56ea with SMTP id 5b1f17b1804b1-45b68229282mr57319645e9.23.1756300794637;
        Wed, 27 Aug 2025 06:19:54 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f306c93sm30170305e9.14.2025.08.27.06.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 06:19:54 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC v1 0/3] introduce io_uring querying
Date: Wed, 27 Aug 2025 14:21:11 +0100
Message-ID: <cover.1756300192.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a versatile interface to query auxilary io_uring parameters.
It will be used to close a couple of API gaps, but in this series can
only tell what request and register opcodes, features and setup flags
are available. It'll replace IORING_REGISTER_PROBE  but with a much
more convenient interface. Patch 3 for API description.

Can be tested with:

https://github.com/isilence/liburing.git io_uring/query-v1

Note: RFC as I've got a last minute uapi adjustment I want to try.

Pavel Begunkov (3):
  io_uring: add helper for *REGISTER_SEND_MSG_RING
  io_uring: add macro for features and valid setup flags
  io_uring: introduce io_uring querying

 include/uapi/linux/io_uring.h       |  3 ++
 include/uapi/linux/io_uring/query.h | 40 ++++++++++++++
 io_uring/Makefile                   |  2 +-
 io_uring/io_uring.c                 | 21 +-------
 io_uring/io_uring.h                 | 20 +++++++
 io_uring/query.c                    | 84 +++++++++++++++++++++++++++++
 io_uring/query.h                    |  9 ++++
 io_uring/register.c                 | 39 +++++++++-----
 8 files changed, 184 insertions(+), 34 deletions(-)
 create mode 100644 include/uapi/linux/io_uring/query.h
 create mode 100644 io_uring/query.c
 create mode 100644 io_uring/query.h

-- 
2.49.0


