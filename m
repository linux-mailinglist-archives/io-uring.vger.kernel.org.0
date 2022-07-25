Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD7858022E
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 17:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbiGYPtC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 11:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbiGYPtB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 11:49:01 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995D9DEE7
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 08:49:00 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id l24so9088303ion.13
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 08:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=sGJ0zRynPcRnh4Vmjh7w//xnQvVr8wE5mTRuKp7iRUs=;
        b=mgjG7rIX8/miVARaLUrwY9TIR2f5NvCQhWoaxnCvsvm2fsu69SZbSNlxIQNYSE9qyX
         Bni3aYoKUqvy9BZ03+Nt/mLwwlzANkC/ANNDzk+cVlw0VJSGZqIExkXWZHh37iEbfJsG
         O3k3y7ySE/dmDc8dEJj0/lihdSxtHa93RDPJEIb65S3MAUyWOdp4wPwhsOh+qnzyQc9q
         yg7Rlw1+q4KNMZhb3D9aFO6NOes8xqLT6txPLDqL2jD+4fYewRO9kawZ/JGAk7jS0OB7
         hqmERcGSqSCE2cXLLmoIdEW5XXx8iQnL235CT0jBOFTn3eDMRWmg8FpAa43TWnMD4Snn
         xmJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=sGJ0zRynPcRnh4Vmjh7w//xnQvVr8wE5mTRuKp7iRUs=;
        b=IIjUQ0WI8+B6oEMvsxOXE3TnKEv+6/LNaNNanulVatZScYpmyRg+yNn75LBtedoYCN
         5q6MnzdVlF5/kyc4hlwvZGRGFyj0pjlU3RCob+i5qhbonnyGDh0TwUeW4nA779sMqjD9
         kmYqZrqDTJ2I7xpe+sx5sM2cI4a9uUYubaGDjGFjnPDbpjKOgZzHhJZDGqaUe48k2jk/
         93kZkwU9sBGNMwzQFyROK6v1trA9O7uwnVctEIntEyHnYaP3yAwjqEYMQ2/KliNXWOrC
         0msJITS78Q6tG4waYSWM9SKOG88opHz7EXjQpiJTS2VfDt36va15fLayT+QNrGOYyplH
         C/wA==
X-Gm-Message-State: AJIora/ixvx81XcThiE+4ySfgVvpQwQIUUhat4YFD6VZxfJniBHo9Gg8
        yPjYneJmnshdICSjC7FUSmuolTs21yI8mw==
X-Google-Smtp-Source: AGRyM1tyYjKCnQeqvYTEsDtp6HR7Stse+4R8K0V5XJc7bHc+Hnir9ddglZOSprahp25WLTFdGW1CQA==
X-Received: by 2002:a5e:8f0d:0:b0:67b:d8fa:7bab with SMTP id c13-20020a5e8f0d000000b0067bd8fa7babmr4701708iok.118.1658764139932;
        Mon, 25 Jul 2022 08:48:59 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y6-20020a92d206000000b002dc10fd4b88sm4868156ily.29.2022.07.25.08.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 08:48:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
Cc:     ammarfaizi2@gnuweeb.org
In-Reply-To: <cover.1658748623.git.asml.silence@gmail.com>
References: <cover.1658748623.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 0/5] zerocopy send headers and tests
Message-Id: <165876413920.1091866.13314205448104071871.b4-ty@kernel.dk>
Date:   Mon, 25 Jul 2022 09:48:59 -0600
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

On Mon, 25 Jul 2022 12:33:17 +0100, Pavel Begunkov wrote:
> Add zerocopy send headers, helpers and tests
> 
> v2:
> 	use T_EXIT_*
> 	fix ptr <-> int conversions for 32 bits arches
> 	slight renaming
> 	get rid of error() in the test
> 	add patch 5/5
> 
> [...]

Applied, thanks!

[1/5] io_uring.h: sync with kernel for zc send and notifiers
      (no commit info)
[2/5] liburing: add zc send and notif helpers
      (no commit info)
[3/5] tests: add tests for zerocopy send and notifications
      (no commit info)
[4/5] examples: add a zerocopy send example
      (no commit info)
[5/5] liburing: improve fallocate typecasting
      (no commit info)

Best regards,
-- 
Jens Axboe


