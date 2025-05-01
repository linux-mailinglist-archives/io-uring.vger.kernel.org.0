Return-Path: <io-uring+bounces-7798-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FBE0AA5E39
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 14:17:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D9821BC4086
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 12:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3DA722A1CD;
	Thu,  1 May 2025 12:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fKxj0+ms"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E853226CE6;
	Thu,  1 May 2025 12:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746101799; cv=none; b=pHrfkioknodiapfB8UxDe0Y9wi0EquwQ5ysSN8G1FmLtb8XyAvTi/IHf3mFQsW4kBLgBsa1qLO9tVWclhKV+BVsPUgrSU/4eQrWpZVvjh5qEhNVLwlwBLt3fYJYalqZlfgdEVCYjdKHJZF1Aorbya4tvJuNC+W0DnW6P7JnMyhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746101799; c=relaxed/simple;
	bh=+YZmRaAj1d98hnSpg9TViCKCIRGXCCMU/yUP5GL0iPA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GIb4NNEWJGzSOhKaWxZsjo0SxqLRh/8FENKX6Co4bs6ReB0qMAwaR1FA/fTt1beum4gObXKcK58AWI2TzrpZmKqLRVxMWQc3hbNViJvj4y6ZS+ukm9UO9W6wrkTDRZuNCYGKjypS7iugcUtf+pgDI2CXPBPgABgG5c43rbdpYT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fKxj0+ms; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5e5e63162a0so1278274a12.3;
        Thu, 01 May 2025 05:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746101795; x=1746706595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k5ifP7701xX/q9HHhTWeOLD9et26fC5Alp12CmuKzXU=;
        b=fKxj0+ms0/KpaGTqZfdHn9nQuuUW2x6p9vXtZmAJw9ofoAqZcNvLllhNekSElj9zha
         8V5UDztM7/f1dGpdt4BFR95+eSrspSW9pI5srIExDFLJ2pXBcARXYiLsoQjdCvx9B78T
         AFI1/SANtHoAgizd18uMCwPAQzF2QJyzOjsVQxRDeioTtqGme93DtqkmIfCvzoXRRFVr
         MDen0PnW69zL8w14j7IfUB2tRuA4c2wt2WwwXEoMGvQ35mxrpO7ou+MqNPqLBV3HguK6
         S1Aj0D+E/dr87TaFL640VDoG1+UY0m22/qSoVEFlcE/nOyR2DPS081R/hQEXsWsN/arJ
         emEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746101795; x=1746706595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k5ifP7701xX/q9HHhTWeOLD9et26fC5Alp12CmuKzXU=;
        b=eQR5xnsnTcla/0eryU9+3DVUCJEMBa2zDCXIhtjhH+YwjphlEPRsrXwqX5JQndXLgT
         pmiJ94uW3iZLU5s5I38mTQPD4P3ZKDXYmJ4xWBMUkH7VMiajyV2AUyXZh2tsMOputtt+
         BNK+wAE0uoLbpaj4UcDJKP7G7onKfv5sx7tJXyw8J+IQz/fjETp6ek/fOrtylp2ir6/e
         8IgbYanSdxQ658EGXICYDNCZLeyn5tQpXzDxaNVseIgMFLzLSn64jOewh1xx4Bz9bE4m
         Slr/I2SWUuuMJ4px7ThN4m/6fXxFRRJNeQo1oX6ZdisHUd6lnDEjB3RBNcmvVV47Wfbt
         B12A==
X-Forwarded-Encrypted: i=1; AJvYcCXE3MGe3TzCkqHTM4SzQKrRyGY9tghxYFrdqSZF5gbS5IsYvPDMwUjHsuYAzF+M0Wdk9H4tJSU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCOjY0L7pmNPTIQqH0/I6kARt/yc0+JC9ohY0hTnR70mhgMij4
	cACTHkDp6JcoCOh3JJigU6hQzn8zbQIPbRu2H1uAd4Yk/MSVeCParQ3EAw==
X-Gm-Gg: ASbGncvkrX3yRnbQF+yhxfeWxCgdYsDhmRcGMMI4NrHN+fqkEXPYuKa6XFhsmAedAgE
	enBnCREaMQwF2xko6/IpYJsZtWmW/TksCWqxEczSctrkOq9MD0SQqKWe0+2F5Qh2jypb1H0eLgU
	2h3L1Bqt9873dzg41bV82XDOZlEJ7lIfPNI5o+azm7/J59WIRX7/NkT9Rb5xIhlmR+H1L41Qkc7
	vGHXUUdiNgoVg/Mzxp2hQhldcneJEEYbtzlrxqTiGFptLSCenu7GyLe7ToMxFV/SwsSqqdQ3WqA
	HMK0SY+uLj43GcJO65du3vIgdp6YTOht5uQ=
X-Google-Smtp-Source: AGHT+IHJpt3cCmG/EgkKKvIsl9ACDk1eVBDJJ172gsRl+yVZev9N3JC22xmaJe6vtL9P7lH4YSgO6A==
X-Received: by 2002:a05:6402:845:b0:5ed:2a1b:fd7d with SMTP id 4fb4d7f45d1cf-5f9193dfad3mr2105987a12.19.1746101794570;
        Thu, 01 May 2025 05:16:34 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:9c32])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f930010655sm346146a12.73.2025.05.01.05.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 05:16:33 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>,
	netdev@vger.kernel.org,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH io_uring 0/5] Add dmabuf support for io_uring zcrx
Date: Thu,  1 May 2025 13:17:13 +0100
Message-ID: <cover.1746097431.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, io_uring zcrx uses regular user pages to populate the
area for page pools, this series allows the user to pass a dmabuf
instead.

Patches 1-4 are preparatory and do code shuffling. All dmabuf
touching changes are in the last patch. A basic example can be
found at:

https://github.com/isilence/liburing/tree/zcrx-dmabuf
https://github.com/isilence/liburing.git zcrx-dmabuf

Pavel Begunkov (5):
  io_uring/zcrx: improve area validation
  io_uring/zcrx: resolve netdev before area creation
  io_uring/zcrx: split out memory holders from area
  io_uring/zcrx: split common area map/unmap parts
  io_uring/zcrx: dmabuf backed zerocopy receive

 include/uapi/linux/io_uring.h |   6 +-
 io_uring/rsrc.c               |  27 ++--
 io_uring/rsrc.h               |   2 +-
 io_uring/zcrx.c               | 260 +++++++++++++++++++++++++++-------
 io_uring/zcrx.h               |  18 ++-
 5 files changed, 248 insertions(+), 65 deletions(-)

-- 
2.48.1


