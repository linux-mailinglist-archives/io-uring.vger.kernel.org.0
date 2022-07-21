Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E029757CEDC
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 17:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiGUP0O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 11:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiGUP0N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 11:26:13 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841785B787
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:26:12 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id x64so1612548iof.1
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Vh1wEDhtkpDgbhyqzQiTGPIjTTdvof6/9FTATTCbCns=;
        b=yb2enElY/SwlOrJzekJXe+6bCqdyANM3JC+hhQjZ5aFZpalRRtYElO20jdAzFFp/Wh
         GVsFvEeVVvqN5ZB0pl7iEOCcSup2wPugeucHAQhsrK19nJEpE9RYt0p1CM0DgiVjplkV
         DUt+VxX6ALFGA55IPxwqOoPcUyeZ1A93sku1y6NIITBEHng76T4ufYATNzncU6W7Pknk
         CrRNMiJHug3svEogO+YvI20KiZMXD6wN0KxeeeQxOOo2CQkfJhMKKpn/dIBzFMHClg39
         sR40+Elg89iPbEti74N3wnKu+WZxNY/hModsem4NCZtgGuON4H+fJ2yRU0MKKFw0JTpG
         NEJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Vh1wEDhtkpDgbhyqzQiTGPIjTTdvof6/9FTATTCbCns=;
        b=V581FdmMiQAosGYhyQ4lxg1u5RYlqeXng/Huvn2BatLBAoTMRcDKiyPgaatcxDyc9H
         /x4c0f5s1dM2+dvZtYnX/Yf89Qrk5tl6ChmJFJr/OVOVlXUgME2pJco5nDXEbauudc7c
         142UVdhb+dz7XsAnTBPAnd4MSTT0UyL08abhMpCYyL4rH3BW5KiH+j5X0LeMsfZBlS92
         6ucRlrOekdY8Wjh9xCm6h0EgnvtgVHo+81rVgAHkDHOQ/Qx3z2s6LUqTiMV82o1wzI7n
         HNCqbvSmVok0b0cSVFh99LNdlNmhtSnDs00acN5Ejd1y0fAQ2bdHmlbiwlKy0woAuB+/
         8UnA==
X-Gm-Message-State: AJIora93FFXc1F1VmWF3S4u5czLMf5E1RAbsjqAnSn1AN9pJF/mR43L4
        lI2KfCHcrq/JWtiWa9RREuV0CQ==
X-Google-Smtp-Source: AGRyM1sYC4Ws4fx+WY+6xz3bW5P6QQdaMEs6hThpi82I96pl4YXrX0+lRI2D/+rg1PDRnp+F4icTLw==
X-Received: by 2002:a05:6638:37a3:b0:341:8cb0:2d0e with SMTP id w35-20020a05663837a300b003418cb02d0emr5846161jal.118.1658417171889;
        Thu, 21 Jul 2022 08:26:11 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s8-20020a0566022bc800b0067be120e900sm959329iov.55.2022.07.21.08.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 08:26:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     dylany@fb.com, asml.silence@gmail.com
Cc:     Kernel-team@fb.com, io-uring@vger.kernel.org
In-Reply-To: <20220721144229.1224141-1-dylany@fb.com>
References: <20220721144229.1224141-1-dylany@fb.com>
Subject: Re: [PATCH liburing 0/4] tests updates
Message-Id: <165841717119.93195.3597930860867630922.b4-ty@kernel.dk>
Date:   Thu, 21 Jul 2022 09:26:11 -0600
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

On Thu, 21 Jul 2022 07:42:25 -0700, Dylan Yudaken wrote:
> This series adds a patch for a panic in 5.19-rc7 simplified from the
> syzkaller reproducer
> It also causes the poll-mshot-overflow test to be skipped in versions < 5.20
> 
> Patch
>   1: is the panic regression test
> 2-4: skips the poll-mshot-overflow test on old kernels
> 
> [...]

Applied, thanks!

[1/4] add a test for bad buf_ring register
      commit: ded2677991f3af247206f67f466111b3060006b7
[2/4] Copy IORING_SETUP_SINGLE_ISSUER into io_uring.h
      commit: 205f2e87471ef543b867fdea2140309507a2e1f7
[3/4] test: poll-mshot-overflow use proper return codes
      commit: 7591d1af4b5a16f4371c0bd907ef71575a837315
[4/4] skip poll-mshot-overflow on old kernels
      commit: 4538e990a8c909bd0e7d3e5ecc0016a4e5f26b0c

Best regards,
-- 
Jens Axboe


