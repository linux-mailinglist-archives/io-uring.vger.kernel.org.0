Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130C92029FE
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 12:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbgFUKLh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 06:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729792AbgFUKLe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 06:11:34 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AD6C061796;
        Sun, 21 Jun 2020 03:11:31 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w16so14914794ejj.5;
        Sun, 21 Jun 2020 03:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gh2f1Rx0We31z5hG4/15/ZU1RW/fb1QxIKH7czgCtno=;
        b=J2pwUtQStXgIXHdX7n5BVbUYsCp9oSejBAWXUDE5xptrjcntjWEep+F3iWbOUiuDgF
         tPE8kI7RC6JcJVhR7iS7rdIah6fOkQ1kLYribi59Bof45xLUIi6k96v4uRbj/6XWxIOn
         ue4g0j/w6Lpk7E4Bk9IMH+dqnqLwYE3NN5NGfVxI+IbQOUmeWH/nTwmc7XcsPOcjX3nl
         s9AGqKc1TAabSFwHXuwuz2Pr+ojPNk1NPmiF6vbaQgtUIL64CA7n7uMk45Sl4IqGBSdM
         6gNn/UdbYqKTPvuEeiBEMbCWGzagt5Y4tu6BWnNLUZsV+EUuI/m/KU5iE9t9zVg7p6yG
         PgcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gh2f1Rx0We31z5hG4/15/ZU1RW/fb1QxIKH7czgCtno=;
        b=RqVxe27vbUhfkRlEb5zc5MhGKY+0B6qM+Ua7hH4XBfiXOgStsJbnCXdd6SwZ/h2SxJ
         /MiKZB7PZT5vhS9aoYU4rSr3iirUKgwOT01juy1LPKVmtLH3FEfMi9+ybiwayV/JJxWZ
         kyJw+ufb9RcaPYs2O9TUoqH9Dwti+cLC+hQaSMzSFeO+7qqj9RVrR4U7Mu1RD0L2GJ7D
         b1HAnYL9geE/6ER1dL3WBBT18Yomf9tKUhG4fY7WwZFZWF304twEmPDSH+a7VK5xuL6w
         0uOzt4bh5Y7u60j4Zv82H8/eXwFFUkR0k0wJUk+4xVSDMZTFXgZTAWQ1qA2xuMPJ8XfJ
         ARGg==
X-Gm-Message-State: AOAM531MJ04IzcB8FgKPBbuUyQXkYF6RANExEfvR/HFK/NZMULXbpTeO
        tNESX5WuN/wZROtOHqlY0gA=
X-Google-Smtp-Source: ABdhPJzaimlw2CUHRUNwFGXQxyy4ChwjkI7yamHKgKrmZyj3yFVb4amiHOYPh0XNHjB21fgmjP0rQw==
X-Received: by 2002:a17:906:1d56:: with SMTP id o22mr11123737ejh.406.1592734290363;
        Sun, 21 Jun 2020 03:11:30 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id y26sm9717201edv.91.2020.06.21.03.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 03:11:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] io_uring: remove REQ_F_MUST_PUNT
Date:   Sun, 21 Jun 2020 13:09:51 +0300
Message-Id: <7450caafc8c0121254f950d3415046a3b8dba2cf.1592733956.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592733956.git.asml.silence@gmail.com>
References: <cover.1592733956.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

REQ_F_MUST_PUNT may seem looking good and clear, but it's the same
as not having REQ_F_NOWAIT set. That rather creates more confusion.
Moreover, it doesn't even affect any behaviour (e.g. see the patch
removing it from io_{read,write}).

Kill theg flag and update already outdated comments.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e7ce1608087f..84b39109bc30 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -534,7 +534,6 @@ enum {
 	REQ_F_LINK_TIMEOUT_BIT,
 	REQ_F_TIMEOUT_BIT,
 	REQ_F_ISREG_BIT,
-	REQ_F_MUST_PUNT_BIT,
 	REQ_F_TIMEOUT_NOSEQ_BIT,
 	REQ_F_COMP_LOCKED_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
@@ -582,8 +581,6 @@ enum {
 	REQ_F_TIMEOUT		= BIT(REQ_F_TIMEOUT_BIT),
 	/* regular file */
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
-	/* must be punted even for NONBLOCK */
-	REQ_F_MUST_PUNT		= BIT(REQ_F_MUST_PUNT_BIT),
 	/* no timeout sequence */
 	REQ_F_TIMEOUT_NOSEQ	= BIT(REQ_F_TIMEOUT_NOSEQ_BIT),
 	/* completion under lock */
@@ -2889,10 +2886,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 	if (req->flags & REQ_F_LINK_HEAD)
 		req->result = io_size;
 
-	/*
-	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
-	 * we know to async punt it even if it was opened O_NONBLOCK
-	 */
+	/* If the file doesn't support async, just async punt */
 	if (force_nonblock && !io_file_supports_async(req->file, READ))
 		goto copy_iov;
 
@@ -2986,10 +2980,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 	if (req->flags & REQ_F_LINK_HEAD)
 		req->result = io_size;
 
-	/*
-	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
-	 * we know to async punt it even if it was opened O_NONBLOCK
-	 */
+	/* If the file doesn't support async, just async punt */
 	if (force_nonblock && !io_file_supports_async(req->file, WRITE))
 		goto copy_iov;
 
@@ -3710,8 +3701,10 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 
 	/* if the file has a flush method, be safe and punt to async */
 	if (close->put_file->f_op->flush && force_nonblock) {
+		/* was never set, but play safe */
+		req->flags &= ~REQ_F_NOWAIT;
 		/* avoid grabbing files - we don't need the files */
-		req->flags |= REQ_F_NO_FILE_TABLE | REQ_F_MUST_PUNT;
+		req->flags |= REQ_F_NO_FILE_TABLE;
 		return -EAGAIN;
 	}
 
@@ -4634,7 +4627,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 
 	if (!req->file || !file_can_poll(req->file))
 		return false;
-	if (req->flags & (REQ_F_MUST_PUNT | REQ_F_POLLED))
+	if (req->flags & REQ_F_POLLED)
 		return false;
 	if (!def->pollin && !def->pollout)
 		return false;
@@ -5837,8 +5830,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
 	 */
-	if (ret == -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
-	    (req->flags & REQ_F_MUST_PUNT))) {
+	if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
 		if (io_arm_poll_handler(req)) {
 			if (linked_timeout)
 				io_queue_linked_timeout(linked_timeout);
-- 
2.24.0

