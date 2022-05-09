Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026B8520196
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 17:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238638AbiEIPy5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 11:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238658AbiEIPy4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 11:54:56 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2B84348C
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 08:51:02 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id o5so9559904ils.11
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 08:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2vheLx++WCg20E0ZwSLvxlkhx/H+2/Uv2hjKZUPkNf0=;
        b=FO11NQTfGvGRMNDjKzTHV0DZZlwQIDp/h4LXVTgTmFeWqrG53PvhOa0wSrEYAheJHH
         TcNKAFTm6LXerVE2+QvRF+n1T40No7LsSxvkJX6TWu/oVOd8NZ/YK3VV+2DIvEPJyx52
         O3Mnamiz+B7u3YqgSfPXvKPopMUsGrU8I7KAh1EroGMB8ePUo3SG9KUEVoxV/sJYYVoZ
         y9PgGxKgl3AZJ2bu/N46NzzkZv7W9cx9hfS2hGaGTVpb2llAUXSXgV59G7jPYsNzfJEJ
         lvzZmm3kHz0cOraTpGG1uY+N89jGeCvlJoL6GFeQT8IVIZUPXC34o6g62KiROtABQpbz
         XH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2vheLx++WCg20E0ZwSLvxlkhx/H+2/Uv2hjKZUPkNf0=;
        b=vXjj5Z+c8xX8rGvKLiZ9BN3ivrM71hoM7g8xApcfsoFHyZPcT8TvASHbINZ9rUcqTW
         57pxwNyF1cbnEzwx7kIBrjhBBtovi7CJBTjql6g9zlIinL7PvnN9Ug8gDuF/sm/SCdsr
         OAMlmTYCsTJ5hUOgbKMfhRehAqEYjHMmOJqiZ5Ejqi/svLjvXpG2o2BiaOXArPbVT4n3
         hBCtK+FlO/yBO03lJF694FfA1jpoWM0bEeeB+KnmbbTqQNRLBeqrYpwAFgKe/Mewhjv8
         qZe66N8RsH4I6vjzDMxZyQtVYortdYSlKXPIqvt5JOx520CC8G9Mv/7UT6VmRlkJO23P
         UvfQ==
X-Gm-Message-State: AOAM532TPWl0znnWPy0HURbEMxXvusWDjbDkOoeTisM5CHElfYCwIZK/
        SVmReh2bwZO+J5zBuZ0QlJtts7JDGoOOow==
X-Google-Smtp-Source: ABdhPJy1QmLl/ahc21qUohtPsmTx9JecLGiLamO9W6XWRb4r+8dK3haSVypF/QBn+TC1x8NqMVN7UQ==
X-Received: by 2002:a05:6e02:20ca:b0:2cf:8c46:3365 with SMTP id 10-20020a056e0220ca00b002cf8c463365mr5075560ilq.73.1652111461514;
        Mon, 09 May 2022 08:51:01 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a1-20020a056638004100b0032b3a78177esm3696499jap.66.2022.05.09.08.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 08:51:01 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring: allow allocated fixed files for accept
Date:   Mon,  9 May 2022 09:50:53 -0600
Message-Id: <20220509155055.72735-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509155055.72735-1-axboe@kernel.dk>
References: <20220509155055.72735-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the application passes in IORING_FILE_INDEX_ALLOC as the file_slot,
then that's a hint to allocate a fixed file descriptor rather than have
one be passed in directly.

This can be useful for having io_uring manage the direct descriptor space,
and also allows multi-shot support to work with fixed files.

Normal accept direct requests will complete with 0 for success, and < 0
in case of error. If io_uring is asked to allocated the direct descriptor,
then the direct descriptor is returned in case of success.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ef999d0e09de..7356e80ffdbb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5801,8 +5801,8 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		fd_install(fd, file);
 		ret = fd;
 	} else {
-		ret = io_install_fixed_file(req, file, issue_flags,
-					    accept->file_slot - 1);
+		ret = io_fixed_fd_install(req, issue_flags, file,
+						accept->file_slot);
 	}
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
-- 
2.35.1

