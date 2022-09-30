Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166E25F0CFC
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 16:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiI3OFF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 10:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiI3OFD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 10:05:03 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADC269185
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 07:05:00 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id d8so3317934iof.11
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 07:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=KE/La02ogRQIY/HzxSEopjUhIfT01GVed+k6zu427FM=;
        b=eTSscY00rOLUJHWuFQyJIl59dQGpUSoWvHHwSfNnFKA4Lw44WSKU49+jZTWN47Jnf5
         55R/FwWHdwkFedGF7J3APM2KsySrM9JgactJUB3aSET9yPsj9KVjVwyT4ZLrz+OD+KKV
         AhfLWzDGtUjoMr5OXEttfZYzZDT4hj0bjxzcqlI1syLfAFm+CjXjGbkI72jZhUIib47a
         TiVeQlPuyIFn+ebZpyH/8DYCExfqdWWWzDillNjOUNcotehAMdGUndCvUHfH4w0GpLJq
         ughRo26e9JqrBgCkOHoGxXOjnjLv3PQ8AiiKFqEgltASsaQc8z5EH/ExdZCSOWlOJt00
         kMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=KE/La02ogRQIY/HzxSEopjUhIfT01GVed+k6zu427FM=;
        b=5QfVVwi9E+lQtnBdaZ0a/XVhcxSK0VwU7zjO47owIzOmBGJ1ERzfuoBtn6cO/6EvBP
         McDqR4PnIFxO9Vexvx1RTv0y2UnaLgk1Jl/DKgEIHC2YBJewyj2/7U8D/dgbrPkN7hGy
         OAfOHsVQwUW7E5bKZtufQrrT9JlzYEDz7M0YFyYp9qYZnZORPiQPSKdW9bE+s/YG8u8E
         UwPPrm8HB97owYIWYFLFIrrKCJSt1diClY3sv85/XrEmVtEUvqCPcWrv1v+vN1lK5xMJ
         GFK3J9zCW4oerUISnljhC8ENg0dhlMedGEZZEuQAjVRRPZfybHIu1h7tpofpCVytngyb
         TrPg==
X-Gm-Message-State: ACrzQf2tVpqZGP4FLgw7q/HZZfEjgQ5rApep7aCrTNgKYNG6ke1VT888
        pwyuVrEoXR03grrRzWDM4R3eag==
X-Google-Smtp-Source: AMsMyM4JtLxVJcRSJ6Gida3IQoin845TBOh5Ewp8EzEnzwL947qn7d3mtbmSE+hpAqBx4RR26Cvc1w==
X-Received: by 2002:a05:6638:1449:b0:35a:70ce:8a3f with SMTP id l9-20020a056638144900b0035a70ce8a3fmr4631148jad.42.1664546700214;
        Fri, 30 Sep 2022 07:05:00 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y4-20020a027304000000b00349d2d52f6asm963095jab.37.2022.09.30.07.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 07:04:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     kbusch@kernel.org, Anuj Gupta <anuj20.g@samsung.com>, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        gost.dev@samsung.com, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
In-Reply-To: <20220930062749.152261-1-anuj20.g@samsung.com>
References: <CGME20220930063754epcas5p2aff33c952032713a39604388eacda910@epcas5p2.samsung.com>
 <20220930062749.152261-1-anuj20.g@samsung.com>
Subject: Re: [PATCH for-next v12 00/12] Fixed-buffer for uring-cmd/passthru
Message-Id: <166454669913.10664.15099234392865928285.b4-ty@kernel.dk>
Date:   Fri, 30 Sep 2022 08:04:59 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 30 Sep 2022 11:57:37 +0530, Anuj Gupta wrote:
> uring-cmd lacks the ability to leverage the pre-registered buffers.
> This series adds that support in uring-cmd, and plumbs nvme passthrough
> to work with it.
> Patches 3 - 5 carve out a block helper and scsi, nvme then use it to
> avoid duplication of code.
> Patch 6 and 7 contains a bunch of general nvme cleanups, which got added
> along the iterations.
> 
> [...]

Applied, thanks!

[01/12] io_uring: add io_uring_cmd_import_fixed
        commit: a9216fac3ed8819cbbda5d39dd5fcaa43dfd35d8
[02/12] io_uring: introduce fixed buffer support for io_uring_cmd
        commit: 9cda70f622cdcf049521a9c2886e5fd8a90a0591
[03/12] block: add blk_rq_map_user_io
        commit: 557654025df5706785d395558244890dc4b2c875
[04/12] scsi: Use blk_rq_map_user_io helper
        commit: 6732932c836a4313f471b92b4d90761f31d3fa81
[05/12] nvme: Use blk_rq_map_user_io helper
        commit: 7f05635764390d5f811971af9f4c89b794032c80
[06/12] nvme: refactor nvme_add_user_metadata
        commit: 38c0ddab7b93daa90c046d0b9064a34fb0e586e5
[07/12] nvme: refactor nvme_alloc_request
        commit: 470e900c8036ff1aafeb5f06f3cb7a375a081399
[08/12] block: rename bio_map_put to blk_mq_map_bio_put
        commit: 32f1c71b15fc9cb8e964c3d0c15ca99a70cfe8a7
[09/12] block: factor out blk_rq_map_bio_alloc helper
        commit: ab89e8e7ca526ca04baaad2aa28172d336425d67
[10/12] block: extend functionality to map bvec iterator
        commit: 37987547932c89f15f9b76950040131ddb591a8b
[11/12] nvme: pass ubuffer as an integer
        commit: 4d174486820e625fa85bac5d4235d4b4cb659866
[12/12] nvme: wire up fixed buffer support for nvme passthrough
        commit: 23fd22e55b767be9c31fda57205afb2023cd6aad

Best regards,
-- 
Jens Axboe


