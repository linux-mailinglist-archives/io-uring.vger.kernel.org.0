Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E487A5AADEC
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 13:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbiIBL54 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 07:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbiIBL5z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 07:57:55 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E694BD779
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 04:57:54 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id x80so1822315pgx.0
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 04:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=y0vSBbR3dCyD6AMy5/WJgQxgCQS/LghoP9XD65ke+ss=;
        b=KD/CeF8GTc6X4IKBV+bISNz3i3ZvwFuAGr7HSsTqxZ5AY5415j+Nib5Ipu3OOpuQrX
         KLGCieMI+b9CqIqoYIio7m7pb+lZJ+kpOLHHJP2lcDhpY+Eu/OEAJLimMLT0A8+f8ZEV
         NAtxlCAX+rvgrzfMUekRlQgyOFryL2JRquuy5RH2bs2AHUE533vz3jL/04fViV3ghmqv
         kztwc1uVCutiNrBpbLbS0JepVJi9fcOsO2KxJqd96FP8uXR/2Kg18qY1vS7h2WbRVYxa
         ylN1rQp1c5yinVvWFEcn5A5CiZWZlOhnHipy+k0ndKm6WC+FZ3clrfD67RSGw65AUeP5
         j4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=y0vSBbR3dCyD6AMy5/WJgQxgCQS/LghoP9XD65ke+ss=;
        b=slESfYJU46bhQMs6GekyvhoYIfanOZTdCmXq7wfQ4pahYI0Fp5Xi2vvU4EESA2j5J2
         u3/QYv4yXLXgrQOFUW6DXmiQMiqim5j3jXWS0/VE5jWUJmnIl+U+5I1orzjmKezIChJz
         qCjP2WCMGoYdJbbOyWCSygiOcjGQLfpRUMOPg4tDuzFq0mgx5PLJpljdKcWygB/Yjjv0
         S/AcbZjvPlaqE3/iT7c3z17MumlA0Vn8bFnKSBHbW/EK3yc3IiuAMUs9cxiasaZ4NUhc
         yCRi/2D8Sf/cHiUnAKD48oZ+ZwAJ2QrP0QBo/NNUn0UEg4DNoXhvsxImfBF6FLfOkH/A
         RC7Q==
X-Gm-Message-State: ACgBeo364N8PMQbEo8eC2qyi3Wfzn6GMuF6H7HhOrs9BWdyLk2CHj703
        2QUZJc9lJduF8hVvgYtgAbRHW/A1Cl4MVg==
X-Google-Smtp-Source: AA6agR7Pdt3gBsJcI2vX58T+nIy653RMmoE9iHW+j/zA5HxGEwLwpKpvpco0pcbAaLqINh6qXBIxJA==
X-Received: by 2002:a05:6a00:1952:b0:537:1bb2:8451 with SMTP id s18-20020a056a00195200b005371bb28451mr36538456pfk.77.1662119873488;
        Fri, 02 Sep 2022 04:57:53 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s64-20020a17090a69c600b001fdc88d206fsm1300992pjj.9.2022.09.02.04.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 04:57:53 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Dylan Yudaken <dylany@fb.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Facebook Kernel Team <kernel-team@fb.com>
In-Reply-To: <20220902071153.3168814-1-ammar.faizi@intel.com>
References: <20220902071153.3168814-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing v2 00/12] Introducing t_bind_ephemeral_port() function
Message-Id: <166211987247.16298.10607898123162284613.b4-ty@kernel.dk>
Date:   Fri, 02 Sep 2022 05:57:52 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 2 Sep 2022 14:14:53 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi,
> 
> This is revision v2 of "Introducing t_bind_ephemeral_port() function".
> After discussing an intermittent bind() issue with Dylan, I decided to
> introduce a new helper function, t_bind_ephemeral_port().
> 
> [...]

Applied, thanks!

[01/12] test/helpers: Add `t_bind_ephemeral_port()` function
        commit: 0a2d0af5c1d7daa77bacc203d28a7a79662a928e
[02/12] t/poll-link: Don't brute force the port number
        commit: 6341145b6fe368d123ced2ba9857b3105673f644
[03/12] t/socket-rw: Don't brute force the port number
        commit: e0f0f04de43447c69f442532f5c4d72e9a833481
[04/12] t/socket-rw-eagain: Don't brute force the port number
        commit: 156ef697a9af0efd2e2e0d210de43e45e620fc76
[05/12] t/socket-rw-offset: Don't brute force the port number
        commit: ac7f81db44fc658bb7b99cceb1bee738890a317e
[06/12] t/files-exit-hang-poll: Don't brute force the port number
        commit: ce419aa629af36c0e0b19c155ef385e58bd8f9c8
[07/12] t/socket: Don't use a static port number
        commit: 875630a00f64ede24bf3cd7b3df4a37c45de65e0
[08/12] t/connect: Don't use a static port number
        commit: 7ce01375835e57a47c46be9646f773be1a8d8c3c
[09/12] t/shutdown: Don't use a static port number
        commit: 4736c9392bb910ae5a7d965f1019070864f831d3
[10/12] t/recv-msgall: Don't use a static port number
        commit: 2f8d4bb4259c6e3b6c519c03385c86f14e619ed9
[11/12] t/232c93d07b74: Don't use a static port number
        commit: fab19e78737fd65a411a446b848d427af6706c0e
[12/12] t/recv-msgall-stream: Don't use a static port number
        commit: c93f347ccaeb68c1aa4b377658555f0c7c2576b2

Best regards,
-- 
Jens Axboe


