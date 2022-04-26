Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238E650FDA3
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 14:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347133AbiDZMyQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 08:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350196AbiDZMyP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 08:54:15 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4CD179EB9
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 05:51:07 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id p6so2188059plf.9
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 05:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Pz57Ghwlp6ifNH6m/KUmY8sb+fuj+WwLqXWt5iAfEx8=;
        b=rMhiaul/YWKa1xD4BeI3VR6vKGBOf7WM85UP+K2bajuV5gzbAHSeYggryNpuOLDv5k
         zCa0JLuc+sf10ikDyK1rGToH+/ni6kVJH28m0W2rWDxeoFzj0Je5kBWj8MmsRIQ4dA1r
         8urHt4E/Ud0MM0yldJWMk4aQtCu4soV8GARpYz2HOmbmgHuaQ0LU4z8V/SOYit8X6xbk
         UZ2YzP3+hKvc0fVQpCBlo/aJMEys6FoHEunFToZ2ciz5UqEO1mKPv29UmWAuHi1yv8zQ
         d7+ABEkL+/pdFVIXc4VKc6dhL13DxT/hy+s7fJkQfpLbNubZ/KzewuX0H02czn2XjFZl
         Du8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Pz57Ghwlp6ifNH6m/KUmY8sb+fuj+WwLqXWt5iAfEx8=;
        b=FyjD0qJDxQXoF1wukmZ0Wcr5acKfdnLK8esp6a6wmNWhJVvqGR5JGJVPQLIKJRd2n0
         O7n1dlJwGXSGTVqj7PcgiB2G1oiOTnZ7/h/kH4a2O01wiPaaQAye7rdGnK9jCqjLRucy
         KIHKY3Op4gPZXwYSwBDWNYlv3WknXfdJh5Hdl/MuFFz8asyf3LEgGzWf/P5LQJPk7dUK
         RdD2X/lWSliSclT4WIJ2ZSqsAVb2KJBARBGlSP3/V6IG8WlFBxWAFPGVzP/bxLCptqkc
         qoGIFxQwNiGs/S0xsb7I5ofuHI3nzR2QmuvVzil+ZNChHw+qK7Sp+lfXOhbQVDAmJ1/R
         pM2w==
X-Gm-Message-State: AOAM531DgQZqsT62X4tvw35Pi7CRNJaZ5TCF9Xe2UPZX0aPD0kplgiMz
        b8ewhfJlc9AQWQZirwCMbfR15x/2YApbmGBA
X-Google-Smtp-Source: ABdhPJyzsltO1xgaWhua9FqZiBiVI+kyjPr5d5O/3+FrknN61iWrO7g9Ak90vpnFycmQT96dwTAqAQ==
X-Received: by 2002:a17:902:76ca:b0:157:1c6:5660 with SMTP id j10-20020a17090276ca00b0015701c65660mr23280633plt.105.1650977466801;
        Tue, 26 Apr 2022 05:51:06 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ns21-20020a17090b251500b001d9b7fa9562sm2105876pjb.28.2022.04.26.05.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 05:51:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, dylany@fb.com
Cc:     Kernel-team@fb.com, asml.silence@gmail.com
In-Reply-To: <20220426082907.3600028-1-dylany@fb.com>
References: <20220426082907.3600028-1-dylany@fb.com>
Subject: Re: [PATCH v3 0/4] io_uring: text representation of opcode in trace
Message-Id: <165097746566.8372.12503074441658351941.b4-ty@kernel.dk>
Date:   Tue, 26 Apr 2022 06:51:05 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 26 Apr 2022 01:29:03 -0700, Dylan Yudaken wrote:
> This series adds the text representation of opcodes into the trace. This
> makes it much quicker to understand traces without having to translate
> opcodes in your head.
> 
> Patch 1 adds a type to io_uring opcodes
> Patch 2 is the translation function.
> Patch 3 is a small cleanup
> Patch 4 uses the translator in the trace logic
> 
> [...]

Applied, thanks!

[1/4] io_uring: add type to op enum
      (no commit info)
[2/4] io_uring: add io_uring_get_opcode
      (no commit info)
[3/4] io_uring: rename op -> opcode
      (no commit info)
[4/4] io_uring: use the text representation of ops in trace
      (no commit info)

Best regards,
-- 
Jens Axboe


