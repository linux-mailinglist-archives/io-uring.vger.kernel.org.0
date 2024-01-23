Return-Path: <io-uring+bounces-464-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0DBD839B85
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 22:55:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5048A1F22660
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 21:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA3F47F5D;
	Tue, 23 Jan 2024 21:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="eWR5/Ay1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CC745C12
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 21:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706046911; cv=none; b=MICKM1sMQpxg8TsDYFL2gMEMLp63MIiRRDk+W8BW26HOYrzHNIX21NR+WEMIGfax/OhaHhRGmBUJyEUysGFW4wN9abgb4eq1VRNfiTjOW4ErIgW3tTfU/bnE9CJ27wcAPHMk9NwVRsfAiy9O2ZTZbxxmC2Ff6tYgZ111HGTp/VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706046911; c=relaxed/simple;
	bh=C7CYzH+xBSmnm8JMUI0gWqSLf8ydb7G+sBRYyUFAD78=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FmwyDTrOQtZERI+kwBaVVk2IK4Uwh0+u5f+arR1kd1hUnnXm0BaToF8fhzn3oe80VreIKjLkb+qW4PCEwL8iImB4nU2NAkTNnEEn2Rp0B9O9NCfUU2oc+fzT36nVAKdzgnuS+q5ryRC94IpjRRfTgo1Wf8fu78xcolA297ZsTj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=eWR5/Ay1; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-4bd563d0222so108711e0c.0
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 13:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1706046908; x=1706651708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b+TXC7Cl8RW7R6tVYRCFEo3eVAAYyrP4TFYZ+SMkqWQ=;
        b=eWR5/Ay14RJdtVv6QdpEOg7cxHHS3y/P4aDE89cJLdwp77p5F20D5pxXPmAfsX+Ip0
         4AdS0rsbrpSOkhQsdLlqUHyXA1TdUGMUfVP/YzhZVAJRWDZhwZ76eyZFsd2AuIrAnoeW
         JSAyzmdaD3zZzMYNKGYqSjjZjaivI7xu09AophSonK0o6kdn4JAUmiYfWZ7y7pBTyI90
         2e68JYS3SuRCvD7qUpGKFs/WmsHMQTOocHhqLOnlJFEu1e3XpZ6tHomSNMj8Hec2+Lwt
         hkJmJHWIp/hwttxz1GWhrMpVE0pzmHEDEVzK5UokZiBu9MW8Eh30zUjd8C5F0RvjA7oC
         GLXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706046908; x=1706651708;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b+TXC7Cl8RW7R6tVYRCFEo3eVAAYyrP4TFYZ+SMkqWQ=;
        b=cGD9MpbyuIrb+eFJBC+0D52c20Ip6R6ACfbvLh740CVW1VXDfsYcmfrDJd4crAj5Z8
         jHPJlWq5l1ZrkiR+xKlucJmUdIj17SsTKVCCP2KI9m3D7Bh7FQJCUxU/GFmi1EsjoyXy
         DxalxGK+dj10fikw7dg+xGpXkIQiOjq9fmetLZFnkg3yLEP60fkiO1y4ejOD4LqFBphu
         RyE+tk30ietyftIB2TapocAMztviTumFtXzUM3PQrc/eZ3hC7xTiMrvSSE/8DBNZ2XK/
         ciDhoz6LNgaGnzGDX+pJeruhUqCIFzsRrrbfmzfzS6UUlw9L5grsHAf7ya56lnbKh+yJ
         D1QQ==
X-Gm-Message-State: AOJu0Yw4ydqhrQFIucE5SLKMIqc0mhaIyAWPOXiQPxBZ/z2CbK57l+//
	U4vrNLG4OPYZHAdpPq/YY9vnC1lL5bH60h2xJwb+5hPCj7KmnRxAcH8y5Cq8ffTtC1pw2jm1wI0
	=
X-Google-Smtp-Source: AGHT+IHENJcaOYD/BjnI4SGPEEQJpeJSGQ80ajTMAxZDFVY5z1j4z/4pPo4EsxQlBeCXpjC5Ohq6Iw==
X-Received: by 2002:a05:6122:46a9:b0:4bd:5cd7:ed61 with SMTP id di41-20020a05612246a900b004bd5cd7ed61mr290859vkb.13.1706046908257;
        Tue, 23 Jan 2024 13:55:08 -0800 (PST)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id sq9-20020a05620a4ac900b0078322b61e88sm3446592qkn.78.2024.01.23.13.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 13:55:08 -0800 (PST)
