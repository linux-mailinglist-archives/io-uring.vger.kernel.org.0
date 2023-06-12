Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CC772CD94
	for <lists+io-uring@lfdr.de>; Mon, 12 Jun 2023 20:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbjFLSMM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jun 2023 14:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236949AbjFLSML (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jun 2023 14:12:11 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC32610FE
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 11:12:04 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-77ad566f7fbso45603739f.1
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 11:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686593523; x=1689185523;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ArfEG/zwX+Qu50yqWsLLeIAObXJ440FdnIJFkcDTwak=;
        b=MLP11eaKUEnWnr3tT1G+bXrAxvIdMysvDLDleTr5mkuPZ36uaDGL2Je1SVO4kE04V3
         soI6QyDs6AeFA3069KRUJLtHcH2vjFA6dUvVAsChzuEhgInftIf5lu2bg8EepdHvJjKA
         Om6d0ekCWiPoud0ZKBplUDnOtgoBYHDfR0zB5FFYL95yaHDuCJEn9C3LuVUudjuheDp/
         sJLBRsIED9B5UNHCMsKzPlZi9uZ/b/YrNFLea5gAsJWnda61ZV5DkQyQ4ub1btYKGT4u
         yx9GI8Ps0gzwM7IporZ1U+utTG6kQDy8VsyaFxbLSUZyWR/VpaNTHzcjNvX3kfXb/zHJ
         P7oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686593523; x=1689185523;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ArfEG/zwX+Qu50yqWsLLeIAObXJ440FdnIJFkcDTwak=;
        b=dcrdJ99htW4whW0C7CSaKMhT/auBsWLSgFiqpMDU791RFpKQQhOsA+y8H6B2ddVYU2
         6C2mxkulIeDUTI04VqE49gkhGEJRXIjObfXzoIFY43y4n6u31uJfeir/y0DaHXDPXdZe
         eL2/a5B8TVasvO3MdQcxmh3X1HSR+g0VRFRN0xv9c/2eqYRXknMtzPPlN2lUbmkTV1e2
         8OJd7FdYr5N1zKPxgolnd49UlfzVaaDu0PbABVtlQ7ZKMG5pzH7cMsa9ABt0Ap7T+sMY
         9vgCbp5DFZTvWrYDNVQ3nT5BRaHWPmHzB+cUEcF4r1ve8Rj1dUWJU4rxRhPQ+F3toweZ
         laFw==
X-Gm-Message-State: AC+VfDytYV0qycCMnsGXMftUcsY45xX4baUWwTgCbGFdwB7XhK/Vxrxu
        KN2D4SdC0gU0ENFwg9G3vXwnXII1rtZownjwoBw=
X-Google-Smtp-Source: ACHHUZ6ynp4ZRI2CJT+g4J7cX44RSKygn3bUSTJEdhwij4+cpgkRDSrDA9Oya0lzjLcgBwQ0SgVx3g==
X-Received: by 2002:a6b:5810:0:b0:777:b7c8:ad32 with SMTP id m16-20020a6b5810000000b00777b7c8ad32mr6714667iob.0.1686593523175;
        Mon, 12 Jun 2023 11:12:03 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z3-20020a5ec903000000b0077ac811b20dsm3352116iol.38.2023.06.12.11.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 11:11:58 -0700 (PDT)
Message-ID: <2392dcb4-71f4-1109-614b-4e2083c0941e@kernel.dk>
Date:   Mon, 12 Jun 2023 12:11:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Zorro Lang <zlang@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/io-wq: don't clear PF_IO_WORKER on exit
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

A recent commit gated the core dumping task exit logic on current->flags
remaining consistent in terms of PF_{IO,USER}_WORKER at task exit time.
This exposed a problem with the io-wq handling of that, which explicitly
clears PF_IO_WORKER before calling do_exit().

The reasons for this manual clear of PF_IO_WORKER is historical, where
io-wq used to potentially trigger a sleep on exit. As the io-wq thread
is exiting, it should not participate any further accounting. But these
days we don't need to rely on current->flags anymore, so we can safely
remove the PF_IO_WORKER clearing.

Reported-by: Zorro Lang <zlang@redhat.com>
Reported-by: Dave Chinner <david@fromorbit.com>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/all/ZIZSPyzReZkGBEFy@dread.disaster.area/
Fixes: f9010dbdce91 ("fork, vhost: Use CLONE_THREAD to fix freezer/ps regression")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index b2715988791e..fe38eb0cbc82 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -221,9 +221,6 @@ static void io_worker_exit(struct io_worker *worker)
 	raw_spin_unlock(&wq->lock);
 	io_wq_dec_running(worker);
 	worker->flags = 0;
-	preempt_disable();
-	current->flags &= ~PF_IO_WORKER;
-	preempt_enable();
 
 	kfree_rcu(worker, rcu);
 	io_worker_ref_put(wq);

-- 
Jens Axboe

