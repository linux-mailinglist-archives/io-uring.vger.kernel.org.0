Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF0E57FCBC
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 11:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbiGYJxd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 05:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbiGYJxa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 05:53:30 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3859F17056
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 02:53:28 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id k11so14720826wrx.5
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 02:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e6GmZAEY3//P+P8nZMwuToWOP7eLJHCmtWaq9pycqJY=;
        b=B0zQtNYuFMQ80U5yFhqp/1p/hv17r5TJF7WVbvgE7wQlGhryuM8DZQrU4nQ2f4wfDt
         zEGNTCVChXbfQBSk20nkfF/ADSH+TXZMDuod517wO2HMS1vN0EbSSpgP1otJ3if9FSkt
         Epn9Fqz8SHanH0Xz3jDcAGotOHTXGq+ctIs2sMjtEUfBlDstpYmDf1PSTY0g7n6o80hk
         NTvMKV92JxpoEPGGgD25p16R6LoG9LtThfYQkGRHXL4+C9i4yusTUV7w+xSXtVQpHHMm
         lETGXNykDw6THi12HxyHOmIqybZmPNmdeW9G6tOFoWzbl/rnaLB5nJ15HViMVUfQ+nyj
         vT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e6GmZAEY3//P+P8nZMwuToWOP7eLJHCmtWaq9pycqJY=;
        b=eE8XeTB+MZ5wGaxXIvPn3LobRURBf5w5DkZfOaOUIcUD0NK4osDYO9/HE5gjlFDUco
         HORoY6ZU/0mgZKqYkIXK6kyOVO3gjNtpt8F+VkFU6omr3pLQLZY8WGO6UPnyFM3vA1/t
         P7UrKfOuhBqk7uLbFIyNfR3dQLHzq4ZtEKerUblEmbor6I8aU6RSe5AjWSZc9ImjLfHm
         12OZ1/L+y75mhNB9d8/dH+tG4dxsw5xjJ/3j34EfAh0o2IzuC+NEEFMI8fJpTFiYD3Da
         erjcR77FlJVGVCP0IOt/bWmGBPTCSGGXGqQf6Cj0R2pMbHccPbnjz81M1CbLNON+pbdm
         FSyw==
X-Gm-Message-State: AJIora+/aFdAoVeCad++h5PyOCVwngya05K8TkHDjNRyWHgg59uPMIsk
        wCXGh+hUpsb4hcUfUGsbUujek+8aPXJJdA==
X-Google-Smtp-Source: AGRyM1sk1DBkL4F/AUzwyEsIV50V0ecV6bIl88EfCby6NUcihAE6mCCGtTByd4VsbysU/RqsPcWEJQ==
X-Received: by 2002:a5d:64c1:0:b0:21d:ac34:d086 with SMTP id f1-20020a5d64c1000000b0021dac34d086mr7038182wri.319.1658742806388;
        Mon, 25 Jul 2022 02:53:26 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:1720])
        by smtp.gmail.com with ESMTPSA id n12-20020a05600c3b8c00b003a2ed2a40e4sm18909636wms.17.2022.07.25.02.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 02:53:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/4] io_uring/zc fix and improvements
Date:   Mon, 25 Jul 2022 10:52:02 +0100
Message-Id: <cover.1658742118.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It mainly fixes net/zc memory accounting error handling and then makes
it more consistent with registered buffers mem accounting.

Pavel Begunkov (4):
  io_uring/net: improve io_get_notif_slot types
  io_uring/net: checks errors of zc mem accounting
  io_uring/net: make page accounting more consistent
  io_uring/net: use unsigned for flags

 io_uring/net.c   |  8 +++++---
 io_uring/notif.c |  9 ++++-----
 io_uring/notif.h | 21 ++++++++++++++++++++-
 io_uring/rsrc.c  | 12 ++++--------
 io_uring/rsrc.h  |  9 +++++++++
 5 files changed, 42 insertions(+), 17 deletions(-)

-- 
2.37.0

