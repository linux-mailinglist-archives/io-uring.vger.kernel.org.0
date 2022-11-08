Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C058562168A
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 15:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbiKHO2x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 09:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbiKHO0Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 09:26:24 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2725A1033
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 06:25:13 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id h14so13939328pjv.4
        for <io-uring@vger.kernel.org>; Tue, 08 Nov 2022 06:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=qJPWO9SMfKs9CV4DzOtfpg0tG5L2kEZQtV/LBBChMrnKplvig/HcfOA36QzOFbaour
         tgINSm9CFH0IH0weUkbi8oL7C5P0uFU99A+FANpQrOPV/x2at1b6HjUUAphEgu/Nt2rO
         YdZzEeguInvIt6hR0YTDbuGc0g6QmBH3JOdUVEiMakuZ8pUv0rSqDGDPPz36WP9L+M70
         Yi8Qvn61/fVJa/s6+O6bNGj9Vrx81J7VmEWQcrrTipgg1zMWjvYHOXsRX3Tp8F7t1isZ
         URWNY0E6DDGhkUjSdRf6tRRt6Dm01iRomcQNGIBkoA7vu4q8ZFmcmXCe9DgPR3TaW/OT
         odpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=EOjJe7x7mCaAOlNq/Hziz5Z6Th867zciqvHvKhsCxzlMmsB77knyCor9F0RLW51MOX
         LI5ha5gxc5a2miYfDCGT4SrcC2Afx3VUHcyD4pXVSQ2iRiYpcfxKdaUiktr3pwzWI40N
         TDXVe/O1MiWpZyT+DIX3o6THBeSa/SCRxIuzoYYQIw/fbJJ249H4mB+xunH3t7vgz9JG
         3+3YrQ4/XUJVOKTDxmaYXr+ipqy+F0QwogTIauW0J9jBHiclGlY9qeGtmwWrw9RKW52b
         QwcWAiqniBzglnzKpkdWFmjD6HaR0pwc8n7vpliX2hTHgSfIP1pw5jLyWXgVPuSzsXDv
         Ewew==
X-Gm-Message-State: ACrzQf1eyr1IRgzg8H2g3Q9SPk6fzFmYBKD3m0TRa4usiEZfFW/b9UOJ
        fTYkM1RJWgjY5EJ4ZgnvKmCxFkNlyOdBUcKFhKI=
X-Google-Smtp-Source: AMsMyM7xjnW3BCIcPmRXceI8CMPrgJsNpwknP0oXmxg9pb3hPM8UnVyASTbWsNqLc31U8nSLRepoWwOH4L/DHUye4LA=
X-Received: by 2002:a17:90b:1d90:b0:213:c798:86f6 with SMTP id
 pf16-20020a17090b1d9000b00213c79886f6mr52558648pjb.84.1667917512394; Tue, 08
 Nov 2022 06:25:12 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7300:5388:b0:85:81c6:896c with HTTP; Tue, 8 Nov 2022
 06:25:11 -0800 (PST)
Reply-To: mr.abraham022@gmail.com
From:   "Mr.Abraham" <davidkekeli11@gmail.com>
Date:   Tue, 8 Nov 2022 14:25:11 +0000
Message-ID: <CAPBO+FJ3Nhd2ncX9Z_fDUqYStiGQU821nC6EEFSDx5iCTdXkaQ@mail.gmail.com>
Subject: Greeting
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:102e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4972]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mr.abraham022[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [davidkekeli11[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [davidkekeli11[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

My Greeting, Did you receive the letter i sent to you. Please answer me.
Regard, Mr.Abraham
