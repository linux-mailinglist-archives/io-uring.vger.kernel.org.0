Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C93391D07
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 18:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbhEZQb3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 12:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbhEZQb1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 12:31:27 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664E1C061574;
        Wed, 26 May 2021 09:29:55 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id g17so1555870wrs.13;
        Wed, 26 May 2021 09:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2BR2CpRv5HUtxyF1HEzJXZYtJUUJGLsBTSqdUuHN7zA=;
        b=gf/XOSZVYbCOim1OET+mYLpTrqZ76gUyQqjCbZN/qlFwFtlzvuaZl61FdQEADmWaA0
         TSAOGHv7/1Xy3c0e5CbBfqlJN9/x3VxAx7wm+5ER5sA9MBkANhIkiAJJfeRuzE5TIIxD
         8SQtf6CPnIHV96nehAE01lGzq67TQ4ZHvEpdWPsht4syTldGlKewWOUHbbVtK4Ej/VOp
         0nUKLj4HlVx7X38Uo0vT9bO/PnEIMm77uxE8Xq16aD/RMpVtokWc1rYITI8lKKBotfPd
         LHWf+dga3w54rU3XXlDl6mKTSrfdxF/KB0vseClIjXnliKr97U7zCSUjSY/1Y9NsqPaZ
         lEBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2BR2CpRv5HUtxyF1HEzJXZYtJUUJGLsBTSqdUuHN7zA=;
        b=QZjyhu4VU1l6WAiBJvmj/KisCjrPV/KCzaZmEKegKbjp2xOwPkVpq/fVHcmdacgkC9
         oS1AXZv+n3h3HQVgOUfBG2ShC1eEBrkUQjQlZD8XlzJIh1vMVHzaPSEW/3ZAZ+ViCVSK
         zCdmcy4CgU2uIq/KEquYolW/WmAm1ThLcHckpmpbW5dHaYg9qhF5bJ3s9ivycikXj7n6
         Rhf9P2OoFuCk8vy8jMiQV9+qgHPRYBYVjQzyh2H5SnYYSnjxzR7JU1TaoNEWbqb6iklP
         kuf7gwtwDxRs4qxvaBHcO0mPzKCRqLEKpep/wMwQqhd8miMDEY3dxJQnVjXcTXqaTZJg
         2PMQ==
X-Gm-Message-State: AOAM533kdSRgoUzHxxY1UJFsgZT9J24Jzp+j8EJlxTHTsBr/ch7f1QZU
        +2ksSAY/y9EKBaEKsEloNQk=
X-Google-Smtp-Source: ABdhPJyOSJ3dplHGyVVRAngVGaxH8j406gBMGci9x8u/90yiXrPEDkoJqHB+H0PMlJGwXCnQkSXF9Q==
X-Received: by 2002:a5d:4a4f:: with SMTP id v15mr34464625wrs.154.1622046594006;
        Wed, 26 May 2021 09:29:54 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.10])
        by smtp.gmail.com with ESMTPSA id z203sm3561450wmg.9.2021.05.26.09.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 09:29:53 -0700 (PDT)
To:     Marco Elver <elver@google.com>, axboe@kernel.dk
Cc:     syzbot <syzbot+73554e2258b7b8bf0bbf@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, dvyukov@google.com
References: <000000000000fa9f7005c33d83b9@google.com>
 <YK5tyZNAFc8dh6ke@elver.google.com> <YK5uygiCGlmgQLKE@elver.google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [syzbot] KCSAN: data-race in __io_uring_cancel /
 io_uring_try_cancel_requests
Message-ID: <b5cff8b6-bd9c-9cbe-4f5f-52552d19ca48@gmail.com>
Date:   Wed, 26 May 2021 17:29:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YK5uygiCGlmgQLKE@elver.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/21 4:52 PM, Marco Elver wrote:
> Due to some moving around of code, the patch lost the actual fix (using
> atomically read io_wq) -- so here it is again ... hopefully as intended.
> :-)

"fortify" damn it... It was synchronised with &ctx->uring_lock
before, see io_uring_try_cancel_iowq() and io_uring_del_tctx_node(),
so should not clear before *del_tctx_node()

The fix should just move it after this sync point. Will you send
it out as a patch?

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7db6aaf31080..b76ba26b4c6c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9075,11 +9075,12 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	struct io_tctx_node *node;
 	unsigned long index;
 
-	tctx->io_wq = NULL;
 	xa_for_each(&tctx->xa, index, node)
 		io_uring_del_tctx_node(index);
-	if (wq)
+	if (wq) {
+		tctx->io_wq = NULL;
 		io_wq_put_and_exit(wq);
+	}
 }
 
 static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)

 
-- 
Pavel Begunkov
