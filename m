Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9DC4F800A
	for <lists+io-uring@lfdr.de>; Thu,  7 Apr 2022 15:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiDGNHn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Apr 2022 09:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343636AbiDGNHm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Apr 2022 09:07:42 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADD357141
        for <io-uring@vger.kernel.org>; Thu,  7 Apr 2022 06:05:42 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id w21so7798361wra.2
        for <io-uring@vger.kernel.org>; Thu, 07 Apr 2022 06:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iqNXIvaRuiY/AcRipIoRpEC0RvDQTTfMd414mT2f1Wg=;
        b=VLBps6Dk434aJNprnZJFD/YJZ1lbAILs/njX8yEzN4DzL2NH8RtRFnHIKbQ/eikzEd
         X94DJYSXSLr+5//g/zEqHP1NX7LoMLv1nCGaPvWc1WtGcvyHLZEP/KsUI5+VLTBUU74k
         MQbggvmcqLUL0laIKGQ3pEUZutD6G5JC8t0zVDzEDnpqGhpaIsH4N3rqjdBI3jkR6c0J
         tAmwQEI0woed/6c9QRepqhFWED6h9CBHTdazQwTZVGbmA5v4Oxz87vp4vFAb5jo7OSdo
         nhDDbnKkIikG2a7DWDRz9xylH7hNsKR3b9+BpsN5MTaS0jNsFBZ9Wt8BJlWlQQredKvo
         kv9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iqNXIvaRuiY/AcRipIoRpEC0RvDQTTfMd414mT2f1Wg=;
        b=oOiZDhc+akySd9WiBShVucv6nZhDh70eGBKFkxYiTdFXcB+KwQxTxU39pvboF15ilT
         jOqkfwjDosGwZlFUlIH7r8OUMt4WSnCW5SmChxns3j0d5hEqUnD7OvMs8VpThI6IFOJw
         kgjIyVi8kxT5VKHJPrK99PDxf6YdPJuxuOdRk9uwjUJ8R1Q0GRn2HLkuA4RAX1vP1I4E
         67SfIMfqs7lqGXjJxtBbmdz5gLfBWcjlbpuHLSjz/mpcagu2l759554o711UpVS2y8HF
         7dslfuL9aNiAWRyM5HEbG63Z9zIznJmzakL7Hb7a/iSzOJIOw5gQQje4T0JZG1AlWZqA
         xetw==
X-Gm-Message-State: AOAM533Xva8Tad6CDUeyNG0lhoMSI2H6q1O94vr2OtNVWUeGnwrA1lA9
        6PybnhOi4K2osq/qpYgsg1lNhwi9bPI=
X-Google-Smtp-Source: ABdhPJySs4hiftjV+7BalWJolaATHxANLY9G+yzBmja4/ChSbIExntAGd68QKLutlJuYJpPcOkNszw==
X-Received: by 2002:adf:e18f:0:b0:204:444:dd0d with SMTP id az15-20020adfe18f000000b002040444dd0dmr10810759wrb.678.1649336740915;
        Thu, 07 Apr 2022 06:05:40 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.237.149])
        by smtp.gmail.com with ESMTPSA id v15-20020a056000144f00b002057eac999fsm17640306wrx.76.2022.04.07.06.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 06:05:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/2] two small rsrc infra patches
Date:   Thu,  7 Apr 2022 14:05:03 +0100
Message-Id: <cover.1649336342.git.asml.silence@gmail.com>
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

Small unrelated changes

Pavel Begunkov (2):
  io_uring: zero tag on rsrc removal
  io_uring: use nospec annotation for more indexes

 fs/io_uring.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

-- 
2.35.1

