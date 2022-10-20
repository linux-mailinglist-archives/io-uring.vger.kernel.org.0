Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DF960551D
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 03:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiJTBnl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 21:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiJTBnk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 21:43:40 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680AE1D1AA5
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:43:39 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id u21so27776751edi.9
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qIlxmz8bqI/AjdWv0EBhfb5P48nECpAjHhgSFLJazRs=;
        b=a/N4KtaJJBzZHoGN5Bt+dMmyZS6B2eetyFOlrsWowJmhdUlgWoLsoqUjD/ORE+vLy1
         XaVA4pFMpgW1pBSmGt5itkraIDtX05yBnbcjVSI7+ByGQnbCmbItJl6EWli9+vIzjBzH
         klxK8WLLiKdB+BkxMvbWaLOV+MBVWJ8Cg6hbl044gWSjH6CMzEpVCRA2ZeSL4hOVfDVF
         QVPYHmgZDtcqd1fxRzfec6C7kTk0A2aS+ZKcI/UXHzUPJiKplX8k6vd4+jOOTQMEKvIQ
         zWZHUZuYrUu7RnN3XwmptlAmlX5ADu/c+4pTxLOxbRtrwiiYD6fdT48N47o6uv5/qNGq
         nc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qIlxmz8bqI/AjdWv0EBhfb5P48nECpAjHhgSFLJazRs=;
        b=JoZ9v+79Z59BiN/fnnnpJXCckm4xDK9XQg1VIAi61MMlkySPZxdW93RV0wltpHxSfz
         iVNwXhkTckNYcydFwLL/vsnstmZbNaHoNNhkuIImCLQ9yx/4wl+7q2ubusfV23T4fHaN
         1XvvvPN/IZdt1sIYIj3MGHhfvBeXt+VDD9sSzF3SFdp84MmTR8veSNn5G96GiSHW90lW
         0mKd8Dc5vlPBD74O4RlEGuGJlE1SwB+2JR9AwEJvhgv4t29ILGbt6xLZklZ/5kQ0Bfix
         52wQeP6PvlQfEJ+cbeieE4reut/BaG9eVwp3hPB7ApGF5E8jzdK5oMojMilY4EyZu5pf
         In1g==
X-Gm-Message-State: ACrzQf0DZ+K4bq2Va2doYdsYMq4iwMnAC3l2BapLWUQF7pyAX/J3ng8r
        gYDmGPo1YEAh/DXiqgHjpsXYeZZnjWw=
X-Google-Smtp-Source: AMsMyM4bYKpcdjekNSWu7b/HwNlKQH8S1i7KPZ89RBmPaUOJeeNFtxOhMELb36GJr3DfUuE+reUzjg==
X-Received: by 2002:a05:6402:42c3:b0:45c:ec49:aacf with SMTP id i3-20020a05640242c300b0045cec49aacfmr9975762edc.40.1666230217554;
        Wed, 19 Oct 2022 18:43:37 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id g16-20020a170906539000b0073d5948855asm9695530ejo.1.2022.10.19.18.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 18:43:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH for-6.1 0/2] don't fallback if sock doesn't undestand zc
Date:   Thu, 20 Oct 2022 02:42:34 +0100
Message-Id: <cover.1666229889.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
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

Prefer failinig requests over copying when we're dealing with
protocols that don't support io_uring zerocopy send. The patches
are split to make backporting easier.

Pavel Begunkov (2):
  io_uring/net: fail zc send for unsupported protocols
  io_uring/net: fail zc sendmsg for unsupported protocols

 io_uring/net.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

-- 
2.38.0

