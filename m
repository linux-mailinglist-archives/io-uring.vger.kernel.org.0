Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A022E4FE643
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 18:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245117AbiDLQt2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 12:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238549AbiDLQt1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 12:49:27 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A8553B50
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:47:09 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id j8so17269893pll.11
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=PhC39VF2R378p6W0ZCW2YmZlmGvdiiDLiBtxpaG9HzA=;
        b=ONFsu5ydyBNrt50qD8FlmpeUZiObYsYczg5RjhWWudTwvKio821KTd33tLQ0wobOnz
         gb7H/fnpHnksjLRXPUUOY8/77oLGfCj1Y1nngq/5Y+iGPguU6t09pIhT6kmcDnBIvJ89
         ll9L8dFko8/ga/hAjdBCVS/trSqspb3O57KxKzUtJbWF01SxQy8c1QWgHeRcgvP+Whey
         gF+NOlFSiQNUug3Qybezbi6KUPVI4mGQrOCWxa0mvTyHLxP5cm6YepuEBZ3UW/KQno3I
         xkweKg7YGXuS/FCAsNaKx25BPBzwcwjJ64JlnN6QgLB99Dq8kcXdqQ49sUo8UrtSTmuL
         hzXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=PhC39VF2R378p6W0ZCW2YmZlmGvdiiDLiBtxpaG9HzA=;
        b=wPP20YDFSxLNZA8FIveZpDe3b4/a8BFfDvWLeEdOJ5wAA4MKo8CnKiw/LEgy7rLHwy
         W0P7XsF+kw6jRw1rRjC0tuAlbKbBZ2LB8ILPSalqEu9efwePAuP27TN+PeR5+CYcJz9X
         563P9Hzfyzzu9urMXpx7Ixa1DEdOSSe8A/AMGQr1oGzVxXwDzDIpRT1grcruCHoNFwlb
         k/0AVrOcfuoAN3Coi4d98Xipjrz58SFvZfypq2eDFG5A8ZZnTJWBH9CiezH/B2NXscwk
         Y0xQVFeaawll2sQofltSlpsoAKIGlBQBnjGYA2b4Q10/OlgfVH67d82baTrto/ki5ptX
         BaUQ==
X-Gm-Message-State: AOAM5326Pxpmg3eR7tFM3ZBfr2/dP7fS+JJvfugXH6apeUB62nnu6t/U
        RsWeUyJAFiaYDzlf013DO2uyTw==
X-Google-Smtp-Source: ABdhPJx1VAwSf2YNvbCRKsvPJbgkiPzq/4+uoiZK+MSiNZx/XK97x+1JA/2cEfmftG11Hvp4pNRwzA==
X-Received: by 2002:a17:902:d2ce:b0:158:6aaa:94e with SMTP id n14-20020a170902d2ce00b001586aaa094emr10071752plc.51.1649782028892;
        Tue, 12 Apr 2022 09:47:08 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b2-20020a056a000a8200b004f1111c66afsm42963807pfl.148.2022.04.12.09.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 09:47:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     dylany@fb.com, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com,
        asml.silence@gmail.com
In-Reply-To: <20220412163042.2788062-1-dylany@fb.com>
References: <20220412163042.2788062-1-dylany@fb.com>
Subject: Re: [PATCH 0/4] io_uring: verify that reserved fields are 0
Message-Id: <164978202800.150007.4276154311788541180.b4-ty@kernel.dk>
Date:   Tue, 12 Apr 2022 10:47:08 -0600
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

On Tue, 12 Apr 2022 09:30:38 -0700, Dylan Yudaken wrote:
> A few reserved fields are not verified to be 0. In preparation for possibly using these fields later we should verify that they are passed as 0.
> 
> One extra field I do not have confidence in verifying is up.nr in io_register_files_update(). Should this also be checked to be zero?
> 
> Patch 1 in this series just moves a validation out of __io_register_rsrc_update as it was duplicated
> Patch 2-4 add verifications for reserved fields
> 
> [...]

Applied, thanks!

[1/4] io_uring: move io_uring_rsrc_update2 validation
      commit: 565c5e616e8061b40a2e1d786c418a7ac3503a8d
[2/4] io_uring: verify that resv2 is 0 in io_uring_rsrc_update2
      commit: d8a3ba9c143bf89c032deced8a686ffa53b46098
[3/4] io_uring: verify resv is 0 in ringfd register/unregister
      commit: 6fb53cf8ff2c4713247df523404d24f466b98f52
[4/4] io_uring: verify pad field is 0 in io_get_ext_arg
      commit: d2347b9695dafe5c388a5f9aeb70e27a7a4d29cf

Best regards,
-- 
Jens Axboe


