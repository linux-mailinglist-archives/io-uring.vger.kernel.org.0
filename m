Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10F870D25D
	for <lists+io-uring@lfdr.de>; Tue, 23 May 2023 05:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjEWD3E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 May 2023 23:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjEWD3C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 May 2023 23:29:02 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E7291
        for <io-uring@vger.kernel.org>; Mon, 22 May 2023 20:29:01 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-2554696544cso1839072a91.2
        for <io-uring@vger.kernel.org>; Mon, 22 May 2023 20:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684812540; x=1687404540;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AgCtPFr8n9i3Zze+8pX+ddqZf2OAxGCL4K2iyt2qKuE=;
        b=eUJTm+wPcDSWoFM20Kr8C8NEVAp98fujr3CkvZvHZ/80icfKvJMHW31BlbHgHKyPN7
         vSaztiVPbFARHNGlDy7PaLSmFarNcOdZrfVk56vt14ZQ1E7HeEA3e/4fddBgS1w7LHS8
         3xZrCESHPv22YiDVy0BpKdXWDhZpBg6V5Vl7ij1OutDJiDfnnXwUdLlBd7ujQ1sVWIfv
         mfy0Jb+Lop8pdB3ftSV9jy3R4uhDWILGGGTnHqNu+jGQkc9K6dAkXQ6MQnE3KiJW0b+5
         X4mjTX1ZHZXvdpoUzYeqRBqvAsDGB08iZo7uW3txtnSjUyBsVu0/AFRvegF3uP545Hxv
         NtkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684812540; x=1687404540;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AgCtPFr8n9i3Zze+8pX+ddqZf2OAxGCL4K2iyt2qKuE=;
        b=cYCC+RXqXMWEkwhXwGx5uRpRGkPk8PVgxSa0r0ZFVRJFDzZHdVUNUsY+ECI79h+Z50
         KVnPl6EwYsF2a/ot2pKn2O3m9dUvD9XiZTDKT8U6/60yqQKtYh4GTE9ccQrzyF3TxVXQ
         yrk/bQbodHJicsFOa6ITg7ASH0XpA5t1paKVFbVswiz8b9o+lF85U+V8ewAX6v/hS4t1
         vQLhIEgpbeIO/a27gKjyRA0fiCLT3WdiAubkgVex5uJsUekyP5PxpsbqSHfyPsaY50MO
         95+jpXh+dBXSNRoOSlgJX9g+r16KHDoBWVZyr2JtWbWXJ98je2C3X0tlDTL8F4lmEYMF
         D4YA==
X-Gm-Message-State: AC+VfDwnN280+fsZoumREu4qvb9nt7NdXlXecaQzmFShFK4T2fiwAGxO
        +EC4wHIbX0y3THu61DBeT+Xaiak4x3VzteLK+rFjFwl5vJs=
X-Google-Smtp-Source: ACHHUZ4M8TVG4oCMUvxRiCMyyz0kcO5svzaxo0/yCCAxVEsrkZIPq13GANDXbmKfp5I5WAtGhV68miYMhuZNfQJ87Cw=
X-Received: by 2002:a17:90a:f289:b0:255:5d2f:26e8 with SMTP id
 fs9-20020a17090af28900b002555d2f26e8mr5040585pjb.30.1684812540555; Mon, 22
 May 2023 20:29:00 -0700 (PDT)
MIME-Version: 1.0
From:   Peter Veentjer <alarmnummer@gmail.com>
Date:   Tue, 23 May 2023 06:28:49 +0300
Message-ID: <CAGuAWdAZLYdzby8n=9-Au8sLQrkL-26HfqtzMqMcEdKiSXihEQ@mail.gmail.com>
Subject: Socket IORING_OP_WRITEV fails spuriously with EAGAIN.
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I'm working on an io_uring binding for Java and one of my integration
tests is failing. In this test, I'm writing large payloads
(up to 10x1MB) to the same non-blocking socket using IORING_OP_WRITE
to simulate congestion.

The strange thing is that the cqe, indicates the request failed with an
EAGAIN on Fedora 38 (Linux 5.16.12-200.fc35.x86_64). But on On Arch
Linux (linux 6.3.2.arch1-1) the test runs perfectly fine.

When I reduce the size of the payloads or the number of payloads,
the test passes on Fedora.

My questions are:

1) under which condition can an IORING_OP_WRITEV fail with an EAGAIN?
I have gone with a comb through the documentation and I do not see any
obvious causes.

2) what is the recommended approach to resolve the problem?
Resubmitting the task solves the problem, but I'm worried it leads to
spinning behavior.

3) When an IORING_OP_WRITEV fails with EAGAIN, is it guaranteed that
nothing got written?

Regards,

Peter
