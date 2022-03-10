Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040374D4FD3
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 17:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiCJRAO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 12:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiCJRAN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 12:00:13 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BD0B65F6
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:59:11 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id r2so7145059iod.9
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MqniiYezbrxFRna5aPEEbSgTbzBbKNmc+1d98/Zd790=;
        b=JYZe0JDjVvVupQMIGlffiAHgd6Jl/bKaGpRJbW3uEsAvjPp78lbqU5GNZcBsyQfy1d
         pEoVG8ReUjKIZd8//NRBQFZMCjUVrEoyhySuV4Gs4XTF6VF8/C/CGNlmXIRKOeu0EIMv
         BqnxWZ0t0GGc0AV9Nwp8K2ILySqp00/TmdwUvrzI2K5IGgf2AU1JF7fBmTG7dFiPHKdG
         9g29hjSnU2l+Eyog2VIRcTrKNHPq9nCv3gWC5Cx09i6iXnRcb3L9cyuO6QPTt5NROz2t
         HcZtGGrkSCA0yGF9MmHSys2Adf3g9hiTmbHGJx5jZwc3dmuqmJspCQvlP+cObCtkpySW
         AV0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MqniiYezbrxFRna5aPEEbSgTbzBbKNmc+1d98/Zd790=;
        b=Pkq8VAzpuoqWtRCpAFRIBgnKmKNl69WkMI3uNF/3AbsMpkW9V9SUEFB35FghAsLUaY
         QyRzkA7R0y/t7kK2oQ06JJTdt+4QfbAOYPIJg7yJmxttW2CC20KAGVa3b4VM55wMS/H3
         o141mVd944HxP3v/8avSJjxFxNLiK/iFxF4LpJiTfRLC9Bo5HBM0tMJq32ztfDzc8cjF
         dt0FyRkJ6IHnUjaLVGCDReml2GpjO7kHfboKgsujJdoztUrexw0F8MqO25Wz5zm/voYJ
         uHL6B/N043u4UT/fLXz1xZ3w1+kcf5wP777xKgtxcHu0oEoUQ155ISCoX9XpK5Qc/G2t
         PxzA==
X-Gm-Message-State: AOAM531kKdr0z6wdTizjA6nYty+H9KgdVZGCflw/FTOFmpIjceTWPalA
        ZS1c4DFICMrpLbKtPH7y+sPZaW89Vq4nMTw6
X-Google-Smtp-Source: ABdhPJzoYupCq1nnh3qR/xAFmxbl4UQKEh33wfQb6mexyBayms4LWf6Nkb8KfMoSXjBLgzb8oBpomA==
X-Received: by 2002:a05:6638:1492:b0:317:7b7b:c2e9 with SMTP id j18-20020a056638149200b003177b7bc2e9mr4737040jak.315.1646931550676;
        Thu, 10 Mar 2022 08:59:10 -0800 (PST)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i8-20020a056e020ec800b002c7724b83cbsm86865ilk.55.2022.03.10.08.59.10
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 08:59:10 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/3] Provided buffer improvements
Date:   Thu, 10 Mar 2022 09:59:04 -0700
Message-Id: <20220310165907.180671-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

One functional improvement for recycling provided buffers when we don't
know when the readiness trigger comes in, one optimization for how
we index them, and one fix for READ/READV on re-selecting a buffer
when we attempt to issue the request.

-- 
Jens Axboe


