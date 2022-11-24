Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31904637FC5
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 20:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiKXTrZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 14:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKXTrY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 14:47:24 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33648A151
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 11:47:23 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id n7so3819480wrr.13
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 11:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nWuuqaxpLnqx3zceouXIURqdv8N11x8g4a7cES1rCgo=;
        b=k0pBZx+/2yyejITbNBx9OMYwUwrwU9MrykDimes5w0YIL+HvCRxDcX/N9zdwr4rFn5
         ArsiG/bI8QYIzmsaOnnev7zo4wXfse7n7q8ziT2IGedC1BlXAqoIGid9n3LZxs5owDX3
         3qDqKBeW8dzz3xnbPHhFsCAKlbRVXcMIL+s0wirmIa1RlSgl46Odi0ANut7oWmup5vV9
         kBcAqj6Vhha5hcC6MoopSuPZl78DbUcy1e7NGwk/zCaeLGxYmuSrHl5UQetPt4JWttTe
         MZhT8N6bzHXGXChkYgxO8KeX3L93U7eAmUhQPvVPGoMkVBqo1v/639FLLJBy0FErePMJ
         0HGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nWuuqaxpLnqx3zceouXIURqdv8N11x8g4a7cES1rCgo=;
        b=fjcERovFhK4AqaNeh2G7WFfkirIMEsHZK7ZOwXTpuvkjh0h3MfS4BU9PT1P3ypCIJF
         c1WdpcOMyCLwwJlOKg9mGl6wRyDFailJSRqo6mIIM3krWTS2IUvYETEdij8d2ZHaZpxY
         aAi/5v+2YyHEKG2Eb/+oJ2OPqSNNkp5poHtk+FztwHjdZZEdSMk1uZuu8TPxobwUzQwG
         M/qs1llFyUSyYhVdhGrw+IEHmnuvNwJQLeeQ/rKb6y4amso5hQ8u8QJY51q4hNxs83JI
         +9U74uucKs8cIQh9KMLqAdvj4J8+iBKoWQ4WH7oDogBaKyCiXclEbjbgsdm8igKdTmXN
         XHIw==
X-Gm-Message-State: ANoB5plzHPUrqXbvTguAbe6NnGNYZtaEwNmXjSc8vVZ0PSZ0IdKofWHP
        IcKaiBzT43Jyr/QQlPy256oj8eKuBhw=
X-Google-Smtp-Source: AA0mqf4gANzSebNj/4zOTf4LCG3NQsgHArekfqTBA9zozNz9bpIF3ETTZ9iZB8ua62tcVA0b/Qyukw==
X-Received: by 2002:a5d:4d0b:0:b0:236:c206:fd6b with SMTP id z11-20020a5d4d0b000000b00236c206fd6bmr15660191wrt.56.1669319242201;
        Thu, 24 Nov 2022 11:47:22 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.226.30.threembb.co.uk. [188.28.226.30])
        by smtp.gmail.com with ESMTPSA id fn27-20020a05600c689b00b003cf75213bb9sm6999308wmb.8.2022.11.24.11.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 11:47:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/2] random for-next io_uring patches
Date:   Thu, 24 Nov 2022 19:46:39 +0000
Message-Id: <cover.1669310258.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
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

1/2 removes two spots io_req_complete_post() in favour of the generic
infra. 2/2 inlines io_cq_unlock_post() back.

Pavel Begunkov (2):
  io_uring: don't use complete_post in kbuf
  io_uring: keep unlock_post inlined in hot path

 io_uring/io_uring.c | 11 +++++++++--
 io_uring/kbuf.c     | 14 +++++---------
 2 files changed, 14 insertions(+), 11 deletions(-)

-- 
2.38.1

