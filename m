Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBB83BF598
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 08:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhGHGhz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 02:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbhGHGhv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 02:37:51 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDE4C061574;
        Wed,  7 Jul 2021 23:35:10 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id v20so7597690eji.10;
        Wed, 07 Jul 2021 23:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gokPHawoPLTY7lmBlEah/J0yiKgx3oWjxOPrR9t5IgU=;
        b=BoFPoTEmWa3dojswo8JWLDQ3Qut9jFAuQjLXxSuXqGEDBQQCbwqNrveaIFbcoZbgkS
         vWALlj2lFShp46X25o2hGtr4Ck5bJGQ1ujhEvVxnH9NgV6gwTPHhJRk1g2dba8g8AST+
         7mylcCOSQfHNakE1TdsJATX17N3RQ7zObD+526l9rsQA+5yDHjXTPQQsR/MNp/SrgY0x
         S8aNUyOUzQmd/EpMzRC5oWc3eWnvZYOFwVWcZyMKCQeE5UJRdHyclIZScjmrVNnp0yq8
         CXsIHxRrnil4qHLpYJVC1ZyC5fLhF/pSTwoK6XFw50pbiVUW7E01SOVPozFKQn8Z0SkV
         ujxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gokPHawoPLTY7lmBlEah/J0yiKgx3oWjxOPrR9t5IgU=;
        b=r5u2pDaRCLJHZz0ucl3Xvo05JZoUaK5Lg7ubrzsu2M8qQ/oVqokstM/ibShgV6gXVE
         aVRitvcL9h/7jJgNFbp+1JxQMQnrVoUkUovXEuk7W9NGcf25qK6EKETOgg+SBYj1q3d7
         qRYAEZZCbledPnaKg23FyMT7pmSSraord41EJuJdQQY1rnVx7BOo3hnMB4RGedEDMChH
         2QSwlbhOD63lqtpel97dg0i4FLN2NizGyEiUJHQbVBc4xxo+6hTOYPrV+YTmA/0P7JZv
         HbczEZPX6fvVaIQKc+mvQxa6UNn5gDcrBKPgbG9Wdot2gEp/gkrH1IAvMt47Ax0dZHXf
         3SvQ==
X-Gm-Message-State: AOAM530ymzTRUd6BP7RLpwMX2ZoD4WFDMzCsXR7Y/uRLcLk9qXhx1dxO
        XtRqu54wsog2OnUvGujMWVI=
X-Google-Smtp-Source: ABdhPJyq7S8kAUWPiONQiLyFdtpAWYQ3HaNDBVUZsKb85uJvOuPqgra8QoNKnzIhX17NCxo6Bft4cQ==
X-Received: by 2002:a17:906:1796:: with SMTP id t22mr28474566eje.304.1625726108972;
        Wed, 07 Jul 2021 23:35:08 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id u21sm410260eja.59.2021.07.07.23.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 23:35:08 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v9 01/11] namei: ignore ERR/NULL names in putname()
Date:   Thu,  8 Jul 2021 13:34:37 +0700
Message-Id: <20210708063447.3556403-2-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210708063447.3556403-1-dkadashev@gmail.com>
References: <20210708063447.3556403-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Supporting ERR/NULL names in putname() makes callers code cleaner, and
is what some other path walking functions already support for the same
reason.

This also removes a few existing IS_ERR checks before putname().

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wgCac9hBsYzKMpHk0EbLgQaXR=OUAjHaBtaY+G8A9KhFg@mail.gmail.com/
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 79b0ff9b151e..70caf4ef1134 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -247,6 +247,9 @@ getname_kernel(const char * filename)
 
 void putname(struct filename *name)
 {
+	if (IS_ERR_OR_NULL(name))
+		return;
+
 	BUG_ON(name->refcnt <= 0);
 
 	if (--name->refcnt > 0)
@@ -4718,11 +4721,9 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 		goto retry;
 	}
 put_both:
-	if (!IS_ERR(from))
-		putname(from);
+	putname(from);
 put_new:
-	if (!IS_ERR(to))
-		putname(to);
+	putname(to);
 	return error;
 }
 
-- 
2.30.2

