Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F044820C0EF
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 13:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgF0LGr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Jun 2020 07:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbgF0LGq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Jun 2020 07:06:46 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA96C03E979
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 04:06:46 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id q15so11055453wmj.2
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 04:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PC9uJEAL4GkoLY5i/syfIPWvmtSf0BqWhbpLEjV5p8Y=;
        b=Dm3prRpMkL+qJpmJw9wZ7tsFya5mSurYbZNFQ9gJvGGh7mY1sjpMAZowmnxiNyK6Ed
         MRo4x4Skb5Ga62ejyiNQP4NMBMVwrI2m6SKnMYjgMvvEvWmLAh4JIjrWAOM3gy2RWTk1
         d4OKxa2GArCXQp030QKhd5qScLMvULljnLqR35I+qLC0vYuaTvn0Ia803jBRD79BIG5s
         gO/V8EHzhJKCp1eJ+P250ri6Cbj4wG3CCGHc2hib9HyVf/w2qQDjMQAocEvr+SBlXXRo
         2u5yYg0ShSN3deExqFGTKX4ibUaiSOVadDqCW5+asDHqpgGh+Xwg8/8/lKXMbO/nwHPn
         m4Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PC9uJEAL4GkoLY5i/syfIPWvmtSf0BqWhbpLEjV5p8Y=;
        b=q9yrIAPhZ2kytgIs2I3b8sVwVN3GbK8BG4vgXf9/hkMyc2lHQrY4M/J5VAq9Q9O6Hp
         msUQycYeuhRIeNJxrIfBEnc+XRPMypV1lNCubTdfp4q6mOomyvwuFA7iHApN5b8CAHNj
         w3s6x4xSLcl64duTpSAwNBsuAk1pu5ROodkVlG348/oFB/c7GfXDiNtqZVV54YMtkMV3
         zMKnuEu8qChFJ3kBiAKgqAc0TItNb2T+Ob/dQvehdJmxPmNF7q4gUC6JY0xrf4VeJY9x
         V7V+si74TMmpRNu8a5muytVuGQdgUvgZ3xGzFQe+Ss0cNMsMDaizc29/qxKzDyp1K9bj
         Lf3w==
X-Gm-Message-State: AOAM5333EM55bVQhqTIuyE/FTEgL8G2VIy5kAWgGf2MxWfiPXQ8WhB9j
        HZnnV0FQzL+tvPz2YvNfCEc=
X-Google-Smtp-Source: ABdhPJy4D2DArx9o2RCMSnbblNCm4dkUvnfYgwt7632F3Dk3jQZXThDxcwgLyG85AWCeKNDODHE/pQ==
X-Received: by 2002:a7b:c09a:: with SMTP id r26mr7749605wmh.176.1593256005400;
        Sat, 27 Jun 2020 04:06:45 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id x1sm14706721wrp.10.2020.06.27.04.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 04:06:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/5] io_uring: don't mark link's head for_async
Date:   Sat, 27 Jun 2020 14:04:57 +0300
Message-Id: <1c991c960cc12de6909973b30e6f2bdb1c58e14f.1593253742.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593253742.git.asml.silence@gmail.com>
References: <cover.1593253742.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No reason to mark a head of a link as for-async in
io_req_defer_prep(). grab_env(), etc.that will be done
further during submission if neccessary.

Mark for_async=false saving extra grab_env() in many cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b577d6f50cbc..ca486bb5444a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6086,7 +6086,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (io_alloc_async_ctx(req))
 				return -EAGAIN;
 
-			ret = io_req_defer_prep(req, sqe, true);
+			ret = io_req_defer_prep(req, sqe, false);
 			if (ret)
 				req->flags |= REQ_F_FAIL_LINK;
 			*link = req;
-- 
2.24.0

