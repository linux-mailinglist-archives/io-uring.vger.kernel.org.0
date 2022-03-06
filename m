Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A64F4CEA87
	for <lists+io-uring@lfdr.de>; Sun,  6 Mar 2022 11:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbiCFKhE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Mar 2022 05:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbiCFKhD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Mar 2022 05:37:03 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E223E424A8
        for <io-uring@vger.kernel.org>; Sun,  6 Mar 2022 02:36:11 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y2so11532683edc.2
        for <io-uring@vger.kernel.org>; Sun, 06 Mar 2022 02:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DDwcjiqxRhoig8KNuPLOGLHsRfAcfl3QZyKMLPh2PnI=;
        b=SjDTRjXVL+Ob8cWqA1sQFYOL+UnvVCksilZ7BVbbHPu1qq0DwfPXLQ/6LO6HNVwqL/
         vX38KadQpJPVOeJC3xX/TzJIdXYSlTV4XNPN2KVL/VJfzjUdzhJT4Fj1cEzPAHiU10wn
         SQDFVxeRe2dEu24WOpYIvadfJk7yQs9bZ8M/KdqhCAI1QfwPNYp2OSE2X++gCBC02Vku
         OI0pHXZgBxLmulReplM6Po+CR3h8Z4JnPwITKPZtyaswZR75FxdSmqUISK8mJDiMfL6n
         jQ3W6zvJYaJUBODZFtdV/o5d6ILcGywlk2idWzAQtsmL4miJ/VKzoTNTVlTtf9HnMZEG
         fwuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DDwcjiqxRhoig8KNuPLOGLHsRfAcfl3QZyKMLPh2PnI=;
        b=FUn/nnTTl8UmpQ02oQOKsVXfHd1wiwsOOXeEbesEZ4FgSXHKTQoVeaLhUl6/pVdMkH
         JzMoTk2XmER6BTp97MWAIHWXK1e0Zn+V8u4beZD2OQfVcNZT2Hir2lnOMCLZx1noZfRi
         lAr8+WC8VTPDyUjDvf7p3B8fOwso8oZjzi3CVAeBx+W0PhsjSaPh7vVctcUfIGofPh8p
         Dx23lK3+2Kju/m8rGVuakkJg2tZARcxz9MRWyvhDJaeVuotSZMEtIOljCdBp240BVaM+
         VwWq5RpTgJsK5LgiCtx5xI4ApEWlJ6/Ti0AzX1zgrkLuWwozh2TwGaFEY5HVOiPhCofH
         tD8w==
X-Gm-Message-State: AOAM533sT7B3zPi0F1/6/QonkhsZvooAwRibwEjlHBQOeWxEwO9kgs/4
        yVv8YD93/cdixQlBRlhuITWjwgu5LLCO67jHAs8=
X-Google-Smtp-Source: ABdhPJwn0gZKQIiYlBCk0ahHyx6vyUjbRy26Rsfg9iXHoeWccE24gCrMnJw9T0D0d439RnhPobronw==
X-Received: by 2002:a05:6402:254c:b0:412:b2d0:d212 with SMTP id l12-20020a056402254c00b00412b2d0d212mr6376229edb.181.1646562969872;
        Sun, 06 Mar 2022 02:36:09 -0800 (PST)
Received: from localhost.localdomain (89-139-33-239.bb.netvision.net.il. [89.139.33.239])
        by smtp.gmail.com with ESMTPSA id e5-20020a170906374500b006d5825520a7sm3712945ejc.71.2022.03.06.02.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 02:36:09 -0800 (PST)
From:   Almog Khaikin <almogkh@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [PATCH] io_uring: fix memory ordering when SQPOLL thread goes to sleep
Date:   Sun,  6 Mar 2022 12:35:44 +0200
Message-Id: <20220306103544.96974-1-almogkh@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Without a full memory barrier between the store to the flags and the
load of the SQ tail the two operations can be reordered and this can
lead to a situation where the SQPOLL thread goes to sleep while the
application writes to the SQ tail and doesn't see the wakeup flag.
This memory barrier pairs with a full memory barrier in the application
between its store to the SQ tail and its load of the flags.

Signed-off-by: Almog Khaikin <almogkh@gmail.com>
---
 fs/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4715980e9015..221961be9213 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7613,6 +7613,13 @@ static int io_sq_thread(void *data)
 					needs_sched = false;
 					break;
 				}
+
+				/*
+				 * Ensure the store of the wakeup flag is not
+				 * reordered with the load of the SQ tail
+				 */
+				smp_mb();
+				
 				if (io_sqring_entries(ctx)) {
 					needs_sched = false;
 					break;
-- 
2.35.1

