Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0596BD06B
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 14:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjCPNKo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 09:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjCPNKn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 09:10:43 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C5EBE5C9
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 06:10:42 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id eg48so7314875edb.13
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 06:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678972241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQrnfzqihFCU0I05+lAt0eKTWUHJ8lOtAXhnW48oYlI=;
        b=I2F93xFxAUGotsGISBvICBggs3ZWKBQdFaTaOl6mZiNFWfAr6+j6UTaEAlKGfRop6a
         /Dg0/iavU6gIixSmN6uWHHB1+18yumo2tw6TWxsJhEW8I79VcsQ6QJR6QTVRUrAHl7lg
         UxKYBdvRc78lLQsnItuvEBiz//a+5oqtkeIriwZ5+xSpeIpA7Vk84hIDqzV6g7axnDL5
         971fGOfYNckTa59iXu5vCHtWppeE0lWyOWURtmzrpJd+b1HZj33FGZ5Px91jgbQ2p0TZ
         V1CjcIh1Bhp1dIE6YKNZFLmVLtlkcDhhyABlroxlnrvAVK/N2JLC/ooCXVOW0DrNsCE/
         erJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678972241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fQrnfzqihFCU0I05+lAt0eKTWUHJ8lOtAXhnW48oYlI=;
        b=wQ3BulB7tv0+ssT1kddU9i6ukhcbxPpEZ9CdT6bOD0TvMk5DrvVOto9S9bTw8WCL8q
         izkQJdYQTem/vXhXko32gBqQRhln7Te2iXFqSLhKeFVRG5dkUbr27FshrWrIgEuSpXOc
         24azt09ch1aiWWqtn+Nf28leItcOD/6Ylwn8/u/a5ILASZYG2xwkJa7eb0IdUfggLMqL
         lGWClUbblBUtaO1IIUpi2KiNADgFK9H3w8IAuby9BlxG95vWveXhewcYe2m5pjbRmOgS
         T3kCmbrm9Fnv8bzXJnCYh7f5HWrlWpPegQHzCLCMj2FEf0D73W5JNQVo+d1wnGpAT7hr
         SBSA==
X-Gm-Message-State: AO0yUKW+K9bGFp4Nr5MxubIxHv9mowLj+sjTCtYzpfSfgAEEfUTrkAfL
        cUtgFQRKXDKfG2/mVH2Nif+aRktUYis=
X-Google-Smtp-Source: AK7set98Jmmbqt/05Bim7lBbyHoo/bOqXFPpTMkICQt+dMnllDKWWa6rePWU299k2Fr1Sgq/ygPj2A==
X-Received: by 2002:a17:906:4f1a:b0:925:6bcb:4796 with SMTP id t26-20020a1709064f1a00b009256bcb4796mr5840661eju.38.1678972240742;
        Thu, 16 Mar 2023 06:10:40 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7abd])
        by smtp.gmail.com with ESMTPSA id n18-20020a170906701200b00927f6c799e6sm3814967ejj.132.2023.03.16.06.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 06:10:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/2] Add io_uring_prep_msg_ring_fd_alloc() helper
Date:   Thu, 16 Mar 2023 13:09:20 +0000
Message-Id: <9237f9399e4d8fcc9c8c1996905168138f99d2b3.1678968783.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1678968783.git.asml.silence@gmail.com>
References: <cover.1678968783.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper initialising msg-ring requests transferring files and
allocating a target file index.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index bf48141..0848cf0 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1015,6 +1015,15 @@ IOURINGINLINE void io_uring_prep_msg_ring_fd(struct io_uring_sqe *sqe, int fd,
 	sqe->msg_ring_flags = flags;
 }
 
+IOURINGINLINE void io_uring_prep_msg_ring_fd_alloc(struct io_uring_sqe *sqe,
+						   int fd, int source_fd,
+						   __u64 data, unsigned int flags)
+{
+	io_uring_prep_msg_ring_fd(sqe, fd, source_fd,
+				  IORING_FILE_INDEX_ALLOC - 1,
+				  data, flags);
+}
+
 IOURINGINLINE void io_uring_prep_getxattr(struct io_uring_sqe *sqe,
 					  const char *name, char *value,
 					  const char *path, unsigned int len)
-- 
2.39.1

