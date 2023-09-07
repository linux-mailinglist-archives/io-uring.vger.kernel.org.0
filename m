Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBDA797574
	for <lists+io-uring@lfdr.de>; Thu,  7 Sep 2023 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbjIGPrS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Sep 2023 11:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344336AbjIGPc5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Sep 2023 11:32:57 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1791BE4
        for <io-uring@vger.kernel.org>; Thu,  7 Sep 2023 08:32:40 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-31aeef88a55so1005804f8f.2
        for <io-uring@vger.kernel.org>; Thu, 07 Sep 2023 08:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694100713; x=1694705513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yB8WQYYBa6q+GamlYDLj4fyPZ0QvZbGznD5zBOE0zbQ=;
        b=ajNmCsDAWhrbQJV7qmvLlXfld87cySllkXdLcolaGQKC5wr0MDSUl8PugWBkHyEfVa
         OyTn/32GtnA27fgqCgDH7deBnlZ89GQnhYRDyCPkJ4UCzlQIj8CpXhWTrBXlP2V7wtXs
         rZ28KuCOpe8BbadNWBTl73efblW72OTQ3/9YiQOFw8Y43bGbyqamColRbegCeZ91i0ub
         /oUfmxyykT9LPPuUtEpHcSvkRNupioBqwKzJ1sJ59FaTJp/GtJmFd6nu3kr+DyhYs05D
         ezG1Gyb2uWjthiG7NRe0tiI4sT74dElOMop8lW92z8hbAL7RXUJncq5hjtoMnzHEEi0z
         fZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694100713; x=1694705513;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yB8WQYYBa6q+GamlYDLj4fyPZ0QvZbGznD5zBOE0zbQ=;
        b=I4lsdIgMdMhxoeZkDxYaUQEPClHc4ywQz+TSQhlXH9Gj6eEgPhqqMoff1zv8actLmG
         IpnmIbrmgDamh/mLodFGOEsfo7nSkKzk7TC1FTRzbXaF9Am/4lWiiPgjdVCxHGR4Mws9
         rpZZcOE/7ObPtfYERanjlaFxFbwbSnmbYL//d8FeX0hpRXHP1EyCL8NYqX5G+aItwpbX
         IO+Nk69lu3ncgr0B+z0VXH8wmAlfxbTcd/kuW/oIxCd8oH+kBo3SOQiEvUFo/nApHnH7
         q3tTe0I+dxeAm/F8nJ8I7JOIt2oqPwCHhLekEhcVFerkt2F3mSMUNvJbmtU+dR4HkPFi
         SHSA==
X-Gm-Message-State: AOJu0Yx5h+3frM70rtGqE18DgBTVrbJXsbR5yYhe+UsxDxvf+GYpGmYI
        Nlm9SyXewJsNPljln0aH6cuOOwasjeI=
X-Google-Smtp-Source: AGHT+IFTsuPRrdR2OsPo28UDzHfThtAHkhPdGs8IA99a6bMoeOFJnHmwdoBvEuTGzBXHtuzWFs/XyA==
X-Received: by 2002:a05:6512:3298:b0:4fe:551:3d3c with SMTP id p24-20020a056512329800b004fe05513d3cmr4834689lfe.36.1694091033565;
        Thu, 07 Sep 2023 05:50:33 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.16])
        by smtp.gmail.com with ESMTPSA id p11-20020a056402074b00b005231e1780aasm9612279edy.91.2023.09.07.05.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 05:50:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/2] for-next fixes
Date:   Thu,  7 Sep 2023 13:50:06 +0100
Message-ID: <cover.1694054436.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Patch 1 fixes a potential iopoll/iowq live lock
Patch 2 fixes a recent problem in overflow locking

Pavel Begunkov (2):
  io_uring: break out of iowq iopoll on teardown
  io_uring: fix unprotected iopoll overflow

 io_uring/io-wq.c    | 10 ++++++++++
 io_uring/io-wq.h    |  1 +
 io_uring/io_uring.c |  6 ++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

-- 
2.41.0

