Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA7E6E655D
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 15:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjDRNHV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 09:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjDRNHU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 09:07:20 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3524512C
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:10 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id xi5so72986564ejb.13
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681823228; x=1684415228;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n9Rk4CeuJ+WYMgkp8vaq9Y5Rxi/C11QkiK5frzQ+CRo=;
        b=U/M3gUjOoyrYY4VhrZ6oV2lmsgimLiy6cGlfXp+Kenl/MZwzxFkiVljFb4mqhAKucP
         zDiCeOqpGSl/eTaE/mrTxPqef5onmHwRINgw8aL1Gszcbp7EeHYuP1ysyIf0pJm2vCdu
         3uO+iknxW78NEemnDyLc0cqnzoy3hOUOjQSt7Xu0PATxAMyzL7Du2/zY/lK+xePWqVpC
         dg9m/YmkEfz9yece0j2vBJtVlOjZJRCndRGdslbksiq3U7zb1cE0RaNpbecI2ZoAJj3D
         wzDMYGwSt441gPGZY/0MlA1vK8PbKUWXOlrM4lfQlo5fqapeOGX7i8qXKFT9KgpavIu4
         VTSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681823228; x=1684415228;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n9Rk4CeuJ+WYMgkp8vaq9Y5Rxi/C11QkiK5frzQ+CRo=;
        b=YSH13yO4IhlOZwGTaaqd6fmIt2WtHJBbGop7bH4NNKAGSQQbXv/0j9vLSj3reJEgk5
         v6XVJ9Cdi4mJpG5biVVW1zAFnK6hQgBWdudEeTFx5LXkcQXAXey4bM26Wf5xfTsU4Qa0
         3GWXnf6IoYBulob7W1ABAbHcndmZpbcoGuIFsSKLed5L1Sk9QNmZptNr2xIfB2HYYVhD
         exhSez3LO+ccV4wJ6REDcjoXJtFfpmnbq7lUZMwFmZ6irS4A0W5krSCaIzYNCYVXErdj
         NJMSZTFv65fTUkObDJ4OuhE36l23aPaDsC8/LEYP1qfcqlPcCjjy3jDgM5AXIcRMJZ8n
         aA4Q==
X-Gm-Message-State: AAQBX9cKdEwGGuRad4oOqvVdyyvuyxh9znYe5mEp4qw1uA+w024xKkYT
        hkVi1A7BaVBtAeIhoe7XJqVuLxYzv1k=
X-Google-Smtp-Source: AKy350Zz7F4HDauHJnaMVdTvd4+JxiSC4FNupdF4Xqp24T3GrTVwu395K8CPvILS1UsxQChG/y3TSA==
X-Received: by 2002:a17:906:eda9:b0:94f:3074:14fe with SMTP id sa9-20020a170906eda900b0094f307414femr9788113ejb.17.1681823228453;
        Tue, 18 Apr 2023 06:07:08 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:cfa6])
        by smtp.gmail.com with ESMTPSA id o26-20020a1709061d5a00b0094e44899367sm7924919ejh.101.2023.04.18.06.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 06:07:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/8] another round of rsrc refactoring
Date:   Tue, 18 Apr 2023 14:06:33 +0100
Message-Id: <cover.1681822823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
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

Further simplify rsrc infrastructure, and make it a little bit
faster.

The main part is Patch 3, which establishes 1:1 relation between
struct io_rsrc_put and nodes, which removes io_rsrc_node_switch() /
io_rsrc_node_switch_start() and all the additional complexity with
pre allocations. Note, it doesn't change any guarantees as
io_queue_rsrc_removal() was doing allocations anyway and could
always fail.

Pavel Begunkov (8):
  io_uring/rsrc: remove unused io_rsrc_node::llist
  io_uring/rsrc: infer node from ctx on io_queue_rsrc_removal
  io_uring/rsrc: merge nodes and io_rsrc_put
  io_uring/rsrc: add empty flag in rsrc_node
  io_uring/rsrc: inline io_rsrc_put_work()
  io_uring/rsrc: pass node to io_rsrc_put_work()
  io_uring/rsrc: devirtualise rsrc put callbacks
  io_uring/rsrc: disassociate nodes and rsrc_data

 io_uring/filetable.c |  14 +----
 io_uring/rsrc.c      | 146 ++++++++++++++++---------------------------
 io_uring/rsrc.h      |  32 ++--------
 3 files changed, 61 insertions(+), 131 deletions(-)

-- 
2.40.0

