Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2A64FE642
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 18:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244550AbiDLQtZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 12:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238549AbiDLQtY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 12:49:24 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A748B53B50
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:47:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p10so423942plf.9
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=m87fq4MxHo3ZK8W+Fhnt2hiI8ALErz5L8bxnq3xNeuM=;
        b=TEfQpvA4rEg0cFiLjm4zBgaPekJZ6didl2HjTkuP+AGhLAdQPZ+PUracchZPi82SvY
         p30kmQsa5tCFZnkY+F4AUV7pv/BcqDPvX46vBGIrGAz5tgYA6gVM4LLK3KcEuo5VSRKP
         SvBtfszN3bg+87UTKyNxaMzGqP8byjAjmPp4udJ00Jc1Zc/sc4WQLe+FO/51KV5KS+Jt
         tho/6txjoiek6Tzhyj2sPrInJNwlJ2J2JPU6lSLrppcG42iLHx/Wv8nx0FyQag0Tj4Sk
         3PhhmJTh/17Gz5UxBelxFFh4RaQk56Hf+nX13j3j1XUM2jjo54B0Ei4YhjHrvnbNKVjo
         dcuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=m87fq4MxHo3ZK8W+Fhnt2hiI8ALErz5L8bxnq3xNeuM=;
        b=LqiEwrkPKgFFsvgRt8cZLEkLpEEAErtEp8msVXAhSfRCblVpp4ZetYm0rO61ysaOrz
         2DTFUw3o/jMhOwj2UQI55csgzCQP7aY0Ds5IAPYq7ymwzBJBMriqsuirZ8952ypR+Fp5
         EVQh0kj9t69lMsUei/Gt8m7/QhL6NXsuVVR+ocxwUpd7D0ZYRf5jqQ1TwPIlo3gxR44S
         jUeMuG/85/UFR69JF2D1sbWUmR6F5swfTIbhbnnFxlyFb7IawTniVmqMixuxNUBNao1P
         Cvn711AEXT+qGELzQ7OeGYLMedGtE2FHzDS0N3hITL4q6SiDx6a+iiv0jZlqbwaofnlI
         oYkw==
X-Gm-Message-State: AOAM5307exm+Y0pRGnnH4trZDBP7ypYURw54FZ/0mLjctZ8jv/ojAjdh
        Z2yJCVpb+pJHXTbkDRVNr5l9AyaBXPVxj1cN
X-Google-Smtp-Source: ABdhPJwrkL8ApiY9hs8F2QsmALSzf71PKJsl3ND5OILS4JiVHvv89e8lY2iLCwKNxrthXbj3O6ubJA==
X-Received: by 2002:a17:90b:1186:b0:1cb:8e59:2a35 with SMTP id gk6-20020a17090b118600b001cb8e592a35mr6062334pjb.95.1649782025911;
        Tue, 12 Apr 2022 09:47:05 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i2-20020a17090a138200b001cb6512b579sm18741pja.44.2022.04.12.09.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 09:47:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <cover.1649771823.git.asml.silence@gmail.com>
References: <cover.1649771823.git.asml.silence@gmail.com>
Subject: Re: [PATCH next 0/9] for-next clean ups and micro optimisation
Message-Id: <164978202527.149933.3361512875935613287.b4-ty@kernel.dk>
Date:   Tue, 12 Apr 2022 10:47:05 -0600
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

On Tue, 12 Apr 2022 15:09:42 +0100, Pavel Begunkov wrote:
> nops benchmark: 40.3 -> 41.1 MIOPS, or +2%
> 
> Pavel Begunkov (9):
>   io_uring: explicitly keep a CQE in io_kiocb
>   io_uring: memcpy CQE from req
>   io_uring: shrink final link flush
>   io_uring: inline io_flush_cached_reqs
>   io_uring: helper for empty req cache checks
>   io_uring: add helper to return req to cache list
>   io_uring: optimise submission loop invariant
>   io_uring: optimise submission left counting
>   io_uring: optimise io_get_cqe()
> 
> [...]

Applied, thanks!

[1/9] io_uring: explicitly keep a CQE in io_kiocb
      (no commit info)
[2/9] io_uring: memcpy CQE from req
      (no commit info)
[3/9] io_uring: shrink final link flush
      (no commit info)
[4/9] io_uring: inline io_flush_cached_reqs
      (no commit info)
[5/9] io_uring: helper for empty req cache checks
      (no commit info)
[6/9] io_uring: add helper to return req to cache list
      (no commit info)
[7/9] io_uring: optimise submission loop invariant
      (no commit info)
[8/9] io_uring: optimise submission left counting
      (no commit info)
[9/9] io_uring: optimise io_get_cqe()
      (no commit info)

Best regards,
-- 
Jens Axboe


