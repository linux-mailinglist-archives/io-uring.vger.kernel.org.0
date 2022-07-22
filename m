Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1440257E3A0
	for <lists+io-uring@lfdr.de>; Fri, 22 Jul 2022 17:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234812AbiGVPVn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jul 2022 11:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbiGVPVm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jul 2022 11:21:42 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C563793601
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 08:21:40 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id z132so3905498iof.0
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 08:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=lu6edPMdEGjnOYcCO1GoY5J754b4rIPhEW+ZQl3jzlc=;
        b=koeuRv+AkHsNVymF/A7qNBN2vz8VoCpIaT4vUwdYUyZiB1X7kc+QVr8YzlfVzPjsB+
         rSnquFqhwv1ZSrKGTzRddve5FQzpV7OIFwRO2mfPMrsPq3i/xo3HT+jsPYP0yJmG042R
         QDUD1/9XixYJV2nb+EP9UXYgG4KxLKerlbFnZwTCSbIUxINhemdbtDrnrsCTeDUmj4XX
         W68L7ht/YPhTpjQ9bvPrLX5DJWLX6sFHjLbJbiywHpC1L8fc+f0aULbCLCwJcDFBNXlF
         XkmilgE1VzD74T8Tqex4/GUhmX9eRd+SvJOhtbob+aMrhaypZnAjexvJ5gf63hMRlIr8
         DWzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=lu6edPMdEGjnOYcCO1GoY5J754b4rIPhEW+ZQl3jzlc=;
        b=DdUgDTsoKudj17kjw9KCbnmz82tq0H8FZ0D5KMPVgCaUq6EsqMnykREjzUs8wrbZ2S
         u6aPXZywKq0wgPAI34GRJnquIO2nPhyVCvXQH68ReqAwrIgcjMG+JzYVYBz5smAOI4gD
         dt2gU6w6u3OMLsVxnLH+oZttHH6Ja9BCKSdi6f09Ol/kuq9sbcmg+2E7AzbSRGvlLy8l
         9tVH/5PO1FQ33bgKJSYo4gY3COhobmjehhTtnJgxjyUukOMwlSAtzSi+hh3D5z56IsIn
         soQ/yyJBLB4yTSM8vN1IfYM52Dct1T2QDO09/RqRLbhAKwpX5eyD+C8CUSaA2gYceEtW
         X+Dg==
X-Gm-Message-State: AJIora9fiMk4fgQsT6aEHQg6M4u8KcEUdbFNPW2G6fr5axqYdKlf4we+
        Vq5O/pWAklF06LmVMnl+QNOV07fUhwZ89Q==
X-Google-Smtp-Source: AGRyM1ucZUPjx7kicz0fZ7zpZ+CLEDUUU+R3Uz3hEjbjt/hl9b8A74bjwgJne5OyUOZdXFxMiK5EFA==
X-Received: by 2002:a05:6638:4394:b0:33f:3e15:ef88 with SMTP id bo20-20020a056638439400b0033f3e15ef88mr267149jab.248.1658503299937;
        Fri, 22 Jul 2022 08:21:39 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t10-20020a92dc0a000000b002dce032d817sm1846646iln.81.2022.07.22.08.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 08:21:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <cover.1658484803.git.asml.silence@gmail.com>
References: <cover.1658484803.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 0/2] single issuer tests and poll bench
Message-Id: <165850329890.235904.2867046538879716531.b4-ty@kernel.dk>
Date:   Fri, 22 Jul 2022 09:21:38 -0600
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

On Fri, 22 Jul 2022 11:37:04 +0100, Pavel Begunkov wrote:
> Add some IORING_SETUP_SINGLE_ISSUER testing and poll benchmark.
> 
> Pavel Begunkov (2):
>   examples: add a simple single-shot poll benchmark
>   tests: test IORING_SETUP_SINGLE_ISSUER
> 
> examples/Makefile     |   3 +-
>  examples/poll-bench.c | 101 ++++++++++++++++++++++++++++
>  test/Makefile         |   1 +
>  test/single-issuer.c  | 153 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 257 insertions(+), 1 deletion(-)
>  create mode 100644 examples/poll-bench.c
>  create mode 100644 test/single-issuer.c
> 
> [...]

Applied, thanks!

[1/2] examples: add a simple single-shot poll benchmark
      commit: 8200139273363c9d30d6b2db187f33508b6cd49f
[2/2] tests: test IORING_SETUP_SINGLE_ISSUER
      commit: bda30ea972839abdd1e7a0ecdef83e00ff9db7c8

Best regards,
-- 
Jens Axboe


