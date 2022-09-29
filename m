Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADAAA5EEAF3
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 03:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiI2B3j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 21:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbiI2B3i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 21:29:38 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167F3E0F
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 18:29:32 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b23so112271pfp.9
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 18:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=qeH6Z8yHZQHwl7teAaLOXgXNxPXZvPWmYVGQxMtuAJE=;
        b=0GOxN50rwAk2FX6OzbSlaNtymy8Jw8usFvxGLkOYXcY4UQ7XkLA3WwSVdKMFNW/m38
         FIl06hhtQRaE4r8OWdxDD/z3k6RnwFxAfcgDogAiNXrr6RfoWE3RgGbSBTmPeXBmIgnx
         9t5lJjOr10zos7yp+sRkta9/RCY4eCngS3BavS5I31bHpm1+MmoRE6UZ8vNHWz7RLBCt
         +SPYG1Ejf7IlhwOItBxxyXnPNtCSbVYZ2BDgXbKbpqsV2pQfG+t8eaqYZfx3VGXHJDmA
         zcaiTotKjhjGtTHJ4KUgA1cXR9Mb2qJI0kaOMOSundWPoPXMd8fNJp7sldbpJD205eqo
         4TXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=qeH6Z8yHZQHwl7teAaLOXgXNxPXZvPWmYVGQxMtuAJE=;
        b=Vsc7OIIe8yKX24XP3ctdBqJcctZKL06xiWqn+WfNcAz50Ra+5wXcOvlqTHflKxdLLw
         8e7HbMTCPiH4ZtMCfNhVVfwayBjDfNTdisxJrCTWhEBUoUoSH3C3FBhMokCui4nuqiuB
         vy8WhclzSeEDMSrpwWQcp7sgn0pvz6+5ESa7zDrPt0rRTsuLchzke06QqAKtr1IANv62
         VlLQiV2ZO7JkxyiXuunvw5xKAkgUwcZo4VDhFfhxYaE0nuYUVyZxTrUsPdlfm3GBLQEH
         NInkFmdJ1CkDvNKgNbxCsGp4puhh1fq2kBoHxB4JUV2FrAnG/zEy4LONxngHyDUFYsG6
         89Ww==
X-Gm-Message-State: ACrzQf0s+qv9Lho7vVcHE6sGag32UBIOcoC27mYyxTW7dE1ow4wpODLG
        5TDQglSQLbxj96AeTpWadyNm+FWKp3oIhg==
X-Google-Smtp-Source: AMsMyM7hT0pqqoPIHLifSKmtIGYhpOdF5lZ//vPMX6rTpYC5Ptz0GXg57IQbnlQ7i0dA2myDDtusVA==
X-Received: by 2002:a62:6085:0:b0:53e:7874:5067 with SMTP id u127-20020a626085000000b0053e78745067mr828014pfb.4.1664414971426;
        Wed, 28 Sep 2022 18:29:31 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x185-20020a6263c2000000b0052dfe83e19csm4710074pfb.16.2022.09.28.18.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 18:29:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <176ced5e8568aa5d300ca899b7f05b303ebc49fd.1664409532.git.asml.silence@gmail.com>
References: <176ced5e8568aa5d300ca899b7f05b303ebc49fd.1664409532.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 1/1] io_uring/net: fix non-zc send with address
Message-Id: <166441497068.3754.9907442113781277579.b4-ty@kernel.dk>
Date:   Wed, 28 Sep 2022 19:29:30 -0600
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

On Thu, 29 Sep 2022 01:03:29 +0100, Pavel Begunkov wrote:
> We're currently ignoring the dest address with non-zerocopy send because
> even though we copy it from the userspace shortly after ->msg_name gets
> zeroed. Move msghdr init earlier.
> 
> 

Applied, thanks!

[1/1] io_uring/net: fix non-zc send with address
      commit: 04360d3e05e885621a5860f987c6a8a2eac4bb27

Best regards,
-- 
Jens Axboe


