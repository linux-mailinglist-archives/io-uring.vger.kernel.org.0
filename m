Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802D26377E3
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 12:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiKXLro (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 06:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiKXLrl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 06:47:41 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EE0FFF
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 03:47:30 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 3372C8166D;
        Thu, 24 Nov 2022 11:47:26 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669290450;
        bh=eiWoW7SsKexMoYK+aXHgvZrDbaN0ONDDt4rC72Y21aQ=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=UmWUU/sZ4uj9unRYIZMI8CWaYypc3mNhPN4ExuAeBLf4QbXgtGL5iND/PbfNYdgE5
         GVHvV4btUDODFo1BOKgWJzMIpK890X4UZur01NiZW31SKmHU/QHchi7lN6A2jCcSkI
         dnj1j/J7bU1S/bHXBBrMBAHxJegJ1X2NNW1NTkT25OQxWNPMQ6X40B38lyX3f+fNUx
         YlxQ3ophoFYiNpZopkbCMnfENp6kAJEY+UNg8M+2rr8mu+R1t9PTJppf/8DaVKVXWD
         4ODdgQFGBnHrtMMRqV8PsRevh8MflgFP2AukZTGVzi4/t150wDtaeFsrj280HvH57e
         bIj4313FBrDJw==
Message-ID: <b303bde6-91b1-2ea2-7b1d-e64546c8ae7f@gnuweeb.org>
Date:   Thu, 24 Nov 2022 18:47:24 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>
References: <20221124075846.3784701-1-ammar.faizi@intel.com>
 <20221124075846.3784701-2-ammar.faizi@intel.com>
 <f750be65c33e5d3a782cebf85954319caa77672f.camel@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v1 1/7] liburing.h: Export
 `__io_uring_flush_sq()` function
In-Reply-To: <f750be65c33e5d3a782cebf85954319caa77672f.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/22 5:14 PM, Dylan Yudaken wrote:
> I think changing the tests to use the public API is probably better
> than exporting this function. I don't believe it has much general use?

But there is no public API that does the same thing. I'll mark it
as static and create a copy of that function in iopoll.c (in v2).

Something like this, what do you think?

  src/queue.c   |  2 +-
  test/iopoll.c | 33 ++++++++++++++++++++++++++++++++-
  2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index feea0ad..b784b10 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -201,7 +201,7 @@ again:
   * Sync internal state with kernel ring state on the SQ side. Returns the
   * number of pending items in the SQ ring, for the shared ring.
   */
-unsigned __io_uring_flush_sq(struct io_uring *ring)
+static unsigned __io_uring_flush_sq(struct io_uring *ring)
  {
  	struct io_uring_sq *sq = &ring->sq;
  	unsigned tail = sq->sqe_tail;
diff --git a/test/iopoll.c b/test/iopoll.c
index 20f91c7..5edd5c3 100644
--- a/test/iopoll.c
+++ b/test/iopoll.c
@@ -201,7 +201,38 @@ err:
  	return 1;
  }
  
-extern unsigned __io_uring_flush_sq(struct io_uring *ring);
+/*
+ * Sync internal state with kernel ring state on the SQ side. Returns the
+ * number of pending items in the SQ ring, for the shared ring.
+ */
+static unsigned __io_uring_flush_sq(struct io_uring *ring)
+{
+	struct io_uring_sq *sq = &ring->sq;
+	unsigned tail = sq->sqe_tail;
+
+	if (sq->sqe_head != tail) {
+		sq->sqe_head = tail;
+		/*
+		 * Ensure kernel sees the SQE updates before the tail update.
+		 */
+		if (!(ring->flags & IORING_SETUP_SQPOLL))
+			IO_URING_WRITE_ONCE(*sq->ktail, tail);
+		else
+			io_uring_smp_store_release(sq->ktail, tail);
+	}
+	/*
+	 * This _may_ look problematic, as we're not supposed to be reading
+	 * SQ->head without acquire semantics. When we're in SQPOLL mode, the
+	 * kernel submitter could be updating this right now. For non-SQPOLL,
+	 * task itself does it, and there's no potential race. But even for
+	 * SQPOLL, the load is going to be potentially out-of-date the very
+	 * instant it's done, regardless or whether or not it's done
+	 * atomically. Worst case, we're going to be over-estimating what
+	 * we can submit. The point is, we need to be able to deal with this
+	 * situation regardless of any perceived atomicity.
+	 */
+	return tail - *sq->khead;
+}
  
  /*
   * if we are polling io_uring_submit needs to always enter the


-- 
Ammar Faizi

