Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB797093D5
	for <lists+io-uring@lfdr.de>; Fri, 19 May 2023 11:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjESJko (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 May 2023 05:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbjESJkI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 May 2023 05:40:08 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD5B1BEE
        for <io-uring@vger.kernel.org>; Fri, 19 May 2023 02:38:54 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-510b869fe0dso5232343a12.3
        for <io-uring@vger.kernel.org>; Fri, 19 May 2023 02:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684489069; x=1687081069;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MykftQ9vqsw04OqgCh7rrq9rV2ToZv4V/lyH2OaLw/w=;
        b=i+OKJGE4Cc6Thh0Ue19f3PsB2e1ClXh02qPDtCxBG1sYqZJEIro+1Ox3xClnCsa1JU
         nmkOPIoPx8TPyh+G2jZZhmOaWxvyJSIIpxZocCVfQwOaYK96YpWY4N1O5UfNJ2h1I2cL
         8JeOoaTHn8J+sZ6c5bNUCu25oaF4EwGa/PCdW8fzx2PqznSJvbDPFJ/EODMtQvn4m2qM
         1/9xrWSpNecEv16fP6IhwMCTVDLKiVAFa1wYyLBOhDpWWaPYQBKWyCazN0N1Wb0s3Ao6
         qSULUbrwZc6DOTT+eTxfhdTJiP9LyutNrN9QWGOBJYH2LtyxU3HPUZ79o88g8Va2ak+T
         2mAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684489069; x=1687081069;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MykftQ9vqsw04OqgCh7rrq9rV2ToZv4V/lyH2OaLw/w=;
        b=MsibugzXIV4v9d1QMGZ76W+JWaFEC1OGrllscOp2WP8/coWr1UOwfxu08cTWD6YMT6
         XFrHYOCzet11lRF7UO4kzDX2d2ghdU3KU205JjVTb+D9ba72FSzcho0l7Pzakusg+V9A
         Zg8Ol4UlVQnthxf0/yIB2IPY1tVVgmOiog0idXv+JjMAcOBhAg+ryqbaUIapElz8HK0A
         vlQ0D68b0wMJ2XfffczsxItaqd0CYpH4TvsZZkoGgSVYEzarouGIDe+iQmfhP08GFkJ2
         6NOoqOHP5DSebMGBs6m68fOTAaDsxcUnoRBwoUR6iqRbWS/qTmpH6yxS0Wmqdehqi+IS
         2+Ag==
X-Gm-Message-State: AC+VfDyNnPGQQt5rquluGVyP28O/s1H+N9P98CbmuwNuOF/vm443TEYv
        KDMRZbcE9pLIO7DMR3fp35GwNeaX3x3W6aP0LrQ=
X-Google-Smtp-Source: ACHHUZ4zQwqn4fjiwemV2BOFOkr+nnTqF0kF+CPQA8hJaG2S70dDG9SQI/mhZcZWhe78GcA1o7Ac7UNaKhu+OTWhzU4=
X-Received: by 2002:a05:6402:160e:b0:50b:c72a:2b26 with SMTP id
 f14-20020a056402160e00b0050bc72a2b26mr1089418edv.9.1684489068463; Fri, 19 May
 2023 02:37:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a98:af92:0:b0:1cb:dafe:30ff with HTTP; Fri, 19 May 2023
 02:37:48 -0700 (PDT)
Reply-To: ninacoulibaly03@myself.com
From:   nina coulibaly <regionalmanager.nina02@gmail.com>
Date:   Fri, 19 May 2023 02:37:48 -0700
Message-ID: <CAE4etd4QJhtnLGA=LNsq_9m3z070W8+e5TcwB7QFKTV3Ba3YYQ@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dear,

Please grant me permission to share a very crucial discussion with
you.I am looking forward to hearing from you at your earliest
convenience.

Mrs.Nina coulibaly
