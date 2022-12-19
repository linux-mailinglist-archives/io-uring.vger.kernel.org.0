Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62BF6510D4
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 18:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiLSRAZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 12:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiLSRAY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 12:00:24 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBEC1149
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 09:00:24 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id d14so5007600ilq.11
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 09:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l4kgpq+zGDcNFY9jmuIfTMdh0UKn/wZV0MZB7SX956k=;
        b=k0FCFoS3eBW0L0gX6KDID94rjLRaOht8TzSdMald1pyEnRrU7pIEmVrg66cD76vJ90
         amgFGlPutWgmoiGn7mpyITk2m3vbfvWikROytNurr8fXTq/SBEyZDtLu3UySGMS5l1XN
         a6Yhc7XxU1CJI48Q+7uyMJIIxZhoRPiqz7fqTYU7b7rX2HqPiauTbKvZ7RTUwymP5O0A
         OzwhaYAq+Idgx1t56gI4w52wS+1ynP8hIqwzR4ECf3/VH9aul7V7X3CflgIadp9d2Ypc
         QbJQWBe98JDJxeIkOD+HUSw1NXbCoZw8x4bjVxalZrbZou1JIOl25cEDOk+BvygkcQIw
         5Puw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l4kgpq+zGDcNFY9jmuIfTMdh0UKn/wZV0MZB7SX956k=;
        b=bObnXmXBoG126ON962ANMfh9GcuCACxaQ8nNOby4c0/OvQGNi8FuHInMizDdolXwc/
         2MFTSMAW+gU5sBP/53BhoNJckuIYWa5OT2PTQ4Pc88cI47V5HiL0KTw4RkJNIclOUN1y
         D6x78kMsiQG20XMftvAdu160ZL96bBWJZtoHriAVeBvb+lWBbvYfk1R8O/EZkc1M1YlW
         CwWFbuTr6pneWCUxY//SHG1PfjDfPIftuY88tHsxW4ROJsaFuQQqfJmypJeM0vtiO1hu
         vgTu3ECoAxUoqiG1cfRYSo6kNzyfFzllisZd5/pgRsUBaGx6r8chlRwY8Lm6shwzeOp2
         dIHw==
X-Gm-Message-State: ANoB5pliU+9GU5qKB9P7wki6Ad275RCTbOfoAklkkDkmMtofcn46ISCc
        2UOinZ83aK+O9rBlW6xXe7X/3skbZrHELyrgOew=
X-Google-Smtp-Source: AA0mqf4hRhRQPEwQvtWZnMxjImrL58W9MjRFxJBdS5cPbjD1ggWxdlTlmp7wFIt6vMEv1DTzG/RF4A==
X-Received: by 2002:a92:d74c:0:b0:302:d868:8ded with SMTP id e12-20020a92d74c000000b00302d8688dedmr4178648ilq.0.1671469222824;
        Mon, 19 Dec 2022 09:00:22 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y14-20020a92c74e000000b0030347a87f16sm3419666ilp.1.2022.12.19.09.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 09:00:22 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: =?utf-8?q?=3C9e326f4ad4046ddadf15bf34bf3fa58c6372f6b5=2E1671461?=
 =?utf-8?q?985=2Egit=2Easml=2Esilence=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C9e326f4ad4046ddadf15bf34bf3fa58c6372f6b5=2E16714619?=
 =?utf-8?q?85=2Egit=2Easml=2Esilence=40gmail=2Ecom=3E?=
Subject: Re: [PATCH 1/1] io_uring/net: fix cleanup after recycle
Message-Id: <167146922202.37861.14478011174309706338.b4-ty@kernel.dk>
Date:   Mon, 19 Dec 2022 10:00:22 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.11.0-dev-50ba3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 19 Dec 2022 15:11:40 +0000, Pavel Begunkov wrote:
> Don't access io_async_msghdr io_netmsg_recycle(), it may be reallocated.
> 
> 

Applied, thanks!

[1/1] io_uring/net: fix cleanup after recycle
      commit: 6c3e8955d4bd9811a6e1761eea412a14fb51a2e6

Best regards,
-- 
Jens Axboe


