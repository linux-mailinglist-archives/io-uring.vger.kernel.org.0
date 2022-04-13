Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA6F4FF9CA
	for <lists+io-uring@lfdr.de>; Wed, 13 Apr 2022 17:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbiDMPNf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Apr 2022 11:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiDMPNe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Apr 2022 11:13:34 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD6F36B55
        for <io-uring@vger.kernel.org>; Wed, 13 Apr 2022 08:11:12 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id s18so4694199ejr.0
        for <io-uring@vger.kernel.org>; Wed, 13 Apr 2022 08:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1yrtHboaewLPtT4vqN3xSo/ipf/zihGgY9G7yWBUlu0=;
        b=XuPtt4FW+pCLVhvgQ7tgFth+o/N5kxJ9PJKfyYAHM01Ea/KPqRTRj+ckwKAptu/hjY
         IL++/FpcZrRwpw6upk5WDhhQs+35ZOwQzXVAuorYWKrup+beMKKQXH6rqnXOxs5g8BPA
         rfcvE8AZxvHP/IwVl66wYLM4QJzR4ijBJ6O9HEB0xwqIj+9wAGsOk5kSFSd0dLUdqr9k
         pBRhgnokzz+MvvYvpntPhM48EpVV6QlQSJmeOCYB8/q3CaCVucVF/mOtMJsHeZ0cO+wh
         fXq9f1aF0GDRzI+zrPT+UWDgssUnhq1duUr9VlOgniT/2BiQBsX6B7mZxIW76W9VAbbw
         wkYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1yrtHboaewLPtT4vqN3xSo/ipf/zihGgY9G7yWBUlu0=;
        b=LDbnvkCU49ARXUtVs8MAILppA/uwG0FmcMNhskOgLqmEenVwInt0xF5/j0/TqwyJlq
         INUQFa7yZaBBgfoen4AAyIbxECK7QT465FhRn5K65bK8RHNTIKA/Y2MiJGa9cpzbc2xG
         YmPNaS6ygfgH0rl1EWfiCK8Pa0cCRXnrCfOPm62YFepEtiaWUmAzFBu8K18KteqN1TFM
         CB876CIEB2+leVIilyk8qwXH6Fr6uPLr9ukVKRnN8ZVP8cUc3nedinQhKqMTURqRfvv4
         PsWPxSYoOpca86Bdo48XbX/huwLN/rMzbETvjGUVF/RjNF0F+kbiUurASOWkur0IuJBn
         wivg==
X-Gm-Message-State: AOAM530gFto/wHs/JF26Bei41WqCuz0m4wrW2GMpd/cfebVFn9MkNFZW
        zSAGHZNrd0ShmFY2YL6z7DhBjEE4TsE=
X-Google-Smtp-Source: ABdhPJzwkamgiY/zdPHG5CXbZNua3P4UBSvmnr8pu+43YjjdJ/TLhYXLLflXWkFWVRqezDmUzPrW7w==
X-Received: by 2002:a17:907:6e92:b0:6e4:de0d:464 with SMTP id sh18-20020a1709076e9200b006e4de0d0464mr38556628ejc.348.1649862670372;
        Wed, 13 Apr 2022 08:11:10 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.65])
        by smtp.gmail.com with ESMTPSA id j2-20020a056402238200b0041f351a8b83sm1037152eda.43.2022.04.13.08.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 08:11:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/3] io_uring: use right issue_flags for splice/tee
Date:   Wed, 13 Apr 2022 16:10:33 +0100
Message-Id: <7d242daa9df5d776907686977cd29fbceb4a2d8d.1649862516.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649862516.git.asml.silence@gmail.com>
References: <cover.1649862516.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass right issue_flags into into io_file_get_fixed() instead of
IO_URING_F_UNLOCKED. It's probably not a problem at the moment but let's
do it safer.

Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6b1a98697dcf..3d6cbf77c89d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4358,7 +4358,7 @@ static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
 
 	if (sp->flags & SPLICE_F_FD_IN_FIXED)
-		in = io_file_get_fixed(req, sp->splice_fd_in, IO_URING_F_UNLOCKED);
+		in = io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
 	else
 		in = io_file_get_normal(req, sp->splice_fd_in);
 	if (!in) {
@@ -4400,7 +4400,7 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
 
 	if (sp->flags & SPLICE_F_FD_IN_FIXED)
-		in = io_file_get_fixed(req, sp->splice_fd_in, IO_URING_F_UNLOCKED);
+		in = io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
 	else
 		in = io_file_get_normal(req, sp->splice_fd_in);
 	if (!in) {
-- 
2.35.1

