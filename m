Return-Path: <io-uring+bounces-7818-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C7E5AA77D1
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 18:54:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC3929E3776
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 16:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AE60267B72;
	Fri,  2 May 2025 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hN5juSUQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CA1267B86
	for <io-uring@vger.kernel.org>; Fri,  2 May 2025 16:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746204784; cv=none; b=CWDzgRf58DuXQKjr2KTznY7qqVjowgeHA+oWNCNj2aHLhWOs69YRajymLzHnAkzkMZYOdJ5V1cq5Qs4p61a0W/vQD9sYcv6kSO4khJGz36TEDd67nY6ioLEkyD91N9aaYK6O8z3hxm6dBL2RpsesXWiwZ12JBzGp2pRrxKwi4OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746204784; c=relaxed/simple;
	bh=12ds24LS+IrVibujKQlMSPHi/v7Qfpu8IBdkTPFtU9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JrwnDJj9Jt7zWX6tEYqp8B9cOu1e6cH07P18vKfFyDQl7tiI8oScj+2NZEQmK2cv9HjtPKiK7LNQMwXapicuZgwQuWwnXKBvlFOEPOO5KL68OAql/Gqs9a3O2on3FcIi/7/67YDKcfj8V10Ew+zWF8xWtO4ZO/Y/hckarMGSLkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hN5juSUQ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cfecdd8b2so13434295e9.2
        for <io-uring@vger.kernel.org>; Fri, 02 May 2025 09:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746204780; x=1746809580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+hmMdoCjkPQ45QlUj7u7dKngIhkaqq3taJVVRtPduhI=;
        b=hN5juSUQvJN47BRgwDXkax7jgu2G2fZ1CLnmj9hiZxYb7lwKqQ+XmIvCdFhWOlKQ5L
         iq1nqPCl/DVcfwRQzWJDMbSCVul0MWU/fkj+Lk0qesagVqB3pAHYexf3Me2DA1jIpZxf
         hjOjeo9WHzCcAQkT4AvoXyt1AH2Fq8V+YQbqPzWdkUR00mcdlHRcAY2jc7ltWfnCBo/c
         t/t4yzj0celQeMCj5F+Qq1q2vKx4Yr5hhZzxE75sTjhE7DRjLrN5mLKpq590PHu+R3wD
         I8p5+OhlZGrKZiSvT/RU/xTtg6tKXWpd46nCe3vVs5D1jzrtD6Xkz2ETjm+4TBVpt5f+
         KX7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746204780; x=1746809580;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+hmMdoCjkPQ45QlUj7u7dKngIhkaqq3taJVVRtPduhI=;
        b=b/NCepYanMrezNezSxvGnfsRrBmBxwXG3dY9Zmfs5Nt1Tn5+RcNX51klPFdtgPj5si
         JIytV9pylqbLiXl3Hlg+bxHAMjlFaUGmaRVU44SwmZ9k5tYBYrzjqXEOPGgtZdNlxEtn
         bIxmIieErGuif2f349Drf6s/yBTTA0ORxEIPh6Sir3NGOYxFQwoSu388+4rlvzo7KC63
         VtumFvkQJ9NnxOrcxGx/N0Iw/5G6SKwY9F3ABRwineaFZnBq4z4UYjqWda8vxtQOYTAE
         2PFT/qbUYRaJl9o6HjR1yW/iofuFPHm+zpcJdUHI4WeRWpj53JYxyEj+e7UTXuJfqRQD
         pYEA==
X-Gm-Message-State: AOJu0YwByL2BeLF39KQy8ZVB5wtzXgMHPKYuC3sAtqCLiEBruPtrCqxB
	76AewBG9ZAsckf6hNUHNKUjQTwfXtH/doVx5/jN5iqNgzeX5qMRgYwM9eQ==
X-Gm-Gg: ASbGncvzCJ3icJnKqvB470py5StrdIe1EYPxp7btYOQ/hTcVRnY5wCuOyqK4eGwndke
	P66UrCvfYKBYjOhqfmEWhGCqB+kmM7gc9cu3dkHKKl1X1kKJ/VmTvGVjY6qnlSNgrvbHZ3S66v2
	qUwE1M+Qrn8Yzcg7ZmRkBKnQt9tcNJstWKj4sOlzSZlpsgTFLHi3FHywGsAqVLzxDrS4zeGaqWS
	IyZ3kqDP2Ylcv6faMkV4w0HoLIXX2+JH/hIRzrjM993CISzSPc2qmsUfGBJHCnwEAPg3HfLMm6A
	Wh+u5XaQ58T1gFCMIgbLWZi9i0SGtwTj+fjF9qvqczmoZecA/TwNP/E=
X-Google-Smtp-Source: AGHT+IFG11s0JoRY+nVrb8Mz7GkyonsedRP/QsDGawyp5gsN5Tr045rhNvLhIXGlmSzQIq9hLFaNbQ==
X-Received: by 2002:a05:600c:3485:b0:43c:fbbf:7bf1 with SMTP id 5b1f17b1804b1-441bbf37f1fmr38781925e9.30.1746204779924;
        Fri, 02 May 2025 09:52:59 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099b0f125sm2586013f8f.72.2025.05.02.09.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 09:52:59 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v2 0/5] enchance zc benchmarks
Date: Fri,  2 May 2025 17:53:57 +0100
Message-ID: <cover.1746204705.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The patchset adds options for binding to a device and for filling with
a pattern for data verification. Also, improve warning and error
messages.

v2: add patch 4
    fix ghost variable build errors

Pavel Begunkov (5):
  examples/send-zc: warn about data reordering
  examples/send-zc: option to bind socket to device
  examples/send-zc: optionally fill data with a pattern
  examples/send-zc: record time on disconnect
  examples/zcrx: be more verbose on verification failure

 examples/send-zerocopy.c | 110 ++++++++++++++++++++++++++++-----------
 examples/zcrx.c          |   3 +-
 2 files changed, 81 insertions(+), 32 deletions(-)

-- 
2.48.1


