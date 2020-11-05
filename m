Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734182A804E
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 15:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbgKEODK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 09:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730501AbgKEODK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 09:03:10 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE2CC0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 06:03:10 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id u4so1483521pgr.9
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 06:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IlLitVLc0Gpfef8neL0GP8FKNziHQyytZeUORoHGQ44=;
        b=twZPPsBJd9NeaRhe0yAovLR3vXA62FUhRJFNi2QRRtFfaG+MNcBfkYe8JDFnoCORRN
         lvhbe6KS4I+LLHzHJ2EN2Mhjdzeb3ZsxFDSqv0qn+1LcLRxWaEaHN5DfI0S8E52j/Vsz
         x0I4hHN53t/QfIwCnAuFOODzy5xet83S7NYFtVpikRsYFPPg7m7gjHaawPvaofPFc47J
         tz1slXg/AAU+YI7W7F3Hl/gYHVJz5ryuha0ADYi+w30rNrUhlp6skbqNg+gwlP8mR8lt
         PB0mGswwDA6luHKeLwPT0KGPRX7vgp/xLA/7nSyUWAcmAMzXyhVuI9U6VzVxll56J006
         SWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IlLitVLc0Gpfef8neL0GP8FKNziHQyytZeUORoHGQ44=;
        b=Nlp6OYbowtIorraR7qkbfCkiUOwlF6N5LQmF7ATSXvq6fRgobPP8k0mjOUCe7mY3qO
         ODIkU0cNYe5/tgBg3RrVi+IOnfbI15RvIkeIEyaWBxFE9Lpun9FHXeeN0fAxnv6iaM+b
         daIKjewTmNv+ywEgvktTYe5+8LUwcltZI1JLDBGO5Jka9Hqqy3M8nsffRfVttLjOhoWf
         4ekC1JRLoElp68flUxZZcPC7D7kmhxyo7480jANH/vs6A6rLf3virJbBsM6iKMLcGPIA
         h4b+gBTgVyHCjOo+PE7YVvMrUqxaSbuoTqs+WtjT+GIj5vKjgk7/sfOlfW/CL0z8G68Z
         2BAA==
X-Gm-Message-State: AOAM530tgyg6StN9TpQUu67lslxonRNRj+ZRCx40p5GMTzQtuTaWXVwh
        i/RXuOpI7NKvjKhiR4+h+pph+lOKEUg=
X-Google-Smtp-Source: ABdhPJz1XYuw6U9CMBgh0ecqseeBZiZfyBJGOqte3hjrVpmWn5zxqhE94REzEwggZp3K/QondtPQnw==
X-Received: by 2002:a63:5644:: with SMTP id g4mr2651842pgm.145.1604584989385;
        Thu, 05 Nov 2020 06:03:09 -0800 (PST)
Received: from mita-MS-7A45.lan ([240f:34:212d:1:9ff6:8e52:79cf:ec2d])
        by smtp.gmail.com with ESMTPSA id d18sm2420800pgg.41.2020.11.05.06.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 06:03:07 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] remove zero-size array in io_uring.h
Date:   Thu,  5 Nov 2020 23:02:51 +0900
Message-Id: <20201105140251.8035-1-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This fixes compilation with -Werror=pedantic.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 src/include/liburing/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index e52ad2d..8555de9 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -308,7 +308,7 @@ struct io_uring_probe {
 	__u8 ops_len;	/* length of ops[] array below */
 	__u16 resv;
 	__u32 resv2[3];
-	struct io_uring_probe_op ops[0];
+	struct io_uring_probe_op ops[];
 };
 
 struct io_uring_restriction {
-- 
2.25.1

