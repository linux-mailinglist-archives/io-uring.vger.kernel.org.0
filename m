Return-Path: <io-uring+bounces-8110-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DA8FAC3ABC
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 09:35:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2118C7A4D2A
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 07:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 532CC25776;
	Mon, 26 May 2025 07:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BAX+XZSh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34B416D9BF
	for <io-uring@vger.kernel.org>; Mon, 26 May 2025 07:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748244913; cv=none; b=oaAzcI7xkXwFqrL8ehLwb3g5ult7nKF2iHsZ7Fthdz9sKBhNkrUQhy40O6vQMTlZLMbxEVB8oOp72jg3cQ4cnOBU+ukwMRizdDjiJb+WgEsAcTvs/FYUpwiuVchc2yHNLAip6p22zh6kUlUxVZJt7fMAirYxBTMn4kBkGWGq9wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748244913; c=relaxed/simple;
	bh=U+iQLGj80k2teYfUo4UpSRIxfFjCsZW4QKgoCU24PLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WQ0ZdxfP1aTWwXXQgnOl7WThPKGihndZwmhxANG8Bho+LeIh64R4yt2PwCFdLGmTrEw8DQgNNC5/jmC4xbTRTGSb5mzLfB6t+VFMx6ysowwG6MHMJaiVz9uy2aT6iMQxUJ2/433443HCXETYfV6dVGfm25oN0MKtujKQ5fC66PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BAX+XZSh; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ad53a96baf9so376391966b.3
        for <io-uring@vger.kernel.org>; Mon, 26 May 2025 00:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748244909; x=1748849709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eYZWXtvBhHVOZBFo+NJxaUKbI581di0WWCQ4i8JnLD0=;
        b=BAX+XZShC2Fha9SZuekSHSl/8aq+LfUGIQMz/KfwRNryyAgkZIZAvfHqay9Uy9mpK8
         gJEo+4n9FxBBqe6Ows/h+r1RJZIFJxtvQGJlSie8UHKZ1zBMkxmHyp8BzBQPd0l5utS/
         5WEwaORSlClkLc9ew+J7VpvyQKxxQvx55DxAmWPAACmi0ss1/LUKUhVSkOXdm7QK8BZF
         Uf33v5LrTxc+i9VACOXYeN0k1u0uxS2YHBKiSk0UqK0Pdg0utFmTgI8eDBp+Ot3OVatR
         S718/KwKK4RTbdUVbr4llxk/PGkwO7zwb1m3o2Ho/2Vi/TnNpTKymVM4HMUgSdo692Xw
         o57w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748244909; x=1748849709;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eYZWXtvBhHVOZBFo+NJxaUKbI581di0WWCQ4i8JnLD0=;
        b=W4M6SD5ZnaX//RyTo0eUn022XB4+q9GqNyYp6xDnYbCP19btizi1UFdOhOCKObVMBc
         NJfBHEqlvo/vpHTV2Egm8Wu4j8iP1GRosrgV4A6CXGjyCdKEfU5UgHxsJDWAsqFrfjT8
         1lmYuzvyAWF14m8KUff9XoVV4KhqYHva+aHxIuGL11/Mm2pncbK1fPtP+OtWB2ZiBrkF
         TaRjLFfQnkZktnJ5ahsEp7aB60QNkRZeQIp/uusHZG5bdevhoSbAw0BQwTGoVj7rtF2m
         zmoITl8AXq+Zhrdjn87kOc2B+OW2JSas94G8mqtdqybBJ6tqobrL/c3Zm2RY4d6Jda/H
         o1sA==
X-Gm-Message-State: AOJu0Yz28riryqzfCEs+VIS6tsEIPcl/GcIRWC+NwApFNDDi4TFOZ3iP
	xcZQsz+ZrOdbGFaejKbi+X2ULZQ2wwZZi3/2xT8gRdt6dCl26hrmzmZTD1bDGQ==
X-Gm-Gg: ASbGnct+bIRhU5PsdtpNC3ad/v0985dfTISVz93XHflvd08ZRgjyFBlh8DkxV6bd7sh
	zazBZ2s2EHBC594oxzPoZUwjDk6tZs7nseTW5l7m2GUqWR4K6NPZnR6VsFLlsQWeJAuzbiiE00c
	6mJ4zdX7S5tc9HwHiAdFluFvpV62E9S2yrKph/AMpLusX8zOVpZiXkHVrh1NsHRZMhKHz3cZ8Jw
	CyqXZ/w6VfRh5JyiB0ua90zIo1ZU2mq/S8/KZ2EnxEoLS61b1Fq/MTvrAJHrSRP1g7TocsjUZQG
	0Gd/qazdvnpMPoOUcmADslaPvpa+061oiuj7Th7X6U2BAhBJZBpIRAGzmYAx+i6W
X-Google-Smtp-Source: AGHT+IG50uIGCLmWplUauXr0VL/bW0phcNfgb406iYtExDxMnOKYXWvvXxPftDoKDmtJks/eGZHH5g==
X-Received: by 2002:a17:907:9627:b0:ad4:f5ef:84ae with SMTP id a640c23a62f3a-ad85b337d04mr760905066b.54.1748244909466;
        Mon, 26 May 2025 00:35:09 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d43840esm1622780266b.87.2025.05.26.00.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 00:35:08 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 0/2] mock file tests
Date: Mon, 26 May 2025 08:36:16 +0100
Message-ID: <cover.1748244826.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tests using mock files. Patch 1 adds basic infra and tests
vectored cmd with registered buffers. Patch 2 add a trivial
read/write test varying mock file options.

Pavel Begunkov (2):
  tests: test cmd regvec support with mock file
  io_uring/tests: add read/write mock file tests

 test/Makefile     |   1 +
 test/mock.h       |  47 ++++++
 test/mock_tests.c | 373 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 421 insertions(+)
 create mode 100644 test/mock.h
 create mode 100644 test/mock_tests.c

-- 
2.49.0


