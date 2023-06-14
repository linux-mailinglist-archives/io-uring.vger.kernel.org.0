Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB468730319
	for <lists+io-uring@lfdr.de>; Wed, 14 Jun 2023 17:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343586AbjFNPNE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Jun 2023 11:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343588AbjFNPNA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Jun 2023 11:13:00 -0400
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9438A1FE3;
        Wed, 14 Jun 2023 08:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=OHZn+k1AM9F1aty+YrtKkF7m95JGwUE4afqcP7fAHA8=; b=g
        /bdE4cvMeMBSwBXoKSoOD/yOK0BzlaCrH3txPZJWrVNFWOFP8PPg80N/WWz11+4v
        303mRIpCcqMNu271IJJ3XyMqaqPjVbnAoeth/M9NCQrzUuxKYbLbdzdjVKNAJSEC
        f21xUq/rKrXod/hpwToNlVgtae2YZj4VBce0Z/SP7g=
Received: from ubuntu.localdomain (unknown [10.230.35.76])
        by app1 (Coremail) with SMTP id XAUFCgC3v__v2IlkbinsAA--.37499S2;
        Wed, 14 Jun 2023 23:12:48 +0800 (CST)
From:   Chenyuan Mi <cymi20@fudan.edu.cn>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chenyuan Mi <cymi20@fudan.edu.cn>
Subject: [PATCH] io_uring/kbuf: fix missing check for return value of io_buffer_get_list()
Date:   Wed, 14 Jun 2023 08:12:46 -0700
Message-Id: <20230614151246.116391-1-cymi20@fudan.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: XAUFCgC3v__v2IlkbinsAA--.37499S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr4fur4UZr48Xry5Zw17GFg_yoWDAFc_G3
        ykZr18u343GFsYkr1UCryrArWUCF43Zr4xWFyIyas3GF1YkF4rAFZ5ZFZ7Wr1xGa13W3yj
        yF4qgw1agr1IgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbskFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2
        IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
        6r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2
        IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E
        87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73Uj
        IFyTuYvjfUOXo2UUUUU
X-CM-SenderInfo: isqsiiisuqikmt6i3vldqovvfxof0/
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The io_buffer_get_list() function may return NULL, which may
cause null pointer deference, and other callsites of
io_buffer_get_list() all do Null check. Add Null check for
return value of io_buffer_get_list().

Found by our static analysis tool.

Signed-off-by: Chenyuan Mi <cymi20@fudan.edu.cn>
---
 io_uring/kbuf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 2f0181521c98..d209a0a9e337 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -66,9 +66,11 @@ void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 
 	buf = req->kbuf;
 	bl = io_buffer_get_list(ctx, buf->bgid);
-	list_add(&buf->list, &bl->buf_list);
-	req->flags &= ~REQ_F_BUFFER_SELECTED;
-	req->buf_index = buf->bgid;
+	if (likely(bl)) {
+		list_add(&buf->list, &bl->buf_list);
+		req->flags &= ~REQ_F_BUFFER_SELECTED;
+		req->buf_index = buf->bgid;
+	}
 
 	io_ring_submit_unlock(ctx, issue_flags);
 	return;
-- 
2.17.1

