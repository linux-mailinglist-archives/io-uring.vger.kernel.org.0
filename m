Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06735AA797
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 08:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbiIBGER (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 02:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbiIBGER (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 02:04:17 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D72ABF00
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 23:04:16 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
        by gnuweeb.org (Postfix) with ESMTPSA id 2F2B480927
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 06:04:16 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662098656;
        bh=5wv1FRwjtHTsyU5ym4Tk37flfqv47hU4ToU4RSBI7sU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=k5kLb6p04IKAhsqpvZkZHaFzxTeBlvizhbm7T2jIBCHyM/z3mdZfsEur/wEWB5FES
         9uJpYTcHKP+42gjejH8y7nbQHsIgxUqKE097P2XnnOb3ERSFzko26opQywS+e5NTSt
         g0CM7lNmxaoId63OmY/8SKw+qqCtT6z/Gc9SuMcQ3BacOie1ipefWqcIFX0ZWpHDz6
         OkbHrwIaFiNFyQ7CuEjSibIGb0hr/nbN1stJH8BbxSrJGCPld2ByL2ncBAVcvoXaCJ
         xjt+CFyklV7Y7lFm3e0c6PIl+Y890yQy27ZiPPhOQEsuA7PKAzOVmoVd9IBIZaSmRi
         kBIdG1vaeVDAQ==
Received: by mail-lj1-f170.google.com with SMTP id b19so1210936ljf.8
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 23:04:16 -0700 (PDT)
X-Gm-Message-State: ACgBeo20emqnQA45HxOcFlNNXvx3trz6EoQtA7Rf+uL/7SZb7FzNzCHm
        m+nvgqpZLLuj5RV0bDe+VBNJBs+avei3f8ss9ls=
X-Google-Smtp-Source: AA6agR7T+SHU2sG4BKVImWbni4dx665N8fFyyMZeXM1hlO7xRCc0dVy1u/D0AqBOke9bcLpAq+jug3SYm+g9vcNIoJQ=
X-Received: by 2002:a05:651c:b2c:b0:25e:6e68:ff51 with SMTP id
 b44-20020a05651c0b2c00b0025e6e68ff51mr10315002ljr.349.1662098654338; Thu, 01
 Sep 2022 23:04:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220902011548.2506938-1-ammar.faizi@intel.com> <20220902011548.2506938-3-ammar.faizi@intel.com>
In-Reply-To: <20220902011548.2506938-3-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Fri, 2 Sep 2022 13:04:03 +0700
X-Gmail-Original-Message-ID: <CAOG64qNCEss+i-MQV4gJjZh4Eun1o0U1E2WcFrgeg1ifjUMo6Q@mail.gmail.com>
Message-ID: <CAOG64qNCEss+i-MQV4gJjZh4Eun1o0U1E2WcFrgeg1ifjUMo6Q@mail.gmail.com>
Subject: Re: [RESEND PATCH liburing v1 02/12] t/poll-link: Don't brute force
 the port number
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 2, 2022 at 8:18 AM Ammar Faizi wrote:
>  static void signal_var(int *var)
>  {
>          pthread_mutex_lock(&mutex);
>          *var = 1;
> @@ -80,45 +81,37 @@ void *recv_thread(void *arg)
>         ret = io_uring_queue_init(8, &ring, 0);
>         assert(ret == 0);
>
>         int s0 = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
>         assert(s0 != -1);
>
>         int32_t val = 1;
>         ret = setsockopt(s0, SOL_SOCKET, SO_REUSEPORT, &val, sizeof(val));
>         assert(ret != -1);
>         ret = setsockopt(s0, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
>         assert(ret != -1);
>
> -       struct sockaddr_in addr;
> +       struct sockaddr_in addr = { };

move this variable to the top plz, with that fixed:

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

tq

-- Viro
