Return-Path: <io-uring+bounces-7699-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6652A9ABCC
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 13:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 140471B603F9
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 11:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018A61F4C98;
	Thu, 24 Apr 2025 11:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZeMSB16a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2211EB182
	for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 11:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745494212; cv=none; b=gW6nJJcCFvzS+8T4HhEqbd6ANjfDHBz0MQpv2V3O4Xf9gyWkkB1ND3g1NOHy5ZQxzWMeB01jg4ilO0FNZyh8uTjyb/uvWyGmxnd0cGqHP/nfX2EYLffILZYsYe1j9EQsPfCyY70gGBjOoDMRKn4WsQ0vwKY0TQ0LqqYRufUxGC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745494212; c=relaxed/simple;
	bh=fI39p5OLY/xeU+wauF+gCN/XU8bmLO84hgz5B2YQULU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VMzXQYmth2UbVfgD4dzgvZfCBwmH4sjmoDKsnUIj0zvSJyvndUbYj5fMkm4eHY2/Rd1u7k9NEEFd9CblJmAqS0C1MJTnaBAh3mp0nTFk0h/EQjhMwoyvfOOBPLtFHF9DEYjChwRDvFMaR06aOJu7jNS5wXRKZLRO/4h3mDvoVSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZeMSB16a; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ac2902f7c2aso157286066b.1
        for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 04:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745494209; x=1746099009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MHKStSTrHaKnMnmE9wztdhsltJtCwXFCy3+i9YKHAg4=;
        b=ZeMSB16a0KYjnV7l23fn3DGUNtDKp48g5NffCTLk6qVIoxEjo+lMeK7cXRts4EkNS/
         ngLqz7t56rzC5GVqQ1Y01tZMXmRFlyCg0bootjgEvhYaxpUU5DP+ly/QESAivBbrBKFI
         boQsHJF2BAETYLT6lgHoMzeK+cYPhQwMnRNTQBpztfjfMvXp0X1Jkor4rswa3dFruaIn
         N4p5D3G/9Xrx7tt+xF4tLH13Ocv7D0snAN7ReoOE0fE3zALpx+g4pfKYabAI7W/vVyGf
         rg8Xs205diH/zRbTte9ENN/VAo/YGhXl1S+scP+KJgPj+kJl0Z3uaz7wjk5+0fksH23l
         cB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745494209; x=1746099009;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MHKStSTrHaKnMnmE9wztdhsltJtCwXFCy3+i9YKHAg4=;
        b=W30uE1EWeqYSOIpPijmXqvrLDY6EKFw9n7srYEgpkTAS3cmIBxVOqe7ci5Vdwddig7
         JPjNxzNs+0X6V1LnUGrnH4tQiW6DylKSQIARDdXamZIj/a0Vul2WTELq47B61/da5czy
         zC3ighUQVMBGo0JyQnd/J7MrUHotpk8UDE1tXRcmP1pq1NPomwZclfc8motcIGWCf1/Q
         17X8fGz/wAvxspalqoyDEvbnimlujclQGSCoNjGz9L5UfyCnSzJRBA/ngeH43t0/9M0N
         SG6RgN4rsbZw1Bogg386XI3ANN1rJgqfa8EYIhCKwBmWjbV+yt6EwPj/Fdqdqi/LqvlP
         hjGQ==
X-Gm-Message-State: AOJu0YzX/yNukNjjxXLFb0xsukFQFAtZ8HEXrVMUiMwMq3Sxtn3uT1fk
	xa5E+I4x2dowlje/ZCyMEFFv+6BBC/osUPLbwnHIoTsyofnZFbw9FQSDqg==
X-Gm-Gg: ASbGncsUY88xWC/OQqkaqQKvphsDP5x5QJ7N6mHrPsTa3PtaibHLbe3MA6d3QBV6PWK
	X57/uLgGtAKIugx52vLRxw5IyLh7TAcYhvqKVAisXF+Nx7C9+pYHci9/qHA87WGcKBNF784Bg8X
	UlRsO2jLhO+6iZJt6h70HSlBF/QdZ+NkRMAqSfnA4zQ44bzQTddh0RvcFQsGzFji6irvaM6Mdui
	Uqy1haTMZkscaixyHRWfzljr/+XuY10IgmxPxqOTMtCaClxLfPxoAXwM94ibftqmlSYp4HmffBM
	p/3q5f12WogMv0jFMx1ARNHA
X-Google-Smtp-Source: AGHT+IFeIxGThN6ZoC2fQ6jb7+XhevYcSX3J38KpR2k23fb7JMcbNaS9LLythhhb1PfqP8ZkgGT9lA==
X-Received: by 2002:a17:907:d27:b0:ac7:4d45:f13e with SMTP id a640c23a62f3a-ace572126e4mr234867766b.13.1745494208748;
        Thu, 24 Apr 2025 04:30:08 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c716])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace59c26316sm93675266b.151.2025.04.24.04.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 04:30:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/3] eventfd signalling cleanup
Date: Thu, 24 Apr 2025 12:31:15 +0100
Message-ID: <cover.1745493845.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Get rid of of conditional rcu locking in io_uring/eventfd.c,
fix a sparse warning and clean it up.

Pavel Begunkov (3):
  io_uring/eventfd: dedup signalling helpers
  io_uring/eventfd: clean up rcu locking
  io_uring/eventfd: open code io_eventfd_grab()

 io_uring/eventfd.c  | 66 ++++++++++-----------------------------------
 io_uring/eventfd.h  |  3 +--
 io_uring/io_uring.c |  4 +--
 3 files changed, 17 insertions(+), 56 deletions(-)

-- 
2.48.1


