Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35B842DDB8
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 17:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbhJNPOX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 11:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbhJNPOQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 11:14:16 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06C3C061778
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:09 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o20so20602213wro.3
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aPBN9LFikXQ+a5sIJMa/ol5NAckTDWo4apkVH8XPszY=;
        b=l1YG5i8WIacG/zRFPbjJAk2VyLofu+KxmEyAH8GROMdUxjB3ThmCfUFI+RJ/DflsjB
         YbBlTmNWRMvbZWYoui+9L5Gud4ptuOMHCt/pJbgMMkZYLvU8e9d9gMu3mqFZglkkm+wj
         pH9AnUWFgSmudG79V00x5xI7uc074tmy6lawohqauF1jnMqjM32BJ0LL4+JLSAbplYoH
         naUSwUeTwK5WgiuhOckaPLF9oeTog2pKn2a1OazHs/abLDY1bC1oDORrroYNmdWIqUE9
         MgoivoAD5lZnpcxNXa2ptqaHxiwsPt1CVOzLrhVFEP1XOessaUo0mauKzfZFklTsyXxb
         M3Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aPBN9LFikXQ+a5sIJMa/ol5NAckTDWo4apkVH8XPszY=;
        b=HRjaWOpKg5uSt3c3/FWG0x4SrAdn+Z4xuG9lJjgr145zYvKhHrzPdJDua2hZnoJiCP
         6iaAOHDYuB9a3Z51cZHfzGN5maCPcWHpRxGWCo2Y7JTsvb/1GWknb09+n0b4a01ggJqO
         rlpjDLka15fmiDQNuRPIkNt/tw45TMbNMDZ8yLfrc525kXGrh4L8PPgGbmsSJh8G11Nc
         q+hPmaeJifM3wDpzKFN6IIPGwntq42e1ZxQLaDC+/AqTAPtHTj4gWXSwcGzkqGavhIC3
         yoT6epNWO641Z6WhcNGXbJtdB+NtwuJiD3raR60i3b+J4PbA59mBV8biQ2ay3EdEaPqf
         bwKQ==
X-Gm-Message-State: AOAM532Pr8IwYV+mpBZnMrAgUREkS+jc8xh5yRgTIidfmJkyKrxFBZq2
        g62+AZ4dNik9UWETBuPBG2IbG7bAQOQ=
X-Google-Smtp-Source: ABdhPJwCQp+ETAdrJXwJB7bxmwlkH3GWavUwooIAopH1Iep4jG4XXtkaaq/Nzoc5uQoEE7IpgTEvpQ==
X-Received: by 2002:a5d:6484:: with SMTP id o4mr7648360wri.337.1634224268223;
        Thu, 14 Oct 2021 08:11:08 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.214])
        by smtp.gmail.com with ESMTPSA id c14sm2549557wrd.50.2021.10.14.08.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:11:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/8] io_uring: consistent typing for issue_flags
Date:   Thu, 14 Oct 2021 16:10:12 +0100
Message-Id: <04ad43797783bc9cc7567f287ab545518f8e8cf2.1634144845.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634144845.git.asml.silence@gmail.com>
References: <cover.1634144845.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some of the functions keep issue_flags as int, change those to unsigned.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 55435464cee0..561610e30085 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3748,7 +3748,7 @@ static int io_mkdirat_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_mkdirat(struct io_kiocb *req, int issue_flags)
+static int io_mkdirat(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_mkdir *mkd = &req->mkdir;
 	int ret;
@@ -3797,7 +3797,7 @@ static int io_symlinkat_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_symlinkat(struct io_kiocb *req, int issue_flags)
+static int io_symlinkat(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_symlink *sl = &req->symlink;
 	int ret;
@@ -3847,7 +3847,7 @@ static int io_linkat_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_linkat(struct io_kiocb *req, int issue_flags)
+static int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_hardlink *lnk = &req->hardlink;
 	int ret;
-- 
2.33.0

