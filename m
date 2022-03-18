Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0778A4DD329
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 03:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiCRCmT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Mar 2022 22:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbiCRCmS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Mar 2022 22:42:18 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE8411BD8F
        for <io-uring@vger.kernel.org>; Thu, 17 Mar 2022 19:40:58 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id p5so2256803pfo.5
        for <io-uring@vger.kernel.org>; Thu, 17 Mar 2022 19:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=5KML22uVpd0gvcZvJ5obgsC0Ky21jYtwaTzQb1AQSmc=;
        b=A6qVW65Kd6nzjrpHZVdvX/VSmj5EtEt11JjjG3mOYzWxKV603PFQPrLs1w5Z45LHjC
         pdGC60MGOhZPPMHci2Vnhn+5venc3EMxmym57OGlrjZoromMtxe20HxTFed/5NxH4Vw8
         v7fHgf8POY6HVyasfGns5RqsYY4KUbk1hWeTcIbrARY3cgFrPufjJXxzqGFxxmzI/g13
         pHVDgWLlhwOUxrRgbYchwmPZ4Bly4z3Z75mqQlsz7VxzvayAW9EAsOOuaklluhm16250
         DyRNVVEXuiyRY+8Iip4slH+u0LvTWevYDkWRT4iH39qNm8k4WCAitp6vWXXYbJ+W+jYI
         /Msw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=5KML22uVpd0gvcZvJ5obgsC0Ky21jYtwaTzQb1AQSmc=;
        b=lntpZyxayN9JTzSJPrngKA9r5vs81/9haOwQjuNvZnYckY8KRKR52lpKF3mU6JLEve
         rojAvmWxN2/o6hHzuz4wbnISibaxsCNdUa+1RZenv80PaLcoxt4NW51z2BPP/8NYgtrb
         LCZqI9rtu/i3P6/nr7t5ixrZq+JniLLUGgdjs8KBHyGbVZvtji6EWLRmA4m1afh9mt7B
         Ov2FfTaAgKJRLUElhZabjS7Zmr0mFZcL0jOzAhNhTp1g3djH2WKRhkOjKY8spbHBPzQD
         NYl/eok3oFYWLv3JP2EiyB/OIum8AZuxUAkIE0Ai0DTxcxqUjfe7eO3AP9K542WyMu6Q
         CYMQ==
X-Gm-Message-State: AOAM530PJq9qMawu0rpVbagYarqqy4PshSkjw/DFjOP4jvJxcmhnhUMF
        cZ/xSOdbIGxhDJ8JD8/eeehkuZqYXNcjo9qX
X-Google-Smtp-Source: ABdhPJzBiY2w1J/JgZQePWouxL3mImRbCPB/mc2zOID9qLtAaxK/HSB7adDQPw1zy8QdwhI//w7Djg==
X-Received: by 2002:aa7:8b14:0:b0:4f7:83b1:2e0b with SMTP id f20-20020aa78b14000000b004f783b12e0bmr7690468pfd.37.1647571257836;
        Thu, 17 Mar 2022 19:40:57 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b13-20020a056a00114d00b004c122b90703sm8083514pfm.27.2022.03.17.19.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 19:40:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4b6736f6da309756027b00f3b294417eb1832506.1647530578.git.asml.silence@gmail.com>
References: <4b6736f6da309756027b00f3b294417eb1832506.1647530578.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] man: clarifications about direct open/accept
Message-Id: <164757125702.111082.18333308307485650186.b4-ty@kernel.dk>
Date:   Thu, 17 Mar 2022 20:40:57 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 17 Mar 2022 15:23:34 +0000, Pavel Begunkov wrote:
> Direct open/accept replaces files for slots that are taken, so it's not
> necessary to use sparse file tables. Update on that, mention the
> replacing mechanism, and add a note about possible compitability issues
> for raw io_uring API users.
> 
> 

Applied, thanks!

[1/1] man: clarifications about direct open/accept
      (no commit info)

Best regards,
-- 
Jens Axboe


