Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6EA6531682
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 22:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbiEWUQ1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 16:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbiEWUQQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 16:16:16 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E801FA6B
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 13:16:14 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id n23so20615608edy.0
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 13:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EA3FIBNNDoj02Qd5UyhoYbcYuhDKnQDkuCoIXsHPGWY=;
        b=Nfn7ww9o3d0ammGcjT3qgI9xxfAGwUBtkBtWkmxyujjnhZ5owJd6qJrN9TUYSY4B0G
         C8sS56B0FTy0zY8TGSBy7mCZaTgAYNDgfE2spXBFYauQ0VIko+BXGY6hGxZXyllmvji6
         JZ9lWCVYiTDJz49RoARM4qI73Jd0TIJVA2Yow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EA3FIBNNDoj02Qd5UyhoYbcYuhDKnQDkuCoIXsHPGWY=;
        b=MjlEucPKNaX+4aLr+R/QAZzgUhr8uG3W1sjlJK6G+JQhkSvHUzGetlHBlayvs3GRlN
         gwu51sil2BUhVzOy+CUPaGOmsjahE5c0U1HNOu2FSnlmwts4DZguZZ8GgFv5rBFH6E4Z
         8mxRIxY5o7YFQmWnT0a1TmBhVEeFHnxD2egiGjoTK/sQhGcsCcMGnGF2FpaBH2HcQVP6
         7yDZONB3J9ZrXLdKMvGSUeRFBsBdiIg0RXpccCCqJxOiGVWyS+vJl5rroil8kWZUSIhc
         kqVN+RRL4lV5lMGOwIbnsysJ2uqUivXGlnnExbeef1AADLMoTSo+euBCcT7qZ4nlmGSS
         W3lQ==
X-Gm-Message-State: AOAM532xFy/GOs22XYg8I4nGmGpeeeJ/WHAVVx72Fd8jT9LFCDkkeGMM
        X6vN4Xc+Yxms2VFqvHZz8zt6jwdRECaKfuIgiH0=
X-Google-Smtp-Source: ABdhPJxYDBHZATQpsxa/FEW0x8+H6TE5a9eL9hNqP9wefbbX2tBxQhucP380CKoCEGs00BBUeA4SjA==
X-Received: by 2002:a05:6402:368b:b0:42b:42c7:f63f with SMTP id ej11-20020a056402368b00b0042b42c7f63fmr13107905edb.409.1653336972886;
        Mon, 23 May 2022 13:16:12 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id j11-20020a17090686cb00b006feb047502bsm3932677ejy.151.2022.05.23.13.16.12
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 13:16:12 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id r23so22944527wrr.2
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 13:16:12 -0700 (PDT)
X-Received: by 2002:a5d:6da6:0:b0:20f:bc8a:9400 with SMTP id
 u6-20020a5d6da6000000b0020fbc8a9400mr14025325wrs.274.1653336971796; Mon, 23
 May 2022 13:16:11 -0700 (PDT)
MIME-Version: 1.0
References: <6f712c75-c849-ae89-d763-b2a18da52844@kernel.dk>
In-Reply-To: <6f712c75-c849-ae89-d763-b2a18da52844@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 23 May 2022 13:15:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=whfi3FE3O7KrziqPbyGvAmNFas3xxLz2O+ttzBkCOQmfw@mail.gmail.com>
Message-ID: <CAHk-=whfi3FE3O7KrziqPbyGvAmNFas3xxLz2O+ttzBkCOQmfw@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring passthrough support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
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

On Sun, May 22, 2022 at 2:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> This will cause a merge conflict as well, with the provided buffer
> change from the core branch, and adding CQE32 support for NOP in this
> branch.

Ugh, that really hits home how ugly this CQE32 support was.

Dammit, it shouldn't have been done this way. That io_nop() code is
disgusting, and how it wants that separate "with extra info" case is
just nasty.

I've pulled this, but with some swearing. That whole "extra1" and
"extra2" is ugly as hell, and just the naming shows that it has no
sane semantics, much less documentation.

And the way it's randomly hidden in 'struct io_nop' *and* then a union
with that hash_node is just disgusting beyond words. Why do you need
both fields when you just copy one to the other at cmd start and then
back at cmd end?

I must be missing something, but that it is incredibly ugly is clear.

                 Linus
