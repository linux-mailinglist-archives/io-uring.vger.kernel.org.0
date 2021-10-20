Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC4143428A
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 02:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhJTAZb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 20:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhJTAZ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 20:25:29 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EFFC061746
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 17:23:16 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id h10so20287580ilq.3
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 17:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jWSXVEPr+jRfCAQKXBHMtq6TUrWr/FQEEdA1jjy0IUg=;
        b=vog0g3MDrkkFxl6qs/+tY7DyzJNuX9WUlxxmsLTtPfZD6218I/yNLLSidPuvksVFOi
         p2HhTngPe27YlTJaC265NKSuWhNiuAgCtFE7is8YoDbigkv65Qurj2nIZnrrzHlX9INR
         /U56fgUYW0sRGc87gRUZyqZR3q9dRit/2wTidATdLSKJpNHpGY6ujkgU/gUCdMbni6Cp
         ooFSKg8FlDsPc/yzdATcylYp7pbYFcOEZxHY6EQ8+Z21Vu0dgjlaWKmiEPlTd9+rzPIm
         5LWQ4HYmcX/lJ3uSougOjKmAhy/mvt2ufTkVSKa91+Fmb4xpej24wyJ46XzJGBkHzAq7
         AWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jWSXVEPr+jRfCAQKXBHMtq6TUrWr/FQEEdA1jjy0IUg=;
        b=rwxA0bJXnY2zzGXf4NF52NpqQSw5P2auTN/ychV4plhgLrUZtik/TWxfTRV8GmvExe
         QrvhkF4jJ4q0Qbn2TSqJgAjY2Cc9RKgNLQzoRc2ekMiBagYpH7bG6zj2tQrOvbGVRvHQ
         QO4KolQeRvfma5qnftVzO9RUzTfipJAM2TJS8+62/4k417PwB36Zz4ANo6eczx8u0nLI
         ZUMqGyYuFxYz5u8uOzN8uoBRWZkG3M0NLvJ5usCh7h8qBjeZ6vuZCqK9GpijlNFGP1cg
         kgB0BIKL4MbiulOaseIBdonPg/GKwesAO4WSxUqAofUl1N2eejChMmNbPymdMhwdzn8+
         Y6IA==
X-Gm-Message-State: AOAM532c6wshia/U6AilaEufW4ObxNHlfISwSUoP5Pr7ycmxS5b33/Dm
        X/P4zoiSmx6lpUExF3aUhXs1DfH4Mp8Uag==
X-Google-Smtp-Source: ABdhPJyrTA6rLct1+Bne0ORZF55qKwA/n8xkby5WqxwhQCTLnEmHq4FrvKEGDmbFI8JThbUDatoJIA==
X-Received: by 2002:a92:ca0c:: with SMTP id j12mr22286327ils.50.1634689395973;
        Tue, 19 Oct 2021 17:23:15 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m10sm314553ilh.73.2021.10.19.17.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 17:23:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v2] io_uring: split logic of force_nonblock
Date:   Tue, 19 Oct 2021 18:23:11 -0600
Message-Id: <163468938922.717790.14117389631747248538.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018133431.103298-1-haoxu@linux.alibaba.com>
References: <20211018133431.103298-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 18 Oct 2021 21:34:31 +0800, Hao Xu wrote:
> Currently force_nonblock stands for three meanings:
>  - nowait or not
>  - in an io-worker or not(hold uring_lock or not)
> 
> Let's split the logic to two flags, IO_URING_F_NONBLOCK and
> IO_URING_F_UNLOCKED for convenience of the next patch.
> 
> [...]

Applied, thanks!

[1/1] io_uring: split logic of force_nonblock
      commit: 3b44b3712c5b19b0af11c25cd978abdc3680d5e7

Best regards,
-- 
Jens Axboe


