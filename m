Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1881D3A2F77
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 17:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhFJPkW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 11:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhFJPkL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 11:40:11 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BF8C061574
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 08:38:01 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id k5-20020a05600c1c85b02901affeec3ef8so6887469wms.0
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 08:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HD98rzzeIB6rQfQpcLXKisywnwHBgIwVfF01p7YDXcs=;
        b=fVtXQ7Tj6l1djDk/KbxQiA6q5EIbACwzGazoR+/oAJeTfmNzIXT3SeUrUkwkWwc8v5
         yrRS4Pshv4zH6GU0ZJF+QCkuyybsGAHvYWq499LhpzQWZSL/vslsW2rnVCbgFHcVffeQ
         VhIx6XefDMlgYYw74csfHiz+SEbdyb56tV3ePqPNwODwuCKUgPd3cjikLwiuTL/55+zj
         ErbFr1VTmSAFsHsdYodmoBhsSobO7n454Qq2LuAi5Z3TEfaH/Ew0FCtcICFdjkv+W7Xw
         kIGVewAZchYKzGgCL1QIMI2VRefO1caQYIJXMCZma45p4HKapkwrd/3SHn6Y6nyui9I9
         YOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HD98rzzeIB6rQfQpcLXKisywnwHBgIwVfF01p7YDXcs=;
        b=ozfme2i3nRdDWWo4nhUuxAdiaoxLluJKgzvmk2e9YXWYJeb9iQDZhF5UnYzJwfo64F
         igff5G8iLz/fO9qJ09tWMe4mlAFfXZF565e8cSbMUxQmnEGzrCFSfmVwYnKyfesz7uZJ
         o3WgpLaCYZg436w/EirauvMLexVER0MPprLxbIIM8P3Q84HMjFYXGyJdx+8pooyXECdt
         bVL2mSFi02gXQie5MNZRWYpXv/O3nOIDriQvODLYSmNVb8dANWBtMVTWe5W4FNofjtA7
         MELBdXxA4IAT98nXEOf+QW4/pnkHwg6kAowM8CAPa2rgZO+B6nZsf0fgiE1YRMl1nAtt
         sNBg==
X-Gm-Message-State: AOAM530vEd8PPDuvA8FtFa7KPwYsQePvuombp8sXvrXyD4aeMDv1Af4J
        un4HzKU1y9DwurbgsOPHIl0=
X-Google-Smtp-Source: ABdhPJxrpq+khuRWNkzxG+txo3OP+ebRiLs9h4CxiMSCnD5OWU3fflOsTE6q9QPkfoUiBzyHn3Au1g==
X-Received: by 2002:a05:600c:358b:: with SMTP id p11mr5653355wmq.112.1623339480564;
        Thu, 10 Jun 2021 08:38:00 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.95])
        by smtp.gmail.com with ESMTPSA id f184sm2388825wmf.38.2021.06.10.08.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 08:38:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: add feature flag for rsrc tags
Date:   Thu, 10 Jun 2021 16:37:38 +0100
Message-Id: <9b995d4045b6c6b4ab7510ca124fd25ac2203af7.1623339162.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623339162.git.asml.silence@gmail.com>
References: <cover.1623339162.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add IORING_FEAT_RSRC_TAGS indicating that io_uring supports a bunch of
new IORING_REGISTER operations, in particular
IORING_REGISTER_[FILES[,UPDATE]2,BUFFERS[2,UPDATE]] that support rsrc
tagging, and also indicating implemented dynamic fixed buffer updates.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 3 ++-
 include/uapi/linux/io_uring.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 663fef3d56df..fa8794c61af7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9676,7 +9676,8 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
-			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS;
+			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
+			IORING_FEAT_RSRC_TAGS;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 48b4ddcd56ff..162ff99ed2cb 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -280,6 +280,7 @@ struct io_uring_params {
 #define IORING_FEAT_SQPOLL_NONFIXED	(1U << 7)
 #define IORING_FEAT_EXT_ARG		(1U << 8)
 #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
+#define IORING_FEAT_RSRC_TAGS		(1U << 10)
 
 /*
  * io_uring_register(2) opcodes and arguments
-- 
2.31.1

