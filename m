Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B2C554E36
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 17:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353361AbiFVPCR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 11:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357949AbiFVPCP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 11:02:15 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96003D1FA
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 08:02:14 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id f16so14846909pjj.1
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 08:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=vhZEVnaGNBjosB86GDUW8b2wHjB/+QU31bPXl36TqFE=;
        b=pTINA78Olj8sFIz8yXGETQAU2EH3XBGd3bkN8lo6QT3IK3aP0NZhFaZks7wrvtrdVV
         wFtUd7+y59qMtKrxs7Ep9LJQLYL3ZvkQRXxLiIpK0x/NtIVSx/pQXmR2ka1LT3QkNtrP
         WaXrM5K+RV2Vh0rgaS2lNo4CtTpkQW+pYELKmfeR5xFieFA/lr8IfSFxAKTLNuMfUvLP
         +F48/TfEfZ4GmDkdU4L51gPGkrwdZB1/L/iwdUuoT168GULtz41oMQIfj3w1IZEoVruB
         gfsjHdCm/SjE3Hr40Ou+A/934VCRBlKAyAWeF2V/S5TOYMI4Ww5c/Q7+TAJ/iWILJiXZ
         5mGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=vhZEVnaGNBjosB86GDUW8b2wHjB/+QU31bPXl36TqFE=;
        b=TkB1hQNUEb4NWI50JP6ZBjz7IlJWXgiqTYeDmNuaeF9kfIimCeL2CozOp7IxhzNso8
         IKBOuqN4GN0kiK7ew71ZQEUDzSeuNBX+VaG8xXx7OiHhYlM30E0THgu/Qr3PHJbT4s9R
         OVtxsRRjTh6uyIanorS+MTXKOpuy9sqoG4u0cQ+DWmGDLNAN58FLkeh+StKpVqhchMbr
         bN3vzK9y34RddVpXDVFpcsbu7y0DY7aZQFc8OyKErIshPRda8eZc8OfkzqF5ctNbqqdV
         7Mh1fSgDyr+lZDbpxRrCYRnilBnNReBMEJsSJ6M9SPODMKuvjdKvpWQhwIzgU/VqfqPM
         TIFg==
X-Gm-Message-State: AJIora82pDVt5JhxsL8Roop1tiw641KBj3wb7wb9SlgVAUBwJ/sHyKFR
        zyiI3L0Rr9YqQVeUHSxDJIvcbKUWqkwkY1v9yMw=
X-Google-Smtp-Source: AGRyM1s/RlUyH5+8Sfplj56GxJRUyIKoghOBWZuKgezQN9RuuYnd5VDzNFY1LwRKTp/0EjiTEgSp6eoyOjZzYvbTM3k=
X-Received: by 2002:a17:903:40cb:b0:16a:29dd:368f with SMTP id
 t11-20020a17090340cb00b0016a29dd368fmr14312947pld.96.1655910134020; Wed, 22
 Jun 2022 08:02:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:903:2308:b0:16a:1b3f:f74b with HTTP; Wed, 22 Jun 2022
 08:02:13 -0700 (PDT)
Reply-To: sales0212@asonmedsystemsinc.com
From:   Prasad Ronni <lerwickfinance7@gmail.com>
Date:   Wed, 22 Jun 2022 16:02:13 +0100
Message-ID: <CAFkto5sSBBEkDUJBpnH-2Ce5wo_gDVMR=ZMVjcCu_x+jvErVWw@mail.gmail.com>
Subject: Service Needed.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

-- 
Hi,

Are you currently open to work as our executive company representative
on contractual basis working remotely? If yes, we will be happy to
share more details. Looking forward to your response.

Regards,
