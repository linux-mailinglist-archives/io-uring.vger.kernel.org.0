Return-Path: <io-uring+bounces-9386-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BA3EB3986B
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 11:38:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C307418976E0
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 09:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50517207A26;
	Thu, 28 Aug 2025 09:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WtMlDWHn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BC31FE47B
	for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 09:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373897; cv=none; b=GAxGMRcne+zJ8TLr6jQNcMRGqW3MBzDZGq+9cabyHAX8Kx6oTpavZNMKVQiGVwXESVCIqIe4YO+7sP6O91hY6w8XsC1VXR6Yac59qPLidHM+P2MnKW+tcqc7CDz2d3vKNxR20aIXMTudrOavGMsUgTkOsHGQ9xMVkYOUrWEJ7qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373897; c=relaxed/simple;
	bh=q/BAObkwTNcIeDDn8bwBRkOV4AVDkgTjY/26vXkaMsc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p36Jz9DEC2fpvqy4AmOhaBgSVxw4DMJDcgUff/vieL5q9ryNb+wJh+YH+bIPNIBW1kP2q1fAm/iSQW6nvxJ/XFhEgPN91YLKxAhnLbRZYC9/WWPlniTu9H3keDnKHNgbKaQeknviVRMvVS6RHSonMlaD/H/Tbd5lLxpMHv1KZh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WtMlDWHn; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45b7d497ab9so638345e9.0
        for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 02:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756373893; x=1756978693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qj6NA68N38AvZqAtxfX/9B+Co15bMF2WBhMXjngUwYM=;
        b=WtMlDWHntmOfHBSxPYcB3nFQsjVTAj5DzQxYG3OL6/dldpQD8/1SfwtHM3v6vpnw96
         wyVAlkJaeM7KL/4QF3wWw4NfJgNaWwGUWVcs+fz96H+i9H9iQ/A+vZ+2tJteT+FJ2EMn
         mgibpDHhwESVYRQCc22w6yFsAgMMKJ/8xRYjOa+7D7Sr/NeXf4zfe17GMZyGs0BFF/bR
         1URQA8+ZbGvcXaXOtaXPgk5k5fGrSK3iXsyR2X4PkAJiLL7kM9h7lVNl0Hq8zhBSN3kJ
         GJrKnzzhw/8FPkgJIDpBl7sAt2cOPA36aC6l0Oa4M4yyKbjslUaodInOROKdMnOJViLw
         trIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756373893; x=1756978693;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qj6NA68N38AvZqAtxfX/9B+Co15bMF2WBhMXjngUwYM=;
        b=UwajliNtNmZCbKxjuG0oQUtGdt90+LwAx8SuGNf+N7UWbA/fjziak3Ry3IN3KLjx/x
         2Q1zjBj7yF/uwnc+IOWYqBX4/hLek46UHBwiD0xBvpI7dwxDVwjRYMscb+iXdaRB2CGR
         WhMQb6uQvbdsgv+8hxafU5pSj5p8PgDtAD7MWrJe53IFkf7WcymXVR7qkObEtxqrPO4D
         Sm+VxjcAbhqgHaYXtud4SPFOjz6CLSroWH3Kyt8pPK4MyFMkct864FH9jF+HqSv/jyGH
         SoFM/My6j3b99MvYp8cV15jUr4NwF3Cx6ZP0Y4XbAV3IXX5+0F9h/auo7+wC3yme3RTM
         OoXA==
X-Gm-Message-State: AOJu0YygEn5/I2nUlUwHY+a64SljzS050IHqxdnTQSUCLyRJhJxmSTPF
	jK8Gvv39tG2Rugfj/GqZxR2P96vDfCyeGKgax3K0DQLNDMtODvP5YtG/jFCDRw==
X-Gm-Gg: ASbGnctn6bBbLzgIJ8z+/w1JWJihbdWvuEX3FIeLeFsS7iO6vIb4oA3qq+fZOOa/gAo
	j80dTVe3ubWCStCCkaHLkOBL7IhY7tzutEtbEln+1bTaaUiiT/3wHuYVoTAme+Yc4Du21hZtxOC
	h38Yq+Z8bOm2jSSgi2qSu2c9Q5URV0bWMAMQ0I0WTQsXywW6CC/P4GObl+xhuILddpqy/KI/Gwc
	tsz4WiHkENXswkuyYNd+Xhimov+c3DIlhM4PsidtL77/daIJTzLwDiYABOEjoK/G52TfW5MgOj4
	LZVZhO6TpycsQE2manYCcHCfU6IQ8EPqN5gc4IjhUB3XYyaNtdUwkwHQtOcSCtzkkSb1Q61/kaX
	xtJa/w8dPCN60D+lQ
X-Google-Smtp-Source: AGHT+IHnl6KJK7qSpMQ7KDeog3/rgPHY+I6+hRhqAy/gVn6h1Mt9pUMcsn6YEZ2KV9Tbqgmap90RJA==
X-Received: by 2002:a05:600c:1c09:b0:43c:eeee:b713 with SMTP id 5b1f17b1804b1-45b68a59459mr73093595e9.20.1756373893248;
        Thu, 28 Aug 2025 02:38:13 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:68ae])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b797e5499sm24331455e9.21.2025.08.28.02.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 02:38:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 0/3] introduce io_uring querying
Date: Thu, 28 Aug 2025 10:39:25 +0100
Message-ID: <cover.1756373946.git.asml.silence@gmail.com>
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

https://github.com/isilence/liburing.git io_uring/query-v2

v2: - Add enter and sqe flags to IO_URING_QUERY_OPCODES
    - Zero unused parts of user structures (beyond returned hdr.size).
    - Don't colocate hdr and and query specific info. The header now points
      to it via query_data.

Pavel Begunkov (3):
  io_uring: add helper for *REGISTER_SEND_MSG_RING
  io_uring: add macros for avaliable flags
  io_uring: introduce io_uring querying

 include/uapi/linux/io_uring.h       |  3 +
 include/uapi/linux/io_uring/query.h | 44 ++++++++++++++
 io_uring/Makefile                   |  2 +-
 io_uring/io_uring.c                 | 31 +---------
 io_uring/io_uring.h                 | 56 +++++++++++++++++
 io_uring/query.c                    | 93 +++++++++++++++++++++++++++++
 io_uring/query.h                    |  9 +++
 io_uring/register.c                 | 39 +++++++-----
 8 files changed, 234 insertions(+), 43 deletions(-)
 create mode 100644 include/uapi/linux/io_uring/query.h
 create mode 100644 io_uring/query.c
 create mode 100644 io_uring/query.h

-- 
2.49.0


