Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092D662492C
	for <lists+io-uring@lfdr.de>; Thu, 10 Nov 2022 19:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbiKJSQO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Nov 2022 13:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbiKJSQN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Nov 2022 13:16:13 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A4220BFC
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 10:16:12 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id z3so1889437iof.3
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 10:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BwiJ2SMIDDKVYRQ7wQe9txGQX85SKk+nkzBYRxOOnlM=;
        b=kHfiqARDwfuITn29KeBalVuK/L3P0wuICJMmftMNqljzDzeKnSqXYkys6ad3bnWHbm
         KOSAJOT0nn78yyg6lcthYlAKAtLFmK25HdZZ0XHrC3YFGsz6jCxHW2KaJy8cXylewl9j
         94EjvQS+rX3cd0z5SvCQWz3jdxhDC9GLykyczbthVFFWLCi/dj4Asg0DrliHXVTfea6H
         uJKRb0H2E9IYIRfNJdB8hrrDA8bC06vMGmIxsUGUoGRL449eCQsmdQWxp7My+ldlnPh8
         c1HvH4jz8+0gADtvrsyAIrmF4NIpBsvhqwNlvKIAcDE92oqZZ3KhSeWK+xLRf3bnMZ0u
         iYFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BwiJ2SMIDDKVYRQ7wQe9txGQX85SKk+nkzBYRxOOnlM=;
        b=v31XskMi6+de98Ve79k1AcDQuqn8/CAGPnrFpBuOqHpYltblRXxPnb6BXxmPWE4FSa
         UZdrfwB3USNsc5Wr5JHbM+vPR8lwld+7pHw9s3cpRfQyO6ahrDa5xKIWvoIWblPnwrrG
         d9TI9IEPtgsaYyEmxGJAs9cNLmaN7Co18OuXdeMx1jPoaODQw3CwhN7/uE01jDhRv2HT
         yHd/Jc3CAMY3eHJ1O/YWV2cX/q6GVIQ0eZrqpAvti5MCp1+FCVpUQ5wS2M2V3B0B5e/8
         WnDB1xwdG6ryeje1zavBMMhMdbn8362XSMkpiqzYNIps9eV09p5gM40E2Zd6QQuZcYz9
         STAg==
X-Gm-Message-State: ACrzQf1LzYOFH9qSsLHLu+ISvcRbq3igMg95EH/lWOpyAB4jQWRZnXYz
        TPE76hzJMDPQN2W+2TcBQLLh6g==
X-Google-Smtp-Source: AMsMyM69A0Wcg2ODJ2yCKZOtlp0FodOQRHVchYC9CEXPAD7WUuvbfsgOHhvCu+AR21g6kJVWX9Q6WA==
X-Received: by 2002:a05:6602:3608:b0:6cc:e295:7bde with SMTP id bc8-20020a056602360800b006cce2957bdemr3178744iob.183.1668104172188;
        Thu, 10 Nov 2022 10:16:12 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s2-20020a02b142000000b00363cce75bffsm31120jah.151.2022.11.10.10.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 10:16:11 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <20221110122103.20120-1-linma@zju.edu.cn>
References: <20221110122103.20120-1-linma@zju.edu.cn>
Subject: Re: [PATCH v1] io_uring: update outdated comment of callbacks
Message-Id: <166810417041.167294.11773819036145518870.b4-ty@kernel.dk>
Date:   Thu, 10 Nov 2022 11:16:10 -0700
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

On Thu, 10 Nov 2022 20:21:03 +0800, Lin Ma wrote:
> Previous commit ebc11b6c6b87 ("io_uring: clean io-wq callbacks") rename
> io_free_work() into io_wq_free_work() for consistency. This patch also
> updates relevant comment to avoid misunderstanding.
> 
> 

Applied, thanks!

[1/1] io_uring: update outdated comment of callbacks
      commit: 55acb7980966a3a007af6173910c7aa7b600226f

Best regards,
-- 
Jens Axboe


