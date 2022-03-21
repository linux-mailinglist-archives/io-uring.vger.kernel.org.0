Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9064E269C
	for <lists+io-uring@lfdr.de>; Mon, 21 Mar 2022 13:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347057AbiCUMfK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 08:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347245AbiCUMfJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 08:35:09 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F1819C02
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 05:33:44 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id kx5-20020a17090b228500b001c6ed9db871so3927285pjb.1
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 05:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=DvpKRhuqGuhwCDsD6Yz3o7Zcv4FeXWHhYH+HXBxdrb4=;
        b=LlOSTCpKo4f8MBEHPsESb/6Jcpsr+R7Gb/ZWrAwI55SQSnPD/I6GFobi9ZTD0GkLNM
         U1EBgQEd6VwYNd4xPsJ1QTKUhcoBOQmAyyzVfjIbZFV9BA8PSs9vgP5JWbOEC1WIrDtS
         4OFaBDomXAlCT17nMGvg478ZCToEtgYgxsH0nZpu6kPUwUWRpJ4QwOaCK+CKU0Ne5oJJ
         TgvoNrdLZALH1Egt2O5gm3ebYVb8cVrm8TRdJtbNkcDklX8B2ErEewEiNm2K8cKTV7Ca
         Uwiv74vtvMOIiiPGImY9zK2r1TAiin2qF3IcYPW4yiTGVIG0bzUyyFA0ybAwFI7ISpWo
         pSFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=DvpKRhuqGuhwCDsD6Yz3o7Zcv4FeXWHhYH+HXBxdrb4=;
        b=prIpAtTkRR01PBKuqqU22f44L6MOq4Jbi7jiOffrjR704vTA9u9W/2V6YE5m7BoYgs
         YmvzrNfipRgRdSv2NNpJTcvI3HMC7slN+TuNkcgA0VOzYpogGs5+nyOo2eopi/M6twPD
         xFkGq2It7C+hHCB+T/LWrlUcR3WWTy+EM4JEuTFCClo0QYHeyC2C8iW/l2/Wc8AHgH4V
         82y4lp7v/9NhHiJDEPs9EBu3yzkfSFe1JSDpameMpj29cGu+MJZRSfkgbXOHuTBy0y9u
         9/HjJ2HCekQLh28tnBqJGDOnHNmkri1ZcPl+m2MflT0nbBcily51cz/5M0nJLYt7eVQk
         B7cw==
X-Gm-Message-State: AOAM533pwHYBeJ4EA/Rp0YQretUHY7hv/4SjiNYOBo1FWsXg7BDchyd7
        7rvrHdEX64L8l/2MywLB4QGB2Q==
X-Google-Smtp-Source: ABdhPJyyp6j33Q6qpZak4OO8boVxaVNEJl2ceBxkPQXnOYV++jX1vXWbBj48UenATF1Iq+621rIQKQ==
X-Received: by 2002:a17:902:7802:b0:150:baa:bc1a with SMTP id p2-20020a170902780200b001500baabc1amr12730358pll.110.1647866023985;
        Mon, 21 Mar 2022 05:33:43 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h16-20020a056a001a5000b004fa343c2d0csm16097049pfv.136.2022.03.21.05.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 05:33:43 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Almog Khaikin <almogkh@gmail.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
In-Reply-To: <20220321090059.46313-1-almogkh@gmail.com>
References: <20220321090059.46313-1-almogkh@gmail.com>
Subject: Re: [PATCH v2] io_uring: fix memory ordering when SQPOLL thread goes to sleep
Message-Id: <164786602316.7312.1156269365194554675.b4-ty@kernel.dk>
Date:   Mon, 21 Mar 2022 06:33:43 -0600
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

On Mon, 21 Mar 2022 11:00:59 +0200, Almog Khaikin wrote:
> Without a full memory barrier between the store to the flags and the
> load of the SQ tail the two operations can be reordered and this can
> lead to a situation where the SQPOLL thread goes to sleep while the
> application writes to the SQ tail and doesn't see the wakeup flag.
> This memory barrier pairs with a full memory barrier in the application
> between its store to the SQ tail and its load of the flags.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix memory ordering when SQPOLL thread goes to sleep
      commit: 649bb75d19c93f5459f450191953dff4825fda3e

Best regards,
-- 
Jens Axboe


