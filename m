Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E59579ECD3
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 17:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjIMP2b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 11:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjIMP21 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 11:28:27 -0400
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794111BC9;
        Wed, 13 Sep 2023 08:28:23 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-50098cc8967so11230224e87.1;
        Wed, 13 Sep 2023 08:28:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694618902; x=1695223702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+vvxyHXTfiSW+8d09yTsLSiY7Ry74wlSEWGj/O1wQD8=;
        b=ID3aFaZrNBfatNHIcF2NhNrJIe4CRwfzK1LnEMS+UWByX5zZqaEFxRRYdSFrRwDwy+
         aNW7Q1nsuGzP7dJtrYxscAaRZWHnl1APV8enrlZ+27UWhn9kJhcLGQkqe04OwN82OsFz
         Q/WgW9/28cKN3p5bpukpjCH3hrf9QDummyU6I6WZZuytCK5C/eWiN0XoiXTVv3tWrpSm
         niVoPVTPrrJY6a3lQEX6hzkiOK5QXk2on4NbZBT2rsO4aFolozc1+hDbzETk9a2QSClI
         3y444Zr3BkgudiyHzsJnaBRZ6l4HZzPGzA27v1Kh1d/IZCEIfrv8AkuY/4hbEwV6RGSv
         7CHA==
X-Gm-Message-State: AOJu0YzIBropAgKvxi40wTJe7b3a4PHGDvxeLssJqbqSrvVWIghiazHG
        LmnAxa5125iMx11ingdvHho=
X-Google-Smtp-Source: AGHT+IFkDHP8efksOvVhO+b094unbQdjltuvg/Q7103ZxOgGHV9iGnK7Ay3GrpY/UFr/gRMRmdwR2w==
X-Received: by 2002:a05:6512:3e17:b0:4fe:676:8c0b with SMTP id i23-20020a0565123e1700b004fe06768c0bmr3139980lfv.11.1694618901572;
        Wed, 13 Sep 2023 08:28:21 -0700 (PDT)
Received: from localhost (fwdproxy-cln-017.fbsv.net. [2a03:2880:31ff:11::face:b00c])
        by smtp.gmail.com with ESMTPSA id oz13-20020a170906cd0d00b0098951bb4dc3sm8608469ejb.184.2023.09.13.08.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 08:28:21 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v6 3/8] io_uring/cmd: Pass compat mode in issue_flags
Date:   Wed, 13 Sep 2023 08:27:39 -0700
Message-Id: <20230913152744.2333228-4-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230913152744.2333228-1-leitao@debian.org>
References: <20230913152744.2333228-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create a new flag to track if the operation is running compat mode.
This basically check the context->compat and pass it to the issue_flags,
so, it could be queried later in the callbacks.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/io_uring.h | 1 +
 io_uring/uring_cmd.c     | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 106cdc55ff3b..bc53b35966ed 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -20,6 +20,7 @@ enum io_uring_cmd_flags {
 	IO_URING_F_SQE128		= (1 << 8),
 	IO_URING_F_CQE32		= (1 << 9),
 	IO_URING_F_IOPOLL		= (1 << 10),
+	IO_URING_F_COMPAT		= (1 << 11),
 };
 
 struct io_uring_cmd {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 537795fddc87..60f843a357e0 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -128,6 +128,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		issue_flags |= IO_URING_F_SQE128;
 	if (ctx->flags & IORING_SETUP_CQE32)
 		issue_flags |= IO_URING_F_CQE32;
+	if (ctx->compat)
+		issue_flags |= IO_URING_F_COMPAT;
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!file->f_op->uring_cmd_iopoll)
 			return -EOPNOTSUPP;
-- 
2.34.1

