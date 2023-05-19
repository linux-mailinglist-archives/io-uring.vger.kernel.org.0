Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20CAD70A017
	for <lists+io-uring@lfdr.de>; Fri, 19 May 2023 21:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjESTuJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 May 2023 15:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjESTuH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 May 2023 15:50:07 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5A7E43
        for <io-uring@vger.kernel.org>; Fri, 19 May 2023 12:50:03 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-76c6ba5fafaso1261839f.1
        for <io-uring@vger.kernel.org>; Fri, 19 May 2023 12:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684525802; x=1687117802;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2NOxXSZ8y0reFVIaRGROddIXzipYkk5wKhcrrKEaAS8=;
        b=p1BEf2fZcAmO31S0GMMNovj2vkGk6bN1a6JYKJbO6zh9LWx3k1B/XIVjDpLieoL03H
         +vMg4RKR17qCzfV7vKmGW/eGLuKMYTxQZ/N85wYb9GQjLBDK3lkEnwV0DwesWd3B7Fok
         MIsn4u/OSqa6tj3pba/H6y8dpw7NJBw+mnisprhCKfpJUferuZYO0GP9AEsxZF8Ykjcm
         QcALxdAKmIOpYMEEqA7KUz552iYwqKAmO5zpSa+Z/tDjwUJhg+gDxQYdCdAtnz74M8Ty
         /n0OG+gz+cokE2DjVj3l1Q5yLdSet0n6L/zX9rEp+vlElYzAauCpo+7wX1CUZ/ugZE4z
         +Tyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684525802; x=1687117802;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2NOxXSZ8y0reFVIaRGROddIXzipYkk5wKhcrrKEaAS8=;
        b=leSZWGTn30bIED0Hlioig8B0LOQadPJOjEX8A85W/D7PC8L7/5n9C0NGpOJI5pjsx6
         8bAATPLsj3Cts7fh5AaDkIssdkWxo+nm897npzSExfBN4Whc4KN765TyXR2cfBU3FD+7
         DfSkdPGY+TLDnQTmXQ6zi0l5I9wBVVVGgbDpxmJfpd5+5kkXEeIy/V/7dLkYrIcbu00o
         Ib6rI+i4e1nNjWv9N8S/Y2gDVS4OHvyHhQTcSoJZEN/0S4TuWwzoJiIzzi51Ue5QdVgU
         fcGiR8D/ns2VcTR6gGLmLJ6Sfm0p4y4+upB65SCGQzlRVtw/SF8jb4x/akJ4z3DlY6Zz
         bgaA==
X-Gm-Message-State: AC+VfDzPlKN/jZU3Sl+9/1vcPeOhBsx10MzJHdZ9OIPKPFrlwBHTPsYy
        +5C6Ao3uOcSzuRM4C++ZsSVP3bt321rgpTBjUu4=
X-Google-Smtp-Source: ACHHUZ5gYK1iJbXGADDmPFfleQx8y7pYSfWgs0DotAVsVgL9Qrl4pupzJIIXNqM8wYTZPIwsLncoDw==
X-Received: by 2002:a92:8e12:0:b0:332:fcce:c26d with SMTP id c18-20020a928e12000000b00332fccec26dmr1172117ild.0.1684525802508;
        Fri, 19 May 2023 12:50:02 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t7-20020a92c907000000b0033126f7bfb0sm29055ilp.1.2023.05.19.12.50.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 12:50:01 -0700 (PDT)
Message-ID: <a71d2685-1f2c-5f5f-d1ec-2b229f721d0f@kernel.dk>
Date:   Fri, 19 May 2023 13:50:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: maintain ordering for DEFER_TASKRUN tw list
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We use lockless lists for the local and deferred task_work, which means
that when we queue up events for processing, we ultimately process them
in reverse order to how they were received. This usually doesn't matter,
but for some cases, it does seem to make a big difference. Do the right
thing and reverse the list before processing it, so that we know it's
processed in the same order in which it was received.

This makes a rather big difference for some medium load network tests,
where consistency of performance was a bit all over the place. Here's
a case that has 4 connections each doing two sends and receives:

io_uring port=10002: rps:161.13k Bps:  1.45M idle=256ms
io_uring port=10002: rps:107.27k Bps:  0.97M idle=413ms
io_uring port=10002: rps:136.98k Bps:  1.23M idle=321ms
io_uring port=10002: rps:155.58k Bps:  1.40M idle=268ms

and after the change:

io_uring port=10002: rps:205.48k Bps:  1.85M idle=140ms user=40ms
io_uring port=10002: rps:203.57k Bps:  1.83M idle=139ms user=20ms
io_uring port=10002: rps:218.79k Bps:  1.97M idle=106ms user=30ms
io_uring port=10002: rps:217.88k Bps:  1.96M idle=110ms user=20ms
io_uring port=10002: rps:222.31k Bps:  2.00M idle=101ms user=0ms
io_uring port=10002: rps:218.74k Bps:  1.97M idle=102ms user=20ms
io_uring port=10002: rps:208.43k Bps:  1.88M idle=125ms user=40ms

using more of the time to actually process work rather than sitting
idle.

No effects have been observed at the peak end of the spectrum, where
performance is still the same even with deep batch depths (and hence
more items to sort).

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index dab09f568294..5495e7c0fa9f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1405,7 +1406,11 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 again:
-	node = io_llist_xchg(&ctx->work_llist, NULL);
+	/*
+	 * llists are in reverse order, flip it back the right way before
+	 * running the pending items.
+	 */
+	node = llist_reverse_order(io_llist_xchg(&ctx->work_llist, NULL));
 	while (node) {
 		struct llist_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,

-- 
Jens Axboe

