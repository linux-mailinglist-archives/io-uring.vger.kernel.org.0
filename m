Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DA46B24D2
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 14:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjCINCF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 08:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjCINBi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 08:01:38 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F64E166E1
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 05:00:29 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id i34so6605372eda.7
        for <io-uring@vger.kernel.org>; Thu, 09 Mar 2023 05:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678366828;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u5aYy6zEOXXcfZThmM4brDwceB8RifC5tRBobqHx5FU=;
        b=GnkhaRGOFOr+Gj1X9pXA3zspUS7I9RStrU+2p5bCH/1EYgDhBbH90wUkvxN23jBzir
         V9hlmt+EJtXblQTHrxXk6jmR8qi6L3RSysKbZwF6RHvqVlthMp2315a6MXXDuXMqRrwg
         tP1EYIC2WvXc+r7aUu6xxA1rauqp8vqPkC4IGdNi3JMQC0Cn2jfw6z8xf6aDGoqTPsl2
         PZrxd6u+HB4xM6st3VOs5KwXi5EfdMR0zgjSMcYYcu93/U20VrLVBKA5uwv9FWsSorFX
         PNdqiSvUlvEU7ku2BfdWWllNaSfK5kjAVx3T0N46u1Kx/kTYuNg24bGeqtTDat68CypQ
         xA4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678366828;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u5aYy6zEOXXcfZThmM4brDwceB8RifC5tRBobqHx5FU=;
        b=Ro99+WI7jryrxqXuKm1bk235nlH8wG9hDlWnOEiICZlM39n3nwmrauD0lBwBwZw8Km
         FEfOpHJccnBlEVCv0UWH1FsWfLW/ErvmJPK8xOZUvznDtPUWfphGACiSAju5SnVZWsrQ
         iJLOzB19TMMrHFPNZBt/giHK787JHBM+mt6f0lNsioPyeALeknODLIov2Xgd4TeqOYvN
         u+YYxJb7/KssznMlnaNQQP+KTv629p0aNy3n02kWSSZvsEL45ch/alnm9i1JwGwlMxDU
         nRvUyZcZwLiCDk1zzBQk+zX8iGdha2sDjwtQo84s7i89XNfc0wFyBev85CoA6EwOeSss
         gnKw==
X-Gm-Message-State: AO0yUKUKT4JW0BMO/DjncgzPS+JBg07kviv/JmGvCxg54Ew3d5NmWPXB
        uv0Mn3X0C4C1swyk0DJvI4I=
X-Google-Smtp-Source: AK7set8EGXdOty5wnAxmkKCvsO7fuhuTitUF1GRid1PcGCLd9mEhNaTsS0RoIBG3ZhLffuHrqYRQfw==
X-Received: by 2002:a17:906:6ad1:b0:8eb:27de:240e with SMTP id q17-20020a1709066ad100b008eb27de240emr21862897ejs.13.1678366827812;
        Thu, 09 Mar 2023 05:00:27 -0800 (PST)
Received: from localhost ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id fw20-20020a170907501400b00914fec9f40esm4417641ejc.71.2023.03.09.05.00.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 05:00:27 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 09 Mar 2023 14:00:26 +0100
Message-Id: <CR1VDVQPMRQ7.3GGCJ11TF4621@vincent-arch>
Cc:     <axboe@kernel.dk>
Subject: Re: [PATCH v1] io_uring: suppress an unused warning
From:   "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To:     "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>,
        <io-uring@vger.kernel.org>
X-Mailer: aerc 0.14.0
References: <20230309124758.158474-1-vincenzopalazzodev@gmail.com>
In-Reply-To: <20230309124758.158474-1-vincenzopalazzodev@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu Mar 9, 2023 at 1:47 PM CET, Vincenzo Palazzo wrote:
> suppress unused warnings and fix the error that there is
> with the W=3D1 enabled.
>
> Warning generated
>
> io_uring/io_uring.c: In function =E2=80=98__io_submit_flush_completions=
=E2=80=99:
> io_uring/io_uring.c:1502:40: error: variable =E2=80=98prev=E2=80=99 set b=
ut not used [-Werror=3Dunused-but-set-variable]
>  1502 |         struct io_wq_work_node *node, *prev;
>
> Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Please ignore this patch I just send the wrong v1.

I fixed the mistake in the v2

Cheers!

Vincent.

