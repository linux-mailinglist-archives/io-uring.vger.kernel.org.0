Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7848D54E140
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 14:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbiFPM6o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 08:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbiFPM6n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 08:58:43 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51763C4B4
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 05:58:42 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id eo8so2125263edb.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 05:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pLA7qDlmhwRat3Kh0Mcxz/vOJj63IE/VIdFB+XufJE0=;
        b=Yb/OzCheRnVPi8hjCPybly7OcZysRPCpJTdaZC92jmQDGrbNZfsnbwjIpQ7Tfe+52V
         5CcZW5SsqP5lF6i/eM4Pc+dWy+c7L+Ig0OIoj2rp4U/G4pGgK2X3ql+Tp0TaeBS2Ujys
         ztIZdT1Xc6h41YTzWAPSnlqQakH3bMta1FtxDtqP1m1f4LnCnFu+P7LWjLFWVPFsaFIx
         D+yeSSaLScw7pvbKG6qQdRM55YTQCEIhQ/1O43Oga45/Zp6l4tXHbZEgCkJyq4C7087w
         8u5CpWNEyD7sl2zr7Ltg8HWLr6cON5OBF9dATsMz5YYnus9UmG7PGE0RdRhCBknFhlgP
         X52w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pLA7qDlmhwRat3Kh0Mcxz/vOJj63IE/VIdFB+XufJE0=;
        b=Qx6b6WnoIqxhoYvFQYaV0AfKhFjyoc+nuV5w2iXcUjo0kpff4ScAqcen+8VO08VlcH
         S+0O0hTKaij0DkC/P7JSvapfDAISos/v9WNV+ksHtxkdFXSJrSwSnmUWCoDIwZVGQyF3
         tITIkGfSBoOTAiyzT3ML6MbjLUTPZN1OVK3jDE03/AgIaTr7TXuBIKzCv4p4sLDl7LHX
         U+0AzlT4hDEajDyykQ43gdSKZTk8mIQXOH3WeZmN9Dppg0UWEgYJ0bv/XMu/yO0W0ErI
         D7rUM9xa8N569M0Qkr2/72SaV5c7ZWhrT6ED+Psz85VukqE33WdzAVmxsNF0wDrrS0e9
         YLTw==
X-Gm-Message-State: AJIora/sZYr+0OVBnijuScymr3ZPLBRdJoujfJaDHg3mwy4IT+vk05RP
        2gStoR3WxLbNnk0j0cvscZZNScDBxOfyeg==
X-Google-Smtp-Source: AGRyM1u6+iFZTfGp3sWeE2uDMw+c7sDg8oWPih3u7QVhuSz0H0AKFcyqYs49TYAasgt5jEACMYXoVA==
X-Received: by 2002:a05:6402:2804:b0:431:7dde:6fb5 with SMTP id h4-20020a056402280400b004317dde6fb5mr6390925ede.379.1655384320847;
        Thu, 16 Jun 2022 05:58:40 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:139d])
        by smtp.gmail.com with ESMTPSA id j17-20020a17090623f100b00711d5baae0esm746896ejg.145.2022.06.16.05.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 05:58:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/3] io_uring trace events clean up
Date:   Thu, 16 Jun 2022 13:57:17 +0100
Message-Id: <cover.1655384063.git.asml.silence@gmail.com>
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

Make io_uring_types.h public and teach tracing how to derive
opcode, user_data, etc. from io_kiocb.

note: rebased on top of the hashing patches

Pavel Begunkov (3):
  io_uring: kill extra io_uring_types.h includes
  io_uring: make io_uring_types.h public
  io_uring: clean up tracing events

 {io_uring => include/linux}/io_uring_types.h |  28 ++++-
 include/trace/events/io_uring.h              | 118 +++++++------------
 io_uring/advise.c                            |   1 -
 io_uring/cancel.c                            |   1 -
 io_uring/epoll.c                             |   1 -
 io_uring/fdinfo.c                            |   1 -
 io_uring/filetable.c                         |   1 -
 io_uring/filetable.h                         |  11 --
 io_uring/fs.c                                |   1 -
 io_uring/io-wq.h                             |  17 +--
 io_uring/io_uring.c                          |  17 +--
 io_uring/io_uring.h                          |   4 +-
 io_uring/kbuf.c                              |   1 -
 io_uring/msg_ring.c                          |   1 -
 io_uring/net.c                               |   1 -
 io_uring/nop.c                               |   1 -
 io_uring/opdef.c                             |   1 -
 io_uring/openclose.c                         |   1 -
 io_uring/poll.c                              |   6 +-
 io_uring/refs.h                              |   2 +-
 io_uring/rsrc.c                              |   1 -
 io_uring/rw.c                                |   1 -
 io_uring/splice.c                            |   1 -
 io_uring/sqpoll.c                            |   1 -
 io_uring/statx.c                             |   1 -
 io_uring/sync.c                              |   1 -
 io_uring/tctx.c                              |   1 -
 io_uring/timeout.c                           |   4 +-
 io_uring/uring_cmd.c                         |   1 -
 io_uring/xattr.c                             |   1 -
 30 files changed, 85 insertions(+), 143 deletions(-)
 rename {io_uring => include/linux}/io_uring_types.h (96%)

-- 
2.36.1

