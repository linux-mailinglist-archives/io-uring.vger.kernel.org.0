Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EB15ABF19
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 15:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiICNSC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Sep 2022 09:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiICNSB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 3 Sep 2022 09:18:01 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DACD91
        for <io-uring@vger.kernel.org>; Sat,  3 Sep 2022 06:18:00 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id bn9so4815350ljb.6
        for <io-uring@vger.kernel.org>; Sat, 03 Sep 2022 06:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=S2u9Q+tjkz31iCRfklDeKGl5LtO3Yk8kTNoA3qpbsNs=;
        b=NbJ0O6ewwnkfjcKByZukeMQzUlsixqxgceoebU6veu5KOH0pWMCLvdvSKC2q5M0zHD
         6g23+/Aaps/hKIdtzn4zvCC+7RctTM5b21DTqTZZdQUA7cEVH2W8+lNd++LU624m8N8K
         YR4zfqZRmu8WFo8TCNt5+dZ3qqloW+EvCpLnKpA/uNL0w1tZ83jD6DzOLtCVgONvrGCU
         WXt+NK1jTt/25CeM0oCvct8+Cjs8Ux+KiDo0QMWgB7IXXNBFODmKIksA9j7ZpaVMOu44
         Wv9atXDXQE2jlm+PHcrKW70twocCL02E0kZfGB0MmVgb6LHN7Gh69WN/OR8qDS6HTcr0
         QP+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=S2u9Q+tjkz31iCRfklDeKGl5LtO3Yk8kTNoA3qpbsNs=;
        b=MPs/EXbV6JJekt4T8GN1FOpY6UPYTk+iTYPtI/fdLlN0lXN+Auwpswr+Ue2shGk+1Y
         jlYgGS/vpqHy9nOujrRx7CNRHtcxKp0p7EU5ETeJGG7PhwFXSpQEQ7cyAc31d7CvXWZX
         Tm2CEfOfLOQDml+yuy4lpMOpbCix5xxNENYHxBdogPd1q0XqzV7q779OtY2puIvChXyz
         ePdGNvqDbkFlbUK1n7rZOGAY75itfQrMDNd9oYl2yuh6yVUZP4JkhWnjJZ0iMOv1u8qo
         2bjLjfFqww5h5LdFB+Wip5zaRDgjqmBf8R9PPwkWYOy33INZBdJNw+V7UY5bTmqAtdGh
         GOWQ==
X-Gm-Message-State: ACgBeo1tSZL9+JZoM2oAp663510Jn3ogD0gksMkyg6uyHYmNS9M4OAcC
        JH5KfLuxWd1OIDMjyC/J1Dvb/3uy4GipD5kAaEg=
X-Google-Smtp-Source: AA6agR7Xxz81r9x0Bhl8r+g1p8ZMecoufgQRzYQWWDugkGv1CmSZaR8awDUf4LMleyv6zK6JIx5MbZz04htxT1PThsE=
X-Received: by 2002:a2e:910e:0:b0:265:4bd5:4d65 with SMTP id
 m14-20020a2e910e000000b002654bd54d65mr8387010ljg.34.1662211078634; Sat, 03
 Sep 2022 06:17:58 -0700 (PDT)
MIME-Version: 1.0
Sender: missabibatu@gmail.com
Received: by 2002:ab3:1e0c:0:b0:1db:50d2:db73 with HTTP; Sat, 3 Sep 2022
 06:17:57 -0700 (PDT)
From:   Ariel iah <pb589847@gmail.com>
Date:   Sat, 3 Sep 2022 14:17:57 +0100
X-Google-Sender-Auth: xpQNvYwfphrL57MihM_WQcucqLQ
Message-ID: <CAHRP2D4LbcLnSMXfcVfoQWOACHqZgZVGs0_WUwDjqfwGVa2rQg@mail.gmail.com>
Subject: GOOD DAY
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

i am Mrs  Benaiah and i was diagnosed with cancer about 2 years
ago,before i go for a surgery  i  have to do this by helping the
Less-privileged,so If you are interested to use the sum of
US17.3Million)to help them kindly get back to me for more information.
Warm Regards,
Mrs. Peninnah Ariel Benaiah
