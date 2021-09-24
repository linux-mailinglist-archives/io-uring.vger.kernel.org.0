Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D359A417B74
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 21:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346170AbhIXTHg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 15:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhIXTHf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 15:07:35 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C771C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:06:02 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id c21so39334904edj.0
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=AtefL8lTV00VAdhOFVMSb/wrYCaeCdlRuTpk4Mudy+8=;
        b=b0k92k2PoKPFisZBt6nOimOh+d2O+tB2fvi97UfUNiUZdwkcJV7iigjPE4irNmQVOl
         7CpM2H/ROhFvbOJjuDYSvYN/SLL3mkoJolChYHjcoykDZE7k71WhsGsBxHE/sfdv37aX
         NAhjqaQR6+tDmIpxhIXXEDpbMuDZA/Cr49KA/0/F32LLAQ0SdJ4nwFTHJAe0xboihB4Y
         4JPkTIADJQTOcu8LmdkJZrU5cDrqCPuq2RL9qmRn/lqk41j30S364X5VgzP6ylfXAOGz
         ShDnXY3VoTOFDKXEX/SEJnqVAxA8ZERuwoRgtje2kja29XIi9M08EMYVpxRdExWjVANA
         9aEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AtefL8lTV00VAdhOFVMSb/wrYCaeCdlRuTpk4Mudy+8=;
        b=FJs382JZHmGosOkf1QAkWDTLzhH03A0CDjZxKYkLeTM9czjMmrrezbtRKUNhlK3dic
         dnar0LwInAFmCKIqcgBneYk9pWvfTsCfTzqunJ92WUZQLJq3MnN+Grkg1xzakHSZIFem
         WG/WtQ2sRu3lOGIQ0lyd1QDkF0kOiApXnNuJ97ZekRdK6LlJcJFYZfGv2bzt/uYD2Vb6
         cdJAcirtBrGNHolgGHnieSYMM7HD51dqb3gRb1CECUxykMJgM3qwiYyl2MSVDPXha82K
         BxFfI0W66UoL3xS3pMuu/7GVifcTwsGd5hbov1SZKE7tMK6NDqnJ4H2V/UDBeifOVwPn
         6APw==
X-Gm-Message-State: AOAM533Rd9w74IZw3Nbb13tqr7aXSoFs/DYFvOZRWztPGryW4atnx+v5
        tNQPmoda7xgpXIlvUGhdnHo=
X-Google-Smtp-Source: ABdhPJzgY2WD/Z+9o2XWPKeAqaINkhpG3hmvfP4PF8/Ga9++01EZD1458zBGk+HwvJ84rdaSatiQaw==
X-Received: by 2002:a50:d9c9:: with SMTP id x9mr6935846edj.179.1632510360679;
        Fri, 24 Sep 2021 12:06:00 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id m10sm5380301ejx.76.2021.09.24.12.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 12:06:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/2] tests: match kernel and pass fds in s32[]
Date:   Fri, 24 Sep 2021 20:05:17 +0100
Message-Id: <260526556a2a44c833e2265ba59e5d2705ce8870.1632507515.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632507515.git.asml.silence@gmail.com>
References: <cover.1632507515.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Follow the kernel ABI and pass fds in an array of s32 but not just ints.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/rsrc_tags.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/rsrc_tags.c b/test/rsrc_tags.c
index a3fec0c..f441b5c 100644
--- a/test/rsrc_tags.c
+++ b/test/rsrc_tags.c
@@ -322,7 +322,7 @@ static int test_files(int ring_flags)
 	struct io_uring ring;
 	const int nr = 50;
 	int off = 5, i, ret, fd;
-	int files[nr];
+	__s32 files[nr];
 	__u64 tags[nr], tag;
 
 	for (i = 0; i < nr; ++i) {
-- 
2.33.0

