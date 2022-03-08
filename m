Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335B04D246B
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 23:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbiCHWlZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 17:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237826AbiCHWlY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 17:41:24 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90F258E68
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 14:40:26 -0800 (PST)
Received: from localhost.localdomain (unknown [138.197.159.143])
        by gnuweeb.org (Postfix) with ESMTPSA id 97A977E6DA;
        Tue,  8 Mar 2022 22:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646779226;
        bh=GKwYOXzEowl6fOPVN4UroclsoZy79CJfjujBnS0pxrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDnIHZTgDgdXU1kLL6rqXDRs/W6e/yM7YHKACNPBgjZHOpFkyd9Moi2ZAWayJegL8
         z6wUOhn7/dirFwUGBYzjt+8SAdpAGXmV6CLhWE0wMjQzi2AyDFeeVDVYniD/3oELy9
         LgFnp14TJyVG9cCXq2Avq4OhGm+E7l/nXJwNIVEtNY0jCaxzlZq0dJY+fyF7tYwmsH
         djfmCJFsF8NCPTXL3L6J/HlzhRxeoZdPZmUGeGC1dyZ6MhhoJ/wLp+RttN8IRDentB
         pvEa3mYwI9I25GzaZhO1ZH67AlTfvYJ+nAFoUeu5hDDuqEPpA8WZexVW0gp4FVtr1i
         mxYWXFpTVrotA==
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring@vger.kernel.org, gwml@vger.gnuweeb.org
Subject: [PATCH liburing 1/2] src/Makefile: Remove `-fomit-frame-pointer` from default build
Date:   Tue,  8 Mar 2022 22:40:01 +0000
Message-Id: <20220308224002.3814225-2-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220308224002.3814225-1-alviro.iskandar@gnuweeb.org>
References: <20220308224002.3814225-1-alviro.iskandar@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

-fomit-frame-pointer is already turned on by -O1 optimization flag.

The liburing default compilation uses -O2 optimization, -O2 turns on
all optimization flags specified by -O1. Therefore, we don't need to
specify -fomit-frame-pointer here. Remove it.

Link: https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---
 src/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/Makefile b/src/Makefile
index 3e1192f..f19d45e 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -8,7 +8,7 @@ libdevdir ?= $(prefix)/lib
 CPPFLAGS ?=
 override CPPFLAGS += -D_GNU_SOURCE \
 	-Iinclude/ -include ../config-host.h
-CFLAGS ?= -g -fomit-frame-pointer -O2 -Wall -Wextra -fno-stack-protector
+CFLAGS ?= -g -O2 -Wall -Wextra -fno-stack-protector
 override CFLAGS += -Wno-unused-parameter -Wno-sign-compare -DLIBURING_INTERNAL
 SO_CFLAGS=-fPIC $(CFLAGS)
 L_CFLAGS=$(CFLAGS)
-- 
2.32.0

