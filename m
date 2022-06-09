Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E3254479F
	for <lists+io-uring@lfdr.de>; Thu,  9 Jun 2022 11:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbiFIJd6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jun 2022 05:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241975AbiFIJd5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jun 2022 05:33:57 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E213855AE
        for <io-uring@vger.kernel.org>; Thu,  9 Jun 2022 02:33:54 -0700 (PDT)
Message-ID: <02f64aa0-b68e-9a9c-edbe-08247e898640@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654767229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pU8l3xvX8xSnZau6CFbvHmzLs5lAvJqEgrhRh8MUDWs=;
        b=eGXO9tBrqQKY5zmniMFIRSKM4vTOYHA7fv/ajQ1MYSiRwrgSq/bpWX3Oe2RIjgLWv77o0h
        U8XCCyghvd019FNYXEMTsxINor+TR2PWg7o+i2j0qSl7WElLXGJ2ny5qbGyg91RJYsYJc/
        VuhHwdixoMbaCf0NltXWjAMYfqC64xY=
Date:   Thu, 9 Jun 2022 17:33:44 +0800
MIME-Version: 1.0
Subject: Re: Possible bug for ring-mapped provided buffer
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <1884ea45-07df-303a-c22c-319a2394b20f@linux.dev>
In-Reply-To: <1884ea45-07df-303a-c22c-319a2394b20f@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/22 15:53, Hao Xu wrote:
> Hi all,
> I haven't done tests to demonstrate it. It is for partial io case, we
> don't consume/release the buffer before arm_poll in ring-mapped mode.
> But seems we should? Otherwise ring head isn't moved and other requests
> may take that buffer. What do I miss?
> 
> Regards,
> Hao

something like this:


diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index d2b2b4728381..ae4c69ad0f86 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -48,7 +48,10 @@ void __io_kbuf_recycle(struct io_kiocb *req, unsigned 
issue_flags)
          * If the tail has already been incremented, hang on to it.
          */
         if (req->flags & REQ_F_BUFFER_RING) {
-               if (req->buf_list) {
+               if (req->flags & REQ_F_PARTIAL_IO) {
+                       req->buf_list->head++;
+                       req->buf_list = NULL;
+               } else if (req->buf_list) {
                         req->buf_index = req->buf_list->bgid;
                         req->flags &= ~REQ_F_BUFFER_RING;
                 }
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index b58d9d20c97e..9ecb175e60a9 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -58,8 +58,14 @@ static inline void io_kbuf_recycle(struct io_kiocb 
*req, unsigned issue_flags)
  {
         if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
                 return;
-       /* don't recycle if we already did IO to this buffer */
-       if (req->flags & REQ_F_PARTIAL_IO)
+       /*
+        * For legacy provided buffer mode, don't recycle if we already did
+        * IO to this buffer. For ring-mapped provided buffer mode, we 
should
+        * increment ring->head to explicitly monopolize the buffer to avoid
+        * multiple use.
+        */
+       if ((req->flags & REQ_F_BUFFER_SELECTED) &&
+           (req->flags & REQ_F_PARTIAL_IO))
                 return;
         __io_kbuf_recycle(req, issue_flags);
  }
