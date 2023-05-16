Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADE570504B
	for <lists+io-uring@lfdr.de>; Tue, 16 May 2023 16:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbjEPOOh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 May 2023 10:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbjEPOOg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 May 2023 10:14:36 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC80D55B7
        for <io-uring@vger.kernel.org>; Tue, 16 May 2023 07:14:35 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-51f405ab061so1402195a12.1
        for <io-uring@vger.kernel.org>; Tue, 16 May 2023 07:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684246475; x=1686838475;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cCxvGJajOXCMUGeHJZr6/Oyl9zRWStp7x7yawhzT6QU=;
        b=sGkGwfptGEfX2TcFtw52PNDHgWfDqqPwNnOO9EEvpAplpLrpJ/642P6u8YXz71N5q5
         DwroumVlR3PxNl8Mo4zdeQfBBNiH9ZSg7PsbsGuqcgr8kqOLOcqPFl2lizhN1SR8EYmM
         bgBn5oMM5EdQgeRhOMC1HMYZ/L5IZNZfReYWEc2cq9k2cIIwquLPL3XHW4ciC+r+7Cgm
         ACRR/4pavdBT0MptSdhryYBpiNuVbBZqUbuCIe1MqAN2R8nvca34wvqt4FuMU0o93tgv
         /JAcsxNZyA0WHMWt2pGZkOrLAmFlJlqnBNN9U0rZObO91KUemCJmz9x9Fo2mQemdT/XR
         kCCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684246475; x=1686838475;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cCxvGJajOXCMUGeHJZr6/Oyl9zRWStp7x7yawhzT6QU=;
        b=Eaqsq8K8mpQiSf9V+eRXUBMlFPyEapfIgquUL/kDcHQLquEllFoAmKE3GVVLDajVv1
         1E5V4RgIx9SVo/WO2pPlo/Qp+E1bEAfsN91iqYu3WQUwUieDYD6uvu6uYN9ltSgkLN/8
         KrC9GMrELqa0Jd1wpTLdcik5cAsNa2kQdwbKGBWid+lOyjO60ynI/IvIWAlf+N8uMK6y
         /s1qe3ycfru0lkbQ28WCtMdWSBdvDn9mtHD4DqwfALppvHA4nMbrNvNBQP6+/if+b+mR
         +FZFO7pKt9Q7b4Rz92CUqMg9B4UiW1DoEARoiHhhvbSA9kR/JHTg25aB+dW6ffceQnod
         4wxQ==
X-Gm-Message-State: AC+VfDx7vfV97sexe1W/p0F3Ms9TsIixEjBn1/usVGPsshLuVqZfilxD
        uIG4kus0H+gmhfwOxeIxNKOerQ==
X-Google-Smtp-Source: ACHHUZ4ArrQmcdldMUd/RhtEp98ANEbUxDowKAOxeDQn1K+i8+lUFT7CVOAvpGIl+9mbI6ehtzH9Lw==
X-Received: by 2002:a05:6a21:99a2:b0:103:9d9b:1ebb with SMTP id ve34-20020a056a2199a200b001039d9b1ebbmr4696510pzb.0.1684246475143;
        Tue, 16 May 2023 07:14:35 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id r15-20020a170903020f00b001a1a8e98e93sm15592351plh.287.2023.05.16.07.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 07:14:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
In-Reply-To: <bc8f431bada371c183b95a83399628b605e978a3.1682699803.git.josh@joshtriplett.org>
References: <bc8f431bada371c183b95a83399628b605e978a3.1682699803.git.josh@joshtriplett.org>
Subject: Re: [RFC PATCH] io_uring: Add io_uring_setup flag to pre-register
 ring fd and never install it
Message-Id: <168424647374.1741575.7066874860468744586.b4-ty@kernel.dk>
Date:   Tue, 16 May 2023 08:14:33 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Sat, 29 Apr 2023 01:40:30 +0900, Josh Triplett wrote:
> With IORING_REGISTER_USE_REGISTERED_RING, an application can register
> the ring fd and use it via registered index rather than installed fd.
> This allows using a registered ring for everything *except* the initial
> mmap.
> 
> With IORING_SETUP_NO_MMAP, io_uring_setup uses buffers allocated by the
> user, rather than requiring a subsequent mmap.
> 
> [...]

Applied, thanks!

[1/1] io_uring: Add io_uring_setup flag to pre-register ring fd and never install it
      commit: 6e76ac595855db27bbdaef337173294a6fd6eb2c

Best regards,
-- 
Jens Axboe



