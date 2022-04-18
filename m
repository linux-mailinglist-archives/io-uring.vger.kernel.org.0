Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCB9505C92
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 18:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239301AbiDRQqp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 12:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237766AbiDRQqo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 12:46:44 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6F9326E9
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 09:44:05 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id y16so8848017ilc.7
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 09:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mAzN/QGXIaCGFp+0ToFKIB05z98FAbtwDj6HI0if2Xk=;
        b=N0ICD/2RvA6v6xsc/tlxMGjUr6MxxwrtHakDeLwjXA1N8RucnRlgWZKDKdg80Q6eKL
         0Ols4Of/TPtR6J/i7Tk+OJ2kyEEUdobJGxLDGDFKI4AETRzxmF/IJL3vsINXZN0w5Bqg
         oKzf6LIqU075H2CZkrcl4T7o8J+ZnfDwARUtMPzeiNi+G3BFZ8sdkWITDHeoD1Su1mD/
         dQ1H1drKZ8onY1fypqvBFQXCV1BnD2oY91vBkUdlrFYWT/KQV3L43+4Mu6ZMJVfVHFJo
         0veokUXZnBpwci1FodQgm6v4C+Lo5fRT6ehh34IGGA0DH7mQc9vMKk6ERhKQDm5JATsL
         0C8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mAzN/QGXIaCGFp+0ToFKIB05z98FAbtwDj6HI0if2Xk=;
        b=bbBolJQhI8PZuYP1Nwhb2pTfaRksrDjFJn1UOSkhtYP0ZXXfuqyAu5yWjNlqicFBWM
         6fScnk018p8pQ17KMS8Q4snSTUoxIdURl71PtFxN0ie3k23s4SOVB2B5QiJZXEaixPco
         BVSFEPREWe7tKmmI5H5k4O/wLt4to7y9qO9p5sZ5PMLHaRv0UEuVBmPkURNg22gyQPxs
         W27G5gsWLqbmYX2N5Bj0Kml2EM+jlqzsLxcC1cyNTHVjtINCJ3nepOi6i3glB/R+zlc4
         pdLWu/Id0barMyMBYhNH4Am5j3BD4W1+cZIqrqQe/U1D38MKD3F9KTK8AGAs9oFM96sU
         QxRg==
X-Gm-Message-State: AOAM530RtSoh9kUgh46v1onnddCfvq6GIUUM0wtYOEhVnAYCJsnc3Ttx
        V9aeG9H+rZqEZXIDMLXdy2iFvLTxm3Zm/w==
X-Google-Smtp-Source: ABdhPJy/TN/4SVAIqBbYObKteiV349kPgkO1eJp2WCyaFT+/yzZUIOkt0OYLEbPW8Lehat+h8VYNgA==
X-Received: by 2002:a92:4402:0:b0:2ca:b29a:9974 with SMTP id r2-20020a924402000000b002cab29a9974mr4751716ila.155.1650300244368;
        Mon, 18 Apr 2022 09:44:04 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y19-20020a056e020f5300b002cc33e5997dsm1188926ilj.63.2022.04.18.09.44.03
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 09:44:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v4 next 0/5] Extend cancelation support
Date:   Mon, 18 Apr 2022 10:43:57 -0600
Message-Id: <20220418164402.75259-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

We currently only support looking up and canceling requests based on
the user_data of the original request. Sometimes it can be useful to
instead key off the fd used in the original request, eg if a socket
goes away.

Patch 1 is just a cleanup spotted while doing this, 2 is a prep patch,
patch 3 adds support for IORING_ASYNC_CANCEL_ALL, patch 4 adds support
for IORING_ASYNC_CANCEL_FD, and patch 5 adds support for matching
any request (useful with CANCEL_ALL).

If IORING_ASYNC_CANCEL_ALL is set, all requests matching the given
criteria are canceled. Return value is number of requests canceled,
and 0 if none were found, or any error encountered canceling requests.

If IORING_ASYNC_CANCEL_FD is set, requests matching sqe->fd are
canceled rather than matching on sqe->addr for user_data.

If IORING_ASYNC_CANCEL_ANY is set, all requests are matched vs using
the fd or user_data key.

There's some support in the below liburing branch:

https://git.kernel.dk/cgit/liburing/log/?h=cancel-fd-all

which also has various test cases.

v4:
- Minor cleanups
- Rebase on current tree
- Add IORING_ASYNC_CANCEL_ANY

-- 
Jens Axboe


