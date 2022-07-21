Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C416857CDB1
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 16:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiGUObn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 10:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiGUObm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 10:31:42 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451957E321
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:31:39 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id r70so1449874iod.10
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 07:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=kaZ8yXAxFSc45GxIoHxoIYoWe/r5KZ/Bxj50vNLsp/E=;
        b=kE1UCkmwHJE/VKmcmZk2il3PeNepyyUmCrTWUk+FPyA3VlkUYnuVy8SwVc/dfB6CkJ
         HbWMY+mowsU/311L65yK4xGJ+EwrQ8ATQPM8j7rPastixzctKJSiYLggFQR016y52rfo
         IMEXPxp9AdTHb2wbnL0f8eUCB0AVwSEjT9HqGfKMJy4T6+WYdTNAJHCMOr9LZNs0AZGg
         LithkY95npxq5zSVdiCEfuDAdJZxbcNcMDoRZwVViovlHYA2LrD497VS11N/D09cUd9g
         R0i5wc51N6Vq9RXgjXE1JCYuhUcpsU7CUVIlidEt6vLFI4B4QHg0Jn6FU7Fzmau1BeW9
         K52Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=kaZ8yXAxFSc45GxIoHxoIYoWe/r5KZ/Bxj50vNLsp/E=;
        b=fxTE63Yzlouierqvc1AF6o0JtxLPEKlPIHLmUaNvokuc8F0BxuwAdM8Ud6PwoxQfBX
         +TvF6lOB6zKYVrnP1ygiL5zS99lcPsoOARR1rIBbCgwleOt3mLaPC3O90MkBLjzhO48M
         eTozFVJgQcTPmdwk1z/L60xuVPQd14RerdlfIClz3HIDnP9rs3xwDLzNLmxo9TYbpLQQ
         ZbJGcBc2VInThVxze8ZGMLwrSw9cmP3Mq+60wMLUHpJ42skWtINUBlkG/DJP49o7JPxw
         8gPhVagrK5zN2pytVL5ndQhQjAf/p9Bvha46jLrN5ObVruuZpXesMK1YcQIL3yQal+EP
         mYEg==
X-Gm-Message-State: AJIora/hCiGuTdhzqt57sBwvcw+oHeHEsMy8zk8h+bglI7RFAqDB/1yV
        0hgis/WI2tPYs1ymIlG7VJwBUw==
X-Google-Smtp-Source: AGRyM1vy+HZsgccQoKpi2QB5/0+dGRr5oTj2PchRZH3UbW4IAqZ+7+xrq+7tNv2kkpktj+oOgwPJmw==
X-Received: by 2002:a05:6638:264b:b0:33f:5c2b:183d with SMTP id n11-20020a056638264b00b0033f5c2b183dmr21740253jat.173.1658413898561;
        Thu, 21 Jul 2022 07:31:38 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m24-20020a02a158000000b0033f3b201d1dsm846452jah.21.2022.07.21.07.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 07:31:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, dylany@fb.com, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Kernel-team@fb.com,
        ammarfaizi2@gnuweeb.org
In-Reply-To: <20220721131325.624788-1-dylany@fb.com>
References: <20220721131325.624788-1-dylany@fb.com>
Subject: Re: [PATCH] io_uring: do not recycle buffer in READV
Message-Id: <165841389777.10412.3815798285914520937.b4-ty@kernel.dk>
Date:   Thu, 21 Jul 2022 08:31:37 -0600
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

On Thu, 21 Jul 2022 06:13:25 -0700, Dylan Yudaken wrote:
> READV cannot recycle buffers as it would lose some of the data required to
> reimport that buffer.
> 
> 

Applied, thanks!

[1/1] io_uring: do not recycle buffer in READV
      commit: 934447a603b22d98f45a679115d8402e1efdd0f7

Best regards,
-- 
Jens Axboe


