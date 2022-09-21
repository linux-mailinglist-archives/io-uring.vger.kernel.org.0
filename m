Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404B25C048A
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 18:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiIUQqy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 12:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiIUQqN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 12:46:13 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81B2219
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 09:37:46 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id z191so5469196iof.10
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 09:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=Uc9ggBcu1ueFQlcLexRCe1pIhmcUa1N1GBbkSPRQHh4=;
        b=VWjbvc41cu1ta4dFxm6Qel953u1+n6OiOs/kYRNM5/wyvGT4hCBnnSQywP6E9B8b4t
         MQE7NXFB1GxQUg5DJLpwSv4y9twVxuTZHDRYv4prd3/CnioQeoyFlVpsZ2m0sBNZ3BxX
         PczrcWbTfdF6f70zjuIZHWkqPMEhI0YfMD1mV5gw30gccCur/JmmZXjbaqXAFqJdWQd5
         TH3VoctqT/FHixZiORyG02byRBJWTbPPSARgHJtCiveZAg97yFXnUw0aZ5m7Jlg4M1Qa
         qQl+p+bvpmD8mbm4dWD5TxGUQ9bdYQ7tlxY++rXMpzZ8jV3PUoHVlCYBYmxB0fyGDiIZ
         oM9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Uc9ggBcu1ueFQlcLexRCe1pIhmcUa1N1GBbkSPRQHh4=;
        b=VUrSWu7d6ei8eMvO6QuUOMabiS2mTeeI9xr8HlTkRD4C5we+WAPU+PyCSjqLCdYLz+
         hj1eZcSMpceTSIZPKEb6kI/MJ0xA0waAj7vKNuvNgw/8ZkSxdLSBqajJ04z8ZmYQuTyh
         AHlPMACYqdLwtzXoHwHd2oiVkLF6fmyKPLCJBnWT8npHOgEKSZfo2ZTkXX1Ortyu2pzR
         QbgcnF1PAodzsyy7Bu473luAGY5ZI14HP4kkz0f0VAHVdmz0SsQcsp0agtluBMNMPJ9I
         zKgjQFtwnsN8Qzv0wdMYuhD71oPwy8yaBgeGpqmAK+VKeODLyL3oKgag3pACkG8vOAqU
         AP0w==
X-Gm-Message-State: ACrzQf3pNSPCiE+X4Ze3Ub1c35QgkMQOselSG1QiX9sHtTAYwLtUQ/tK
        qo5huOew3L1T4GQRexPULk2qX1msbg8sGA==
X-Google-Smtp-Source: AMsMyM5n7mFsH/KUInDPLo1xVri5rOMFoixKHxAu2H0NmADjF382wi3WdZxz+nA/krEo0cpDC6lAmA==
X-Received: by 2002:a05:6638:1922:b0:35a:fb33:36eb with SMTP id p34-20020a056638192200b0035afb3336ebmr4396895jal.154.1663778265901;
        Wed, 21 Sep 2022 09:37:45 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k4-20020a056638140400b0034f465bbd52sm1231175jad.42.2022.09.21.09.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 09:37:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <cover.1663668091.git.asml.silence@gmail.com>
References: <cover.1663668091.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/9] mix of 6.1 net patches
Message-Id: <166377826537.54625.17908942392343860263.b4-ty@kernel.dk>
Date:   Wed, 21 Sep 2022 10:37:45 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-355bd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 21 Sep 2022 12:17:45 +0100, Pavel Begunkov wrote:
> 0-4 fix a rare scenario when a partial I/O is completed with an error
> code rather than the number of bytes processed, which is especially
> bad with sockets and other non-idempotent files.
> 
> 5-9 add some net features, specifically 6/9 optionally transforms normal
> sends into sendto, and 9/9 adds zerocopy sendmsg.
> 
> [...]

Applied, thanks!

[1/9] io_uring: add custom opcode hooks on fail
      commit: 18b24300d6d3223192e69216d76ea273fa4b4f25
[2/9] io_uring/rw: don't lose partial IO result on fail
      commit: 7f4149434dbd8a9c356a959263b9e327bc5ed65b
[3/9] io_uring/net: don't lose partial send/recv on fail
      commit: 9a837772f2745351610e3554e193caf82e315bb3
[4/9] io_uring/net: don't lose partial send_zc on fail
      commit: 98e7a0e1c8102354ab28b46be737258739f7c92c
[5/9] io_uring/net: refactor io_setup_async_addr
      commit: 9f60a56760986bf3f2be3f906d2cd65215d0c065
[6/9] io_uring/net: support non-zerocopy sendto
      commit: ce6a8fdbb23f05cb3f6ddc6d0d76274eadf56a10
[7/9] io_uring/net: rename io_sendzc()
      commit: a7093eb542f723cc8f8e9d122d0aa82061f59ab4
[8/9] io_uring/net: combine fail handlers
      commit: 8cf8464184f4141294a9e86820b74a49e18a2436
[9/9] io_uring/net: zerocopy sendmsg
      commit: 2ec37c3b63d326147d7b70913b17c4ea3295c47b

Best regards,
-- 
Jens Axboe


