Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADE34E6862
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 19:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238015AbiCXSLA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 14:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347622AbiCXSK7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 14:10:59 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B1D5DE7F
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 11:09:25 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id n16so3683469ile.11
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 11:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Xr/wNcZmpQav+OCOaIe6D2beDVuNLbl806Yhzk4+ybo=;
        b=w7+3o3liJht3xx3Pf7N7XagX+sAeSFyhq3+28HV2+z8VcZDA2OQwWCgYaLwo6aQZ7Q
         HU3e4cFjts9PavRIFWiAO5EI2evpIXNW5m0JRv60jlbPWsIxPo189KNq3kQqEbH7keuW
         qFT262LR4IwJasSIMaHGOM0tUCb0Gb/WB7lan+/2bnHjLcrwC/fFSHIIXJgGeqaCKBwi
         iymUn17wMH7MTX3yFeDFrG7WLuSFUvQJfasnKZUyDfWV3XQm0B+2sRUwpUKOEUDohrSv
         Z11SjWKsJf70QKpQEpTrcB18vTV411uqHqXPHGVMYEWxrWAPQt5jpmi7RkveP09LihYd
         oFIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Xr/wNcZmpQav+OCOaIe6D2beDVuNLbl806Yhzk4+ybo=;
        b=7pUi2l2BD5/FF1bD6Y1C69wiyb2rBBPV8RQdHvFSEbQZB+0lvpLeuwUw4cLg1j/a8b
         xVIuktDuJbiUEwuYaOZcaTLMCHIFIiPvYjaemRYFCCxI1GWIvWvwc00E+VuWVLykls4b
         p3JjKMfu3Bg/vOMLhH5kHdIH2PKcIXBGTAZSO0xko+h9wW9OQiN0aslGEbU/5uZ/9EoV
         JgSq5Q9A3ZrNuhsYymkAmNfUbDoKaV34NHTOf1ZzIjQYbbOCFvTS2CbgkxOGVGLmE7p0
         mNydTcSatRPgO4D/fUVVd9EaCOWTCKy3aLoRpApg4Liilt1AWsfSc8Ni0zDZ0jKZGebc
         +fHA==
X-Gm-Message-State: AOAM532w37fhWxnhyLxNj1HEf3A48u+t8fYXoxzftSMJiGmU5FUb9fEn
        1UT3zGtLi3y+oFG9EXOVc1YFUxevJrrlR235
X-Google-Smtp-Source: ABdhPJyR8d6xqNI0z24oSV5h1HLTqxYH1YSrWg76lnY1OK8Fid9YlIsBSXlTPyN1nAID0lzOlIuYQA==
X-Received: by 2002:a92:cdae:0:b0:2c7:ab53:46cf with SMTP id g14-20020a92cdae000000b002c7ab5346cfmr3483161ild.85.1648145364230;
        Thu, 24 Mar 2022 11:09:24 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f9-20020a5ec709000000b00645ec64112asm1723606iop.42.2022.03.24.11.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 11:09:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Dylan Yudaken <dylany@fb.com>
Cc:     kernel-team@fb.com
In-Reply-To: <20220324143435.2875844-1-dylany@fb.com>
References: <20220324143435.2875844-1-dylany@fb.com>
Subject: Re: [PATCH] io_uring: allow async accept on O_NONBLOCK sockets
Message-Id: <164814536370.100607.16103024510642736333.b4-ty@kernel.dk>
Date:   Thu, 24 Mar 2022 12:09:23 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 24 Mar 2022 07:34:35 -0700, Dylan Yudaken wrote:
> Do not set REQ_F_NOWAIT if the socket is non blocking. When enabled this
> causes the accept to immediately post a CQE with EAGAIN, which means you
> cannot perform an accept SQE on a NONBLOCK socket asynchronously.
> 
> By removing the flag if there is no pending accept then poll is armed as
> usual and when a connection comes in the CQE is posted.
> 
> [...]

Applied, thanks!

[1/1] io_uring: allow async accept on O_NONBLOCK sockets
      commit: 6d4809f49bec8dc3b244debcb97f78239e52f5bb

Best regards,
-- 
Jens Axboe


