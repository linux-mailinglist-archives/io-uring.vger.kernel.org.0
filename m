Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF2C6DFD3B
	for <lists+io-uring@lfdr.de>; Wed, 12 Apr 2023 20:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjDLSKO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Apr 2023 14:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDLSKN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Apr 2023 14:10:13 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535A7132
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 11:10:12 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-328790455e2so633595ab.0
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 11:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1681323011; x=1683915011;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f0XKsuk94p6K14Aj9zEPZKmNw1sL/GqrA3wxwlf/UYA=;
        b=zDquSbT3SkjalV6vDkmj11O2Nx2WAmVGNwHRFHpnpkN0NdBGW5cbKolg3kNy3iP368
         iMgfWqQkKrhXk8tuGWFZVcHYXY0QXiYffeP1GBW8S+Vk6isYk1BR2gxVSptcd/N4LcMB
         6m1AtBOl/E5lq+jwoTtmqHCuz0QD+DTyFNtuuB+Ky2lpzlN/9JKzOcm7WGKklhJ8ghWc
         9/UhZ/GBmkfO/1cOI8UF+gFt2i6hDrTQ0VPx5fY9geq2I+iwDnDmwDATHP0G34rlbjLp
         LceUlkruqg8AiZXgTUbu9KpGASXtdI2WRyfeejknkzgE8qweBTToddy0OXe9JoRZ0fgs
         7zAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681323011; x=1683915011;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f0XKsuk94p6K14Aj9zEPZKmNw1sL/GqrA3wxwlf/UYA=;
        b=kaE1rIBNwLF46s3082L43L5HVLI2AyfmKKYlt1UhBVkJO6ZAWIkqZXp3KjBjQrRGZG
         q9PiPN0Na78OJtKSVpZNivtjowvOOKd8jizfPgn5R2Fq3lEZPoJB06ZSuoJjVdeyBXz5
         0D+xucxWFK2bg6Hf+ZCXvQwbWAXXmYoJelNQjf3+FIVFML94nE2HW4JltBwr50LsnqH8
         hCPfFTTAzi32CGeJQFl8F71vxg2HQY+sK2svYl9wN5Asb6ccqBwAICbHcuO07rIvaXKj
         Tum4mxNd9JGjP30A7YVA2/uc38r+Dc2wrBX0FoXjkQumbt69U8C55Dk5RzpxZ6ZZSSxN
         Zh9w==
X-Gm-Message-State: AAQBX9fqMI0Fb4J8gWC3P1Lx7lrtVx3NMTR+xZQiCEQX1sXXc9iN8O+G
        j/9eo88/L8qbPMECpA8YYDhM/ngvJ96x8Sk7yOo=
X-Google-Smtp-Source: AKy350bLUi2z6dKg3snk5LhlBVcUjT/SY7U4XyrRYfE57I3gw3UsmZ4lA/QLmbmq7tkn1mI3po3tXg==
X-Received: by 2002:a05:6602:1652:b0:758:5653:353a with SMTP id y18-20020a056602165200b007585653353amr2050785iow.0.1681323011662;
        Wed, 12 Apr 2023 11:10:11 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t11-20020a6b090b000000b0075ba6593512sm632190ioi.53.2023.04.12.11.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 11:10:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1681210788.git.asml.silence@gmail.com>
References: <cover.1681210788.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/8] for-next cleanups
Message-Id: <168132301110.359944.7130853128204770845.b4-ty@kernel.dk>
Date:   Wed, 12 Apr 2023 12:10:11 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 11 Apr 2023 12:06:00 +0100, Pavel Begunkov wrote:
> A random set of cleanups
> 
> Patches 1 and 2 address kernel test robot warnings.
> Patches 3 and 4 add some extra lockdep checks
> The rest are doing minor rsrc cleanups.
> 
> Pavel Begunkov (8):
>   io_uring: shut io_prep_async_work warning
>   io_uring/kbuf: remove extra ->buf_ring null check
>   io_uring: add irq lockdep checks
>   io_uring/rsrc: add lockdep checks
>   io_uring/rsrc: consolidate node caching
>   io_uring/rsrc: zero node's rsrc data on alloc
>   io_uring/rsrc: refactor io_rsrc_node_switch
>   io_uring/rsrc: extract SCM file put helper
> 
> [...]

Applied, thanks!

[1/8] io_uring: shut io_prep_async_work warning
      commit: 8b1df11f97333d6d8647f1c6c0554eb2d9774396
[2/8] io_uring/kbuf: remove extra ->buf_ring null check
      commit: ceac766a5581e4e671ec8e5236b8fdaed8e4c8c9
[3/8] io_uring: add irq lockdep checks
      commit: 8ce4269eeedc5b31f5817f610b42cba8be8fa9de
[4/8] io_uring/rsrc: add lockdep checks
      commit: 786788a8cfe03056e9c7b1c6e418c1db92a0ce80
[5/8] io_uring/rsrc: consolidate node caching
      commit: 528407b1e0ea51260fff2cc8b669c632a65d7a09
[6/8] io_uring/rsrc: zero node's rsrc data on alloc
      commit: 13c223962eac16f161cf9b6355209774c609af28
[7/8] io_uring/rsrc: refactor io_rsrc_node_switch
      commit: 2933ae6eaa05e8db6ad33a3ca12af18d2a25358c
[8/8] io_uring/rsrc: extract SCM file put helper
      commit: d581076b6a85c6f8308a4ba2bdcd82651f5183df

Best regards,
-- 
Jens Axboe



