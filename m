Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E745EDE35
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 15:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbiI1Nxv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 09:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbiI1Nxp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 09:53:45 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AE088DF9
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 06:53:40 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so2352678pjq.3
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 06:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=bFQCAifLmujnnLkDNk0kkjrd3BKfKN4tlM/6U19pNH0=;
        b=x8KCqMEeS/mobkx+JpTqnIrL422uM5gB6Tqi5RY/F2IPSmLl+wV1MZookEVR5GvJLf
         UdrPUtRo8j+mRFqQ/teHu4ANY2lvCbPl8oLGCHrEmTKHlDnK1FV3UGY5MUVZ71jhBBDy
         Y1qfWZU/5coF9yw/5eVuUQox7td80bYBTDH/hb94sOD3H8IwV2faUQYyiwJRhMZSCgig
         yIGnJGusjeCW+DLeLxS+jKAGIpYsue9gz2ybWxEdU8XawguUoes0T8rbMzmmWkDsMrxE
         9rAPmD5rt9EUgPggZa6aXJq2101u4m2OriufcYUoHp+6eFcyNO85I/I67v9bHbbNuEo3
         yT3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=bFQCAifLmujnnLkDNk0kkjrd3BKfKN4tlM/6U19pNH0=;
        b=WrRfDis56Ej0x5FhOuRfQqVyNavzNYtLh7lul1Bg44XWDvb8WvtYP3KH3hXERqadvm
         SnuYVi4kqb4XZ+ImbV+nPJO0/Pw74zjtrjSlMh2Za+YURpvRGOwh0JyMD1fExJzzVcFb
         R/NTR/7Sawu1oGCcioIP4hTLnzywiBHQJ7QFkT2tMID9YRrFgPc/blRLOFwJKr8wmaEx
         JHq9fq67bTXPxPFAj2Qpp0gU6Ctkcn77GetWuKqO4Dufi4onB4Ul/XN/dnqXvzbR4iA7
         y6JJV9tYBlNDBSlq3Z/uKgL7of1cAIBRkd0I1UsbBS9Uls6xg7ooXa024AK1BEzyuU0D
         t6Hw==
X-Gm-Message-State: ACrzQf2yUFJwwJCn992017wmfrOunF+rbnOOAscenGka79cJ1U3DL7fH
        qsdwy9H7a8BL5lbLOCAL38mEXn9/CxN2Dg==
X-Google-Smtp-Source: AMsMyM4wSGauBvGV28hSUlB6IeekuCHzLWVx+H29xIfF51By6aP80GKkyaLn7zLzHAHNf7RxdCUdbA==
X-Received: by 2002:a17:90b:1c82:b0:1ee:eb41:b141 with SMTP id oo2-20020a17090b1c8200b001eeeb41b141mr10923840pjb.143.1664373220254;
        Wed, 28 Sep 2022 06:53:40 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t16-20020aa79470000000b0053e5b905843sm4039942pfq.203.2022.09.28.06.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 06:53:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     Stefan Metzmacher <metze@samba.org>
In-Reply-To: <9c8bead87b2b980fcec441b8faef52188b4a6588.1664292100.git.asml.silence@gmail.com>
References: <9c8bead87b2b980fcec441b8faef52188b4a6588.1664292100.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-6.1] io_uring/net: don't skip notifs for failed requests
Message-Id: <166437321950.10271.14794575735421337726.b4-ty@kernel.dk>
Date:   Wed, 28 Sep 2022 07:53:39 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 28 Sep 2022 00:51:49 +0100, Pavel Begunkov wrote:
> We currently only add a notification CQE when the send succeded, i.e.
> cqe.res >= 0. However, it'd be more robust to do buffer notifications
> for failed requests as well in case drivers decide do something fanky.
> 
> Always return a buffer notification after initial prep, don't hide it.
> This behaviour is better aligned with documentation and the patch also
> helps the userspace to respect it.
> 
> [...]

Applied, thanks!

[1/1] io_uring/net: don't skip notifs for failed requests
      commit: 6ae91ac9a6aa7d6005c3c6d0f4d263fbab9f377f

Best regards,
-- 
Jens Axboe


