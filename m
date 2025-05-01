Return-Path: <io-uring+bounces-7804-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC2EAA633D
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 20:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B22004A7260
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 18:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30195218E97;
	Thu,  1 May 2025 18:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LjaEjZ2P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C714223316
	for <io-uring@vger.kernel.org>; Thu,  1 May 2025 18:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746125745; cv=none; b=OfTQN0B5juw5nrkdIBlWkM5T/Mh++hUwi0oHB7hbxkowsFWzUHFnkxeo9UHAI0aH+mNpB3ffh1poLw3wu7IyhME5xB36ULb5SXZcwF2Hui2iJZfWui6Woc+RWsB3t0FsD3QG+dyIP5sBsZph4EyYSSpWPcrsCh+K0haTquiItfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746125745; c=relaxed/simple;
	bh=3eoynIguVDMh63Ds8WJ7Mef0nu1KIYS4vbYuYJDU5MY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uE4+yY80PLDzN1EIov4ZkRkZbEehrQ7F+Y5GTLkd03LqOe79L2VIZOVyKSWLtIHO3tP02Ei9e5d0PwA448fby1lWKAfkqzao5LiyzKN7YiqexsdnjiQ6XDL9H4SWipqLsmsviGz1NZVKizi2NmMBnxBLbNUTpgDzipVAdJa6VuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LjaEjZ2P; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-acbb85ce788so270580166b.3
        for <io-uring@vger.kernel.org>; Thu, 01 May 2025 11:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746125741; x=1746730541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EjapVE573mLyDHRnsdhQkhBkqqdFT9rIo6bSvXef8z0=;
        b=LjaEjZ2PPSxtfe6X5FvSuzhrCcaeN13PxGv4Q8kv0BI3jM6itkUaHGnHsIMZRmYPUU
         WH3PNMkLf17lO7CZJzrPiWAOfxDC1LcR40QTjB06V6g2wk5qP6AB/Tf5HhtT+yGtTnps
         F71qI4sKHwXt1Edq1gypmrICxFHzNiTB0LRS6qR+360v5Pmw7/+kWVkB/EZGM1sbs8By
         bRZZZ6dgZVbkuaoypqtdvtc4TO7e86IBF9J0+SU+FXwwl2IM5eB1UKq0pIbQEuoQchdi
         0BZJdhnG8H0zbAXVGQcUN4NZNz4nh8lkvDUByrHPk0ZT7tMQ3NMaGNggCTzBvEpIOJrZ
         P5cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746125741; x=1746730541;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EjapVE573mLyDHRnsdhQkhBkqqdFT9rIo6bSvXef8z0=;
        b=j8qkHPJQAgQLXILeQdFfDotlUQnu1X+tjk2CsRbuqVfuEbg7YUXetSCfOcmPOR4eAM
         SVsljIgm9O+E7uDR57Ez/7TKIcL1QVxl5LKEA10QUHQmDKgAvLZku7qhuiL6ZkNe7puk
         knPANftcNpOVepae8WSJ4K/ed/8Oi/vPzFJ62A0r+i55K4m6po0ZyPYLdcJwWenPXHCG
         2ZoZFlaW6Ja9/kjB3yWo5DO/96o6nJNp11W+iORBG/n3jMcc9ridLYk8mhc2IFeLO0FL
         4xWoZ0GHa3bDPohcgz/RzB1QxAHExVeg4xxC43YYJxo4+A3uPWxfxCtEQlHbZgMU9QZu
         MZLA==
X-Gm-Message-State: AOJu0Yy5zTJTFaiBQ1w9SXW8hPr6pysO4M6Uar9PkFbrL3HtVYFoaJDG
	w80C8M+YZNhHsh4NBwymb4/QtiGZ5e+gri3i6bVzs3jwlqrv4BC79DzUwg==
X-Gm-Gg: ASbGnctOPsMsw/bAKUE+Mfo2dA40y6Yi+nazFg/V9taQGQgSM/pfuGqeL0pbmnevFgC
	PDG+YRfnGhCu6PwrGIz1RZOb0GY9RorEDKZdn+GxFX4Z//wPsNHVHdx/GNWY5szQyqxTvUMQHEP
	sVIH+f+xWv4U1fxUjfoiO8ahZihdtXunMcUbS/cCchN7fQAFkCkArH8WT4RSyoidBOsb5nxKQwm
	/nwO1V8v5G17vFZSlDPdldK6arEEc7RSRLLqV3UH5ZQqgP2IJaAkK621XEMBgkC/BCRmTmfhkdw
	Nw6Y/RS9FNrtxPE7q0owyBxuJhO4G4sAl0T8qlw50DL0NlLpDrwu9w==
X-Google-Smtp-Source: AGHT+IG6LZFJfp0x8Ml6T2zKj2fFbUK5WWxJp88ZoIGCH60PyCjFYjYOFAVpw+/FLHa5E603jNgnKw==
X-Received: by 2002:a17:907:6090:b0:aca:c507:a4e8 with SMTP id a640c23a62f3a-ad17ad60c88mr28916266b.21.1746125741014;
        Thu, 01 May 2025 11:55:41 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad0c70d3955sm79059566b.7.2025.05.01.11.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 11:55:40 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 0/4] add more features to the zcrx benchmark
Date: Thu,  1 May 2025 19:56:34 +0100
Message-ID: <cover.1746125619.git.asml.silence@gmail.com>
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

Pavel Begunkov (4):
  examples/send-zc: warn about data reordering
  examples/send-zc: option to bind socket to device
  examples/send-zc: optionally fill data with a pattern
  examples/zcrx: be more verbose on verification failure

 examples/send-zerocopy.c | 72 +++++++++++++++++++++++++++++++---------
 examples/zcrx.c          |  3 +-
 2 files changed, 58 insertions(+), 17 deletions(-)

-- 
2.48.1


