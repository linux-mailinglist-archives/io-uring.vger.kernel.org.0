Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C3E3E4514
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 13:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhHILxh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 07:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbhHILxg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 07:53:36 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A43C0613D3;
        Mon,  9 Aug 2021 04:53:15 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id z4so21044230wrv.11;
        Mon, 09 Aug 2021 04:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x+4wra4HxuvSp6gGCVI1S4IbawlslKqdZS2ju2uJ+hk=;
        b=snnjXX5akYWUzTGTzXa+4a2AcV8LH8jltO2Dpxm9qFVN4CcuOUIvuVEtD3X+pG+TPQ
         EGnQgd/HNYmsJtLx3OiYimKEV251HnG4q0nxwPOMIY10+QvCKKBQ4nP+aS6pbjjIDHrr
         LLLwtISx+7vaPB9XFrEtv53jU8Uq0MwvOa1u55BRvzT02fKl+YE38jpUgOWOyXXdiaeY
         T68ziDEqnWhvuGqbdevJm1SLm8d9WfUNff3pkzmFeq8dfiNyN+GlYbDg7mZpXGKoWtSr
         EGoG2eh/Q7kiJ/qTTw35yRRuiHK00nNM1y2IZThvyeTkacpgVhp9s+7EHy6ATqDtJdjM
         4JLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x+4wra4HxuvSp6gGCVI1S4IbawlslKqdZS2ju2uJ+hk=;
        b=P9PpsWlbNKQLyoTv15vyaDqxKZPVkIRwgqHL8/c2yzjvrgRz+aTFdutyNNM3I2soSC
         IP0mjcfi1U6iR1tyBYkdSLTMrwPWdX0O/O45LigtWKoWNd9YPOq+6KhddfnR3Gm46Igp
         kiJZ2S/JUDDftmDfjC8ClXC8O9w4K19LC7k+YvZXoA7iTXPY7jybkhtFhcOS6bFPPHiD
         8uos1aY3QS6ABqBqb0xwkFniWjG2fhMtohjwEE9Rpk0UDMsLP/i+1dZghfVc25FOzdPi
         UMK0F7ElBpdkhVKmjZUCHzLo740RviT5YPk9VKOIteLJscQj2ADDhrcz04ILp6wtC+Aq
         iqtw==
X-Gm-Message-State: AOAM530veKdy9CpUQ9oPqEOyNLOsZX/hQ+X3ZOuMsRUTuzPaTxb9ZVzP
        e/dPdYzvKwWJTsKbjDzrf3M=
X-Google-Smtp-Source: ABdhPJxO4t8RPG/eLJHtqvniU7f3oK63kE6lt362rmPXQ/IiIvUL6ZbE1bZQlOK4UEASK2bXGnCWiA==
X-Received: by 2002:a05:6000:10c6:: with SMTP id b6mr25015640wrx.110.1628509994318;
        Mon, 09 Aug 2021 04:53:14 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id f17sm22876828wrt.18.2021.08.09.04.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 04:53:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, asml.silence@gmail.com
Subject: [PATCH 1/2] iov_iter: mark truncated iters
Date:   Mon,  9 Aug 2021 12:52:36 +0100
Message-Id: <a2c762e46ede42470f4dd9aafb927466bd363943.1628509745.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628509745.git.asml.silence@gmail.com>
References: <cover.1628509745.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Track if an iterator has ever been truncated. This will be used to
mitigate revert-truncate problems.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/uio.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 82c3c3e819e0..61b8d312d13a 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -30,6 +30,7 @@ enum iter_type {
 struct iov_iter {
 	u8 iter_type;
 	bool data_source;
+	bool truncated;
 	size_t iov_offset;
 	size_t count;
 	union {
@@ -254,8 +255,10 @@ static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
 	 * conversion in assignement is by definition greater than all
 	 * values of size_t, including old i->count.
 	 */
-	if (i->count > count)
+	if (i->count > count) {
 		i->count = count;
+		i->truncated = true;
+	}
 }
 
 /*
-- 
2.32.0

