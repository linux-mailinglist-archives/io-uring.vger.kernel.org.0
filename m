Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E1C6EAA64
	for <lists+io-uring@lfdr.de>; Fri, 21 Apr 2023 14:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjDUMcF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Apr 2023 08:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDUMcE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Apr 2023 08:32:04 -0400
X-Greylist: delayed 313 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 21 Apr 2023 05:32:00 PDT
Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0667A5E4;
        Fri, 21 Apr 2023 05:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682080319;
        bh=duaV4P+X6txDoeNzJIEOXbCe/0dCS3xj0J0H4rJB7ds=;
        h=From:To:Cc:Subject:Date;
        b=xFnCpmD7VX4vg/TDYcIJitmIYqG2MxqartE+pe/K7GvfosqWpLze+GUIA2C8Nhg71
         nJhi38r+9bz/us6i3cUF7hRKdwan2FtGOahdmNvoIaqKIigk+0Fdgnf8IDw3g0wpup
         zU6qWtTPFytshWmLvw1RC/yT89oTW768Q2MJpamY=
Received: from localhost.localdomain ([39.156.73.13])
        by newxmesmtplogicsvrsza12-0.qq.com (NewEsmtp) with SMTP
        id 7A78CA50; Fri, 21 Apr 2023 20:30:39 +0800
X-QQ-mid: xmsmtpt1682080239tkwy769a8
Message-ID: <tencent_C8F457D8D10F44760333A1E1AC9B4B0C1507@qq.com>
X-QQ-XMAILINFO: NhUkPfKlCtQwyKVk0NWwFeOpU0M6n5+6EkfUj8WQUyqoroHTWaT4wTa8JcXiKy
         yz/s/rottm1ASTNDUEcttMunvLJl1W0uh/AsDjzXwXB8Qzx62HEsJOJcnUMka0AdP7OQtuQo0XjQ
         0/BCxFHd6DYta4b2uYC+CRprcHSh26UeExWDnb7+Zs/3SevpHkuVsZbZj86mjtdB+3AUFCmoHy1L
         x9JbWVdykIhKmHpeL5CrT35FwxED03nbFwNL7fcuM9WNo0DqhJgydl3Bt58+Y4BKTCil9Tm04s6f
         Pm9kxaPzhMFTczbzmtv1GO5CjTE7MATJ23ud8KtefepBv4MsqpTJY3B66bemx1bjyqba3Yz3IlTK
         GsUQlFMdRNVPFTq1BgSn8/Y749b2lE5mdqrEbkVCkEwK7/ulWYK8vlG8W8yUFDLjlmnzPwzn0C8/
         qp6x64AAxxXD91zTYbIygkrEzu7r+XUIlIXj1Yq1rJBuPKhly9uozFXa6gXxn7QyTyfIRzItxGMo
         VKvpXckwkLCH31083f3onMx87hJiN2j3b+NZXLV5OIsyQ6DytioeJ9km6LRu95Gx7G3mfzUKt3Ub
         n9pGW7aENmUrGmCV39B205o8lllhDAlt53qTthJiRV/EwcwvN/OzyiTOrwzJSH+XR0Z2IryUmBGI
         gcFqzdUmB6JmyY8h3oNMe7VmTT0vmrSRERp2mCORZ+SVvt53rIo+8hL7UGV80AkhjHwxkJ7Gk77c
         hoUheWcDe178BpKmAv27O3Wa8aqkfHufKBFO8N7crZQoE45EtvY7zh3Jc5mfoMXRbYHGqG+2JX0D
         uBzhV0/6JWzHkJA5lzqyyOJISIaJr/vq0bZuCckxdb7yKIlEyxRx2nVHm4lPErwQugh+NWV+EEn2
         9deZmPUUPq9negxU3kDGU3pSDKyxlCKuGep5JsI89pQjm3FFsWPnkTLPfLlW071Tgkto5T0iz5jP
         VtpNmhkTQy2+vQK1BHB0Kkli6hL3l9v4saojYXHYQWUeeQXvk+BohXwlOdbSd0SaPrtFKWB4uK4e
         2xvwhJcy1W7krVwXDt
From:   Rong Tao <rtoax@foxmail.com>
To:     axboe@kernel.dk
Cc:     rongtao@cestc.cn, Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        io-uring@vger.kernel.org (open list:IO_URING)
Subject: [PATCH] tools/io_uring: Add .gitignore
Date:   Fri, 21 Apr 2023 20:30:35 +0800
X-OQ-MSGID: <20230421123036.243146-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Rong Tao <rongtao@cestc.cn>

Ignore {io_uring-bench,io_uring-cp}.

Signed-off-by: Rong Tao <rongtao@cestc.cn>
---
 tools/io_uring/.gitignore | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 tools/io_uring/.gitignore

diff --git a/tools/io_uring/.gitignore b/tools/io_uring/.gitignore
new file mode 100644
index 000000000000..692123722108
--- /dev/null
+++ b/tools/io_uring/.gitignore
@@ -0,0 +1,2 @@
+/io_uring-bench
+/io_uring-cp
-- 
2.39.1

