Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1FA53347C
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 02:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbiEYA4R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 May 2022 20:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241884AbiEYA4Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 May 2022 20:56:16 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967C912614
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 17:56:14 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-f189b07f57so24374896fac.1
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 17:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=/ieTAqAN4d6hKkMcFOVhLy+tMDLYmgD/2JoqYo9l0OQ=;
        b=lZRPuImSeNfBlYcP0gavDmJudzDyZoOXZYkqnYW8YoALi1oe1WYFuz4t4wemrwLtIX
         VX9ikgn7X/S4b/tnO+A2w0ym21bGzdhKAFqq6Jn+XEX4D2LOt2Zcjle1IH731+fXOEwb
         D372uzhS7cILZE9FVYmCL6MfVdCk9eYYLPf2htz0e2o8YicwU56Cw5mcSFqqygvzov4o
         VNcQgorns8FfikdXPYwUBqvUQ0gcuJnS+v7U19Uhsu6vhJyEHiCSNO4s7PNHjhwf5yGt
         FxoDToQT6mh/bZw4daxUNNK1u6I6zotpWUCkncFeY6XdZ1TCuCEuYJX39sh1Vc+CTcVO
         gpdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/ieTAqAN4d6hKkMcFOVhLy+tMDLYmgD/2JoqYo9l0OQ=;
        b=ZEXS1ypFfSZZWSIc4UWi9g8BWoK+XP7VvUWG/bdWkYlpQAZxHJvMrzpNz89mD2vplM
         qdjtd51n+nQjne1rVnXYw4mt6lgcBss2wC4o3u2odrrfXTuJo+99W8Q2V+yahikDELSi
         7JV3nZfWz0hvKRRAEjq04tqJnhzNxOTl6IF4b9I+Y5C4zv7hr8VsPzQia+gqM2A4A3Q7
         fJtKtU3naq7s8X2tw2G8Fd40tWhygADrBz1qeYqE3ttr3w+r4tXwYd0h1KbxnccOVkFg
         92mXAVMXF9jAoyzXvNNW9xt6H7Rwnw9QSxg9yrawtDJCB6S4CR/1oa3V3FxN0uVaYNYa
         p83A==
X-Gm-Message-State: AOAM531MG85Jt7yvXJxfVC5yV69S8JyeUCTiIoKWw7adLiHccN/3AEXm
        WCUJHyVeI0lcg1n6S879TBWqwITHt2pZQSnQzLXtWsbe
X-Google-Smtp-Source: ABdhPJwlp4gdlJxhS14y9/yJxnLfs0uqU5ZSvGof9aeIUYBtB7QQ84NwMrcGk83nqTjG1P0cl73yeP0swzFSKznZQDI=
X-Received: by 2002:a05:6870:f699:b0:f1:de44:9f5b with SMTP id
 el25-20020a056870f69900b000f1de449f5bmr4106788oab.284.1653440173627; Tue, 24
 May 2022 17:56:13 -0700 (PDT)
MIME-Version: 1.0
From:   Changman Lee <cm224.lee@gmail.com>
Date:   Wed, 25 May 2022 09:56:02 +0900
Message-ID: <CAN863PsXgkvi-NLhyLy-M+iQgaWeXtjM_MBoRc0H0fq2jTfU1w@mail.gmail.com>
Subject: io uring support for character device
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

Hi List,

I'm CM Lee. I'm developing a custom character device managing pcie dma.
I've tried to use io uring for the char device which supports readv
and writev with synchronous and blocking manner and seek.
When I use a io uring with IORING_SETUP_IOPOLL and IORING_SETUP_SQPOLL
for reducing syscall overhead, a readv of the char device driver seems
to be not called. So I added a_ops->direct_IO when the device is
opened with O_DIRECT. But the result was the same.
This is my question.
Q1: Does io uring support a character device ?
Q2: Is it better to reimplement a device driver as block device type ?

Thanks,
CM
