Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E9D502648
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 09:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350272AbiDOHim (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 03:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242018AbiDOHil (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 03:38:41 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3465747565
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 00:36:14 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id a127so6499037vsa.3
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 00:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=KeMi8W+p20zdR41YZoRj2EapY7imNsLYkAgQIQsIzqY=;
        b=KKGG111bGlLoLbtJ08SrbAwxsCbag1Sj4zim9cEcdNgK+K7O0bbfJu1ham4uzSqKZD
         6GQh6jTTba5beq8oHPnwJYmmSjLvS6xuWvnXJNidpz/vyLxh96OMg+kocoz6YJG41aPQ
         RtVgQUWjDTWWkIZRB3TqGaiXy+MV4J4X1Cxgy7L98nsY2v1bIjX2JZF0qcnh6iWbfGbS
         /qOzfPK3GPcx1uDzUvuhIZrm2cDQjm7NYnX/UfkvPZmcTelWW6FVlsWwpMuQqTYxb9a3
         OlG2R9zADByOFrq0C2HHYdDLo4CWvGMQbgpfGi4zANCv5M/JbzDS8Mp2bAJqrAeVyR/Z
         7HVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=KeMi8W+p20zdR41YZoRj2EapY7imNsLYkAgQIQsIzqY=;
        b=RGKANrSFwVvlfUz3ZZmm/2bQgaDW51E1kE7RCDBXdiCFcr7G9C1QE3KSZMqUV4s1kx
         nKaizKKgShsTfTXWoRM0naiEwgP7884lK9NItdUY28/3/gKLB6s9jMF7NtFF7yDH4MJl
         daf7xu3v+7PmGL+4xEeDYAjYZJHde3Gpqy5S53D9YKyUFMA5oXbDVeVWcQRf/6I4s/fO
         rtgOTWZdmev1cEB2BhgbKqA77qfCnlcswf8tHJDDbEbfb+6TBJZ3ct8muT/9bFPRMA0P
         /FNumAW3T4kp12aWLBqybtebhJqTvDF7nMQRz7bButVSbEVPuJp0JmUVB+jf8ztJ7h6c
         wiXQ==
X-Gm-Message-State: AOAM533PAAgHoLv2y9J3U8IlsjL3jW26zFhmimoKLP0IaLPgmkYpf3rH
        A6YeYYpKlKy3dtNU/HdyBnW/Xy6gQNq0qyYwl4I=
X-Google-Smtp-Source: ABdhPJz+OMuew99L/sf8+WEj0anXgdzigE1x+1tEKCoqDua7UZoe0xqy/unJte2seOpm/fCkYmhLvJVBbNKsnDZbyzA=
X-Received: by 2002:a67:dc82:0:b0:325:58cc:51c7 with SMTP id
 g2-20020a67dc82000000b0032558cc51c7mr2709059vsk.63.1650008173225; Fri, 15 Apr
 2022 00:36:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:76d9:0:0:0:0:0 with HTTP; Fri, 15 Apr 2022 00:36:12
 -0700 (PDT)
Reply-To: daniel.seyba@yahoo.com
From:   Seyba Daniel <hadissawilliams@gmail.com>
Date:   Fri, 15 Apr 2022 09:36:12 +0200
Message-ID: <CAAC2S9naSc=dYwuV_evRqU80pWgutL=HGerKY_TAh4P4U2e9JQ@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e43 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [hadissawilliams[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

I am so sorry contacting you in this means especially when we have never
met before. I urgently seek your service to represent me in investing in
your region / country and you will be rewarded for your service without
affecting your present job with very little time invested in it.

My interest is in buying real estate, private schools or companies with
potentials for rapid growth in long terms.

So please confirm interest by responding back.

My dearest regards

Seyba Daniel
