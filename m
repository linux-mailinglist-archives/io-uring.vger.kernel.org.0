Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C4E6B2BAD
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 18:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjCIRJa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 12:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjCIRJI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 12:09:08 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833494DBC5
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 09:06:12 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id da10so9816692edb.3
        for <io-uring@vger.kernel.org>; Thu, 09 Mar 2023 09:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678381571;
        h=in-reply-to:references:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSRvbAjNjKcTxZr3/+sdwRTMq2TB+7EUDzoJWinyfg4=;
        b=RugRaYdYHLppZHFucvDknmw3bK7tIXTO2aJPYAlGQV4eBC0aN9gy72y+z3CnQfr9oB
         2XRqlnsqvyK7Jd+xOqeHU9mHLjI3oIyczlDx+p3M5ynPIMPJcss8ruHliOexSM0zz5GL
         ZLKtS8coK/6Mm8918drhtRc0/dbMkc9r0Z8WGLZpYlM4gxRdTKZswZ8y/6+L3au7Bc25
         Ftqcru9HBOv83Q2fdfvFnMC0Am81QZPfgc9+e1sShFHZ7cxSmWmVdg3x0i82MkaWsaBD
         8PkRpjA+HxwpfQg5F7CXhw0UGpV83shr7D0Xb/YwIyUL0MNQzY9a5eOhcyISTWXjUGUx
         18Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678381571;
        h=in-reply-to:references:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gSRvbAjNjKcTxZr3/+sdwRTMq2TB+7EUDzoJWinyfg4=;
        b=4sOWbtYVGEqnJLAHgd8QbsABthUYGMliLlIF3+VLopXDpz6YQnRM48yCSRHB4SGbAv
         GpskrI83sU8nZ4IibXy43pxy8odMnlBTvd4DrvJuJd4jh1Way72vj3yOH8NIOzNwomkX
         vnu/pCPSwISxV+KxmJlaCenbZwnCLP0G1X88iQoUVM2htmI+M0b2zRCCypi0qLUdvaiF
         h6bl8eMlwGmBddBYVrYeJfI4XU5mPiGUQlzTQAYwFfeTs8+V3EONCoo8ZGirIl2dEdS8
         qL3KLPoabo15NfiCBpFUAt9uXnQ5tpdg3Knyep+AEo19zHoMuYPNYlZ0etX3aVgxThms
         XMxw==
X-Gm-Message-State: AO0yUKWlQOJmXMjmZ6lhFWunLthi6DaODBPdntdWHo86Havl/YND2VoF
        zhresUCqMs4cJu6OV4wzumNjL2WuVOxpUA==
X-Google-Smtp-Source: AK7set8BSwJIe3Uxp9tKtOiDsY/BZG05xapf35/OJM8gKvfFX2KgyI0Klaawq7mMTUcB3XES/LNorQ==
X-Received: by 2002:a17:907:9484:b0:886:7eae:26c4 with SMTP id dm4-20020a170907948400b008867eae26c4mr28744583ejc.5.1678381570950;
        Thu, 09 Mar 2023 09:06:10 -0800 (PST)
Received: from localhost ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id l5-20020a170906078500b008e1509dde19sm9043326ejc.205.2023.03.09.09.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 09:06:10 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 09 Mar 2023 18:06:09 +0100
Message-Id: <CR20M0PWOJZM.2KMRHEWFCKY5J@vincent-arch>
Subject: =?utf-8?q?Re:_[PATCH]_io=5Furing:_silence_variable_=E2=80=98prev=E2=80=99?= =?utf-8?q?_set_but_not_used_warning?=
From:   "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To:     "Jens Axboe" <axboe@kernel.dk>,
        "io-uring" <io-uring@vger.kernel.org>
References: <f2499a3c-5e15-eecd-2ee8-4a4e3ea4f9ad@kernel.dk>
In-Reply-To: <f2499a3c-5e15-eecd-2ee8-4a4e3ea4f9ad@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> If io_uring.o is built with W=3D1, it triggers a warning:
>
> io_uring/io_uring.c: In function ?__io_submit_flush_completions?:
> io_uring/io_uring.c:1502:40: warning: variable ?prev? set but not used [-=
Wunused-but-set-variable]
>  1502 |         struct io_wq_work_node *node, *prev;
>       |                                        ^~~~
>
> which is due to the wq_list_for_each() iterator always keeping a 'prev'
> variable. Most users need this to remove an entry from a list, for
> example, but __io_submit_flush_completions() never does that.
>
> Add a basic helper that doesn't track prev instead, and use that in
> that function.
>
> Reported-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---

Nice, I should pay more attention to the implementation
and maybe propose the equal patch before.

But anyway thanks to rework it.

Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
