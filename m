Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D5761FF6D
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 21:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbiKGUSU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 15:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbiKGUSS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 15:18:18 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB072AE3A
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 12:18:18 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id o13so6445362ilc.7
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 12:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vs4GR4z1l65Gj+Aq2DqAdLQVNOKeEP7B5zAivnEcI8w=;
        b=zQ2GSKH+tH7Qvf0g9dMxUV7C3pKeqLWkDc0mHpuvE20zXE/DRFtpgNs10CLmaZED73
         eRXvmslw6W55Me6Fpmg0V+t26AWR0TRaLUax6ZkegRYAhkujfv0r6aCOUqE8cjjd2KR7
         2lqT7hs/MIuxjlbO7LAMvBxmlMFn52MSZy7oNBET4FnxKtW00bhq9KcRvQWBG+XDRsrd
         Ek9vukmtcftwbX96hEkGoSJSj/ZVrfC0AI8cG1iCKzJOx4wq8bIoz47MzueBgAE72N31
         w8deOybXCvvEvon2a3gSnSS143nm2r89PKrQjLwNpJ74sOdbOYwGq6NlbJ8QOcq5GUh2
         PASg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vs4GR4z1l65Gj+Aq2DqAdLQVNOKeEP7B5zAivnEcI8w=;
        b=hjndFdcJ6B9ygLKdMwRxzi+6y8H/5MK5i6iN4OCjOmX4k2j0Z/PBsKGQgzkikGpG+S
         JK7GZ6H9CuaQz2nz/hk1ApLsq1K5akoMiKJ04My5WMnQaE7i9GfJ1B4vq2fJ5T4rqxCs
         tlu4BgP9FjyBC5Vd4K/DoABW4Fheq+EWEPh64Boo0mgZT2Ym8Uj9+TMfZMkU6YpIRtFT
         EofJBOWQmZ++jmMAM8lhPjjxGjKgwxefnI6Zen+GKlErnsRVdPKfhgdohrHfJPBC3wQM
         XqvZprV3VYd6glA0sNE0KnQL2OulgmFca96oeEOpUZIIwo4onerFeDrZpct/VnFM7kD3
         bg9w==
X-Gm-Message-State: ACrzQf0sBPCOj3D/bixDpM7f40wHWiWa6+asRTtBXtVy7jmvVR+miw4y
        bbhEo1xhpE1Jba0B3zyxb41QTYGX6ZOVpHDE
X-Google-Smtp-Source: AMsMyM4avcMOi6JKjM+5QJwh7kwjBgJtbiSDVL1ScuOdhWql73NfF8jFevcZg+HZxYKqMtqzL7yLng==
X-Received: by 2002:a92:d104:0:b0:300:a7ab:81cb with SMTP id a4-20020a92d104000000b00300a7ab81cbmr25586705ilb.265.1667852297491;
        Mon, 07 Nov 2022 12:18:17 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q2-20020a02a982000000b00363e61908bfsm3090772jam.10.2022.11.07.12.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 12:18:16 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org
In-Reply-To: <20221107125236.260132-1-dylany@meta.com>
References: <20221107125236.260132-1-dylany@meta.com>
Subject: Re: [PATCH for-next 0/4] io_uring: cleanup allow_overflow on post_cqe
Message-Id: <166785229641.23646.13284341516331360750.b4-ty@kernel.dk>
Date:   Mon, 07 Nov 2022 13:18:16 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 7 Nov 2022 04:52:32 -0800, Dylan Yudaken wrote:
> Previously, CQE ordering could be broken in multishot if there was an
> overflow, and so the multishot was stopped in overflow. However since
> Pavel's change in commit aa1df3a360a0 ("io_uring: fix CQE reordering"),
> there is no risk of out of order completions being received by userspace.
> 
> So we can now clean up this code.
> 
> [...]

Applied, thanks!

[1/4] io_uring: revert "io_uring fix multishot accept ordering"
      commit: 01661287389d6ab44150c4c05ff3910a12681790
[2/4] io_uring: revert "io_uring: fix multishot poll on overflow"
      commit: 7bf3f5a6acfb5c2daaf7657b28c73eee7ed5db8b
[3/4] io_uring: allow multishot recv CQEs to overflow
      commit: beecb96e259f0d8e59f8bbebc6b007084f87d66d
[4/4] io_uring: remove allow_overflow parameter
      commit: 6488182c989ac73a18dd83539d57a5afd52815ef

Best regards,
-- 
Jens Axboe


