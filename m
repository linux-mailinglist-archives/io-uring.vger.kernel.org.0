Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741D5600D54
	for <lists+io-uring@lfdr.de>; Mon, 17 Oct 2022 13:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiJQLCl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Oct 2022 07:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiJQLCM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Oct 2022 07:02:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E4F5FA9
        for <io-uring@vger.kernel.org>; Mon, 17 Oct 2022 04:01:02 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id q19so15451753edd.10
        for <io-uring@vger.kernel.org>; Mon, 17 Oct 2022 04:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h6TAvh2KhlPwZbZl975on9cPhNtC4Qh0FGtOTBu2EFs=;
        b=eOalPsyfympz8WSVoHfMi4khKJ794quyeNOvn8dTC/R+ROURo4mwneqzYrfzFCnENJ
         1aGK4/yjLR7WgMC/ik915xuQJPTFnCQR2Mu2CXZtIY16Y4F4iP9UJwLWOAmUY5fznD08
         03/Fwq9IllOHHq3v+IWE3qFiJoLtHOwkmHatFxn+XjGuSsbCrMici1hkFlOjyJ462loZ
         akhq7z32NnYZeAHmelK4YgVsaqQ5DZeRMbJxl+/DmIrx6p2hUNEF9wQmSSfINW7a9TVi
         24BzvwWA49cVIjCy4J3mzHnWzywSA7bR+V1DejvBfakxwVxhDLDhD9Ta2N85Ios/z614
         KEIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h6TAvh2KhlPwZbZl975on9cPhNtC4Qh0FGtOTBu2EFs=;
        b=Gl26nMOp2rfCiWCJvJqIqjJCqH0LhDpMT4ExTMGfeQwM2unse0MDVUJu2ZWAGkoK8R
         mLx7RqOBCSROuaYsatrRdUyPKxCWcP37iq3nNAZYcNrMFpQ6MOAM8m2orC3+3l+x99OA
         h41qjX/Gpy0OGOTj7yuCsx9J5W6w90jX1lRmzI8ACy5nwJ8nX63Ccxhqk74dpEw3h9P6
         m2pgAI+MZEsyjImww1L9sXEz+vaDtvsOx4dRVjk70vV+Vl3cFFDHDeDahZ+Zo5nRx6mT
         prDs3ruSKNuAYKWkiakmIolxHoBpCvJhkzbGnRX9vH0IefzXMAR2WMAA2yaH9eAfVgFH
         gxeA==
X-Gm-Message-State: ACrzQf2IY1S84obxvj+0mno8hzfrKlcBAUwLIx5u4ZEygrfYoDRUMvBn
        1Hhd2n4dEOktTgubs4APIoDYsGjJbsFqRnOoPwk=
X-Google-Smtp-Source: AMsMyM7kE22wIOgaR8yVhaV+5YpjOgrtVLIFCzWewuwF5+WBPNllp6taOIKdAjNO2Mko0mkyRQ4kwsuVCbWby/9cyug=
X-Received: by 2002:a05:6402:3484:b0:45d:2f59:fae1 with SMTP id
 v4-20020a056402348400b0045d2f59fae1mr9709382edc.237.1666004459924; Mon, 17
 Oct 2022 04:00:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:71a:0:b0:1df:c5cd:1b43 with HTTP; Mon, 17 Oct 2022
 04:00:59 -0700 (PDT)
From:   M Cheickna Toure <metraoretk5@gmail.com>
Date:   Mon, 17 Oct 2022 12:00:59 +0100
Message-ID: <CACw7F=a0qZTczDh44fDb15b=OJeWrYYJ4+conHbftTPikyzYZQ@mail.gmail.com>
Subject: Hello, Good morning
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,
Good morning and how are you?
I have an important and favourable information/proposal which might
interest you to know,
let me hear from you to detail you, it's important
Sincerely,
M.Cheickna
tourecheickna@consultant.com
