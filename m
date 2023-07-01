Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5143D744615
	for <lists+io-uring@lfdr.de>; Sat,  1 Jul 2023 04:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjGACNh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Jun 2023 22:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjGACNg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Jun 2023 22:13:36 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D761731
        for <io-uring@vger.kernel.org>; Fri, 30 Jun 2023 19:13:35 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b3ecb17721so3751485ad.0
        for <io-uring@vger.kernel.org>; Fri, 30 Jun 2023 19:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1688177614; x=1690769614;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kiEujBdeHSVVbRIiHP015aapRPwiBMavvbLtyV99ci8=;
        b=vnm8IjNErcAIzUhaIQxZBILrCZpeBHFO83rhcK4cRYBs7Hb1xlUP4hXfAf89fuomm1
         TTKOYBny2JDD8p0aFfeKnHyfwGZtRzF9aYCq/9mViuWI77myYJ0xOOGJLIprY7jccYk5
         NV5DhlFy7xvcllvad/d6gFGOo5cC/CNfLJLNbc3xS9emGSybHmWNXt+bjaHOfi5tBAJp
         Ej9fQ829C0b43fAPOoXZGFjBzB4leQmAUEgUrzZpi5FETUxRi6xAQnLSby1oMe8lYE09
         U5WgZn7aVtSevL9dr8ppwla7gzj+3XENPBUPxrPFkGpDIflo/xLkI3pMBFXGZK4RMQd6
         sh8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688177614; x=1690769614;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kiEujBdeHSVVbRIiHP015aapRPwiBMavvbLtyV99ci8=;
        b=OoUNbqF/HNadQ6Tqv1HUKE51kZ2aQdoFZMkfwztNllTJUI0tYuWfQ1kHcwLyXCLk83
         vAaL1UiD8yx+6QZb1OCFHz9+9ToTRqr3Mnn4sBE/OUDQUfHmNGwLO8tnGoIgT/zwgDli
         SNp5PKcSCrCl53HNHSauP7EllDkJV6yBqja4jYgJGUBGzsbblgTubeiw9cKwt270xz6n
         /uKg/tjvmRzDvMD6cIpRBt6KKcYJ8RLekz+NdliPWLBHHK6UCc/ycu4mvMnSaFWwTCY4
         tjgNuBIEzSNYAlu4VRJ6IKiCWBDOIbQbqkY+ymz9UbbZr+Xoj9ZBqEgkW4ZHZg7sh5F5
         oq8g==
X-Gm-Message-State: ABy/qLYMHnD3oA+vCpyAFTLTHzK6NLmTJzikOUxPz3Db5nkG9+oGRzXh
        Kga46G+NSUC89cI2vmlZJU08kE/u/E4XXTTkyr0=
X-Google-Smtp-Source: APBJJlF4UZGkM3pohZKV9v80KrWF/+V+yTelhuq3kQpHobADisR0nr1Z4lZpDZbiQw7epTEFEWxt3g==
X-Received: by 2002:a17:902:d054:b0:1b3:ebda:654e with SMTP id l20-20020a170902d05400b001b3ebda654emr3800348pll.5.1688177614639;
        Fri, 30 Jun 2023 19:13:34 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l13-20020a170902f68d00b001b843593e48sm4710147plg.228.2023.06.30.19.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jun 2023 19:13:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>
Cc:     io-uring@vger.kernel.org, David Wei <davidhwei@meta.com>
In-Reply-To: <20230630023937.509981-1-dw@davidwei.uk>
References: <20230630023937.509981-1-dw@davidwei.uk>
Subject: Re: [PATCH] test/io_uring_setup: Fix include path to syscall.h
Message-Id: <168817761368.402689.10438716688443206254.b4-ty@kernel.dk>
Date:   Fri, 30 Jun 2023 20:13:33 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-099c9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 29 Jun 2023 19:39:37 -0700, David Wei wrote:
> >From "../syscall.h" to "../src/syscall.h" which is consistent with the
> rest of the tests.
> 
> 

Applied, thanks!

[1/1] test/io_uring_setup: Fix include path to syscall.h
      commit: b492a63713f0f0ac3ac677428de4f53a2df00909

Best regards,
-- 
Jens Axboe