From: Paul Moore <paul@paul-moore.com>
To: io-uring@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	audit@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: enable audit and restrict cred override for IORING_OP_FIXED_FD_INSTALL
Date: Tue, 23 Jan 2024 16:55:02 -0500
Message-ID: <20240123215501.289566-2-paul@paul-moore.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2489; i=paul@paul-moore.com; h=from:subject; bh=C7CYzH+xBSmnm8JMUI0gWqSLf8ydb7G+sBRYyUFAD78=; b=owEBbQKS/ZANAwAIAeog8tqXN4lzAcsmYgBlsDW1WF6BaX5WOEzusgRno3YFlZoCzyanmrpVE hajSmWN3XyJAjMEAAEIAB0WIQRLQqjPB/KZ1VSXfu/qIPLalzeJcwUCZbA1tQAKCRDqIPLalzeJ c70tD/9E+YEUzwQqLqdfNoOjtAonOXUS+ug1BCbir99Tq7hcZRiFnMtCUE+eQWUU9ZhJ0Mr4FER ii2b3PHs2yfF6BEJ2LOmItz4Z19z2xZBKetiaid/YwTZt5BRbe/Toz9rN8mzhWBIdJv96PidL0Y BdBCXjps8TS0Ya8AFJO4wXs2AfbjqQezBSS+t1HLn+lNj3QRdT6lEDIESzOb30tm9fcHWmRj/ak EhvNUqSMZ1Txlx9jValm+9/lAdyucwfBFw1+DmDi9Ubx7v8rmHXGG0yy2R6Ehnf+aZkQDVh8IcD 0rIhLjpk0pVquJMo7Ae77aPyFoAv1w8zi8To9vOq5bOaKpHwxQoKU5RYVavjZs7PMN0DvIoZNmd 1yhfFvp1YlKrx/w07a4yV4Yde708KjBOE1NUuCBXjspglvKfxzJGy8RRLhD03EcPGv6gJgQ9A86 4xjHeI5U/t70BKwnqC9kRl13BWSMdwJPFAzfcUJLBp2sInpbpxZ16kQG7Op7snyCprNHAcqME5c JDtQb3JrZr32wnfIQ5iPfAAKFtLl+JsQ5D4EW9iZx2Y4yalWBHY1lwrpDR+KAQo1tfxvcP6DNfD i5/dmVPvqcupwHLdxwZYqu84iXO50IX5PVPpD7QNlThfI1vhnv/Sh3ls0qk8brKqgZX0pQlQ8oa 8GFfeccE+6c1lSA==
X-Developer-Key: i=paul@paul-moore.com; a=openpgp; fpr=7100AADFAE6E6E940D2E0AD655E45A5AE8CA7C8A
Content-Transfer-Encoding: 8bit

We need to correct some aspects of the IORING_OP_FIXED_FD_INSTALL
command to take into account the security implications of making an
io_uring-private file descriptor generally accessible to a userspace
task.

The first change in this patch is to enable auditing of the FD_INSTALL
operation as installing a file descriptor into a task's file descriptor
table is a security relevant operation and something that admins/users
may want to audit.

The second change is to disable the io_uring credential override
functionality, also known as io_uring "personalities", in the
FD_INSTALL command.  The credential override in FD_INSTALL is
particularly problematic as it affects the credentials used in the
security_file_receive() LSM hook.  If a task were to request a
credential override via REQ_F_CREDS on a FD_INSTALL operation, the LSM
would incorrectly check to see if the overridden credentials of the
io_uring were able to "receive" the file as opposed to the task's
credentials.  After discussions upstream, it's difficult to imagine a
use case where we would want to allow a credential override on a
FD_INSTALL operation so we are simply going to block REQ_F_CREDS on
IORING_OP_FIXED_FD_INSTALL operations.

Fixes: dc18b89ab113 ("io_uring/openclose: add support for IORING_OP_FIXED_FD_INSTALL")
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 io_uring/opdef.c     | 1 -
 io_uring/openclose.c | 4 ++++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 6705634e5f52..b1ee3a9c3807 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -471,7 +471,6 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_FIXED_FD_INSTALL] = {
 		.needs_file		= 1,
-		.audit_skip		= 1,
 		.prep			= io_install_fixed_fd_prep,
 		.issue			= io_install_fixed_fd,
 	},
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 0fe0dd305546..e3357dfa14ca 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -277,6 +277,10 @@ int io_install_fixed_fd_prep(struct io_kiocb *req, const struct io_uring_sqe *sq
 	if (flags & ~IORING_FIXED_FD_NO_CLOEXEC)
 		return -EINVAL;
 
+	/* ensure the task's creds are used when installing/receiving fds */
+	if (req->flags & REQ_F_CREDS)
+		return -EPERM;
+
 	/* default to O_CLOEXEC, disable if IORING_FIXED_FD_NO_CLOEXEC is set */
 	ifi = io_kiocb_to_cmd(req, struct io_fixed_install);
 	ifi->o_flags = O_CLOEXEC;
-- 
2.43.0


