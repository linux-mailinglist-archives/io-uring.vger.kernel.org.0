Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415A251F993
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 12:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiEIKST (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 06:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiEIKSQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 06:18:16 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A2822907B
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 03:14:22 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id i186so13305768vsc.9
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 03:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=OE0cJSkFezf+YJwrcp188z4Lj5GTucq0T2aibHnjxt0=;
        b=hzUMvwa7J9WbGCG6APGX6mnRj4kNeJFXa9+7BDJci9aAajIcj5StCoj9e1rCf0mndC
         t5S55/kx2Ik65tzv1vGK5oFDNzlidjcrTkI+qdaP7ASzmhpnHTMeIKdLfj14JqaQbwDM
         vq70NkTgFhBDmApUnp4hVa8Cqfho6y1tZkCVDWoXMLhfGlWLxB3iYytKliZ7csa9dToj
         DSAYfizttjUoPMxgSRNZY4q6mZktKaTuirvHNcPQ04vN4GCpItbc0MV6uv0LoQjzCvAb
         oRwr3u6xxQAxaOfzHZU1XuOW/6nKVjJEx9FYSpwetKN5lwyP8xuAS+zRKC0I78aiYWf0
         ZxvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=OE0cJSkFezf+YJwrcp188z4Lj5GTucq0T2aibHnjxt0=;
        b=AqtAAqkJYvDrRYCelpWCXKrxcg17XFv3Fsu1jpp37KNwLcnMp6aJN8N3TSJoz09V/d
         9XtCJI2gGod8hl90GzyW51LnA1ZK1+OXHY8j55tV8okDnWcFK29++DhMKnDZDrav1U21
         CNvODYCmhUkWoMtAVHAqQ71TAMv+8X7tdH3/mNSVJ373aeIdMn7XAzRNDHarQ6zphSiB
         w9KCZEYsu4BqtKu0ipVuyxw/+AY0qdc3WND8TtTVtyzrAoK77oDDsyx7BDTIgsvq9X24
         sc3PEyvaMELZEEgyX+q/IooFW1gff33t0KD9wI8optlvRQdeP2jOLyZC1lFrXpoT6TZo
         eRqQ==
X-Gm-Message-State: AOAM530J/hgoTDCzfZ5z0En2PfMLEs/UtkrUbYRtuh1C7zE79KC8RNCF
        e/eMze5Akz1eK3XVcnMoWwWtcqoKlPu5G7khZN8=
X-Google-Smtp-Source: ABdhPJz3To9CV1gc2cIAwn8F2x6M6PXJLgBi/WjhMIA36dQmWa72QOh2a3Dn7zNeirTuntlsMhZ87XYPY6SBknd5gHs=
X-Received: by 2002:a67:fd71:0:b0:32c:dd53:9ac7 with SMTP id
 h17-20020a67fd71000000b0032cdd539ac7mr7263024vsa.67.1652091225877; Mon, 09
 May 2022 03:13:45 -0700 (PDT)
MIME-Version: 1.0
Sender: mrsnicolemarois8@gmail.com
Received: by 2002:a59:ad29:0:b0:2ba:1a7c:5596 with HTTP; Mon, 9 May 2022
 03:13:45 -0700 (PDT)
From:   Miss Qing Yu <qing9560yu@gmail.com>
Date:   Mon, 9 May 2022 10:13:45 +0000
X-Google-Sender-Auth: hg0Bur5jYbtGr8sNO7QuWrTStIU
Message-ID: <CAAadsjukavftibY+FotU+sk9dj_fCmw4uMeJtPe+dU6XqEckzw@mail.gmail.com>
Subject: Hello!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_NAME_FM_MR_MRS,HK_SCAM,LOTS_OF_MONEY,MILLION_USD,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5002]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrsnicolemarois8[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrsnicolemarois8[at]gmail.com]
        *  0.0 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.2 HK_SCAM No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.5 HK_NAME_FM_MR_MRS No description available.
        *  2.4 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I am Mrs Yu. Ging Yunnan, and i have Covid-19 and the doctor said I
will not survive it with the critical condition am in because all
vaccines has been given to me but to no avian, am a China woman but I
base here in France because am married here and I have no child for my
late husband and now am a widow. My reason of communicating you is
that i have $9.2million USD which was deposited in BNP Paribas Bank
here in France by my late husband which am the next of kin to and I
want you to stand as the replacement beneficiary beneficiary.

Can you handle the process?

Mrs Yu. Ging Yunnan.
