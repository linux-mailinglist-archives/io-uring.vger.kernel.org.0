Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0AE50680C
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 11:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241742AbiDSJxY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 05:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347871AbiDSJxU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 05:53:20 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E5D1EEF0
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 02:50:38 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id i27so31729695ejd.9
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 02:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=P1PookOQAhpqTbJA6Y7o2nTVnjrot1k+A+mzdGOwzqs=;
        b=UNGq2PUxr7M845xKNOgCehohn2ZdCWCVa5mgBhplfYbRIuxSkkT6jIiNlKUTJAbL0o
         hs5AUq7kbsZZmRr7lP5ku0BZs5Bv4PQRVnwUMnJy4eeurwavwfmtoTF85zXnLQ1ck5oA
         fSnz95AnmKIkZ5HJDR6U91+t4iU1knm8FMb4qs8QqloAMBv4H/El3fh82HvH8EXqcv28
         s3+w8cRHiNBh0oDYFZFC88G+cs6TIlW+Mtyzrt4nLk17AHEOG9VGBOntgs0i5ca+Ke1a
         H7q/YfoeM30Aa1XVmtWX+Xrg1Ep7shUSqmRDet+yRO4IGLos19dr6xYKWP/wS4E08Oqg
         fHlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=P1PookOQAhpqTbJA6Y7o2nTVnjrot1k+A+mzdGOwzqs=;
        b=Sk4VsGk4gILyPCpB8s3UPd3oofqSAJ6eBQUWEXHje1Uy8nI3Ig8/krp+/FZFue1Rbe
         QjaymMLAhmu9XLYFEruc+/1Wn1U+wPDQdvgdSqRpiGhN6QYnu/NWNqQpPqIewLvGmwLM
         gdVokRFouXgZe2laId56T1TiIlAJ7zj926P65QJrVzWPa5qjzydTNqDzR1npb11oFbkX
         p/5H83RSupFMAbbuK2HbTQT1bIpwUFUwkuJ8LlT7uT2/EpOtYhq1gd+UPdHjzOkJlRih
         E3FX9Tfx/mk9Zb6jvHXHTg3eK1KdkzmeKuZsDjlYT2mcOuFwb0arq1prf6D78cOKZsRt
         JEuw==
X-Gm-Message-State: AOAM532YkJ7i7G1W/RXHhk8/yW37JPp7Ae73ulq5W/sOaUVTZdNTTdrd
        6znPROIvBPzZSRJu+pjEn07AyWfGYM3NwkMFVw==
X-Google-Smtp-Source: ABdhPJyctUhCsU4ETF3xKblYMleUht5OfAZijK8k9pYSNR97gnzprp2l4RD3Q4nCKtgh1S64byi7kokUjSKTnRGf1Nc=
X-Received: by 2002:a17:907:6d0b:b0:6e8:b449:df70 with SMTP id
 sa11-20020a1709076d0b00b006e8b449df70mr11994303ejc.533.1650361836915; Tue, 19
 Apr 2022 02:50:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:907:1622:b0:6ef:7798:72f7 with HTTP; Tue, 19 Apr 2022
 02:50:36 -0700 (PDT)
Reply-To: orlandomoris56@gmail.com
From:   Orlando Moris <officepost088@gmail.com>
Date:   Tue, 19 Apr 2022 09:50:36 +0000
Message-ID: <CAG_JqcdZnci5ZvO6sEZu=XK+e=PDGcsy7MYUj3f-i0k9adPQtA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

2YXYsdit2KjZi9inINiMINmK2LHYrNmJINin2YTYudmE2YUg2KPZhiDZh9iw2Kcg2KfZhNio2LHZ
itivINin2YTYpdmE2YPYqtix2YjZhtmKINin2YTYsNmKINmI2LXZhCDYpdmE2Ykg2LXZhtiv2YjZ
giDYp9mE2KjYsdmK2K8NCtin2YTYrtin2LUg2KjZgyDZhNmK2LMg2K7Yt9ijINmI2YTZg9mG2Ycg
2KrZhSDYqtmI2KzZitmH2Ycg2YTZgyDYrti12YrYtdmL2Kcg2YXZhiDYo9is2YQg2KfZhNin2LnY
qtio2KfYsSDYp9mE2YTYt9mK2YEuINmE2K/Zig0K2LnYsdi2ICg3LjUwMC4wMDAuMDAg2K/ZiNmE
2KfYsSDYo9mF2LHZitmD2YopINiq2LHZg9mHINmF2YjZg9mE2Yog2KfZhNix2KfYrdmEINin2YTZ
hdmH2YbYr9izINmD2KfYsdmE2YjYsyDYp9mE2LDZig0K2LnYp9i0INmI2LnZhdmEINmH2YbYpyDZ
gdmKINmE2YjZhdmKINiq2YjYutmIINmC2KjZhCDZhdmI2KrZhyDYp9mE2YXYpNmE2YUg2YjYp9mE
2YXYo9iz2KfZiNmKINmF2Lkg2KPYs9ix2KrZhyDZgdmKINit2KfYr9irDQrZhdmF2YrYqi4g2KXZ
htmG2Yog2KPYqti12YQg2KjZgyDZg9ij2YLYsdioINij2YLYsdio2KfYoSDZhNmHINit2KrZiSDY
qtiq2YXZg9mGINmF2YYg2KrZhNmC2Yog2KfZhNij2YXZiNin2YQg2YHZig0K2KfZhNmF2LfYp9mE
2KjYp9iqLiDYqNmG2KfYodmLINi52YTZiSDYsdiv2YMg2KfZhNiz2LHZiti5INiMINiz2KPYqNmE
2LrZgyDYqNij2YbZhdin2LcNCtiq2YbZgdmK2LAg2YfYsNinINin2YTYudmH2K8uINiMINin2KrY
tdmEINio2Yog2LnZhNmJINmH2LDZhyDYp9mE2LHYs9in2KbZhCDYp9mE2KXZhNmD2KrYsdmI2YbZ
itipDQoob3JsYW5kb21vcmlzNTZAZ21haWwuY29tKQ0K
