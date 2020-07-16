Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B59222CD7
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgGPUab (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgGPUaa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:30:30 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62201C061755
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:30 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g75so11526379wme.5
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NDDZ2cgokdiSMdvNtdvNF1CiNluqv7xGPc88uMuNugY=;
        b=FsMN74RwInIDPgw/iSo/a+x0ZPCTVu8Fr8qmadzP2sI1X2JtgFZm235dHyeb4hv9iK
         F32B23+rtCJYbzhppHPqsIxSVVsbx+NGS36P1TwCT+RIcIomJlwJswb0M86AzqgCH4RA
         3St5SYf06FD8UNb3ngpyxOhpZDdOnn/aqMi9AWi6hWQsnrJEeHYasX5ffa+vWTzgoHHy
         T0mQbgAKt0J30yMytyd8EiTu5HKZpByUyOZKxjFws+AcY3ymby3Zvc4sCPAOGrPHG4us
         XeS0i76d9rdUBofxzDw5iBGl8NzWT/laA8I/QNtg4P/oSlfQaz6nGhXG90RYGYWs3DeN
         4c6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NDDZ2cgokdiSMdvNtdvNF1CiNluqv7xGPc88uMuNugY=;
        b=ZPp0HvQQuw18TxPwWj3dVFtTuNcYurD1ohvGj2Ni9FipFsJfIyiluXsvfmBpgBEuxj
         17F7r5zcKbZTlVHhK9R8A/HiMPPGJdW+5eus6XSA+6PCsIYSZVm/1/oSF0YRgmbYkdVt
         r611udmO2Q5/yvO1rlQTlLvRkISUfgaskZ2BN3UlPfvQ32B7oJlpPD/VHXJnNQxOWihV
         Oh0zT5oczuBC1L9aslMOA4j2Dt7difX1Yd5ZO9TYM2X+kZFZaolH48Mzg+lK1AD2Euf/
         CsUsn4crpMakm37y9oeiytDFYIMxAPwNKB3p0DK4zDlN9tTIwXmoelA0AJYMzW7sSC8R
         39+Q==
X-Gm-Message-State: AOAM533z4L3S4kVeABDZNfZbLZDEofUa+DyZu+a037pmEi5YBFt3F5Rl
        9Powieo7OvRCHOfepsP7uNk=
X-Google-Smtp-Source: ABdhPJwnBbbrro/kVWOvYmszOtMreWMzBsEA2E656J73SYcUIZF/dQ6Si09fizAlynbtjpj07MPKQw==
X-Received: by 2002:a1c:1dc7:: with SMTP id d190mr5714652wmd.36.1594931429135;
        Thu, 16 Jul 2020 13:30:29 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id g195sm10212270wme.38.2020.07.16.13.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:30:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: simplify file ref tracking in subm state
Date:   Thu, 16 Jul 2020 23:28:33 +0300
Message-Id: <8ad5d1e7c726ee96f0c55061049188fce0f1c445.1594930010.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently, file refs in struct io_submit_state are tracked with 2 vars:
@has_refs -- how many refs were initially taken
@used_refs -- number of refs used

Replace it with a single veriable counting how many refs left at the
current moment.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e4ffb9c3f04d..644e5727389c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -706,7 +706,6 @@ struct io_submit_state {
 	struct file		*file;
 	unsigned int		fd;
 	unsigned int		has_refs;
-	unsigned int		used_refs;
 	unsigned int		ios_left;
 };
 
@@ -2332,10 +2331,8 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 
 static void __io_state_file_put(struct io_submit_state *state)
 {
-	int diff = state->has_refs - state->used_refs;
-
-	if (diff)
-		fput_many(state->file, diff);
+	if (state->has_refs)
+		fput_many(state->file, state->has_refs);
 	state->file = NULL;
 }
 
@@ -2357,7 +2354,7 @@ static struct file *__io_file_get(struct io_submit_state *state, int fd)
 
 	if (state->file) {
 		if (state->fd == fd) {
-			state->used_refs++;
+			state->has_refs--;
 			state->ios_left--;
 			return state->file;
 		}
@@ -2368,9 +2365,8 @@ static struct file *__io_file_get(struct io_submit_state *state, int fd)
 		return NULL;
 
 	state->fd = fd;
-	state->has_refs = state->ios_left;
-	state->used_refs = 1;
 	state->ios_left--;
+	state->has_refs = state->ios_left;
 	return state->file;
 }
 
-- 
2.24.0

