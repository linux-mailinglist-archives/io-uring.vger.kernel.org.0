Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F095E8492
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 23:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiIWVFi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 17:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbiIWVFa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 17:05:30 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA290861FB
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 14:05:24 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id a2so768945iln.13
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 14:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=sjMVYwndkH4A/+kWqFtTJCPUvZckb/DvReuf+/YKnK4=;
        b=cXx11N5HbA0nWuKoG7dnrTgr+kN/UvVk7iFj5VQOOMlLLpJKQhzdRaZumiaGxmL7+k
         dFCtzAkRJDjKmQm1rftQcaYJjaFPc8H+3cKhBqkrR5feVE9zOUm9ZbbORVp5rXiCMqI5
         pYdd6FPsaOpmyWStzqR9HpGH7d2gy6ZoMutxuOi+rDdgbh6pPIyqATtpnib2ro/ABpz2
         NMFb0eIIVuL+uXmS545djmuAClV/sAgFcvKxvDCdrkgpnFwsS/w+IkfhedziP5OM6Uk4
         wDoIwpWjPe2/euhVf6bq5Suu+Dens+/Gfgd6m/dl6kedUT33SqbYP5lMRNtiNwZs+xuo
         qq5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=sjMVYwndkH4A/+kWqFtTJCPUvZckb/DvReuf+/YKnK4=;
        b=KC3F0XRZusOMzEo8Hq5A/3UDJojNIWP1zblLHVKoSDbNXhMa8olfU2Y/mSiCbkZQAl
         5/MG2gLJ7ZSkUprzRS5f/w5ydcXV2T77kIZEyzR6heZHUrIioqH3KjHEfR23UcGJ53fS
         uUGz7tV/FWfUW0Ck01KKjdse69rRbR90NySPlQVt8d6qYVaTDCAc09AxFrHBuwszPDC9
         OoQCns4SYAuvcQZGPqXwwaphRZOf683QGUthzDsE68pJuOaNbSrxwBXO9rqAC6ORdGyo
         wS8YAmQMbW5HwLP5w81FcMFQuUiGoCQYKjsDlH7ViCIxKy2Q5WywPc64aaeFm3EoDJMy
         1ZHg==
X-Gm-Message-State: ACrzQf1HsdRmu4VDvLbgIXk6/5w1p+aIfHRDfPxYjVrVQV3e3KrSBX42
        sS+0qEnDwFuxCo3M99GbAz+P81kfOQpA9A==
X-Google-Smtp-Source: AMsMyM4dp8Rn/vPvtUIz3MTLMt+d5SVMhuklDye03Du3pK5Eo9cJNxhVmsVaSJsLxgXoIxYhkvL1Iw==
X-Received: by 2002:a05:6e02:1749:b0:2f6:9928:f1d with SMTP id y9-20020a056e02174900b002f699280f1dmr5136346ill.52.1663967123806;
        Fri, 23 Sep 2022 14:05:23 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k5-20020a056e02156500b002f6365aae11sm3383074ilu.87.2022.09.23.14.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 14:05:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     Dylan Yudaken <dylany@fb.com>
In-Reply-To: <ec3bc55687b0768bbe20fb62d7d06cfced7d7e70.1663892031.git.asml.silence@gmail.com>
References: <ec3bc55687b0768bbe20fb62d7d06cfced7d7e70.1663892031.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next] io_uring: fix CQE reordering
Message-Id: <166396712274.501845.6515930526000088106.b4-ty@kernel.dk>
Date:   Fri, 23 Sep 2022 15:05:22 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-355bd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 23 Sep 2022 14:53:25 +0100, Pavel Begunkov wrote:
> Overflowing CQEs may result in reordeing, which is buggy in case of
> links, F_MORE and so.
> 
> 

Applied, thanks!

[1/1] io_uring: fix CQE reordering
      commit: aa1df3a360a0c50e0f0086a785d75c2785c29967

Best regards,
-- 
Jens Axboe


