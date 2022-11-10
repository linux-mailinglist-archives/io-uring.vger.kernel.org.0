Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900B26248BF
	for <lists+io-uring@lfdr.de>; Thu, 10 Nov 2022 18:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiKJRzV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Nov 2022 12:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiKJRzU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Nov 2022 12:55:20 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9CA48758
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 09:55:19 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id q21so1834657iod.4
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 09:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sYo5yoeZZLZAxyRAHSw3El+Arm1KD5hCiTAft2EarOk=;
        b=WXUY6IOa0vE6btZHHCT5Bl64e+OK9acWf5nQgZvlOllQcmALPikz9EAI2+5kn9Heuh
         aXN9a94ySSjqWNCG2R6cm3AD5NWYO8q2XLW/wh1b0gqWJ7IKo3au+G3p3Us4jj+oBEKp
         6rVZKPRY9Cc5EYsnX3edrB10V0GhzSQgxwFTkd4VfuTYAPXg1pGV3PvNUgTn8iM26REf
         RHG7l/skMuFC+2MxcTLnB/UVGmFzpIaZhyONGaCTq4u3+swPkU8ZW04BX1qSmMGnRJ+1
         P/Wy3P4gVpWIcg159m7lUACIocyCbEG3r/6neR2iKvlu+QLR2OBcud7eQm6BXgTYNC+z
         VzmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sYo5yoeZZLZAxyRAHSw3El+Arm1KD5hCiTAft2EarOk=;
        b=4ABu8oTzy+gkmpJz18Yg/hikPPlasTqixavGk0qEfNBTRLrWE2pwDGz2FFc3hOOCbk
         TlmUmkb04PjIUCgwazas2LzwGzhiIxYDdHlu4Lv+6Oyv6S5NDUqh6Ef2xmqgabaBIeHq
         B3t/oJguHC3H6mF/PPV8BdyB0HvPlwEdFEdcyhm7qDnoLYbWGgF8y3z+Oq5Mbpxo4G9t
         y/go0RKMZPvqwDIFcXnqL0Uk8BYYZjTCk9bbPxTYcssSnMlvGfq562dYzfUcobY+85jp
         Byg0D7QUaQOMSOGNNbwbSGvYIkrSAkjlltK4U+L2qjB7GWbBk8wc/6VuurB+qeYraMiB
         +5PQ==
X-Gm-Message-State: ACrzQf0m7z2O3e6IqgIo0eA2JjdtvLNqYrW6inE/MIQtpkaNhYFRedV5
        p23i2QdB1sGSBs0QgXaXgtML+wAf+i++uw==
X-Google-Smtp-Source: AMsMyM7UJTK8NGmv7xTaS2IKKWO8fXdTivzBBYOyJ1hhUO/VEjyUhbDuFY6jPGtO28SSKH4NMzPboA==
X-Received: by 2002:a02:ca04:0:b0:375:1998:9e4f with SMTP id i4-20020a02ca04000000b0037519989e4fmr3395778jak.136.1668102918489;
        Thu, 10 Nov 2022 09:55:18 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l7-20020a056e0212e700b002f165ceb09bsm67372iln.64.2022.11.10.09.55.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 09:55:18 -0800 (PST)
Message-ID: <82171764-77aa-0f8a-a9c7-3c465ffe51a5@kernel.dk>
Date:   Thu, 10 Nov 2022 10:55:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Olivier Langlois <olivier@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: check for rollover of buffer ID when providing
 buffers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We already check if the chosen starting offset for the buffer IDs fit
within an unsigned short, as 65535 is the maximum value for a provided
buffer. But if the caller asks to add N buffers at offset M, and M + N
would exceed the size of the unsigned short, we simply add buffers with
wrapping around the ID.

This is not necessarily a bug and could in fact be a valid use case, but
it seems confusing and inconsistent with the initial check for starting
offset. Let's check for wrap consistently, and error the addition if we
do need to wrap.

Reported-by: Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
Link: https://github.com/axboe/liburing/issues/726
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 25cd724ade18..e2c46889d5fa 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -346,6 +346,8 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	tmp = READ_ONCE(sqe->off);
 	if (tmp > USHRT_MAX)
 		return -E2BIG;
+	if (tmp + p->nbufs >= USHRT_MAX)
+		return -EINVAL;
 	p->bid = tmp;
 	return 0;
 }

-- 
Jens Axboe
