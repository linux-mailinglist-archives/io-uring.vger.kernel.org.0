Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59ACF55A921
	for <lists+io-uring@lfdr.de>; Sat, 25 Jun 2022 12:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbiFYKx1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jun 2022 06:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiFYKx0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jun 2022 06:53:26 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D9E17AB1
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 03:53:26 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id c130-20020a1c3588000000b0039c6fd897b4so4609126wma.4
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 03:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tnk1IDvVKP9wq2b3qzDW1MEuPXyhZ0QZHiIrPEUNr9U=;
        b=oJC+kqTmUCZIDzbdGqZ55muFo9FnKapdTL+FhwwdGvKdF+9Qq8grBYTm9lqEOBHUPT
         teb+05YyGDICGllpgpGQBbnRABXCcvWo9NFU5w6Sqse0M7kf4hDnmQHSgl95lGCzsBo+
         VMXS7k+9siYJPLNb8OO4GglCKg6GOousuJGb7deVSKBRdQe7XvAbvrwdxTPYEfH1oyRz
         GZVLQjIWgKaqoE2Q9HkKDhCzTm9fPksk4deo04jhgCyjpOOdIzeQArHLYAYqLHcTjVs8
         egu+muWNX3aYnPuHc6lPDq0UFMpy81lDXln61ngwgLl4jeRhvy4hwuAZap5ZYg9xeAO3
         bs+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tnk1IDvVKP9wq2b3qzDW1MEuPXyhZ0QZHiIrPEUNr9U=;
        b=Fp72qnTxXYwSiC+cIx59OmReqL9VnDPwU485xn8qiwJeuw3NT0jTIZPXYwjnw8wJee
         WmWXtWpmWZXLb6S/bqa1ei5zZlfbFsFlKk1B9YhnpTonbxoXA+f7SYvHuB8vrUgJ5kjF
         YMkp91korFnii8R+Nqi6FH4+B4YsRBYtdABQqVSg9BTylR1tGWW49HcQ/jMeTPCbS7wv
         K+YEG6Brwv9BLB9u9ioQKJ6z95nKUgRhMTljdL5mx/xPmplZv4hCOmZSixNTymOdGuVN
         BId80IDaHt+nv05EenpBnv1KAVO2ZT629r3Vgvs7CHXBfOybKwEySb+BXOixj8ajSMsK
         lVbg==
X-Gm-Message-State: AJIora97ZWQcnSIdFWgarO2WHVxSPqZYqGaFdpkCF9trkhXgBqnS5MWj
        fL7OlOYemQq8XO5fznlU/C1mjJA90Myzgg==
X-Google-Smtp-Source: AGRyM1vvQvTbTVkdd8l3dbsppyRZpuWZN9HxPSqXZqCFMXWjIM3jWZ+SK9NhSSd3u2bjZdiDKbjTVA==
X-Received: by 2002:a05:600c:354c:b0:39c:7e86:6ff5 with SMTP id i12-20020a05600c354c00b0039c7e866ff5mr8400041wmq.145.1656154404254;
        Sat, 25 Jun 2022 03:53:24 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id m17-20020a05600c3b1100b0039c5497deccsm15810144wms.1.2022.06.25.03.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 03:53:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/5] random 5.20 patches
Date:   Sat, 25 Jun 2022 11:52:57 +0100
Message-Id: <cover.1656153285.git.asml.silence@gmail.com>
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

Just random patches here and there. The nicest one is 5/5, which removes
ctx->refs pinning from io_uring_enter.

Pavel Begunkov (5):
  io_uring: improve io_fail_links()
  io_uring: fuse fallback_node and normal tw node
  io_uring: remove extra TIF_NOTIFY_SIGNAL check
  io_uring: don't check file ops of registered rings
  io_uring: remove ctx->refs pinning on enter

 include/linux/io_uring_types.h |  5 +----
 io_uring/io_uring.c            | 37 ++++++++++++----------------------
 io_uring/timeout.c             | 36 ++++++++++++++++++++++-----------
 3 files changed, 38 insertions(+), 40 deletions(-)

-- 
2.36.1

