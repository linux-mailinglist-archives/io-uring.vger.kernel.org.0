Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD11561E7D
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 16:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiF3O4n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 10:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiF3O4l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 10:56:41 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BFE1D0DA
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:56:40 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id 9so12555154ill.5
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=bZi6RUC9lgIhgs/6jkTTyRY59TgB12aZJVtJ98gb0tU=;
        b=2CJie8weG90kwnMkuOMLEv9GFDGzXNFx1ytNZjS9BVZvJwIHlGPO/jo6o5GqNJVhgp
         xeTLQ0Nz5Y51/56tWEECbR2/bcwf3it7syVD28yuTeT95B8qMhLNPx4d6VSFFuix/Jd8
         dcz3hIyJPiHcihHWa580cdQQ9FpH1oBJ9ldlEF0T+NEjm6tG9LlEZwNMEnrl1zm3FvPS
         VaB3D8a1rjaLTPABL7VXnghrbYCN6D1DzPHiS9JPHSJYoIfdbYNQhu7kfe496cgZ91Y2
         jNDRMeQrDFlWEqjncGszY0MLtZNpO7Oq9vQYoxD20NqJXdyz5mmdAxZ3bHfEBYQITwqb
         w9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=bZi6RUC9lgIhgs/6jkTTyRY59TgB12aZJVtJ98gb0tU=;
        b=SvAR6P3Gp/iMosXW+bDS8V3dUZAw3hlbfZkoaW5QnlkhA3ljYcyNrbZz70rh1KTAFa
         c9rhIyd8kRKIbuSD3L3upPOaOhz9o+XMf2wjWlQMEEAdZvAzCOP15od8otU6fJSQoATY
         Ebgx6vsoV9CCEGw/x7v6Mn9B51tcVpPOCJol8PkS0lz4yhCTmPbIdE1tGiLMv6X8mo4Q
         pVk5QemuO/irWnniKZkI5TElnsw2k3IQBj6m/1/hLB01zIxV3iR8T18yPRTtCyBEkS1h
         ZNFXIE4UYSbKuvqb9woSoWvY+IC3swmipympHmzpYpE2OeKo7Pam4FQzkjE5PG94mKDu
         TbXA==
X-Gm-Message-State: AJIora/GberEs8iKRW0scw50YhU2Y93Mt0aZG6c97vJqvmTCGA63viR8
        zb9tavwhEGkFcO8IQx+0hk60vB4O8rsSgw==
X-Google-Smtp-Source: AGRyM1spS9R3vf1yi/v0xO6ndBbbPL+SgU81vsvaf0iFZxBpDHGQaTYdHLYQkUqniHVBuuV67lPM4Q==
X-Received: by 2002:a05:6e02:1649:b0:2da:9994:18e6 with SMTP id v9-20020a056e02164900b002da999418e6mr5428887ilu.260.1656600999618;
        Thu, 30 Jun 2022 07:56:39 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p192-20020a0229c9000000b0033cd5a2b231sm1667467jap.47.2022.06.30.07.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 07:56:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <06ab196021be1b5463879f637e080ac2c67ec91e.1656591720.git.asml.silence@gmail.com>
References: <06ab196021be1b5463879f637e080ac2c67ec91e.1656591720.git.asml.silence@gmail.com>
Subject: Re: [PATCH 5.19] io_uring: keep sendrecv flags in ioprio
Message-Id: <165660099886.535553.15967708433061545664.b4-ty@kernel.dk>
Date:   Thu, 30 Jun 2022 08:56:38 -0600
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

On Thu, 30 Jun 2022 13:25:57 +0100, Pavel Begunkov wrote:
> We waste a u64 SQE field for flags even though we don't need as many
> bits and it can be used for something more useful later. Store io_uring
> specific send/recv flags in sqe->prio instead of ->addr2.
> 
> 

Applied, thanks!

[1/1] io_uring: keep sendrecv flags in ioprio
      commit: 29c1ac230e6056b26846c66881802b581a78ad72

Best regards,
-- 
Jens Axboe


