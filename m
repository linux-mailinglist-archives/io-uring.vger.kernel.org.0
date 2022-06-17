Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BE154F519
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 12:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381697AbiFQKPT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 06:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381719AbiFQKPT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 06:15:19 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620206A06C
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 03:15:17 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n185so2067113wmn.4
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 03:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=/zEYo36DhibwN7ieMNT20OooMEvTx3/RIqNrPDigP0I=;
        b=M5JwTFzQ/4LEKG2+IqNBElAh0tfm9dILko66jEGhubYUiNfZj/zUcUwtEPNMt5cIm8
         rKttLWBQZtGnEducsNA2wOTWLkkFv0pV8SeeiKpvux5OF9xZD4BynQeYbi+pGAI4ZKk9
         QIkeDly4ViPfU+Ac4A98MeSzOEyDSwV9OAiL0kojk7g8UHumuqeCvU+HqHljke+1VXvo
         qTicKK3P4h9yaiko7fwMhUn8qOhMJfm+0oZid+Xhu4dkKNrd8iHEC5Nygvnu7cJdkcU0
         XB/SueyZ2svlemV27DqEhPlw5wmTiCNyiOGUGy1RSN65UZfx8WgH19Ktec39vfOxQ5n3
         D4NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=/zEYo36DhibwN7ieMNT20OooMEvTx3/RIqNrPDigP0I=;
        b=CDgpdQEKXz3ojg/oWHrj3T+4XR7peVuGm5lCtKQGbqcM2iGFNSJWh/SUnIjIh0nBDZ
         yuVBmYFrSb+0/Vld2WP+mZlyaf4GXNCSqk1EM4Li1jpM+bmwm4XH1KCfht/tnZ5ottMl
         AjnjuqDNksQvJ0ZdWbN2PEpk6jzMjwlGzG4E7siM1N4cbN/vOLkRuwNdRhnKOfFWplS7
         ++ELh9cyDTygB33kzqsLUuJOxUCXEgZQS47ARNGQxCtaSCWdi/7EK2l0Lcdmdc4P+dSF
         VrFmj4sSocGeQGLZr0tshTQejmWVJgRDbDi5TKzvkb89j+UsIq2NX9jDHrT0SXqcYLbZ
         VUaA==
X-Gm-Message-State: AOAM532YmmazOUVr9qwCKeApcIQImC0VdME1PH/5qpYJ3ROHXhDQMCj8
        YOUnXTeW2RW4tIVvtcXi4w1dOjVJn3RBng==
X-Google-Smtp-Source: ABdhPJzSHPzWCAFhmjtJ8rulREFRIzhcaZsMnMulfI0HBY6ocoki0uhEcWD2B4xNhZRsnaE9jhIoFg==
X-Received: by 2002:a05:600c:19cb:b0:397:51db:446f with SMTP id u11-20020a05600c19cb00b0039751db446fmr20110850wmq.182.1655460915484;
        Fri, 17 Jun 2022 03:15:15 -0700 (PDT)
Received: from imac ([2a02:8010:60a0:0:84d5:39cb:372f:d54])
        by smtp.gmail.com with ESMTPSA id r15-20020a05600c35cf00b0039c4ff5e0a7sm5089835wmq.38.2022.06.17.03.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:15:14 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [PATCH liburing] Fix incorrect close in test for multishot accept
References: <20220616162245.6225-1-donald.hunter@gmail.com>
        <1b7434f0-f06b-e659-33b8-f1cc4ab60dcc@linux.dev>
Date:   Fri, 17 Jun 2022 11:15:14 +0100
In-Reply-To: <1b7434f0-f06b-e659-33b8-f1cc4ab60dcc@linux.dev> (Hao Xu's
        message of "Fri, 17 Jun 2022 16:28:00 +0800")
Message-ID: <m2r13n1tql.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (darwin)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hao Xu <hao.xu@linux.dev> writes:

> Super thanks, Donald. you are right, we skipped the fixed multishot test
> by mistake, the exposed issue after your fix is caused by
> multishot_mask |= (1 << (s_fd[i] - 1))
> which should be
> multishot_mask |= (1U << s_fd[i])

I can confirm this fixes the exposed issue.

> Would you mind me to take this one to my patch series which is to fix
> this and do some cleaning?

Please do.

Thanks,
Donald.
