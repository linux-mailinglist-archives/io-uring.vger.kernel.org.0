Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1471269D7DC
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 02:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbjBUBHF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 20:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBUBHE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 20:07:04 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449C0212AF
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:02 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o4-20020a05600c4fc400b003e1f5f2a29cso2340071wmq.4
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IXMIUxTggbogi3NVSQqkW9SWj3hnOHyL+10HvGQfZgQ=;
        b=GISWzpLCHl81n+gH2BSD0XhKyrO0hWgDoRXfDo5caQtn8wMauw59MN6yll0aCEw5ug
         +BOe4imQzioHZlla/mUxAebis1M4ro4lsaVyPHzqTlAuHiffNIPRaKdOolH8MAwaFj7K
         VAHNyphijCySWJ+xW4NFfb5adodLLw6Ujwfx0wFZmnmT3IKRAPqVL5AaKPFVkDLn1S5/
         pD1fEmoUVoVlPiihtgHo77ek9MJlnzNBWr9nstlDfH7kUfJfnDv+YHn+1VOXeUgGKp3t
         MbtODvHi1k089+yaDDaFOxoJhSb3MDWfNeYTrOhzmZ/t1BLbhpU2s9WT6It9V56IXDvm
         zPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IXMIUxTggbogi3NVSQqkW9SWj3hnOHyL+10HvGQfZgQ=;
        b=Px639FXoPjtN2XKh40AN6DZLLZ51eYv5aTM6CdzrXa3poKPkVQHjLpIW5p0E7FFMu4
         JLndev8Rv7Y5yqAHi91UksAkjkI3Vnz89DNtO7/XErNqs9d/CdAdCoJywJft6E6y1FcO
         i1ZoCQpCUmspriMfCPwPaAPvSwY36MmdeSYIYULTNjs1qcUwMDpKpbWQduDZAQXOCuq3
         9Ncw+9EgeWtn+lze/lirJGL5DnWV5uoCFxbp7wD7VRPJD9cJFvKkHG+2DteBt4Kybzxn
         hqNNxKlRyMzocWgcOOUoPu8AhBvYztqxYIAwa7UxoUze4XTlRpk/b3vyY+g6P+JZAibX
         pcdg==
X-Gm-Message-State: AO0yUKUWdaCFB3LFVT/CESPyYMkc71ZfADjCdvHvWjHm4tgyZoBSfBTj
        Dzrs3Q0+RYCxQEOZdV8/XDOYuhgdIAU=
X-Google-Smtp-Source: AK7set/C2FTWEDRBTTXdjqlR3XZ/JlgfkabDLT4TgGJgtpJCDsDMPDcUo7Rn1kOIuPW49Q0/3xgLxQ==
X-Received: by 2002:a05:600c:4a90:b0:3dc:45a7:2b8a with SMTP id b16-20020a05600c4a9000b003dc45a72b8amr8058134wmp.10.1676941620465;
        Mon, 20 Feb 2023 17:07:00 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id k17-20020a7bc411000000b003dfee43863fsm2092469wmi.26.2023.02.20.17.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 17:07:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/7] test sends with huge pages
Date:   Tue, 21 Feb 2023 01:05:51 +0000
Message-Id: <cover.1676941370.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
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

Add huge pages support for zc send benchmark and huge pages
tests in send-zerocopy.c.

Pavel Begunkov (7):
  tests/send: don't use a constant for page size
  send: improve buffer iteration
  send: test send with hugetlb
  examples/zc: add a hugetlb option
  test/send: don't use SO_ZEROCOPY if not available
  tests/send: improve error reporting
  tests/send: sends with offsets

 examples/send-zerocopy.c |  24 ++++++-
 test/send-zerocopy.c     | 133 +++++++++++++++++++++++++++------------
 2 files changed, 114 insertions(+), 43 deletions(-)

-- 
2.39.1

