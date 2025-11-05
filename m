Return-Path: <io-uring+bounces-10385-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F5BCC37831
	for <lists+io-uring@lfdr.de>; Wed, 05 Nov 2025 20:38:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AE2F3A4C56
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 19:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23810263F30;
	Wed,  5 Nov 2025 19:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hWrjzCLB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEF6221703
	for <io-uring@vger.kernel.org>; Wed,  5 Nov 2025 19:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762371416; cv=none; b=bLp4Rr8z7t5CY1Mh185M0/eLzpXjvgytvdCtPEF0wKfOg60Jq50t/ocPCES/gQVmXURsnPS/Yve248IYRB6nNO3IvK96TQcI+ojeYz/wvN24Mo94S4ptYDtEFENzDBrYi7b9EW6+4iOaf2jHtg8FUkHR8mCIuhX/ZqA78mowmxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762371416; c=relaxed/simple;
	bh=Oz3JQdqOS6JBnPxbzF1YOi1DUlZeoEAsX3qtnL5fyRk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=FJ6y+5ir9v+RvB8lNfs3IM5xYVvQQaw1nLTHPhm9uMLleMkjuIKQ7FVp3nH9jnLod3yXmAUQN+lWjoI8O1XBQLk4x6ThTGvnlUJkC3msbkiwHFKDwWh1ukOJ1AcIaeLIVj9vSQI4iF77wP9x/UKritXoPagxXFfL3lDMAlnpDCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hWrjzCLB; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-4332674b921so680425ab.0
        for <io-uring@vger.kernel.org>; Wed, 05 Nov 2025 11:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762371412; x=1762976212; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=LgPQ4GbV9Zrgudj1XSSRkS89x4TBkS0VjUeLIt8r1bg=;
        b=hWrjzCLB6nFsUlSkdRdsFXHCjDQjQNbHGTXiKc6q3cIDFYUfEw89K0fvIGNue2/Po3
         5c4X+SKHl2EmyAbNtZQunhLkce9qECAmurqB0oIDBchrLBs+uCQ8DRyFPRUE9s3jJmYq
         PU6jtrILgPMI2pPGwKeQan6lLiZ4zVE8j/VtJ6eY4gCQFcg87a7TJ8Z4mVUMcBFi5GLH
         uQSf7hhZyKjlYwuPi08Y/N24vzzKbO+Kpm68uV/gFP+pNQaLYL+gnXfipIGsjU1UDCVG
         mhfE4pIFMVYh6LYV1431M4sfQSnVyFqinJyVO0rRGbECHxN9JHLYCKXXk4Q/fZsauuwU
         qmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762371412; x=1762976212;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LgPQ4GbV9Zrgudj1XSSRkS89x4TBkS0VjUeLIt8r1bg=;
        b=OMpsR9lqxc+Hhm9shMHX77wzjqgra1baSiCAe+NmFCF+RT14ojXDqM6odutDSL2fka
         e3wU0aE0ifW+BmS/UkTGmtZqcJdUxnDM6WL5XkEOLUbOC70fL/rWti78G6V9dGKVMxZT
         8j/FD1LNePOF2ZCbcP/CeMLxaUF8tjrLJZx6667h0Eo01Sma1ivqJ53F3Yg7w5NWsVN6
         g99BcXXl1VVXQZd9RMcqEwMBkCQnzRAhPthLIRhR34m3OX/r1rlspX3zuEuOCshdWOM2
         lw8HIomcsrny2dONkb8vXl5cW2ehwyGNK1oMNVoLEm2MZXHBCKh5Zg5eY0EI6A1mR83h
         nMFw==
X-Gm-Message-State: AOJu0Yw9ORXy7rwQsfVkzJtpDMYX8PtV+QCMyRPCV0TQHEUgsNkPJmyC
	Q7ST1x2rcqpkgiIBXoz8bIbJMQoh+4QTRPpDWfWN0YtH2EyoIelEs8fQ/51+sEFj6ascIsW2MbG
	EYSvc
X-Gm-Gg: ASbGncsooaiUoEEBrCP6//TpVVr4VRo//FUhIAJRNb8FibFIvCyWZ9+J15O5xET8HwB
	IoSeGIzcg7g8RaAXgbRbIIpVw6DblE2TIKzSh0cP4fUlwxVLtn/cNLTM5sQf92IPN26ZujmPHwT
	CmoJbhg085ZueKJ6KFzInlvfW14rKrZ6Fs108+l11hNc8QD8evKQmMn7NmvCh5TiRTKugprGP/D
	qFPxlAxaN9BWFS6LjGX6U6XBNIW2q0Q8b9ffIHshekVKGwV2lBe//uHIzwLnq/GRRZvFClTavsz
	1GULp7yaZMaB8qThOj2dsYsfd1ImQvumLGh8eCibUjeFRWxpY12y9EGsdfJ/Wm7oFOxyMBHpxeN
	tdacsszcjEfe5e7LECPjO44Wz2KKVNRyCeWryZTF59ZC5R8y14gE=
X-Google-Smtp-Source: AGHT+IEIF8GKDk3qXCt4uwpAb0K0+wyiuDAFW5iuS+BDXOUkc9p8ZayYE58MtziuAdPWY5tMUI6FZA==
X-Received: by 2002:a05:6e02:330e:b0:433:30e0:6f68 with SMTP id e9e14a558f8ab-433407f57fdmr60819565ab.24.1762371411800;
        Wed, 05 Nov 2025 11:36:51 -0800 (PST)
Received: from m2max.wifi.delta.com ([99.196.133.153])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7467d43cdsm39467173.13.2025.11.05.11.36.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 11:36:51 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Add support for IORING_CQE_F_SOCK_FULL
Date: Wed,  5 Nov 2025 12:30:57 -0700
Message-ID: <20251105193639.235441-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

It can be useful for userspace to know if a send request had to go
through poll to complete, as that generally means that the socket was
out of space. On the send side, this is pretty trivial to support - we
just need to check if the request needed to go through poll to complete.

This reuses the IORING_CQE_F_SOCK_NONEMPTY flag value, which is only
valid for recv operations. As IORING_CQE_F_SOCK_FULL only applies on
sends, there's no need for separate values for this flag.

Based on an earlier patchset, which utilized REQ_F_POLL_ARMED instead
and handled patch 1 a bit differently.

 include/linux/io_uring_types.h |  3 +++
 include/uapi/linux/io_uring.h  |  4 ++++
 io_uring/net.c                 | 19 +++++++++++++------
 io_uring/poll.c                |  1 +
 4 files changed, 21 insertions(+), 6 deletions(-)

-- 
Jens Axboe


