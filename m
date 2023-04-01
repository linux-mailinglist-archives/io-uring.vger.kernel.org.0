Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290AC6D34FB
	for <lists+io-uring@lfdr.de>; Sun,  2 Apr 2023 01:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjDAXVB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Apr 2023 19:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDAXVA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Apr 2023 19:21:00 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFB51B35E
        for <io-uring@vger.kernel.org>; Sat,  1 Apr 2023 16:20:59 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c18so24794431ple.11
        for <io-uring@vger.kernel.org>; Sat, 01 Apr 2023 16:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680391258; x=1682983258;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=faQ698IMUptiV0IjwDxGsnJHfv2imd05MGaZiZwDlig=;
        b=iBkI8iRhd8LQ0LbhxipBf5A8ladGbufklAFNt/1t7FQEN3o4v9tYNdZfD++KP+1J/O
         3NOr2OqSEIEAm5FOYgsAgurMgUvwJTn57eYuy+DuBPkXha1gfbgAlYc+Sjuz3QT58H2I
         7M+1d97lS3wCVpnp/rMJqq/hHVhbnYugEt4HBMoSaTnuAkhlgf9y5BlYUdb9tx1wP+Ba
         O2TTiYrSMFFsr0xM4fgnPlOuBezqGGphUqVp2dyhUXzF5gx6/9DfCF2hs0ZadPd1iWFI
         C71I9wlw1FpFwTlSD0JSKWY5Ac0cu3mn7DntB5A4fFIFa4izhrXbDlenR20JW7cB11GF
         tWmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680391258; x=1682983258;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=faQ698IMUptiV0IjwDxGsnJHfv2imd05MGaZiZwDlig=;
        b=Wi3AIQ5wP+0li8Q8dqVlONkd7qqNMtMDoFBJG9DVQimPLC7ingKRUQee2NcnyDZKK2
         GV3z9oBXYJIWWn/AjEurloODj1XI6cvYvW4ZKQ4l2CY3vhREHFrVyAjjX2531qoIL0Rj
         DzpjtL35zdXw7o+O2RHTK/erplAHp25hZ7XH32dF/clpbxbOUuh8+GTQp75EJnvIMddq
         ILdPB4FCo4DSCb6WWnGi9elGxqthpvXrDljlGzFOkd8txEWquXCaf+VOBSWB9HR/knAX
         hUAzrjHdq1/ZNmx0LXbaZA5+7s3dQuI+vsioYo6J7VYu80rJiJ6utimdnCTMZsz0iG+7
         E0WA==
X-Gm-Message-State: AAQBX9ejLd9rVtToGF1lmVquYqpsPGZGh2jp1jUiWQQtFWqrbUYx73Oi
        b41rvHJqm4DeAtPJ4uliP64/o4QyxyEF98uHXSTv5w==
X-Google-Smtp-Source: AKy350b4aGLr1VpEGKu/tcn1kZZxAdO1oFaBsRb5Bz39CHIzsDYionmas9eewer7fcYfZUrri9CU1A==
X-Received: by 2002:a17:902:720a:b0:1a1:b51b:4d3b with SMTP id ba10-20020a170902720a00b001a1b51b4d3bmr27623044plb.1.1680391258407;
        Sat, 01 Apr 2023 16:20:58 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d1-20020a170902b70100b001a051eb014bsm3833314pls.219.2023.04.01.16.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 16:20:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Wojciech Lukowicz <wlukowicz01@gmail.com>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20230401195259.404967-1-wlukowicz01@gmail.com>
References: <20230401195259.404967-1-wlukowicz01@gmail.com>
Subject: Re: [PATCH liburing] test/read-write: add test for CQE res when
 removing buffers
Message-Id: <168039125791.142063.1207383594514062900.b4-ty@kernel.dk>
Date:   Sat, 01 Apr 2023 17:20:57 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-20972
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Sat, 01 Apr 2023 20:52:59 +0100, Wojciech Lukowicz wrote:
> When removing provided buffers, CQE res should contain the number of
> removed buffers. However, in certain kernel versions, if SQE requests
> removal of more buffers than available, then res will contain the number
> of removed buffers + 1.
> 
> 

Applied, thanks!

[1/1] test/read-write: add test for CQE res when removing buffers
      commit: ce9ef761e8d29399a079710a78cc84665466a754

Best regards,
-- 
Jens Axboe



