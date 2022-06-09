Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84147544815
	for <lists+io-uring@lfdr.de>; Thu,  9 Jun 2022 11:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242966AbiFIJzD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jun 2022 05:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242987AbiFIJzB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jun 2022 05:55:01 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1561195798
        for <io-uring@vger.kernel.org>; Thu,  9 Jun 2022 02:54:57 -0700 (PDT)
Message-ID: <2c78b0b4-4f07-3bda-30b4-e4a0928b8e7e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654768495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZGojRWLZkpFdE8oPmaHtWDUmCPjxK4U1CEEW35rpVS0=;
        b=xAZCsMpYkppz9cbyWaPA4AxG7J+07JqZ+Kq0WL2QpJ7PfbDJRzeJQCW9Bt/2cJKq/r8gwk
        s0DB/eYzlRLm2ETj4pLKafZR9lSMizcbpeBru4YqYKKazWKUqzgt1DV4cWgtL0BCZJ6k35
        UaZV3H77MX2ClK/JO/U0/sAxH+M9qJ8=
Date:   Thu, 9 Jun 2022 17:54:47 +0800
MIME-Version: 1.0
Subject: Re: Possible bug for ring-mapped provided buffer
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <1884ea45-07df-303a-c22c-319a2394b20f@linux.dev>
 <02f64aa0-b68e-9a9c-edbe-08247e898640@linux.dev>
In-Reply-To: <02f64aa0-b68e-9a9c-edbe-08247e898640@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/22 17:33, Hao Xu wrote:
> On 6/9/22 15:53, Hao Xu wrote:
>> Hi all,
>> I haven't done tests to demonstrate it. It is for partial io case, we
>> don't consume/release the buffer before arm_poll in ring-mapped mode.
>> But seems we should? Otherwise ring head isn't moved and other requests
>> may take that buffer. What do I miss?
>>
>> Regards,
>> Hao
> 
> something like this:
> 

forgot something in previous diff

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index d2b2b4728381..9ff8d14277ff 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -49,8 +49,15 @@ void __io_kbuf_recycle(struct io_kiocb *req, unsigned 
issue_flags)
          */
         if (req->flags & REQ_F_BUFFER_RING) {
                 if (req->buf_list) {
-                       req->buf_index = req->buf_list->bgid;
-                       req->flags &= ~REQ_F_BUFFER_RING;
+                       if (req->flags & REQ_F_PARTIAL_IO) {
+                               io_ring_submit_lock(ctx, issue_flags);
+                               req->buf_list->head++;
+                               io_ring_submit_unlock(ctx, issue_flags);
+                               req->buf_list = NULL;
+                       } else {
+                               req->buf_index = req->buf_list->bgid;
+                               req->flags &= ~REQ_F_BUFFER_RING;
+                       }
                 }
                 return;
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


