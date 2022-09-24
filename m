Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C559B5E86D2
	for <lists+io-uring@lfdr.de>; Sat, 24 Sep 2022 02:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiIXAwd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 20:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiIXAwc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 20:52:32 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10EBE5FAA
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 17:52:21 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d10so487557pfh.6
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 17:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=y+IcgH14o73eM57fBEzKSiy+oDmRbIU9mDc++IWI79I=;
        b=dxX+V/QiJoNQMjAO59xdHYRHJ+3s/49BwYFi6uwVzuky1gPcRqrTWICd5fDjlFwJDL
         plBSgHLdq+fATDdp3/BjVZfMpjwbBaAYh/R2JfJtQ71KIGou7VacrnS0u8AR0wGobWdy
         7TMiLmVvjYJJqrakNXj+xz1rPg1UaQxi0yr5weUllleFFGNtYZLX4buvgDEVhtOK+EtY
         k+erZ4u11a1cGZ642Qo5BzRrKddvofTAI+3roJw7BapmgaZMfsS4y11VxIZ0cT0NWOBB
         CeZIOJLdpz0TpOP6sb6AePNkvP5Y8dPRmDZcbmaESPOAiXD2Y3bZJhzNLw/ctiALgjvt
         bICQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=y+IcgH14o73eM57fBEzKSiy+oDmRbIU9mDc++IWI79I=;
        b=QY4KBUOO8g4fNFyuqd/7fVXFGNFfTpua7nPD4jATPC2hBaraea4KghtEgOedJJEm4y
         dWrM3Z7hYhD6DQ7i1ljJ0m8RgZLoVJhTj4yAIUTJCPmPraDJkKpdymO3uPEx7yVpqMZL
         zstYVSzxRl9+R0hgnDvMSZCC9ToFsJ7lSYbtFVRrU6w8Fodcr7xoCNUMv++pT9KzCgxQ
         sTX55BJylsgLx57QLeTRhY2ZXJBBSVmnbH7UXhTSYlxKM4vV8uBhXDQYjGPVaQo3fcFv
         JswIcqYp5pCJ5qoCJBhYoT/P0dDvl/jUDjzuWGFFGoQ9uD2s80wkEA8Uv4IWc1wf+mrY
         NMSQ==
X-Gm-Message-State: ACrzQf3M4uVx0dP4Hmy6OL93QG1g3BPzvKTCx99VfgB61TEA5zmEQW0O
        UIQzXB0yAw1FL5Lqp+XjjSoe/p1R1v/LXw==
X-Google-Smtp-Source: AMsMyM4AtH4ssDVvO1vT5M+554e9+jrr74LeLR3yG3CA65oJHlmV3RqZV5ketIUr1dhwzRtdPd8t4Q==
X-Received: by 2002:a05:6a00:1a94:b0:548:8ce8:db93 with SMTP id e20-20020a056a001a9400b005488ce8db93mr11899377pfv.13.1663980741016;
        Fri, 23 Sep 2022 17:52:21 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s1-20020a170902b18100b00176ad86b213sm6473571plr.259.2022.09.23.17.52.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 17:52:20 -0700 (PDT)
Message-ID: <f12cebe7-37ef-f322-9ee1-0c2aaa8d60e5@kernel.dk>
Date:   Fri, 23 Sep 2022 18:52:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure that cached task references are always put
 on exit
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NO_DNS_FOR_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        T_SPF_TEMPERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring caches task references to avoid doing atomics for each of them
per request. If a request is put from the same task that allocated it,
then we can maintain a per-ctx cache of them. This obviously relies
on io_uring always pruning caches in a reliable way, and there's
currently a case off io_uring fd release where we can miss that.

One example is a ring setup with IOPOLL, which relies on the task
polling for completions, which will free them. However, if such a task
submits a request and then exits or closes the ring without reaping
the completion, then ring release will reap and put. If release happens
from that very same task, the completed request task refs will get
put back into the cache pool. This is problematic, as we're now beyond
the point of pruning caches.

Manually drop these caches after doing an IOPOLL reap. This releases
references from the current task, which is enough. If another task
happens to be doing the release, then the caching will not be
triggered and there's no issue.

Cc: stable@vger.kernel.org
Fixes: e98e49b2bbf7 ("io_uring: extend task put optimisations")
Reported-by: Homin Rhee <hominlab@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b9640ad5069f..2965b354efc8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2648,6 +2648,9 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_kill_timeouts(ctx, NULL, true);
 		/* if we failed setting up the ctx, we might not have any rings */
 		io_iopoll_try_reap_events(ctx);
+		/* drop cached put refs after potentially doing completions */
+		if (current->io_uring)
+			io_uring_drop_tctx_refs(current);
 	}
 
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);

-- 
Jens Axboe
