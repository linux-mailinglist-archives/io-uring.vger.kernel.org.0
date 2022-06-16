Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415AC54E0E4
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 14:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbiFPMem (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 08:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbiFPMel (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 08:34:41 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F605131D
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 05:34:39 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s135so1105985pgs.10
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 05:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=bLPa2732HLjw9iUHGa0MbrDMzyJNkR+0zL4Woz7f1ww=;
        b=ftj5TsN0Je1Jg3OSDcwq56S+Uf/j0TrVZrfiXTk4dgSXpUVqVpmd1AREMvZdYuL1nv
         0IuekswiYMOSXiShiVX25md9w9eR5XOfRy2Hdn7I+GBBweOmkWUrTmttLrBnIwMd8E5z
         h0R5tgcDEwtVEWaHT/waILoucSUTnCWmsSa+hUyQoThvq1hv/aFE4YmkQXloZKnI3xNc
         aQmci+mYpw62FTsrswNVQ0hkVChHml1SFyKDth8WWPUZW2lxGH0Jw3Tuhoc/jPhOMJOj
         SsxrOzkiyDw/wCPdYoQkeZGv874Mghvqw34ES4DrK61LDSOlLzPYa4/trOE1NELqa2e3
         VWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=bLPa2732HLjw9iUHGa0MbrDMzyJNkR+0zL4Woz7f1ww=;
        b=HTlHbTxKCRGNW5WlCLaQHbZucXfXi3lcPW/6PKaBYknSHOBVf3fvsRGSLtwuefz5uZ
         wcUJcxy6mdmeaqcFamjfzAjJLm7ninnebU7Rvrt5+Q2e1ZhYnBWMyiOBwoaiE8mYfw0s
         KBlsb4K/yUKAq/J075+uVCZLZo4SaMjYdFrHQehcJEQW9dnJAS0N+suvVQp1brVL/Hs3
         2hbUmrFWhZw/DDi3XtaHV4W77KpAmnRhI5p/xShc6IYyrpyk/ywTpjoVUBq+FzL6RK7E
         lUR2cVUKquUin07gXJyf6X4OhMW3IuvyxjXxyS+PwOQ08KLg45AhGEyxohUeh1Zxe5MW
         pUyA==
X-Gm-Message-State: AJIora/yeQuHdptGMKo4Cd2O1QJnMyfswhGs2QhgwX+HeQXnmzbNpL3V
        goPoAgqJjo4U/knaTYTb8LSkVLs6KY/87Q==
X-Google-Smtp-Source: AGRyM1txtnXB8YD4DbRaDaF5JN5n7oXT8aeB79pUAmX6ABoFzcxYgEZ7DuQleOhDzkLll3Buy3wbeQ==
X-Received: by 2002:a05:6a00:22d1:b0:51c:15ac:396e with SMTP id f17-20020a056a0022d100b0051c15ac396emr4512476pfj.58.1655382879080;
        Thu, 16 Jun 2022 05:34:39 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a24-20020aa79718000000b00519cfca8e30sm1622095pfg.209.2022.06.16.05.34.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 05:34:38 -0700 (PDT)
Message-ID: <43b88754-a171-e871-5418-1ce53055c715@kernel.dk>
Date:   Thu, 16 Jun 2022 06:34:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: commit non-pollable provided mapped buffers
 upfront
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For recv/recvmsg, IO either completes immediately or gets queued for a
retry. This isn't the case for read/readv, if eg a normal file or a block
device is used. Here, an operation can get queued with the block layer.
If this happens, ring mapped buffers must get committed immediately to
avoid that the next read can consume the same buffer.

Check if we're dealing with pollable file, when getting a new ring mapped
provided buffer. If it's not, commit it immediately rather than wait post
issue. If we don't wait, we can race with completions coming in, or just
plain buffer reuse by committing after a retry where others could have
grabbed the same buffer.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5d479428d8e5..b6e75f69c6b1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3836,7 +3836,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
 
-	if (issue_flags & IO_URING_F_UNLOCKED) {
+	if (issue_flags & IO_URING_F_UNLOCKED || !file_can_poll(req->file)) {
 		/*
 		 * If we came in unlocked, we have no choice but to consume the
 		 * buffer here. This does mean it'll be pinned until the IO

-- 
Jens Axboe

