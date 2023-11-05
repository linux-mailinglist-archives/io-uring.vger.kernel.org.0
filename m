Return-Path: <io-uring+bounces-25-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 337AC7E175B
	for <lists+io-uring@lfdr.de>; Sun,  5 Nov 2023 23:30:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BA57B20DF3
	for <lists+io-uring@lfdr.de>; Sun,  5 Nov 2023 22:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FCEB1A733;
	Sun,  5 Nov 2023 22:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aDTvKC0k"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA541A708
	for <io-uring@vger.kernel.org>; Sun,  5 Nov 2023 22:30:27 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70664CF
	for <io-uring@vger.kernel.org>; Sun,  5 Nov 2023 14:30:25 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-40806e4106dso23060105e9.1
        for <io-uring@vger.kernel.org>; Sun, 05 Nov 2023 14:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699223423; x=1699828223; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZIldzcbfUXy3Lf2f8/C5Y/pUe9uV4x1WSmxgVf9S/c=;
        b=aDTvKC0k/J5HQr91XCRwuGU+dHIzTaZ5XAU+JLn23X+kxmQlgATWyNMSIqaKS8+gDy
         apijaPevw9EkjA19C/l2VONskwzBgbkeTF2PdUctXDGR6BAdkdc170/Ua1hKMfI8kJJR
         dRB87wvaEAkf98xgvZDHuqbBNsuwah+htBbd3+sH+WR6xoJLdyTWhWoK4XhB/4sr44YY
         Auoffgr0zr1kubEPfcZ/Mimx3EB/WcjKlT1LSgmb1gia5cQob1ZMJieBcu2hQj3rp258
         7UY2tm48LqnZQvP02L/V3OgmkWSphjCIppklbzykQl0scxzSoJq95YCwxVGWZloxAdDi
         Ci2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699223423; x=1699828223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ZIldzcbfUXy3Lf2f8/C5Y/pUe9uV4x1WSmxgVf9S/c=;
        b=Jw/3dhHES66GYdYMYgNqDibRciHazIk88L/UZnVdpcwB9jyooRp81RMNMiFoOk9pje
         1BgHo+LNZwofnHfryoj4W9BZ9PVoPZopu2d/h1Xk9+bPYZ7j7oVhtphQgkIioBc2m5zu
         ygkHGgXN4RUDkoIRoVGXX3hHDpuE2UrT7pv9Lti7EwA1owaa4bmlK07DZugPX4O1iPFw
         XqgNP+lK+xy6WPK9/24NNtovSzgE37tJQ5ALKK0jdosaiTaiueJR47AjyszC8AIreVTP
         Y5kvPP8XT4eNfcCF1Mc9W6BLY6S8KHYc1hG7eXMDXLkXRViMzZ8OKtID+INv8HPsh+3A
         cdcA==
X-Gm-Message-State: AOJu0YzTaHL49H5VyrnQEaE+IibO5OMZI7S9g8PtB/x4shm3a6phr/aL
	TRnPGcNo8pii5xKselKylxZKKCEU+zI=
X-Google-Smtp-Source: AGHT+IGG71Z0jCe7q65nLQ8ZGLJd5tZOE6hjch+HJ64sa9Yd+8oyVkfyBrqrwYJFQKQGWc1cqRZTrg==
X-Received: by 2002:a05:600c:5488:b0:408:3634:b81e with SMTP id iv8-20020a05600c548800b004083634b81emr10419990wmb.13.1699223422898;
        Sun, 05 Nov 2023 14:30:22 -0800 (PST)
Received: from puck.. (finc-22-b2-v4wan-160991-cust114.vm7.cable.virginm.net. [82.17.76.115])
        by smtp.gmail.com with ESMTPSA id m26-20020a05600c3b1a00b00407752bd834sm10244267wms.1.2023.11.05.14.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Nov 2023 14:30:22 -0800 (PST)
From: Dylan Yudaken <dyudaken@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	asml.silence@gmail.com,
	Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH 0/2] io_uring: mshot read fix for buffer size changes
Date: Sun,  5 Nov 2023 22:30:06 +0000
Message-ID: <20231105223008.125563-1-dyudaken@gmail.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series fixes a bug (will send a liburing patch separately showing
it) where the used buffer size is clamped to the minimum of all the
previous buffers selected.

It also as part of this forces the multishot read API to set addr &
len to 0.
len should probably have some accounting post-processing if it has
meaning to set it to non-zero, but I think for a new API it is simpler
to overly-constrain it upfront?

addr is useful to force to zero as it will allow some more bits to be
used in `struct io_rw`, which is otherwise full.

Dylan Yudaken (2):
  io_uring: do not allow multishot read to set addr or len
  io_uring: do not clamp read length for multishot read

 io_uring/rw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

-- 
2.41.0


