Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9882650A10F
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 15:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386691AbiDUNsH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 09:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386711AbiDUNsD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 09:48:03 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519CBB7C4
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:14 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id m15-20020a7bca4f000000b0038fdc1394b1so5925843wml.2
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FcFlkg3/vyorXeLlS4jT5KFHTrI8AgCCGDmsSvORBCo=;
        b=M0E2g0atnxlfNxwRkJAJtGYmQtmLHjoNiSxQ98xxWdxmNTnljX+md1KolkmlzwobGY
         kZ/8IjQT4/rj+P2HJeBzDSRy5HLFYzD7HFSgXUINthrB7URmWzvkUnFarOkfC/TC084a
         ry56CSNDzKWyORwkfVGDvqzbJZX1xK8Mb3vkeoOYmiSreGfQXUQwBQGg/Kx0Cu4bnyUj
         zc/UKikFxkkDuXd+hrrCtvA+lfxV5EF4+IKF52qj8/mrcrCXipZRkzdM33BuTTvXDss4
         QSKiNr1kTUC+XhOCIKfVkQc9bVrE1gmgersl/B/6rNjTaD/3t4EKkSZTX5mmhP+u5jVx
         pXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FcFlkg3/vyorXeLlS4jT5KFHTrI8AgCCGDmsSvORBCo=;
        b=HJPKxYKxjAousdSNYRb4+ydbiqLIDBBNe2SoRq6Pnb+SOYVtH4fbAr/xaSnUiBA/4O
         kclRMG9f3PY/Nhcu92Zz86TJnV7L3PZ0BTTXG/tyS7jhjvq0KC4YzgF9e6UNrACg5aZv
         QEN8fc/E0rQpNFw3NFBbpLUS/jJ+5bebKRsXnqA2dZP19NqFffKTzGii3WjDLngwKLzE
         E19F405P/J/moszEToqQg2lGVx2rK0srPtmrihZdQ+jQpcOsk/54B0h2UPWnmjn8Da63
         hiqckotKj1ApEsf++Zzhz4ZD2MKYAAqYJJUKokydUoL2JgelfiaMEsFVVaJIyObKK+fX
         YumA==
X-Gm-Message-State: AOAM532rQHx1q7sHFbqFKW3nTRnHm5sEZRtEJCwDKO6to+pQaQnV3Nra
        fv3nLI/B4NMKOG/Vr94gQUv8RpMAZNA=
X-Google-Smtp-Source: ABdhPJzWzl0sN/ybruCKxRD8km5qrGo5zB6bn/8O0vjSHmLAyU4FObvjhY73BCrARvyCE7HaNZM6kA==
X-Received: by 2002:a7b:c347:0:b0:37e:68e6:d85c with SMTP id l7-20020a7bc347000000b0037e68e6d85cmr8981101wmj.176.1650548712721;
        Thu, 21 Apr 2022 06:45:12 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.218])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm2837821wri.45.2022.04.21.06.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:45:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 05/11] io_uring: add dummy io_uring_task_work_run()
Date:   Thu, 21 Apr 2022 14:44:18 +0100
Message-Id: <45c494988922fd5f155f81bca6216b06cadc14a7.1650548192.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650548192.git.asml.silence@gmail.com>
References: <cover.1650548192.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Preparing to decoupling io_uring from task_works, add a new helper. It's
empty for now but will be used for running io_uring's task work items.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 1814e698d861..e87ed946214f 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -5,6 +5,10 @@
 #include <linux/sched.h>
 #include <linux/xarray.h>
 
+static inline void io_uring_task_work_run(void)
+{
+}
+
 #if defined(CONFIG_IO_URING)
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
-- 
2.36.0

