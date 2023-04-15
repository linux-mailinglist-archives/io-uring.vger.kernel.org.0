Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FE06E2DF0
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 02:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjDOAdR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 20:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDOAdQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 20:33:16 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AF45B9F
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 17:33:12 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id bd13-20020a05600c1f0d00b003f14c42cc99so1405684wmb.2
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 17:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681518791; x=1684110791;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/krrOzf32PMDRBi/P9qe9m671OONK8NSr+9AstJjJkE=;
        b=Mi5rusR6OYDl7dxyjJ/Pb3GfYkMESFny6ScZgpNtNlcerowXj0SSBY4GyWTR55tD5J
         JoJ7vD0/cbmwqDY1xfzbqVQ1Qo3GErUhJ6ZYyJe4zEM7QJ2UxkqE+ZP2QXmLjik+LheY
         fFXO9HpcmnvfhiF36+EbGgpGLI1AdH7yQNb6Ots/d9bpL8EDmLo7zGpYN5tL52yQwhVD
         66l9IeMKnah/AZQd8mt3nb6xIBAZBYTMGZFt8F1/2gUhrhoBQit6W2XrGpBRv4Dpvroc
         cWFzKxHva9q0paoWavwZ/PYlPQCmp88dRNNWxOYFIPF7s84fxp/xJUmab1Y+iYmtqs64
         lrZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681518791; x=1684110791;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/krrOzf32PMDRBi/P9qe9m671OONK8NSr+9AstJjJkE=;
        b=llPJFgAU1lw5ZAqEAXZcNcUGRmrLZ5dYfjo3A+ihvMmALkeTtPiLXdhfKxHC8MCzk+
         GphK6CxleXrrKGEnJgWKGnM6OWj9+MOhoO5MW/65X65nBpoVSLbSuDFiHHxaGBFbcAAF
         kYy8zkzHb0+T3Z3H/qNx1/j5598OR3/etoAvJrrGShqWRrlsd3QfuN+35tjbr0/P4RNl
         AoGXYRM0MiUgTJ7uexaMbxKNnDz0Th8iBVq3M4FWQmoy9A7mn0I/MRfRHeymN+GkKnjB
         OCNViCsUevzE72gleQTiMo5RyIjDD/ZveMVb9QTcQ6sAzoopi88yFqdc9LInWuU/2XbV
         1Nng==
X-Gm-Message-State: AAQBX9dYlkYyTETtPHpQPFJwrZFwNwR/UHXHMsdqusIFollQmw3UsVPo
        pZ9u95vH17sn2iuyolg+pgnNkTql1Xz7sQ06/Og=
X-Google-Smtp-Source: AKy350Zr7RoiA2RNapqgNQuJei96UjFq9dZFMlzEcs7GSIwp4Rjxp6lwlgi3loZphF88y/Z5Af3iCNFHUDEvRbzswDc=
X-Received: by 2002:a1c:7408:0:b0:3f0:b1c5:8d30 with SMTP id
 p8-20020a1c7408000000b003f0b1c58d30mr2322832wmc.6.1681518790891; Fri, 14 Apr
 2023 17:33:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:5412:0:b0:2ef:b727:2df6 with HTTP; Fri, 14 Apr 2023
 17:33:09 -0700 (PDT)
Reply-To: avamedicinemed3@gmail.com
From:   Dr Ava Smith <acipqr@gmail.com>
Date:   Sat, 15 Apr 2023 02:33:09 +0200
Message-ID: <CACGB4dLPa5LHYxu1-mY+TvO=AZwnpVXWfCRSEV6igYq5Zeu=hg@mail.gmail.com>
Subject: From Dr Ava Smith from United States
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

-- 
Hello Dear
My name is Dr Ava Smith,a medical doctor from United States.
I have Dual citizenship which is English and French.
I will share pictures and more details about me as soon as i get
a response from you
Thanks
Ava
