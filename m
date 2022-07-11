Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939F1570C34
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 22:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiGKUyG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 16:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbiGKUyE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 16:54:04 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8762152DC3
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 13:54:03 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id y14-20020a17090a644e00b001ef775f7118so9486914pjm.2
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 13:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=R7+l4WsZkOWH4sTR/mnUL90qoQHQKoxb+wJHf4OAjiA=;
        b=fWEuQbVmcU1RVysVvfduVoKWgbPrTKgPpATn/tafq4sVKpqtg3kEP3vGejcDwRM8Uw
         FUEhTbkIZ8NWQ+OFKn22d45Yts7E3teCS8bfV/YpqQ7pmQ0KKH7witA1l7bY9BT5ltI3
         174WiIw0Tr4tnRkFVR63YA4D102N0gGarjjyyJ7D6YT7/j059pGkR/BxEXejNlruPJuV
         J5eaBsy0TKQK+218fXUmA/+UYJFXUxajkFAU9kq8RiKKVyzSKooMg9XgLVHafsUdQXDl
         306blfxdU7ifyIgOTIPvuSHMjOvzURk2RRWrt0BlI4Z7p9UvHM5bIZDFUgjiFs2ZiYC8
         b6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=R7+l4WsZkOWH4sTR/mnUL90qoQHQKoxb+wJHf4OAjiA=;
        b=exx7znXaf4L671Wntwxir26D12OPfjG+qlEC3/LrOd7d3b+HqleXvm/sTxXY5MZBj8
         l6MGNSTVhh19EavYjeV5PTlltYY2KqKGFywXw2eDLcJwVIryoRetY36h1EBaMCrfCuxK
         VkqkkbX4ODPgUxCPNZvSCSFRbqXHV2NbyMOUM2OAw8poIMCZj0+wNuF3LcaKQtFLNiMc
         tqSRMJ0nN0E7ow3TY2bfGq4AWsIQBFgM0gniTpRDeo7/LiE0x7oZWTQ5cMOJj9IP2uzH
         xj5YKkmTWhPpbGUeUVuWEQ2/BfvMde8YWCam7B5uIVOGDXZx/vzEIfQ7/GE27qtpOfvx
         Urog==
X-Gm-Message-State: AJIora9gnYF7juMUuw+9Dn+khNC72rqXhvl+vELnCBKQT0iqKZl/EikA
        gPMxi0ucVJAYltcc1PKv/rZuH0ViCzP8jQ==
X-Google-Smtp-Source: AGRyM1sgXRWw8NkMb0QrQBBNUQXDufN1U6E3rp/dZRGiZXDFx5RVoZbwHmltyV1WfS6N076vGjAQ0w==
X-Received: by 2002:a17:90b:1bc1:b0:1f0:3830:8c99 with SMTP id oa1-20020a17090b1bc100b001f038308c99mr275986pjb.1.1657572842766;
        Mon, 11 Jul 2022 13:54:02 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f14-20020a170902ce8e00b00168b113f222sm5168875plg.173.2022.07.11.13.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 13:54:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, dylany@fb.com, asml.silence@gmail.com
Cc:     Kernel-team@fb.com
In-Reply-To: <20220708181838.1495428-1-dylany@fb.com>
References: <20220708181838.1495428-1-dylany@fb.com>
Subject: Re: (subset) [PATCH for-next 0/4] io_uring: multishot recv cleanups
Message-Id: <165757284193.7498.706663220651867415.b4-ty@kernel.dk>
Date:   Mon, 11 Jul 2022 14:54:01 -0600
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

On Fri, 8 Jul 2022 11:18:34 -0700, Dylan Yudaken wrote:
> These are some preparatory cleanups that are separate but required for a
> later series doing multishot recvmsg (will post this shortly).
> 
> Patches:
> 1: fixes a bug where a socket may receive data before polling
> 2: makes a similar change to compat logic for providing no iovs
> for buffer_select
> 3/4: move the recycling logic into the io_uring main framework which makes
> it a bit easier for recvmsg multishot
> 
> [...]

Applied, thanks!

[1/4] io_uring: fix multishot ending when not polled
      commit: a8723bb79e40713f6c27564b1d17824d7ff67efb
[2/4] io_uring: support 0 length iov in buffer select in compat
      commit: 20898aeac6b82d8eb6247754494584b2f6cafd53

Best regards,
-- 
Jens Axboe


