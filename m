Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2A05AF09A
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 18:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbiIFQhN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 12:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234223AbiIFQgr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 12:36:47 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A080FCD
        for <io-uring@vger.kernel.org>; Tue,  6 Sep 2022 09:13:11 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t5so15781602edc.11
        for <io-uring@vger.kernel.org>; Tue, 06 Sep 2022 09:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=SSSfv6MNgJ51RQnW/0x+twmgaSNZQMlEimt0vjErUOc=;
        b=qpumHqN7kAXfusbF4JCFDaMNHwis+ZMJjFTHnxUCzzgSDx7TDKBq0y6Z5HYNxqg6eF
         AR/EbtVwwwaEgTMcow0Kf1fqu0vG0n3Wkj80ZLIz6UkHRncBnf5jgouvfp33VA53oNFU
         aQngMlNtJQauubtroCQzHfHNnGEnX7VxKia6W5Zyku32rg+b7AHCL98GBig8KJP6nOLe
         aDLNvQW5qRGSshUgtsn/TRpr8aZzpT2vQr528yzvlCMpVhwE+5NIYrYSZJRP1IrZj5aV
         HAD37qbZPGDm0tbG8cgEiMhGI8Dmtx9rOV9kFj9JDvr5KWdA70xsrwTFkOMXPxTUWA57
         1j1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=SSSfv6MNgJ51RQnW/0x+twmgaSNZQMlEimt0vjErUOc=;
        b=MPd0y80w7Ab2e3ZWNU8Nj3u355hCC/10aqnB1TIJahkSKGWF+TD/AljM55Z+p1rwPH
         6xJCyFwtb3BTiIS2ZecrNeUoAb60CT0Ffjuzs6qIhM67RJ4SARjIbUVniaBDgryL5MB2
         0W1DNlbrVX0sFyZYW5gFfDT6liW2pcfuv8PoXwysRWLr9gcsmdfDmo0boGB5/Sd3uONL
         M4jv6U+H9ry6MrlHt7P/Tw5gLkr2U3qTM+W4mTGah5Ge1YEqzQ9seRip58fgu5MYzBnZ
         OT1Slwxao1AKPDgN0qeT4LQ9i3RcZrj97Bjy2KapKGZ7rMcaVu0whGpl1z9rPpRDVkJ7
         Nplg==
X-Gm-Message-State: ACgBeo0WnmZS0+8L+7uhTyVZZ2+X7dPbiUJ35reciKBBmFcWM3BHMJ1S
        w9gs5xVGuPLa39npuanYqfz7eqphtqk=
X-Google-Smtp-Source: AA6agR6ZtlZfASxoIvS6CmKP6ygY3ggMVhGhp3T0QVkwTyhAN8oXWoi2i3MlOKGZfBd8stqKJt789w==
X-Received: by 2002:aa7:c74c:0:b0:44e:a7b9:d5c9 with SMTP id c12-20020aa7c74c000000b0044ea7b9d5c9mr6516555eds.19.1662480789334;
        Tue, 06 Sep 2022 09:13:09 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:1bab])
        by smtp.gmail.com with ESMTPSA id kw16-20020a170907771000b007512bf1b7ecsm6556385ejc.118.2022.09.06.09.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 09:13:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/2] ring buffer fixes
Date:   Tue,  6 Sep 2022 17:11:15 +0100
Message-Id: <cover.1662480490.git.asml.silence@gmail.com>
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

Pavel Begunkov (2):
  io_uring/kbuf: fix not advancing READV kbuf ring
  io_uring: recycle kbuf recycle on tw requeue

 io_uring/io_uring.c | 1 +
 io_uring/kbuf.h     | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

-- 
2.37.2

