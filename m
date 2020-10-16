Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E973329091A
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410537AbgJPQCl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410466AbgJPQCl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:41 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD22C0613D3
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:41 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gm14so1623957pjb.2
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HnBBpHKvH3/m3xwsHtacJdx7wvrbbDfL8X+8y9KtF0U=;
        b=D5JCnFS1sVnVSuUu5EOXh3k9RoNi+PmcUHo+8F9w7aXHPvGx6syohQMq3pPfjptk3L
         iDXDQ9w0WZ82FrJ79/wp1VeQ5Y8l+nmpAx7o4myQlvsMUvu1pFBBoA8WLQYnZlBBcyoM
         73xP2DMYgO9bS062PizKRPP9w635aOA4uDZTxNz64CUZOr105HAcrTJS7jKIaa6N982S
         lCP5/rdq4zCVfB1pNo8DLjINuh65/Q95vUxKRHcMYmlLsxUiboFdGRVFGXLM9OXjEduo
         QCl857t/jU5muL0ttrAfeZ43LJSluDRAqZaRpyUKuSj7AxBxna2Pz/CapaipV7MX0rrB
         i7tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HnBBpHKvH3/m3xwsHtacJdx7wvrbbDfL8X+8y9KtF0U=;
        b=lvEc8WSbiK64IbWroGphYCS9AVxUNcUtm59QKUDQjiDPs8Ax9EBI50EXiWcWpNAUWV
         C24aph9WBe9I9azN3jPwbeYcJXdbc5tUDwT+qETCFH4n1f6X57eJNANrGelKGugV89dZ
         zHPPUuYGOIS3C0+ur5Y68/1j0bI72nnldt3C2y27q7MgVZbII8hCv5YwReBTzmxip0U3
         KkOE4qj4Ui2Y7bzt58N4WefGUbCtUDQdFBOAYTrbxsR21TMef1zA8bPZpZI3B8iR30mI
         HAgzQq/YPMa5yvWSg6Xa3I7jo4JHXU7ulVt7qwTQpu9BAeVnytKERpRhHpxA0Fwft/Iu
         uBdg==
X-Gm-Message-State: AOAM533H8SPno6czMDiTHxePEvoxlEoRfqXGugFk0QtQs7SUFJyiM1Li
        /6EDHbm4kSLYTUJpKBsUUEhJQQpIKG2vS3wb
X-Google-Smtp-Source: ABdhPJxXClaliTiCviPpu49fqd6ACnK4v1nb0O9YUe5mjj2IFIiLYJM06braFeHjwhb3+okdJoC1LQ==
X-Received: by 2002:a17:902:868d:b029:d3:9c6b:9e05 with SMTP id g13-20020a170902868db02900d39c6b9e05mr4694978plo.51.1602864159941;
        Fri, 16 Oct 2020 09:02:39 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 09/18] Revert "io_uring: mark io_uring_fops/io_op_defs as __read_mostly"
Date:   Fri, 16 Oct 2020 10:02:15 -0600
Message-Id: <20201016160224.1575329-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit 738277adc81929b3e7c9b63fec6693868cc5f931.

This change didn't make a lot of sense, and as Linus reports, it actually
fails on clang:

   /tmp/io_uring-dd40c4.s:26476: Warning: ignoring changed section
   attributes for .data..read_mostly

The arrays are already marked const so, by definition, they are not
just read-mostly, they are read-only.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 19deb768ad07..632f4e21569c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -760,7 +760,7 @@ struct io_op_def {
 	unsigned short		async_size;
 };
 
-static const struct io_op_def io_op_defs[] __read_mostly = {
+static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_NOP] = {},
 	[IORING_OP_READV] = {
 		.needs_mm		= 1,
@@ -983,7 +983,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 
 static struct kmem_cache *req_cachep;
 
-static const struct file_operations io_uring_fops __read_mostly;
+static const struct file_operations io_uring_fops;
 
 struct sock *io_uring_get_socket(struct file *file)
 {
-- 
2.28.0

