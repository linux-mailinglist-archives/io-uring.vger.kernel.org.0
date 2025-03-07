Return-Path: <io-uring+bounces-7022-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E89AA57082
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 19:28:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE58A1899679
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 18:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C14319ABC2;
	Fri,  7 Mar 2025 18:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fIuid0Af"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E4E23BCFA
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 18:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741372105; cv=none; b=WEI7BqKmXkHA4QYRR18Us33PjR8d2MNQHAfHokCTn2IqnYJ8MqzKLhJFuaL4s8Zkb8AnRpeHISwWsZdVDbShnAPb4VGOyHtjXulLdh+ZhBaaFcF5wnIXt1KLVymngnbMWu4Lj901u2oioJaFghKgqU10qKejDnsZQW/fJ5vRiiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741372105; c=relaxed/simple;
	bh=A4y8Uyl306Lx1VtkS4wqX747CSsMlfQK9wf0GSF0zZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IjzBAJK/ePxRhG+1XiwQV6+iyHwjB5yhee/lg/xth9EED1+LjF2JxGGtLfqO61DzW8Z1/YPvzok4DRjr/OwJWgivqZFUK0dQ4FjcVX4aELDOl4rh+TJy4vYHZTr4oH1i52zFXnz2k1Tb8jx7+bimBdbcEvnWFbRG2N0JdEbsr6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fIuid0Af; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5e095d47a25so3984310a12.0
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 10:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741372102; x=1741976902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OxqVizpkcPPO4l1MdLrly/z3pJBRb1MdctGbFZOIcQs=;
        b=fIuid0AfdKioa5NvQfABJYGAhcW9a8o84ZMc9rScpUYYw3XL0kjluGgntkwNF2A1bs
         8q/WsHojX9Hjg0QrBJLN0IrAPtOO6ZUvaDXBAlQYGgTI2W7wOlM1sd5kvfo1NmXEW7yG
         40Y3VWtG4NfAhGDoqel87DAQDN2R2nQdfzvw/FvFkuzd1w84k7Etj1itjR/g7E5WwYek
         KJaZmvrzp9VSOjofrGfQQLFU76A+cp5g/YJkL4KUps3u+EYjtuE/Po2T34wpsPMtF8Zs
         6stJBuogBTfWv7mlCR2XAHkUpNzCkiCbTfTS2sSed6GkbcmBSy+FrZ0TS7r5NjIoGCCK
         EHxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741372102; x=1741976902;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OxqVizpkcPPO4l1MdLrly/z3pJBRb1MdctGbFZOIcQs=;
        b=pyvmhTnHdfLxsbCalnQIHySEgrpJ6N56Qywy91cCLskVruY6qrpKrT9WggyUebXH/i
         kjgtKEPIQPi5oKFayaZt4WYphYLbxpIwibJyFLECwnskBZ5k6pZaAn9Fdkce1NlQDATS
         z3Th3CMH5c+e3HClrXK37alqQyW1NBhmqAfKGIU7marfke0bkgKiTM+5mF2Yd4H9BkMc
         A8Ihp0nVu0iCJpSyQUvnvyHQMz4m8thlVsD8NYN8/ZQmoMJohG734JpfYv/7jvh0506a
         kjNdpXLAoh5auEVulHPoHXZ9XbQY1aftbCgJnCtHuV+C8ysVO+cFp9XjN54gZUTegYxM
         isaQ==
X-Gm-Message-State: AOJu0YyK76DcuvLZnm3nDBTTZ5nwbmzhZDEuqziSNapF5QUihWwxy/+t
	2IxDnTVQ+cfwk60dqF6/Qy/yDYvHmddVU1hd257T/08QudNbWFBvy9l6Ow==
X-Gm-Gg: ASbGncvAzCFXFWQrNyqAi3uxkIUNxpCPBHWpFsgIiWO+xHwLWsHxX9WgQKQwQChIbey
	3HxufAquV5kd5zCV1zLYdPtYWGMkmSjYJGVMvmL7i1/P2n35b9GhFM0+x0uX1LpzxeVJBOi+bh4
	fgWXCJ3M08/pbY6IikfSnuX32EZBn1TtWLLnHwx1gprDCn+/Km4m3ba5vH6VN4eHZre6W+lB6Wt
	hjXEocvt+iM+kpIhc3KZ8jvcxTmuaCur2s8oedR4ZlsGVXS8SGErEF2SkOuQdk7P3KC9XVzLEiA
	BAc8v3yXRKp6CF7uRyZiibjp5GyubR+7iZK0p8XOLua1NrmrPs5AgNNuxw==
X-Google-Smtp-Source: AGHT+IH4cNCq1YZhPMPBYANaJk0WlxFrZ+wre28Pb8xmzCyP0NNZ/7vFkXv0IEjtrkUF+c+1FfMJdg==
X-Received: by 2002:a05:6402:2550:b0:5e5:c5f5:f51 with SMTP id 4fb4d7f45d1cf-5e5e246894cmr4246446a12.23.1741372101513;
        Fri, 07 Mar 2025 10:28:21 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.206])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c74a9315sm2883230a12.46.2025.03.07.10.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 10:28:20 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v2 0/4] vectored registered buffer support and tests
Date: Fri,  7 Mar 2025 18:28:52 +0000
Message-ID: <cover.1741372065.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It should give good coverage, I plan to extend read-write.c to
use it as well.

v2: Rename the new test
    Fix helpers opcodes
    Use the helper
    Update map

Pavel Begunkov (4):
  Add vectored registered buffer req init helpers
  test/sendzc: test registered vectored buffers
  tests/helpers: add t_create_socketpair_ip
  tests: targeted registered vector tests

 src/include/liburing.h |  31 +++
 src/liburing-ffi.map   |   3 +
 test/Makefile          |   1 +
 test/helpers.c         | 111 ++++++++
 test/helpers.h         |   5 +
 test/send-zerocopy.c   | 138 ++--------
 test/vec-regbuf.c      | 605 +++++++++++++++++++++++++++++++++++++++++
 7 files changed, 780 insertions(+), 114 deletions(-)
 create mode 100644 test/vec-regbuf.c

-- 
2.48.1


