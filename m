Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A035EB66D
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 02:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiI0Ao7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 20:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiI0Ao6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 20:44:58 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2D54D16B
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 17:44:55 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id r62so4181339pgr.12
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 17:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=clgtGlA798hrD7TMNsNfkkJfSOeaNZNymMRnsp/bZ4k=;
        b=oYCDvgN0/s/Vif478uFBUfMX0QRx1GnrKEKgLFrMyaTIM9h4pDY/EQ+3Z50P1uLCqJ
         K8xvIp7MOVadm8A7S1V3ao1JXIUCSSPhMkzMlLOMUgm/PH0nnbbzlvB7XFW56bxls6nY
         lLV07o4jXpFfCN/W0TkBywM19TlDovAm8NLhkxXgNAoDVpxTBkZySv9k9t+jeqqJD7pB
         mdzVwGy00xbLdRUrJGNXMtIxRjgBDNCvcAPMjZRKbo1Pk8wITLsMvbdydG424alS9H/Z
         FdgYy0K4drjw7dJ6t8OtBvvjvcvenjdGcL1ZoWs8Kc0HFEVNM7XD6I4VewD3ngJzPV5A
         oR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=clgtGlA798hrD7TMNsNfkkJfSOeaNZNymMRnsp/bZ4k=;
        b=qsWnVdg/OzatGp/YmoQLF1OvAlyWB0eZeTi+/AMDtxBdhAc8NG9kd87fpLyA9nQi0X
         E6s4kjOuZbMCfmLW2Lmmd97RPUXGcpKAgGsD7dtWom5mpEVPtGcarsQd0FtWubu/BSmm
         sO6siGmLfiUPY08h8mibJHsCZHDGFVOLwpnGBnT6tp0Dw6jswjiqE5yyuJaqBbJseCje
         gS60MrTRzEn5f8G9qbPxexDPLukfxnDK4/uMbi2Sy1t35RL5NmuduB2cIEg6y+9hYNQG
         5Clzju/SmOaMVeDD1YJHiJOaiLA3iGfw2wY4B91BcINx1N4KTVCNRAWPtvqb4UUgDWJR
         7R4g==
X-Gm-Message-State: ACrzQf0uKpaMJUScDAfY8e3MVfjDkBvno3uNLXUOpIuqZhpeZ54XGy4q
        HFdEJplnd96Hboy1majUMV9tbw==
X-Google-Smtp-Source: AMsMyM6KBE+cGnyRBRRTOi/8JyjipoiSKzC5olLIs6nsn0Ex07ggOc1wZTw6Je0P69k0h/JOVpy9hA==
X-Received: by 2002:a05:6a00:2385:b0:544:c42d:8a72 with SMTP id f5-20020a056a00238500b00544c42d8a72mr26754582pfc.84.1664239495038;
        Mon, 26 Sep 2022 17:44:55 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l3-20020a170903244300b0016d9d6d05f7sm23174pls.273.2022.09.26.17.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 17:44:54 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1664235732.git.asml.silence@gmail.com>
References: <cover.1664235732.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next v2 0/2] rw link fixes
Message-Id: <166423949431.15113.4224555674473689865.b4-ty@kernel.dk>
Date:   Mon, 26 Sep 2022 18:44:54 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 27 Sep 2022 00:44:38 +0100, Pavel Begunkov wrote:
> 1/2 fixes an unexpected link breakage issue with reads.
> 2/2 makes pre-retry setup fails a bit nicer.
> 
> v2: rebase and add tested-by
> 
> Pavel Begunkov (2):
>   io_uring/rw: fix unexpected link breakage
>   io_uring/rw: don't lose short results on io_setup_async_rw()
> 
> [...]

Applied, thanks!

[1/2] io_uring/rw: fix unexpected link breakage
      commit: bf68b5b34311ee57ed40749a1257a30b46127556
[2/2] io_uring/rw: don't lose short results on io_setup_async_rw()
      commit: c278d9f8ac0db5590909e6d9e85b5ca2b786704f

Best regards,
-- 
Jens Axboe


