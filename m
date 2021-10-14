Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4071B42DDBA
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 17:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbhJNPOX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 11:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbhJNPOT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 11:14:19 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBAAC06177A
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:12 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o20so20602502wro.3
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2W4OfeTResbNxJcIiDG1ib9DIzW5fyiwLpqum6mILg4=;
        b=bUToqu15Sjj5p4ZStQPzSb89Tq1UIoaVguE0TTHfDEZUW542rtaXSujbSjVdsbUnZK
         8IIdypMYa2NKi/Ezwja5/XrbzttTYRw5Wo/4FzXLbPaJmvrCbkKkCcxMkEnnx04VSi4i
         st/PzBJW6ShvWRKPnOFvwKvyV9BdfW1vokbXsDJRjscLlYaCeDnVNQE27HBmLykGl42z
         TsVjoLVU88sj/sGG6AVKfikftuM8KWN8xUCf07k6NdCExRRS1LE9oUYqieZ9S/qumQWV
         b4imNzjKdacJuApYLX0U16zsPt2eW6h83o1DCzUMz5bdQglCXOSKbqUHId0pG/PdZA1i
         auGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2W4OfeTResbNxJcIiDG1ib9DIzW5fyiwLpqum6mILg4=;
        b=HoMccN+zGZdBMELT8DtW1r1+cedYjA1tCyXIgoA38l/0FvIHdkYhvO2Uve+5mDpFZw
         D3jCIeLANUsl6PU6w6zCqbuZMP3PNB7a0CFVs6bT7Me/YaSpsx/brw830Dz0DXmuM30T
         Bh6uS7Oyl5z66sms5ySE1SbmIPCZFgskBTvgXRPwDh0w5OQcPeLmcZr0eRw6DL5g7TG5
         0kccwBLuQEI5sB0hpGUJlX5KCvzu5Ge95wLJMxwTVqi20WgIvrJVDjTJpGLc1H0L2iJc
         tc2ySne66vgop5ESjHXWQ/cQLN9gf6Dm5ezHPbQPdZZR+Ie8qv0xuqoO8fWEHHgirajX
         J2Yw==
X-Gm-Message-State: AOAM532XSS4vFirGeTFxNDJL73x+IBKrM+m53Dioz4by0lFOd/+UZMOS
        Z4F4GNt1sdoY8yV3wJvzKVrxR3y0SGk=
X-Google-Smtp-Source: ABdhPJzwv/ii3vJyh3XT0+Exd9f0ZF1LpnAxwz4IGqUJLAOH0hqpe2aMsuIVxvNsZ//63oShA5KwsQ==
X-Received: by 2002:a05:600c:358d:: with SMTP id p13mr6619994wmq.88.1634224270507;
        Thu, 14 Oct 2021 08:11:10 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.214])
        by smtp.gmail.com with ESMTPSA id c14sm2549557wrd.50.2021.10.14.08.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:11:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/8] io_uring: optimise rw comletion handlers
Date:   Thu, 14 Oct 2021 16:10:14 +0100
Message-Id: <8dfeb4f84026a20172bcf82c05010abe955874ae.1634144845.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634144845.git.asml.silence@gmail.com>
References: <cover.1634144845.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't override req->result in io_complete_rw_iopoll() when it's already
of the same value, we have an if just above it, so move the assignment
there. Also, add one simle unlikely() in __io_complete_rw_common().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6e1d70411589..2f193893cf1b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2594,7 +2594,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
 	if (req->rw.kiocb.ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
-	if (res != req->result) {
+	if (unlikely(res != req->result)) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
 			req->flags |= REQ_F_REISSUE;
@@ -2649,9 +2649,9 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 			req->flags |= REQ_F_REISSUE;
 			return;
 		}
+		req->result = res;
 	}
 
-	req->result = res;
 	/* order with io_iopoll_complete() checking ->iopoll_completed */
 	smp_store_release(&req->iopoll_completed, 1);
 }
-- 
2.33.0

