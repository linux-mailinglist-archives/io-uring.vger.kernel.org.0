Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527C05EEA66
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 02:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbiI2AE7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 20:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiI2AE6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 20:04:58 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F7E5A2E5
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 17:04:57 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id z6so22141642wrq.1
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 17:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=jOT5RDDg+r/w8LkBdp6NPzsubb0ZlOwAC3odqn7wmm4=;
        b=ene8OXQGZsmPuEhgxT0IqLr/jpEBxsM6kncRtltiHmg6wCOK7rusz+/UCNq9SQGFiq
         bvMrPM5tJoB2xF4/xooOeSq93TBlp4Z+H6AMaxRJkVH6kunJgcBLLG1PoYKCkvwOqWZN
         WaPs72vfXLw0tX+rJtDD0QIXdN5KUuTqm3tfIgC269SOUaBx3IJrSjCz89NZYkqusFgd
         ueaXSwca/Rj//TRuoZBWm7RwR+zP1Z6gtiODttT7VgHyK0MCN8QbIJOJT+SzRLY59VvM
         AOjCbwWl00vkMRqQLL2/sjOYNQdGXPf6V/i29u3huHdVzd2jEI+z521f/7Jx5rNzc5Wx
         qHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=jOT5RDDg+r/w8LkBdp6NPzsubb0ZlOwAC3odqn7wmm4=;
        b=76zl8w0DUndZvZUS9MTsqxJknkSJ0KZ8C+ntCOMXX5+yWPVkBV/Rbc6EwMyh7BHpzY
         Xyd3YTylncsMDGxqz/TumX6LXRn/UPdKWbDc0ar+1RE8jZvv0Q2pb7z40FIj0GF2vJ2O
         W+6bECth/fPVaxivoA1SJIRvJbjllX6iBVm44ycnQbRooksXByJVY9uIiyWiJzi37lRN
         E1rNwPZz8PlNgCH6QETMeS8zw4omaxgNzrop1vvZeEPOQ0Xjkea0KmG3OVt7j/YAajpA
         aVBvrQxaKborH51iy6bpD7/7fonlsQNN6vFZ2dR70Qe9mCdfbDNyIu2/+OLCRkPrRP9R
         8lrA==
X-Gm-Message-State: ACrzQf0g+lN0yGV+BCYigRo+hWvNegm7xgUj3rpdMy5UJTauFBaCi2Ai
        kPHp4A4tg1zyRGc5LSd5NwIK/4cok+U=
X-Google-Smtp-Source: AMsMyM5VLtiL4BN9DNm2NxZ0D3MgvnKlifRRSU5srxFBdyxypI6gY5Z+DbbheADzKGVoM48xFyH4+Q==
X-Received: by 2002:a5d:6d8c:0:b0:22a:e993:c37c with SMTP id l12-20020a5d6d8c000000b0022ae993c37cmr220461wrs.592.1664409895253;
        Wed, 28 Sep 2022 17:04:55 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id f14-20020a05600c4e8e00b003b47e75b401sm3284705wmq.37.2022.09.28.17.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 17:04:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/4] add more net tests
Date:   Thu, 29 Sep 2022 01:03:48 +0100
Message-Id: <cover.1664409593.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

NOT FOR THIS LIBURING RELEASE

We need more testing for send/recv. This series extends zerocopy tests
to non-zerocopy opcodes to cover 1) non-zc send() with address and
2) retrying sendmsg[zc]() with large iovecs to make sure we fixing
up fast_iov right on short send.

Pavel Begunkov (4):
  tests: improve zc cflags handling
  tests/zc: pass params in a struct
  tests: add non-zc tests in send-zerocopy.c
  tests: add tests for retries with long iovec

 test/send-zerocopy.c | 182 ++++++++++++++++++++++++++++++-------------
 1 file changed, 127 insertions(+), 55 deletions(-)

-- 
2.37.2

