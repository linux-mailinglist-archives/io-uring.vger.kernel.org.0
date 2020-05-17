Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663081D67A7
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgEQLTb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgEQLTa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:19:30 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED8FC061A0C;
        Sun, 17 May 2020 04:19:29 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id u15so6795272ljd.3;
        Sun, 17 May 2020 04:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BzKYPa9+f5wYR8KrZHY02kZ40xqz/9Ak0HhKazIkRLw=;
        b=HTzur2/5etckN1rwvGa4A2cZufatRwpbkFZg+HDMRsA0QHduEvTr1xiWWPJPwP+bED
         uugnTe+8fRlmabR2TBvDT8oFV8wvFaijdiC87/WrPNJ6HGubFGzCHQ49IsCZkAH+71kT
         9uzM/6EGn5F3OHiqjyBnfikar38WDMqJ/RVY5m0yqWTLt48s0vQkadSbbaW5uLSi/CJe
         mgvXuclvOmiM8QQ3GbMQRL4KU5WUYn7JNyDICFPikw2mkSQJ9SOKqBskTCXlcAjfaOpX
         g+Cpg4MVa0g/t47MqW7X8IxWngFfjAyjUrE4JeFA/KTO6jTjBWlYlKPAURY8F0qVzEj6
         NKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BzKYPa9+f5wYR8KrZHY02kZ40xqz/9Ak0HhKazIkRLw=;
        b=I2kXm4Jbxe0mxVNIFDte8Hessf8xeLixDjPAYm3yA04oiQ40MfW/kdZSvlGVIF0sJ6
         m3j3vpj48FC+xdGs0Rdv+H/rmgWc1ZpoAGbAKp5OKK7EBISpvLzFRwTUh7Rc5G2VOD2q
         hYHqvllMuQ9Ye01se8W8wbETJIvw/5n8UpNSFU/WE4nO96CiEg6PpOoEM95LJsux/wG6
         mek8ps8zYl56g3lWVWIC7R0mtfXPBt32d1GF+yaIESSKeaEEfYcX8bG30oaYD7sL57PG
         jio2L8rp+dQevmHJXRXYvgSgjvhbO7wXDg5cgJa5jG+BiEic1KnBBELNeJJX5uuLllzX
         cbHQ==
X-Gm-Message-State: AOAM531kfqYhyTIRSFhiho3HBjZCl4U/21VyR0YA2UdTTOOisuaXB+tz
        +LcpwME1qKhMQ0iKr1eYBcE=
X-Google-Smtp-Source: ABdhPJwSewqASQZGINstIal+z4RzYCtzJgc1zCslCG8T4PYxY2tANObwoi6D6esymSL3koD9DuxXNg==
X-Received: by 2002:a05:651c:48a:: with SMTP id s10mr7281978ljc.7.1589714367530;
        Sun, 17 May 2020 04:19:27 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id f24sm5534246lfk.36.2020.05.17.04.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:19:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] splice: export do_tee()
Date:   Sun, 17 May 2020 14:18:05 +0300
Message-Id: <250f722c275e2251b06f8cb8a049fa1cd3bd0921.1589714180.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1589714180.git.asml.silence@gmail.com>
References: <cover.1589714180.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

export do_tee() for use in io_uring

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/splice.c            | 3 +--
 include/linux/splice.h | 3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index fd0a1e7e5959..a1dd54de24d8 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1754,8 +1754,7 @@ static int link_pipe(struct pipe_inode_info *ipipe,
  * The 'flags' used are the SPLICE_F_* variants, currently the only
  * applicable one is SPLICE_F_NONBLOCK.
  */
-static long do_tee(struct file *in, struct file *out, size_t len,
-		   unsigned int flags)
+long do_tee(struct file *in, struct file *out, size_t len, unsigned int flags)
 {
 	struct pipe_inode_info *ipipe = get_pipe_info(in);
 	struct pipe_inode_info *opipe = get_pipe_info(out);
diff --git a/include/linux/splice.h b/include/linux/splice.h
index ebbbfea48aa0..5c47013f708e 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -82,6 +82,9 @@ extern long do_splice(struct file *in, loff_t __user *off_in,
 		      struct file *out, loff_t __user *off_out,
 		      size_t len, unsigned int flags);
 
+extern long do_tee(struct file *in, struct file *out, size_t len,
+		   unsigned int flags);
+
 /*
  * for dynamic pipe sizing
  */
-- 
2.24.0

