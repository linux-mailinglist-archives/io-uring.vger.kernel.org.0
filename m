Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0C16CA922
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 17:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbjC0PgJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 11:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbjC0PgJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 11:36:09 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129162101
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 08:36:05 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id y4so37997041edo.2
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 08:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679931363;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EEsvkvsm864J2o/X8Iiqlszglpc/kZEfSbF0bhMJ4Y0=;
        b=jdoemcYQ/OSYncrjrH9wD5BKaAvsfymCLmT1XfzhxbfxaXmAFeb4qwZy6iwW51a0gh
         r5WsoVSYC+jbOeaPeu1soSQdIcXA41veFdb+KF97iEhXEp1QUxHZyrmxkL6kyuwnDiY2
         gn/I89bX/YXwOTnxkFGlxUPUdiWFLwhicyLxyr3qBZ1XkQiXF5GRsp7p9CYgmX3TgtoU
         Twhoiv6ckjRBHWNxpqCg1G/jLljDjD2RtFRwdmCidpZVMhFJuUI8/hUM6R6m+cDqjm3D
         dm+5ZrQxko+ThtnJ5iwdUQ4+mTSuKApfk75DZ4+4SYBr/inwCssmTgPg3Ffu5uRQSol6
         Pfnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679931363;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EEsvkvsm864J2o/X8Iiqlszglpc/kZEfSbF0bhMJ4Y0=;
        b=0SkN27NOBys143qRPm2c3jnD1miWyf5ojk0TeJoLXgdq0edm0MQtLQkVauHjlkqCIN
         ahVPzOPKSyWFiwkI+mCB2vo+gTSIXVENY4JfgB4B0fqL9H47yKsoi76xGAotKMjW8Re7
         +cNLdapnWmcqQYAo+nqTk7ABk0hWbQckFz0GiIMduj0F99uTesTjTgcBlTtZUWtUQ0F4
         TLkQUZue4IR/1O6XSDC01HzHVI7TOEkOfd5wykSrHHqksQRuux1h4WEzN9ehkwIY0xZQ
         wMfKg8FAihJH/i92ZomUknZQTEy0srtUUmfZ6OCXFvyifH84YphKmDl4hoa1mm4FUgHN
         KA3g==
X-Gm-Message-State: AAQBX9ejGhOGfLtoyJ2TAGzJgzQPba/qTJSx2hP2ScYhrau5kVLaXmET
        ja8eQ+LgA8eDpVS05IxxMA3BhLpw214=
X-Google-Smtp-Source: AKy350YekhyKPiCgFjrR9/nvgXoD8P421kq1xB5k3YAk1dh3x9m7jfxu43aposkj4vAB+Vcgc3GWJA==
X-Received: by 2002:a17:906:ad98:b0:930:6d59:d1f8 with SMTP id la24-20020a170906ad9800b009306d59d1f8mr12035458ejb.10.1679931363215;
        Mon, 27 Mar 2023 08:36:03 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:e437])
        by smtp.gmail.com with ESMTPSA id x16-20020a170906b09000b00938041aef83sm10025140ejy.169.2023.03.27.08.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 08:36:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: kill unused notif declarations
Date:   Mon, 27 Mar 2023 16:34:48 +0100
Message-Id: <f05f65aebaf8b1b5bf28519a8fdb350e3e7c9ad0.1679924536.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are two leftover structures from the notification registration
mechanism that has never been released, kill them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1d59c816a5b8..f8d14d1c58d3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -571,19 +571,6 @@ struct io_uring_rsrc_update2 {
 	__u32 resv2;
 };
 
-struct io_uring_notification_slot {
-	__u64 tag;
-	__u64 resv[3];
-};
-
-struct io_uring_notification_register {
-	__u32 nr_slots;
-	__u32 resv;
-	__u64 resv2;
-	__u64 data;
-	__u64 resv3;
-};
-
 /* Skip updating fd indexes set to this value in the fd table */
 #define IORING_REGISTER_FILES_SKIP	(-2)
 
-- 
2.39.1

