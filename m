Return-Path: <io-uring+bounces-190-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 906FC8000C1
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 02:00:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A74F281604
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 01:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F0CD63A;
	Fri,  1 Dec 2023 01:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NMVywn+T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C7C173B;
	Thu, 30 Nov 2023 16:59:29 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-40838915cecso14904545e9.2;
        Thu, 30 Nov 2023 16:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701392367; x=1701997167; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DCovVFDKvkXq+97AfUx6ubrKnI0Lz7CYohHuF1C06i0=;
        b=NMVywn+TX0d5mffVpfEv/h4dpex3Z8hVkjrOU55wCowPcxk9AMuAHjhXY6sC47sE1z
         8kyzSfqGw5j9b5xgiGthMnyqa2kPRwkMbxnPOXsicslCTdQJIA0eIsKJW3nTsLIzly6z
         n/WW4O1d+KPTKj4+x5G2kogs2H/x+h7ZoLEFMuUZK55f4KRyIY+MUCC7pl5sPrZ+9T/s
         mxe4aZt92fSTIPTkodjnxA2kyYwH3oiDeuFk6fI0U1+FOx+QEr7U4sfFAqUfid7bg4CX
         7WFwwNX2q4DxwzWJShpZr3aBUeHHwWQ9vj7MmbN5pGUQETvyzXmHBv1F6nJnhvufo8/J
         uBCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701392367; x=1701997167;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DCovVFDKvkXq+97AfUx6ubrKnI0Lz7CYohHuF1C06i0=;
        b=VsWXNxez/zjdS+3jbo9F51tyR3P8DTy5pJmiaYSzWbu1M45+LWGY4HyUxZ1ynU0K7o
         m4tD8XmkY8yHg4F2YVA97CqHtQ6H9exN35/eElT+KTp33qU1Aeec/WO6RbgmcMKZuiqN
         0RMdfWopxDmK1gdd0O/nesyEjQkYbk7mRvoZWHRCrVdDHANcTQayQDAoGvJTKknhYr3d
         MpIF6i8zUqs7feV5JtleWBjItHvJVbfbS9vW8CYmknRMR3nHGrOn2/+cLqSJFls1mWeG
         anyszAp+Qos2JinpZk17Va/VOwxfI2TcN+dVVwAblK2ht4B1/2ltoEr0BCVh6webVsgd
         6VBA==
X-Gm-Message-State: AOJu0YwAJ19xRjAuq7vatoweuo1RN/lE03VmAtDcSByAD8Kd9srLGATE
	kSPgIszvcfHyCHxOEQ4GnFwQayKPqRc=
X-Google-Smtp-Source: AGHT+IHvsA3FlPe2VVg3VzV19jVZA+1llGaXu6/xVZ1oh7SLF/MhKK/s+Zpw3AwC5Y/gkhWKhNtulg==
X-Received: by 2002:adf:e68b:0:b0:333:2fd2:68f5 with SMTP id r11-20020adfe68b000000b003332fd268f5mr216762wrm.136.1701392367049;
        Thu, 30 Nov 2023 16:59:27 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.191])
        by smtp.gmail.com with ESMTPSA id ks19-20020a170906f85300b00a11b2677acbsm1250511ejb.163.2023.11.30.16.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 16:59:26 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	ming.lei@redhat.com,
	joshi.k@samsung.com,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH v2 0/3] clean up io_uring cmd header structure
Date: Fri,  1 Dec 2023 00:57:34 +0000
Message-ID: <cover.1701391955.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Looking at the zc rfc, and how we tend to stuff everything into
linux/io_uring, start splitting the file before it becomes even more
monstrous.

V2: fix up includes for security/
    Add new files to MAINTAINERS

Pavel Begunkov (3):
  io_uring: split out cmd api into a separate header
  io_uring/cmd: inline io_uring_cmd_do_in_task_lazy
  io_uring/cmd: inline io_uring_cmd_get_task

 MAINTAINERS                    |  1 +
 drivers/block/ublk_drv.c       |  2 +-
 drivers/nvme/host/ioctl.c      |  2 +-
 include/linux/io_uring.h       | 89 +---------------------------------
 include/linux/io_uring/cmd.h   | 82 +++++++++++++++++++++++++++++++
 include/linux/io_uring_types.h | 31 ++++++++++++
 io_uring/io_uring.c            |  1 +
 io_uring/io_uring.h            | 10 ----
 io_uring/rw.c                  |  2 +-
 io_uring/uring_cmd.c           | 15 +-----
 security/selinux/hooks.c       |  2 +-
 security/smack/smack_lsm.c     |  2 +-
 12 files changed, 122 insertions(+), 117 deletions(-)
 create mode 100644 include/linux/io_uring/cmd.h

-- 
2.43.0


