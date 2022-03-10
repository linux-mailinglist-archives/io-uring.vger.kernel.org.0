Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137CA4D4568
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 12:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241147AbiCJLOL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 06:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241211AbiCJLOJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 06:14:09 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A20BE1EB
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 03:13:08 -0800 (PST)
Received: from localhost.localdomain (unknown [138.197.159.143])
        by gnuweeb.org (Postfix) with ESMTPSA id CE4567E2E0;
        Thu, 10 Mar 2022 11:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646910788;
        bh=OMEfabtPm7vY8fJO6cczoM+3Wl07SdHJQA2hhu2EJjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cf0ffYlBTBw4XDqnsk5qfsG2mQ8uQdhe3pljG3LHuTImSziJ87VGb6etp+twmeZLB
         9PiGIl6jmouQBUM8Eyyq9bwq3ac3p6hve1ua+5/LvE1EscQTD8q8Y+EPgmBZBIdA2C
         Ne5cyJi1g3docZcPJObdi8TOe5KO5vHK22rO9QicfHx1ZpYAoDznAN7Ewo+i7IZkXQ
         nAuXvE3WpUfq7uGdKD59WGm0QLK6UwG1WuyXjtRkz1zFn9wueFveFUJbojjXEcAxxs
         Aler5p0LSz2rCcKp91GSAdkoFcXcGIj1meM7oKGlRQnCpSPh2J89W+57qBuK+1Oj1H
         UXwB71hE5T2tQ==
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, gwml <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v3 1/4] src/Makefile: Remove `-fomit-frame-pointer` from default build
Date:   Thu, 10 Mar 2022 11:12:28 +0000
Message-Id: <20220310111231.1713588-2-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220310111231.1713588-1-alviro.iskandar@gnuweeb.org>
References: <20220310111231.1713588-1-alviro.iskandar@gnuweeb.org>
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
2.25.1

