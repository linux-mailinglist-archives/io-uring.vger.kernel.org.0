Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7945576AF
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 11:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiFWJfI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 05:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiFWJfH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 05:35:07 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B8649257
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 02:35:06 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n1so26823414wrg.12
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 02:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Nk4JmctkP/uGyVG90r+4nFY81ew+kSHsMPO3rfOe6A=;
        b=q5Vi189c8UtdTr2pMzI7/W2zxBUvuJHys0Ay/+GPTEZQKy+btrXDRHD5f0lDpuIiuv
         TusCUAtV/mKOkrTz1qp19r+yGjsOE+Q3qFdkip1Tuz+tpR282J3EQ40jLzZIfqCWeOy2
         Mt5TLRQEnDkIE2O6nJ816D16xyVy51tS9DmDxK//ty1BfB1X+FsqGb5pXOj+Roy3diSo
         cyp74snBBpVhWqLeFAzvrgpeX9er1q/5DfpD49uzcpXEPAPv+XaGmUu+WOPz+eOpr+5J
         VHPQrJUP6tBldUdg1AlCHBegaZ7unSGRdOFLcrFVSW2mmVP2xoAxcFrpch1okrulK0x0
         sjLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Nk4JmctkP/uGyVG90r+4nFY81ew+kSHsMPO3rfOe6A=;
        b=CVyFIataZRYM6GOd7/2eFnCGK9mr0tElC6i4yzNhBBEacsb33lhBt9nJRNA74qduF4
         5YEaDpAr7AwGUy9wYiJf9SfnXTjya7XnbAMXJE235HRdDT+YtV4/f0Vl3b8sisCDFbiG
         p8eVh7CqwgqdNE+oSd/JMlxVN2Xf5lZpKTO0V6EyLr8yp3atbqV2/V6AFIXrvbrDvNjq
         J4Vd0y1VzoFmNc58WBbNc+z/USsFw5rM9TiSaHV3nn+VJA0wW+aa2uGiVFBfxWGoM3qb
         f9eCp6n4eRfC6tyezrJfXFHA6OKzFr0q2nnTr6QWyyogpmxiCpzgqSsejet5iAId5RkX
         4Ayw==
X-Gm-Message-State: AJIora97st2ZrMYt+3pKjKB6wbRaNNX/ZYMarKVuWD3s+s/S3r5xosyZ
        PhE8cbQ6DJwDLxsi23pp9w9NNiiP+mAsY8ts
X-Google-Smtp-Source: AGRyM1tRAwrrIisqHzeXqPATYfGGx6kv8J2aNtzYcuoRRvMqPrsBgkXkCh5kgmUKFBcf0wI6XBbuLw==
X-Received: by 2002:a5d:598e:0:b0:218:531a:eb5 with SMTP id n14-20020a5d598e000000b00218531a0eb5mr7201400wri.334.1655976904584;
        Thu, 23 Jun 2022 02:35:04 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm2431202wmq.26.2022.06.23.02.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 02:35:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/6] poll cleanups and optimisations
Date:   Thu, 23 Jun 2022 10:34:29 +0100
Message-Id: <cover.1655976119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-5 are clean ups, can be considered separately.

6 optimises the final atomic_dec() in __io_arm_poll_handler(). Jens
measured almost the same patch imrpoving some of the tests (netbench?)
by ~1-1.5%.

Pavel Begunkov (6):
  io_uring: clean poll ->private flagging
  io_uring: remove events caching atavisms
  io_uring: add a helper for apoll alloc
  io_uring: change arm poll return values
  io_uring: refactor poll arm error handling
  io_uring: optimise submission side poll_refs

 io_uring/poll.c | 213 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 142 insertions(+), 71 deletions(-)

-- 
2.36.1

