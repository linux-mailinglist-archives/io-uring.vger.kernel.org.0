Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5CF4F6280
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 17:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbiDFPDk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 11:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbiDFPCE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 11:02:04 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17EB440995
        for <io-uring@vger.kernel.org>; Wed,  6 Apr 2022 04:46:32 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id qh7so3632689ejb.11
        for <io-uring@vger.kernel.org>; Wed, 06 Apr 2022 04:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7EnWsYh+GG5QtxkKN99iIFPvX/U3/6Glev7OQSQj/rs=;
        b=CcM8Bpg5wQAWXICPR6hGhag5R9m6GUt7VKgANQkRZ2r/WCXDamiUkP5JbmSTqU4bvF
         8YD5XddJVeuixr2YW2PjT8Pcj6/7dYvGwWYQzjDlMbghYyGwZn2rItJqEGG4N7B0YLb8
         r6mpBGz9Hp6O/06xgZXTXAN0sGqlImEeTRfRQby7IcrJZwz1eWNmj1kNvxUQ3V+o78VC
         3oEOh1/9PHgKlPL//cmXXZ4llzbw6NZI3QgJGGoQUEOW00WGylS36EaqT6fGpz8pNCp6
         Jm/wVW0bkKexnDvR3Fx7vDAVyl/2kzmwfw+3V7eDFdsgRaM756GNOPYtfqsCf6I7dtEb
         gOAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7EnWsYh+GG5QtxkKN99iIFPvX/U3/6Glev7OQSQj/rs=;
        b=Kyx3zhBFG0OQKVwM9pCqt4Usm4NzPEFEQR2Zwh7aFQ1bsSrPT7IckAZN465Q6wGc9S
         q7CHMw+ege1GS7joleIDiy1zTgEfeO5s9JRIfUTIDOpSAZzGuSk/UDzFqnKfKHxSJkfz
         mSkxRuhRaHnrPJu9vGfdmDCh3RSHqpsyWrQKygA0xb9b0Wldwqxd7D6wGWc0+rnI9iHy
         67r+TRd/qfix+sXe0HWYzBlvQQjU03DwsEX1qVkJo9MOvwjbHKM3pYJQWkL7inUE0+C9
         +8MgyhX2B5lpYFJGuvCKJ96pAFo2+QWkhtg7nviLv2yxDUWTV5LGuIGLVfsTz75H60Xl
         5E7w==
X-Gm-Message-State: AOAM531rKFJ6AB+rJIthBZNUP+JBGFAoWM0ogAnSnQlnKkbExTkK/ZBk
        osZYxof1/MZjGqV/EFb91NIvtVuI4R8=
X-Google-Smtp-Source: ABdhPJxEbR9r4Onsj/FRCnOKShAdRyaO+0B8YqOaywjeoNf5utl/U++97fvmN3MHFtJz+CRErze6DA==
X-Received: by 2002:a17:907:9718:b0:6e0:6faa:3aa with SMTP id jg24-20020a170907971800b006e06faa03aamr7970701ejc.307.1649245529873;
        Wed, 06 Apr 2022 04:45:29 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.65])
        by smtp.gmail.com with ESMTPSA id g16-20020a170906521000b006d58773e992sm6506022ejm.188.2022.04.06.04.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 04:45:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/2] io_uring resource handling fixes
Date:   Wed,  6 Apr 2022 12:43:56 +0100
Message-Id: <cover.1649245017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Two small fixes for rsrc infrastructure

Pavel Begunkov (2):
  io_uring: nospec index for tags on files update
  io_uring: don't touch scm_fp_list after queueing skb

 fs/io_uring.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

-- 
2.35.1

