Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7015916D0
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 23:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbiHLVoM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 17:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234678AbiHLVoJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 17:44:09 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1250B089D
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:44:08 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id dc19so4048430ejb.12
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=xL1XSq47BmvTh+ek8hb0kiR6Xt+/rAkCanCeFsSgq5I=;
        b=c7d8c/kLqOGEHyGLvkfCFEXNQB4h7LPFozvOrV2rDZUIcxjS6nYEuCJUSLs5lV6WFv
         0qPNw5r3k9avx5dhMs1CwrV0X9s26YVe6qgZCYUCLnIDTwtXcf2cUx1f+4OnUlMnGSlg
         44WSrEngmFYYqRdpu/X4LDJJCEXwZWGE+Rsno=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=xL1XSq47BmvTh+ek8hb0kiR6Xt+/rAkCanCeFsSgq5I=;
        b=uDn9MpeWEUKVJ697Ve5VSwBwHiQioBKJwSBgHO4YBugKFDvy5PTypUHt40hIPfyFzi
         NpqNbQ9fM4TVnE6whMeTcMwrPiaVFE2kXjpmqLfv9fzLVeYc0c0sdXI8Nw34/I+M16s1
         Kg6RRErtM9x7vfVpEOobTUv9PfMKnPwyUDWACBlEMjPZRet3reQ9FPsiQZXBdP6Z6Au8
         rWrZu8i88vrXfipJSbK+qP4qOUS99MUAsaFRY0Gv/3ti47Y3qaGxinSXMA3qJLesel2v
         7Ktd+9ZJVs0A9+x3aszCTx5sX1F7sQ2V9J/8hpWXjwxKwAMcxoCaegLQWW5YG779+vjj
         RIuA==
X-Gm-Message-State: ACgBeo0kNuvkHCuut/uz2sy/yx6D4011EDr0cDYSkajMiPyZD/iS3wth
        QAES2+i4Saa97UV1h2Ifa/Lc1W0TP6s3j36k
X-Google-Smtp-Source: AA6agR4Ur1NQy3Tg1PvPrVm/k0Mhwbvwo5uQ/44PIL8tj2u6hT0yvJdI0RQE4a9lF8rgSI49d8JYNw==
X-Received: by 2002:a17:907:2896:b0:730:983c:4621 with SMTP id em22-20020a170907289600b00730983c4621mr3833783ejc.502.1660340647228;
        Fri, 12 Aug 2022 14:44:07 -0700 (PDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com. [209.85.221.49])
        by smtp.gmail.com with ESMTPSA id c15-20020aa7d60f000000b0043d6ece495asm1969254edr.55.2022.08.12.14.44.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 14:44:06 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id z17so2446132wrq.4
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:44:06 -0700 (PDT)
X-Received: by 2002:a05:6000:178d:b0:222:c7ad:2d9a with SMTP id
 e13-20020a056000178d00b00222c7ad2d9amr3115454wrg.274.1660340646177; Fri, 12
 Aug 2022 14:44:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk> <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
 <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk> <433f4500-427d-8581-b852-fbe257aa6120@kernel.dk>
In-Reply-To: <433f4500-427d-8581-b852-fbe257aa6120@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Aug 2022 14:43:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
Message-ID: <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[ Crossed emails ]

On Fri, Aug 12, 2022 at 2:34 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> Keith brought up a good point, is this some weird randomization of
> io_kiocb that makes it bigger? struct io_rw is already at 64-bytes as it
> is, if it gets re-arranged for more padding maybe that's what you're
> hitting? Is it just io_rw or are you seeing others?

I think was seeing others (I got hundreds of lines or errors), but now
that I've blown things away I can't recreate it. My allmodconfig build
just completed with no sign of the errors I saw earlier.

I think Keith is right. An allmodconfig build for me has

  CONFIG_RANDSTRUCT=y
  CONFIG_GCC_PLUGIN_RANDSTRUCT=y

and the io_uring "type safety" isn't actually typesafe: it just checks
the size of types.

The other alternative is that we have some build dependency issue, and
blowing away my old tree fixed things. But that sounds unlikely, we
haven't had those kinds of issues in a long time.

           Linus
