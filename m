Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADAE1DFA6C
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 20:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgEWS6L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 14:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbgEWS6J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 14:58:09 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19625C08C5C0
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:09 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ci21so6452641pjb.3
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7SUIxRwptQ6YWj2W/l7Dp7FzKmS+sjQ+qLVh2r/v7CQ=;
        b=asMd1oaZIyB4OBJhuDDS6Qm6IETRfR3fCCxP9jAEJSZo3FYau0gIpI9b/WsuE4N1KX
         RhGUBNuuUrL+ZAlmaNkDbor8+W1ob/cE5h/o3evKIKCN9RWGAgjkY9nVj4AsDXFEOxvN
         jC7XVMjV1it0HHmhL0OxZuSDp/Abrk9rCOqaJil6/D6M7OiW2AtqylxkNCV9an6DjayG
         vOHDb15eEsnEy1dDiJMsIiXcTlcRPgEl8h11Wp/ZpqB/5F1uv0rEg/I9CQ+o05PMPjC4
         Y320pJtBGjmXFef+eP+mcAHwtpvSBcWWOC2sJdIvszbOHJlfXMWF9y09acccBUgWfqzA
         3Y1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7SUIxRwptQ6YWj2W/l7Dp7FzKmS+sjQ+qLVh2r/v7CQ=;
        b=ForkNAE4jGiO3+xyQJ2c3sa0VAU7J/uJjagcFW8fsFHcHADJ7oMSIsyteWDr0r+ySi
         7hJe/Z8WsVhsn0LWOxy+61KVXf4edvNQJEdLuLqTHW6pUc5EcHUkeEDo/ZBxtnG2lfzL
         wiEiX+obRI6ZM6Mxfy0Zl1NpCnRKKlAUNVf+Mf12O5m0BRV+OPQwmVY2f8vW7m13+hd/
         Y4/V//upt67C+fyeqLDYT9zrYbwZhl0cRSw5BnISvBdR5ungFmTLwSBsv0/5bX23X5IG
         L4b/DlPLlsKt+S42AWkj5LhRI0BmsjRe7P9b4A9lKsDOwR5XQZvVtwwO4oBsgV/NG6Hz
         /ziw==
X-Gm-Message-State: AOAM532RO0vMgmBNfAp2F0md56cnzyJYIx6bmsSaoD4hqhzBUZLZIMul
        4TTGBf3P7r+FNJC8XNs1ZM1QaMcUkrt6vQ==
X-Google-Smtp-Source: ABdhPJxN9tF6/2bYMLjdUOX4WlnRkytgiqQRjaUtCQS8ug7GAw+E2pO4OMfyhBqrcqoO8mwzIxyTZw==
X-Received: by 2002:a17:902:b718:: with SMTP id d24mr6737530pls.185.1590260288366;
        Sat, 23 May 2020 11:58:08 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c94:a67a:9209:cf5f])
        by smtp.gmail.com with ESMTPSA id 25sm9297319pjk.50.2020.05.23.11.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 11:58:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/12] ext4: flag as supporting buffered async reads
Date:   Sat, 23 May 2020 12:57:50 -0600
Message-Id: <20200523185755.8494-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523185755.8494-1-axboe@kernel.dk>
References: <20200523185755.8494-1-axboe@kernel.dk>
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

