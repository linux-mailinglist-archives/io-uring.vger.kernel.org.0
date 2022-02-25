Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268F94C4568
	for <lists+io-uring@lfdr.de>; Fri, 25 Feb 2022 14:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240971AbiBYNIq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Feb 2022 08:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240954AbiBYNIp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Feb 2022 08:08:45 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8488422EDE8
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 05:07:53 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id c1so4594465pgk.11
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 05:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=B3GY5pHxl40fgyTRDEfHUIewqx+99afdPdvQA2cgGa0=;
        b=M4+iuQpiPGVHNSvr17HgRFHxrppVIoNEm39FC4iT/zCeuohn9zr98vFinhaxSRf+Wy
         6WdCZzE/g1UnccblUnypxIJjUl0AsChNqceKOg7ZR7bYba2AC4yXTQLPhUj/EByXLxDf
         8DTYnAi5Yx+gMjxDZKLLu2V1+SuKyvz3F2zB8uK8+4Q3woshyCDFNtefSryO6RUiriTt
         vHYSw6miNf66w1a27i/SItMX0FWNtVJ3QSRhojXf2f2iePIKvk17fcSGtTDVeFg2yoIB
         irHxbMhPiZzUhmfbOvoeXdx+P/HdGyg91Ep2S1Yr2J1VCsV9zKjIkFbsZsu1Yr/vGqdx
         fRlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=B3GY5pHxl40fgyTRDEfHUIewqx+99afdPdvQA2cgGa0=;
        b=KeU8lfEa5uVo0nhO+5OJ5UJs/MvMQooVfBNjJYKyoPsbiqeot1v5m4g55jaiQIgorX
         8Dw478cm1VmKMo0+InXqVhXdPkOnoJvwyoiqOAlb/4eJ3MpLWGWVRQyHkXBfBQhP7a7E
         Yrab4d2aZyvd0DV2gsnxo1hVKKuPjO8XTtf8PZzr1GsA7UxhfpDgullhMS0cENriv5OX
         WGOviQdfT3GfcT5f0CxZQHcLVefDU9J70cPUoLKUcIhH2D6LfJxaDEZWpnHTsruvQLct
         DREWDrb3Hp1vdUFeM2Lz7yKDjsE18HgkK/mYkqGXSoX6SsAjysYQdC4ZlDayR3bzmmjk
         qU2w==
X-Gm-Message-State: AOAM531PIJTkIFmhwB7pSBciREnq2fy7uuaMNWERFkimdDbx6BK6+wWj
        gC2kHEPSd7tbkho8r+TkB92qaq6+sw/O1tpt7Ps=
X-Google-Smtp-Source: ABdhPJzch5srO0rQ1XkIjEYmcLXjUIpkoMmIP6ollMt1Fs+TMEjh6nWpVfZR3bnntoMlNwaeaFi8AK6Dz7PGovrfMrk=
X-Received: by 2002:a05:6a00:9a2:b0:4e1:a01d:cc4d with SMTP id
 u34-20020a056a0009a200b004e1a01dcc4dmr7727224pfg.40.1645794473093; Fri, 25
 Feb 2022 05:07:53 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a20:1394:b0:76:7c56:e89a with HTTP; Fri, 25 Feb 2022
 05:07:52 -0800 (PST)
Reply-To: sgtkaylam28@gmail.com
From:   ken manthey <manken827@gmail.com>
Date:   Fri, 25 Feb 2022 05:07:52 -0800
Message-ID: <CAHbNM4Hk=79K8XLZTYnB7jMDT4swFw3DfDpwynTUPtaRvYu4+w@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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

Greetings,
Please did you receive my previous message? Write me back
