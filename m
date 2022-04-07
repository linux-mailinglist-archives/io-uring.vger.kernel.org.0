Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9DF4F81E6
	for <lists+io-uring@lfdr.de>; Thu,  7 Apr 2022 16:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344058AbiDGOjM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Apr 2022 10:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344124AbiDGOjJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Apr 2022 10:39:09 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9673C16DB78
        for <io-uring@vger.kernel.org>; Thu,  7 Apr 2022 07:37:02 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id t4so4317959ilo.12
        for <io-uring@vger.kernel.org>; Thu, 07 Apr 2022 07:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=OLLfcNaEOv4iF9BwV5ghnNqpniGR5v0uWQyBu3K+l4w=;
        b=gDCKYv6oLskmt0faYw6APm6HzmLnN3MrMtrZYOnd76VoJn+vjQZYvpznGMMOdCoCtS
         mDhCmAA2j4aSis34mO9QLgWrBMAfNIJgI+kJQ75nzSUzF9AUkmfC7Y6k7PvCefl3qm/w
         TkMDsa8xixzGLZid48YvXiZBJ4HpTIpYg1L6YXy/gNO7OVNE2Cl0T8Kje4BRJqtIwwbS
         dPs2Lh7EEuDrKjavm2t7mabFUrOgJB7rsFY1osPQrPVxLpCtI7q75Fm+hOnYY7r2BUiR
         viC4Gzs3916wFcfv9Vrs88+er41eGEf4YHReScGWv8LZEJDxQixKAm0JmZ3vtFmPcMoi
         7yQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=OLLfcNaEOv4iF9BwV5ghnNqpniGR5v0uWQyBu3K+l4w=;
        b=7bBcF3baVifHUrv9pFWQE3N60i81q59F+wxCJ43nBx4KAdVPzvwmCnAnhEV+mLrX70
         2+xQ0tE1uU/bnJb5g9qEA7256dyNEy7NVOo0/6Y3hTcdc2mLg39e2tN1wt1TexO8lwU2
         3uNR/TsVTALp4iSprJOekpACZKBs40PfKcJe+tfmcpblQTdNHK1GbEOtHgzKH58rztc5
         TetpE3RGswZ57rZQdTNK3DVEVDu3Esnk8OJYh/K1AU9f+P5zlDVw7Ia0zJVnI6q0bBpK
         tcdfvBNOrrWwXDKdwseErIhgrOJLIj1OM803ptVdYeuCYZrufmxgWofT7+qZfn0Zac/1
         /Gtw==
X-Gm-Message-State: AOAM531fmLstHJz67a8TzM9/SMAub04nAw4TeQT5Cx0aJ+h16I+m2K1K
        rNQh2yD07oKXatXKX783tm7dcg==
X-Google-Smtp-Source: ABdhPJwL9glTrvYxP9JnJWmyQwQ6dfZq7Y9FLt5gaAKV0XL6Hzh52ezprE0uQIVLy2UFRruYA/SJuA==
X-Received: by 2002:a92:7c11:0:b0:2ca:36df:e2f2 with SMTP id x17-20020a927c11000000b002ca36dfe2f2mr6548830ilc.149.1649342221603;
        Thu, 07 Apr 2022 07:37:01 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f13-20020a056e0212ad00b002ca785dd26fsm1317504ilr.72.2022.04.07.07.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 07:37:01 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <cover.1649336342.git.asml.silence@gmail.com>
References: <cover.1649336342.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/2] two small rsrc infra patches
Message-Id: <164934222088.36187.18258318194109932868.b4-ty@kernel.dk>
Date:   Thu, 07 Apr 2022 08:37:00 -0600
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

On Thu, 7 Apr 2022 14:05:03 +0100, Pavel Begunkov wrote:
> Small unrelated changes
> 
> Pavel Begunkov (2):
>   io_uring: zero tag on rsrc removal
>   io_uring: use nospec annotation for more indexes
> 
> fs/io_uring.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> [...]

Applied, thanks!

[1/2] io_uring: zero tag on rsrc removal
      commit: 3aa3bc4fa93acaac8ffb31fd09f14399924740bb
[2/2] io_uring: use nospec annotation for more indexes
      commit: b5e400c9542fdeca2015d4df7672cbf14d40746f

Best regards,
-- 
Jens Axboe


