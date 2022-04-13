Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02234FFB3B
	for <lists+io-uring@lfdr.de>; Wed, 13 Apr 2022 18:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiDMQ2c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Apr 2022 12:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbiDMQ2a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Apr 2022 12:28:30 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC86529C88
        for <io-uring@vger.kernel.org>; Wed, 13 Apr 2022 09:26:08 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c23so2440726plo.0
        for <io-uring@vger.kernel.org>; Wed, 13 Apr 2022 09:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=lOSBRb8HAFrosUTLHZ3LpmLyemt1pxSH45KePhVmkAs=;
        b=JnRBymikeKYcx+XXRIEVS9O9bQgUuasVL0vdIaBN/h7OTwefRbA/HzhzZrdHHSU3GN
         +giuL1dQfWwaYHDwpB3JE0yxXD5ni6avhXbvlIfJ/BqeEXkII6N+VyUBKV16MR6Rb3MQ
         +8olo+1d33ZzuTXtW2i+6X97SAz8oXH1MOfTZ65BLl/v+OA06KGUcCsbjIOI7FbyAMDm
         Ic+QzTmBUm1Nl6i21+97mhBwnRpRiEssUba2lLdO1Z3faPiSdXeQw2392oBSLX/d5+Jd
         sMw+hpcd69ENwwXY1I1n54AmH/4lrHVFuKhfOJBetK/0mrYR2wJ+8DiKzvMTVz2fs+6R
         rLxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=lOSBRb8HAFrosUTLHZ3LpmLyemt1pxSH45KePhVmkAs=;
        b=y0LHOevN/CKWQWqIDMqNpkl0WZ6lb/PseTFLkmHeJca5+DRoqUz8aBb9KHcOmociHa
         R+4IFCg5IA8doLmrdpdZ1X935sVFdcF//asJAH2GbTStL4a04Zau3gv0v9jSB66RSIrP
         GoG8Acy6WT28hzE64k0RdrGPX4MyhZbaJw5IgMHwBa/2CxB94WQ7sW2/HX8eVYOHVuYI
         kalezOXEz/inEaxiD6IgLNOQxm0to2UffI9GpQOAVldvkOeTlw3Kky28KtBzTg3Yw8V5
         JLK8yEjeDWfdZD2ZHC55epPeXoawC3w1lYq/cb/lLsZnwn/AIVkpxk84I7oCzDDmGqvY
         amqg==
X-Gm-Message-State: AOAM530PZdSqfT7wwfirEtcVJ3Qq2TrZSknRDcmo4kgbDWPAmaZMG18k
        8CP15gCBcU0JtmZ1jjQBgQQmJ6QwIGyfqUli
X-Google-Smtp-Source: ABdhPJym5XL/qhcSzCUK9tkkvvOkmNxwmd6FGhPUjMN2cmoMO8fwp3xYJcvzg637sRcrdT5aOfXVGQ==
X-Received: by 2002:a17:90a:de87:b0:1cb:b207:a729 with SMTP id n7-20020a17090ade8700b001cbb207a729mr11628526pjv.144.1649867168179;
        Wed, 13 Apr 2022 09:26:08 -0700 (PDT)
Received: from [127.0.1.1] ([2600:380:7619:ef79:ffbd:c836:a5b0:a555])
        by smtp.gmail.com with ESMTPSA id lt5-20020a17090b354500b001cd3a3cfc0fsm3390618pjb.50.2022.04.13.09.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 09:26:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1649862516.git.asml.silence@gmail.com>
References: <cover.1649862516.git.asml.silence@gmail.com>
Subject: Re: [PATCH 5.18 0/3] file assignment issues
Message-Id: <164986716685.2100.9235875985695135457.b4-ty@kernel.dk>
Date:   Wed, 13 Apr 2022 10:26:06 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 13 Apr 2022 16:10:32 +0100, Pavel Begunkov wrote:
> small fixes for deferred file assignment
> 
> Pavel Begunkov (3):
>   io_uring: use right issue_flags for splice/tee
>   io_uring: fix poll file assign deadlock
>   io_uring: fix poll error reporting
> 
> [...]

Applied, thanks!

[1/3] io_uring: use right issue_flags for splice/tee
      commit: e941976659f1f6834077a1596bf53e6bdb10e90b
[2/3] io_uring: fix poll file assign deadlock
      commit: cce64ef01308b677a687d90927fc2b2e0e1cba67
[3/3] io_uring: fix poll error reporting
      commit: 7179c3ce3dbff646c55f7cd664a895f462f049e5

Best regards,
-- 
Jens Axboe


