Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0677710E9D
	for <lists+io-uring@lfdr.de>; Thu, 25 May 2023 16:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241362AbjEYOyh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 May 2023 10:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241214AbjEYOyh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 May 2023 10:54:37 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C0F189
        for <io-uring@vger.kernel.org>; Thu, 25 May 2023 07:54:36 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-77479a531abso16545739f.1
        for <io-uring@vger.kernel.org>; Thu, 25 May 2023 07:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1685026475; x=1687618475;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+rSHBWkBgS2mm8ALT6WvzGN5/+TkGxD7ynUj1kfMsBQ=;
        b=xbd0kecRRx+9NWW2PIoMEfqgPX0CRT1+PNfTWRD27rP6SGjEA08oc2g1ig6qytqArt
         hxT8emqjIMV+G/8/gMmi49z+HQ/9tAjIdEyPo7LPANxGF9HJoYnm+MLwMWFygdBh3uQ2
         lyw0gvPILXzUW6eI2WgP4+TIOmIxnj5pQYVGXlUGwOP2hxzwqn1DtoLLCDApR2lY50+w
         DkNLqerJzwQT2iG5CfgwyEf5ehHUQTVjkHw5EUGwRzB9gemxMQtul7GDRdUHW3c1KkTH
         OH5Md4o2jll6AEZql2Yoxq2VZawK2EbwkhemknYhEfew0w/vKszegAFX5NxaHMt6fou4
         T39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026475; x=1687618475;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+rSHBWkBgS2mm8ALT6WvzGN5/+TkGxD7ynUj1kfMsBQ=;
        b=dE3La4txlCzb8OhfhVLv/H62437QyTnzdtg100MWnoL/MWL3NFEl4P+0/jyNJZcjuL
         1iBs/Gwua19dkwPF7Q53zzY1qHIB6LNmwTiBxB1l96ode3fCO1hpdkKmBUPrJKAElqsL
         cyQNLqwR7xKJqNcWrttdi52wSEXOcH3IgmP9VVY7NZJWwPn2DM73DMaRyHVYlk+THVYu
         pchpmhFg3ltxLi13uRNijvEANWb+txNeQZGtrkianpobeNHYe4Vfxs7rOUjd/9pZFqwd
         GsAjCAlPCs6QV8Ucl5Ajbu29881i/DFXH4O5s7m6opTlmJj5lfn0UaEyx+2RJfWxdNVl
         awVg==
X-Gm-Message-State: AC+VfDz/qqsyJUah9oH7dYDgcARh1Bq5Mhm2aGW0rkJD26I/HqOjXS5o
        ndaDuyehmCBpi++CGTW3J7tZ2Q==
X-Google-Smtp-Source: ACHHUZ7LB78/pRUlJbEGNmv97WHmzS3adTxZS+I/k6g+L59//3zumtt9ceLdjobbR+UUxoF4QMs8NA==
X-Received: by 2002:a5d:9d9f:0:b0:769:8d14:7d15 with SMTP id ay31-20020a5d9d9f000000b007698d147d15mr4546756iob.0.1685026475368;
        Thu, 25 May 2023 07:54:35 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ei24-20020a05663829b800b00411bf6b457bsm480532jab.101.2023.05.25.07.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:54:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joshi.k@samsung.com
In-Reply-To: <cover.1684154817.git.asml.silence@gmail.com>
References: <cover.1684154817.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/2] Enable IOU_F_TWQ_LAZY_WAKE for
 passthrough
Message-Id: <168502647392.717124.7925068931544884226.b4-ty@kernel.dk>
Date:   Thu, 25 May 2023 08:54:33 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 15 May 2023 13:54:41 +0100, Pavel Begunkov wrote:
> Let cmds to use IOU_F_TWQ_LAZY_WAKE and enable it for nvme passthrough.
> 
> The result should be same as in test to the original IOU_F_TWQ_LAZY_WAKE [1]
> patchset, but for a quick test I took fio/t/io_uring with 4 threads each
> reading their own drive and all pinned to the same CPU to make it CPU
> bound and got +10% throughput improvement.
> 
> [...]

Applied, thanks!

[1/2] io_uring/cmd: add cmd lazy tw wake helper
      commit: 5f3139fc46993b2d653a7aa5cdfe66a91881fd06
[2/2] nvme: optimise io_uring passthrough completion
      commit: f026be0e1e881e3395c3d5418ffc8c2a2203c3f3

Best regards,
-- 
Jens Axboe



