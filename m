Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB8353BB77
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 17:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiFBPPz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 11:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiFBPPy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 11:15:54 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A156228F51
        for <io-uring@vger.kernel.org>; Thu,  2 Jun 2022 08:15:53 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-f2bb84f9edso7087757fac.10
        for <io-uring@vger.kernel.org>; Thu, 02 Jun 2022 08:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=NCpzoj+0l36fkrjHX3S+lurr6Rzg3xie2enwLhIR/28=;
        b=f3H0AiW1vlmmd1hHxESuIyjmy2a0oWC/7Ge1KPXdTIMy0SS1ZafT8TQ/bMBQToRdwp
         ZCv8BFVx/EPVdnkQpETJ37wkdK67y4cCIytBkQYDCf21KA34KJdtVHpuRxTtPlEOaoiR
         N3hRGelutqMm7ZNg5+4DIxFT1mNufdQbAt6dnQaoqMdbXnGYUadfXUNqB63M6+Juu8Np
         Nz1g5WizkKUyLjIDTmjRZQVw2kb6AQF4xanCGqL4XeVPBL+mM6pkvXRVFjYeBqyXDJKT
         nIvJ+vVEluqAgGblgKkaCsccWQECo+AuspN4WjuHRNhdaifu9twwF+B/0WIK3nzMX2Rg
         KuEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=NCpzoj+0l36fkrjHX3S+lurr6Rzg3xie2enwLhIR/28=;
        b=ORgFZ0b8SBkZ4lpAqY3F4FDLBlI5iN7HMQuEBr1fJYwcCnuM6LP4lQ/kcax17FAYCJ
         B7vf70LYWSG8g33+1Cmzl3Oi3pwUohux8pCiO5onwZCTi8ppAJsp3E9T7ZQu/XvtdP4q
         2CoVq1y7dwU9dmi453t553xqfKSA9q3Xnm5swhfiDkTzaXPKw3ttc9+KNtlndHFgVFg5
         lKbMhyCiORKcHZOYlQXA5sr7zV0sr8+F6ceWTVZBAhR6T9Mh1Cz8odMtlzveJTlqxIzQ
         G3dQ7jWGRqk2oCFa/glvG3+H24oU4bixnwatMP/V6QS+ZhqB0UwRJxcteygZ8Ii8q2x5
         9Meg==
X-Gm-Message-State: AOAM531Np/rQ1wrE2dsHrWp5Rg/kmAxOI+auyp8TK4eWzJYQMJs15L2M
        U8K6la/JkICI3fMfRyiD83KsujDjSo/qByTD4o0=
X-Google-Smtp-Source: ABdhPJzz8fP46mkJplJD7yd9nujZ/FKDVRHTvRSIEVYy68iY51O7VkLNNB1RlVZUWPqAG076pVbQOFAd57YmBL7NJf8=
X-Received: by 2002:a05:6870:9108:b0:f5:ecd6:bec4 with SMTP id
 o8-20020a056870910800b000f5ecd6bec4mr4575526oae.110.1654182952462; Thu, 02
 Jun 2022 08:15:52 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:8:b0:9e:2a1a:3d58 with HTTP; Thu, 2 Jun 2022
 08:15:51 -0700 (PDT)
Reply-To: alifseibou@gmail.com
From:   Mrs Judy <mrsjoychichi2@gmail.com>
Date:   Thu, 2 Jun 2022 08:15:51 -0700
Message-ID: <CAJyntBz27DTALTgz9jSgqUuodkkadCpwRVs3B28TRHaqWp6TsQ@mail.gmail.com>
Subject: =?UTF-8?Q?PREMIO_GANADOR_DE_LOTER=C3=8DA=2E?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:30 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrsjoychichi2[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrsjoychichi2[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

PREMIO GANADOR DE LOTER=C3=8DA.

Su correo electr=C3=B3nico gan=C3=B3 2.600.000 millones de d=C3=B3lares, co=
mun=C3=ADquese
con el abogado Marcel Cremer a trav=C3=A9s de su correo electr=C3=B3nico aq=
u=C3=AD
(edahgator@gmail.com) para reclamar su fondo ganador con sus datos de
la siguiente manera. tu nombre completo, tu pa=C3=ADs. la direcci=C3=B3n de=
 su
casa y su n=C3=BAmero de tel=C3=A9fono.

Saludos..
Sr. Malick Samba
