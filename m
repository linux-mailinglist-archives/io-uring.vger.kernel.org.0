Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB7B3E4542
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbhHIMFm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbhHIMFl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:41 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A17C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:21 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id x17so10411145wmc.5
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0g7nFnjjoKt55gZbR1f4r7yqPrapJiSdZXuJWLWJq8E=;
        b=Nfj2nSxxU26kr5vEuEFiVDJ6qR23YdnwtMXYnPkyF/oqrFMOKdg2hSEYB1/xf5Tg/S
         G3CXU57EFIQ/x64yBdkPqsrMTca8b+gilKrEldoff+8fRE4eqJHcVhbwz3Roi78tdcFS
         IBaE6EE0FcbHjwScA0pUIoxUPfMmGlK84pC5tS8ADYe8Zq1waniIcxGmdwEh03u7CL+H
         h+9Gnk+5IUMPIbB3eSc0WbwUz4scfiZiLuZrVOACqS9ooMs44L78lMXfE01TizXKFFWh
         BOixhSAZJR9DE5C2I/kwtMW5rrmkyHn82Bz3+3zCS6Ptlvq/jLDsCdXjf40GVY3Ok9Vw
         FORw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0g7nFnjjoKt55gZbR1f4r7yqPrapJiSdZXuJWLWJq8E=;
        b=V0zuqVrsmfG37nTyR+hgjG3FWcJqvWFEkM+xomlXFBKn/CbMIdlrj+b+3CcIq9oUqA
         7uy35UmNL+AtIj2HIptiQY66bQ8e916KRPXsFU+WqukiHCUHsg82QPU7a4r2FkwcSQY9
         MsmuSqc6h1osFKbqb9DxVnEbjaCvzPxNY6Fr/FDL23vnDK0feFIUvt2NWSv22mOHwNE5
         Q7m56/R9L9LdhxwmQoFpMdzMumWdMMSZC+E6Ts/oHl8b8nNDTcHSIYy+ysmw/DOr1rtA
         Ii3e0i/KfwroMPtC7ZHZECmBKrBYrrCRYWZTzZ/ot+sz2PVO1zxUTjva/wpOW7jz/Rsx
         Lvrg==
X-Gm-Message-State: AOAM532+qil7XJ75LslXSwgIyDY4/WJY245mZV4ZFGv5nC+NK2v3QVOF
        xKneUjp1y2aBpWG6PO4KZCw=
X-Google-Smtp-Source: ABdhPJzNW4q5JlNKa46fp2Uzp9jn7sFSGejTMVF2vThwAgd4m4/1JrnO8VwxC3Ea6g/V1sUtSMLTgQ==
X-Received: by 2002:a7b:c353:: with SMTP id l19mr32634635wmj.127.1628510719945;
        Mon, 09 Aug 2021 05:05:19 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 18/28] io_uring: kill unused IO_IOPOLL_BATCH
Date:   Mon,  9 Aug 2021 13:04:18 +0100
Message-Id: <b2bdf19dbee2c9fc8865bbab9412135a14e24a64.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IO_IOPOLL_BATCH is not used, delete it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a6fe8332d3fb..ba0c61d42802 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -294,7 +294,6 @@ struct io_sq_data {
 	struct completion	exited;
 };
 
-#define IO_IOPOLL_BATCH			8
 #define IO_COMPL_BATCH			32
 #define IO_REQ_CACHE_SIZE		32
 #define IO_REQ_ALLOC_BATCH		8
-- 
2.32.0

