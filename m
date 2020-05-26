Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8311E2F59
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 21:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389642AbgEZTvj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 15:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389620AbgEZTvi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 15:51:38 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9755C03E96D
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:36 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t8so261000pju.3
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7SUIxRwptQ6YWj2W/l7Dp7FzKmS+sjQ+qLVh2r/v7CQ=;
        b=V4vZlEEoKDqieT7hflzw5LCDI+LKcZUvo3Ldv1B6nIJyQFjQVObJEjYJvLZcOXvigJ
         XFaZZNKcVEjx92yoP/mrgXgpnR0CotgPlUTXVNVfzoKp9JzK30dNsQEmJb3wosGrLUxB
         U8RsYVcKqFttW2FE5KGyEAXW3lYLtI/Up6eRarLnAsqMbQv1c3x5NKGKDbBaB/ydFz6t
         7nJ6/vrORT3XMoHvYvJSZPS6MwjnIf9/choDZ58RJSYg3LkxqDzYmJhgdB5KpzqaEp1D
         jz+Rq1oQarSSrrXlfv6K57XzM5S6Jo9ouSoj57WYGLAnQKn8EBEWyWXJUyXm1pphBhbm
         UMOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7SUIxRwptQ6YWj2W/l7Dp7FzKmS+sjQ+qLVh2r/v7CQ=;
        b=TTQZpH48x4BI2bH8nCfjeWsYY4WVB1A+TQVJv2zACFOdRd6F1Ip9X7Y4Fsqp8weojm
         gNC+/RZtzLiu5kgN3svI8WMA4vF6szrh3yusyonYZ8dGpZACjRdFomrOPuBv+Ks13UxF
         ELLqYdROJNUlEccz0FDJkAoQMtfzcr1GG7C4wcIT4UFe0KxrEK5tqI1mX0WQlWaBK0zc
         G7kjMmz+C3+aIrH6eQIiyGW1rfUOdgvwWlTkDxBsRiwh6mCX2ahhExdcszzaFA4uPHaJ
         WqQUFBwDcxTN9Syu8/Q2gxsciEqwmclMv0GLm7M3TJ5uXqNTk9QyYrGiwZ8xAFg1F9hO
         RYyg==
X-Gm-Message-State: AOAM533FcLjpn4KrjPLR2mSde0xDHxK57Wlr4KUGzG+VwATWrAC7VuSF
        NXRrukJGZTSIs3HGHtrng8+1Or4MMJs01w==
X-Google-Smtp-Source: ABdhPJzyYUJtjkoA0PGX2KjnNxmXZglyIl+UX6NMsOMleygDwAvXOfiUub9ZxxKR/u6SZWeIJxQwQA==
X-Received: by 2002:a17:902:bc42:: with SMTP id t2mr2580008plz.233.1590522696165;
        Tue, 26 May 2020 12:51:36 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:94bb:59d2:caf6:70e1])
        by smtp.gmail.com with ESMTPSA id c184sm313943pfc.57.2020.05.26.12.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 12:51:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/12] ext4: flag as supporting buffered async reads
Date:   Tue, 26 May 2020 13:51:18 -0600
Message-Id: <20200526195123.29053-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526195123.29053-1-axboe@kernel.dk>
References: <20200526195123.29053-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 0d624250a62b..9f7d9bf427b4 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -826,7 +826,7 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 			return ret;
 	}
 
-	filp->f_mode |= FMODE_NOWAIT;
+	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
 	return dquot_file_open(inode, filp);
 }
 
-- 
2.26.2

