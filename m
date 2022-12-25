Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB8E655CCC
	for <lists+io-uring@lfdr.de>; Sun, 25 Dec 2022 10:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiLYJrm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Dec 2022 04:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLYJrl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Dec 2022 04:47:41 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C45725D
        for <io-uring@vger.kernel.org>; Sun, 25 Dec 2022 01:47:41 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id k4so4113559vsc.4
        for <io-uring@vger.kernel.org>; Sun, 25 Dec 2022 01:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K1DFvd/qB2iPwiRdxjvsshI/YDS4Nv+p2asGKuDLehw=;
        b=Yu0FFhTfJJBRvIL3y3xGyHWL7sn96WufZ4NFU4W0E3gMhq2huidhvdrip1xbcXaPCW
         izwxWTpjzqR62odeucYmmRTLipVJFOPgBv8/5ND1Lr9tZv0i+J1hSai18pX7k4lNakUI
         Woc8+ycsxfQaTk48YltP2xoZJeMK7u2rH9RmI76b3uwyFCsnvq8dzd3zuqP4R9700jtb
         0EVcIXBj7AfGPKG1T0XdmPn5Bx2BKDmhsVdGx2JOnR6WPt83JhgrfvcqBsg+an2ZI5py
         S1cQkn6g2Ew20TrgDRMZikvnMPgtPk31r9U14iNV6tp3VYUyzNzG6HTTk5TMk3TfnOa9
         rfsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K1DFvd/qB2iPwiRdxjvsshI/YDS4Nv+p2asGKuDLehw=;
        b=kEjRFvBOJ5oMCVchDnW4rBbqnrMigpK0Pz4guIGUBOI5c6FClDw/Rxq6CXJ7M4XmRU
         romiiwXpmY8xoQGxsbaJnTdQa8AJUlcumLjCfmtkQHr2ah8xCJNi/WvZ/LMGj+Y55vfp
         yqNok4REQh/POtFA+aw2gNkn/Om71HfVIeDZ18/AfAXB7geZpUSfitAMB0Sn+oHLzOkR
         vXX2WJINeDN0JaN8I76mWRsRBgQwbz6iK03DhF212PsuQtwkuIz3FkFCTSR2qX4fWlM/
         wQgHZEM+Dl6V1GJNwudSB5RwOaWrKjzMvArjItR2OMSYjM8+brkwrZuzHMaBvUvZ1LX3
         lRLw==
X-Gm-Message-State: AFqh2kregiycsSBQ6aH7FEuz1l/qB8T4pvoNjoXGuEolhXbmqwj8E5EC
        mwMEn7AzikkB6Z81f0hBDD44vaevV7izFFhkH+Q=
X-Google-Smtp-Source: AMrXdXvAtj096OdfczqlbmgB3cS7VTulkB3a5zPb3AVVYtkHzc21/AJFM9qjnIQF9arxPokO+ES8Tj6HPJpeTWv7TGM=
X-Received: by 2002:a67:bd14:0:b0:3c6:7817:4a41 with SMTP id
 y20-20020a67bd14000000b003c678174a41mr268196vsq.33.1671961660341; Sun, 25 Dec
 2022 01:47:40 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab0:5bcc:0:b0:419:1459:f027 with HTTP; Sun, 25 Dec 2022
 01:47:39 -0800 (PST)
Reply-To: thajxoa@gmail.com
From:   Thaj Xoa <zebmorris1121@gmail.com>
Date:   Sun, 25 Dec 2022 09:47:39 +0000
Message-ID: <CAJ2KYch96M0LOTjvc8egaPY=Py6TapjBjmW6Op2CnZVXX9uVFw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

-- 
Good Day Dearest,

 I am Mrs. Thaj Xoa from Vietnam, I Have an important message I want
to tell you please reply back for more details.

Regards
Mrs. Thaj xoa
