Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783EB1DFA7B
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 20:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387998AbgEWS6d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 14:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729017AbgEWS6M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 14:58:12 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF350C061A0E
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:12 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id w20so1561588pga.6
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mDbeWlveWyEr17EututM6ewZlLrenoq+wrG4TB+c+O8=;
        b=SDURcEf2V5NO/4iU1aE24OeWSLHMCXpJdAgFrdnJEd7bIgxaZY8OsCWvWhzpOJOtb7
         RA+oFu3X71L4OYZdo4lWYTXGqp8MWSeWkbW1ZPXTUNI/+Qc/A6l9IJVklr6G4fHvvyM2
         eSkYQ36gSdm3LbIvrCiTfPKjmIT0uHzq657/N5EqmkFU1X3ShnSc8TgsHYOsTlmDtjbs
         fhQgttgwQveWyVOwYI4QoW4GE276osyEbPco1QcSxndNWxRvqeb591UYbiXTc10MOx29
         fpGpdY3/b413xwsNy5DGpoifG0/dhZFZd2GrucUQb1vlwz2jFn1Z/Q8UTQqIGSSktfdg
         vdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mDbeWlveWyEr17EututM6ewZlLrenoq+wrG4TB+c+O8=;
        b=JHXFDssUHwlZfQ2bfm7goYFlmmb2uuSLghNI2esTjG+93L1ass5ckw9utbp908WudT
         /0KQvPmjHAL7RkrUl38q/nr9R+ftZ+9Z94sRZEI6+mH8XtN6AyhaZSiPUO7I8FVmuIYx
         uvhjA2eN7nj3N6pV0yUdi80qD6dkU/1kk0IXnBh6eKm66N8RI+L3afgh7/G7Zw4GxpH5
         QIjiKaRfnnzbqcg+a0FyoCMswQmywiHY26K31uuSc75cgXvZ3DlgSOdnyRK758Ia0Vj4
         rW0C9TNDCrRlhyMWzqj1C95leA0Un9+x2MCUkUs2XBbkxAwrGBVtnMj627SPXpE0bjz5
         W8sQ==
X-Gm-Message-State: AOAM533rhhBaE4kAv+DPwUSQbqyihaVEcqxDJqtp6lcLtXjYlt2ISsDc
        FQi/b5iZ8BoyZk6Tk2JYUBUSO6qAZYXOpQ==
X-Google-Smtp-Source: ABdhPJyltVIJNk8C4W/9AMto9tWC1IL7mnDA5eVGXtM6JkHvLgYtWln7h/t01grs2y91cUsPUSnHHA==
X-Received: by 2002:a63:a36e:: with SMTP id v46mr19101914pgn.378.1590260292180;
        Sat, 23 May 2020 11:58:12 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c94:a67a:9209:cf5f])
        by smtp.gmail.com with ESMTPSA id 25sm9297319pjk.50.2020.05.23.11.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 11:58:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/12] btrfs: flag files as supporting buffered async reads
Date:   Sat, 23 May 2020 12:57:53 -0600
Message-Id: <20200523185755.8494-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523185755.8494-1-axboe@kernel.dk>
References: <20200523185755.8494-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

btrfs uses generic_file_read_iter(), which already supports this.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 719e68ab552c..c933b6a1b4a8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3480,7 +3480,7 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int whence)
 
 static int btrfs_file_open(struct inode *inode, struct file *filp)
 {
-	filp->f_mode |= FMODE_NOWAIT;
+	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
 	return generic_file_open(inode, filp);
 }
 
-- 
2.26.2

