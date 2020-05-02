Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED221C250D
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2020 14:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgEBMKk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 May 2020 08:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726654AbgEBMKk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 May 2020 08:10:40 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D2FC061A0C;
        Sat,  2 May 2020 05:10:40 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z6so3130998wml.2;
        Sat, 02 May 2020 05:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lPr29k9RhQr589P04yAVrhsNnJ7exYeB4/uJNuFLT88=;
        b=OIQmRP1HYjiNVA2bdyAXq1GRdtCdlmQJsbBZo+O3U1gRDxl8Y0DdiFf74DnJmmHmUV
         VYG/y5z046E7yHhxBdkCFgS8Hrg2NwUaMfgRpJARtVpFlaB77ohYDpyeYhmdUX8ZC6Sh
         xA9uu8t2sZHlo6uDCGiHVQ2iDsHB2256VRjPQOk94pdx2DV8CtLcBn4UwNVrD4ylcqoJ
         ocQpOuQ2LLYiVgwSjfKIWtz6DZTVdHFvY9S//hoGqxXcudijLflSIBHl3axYIYONRoKy
         vZbaVxnnpgHUZ7S163W4hTqyA685sKO+9XlpAQaOxObCPnQRzxZ/HNsP2dWt/kcXccaB
         wJeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lPr29k9RhQr589P04yAVrhsNnJ7exYeB4/uJNuFLT88=;
        b=E2ypGGBChQcoqF8ZrPRKIQqwfdi1nLt/DHvyzRJSI1mwkN04QA4IcARNQkwgAY1vv6
         B/ADc2V50c83SLALANLMz9aQU1qSBkCHJGu8jm/BVgFF38Lxqfc7BHjw2W9m/Dq9E9Wg
         37HLPhYtiCL2xUbx1NLAWm0TtWKCiCBVps1tVNcEO1p1eWwvnknHHlsRx89Y3c6BPE1R
         ukT/WH2NcsSmwjymgTCn2dfOSc5w5fp0e6UUlm+8og4F4uNPWfqApV/AV6BWnn4pfvOo
         OSXRaUfMFV+bp/XQF5FsGJ6USH78uCH1Ifs+KWfKLKRebHar0YyAadTZIo6QxTKSWA57
         s37Q==
X-Gm-Message-State: AGi0PuYxum8Gk6WPq8p6AeLf4QRXMKiZSdyBqDV9JQGy60wdNNvjU/e9
        XcwhN85LeC0ILCMwG061juA=
X-Google-Smtp-Source: APiQypLme8PeyVVqSQ3rxJG5vPC9t3mry1ihG64kNeIYwbi69bukbrNUXcGW3ex8o8Mx4aJ1N1x5MQ==
X-Received: by 2002:a1c:4346:: with SMTP id q67mr4319532wma.162.1588421438812;
        Sat, 02 May 2020 05:10:38 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id m15sm3858297wmc.35.2020.05.02.05.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 05:10:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Clay Harris <bugs@claycon.org>
Subject: [PATCH 1/2] splice: export do_tee()
Date:   Sat,  2 May 2020 15:09:25 +0300
Message-Id: <56e9c3c84e5dbf0be8272b520a7f26b039724175.1588421219.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1588421219.git.asml.silence@gmail.com>
References: <cover.1588421219.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

export do_tee() for use in io_uring

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/splice.c            | 3 +--
 include/linux/splice.h | 3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 4735defc46ee..000be62c5146 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1763,8 +1763,7 @@ static int link_pipe(struct pipe_inode_info *ipipe,
  * The 'flags' used are the SPLICE_F_* variants, currently the only
  * applicable one is SPLICE_F_NONBLOCK.
  */
-static long do_tee(struct file *in, struct file *out, size_t len,
-		   unsigned int flags)
+long do_tee(struct file *in, struct file *out, size_t len, unsigned int flags)
 {
 	struct pipe_inode_info *ipipe = get_pipe_info(in);
 	struct pipe_inode_info *opipe = get_pipe_info(out);
diff --git a/include/linux/splice.h b/include/linux/splice.h
index ebbbfea48aa0..5c47013f708e 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -82,6 +82,9 @@ extern long do_splice(struct file *in, loff_t __user *off_in,
 		      struct file *out, loff_t __user *off_out,
 		      size_t len, unsigned int flags);
 
+extern long do_tee(struct file *in, struct file *out, size_t len,
+		   unsigned int flags);
+
 /*
  * for dynamic pipe sizing
  */
-- 
2.24.0

