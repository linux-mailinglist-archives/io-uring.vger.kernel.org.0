Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7177763B2
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 17:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjHIPas (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 11:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjHIPar (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 11:30:47 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34820E7F
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 08:30:46 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6872c60b572so1408694b3a.1
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 08:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691595045; x=1692199845;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C8thwwJ0ZrtudL4Au58CABRf+h3aioWolObvNNK5Jt8=;
        b=iA7d0RfVgOfefszjlBCAk1B+z217PbBUFuo8p6i8RzNN1ziJXA1Cv3QQRct5YpaKfP
         VHZhCIEUKyK7EZyelBAF8Vttkz2Yl7Ks3NLASNLMj1/TXLpz2esnMqM8bpUZXJX/HxV2
         gR6f/uOT0moAz0GdeUaxRuHQbra8H5buUFfeLyTs6PVseQ9fbOqcokdVCKpN5YL8KCjS
         HHVF9S7FPh7tmja821VKZ9H4/a3pCnAodZwYkK9km2E3wp7rIP9pRsezkqDHvO9iUzkG
         xSSMDiARAQhZlWBIEfZ9VE93aFFjdV+Fh9QFdISUIt42cBinvZV4WiR5Y9dMlIYwW9iz
         T46w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691595045; x=1692199845;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C8thwwJ0ZrtudL4Au58CABRf+h3aioWolObvNNK5Jt8=;
        b=C9xeY3xPUjZqnNvvbdeKUNqcc3Xv8dOqdU3wuRERelZoKqlV8u2oTRDcZxo0BKF8lI
         4GGZcXkIszTT674kgP2rqYju4/geFkEHpfgzew4iuC9lfqhOaLs3/PX2IyKHEIytjDQu
         FLROnOsfamxmWzLaqnI5hz/UAPkT3JkLNNM1bnFBGr2DH8VuaUb+t2xznw6x0GSx84HR
         vYnVOKqgdB3PMrGYNAwejSMMXQgK63To7XJT0t6zUIE866384spb47xdbqJnaCL6L4/W
         CQG7PusovtKdTqVE7UOmDT4ZFJ7Y2Dl8FkD2yiEL88WLB0jjvUWEh7i2DN9LbJrYPvW3
         sXkw==
X-Gm-Message-State: AOJu0Yw1YgYiUJAimuu+4xeEUDEy3Gdth9tYzFH80td/br0nHxfWnBBb
        BnjMMLYAvdDKuV8FR1HoF4ABBw==
X-Google-Smtp-Source: AGHT+IHqZ+A7KGG399jHjZJ20306JP3h5qkjIIUxi+g9/JPMotGOmpMIYVJSTP0TTdyojTZSRruNTg==
X-Received: by 2002:a05:6a20:8f19:b0:123:149b:a34f with SMTP id b25-20020a056a208f1900b00123149ba34fmr3793007pzk.1.1691595045428;
        Wed, 09 Aug 2023 08:30:45 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a12-20020a62bd0c000000b00686e00313easm10117028pff.157.2023.08.09.08.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 08:30:44 -0700 (PDT)
Message-ID: <8d0fcef6-605c-4f67-8fc6-01065eedf725@kernel.dk>
Date:   Wed, 9 Aug 2023 09:30:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: break iopolling on signal
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <eeba551e82cad12af30c3220125eb6cb244cc94c.1691594339.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <eeba551e82cad12af30c3220125eb6cb244cc94c.1691594339.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/23 9:20 AM, Pavel Begunkov wrote:
> Don't keep spinning iopoll with a signal set. It'll eventually return
> back, e.g. by virtue of need_resched(), but it's not a nice user
> experience.

I wonder if we shouldn't clean it up a bit while at it, the ret clearing
is kind of odd and only used in that one loop? Makes the break
conditions easier to read too, and makes it clear that we're returning
0/-error rather than zero-or-positive/-error as well.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8681bde70716..ec575f663a82 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1637,7 +1637,6 @@ static __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 {
 	unsigned int nr_events = 0;
-	int ret = 0;
 	unsigned long check_cq;
 
 	if (!io_allowed_run_tw(ctx))
@@ -1663,6 +1662,8 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		return 0;
 
 	do {
+		int ret = 0;
+
 		/*
 		 * If a submit got punted to a workqueue, we can have the
 		 * application entering polling for a command before it gets
@@ -1692,12 +1693,16 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		}
 		ret = io_do_iopoll(ctx, !min);
 		if (ret < 0)
-			break;
+			return ret;
 		nr_events += ret;
-		ret = 0;
-	} while (nr_events < min && !need_resched());
 
-	return ret;
+		if (task_sigpending(current))
+			return -EINTR;
+		if (need_resched())
+			break;
+	} while (nr_events < min);
+
+	return 0;
 }
 
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts)

-- 
Jens Axboe

