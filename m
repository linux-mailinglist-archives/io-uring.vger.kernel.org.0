Return-Path: <io-uring+bounces-2793-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 755209550A2
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D5671C20FF4
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 18:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 659E61C3F18;
	Fri, 16 Aug 2024 18:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="MajBbaEq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ua1-f98.google.com (mail-ua1-f98.google.com [209.85.222.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B361C3796
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 18:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723832157; cv=none; b=Ps598EI+ZrPjqvE18GajkBHUlXvNDLBwEMg2YOMl5/nWBJO7Ns+KVIwxH+qeEwkTGMg/ulJBeH/UD7enBNFKAU/8qOuE/pw0PJtHrbwBX7Mo6CU5uz1woJok35BoxIfeuNwjmyGxNtH7uzzbQugdFvCyjJHRVhpBT7KmMeXv9ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723832157; c=relaxed/simple;
	bh=zxiUW/toeZX5AppBzoekrX29ilUmIU0h888Rq44XoHY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e+ScSwystwd9kq97QKsLrBn+X++ni2wcCN5QKX/Zr0gYYZ2vjbfwH1vfu3EHhxKSTMOJx2ssXiitwaMDJ4ElE9IZLGSOM8oQAhjzWQuxRuAqeWkRy0znX7SPz8kUW2XJxlHApUlkj/UHMWWhaMlgMS6uxfftCLsG7X5CQttlCvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=MajBbaEq; arc=none smtp.client-ip=209.85.222.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ua1-f98.google.com with SMTP id a1e0cc1a2514c-8430d25b01cso185986241.1
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 11:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1723832153; x=1724436953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WjxybjqjIyQYbHemfFTeOm2xjPxQaOuMoDMlPG+rLzw=;
        b=MajBbaEqqqqd+maMYClarM92nP1WXwjdkBIBZkryE3dkEYoDhyLOnLqKhrI3jdikIO
         M7zA03BkCCdoKngAjXpkPREbjqJTv3mj6yIENcfoHa3CiSNHjgizwT5uJ1e0g7eYeR8H
         KxrO1a5Dy6fUyJzWCsZQCY0tJApYovyKgctj15FN14vV26EPh/byrf/3LX0QENq12iuF
         g7XitROqKjCLq3I4Gwj/wcNg3aOO8T4Pb+RkXecdfCif6l82828n0OWLPfSq2GGx2E7H
         RQUhS9OVo6dlWKAJDAj47dIdD9/VJBHOvC2hxhPRg7uEJOpnYZCuW72F7IMHOZv1LXYR
         9m8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723832153; x=1724436953;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WjxybjqjIyQYbHemfFTeOm2xjPxQaOuMoDMlPG+rLzw=;
        b=Meanr1YPtNgW9m1PB3xoO5tSsPxlox9h/iQeZVSieObXuU68dS1lGbq/kfJZpiBszd
         Ilhbq6ppT5D2rlqgs4pM/zRHGZ13KsolPMBR0aptJXiwert9JjUr0DtlsDjFE1jN24dU
         hpZf6SdQR52dfmOEo1XNdEzXKiexEo7E32JqSZY1bD2M+ss6ZzV6lcH0XMILyYHd4GA5
         CsWuDLUk9dFno0YN3t9fKHD1sVj5oL695MC/a5T1v1gP8quBglpft781Z4X1kVgLuMPD
         t9Hl25gpzLQLFZiPafbQOZbFSlw4tmRREGg1j5vjVSxnl44Vs3y5viDdlVWoS23Ej9WM
         m+GQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkYYfmXkveE6nrbECC5+L0NXnJTYgSYuD4Y99EXSRn93q7cUfCME9yfi7eiBaoE4DoL8UYNj2N4Lzw0uV1pJzqgIto2r+Jhyc=
X-Gm-Message-State: AOJu0YzJKkmxosBphbxyox8XjG6Fw47W0Zu95Xsy+DUqcJ/LiM1+eOFf
	wRYlkKXbhQ2hdIyDq6wWWxCSw0zC/b6Tk0WzYCeUgfEcVbBPQmwT00f/MIbOXJVhi9y1PNWuIA4
	iA4hOlGm+rZvRGkyb6wHyJFVLm+UaRFX1U4uGIhOXsgDjLJqE
X-Google-Smtp-Source: AGHT+IEcRZRkVqmX6uxa02ElXcDjNwYLEXrtHyOHkT5kx5rZ1E6y/bSW/WG85j0v8EsBvXBI46ol3hg/vwNS
X-Received: by 2002:a05:6102:c86:b0:48f:4bd5:23d9 with SMTP id ada2fe7eead31-49779906068mr4512209137.5.1723832153414;
        Fri, 16 Aug 2024 11:15:53 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-842fb761ac2sm155545241.9.2024.08.16.11.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 11:15:53 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 8D2863401CD;
	Fri, 16 Aug 2024 12:15:52 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 77B37E408E7; Fri, 16 Aug 2024 12:15:52 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: fix user_data field name in comment
Date: Fri, 16 Aug 2024 12:15:23 -0600
Message-ID: <20240816181526.3642732-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cqe's user_data field refers to `sqe->data`, but io_uring_sqe
does not have a data field. Fix the comment to say `sqe->user_data`.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Link: https://github.com/axboe/liburing/pull/1206
---
 include/uapi/linux/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 48c440edf674..7af716136df9 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -419,11 +419,11 @@ enum io_uring_msg_ring_flags {
 
 /*
  * IO completion data structure (Completion Queue Entry)
  */
 struct io_uring_cqe {
-	__u64	user_data;	/* sqe->data submission passed back */
+	__u64	user_data;	/* sqe->user_data value passed back */
 	__s32	res;		/* result code for this event */
 	__u32	flags;
 
 	/*
 	 * If the ring is initialized with IORING_SETUP_CQE32, then this field
-- 
2.45.2


