Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7119F5ADB1B
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 00:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbiIEWIP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 18:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbiIEWIN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 18:08:13 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0130F62A83
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 15:08:11 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n17-20020a05600c501100b003a84bf9b68bso6359011wmr.3
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 15:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=B44XeZE/tBK+AZtIykioCu8xvxmQHCUXaHy9+QhVa8w=;
        b=PHwzYHQbomSj4KQ8T8ktbK7fMoJtIDh6dNROvXTJO1tUHjmkbcbFKCqjc7RquT93Xu
         mNGgx+jqPmoPT/lyDvrXIbTJqp08U30dySfLnUVnniXfbUyFxwQN9UFEv7AUbz3u5JH5
         h1Hkf6UoGOvVCxB52JOhmkViU3jm1c9LXidpekD1+TNgkMCzrtpgvzMr8ZIUA3XOkG3x
         fLxtDmNETfiotkAqVxGTECZcRwS4SQCxdj1pai6Ef4oYdnb9Yd56nimXim57bxiE1apG
         5hpK4SG6ZjlPHL1gh0QZKe2EX16loQOUlqWRRqJPY+EemZJC0jaFP0h29cDqDNcFQNVU
         n2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=B44XeZE/tBK+AZtIykioCu8xvxmQHCUXaHy9+QhVa8w=;
        b=pQvbCjBpZ0fGp26qkdk5QNjq7cOiTrd+k8WBm+v4A39vHBNfyKIim+RlDg8vEmU4D5
         CuAf5nkxAfD94DIkxRnHNnrWveQ9rJmwjaGn+v8Dcv37KBFmHZ8Ww6dirO8nI3Uz7wHb
         MeyttdsIy/PTaRbknMx1UjKxkVhhMp4gnyGMAKflapy7JoW/W/qYXz9ugz3c57sJnHGo
         aeloqQxuOfE5HSjUJI5pfLPo4A6wm2I6WrK6WhEEofQoULs3hnwxxZe+FV75HKadZm2W
         pVPzl6Cr7tWNkyaCJQ2TdeiqeGkOhZyXDg3Y12Fr2dGrMNE8f4/Is6ybLpGm8MU0oJ6S
         kErA==
X-Gm-Message-State: ACgBeo1uJ5P4cE1NWfFKKJCtIUdHhGTtgahpvFm6aEVyScNdo1tU28Qm
        hED5xj9Q6Nv1OuQHXXxEKFauKjwKmbs=
X-Google-Smtp-Source: AA6agR7BissJqIsfb64gspolLJuKtscLAW+1KFopu4zDSqFfxB9dDu8HcBA/YzDhvvk1etFlNZ9jIw==
X-Received: by 2002:a7b:c045:0:b0:3a5:ff4e:5528 with SMTP id u5-20020a7bc045000000b003a5ff4e5528mr12366107wmc.150.1662415689939;
        Mon, 05 Sep 2022 15:08:09 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id z7-20020a05600c0a0700b003a5c1e916c8sm33791067wmp.1.2022.09.05.15.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 15:08:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 0/5] zc tests improvements
Date:   Mon,  5 Sep 2022 23:05:57 +0100
Message-Id: <cover.1662404421.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

Return accidentially disabled UDP testing, reduce runtime, and clean it up
in preparation for zc sendmsg.

v2: kill __BUF_T_MAX
    add patch 5/5

Pavel Begunkov (5):
  tests/zc: move send size calc into do_test_inet_send
  tests/zc: use io_uring for rx
  tests/zc: fix udp testing
  tests/zc: name buffer flavours
  tests/zc: skip tcp w/ addr

 test/send-zerocopy.c | 134 ++++++++++++++++++-------------------------
 1 file changed, 57 insertions(+), 77 deletions(-)

-- 
2.37.2

