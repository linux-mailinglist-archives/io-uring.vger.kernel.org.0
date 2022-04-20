Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D665092EC
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 00:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239734AbiDTWkU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 18:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbiDTWkT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 18:40:19 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66355BC94
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 15:37:32 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id bg9so3008365pgb.9
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 15:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=cQ/QBSXXxy0ifM6PDkPba5fOj5qGHbCaOLtN26TXWps=;
        b=M/rxi8MEe+cm1aoQCBdYioo8AOfWSBNF+grcjCz/+CNMdiVGUSOsFoAIC/7+0YVsQK
         3NzD3Vj8kFirWZHnHFdohkh0C8y8LA92R7THNXFFnDrdpNX0llV6jktcn/RlwZsjufeA
         HHQ7R4pfFWdVN8RA+3V02M5ry8vLvjOyuXEc6TuhJMWhF/k4XX1HEyhCEopU78EZrfmY
         EZkAIkEPgVf8Zbr2f5X44KOCvSqyYQAmmtsoQlBESRuPKQeiG74ebe/l0xXYe0+h6Byf
         bprSn3ey3ABpvkX7z7SF2z+ezLz6sgHuSiUm34HtZHCVnhFp2uJFEm5tZIKZdwv+hvs1
         OsHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=cQ/QBSXXxy0ifM6PDkPba5fOj5qGHbCaOLtN26TXWps=;
        b=LHnHvMflDuu3UZ1mnJ96mA+CHAmS9ndbM1P0+jH7q7zcMVTclkC7WuArtzeuVBLMDj
         7IOCAgxaTSACPU+s19XkL1v2EX1Y3daUGH+L44y7yELh1/I0QrLiMP4AievSueseZk6v
         iqYq+Z3cuS5BPvf+btxdVr4C8qwegHgulWHJL4H1dlw/axBGCBNIfShGaVmsa//feemG
         PwhelVkn/9udXSmBs5xrgTfdRkSEtwSCbnl+dSP7fWrzUOocx7qZ7Zyw7e5iVw/faBoB
         HEaR7OaFJBLuYT7jdCrSnKDM5XfKCkJsZi1HMzx+zR08mGK7HQqfRvM+T6jU/mTAshoN
         GW+w==
X-Gm-Message-State: AOAM531co/qufYwC05NA4WSKy1OBsNCoaKxAltaklv4qBH55RLn7CCeo
        DvDT0+AQUfsTNjP0g3z05qUBdrc9J9PLUg==
X-Google-Smtp-Source: ABdhPJwgnnfQ8tf8dMdm9o+Z6pzbVIqueRxtWtYgzNw3RmcaezelOY+IkqHDO78ZwFlDf8yiHfwHDg==
X-Received: by 2002:a63:6bc6:0:b0:39d:966d:2791 with SMTP id g189-20020a636bc6000000b0039d966d2791mr21411940pgc.407.1650494251618;
        Wed, 20 Apr 2022 15:37:31 -0700 (PDT)
Received: from [127.0.1.1] ([2600:380:4975:46c0:9a40:772a:e789:f8db])
        by smtp.gmail.com with ESMTPSA id o34-20020a634e62000000b0039cc4376415sm20437900pgl.63.2022.04.20.15.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 15:37:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
In-Reply-To: <20220418164402.75259-2-axboe@kernel.dk>
References: <20220418164402.75259-1-axboe@kernel.dk> <20220418164402.75259-2-axboe@kernel.dk>
Subject: Re: [PATCH 1/5] io_uring: remove dead 'poll_only' argument to io_poll_cancel()
Message-Id: <165049425084.530529.7480425889273735134.b4-ty@kernel.dk>
Date:   Wed, 20 Apr 2022 16:37:30 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 18 Apr 2022 10:43:58 -0600, Jens Axboe wrote:
> It's only called from one location, and it always passes in 'false'.
> Kill the argument, and just pass in 'false' to io_poll_find().
> 
> 

Applied, thanks!

[1/5] io_uring: remove dead 'poll_only' argument to io_poll_cancel()
      commit: 156afa36fd550c03953b9f55977de703f8c24b55
[2/5] io_uring: pass in struct io_cancel_data consistently
      commit: 36689d57c71ff79e2e63a36e8b48f210f77e453b
[3/5] io_uring: add support for IORING_ASYNC_CANCEL_ALL
      commit: 85222d8b6adb5bc2fb48e1bb61f16f3513d3d584
[4/5] io_uring: allow IORING_OP_ASYNC_CANCEL with 'fd' key
      commit: cd9ef41cd35944899861d3fb708ffcb9db15da7c
[5/5] io_uring: add support for IORING_ASYNC_CANCEL_ANY
      commit: 7c648b7d6186c59ed3a0e0ae4b774aaf4b415ef2

Best regards,
-- 
Jens Axboe


