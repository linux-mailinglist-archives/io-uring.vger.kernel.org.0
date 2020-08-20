Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECE224B131
	for <lists+io-uring@lfdr.de>; Thu, 20 Aug 2020 10:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgHTIhH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Aug 2020 04:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgHTIg7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Aug 2020 04:36:59 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F52C061383
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 01:36:59 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id d6so1530494ejr.5
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 01:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wO6NnXVtyb9AZvjYFknb9/e0N0/k7bgPR+UVKM4wmco=;
        b=A+6jnRc+Si+QufZf3MgKA72idPnOPsY+fGx0HLy9UmT4BaL5fSLq/y/2h2cF4KqVW5
         5QK8uQj0EMW5ct2+cX4PV7u2PCH8luSC+2eY14B0p4q+16a1554a7QlpoMHE9J4yofme
         Esk75DiT/fjh6xIivH3JQl7wwg05iGgImgsKFMAs8yY1mBxvM57LWShptLq5N9uuhcIK
         b5+uf2H9drxKXJQQLkHA/WDaxZfjBDCX6PDgnQDouSb1eYIDCQ3MM7zwfg3rYSxDvATv
         gTXvlPN1GumHK82OeXZqt3nLZ+38TKR8V0aIcxoV6WxqsrOHBkf1tAmOUsJOo3fvtJHw
         Icyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wO6NnXVtyb9AZvjYFknb9/e0N0/k7bgPR+UVKM4wmco=;
        b=fYFqzu0flP/BKmNJAfdVa9WObN5OIbCeHi278vmFKs3niA+VW245zN0vbglz/uEQgi
         ksVfF/wvbKuP9x/IWm8oPLFc4DrWRTmR4mMK+hyXQ/bdvUT3U2AY5kV0dpxwAUkd6J9J
         mkTWrmpZdezy1MPlqwomGqln69O72QcNew9nkscJ1VgLPt0OKvdZQv8dpqEnaF+KT7uI
         +B5JtAbO5ApNF+1vyRLQg0plyk+MbJGC6RpqgvIFpGRey97Bo8VN+w2xj720klSBDKbZ
         weukq9ou/vFbUymnFQzeO/DLFpwmSoLywu5L5laofNlBtcQiqSrNyVJYlBjbBFwu6rnv
         iX2w==
X-Gm-Message-State: AOAM532FMEBRDMo6SyJsbGkvn5iLeHG218+w9Z8GAZXVJQrUciTOmr5L
        BRjzzY7MWzBOfYlLn0MQ7/A=
X-Google-Smtp-Source: ABdhPJy9wzuh2Q/DB0aJe9CDnRHRK9aYGm+OQ0c+MxfYsLvFnd0BBgmXxcy7dNhPah7mGbLKvxF+9Q==
X-Received: by 2002:a17:906:fb04:: with SMTP id lz4mr2298620ejb.394.1597912617870;
        Thu, 20 Aug 2020 01:36:57 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.225])
        by smtp.gmail.com with ESMTPSA id d23sm989879ejj.74.2020.08.20.01.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 01:36:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: kill extra iovec=NULL in import_iovec()
Date:   Thu, 20 Aug 2020 11:34:39 +0300
Message-Id: <c61315205aeac2a480ca8c49da92f7ec1dcf29db.1597912347.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If io_import_iovec() returns an error, return iovec is undefined and
must not be used, so don't set it to NULL when failing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ea2d1cb5c422..4fd3c68389cf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2833,10 +2833,8 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
 		if (req->flags & REQ_F_BUFFER_SELECT) {
 			buf = io_rw_buffer_select(req, &sqe_len, needs_lock);
-			if (IS_ERR(buf)) {
-				*iovec = NULL;
+			if (IS_ERR(buf))
 				return PTR_ERR(buf);
-			}
 			req->rw.len = sqe_len;
 		}
 
-- 
2.24.0

