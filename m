Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E6C25EB0D
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 23:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgIEVrw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 17:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIEVrw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 17:47:52 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C476C061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 14:47:49 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id n13so9195441edo.10
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 14:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mXUpJtR+hl53y1ZSAQWN5NQfdfZOQizaScD86oS6//U=;
        b=Pi5AerRVn07OuVnhfthxrgDvj6OqZDSjw0YJInboc1d7d5I8d7pZDTuMx3/w2zgthj
         2/TaiyZYYq09nvfPHNHU/7WgiTfy736c6w9T5wsQ0nztHg27+Mi5CxC6tdafLaYOWUYJ
         ng6NxqIvBErES4IHaYisaROsWEC8aiC6b7d+Ymnr5QkAstunssQFHD6tr7TmIiouATfg
         6iXMajipFeQXLvyFzgprp2Ennc4oOI+C3SaAV6Io+01kbATVAYndOWiv4dFgMbqsXLQy
         +PsQU2OQP35lcgFlXzbKfsMIxIH+puBGFfp88S9Z2Xi5UyTbFbqarzyzUV+FloEMmD5B
         xKDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mXUpJtR+hl53y1ZSAQWN5NQfdfZOQizaScD86oS6//U=;
        b=icKqhQPjhz+VjlLQ50U6DFAIEpJ9/4wJJQuBjftY6JDcVcEXjh8JSesiRiW+311idi
         lQ+yFi9rrkEsKVc9STqr1acdHpNSdjkZQI8eOrh0u9XPi9kZ40JMESKTrxyEgfoO1LzN
         5yXhhWGJgf6iVoAKTm3ASSrN3/ZV8oGKlYzOtSDjqz5QT5TwQlJ1ZQc4a8vd1ZqI0xb1
         RoHBS4xFt2uyGIP41m0W5gRMf2bepUjPu6YhRMoGyZWGjVBqm9l4hisTogP+t9AkZSRm
         X1tLt8g+fiVKPpZpU4VZ7TF5aEwmriYTH30SEDnUiufHLRL77APXXc6+S13CAOG7Z6l+
         jVHg==
X-Gm-Message-State: AOAM532lmS/UIEbE5ZYiBcg+2aA/06UgZ+i0wD79dqDEOgOb3IjjsknU
        WXguSiUI0O5Ci39tqpixHt0Os1QIupc=
X-Google-Smtp-Source: ABdhPJzu3MON+VjzN2ZoHJvVoRV+ePplv1x1WtOzE5qeOXMQYJZfRzW6BrBMLP414yKv+ygYU4MQyw==
X-Received: by 2002:a50:f1d1:: with SMTP id y17mr13063039edl.231.1599342464845;
        Sat, 05 Sep 2020 14:47:44 -0700 (PDT)
Received: from localhost.localdomain ([5.100.192.56])
        by smtp.gmail.com with ESMTPSA id c5sm2399121ejk.37.2020.09.05.14.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 14:47:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-5.9 0/2] fix deferred ->files cancel
Date:   Sun,  6 Sep 2020 00:45:13 +0300
Message-Id: <cover.1599340635.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_cancel_files() may hangs because it can't find requests with
 ->files in defer_list.

Pavel Begunkov (2):
  io_uring: fix cancel of deferred reqs with ->files
  io_uring: fix linked deferred ->files cancellation

 fs/io_uring.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

-- 
2.24.0

