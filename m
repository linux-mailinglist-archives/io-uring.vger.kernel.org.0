Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E094F504754
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 11:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbiDQJMg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 05:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbiDQJMf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 05:12:35 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F7B289A8
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 02:10:01 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id k23so22333721ejd.3
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 02:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OkrK1iGGMYtWYSgWSpmb0uwjYYM7EruHuF3jXHYdY8Y=;
        b=kNb3kQCrtomHBUhAj56j2DZ+VKjQmkMh4FL0/6JOGbyqaY5XrQQ5qLzK3t/hf2T83i
         K5z1sgmUWidD8hN3SiXTrYUXOWYclQMJokWG0UaZIhmRGdn7Q9fx62brLw3DZCY41z/+
         lVLYEhsdRC1PcJejHW/0o5t2u+HOWdrZfHX9oE7l5Go9nvSpfUcNyyv++f8qbwg3BsMo
         D9Vnd5xsW0JB0OEAhQa062Y1dRJ6Uhff+XX7hmNqIG/z9CBySs0JxtkoWSqELjeSuJzm
         X5ymSBnVf/ZYfJsmylemBl0vHt/1uKq4ybQjnVK5nWu9SbsKuYUVPVmNzgWv7SChKodZ
         UnlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OkrK1iGGMYtWYSgWSpmb0uwjYYM7EruHuF3jXHYdY8Y=;
        b=BE1ULlmPlcNfZ70py+pWSsKz6rTJp6M4ih5j0PbE/HVTo6SqbDZKeujC8xpF6ed7oJ
         eCFkijshtHVWn1yauOWEDUgJZc8yoGPTmD/TYbj2xnAA2fHqd4ONVBpf4eAF99PP+BTk
         rRVXE4tpNUaRhrOkED+F3+WErYQocAj6w9mJDX564NjVbuB90C9jYADuRuSBaneAnpSN
         csA4menYkGvtUL1p9O2oEuweWpuJcF9ln8R+jOJVWBSRkAK1TP4H7wiaxmAbS1vWLB/p
         WN0uTvRE3S1Ddavi1LfolC2aLIjx+w+v1UYh/CL7EgkOve6L328rOJ4Td8gTJZNUB0AC
         juog==
X-Gm-Message-State: AOAM530F0epnbstmhYa8aGaSYjOHobZNDgUYUY0tJuQ4kVTcEzKtVx1z
        AYiNYQAL1syNueiyFZZIPbqMJ3fZn90=
X-Google-Smtp-Source: ABdhPJxvTMEMLlVYm1gRTiCuYvrDl33D+FjMJAmkAYrabDgoZOAhaU/Fgc5mkYYMJjMr4fgFGIBU4A==
X-Received: by 2002:a17:906:7684:b0:6e8:5d05:196b with SMTP id o4-20020a170906768400b006e85d05196bmr5286940ejm.209.1650186599423;
        Sun, 17 Apr 2022 02:09:59 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id bw3-20020a170906c1c300b006e88cdfbc32sm3423746ejb.45.2022.04.17.02.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 02:09:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/3] extra tests
Date:   Sun, 17 Apr 2022 10:09:22 +0100
Message-Id: <cover.1650186365.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
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

2 and 3 add extra tests that were useful during the SCM patching and
rsrc refactoring. 1/3 tames the multicqe_drain's execution time.

Pavel Begunkov (3):
  tests: reduce multicqe_drain waiting time
  tests: extend scm cycle breaking tests
  tests: add more file registration tests

 test/file-register.c   | 95 ++++++++++++++++++++++++++++++++++++++++++
 test/multicqes_drain.c |  4 +-
 test/ring-leak.c       | 84 +++++++++++++++++++++++++++++++++++++
 3 files changed, 181 insertions(+), 2 deletions(-)

-- 
2.35.2

