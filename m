Return-Path: <io-uring+bounces-6499-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C6FA3A353
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 17:57:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39E88188C015
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 16:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D121426FA5B;
	Tue, 18 Feb 2025 16:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="0qs78kUt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A72C26FA4A
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 16:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739897839; cv=none; b=dycaB2KlHxNeLpqvM59/wPJNkQQXktVojPVwRsFBJIhtkKJCKUfUfOttnKWk4H887oEylQHoaoaSPyV4JogrOblBiycj+WIoOrL+4tJLAItGfv0IuKnH+lMoo7uns1OKUzoIJaXjpNelD/FiPG3agP+AuQ2i19J8Z0GIiK8w4lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739897839; c=relaxed/simple;
	bh=t5vwAnOkVYQfgNARJmBdNkyW81mSljrXC80CzzCIopc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a9zBQvM9zaT30Wu0TSVcTXe9Mf+Ktdqo0ynGgkVMns/kjWDvzL6hioIo37dBsBA4p0BdDiTHjtMqtvSZJ5kBlZaW86iEVd5d5NhXjq6ZrbdLuVKY6k0gEaB2Pgd51/+NMKoVR+xTf3fLui838ZcKoRRTGrZs8vpVBboASc3IPHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=0qs78kUt; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-220c8f38febso106409705ad.2
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 08:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739897837; x=1740502637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xm+1jBJmPxrJD9oKL4DeXe5lAJaz+i5OdLGsIQFqeWo=;
        b=0qs78kUt2D1ffsLe9mYaQ5VMFzwE9lKNKEFJX0ou4y7gKHttsmNQEg77sgvcVdD0uT
         1yvFF5n9/67PU6eRwDjoRy+q535tQEq8a53/kEE6dxuF7+1AugdUiXidRVF1PHpnyX3Q
         UBSAZgzW2ph9tZz3cisVBBtP6GstB+o2TYF2lbi+FXnp/Vyj4Fu8GD3jk3TXjyjHBRpJ
         y1WIWw69lvwnryqQSHlk9Hklo5lq6Xuv/xZpDBNLTzX7XiaY8YeqrGeCJ/4XcOleEh1m
         3Dz3AvIWVMLGwdkZjkcbqfBsc5hCxHmDRTZV0qFB3zKm+UyRDsIxeDUBYeaZommiTXK2
         +cqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739897837; x=1740502637;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xm+1jBJmPxrJD9oKL4DeXe5lAJaz+i5OdLGsIQFqeWo=;
        b=fAvVYykzbaGpNP/Hs9uzQYOCqXvqtXbjePhrEvLNlB+/VQpdB3opt3g+9zUwOAU7kv
         j9Zr16AsnU+WMwymLxvxZgMfOHycK+xMoCj6mOvgGTLL3BoBee7Hz3pO+RDhF9yGaqWH
         RpYp8cUfa4j7nGIwdmbyZIHtGHXQX4obXBJ3cwl9RQq6kJo8CS5UTI82N1CX5Xka1o2O
         09TpbFRUmDY3tQP81iM/FZ47RvX64CxUmeG/A6Gwko6BUfLuC7bgPwuw+PIxi3M8epFZ
         3Usb35PImPTbt8hmjB2HUwKxZe79rHj0xxRcmLfDPlfLqnoRs2KTKVu9z9nBxNBryYYo
         CR8A==
X-Gm-Message-State: AOJu0YxXRDPUm4svoOP2PrXaq4YqZ/d2Vx97u81R4jl1gBmBnLcL/Y+k
	BDQC+oLWQzjCefoLIYsKWikopHoGKkEL4IAualiw75DYpMo+5QDUHYq1UsU+vvdqi2BNdJdN0ko
	c
X-Gm-Gg: ASbGncvqiBfn8x3nRGLz63HcvDghvgtT2cN1xfsrtpz4g/ALoLqUmJE9QCRjeddeAhX
	e3dnW16Lp7+m4ua52f8/Eq/b7iFF7fZpZn97s02S3ZBj3XkTOTfkY0+1F4P6PZnEO2HLp949mVf
	bv9j+DfssfM0caSuMVNMPQFDiz7c82Phe5P9L81Vl0hCQ9rrzZSZqAL5MaRhPhrtWRuUKGY8sak
	eq0o7UZ5W9qnpV3fYICrzvye8waz492+R3iGSEPbGd0ctl3L9yZSlcDXg2SAoodG02NBUJKUpif
X-Google-Smtp-Source: AGHT+IEifWd/jNYW0YEG0ybA9g9aFfxt4YWWK+nZxaucWrWHFCZrjeE1hqY5bQm4SgM0E+ud6K48zg==
X-Received: by 2002:a05:6a00:2e08:b0:730:4c55:4fdf with SMTP id d2e1a72fcca58-73261799877mr21623102b3a.7.1739897837645;
        Tue, 18 Feb 2025 08:57:17 -0800 (PST)
Received: from localhost ([2a03:2880:ff:71::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-adecac2150csm5005630a12.67.2025.02.18.08.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 08:57:17 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH v1 0/2] io_uring zc rx single shot recvzc
Date: Tue, 18 Feb 2025 08:57:12 -0800
Message-ID: <20250218165714.56427-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently only multishot recvzc requests are supported in io_uring zc
rx, but sometimes there is a need to do a single recvzc e.g. peeking at
some data in the socket.

In this series, add single shot recvzc request and a selftest for the
feature.

David Wei (2):
  io_uring/zcrx: add single shot recvzc
  io_uring/zcrx: add selftest case for single shot recvzc

 io_uring/net.c                                | 26 ++++++++----
 io_uring/zcrx.c                               | 17 ++++++--
 io_uring/zcrx.h                               |  2 +-
 .../selftests/drivers/net/hw/iou-zcrx.c       | 42 ++++++++++++++++---
 .../selftests/drivers/net/hw/iou-zcrx.py      | 27 +++++++++++-
 5 files changed, 94 insertions(+), 20 deletions(-)

-- 
2.43.5


