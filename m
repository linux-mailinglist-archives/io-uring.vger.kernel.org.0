Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB0A620A3A
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 08:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbiKHHfU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 02:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiKHHfT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 02:35:19 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC0A6457
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 23:35:19 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-13ae8117023so15371044fac.9
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 23:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1G4HH/Un4Ldw4Kg9mAfztEcm3aw8Ky8DnIHt266GhrM=;
        b=lwd8Ct3Q8oOwFs1AYPSLq1N2H6y+41Fp/d3apysr2D/0JTV48Oiv1/x0zeGNXV3Uvv
         sxXg+gtydS7N06vqn1oXWc1ukbFzLypS4/MZdC/cZae2hgFDVLBYXaWNe1E1Y4xzOp7t
         iZumKa7yDMWrGGl4knzz5rSE9zu84pPgrCHmx+S+i4MavyOwq5Aea9vDIf4mfW82com6
         x+oWKdWDhSg3Hwpy+27PT95hGhfNnfM/TTLWuCIMLrebLx7C6wdANaLNjacIoA2nwLQd
         GV5qK8iaBwoOTtz6qTSM38TSNxSIILgxer+Zg/jBsRzwkCmJHwEbgZ9HzgDEz5y/GbUC
         j1YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1G4HH/Un4Ldw4Kg9mAfztEcm3aw8Ky8DnIHt266GhrM=;
        b=AYaEQ/+LpvhyWdINnJdnWI0pyEl3c0wiDP7zpjPJJfX4+NJZ7FSo8lC5w+dzW2E4+7
         d8pZwHohTuS3xq4qxLd81Gn1IyC2stIHGR1txsjXkxEooqNjg9jRexZA9/pU8NeYn7Ru
         Iy4wIBgneP/h4jgnWw9sDpzAshPJRngus3xsaQfVfmURIDHSQam5RK6mmXklA/CE2V9/
         xk+ECgzXgXxwHoXTQUwx3k7p4PTMKJtRUEA1/2V4DdquABeJFS1dOgBsUWKaJIhieemz
         pVZhVmvMrc0KlsoZzM6+oB133SsSzDcJaBEIBzZU2SiTH6K5hiN5+klQ10zTKe+3cDpg
         iDhA==
X-Gm-Message-State: ACrzQf37b6dAShGkhSquZCU2HKZJrTNg7OhpMPgncI7ZMiOsqavV1L9I
        LQ1UoRjnn82mPQ7UnBHZMaz2wcJQxj/Jb+Pu4dE=
X-Google-Smtp-Source: AMsMyM6GcW1gqFjfJbj1w0UEDBm6kDETL2/+TlUO9tRFOj8IvtxI/tGkMPy21ryIbd30JCCef/3g36KYdleWFC2zyV0=
X-Received: by 2002:a05:6870:6593:b0:13b:c1a:e8ac with SMTP id
 fp19-20020a056870659300b0013b0c1ae8acmr32146810oab.271.1667892918393; Mon, 07
 Nov 2022 23:35:18 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6830:280a:0:0:0:0 with HTTP; Mon, 7 Nov 2022 23:35:17
 -0800 (PST)
Reply-To: Vanessagomes0000@outlook.com
From:   Vanessa Gomes <leeannelisha253@gmail.com>
Date:   Tue, 8 Nov 2022 07:35:17 +0000
Message-ID: <CAK7usiFE7AdGotpxO1wN4g8SEcW1sXDEqQCh3f3nJkzBzcqH5w@mail.gmail.com>
Subject: ///////'//////////Ugrent
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:2b listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [leeannelisha253[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [leeannelisha253[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [vanessagomes0000[at]outlook.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Can i trust you on this transaction?
I have important business to discuss with you as soon as possible.
This proposition will be in the best interest of you and me both.
