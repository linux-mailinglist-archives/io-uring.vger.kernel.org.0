Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE6E644A2D
	for <lists+io-uring@lfdr.de>; Tue,  6 Dec 2022 18:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbiLFRRV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 12:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiLFRRT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 12:17:19 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE24CE32
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 09:17:17 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id m15so6771135ilq.2
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 09:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vnw2xPvVO8oOmE+QWt+r7RB7ZKiATsnbepvL6xDiN7g=;
        b=0LeYep77pGkPineLutKJswL3Ed/PgcaTiKetLJ/JfNBxwO4wznf3PUW11aGHnQ9HXB
         Cor+0xOXmzIQrPRZMwkB686dYtqep4/1ODc1+IEFMqviHgSlIqer779L1b57gCUMrQdf
         wZyL/l0jTvx5agDoFXukDjg+U4iQMDCpDHnsnJsfXFv3hCWWqC4bypPihCg9/MN256ne
         oSiz8QUM99A9tQshcKfYmvg+3TnSIxtMCykGUByxsu2nYOK0W63rtzP7XHFQR+IMCT59
         MG5gOY5zc4yzDTv1W45+/KyNcVm5xgDzEIh8MTFme15t7GWRZrCaNVI1pnYLPQY0BFBn
         vzQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vnw2xPvVO8oOmE+QWt+r7RB7ZKiATsnbepvL6xDiN7g=;
        b=MHFc0nH+WmfR4pBt0Jje9+Pp4IdqshgxJ6zapEV2UaLEJdq/8Z7lMeLG+UwhctSlA3
         KAaZz5aXUgvks7lEq5KAv8ZTTjxRTWam9rGQ97Cm/0hbOWK9oxIz0JNvNq+I4rCutB3U
         3lbv0thef7/p+QBxzadDVQdC1ylOqCFRhZJzLHZ/uncYSLSO4L2u5iOTV45t4JbbmFQS
         /W96LnCpJH4xNFfi7Bd7uhYf9xSY2PsNx5HpZQCEIbPWi0rUSgbEmcTrloJo1fQdqo/D
         Xz16vNaDXUpToD2Y2p498n7w6jxAh+RNd2dfTcCAUYdSRqUKUgQQih9P01TXRpmXrr50
         HK3w==
X-Gm-Message-State: ANoB5pmBzr54DaWFgWnviRit1PO95mrKmNRIytyRizdrdO763tdlfy5B
        bYbXhyMnGDSVN+t99GX5GYgHTr9pJ5MyYgB92v8=
X-Google-Smtp-Source: AA0mqf7A2Lg+N/XVEQzk6oA/QaiUFeB7TlMGh2kKQ0qVnXEfYhbD2hghygJBar7YAWuC/76EdIGwdQ==
X-Received: by 2002:a92:a30b:0:b0:302:555a:f761 with SMTP id a11-20020a92a30b000000b00302555af761mr29940056ili.323.1670347037027;
        Tue, 06 Dec 2022 09:17:17 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v12-20020a056638008c00b0036374fc6523sm6908825jao.24.2022.12.06.09.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:17:16 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1670207706.git.asml.silence@gmail.com>
References: <cover.1670207706.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/7] CQ locking optimisation
Message-Id: <167034703635.331285.11373766340886831558.b4-ty@kernel.dk>
Date:   Tue, 06 Dec 2022 10:17:16 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.11.0-dev-50ba3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 05 Dec 2022 02:44:24 +0000, Pavel Begunkov wrote:
> Optimise CQ locking for event posting depending on a number of ring setup flags.
> QD1 nop benchmark showed 12.067 -> 12.565 MIOPS increase, which more than 8.5%
> of the io_uring kernel overhead (taking into account that the syscall overhead
> is over 50%) or 4.12% of the total performance. Naturally, it's not only about
> QD1, applications can submit a bunch of requests but their completions will may
> arrive randomly hurting batching and so performance (or latency).
> 
> [...]

Applied, thanks!

[1/7] io_uring: skip overflow CQE posting for dying ring
      commit: 3dac93b1fae0b90211ed50fac8c2b48df1fc01dc
[2/7] io_uring: don't check overflow flush failures
      commit: a3f63209455a1d453ee8d9b87d0e07971b3c356e
[3/7] io_uring: complete all requests in task context
      commit: ab857514be26e0050e29696f363a96d238d8817e
[4/7] io_uring: force multishot CQEs into task context
      commit: 6db5fe86590f68c69747e8d5a3190b710e36ffb2
[5/7] io_uring: post msg_ring CQE in task context
      commit: d9143438fdccc62eb31a0985caa00c2876f8aa75
[6/7] io_uring: use tw for putting rsrc
      commit: 3a65f4413a2ccd362227c7d121ef549aa5a92b46
[7/7] io_uring: skip spinlocking for ->task_complete
      commit: 65a52cc3de9d7a93aa4c52a4a03e4a91ad7d1943

Best regards,
-- 
Jens Axboe


