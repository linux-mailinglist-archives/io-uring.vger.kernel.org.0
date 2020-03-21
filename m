Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 880B218DFB8
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2020 12:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgCULTW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Mar 2020 07:19:22 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44885 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgCULTW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Mar 2020 07:19:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id m17so1548606wrw.11;
        Sat, 21 Mar 2020 04:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4DHh+FncC3jqVGC7ZZ0jqP/hNLUiPdG5Ott4j1JBTPE=;
        b=cUv2WbX/FdmKXUyKTkr9rFaUCQceo2Lv1WDeH00AId4csYJnmXX79PxLy2cNOYq2oy
         25LseCFbvcLhvJCJi/rzaE6TLq6oP/fcf4bHXf0WqVuFtd0AwRmCOR3gmT7kJNt+3WTR
         uLNVOeP8sQ9zx+DaeSw5D22riM1lCWG8U3EzLr1HT3G/z93pKBaquiNRscuLlYkqY4kG
         ZdO9OybuWyuDjgG1a1EcEN8kWQvdRyj0eT2WtgBjiHJaT0YY6tAPEow/lX8rzqnQeZXQ
         7fEnGyhWAqEXXxVQWU4QHEZo8D/S/HBYcFtkRiRPU1Wvj22HzHzXpPl2tMasalhNEtRn
         C9KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4DHh+FncC3jqVGC7ZZ0jqP/hNLUiPdG5Ott4j1JBTPE=;
        b=jHrAhnuW139ISpVFOqyO6F71FAILWG2Wpv663DyhLHvsU15yildCgN1cJg068/Qtw9
         rHu/1UPjvxZla/1d3BhAcKIOG1aidER4nQo5ViY0m53OoJDV/Cp49VfEu58mPhgFsy3f
         +QqPgNfzScDg40Kw+yyuU4vW0en0CmD8ElJSz71tVqKuQ7FS3Tjbsv0Q5pYoJMt5dcB/
         xhuhgPFzonttQiV5MkszDrssBjOCR4IjOKDOThYSuoR5nx6pR25/OCgvxeNylH1Nhwx9
         nltC2zWFtfBAxunUsFq/xFq0Kc8jDUl7kWcRTM9RMIo/7/gy9PpNSJwusCQy2OwoaRha
         XWCg==
X-Gm-Message-State: ANhLgQ2ZDDybJthEho2S+AICwxD8PBoDmrz65kqPzpDP19uIsXwdWQKi
        88MnW+zk+SyndbNkQxWyi/k=
X-Google-Smtp-Source: ADFU+vv7cKC4LRCcSjn+qvMZADkhv0rZaKnuw0JfyQkwg8vZTuHyRV7kQQtY4q5EcLt1Sd/2OWO8bg==
X-Received: by 2002:adf:e78e:: with SMTP id n14mr17861476wrm.363.1584789559971;
        Sat, 21 Mar 2020 04:19:19 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2d49:b100:e503:a7c7:f4c6:1aab])
        by smtp.gmail.com with ESMTPSA id n1sm13023191wrj.77.2020.03.21.04.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2020 04:19:19 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-spdx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] io_uring: make spdxcheck.py happy
Date:   Sat, 21 Mar 2020 12:19:07 +0100
Message-Id: <20200321111907.6917-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Commit bbbdeb4720a0 ("io_uring: dual license io_uring.h uapi header")
uses a nested SPDX-License-Identifier to dual license the header.

Since then, ./scripts/spdxcheck.py complains:

  include/uapi/linux/io_uring.h: 1:60 Missing parentheses: OR

Add parentheses to make spdxcheck.py happy.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on next-20200320

 include/uapi/linux/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6d9d2b1cc523..e48d746b8e2a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note OR MIT */
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
 /*
  * Header file for the io_uring interface.
  *
-- 
2.17.1

