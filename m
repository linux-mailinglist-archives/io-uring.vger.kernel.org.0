Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086F86050B7
	for <lists+io-uring@lfdr.de>; Wed, 19 Oct 2022 21:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiJSTtY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 15:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiJSTtW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 15:49:22 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC166315
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 12:49:21 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id p14so18247520pfq.5
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 12:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JXIMZyeHIiCmjMKrbWzQzcTbZ+nhaZipBFXLjdQJfi8=;
        b=SJvRJj4SIYYNskpr0nXY+QmbqmvzewIWEU3PXol4PWtUvWaxt8/vKVotDGGlzvcAnT
         Ddx64tHHNmkTYNYfgRMIw9ujx6+nIphsqgZnKYk417roB/0slMH1UQydreYCLtoqBjmh
         pbwhl5+qBl7K1KkdE1IdDOREXeBc+LQiCsZ9QxpJIfiyVKEwkJU56C4OgsZxR8Oav2h3
         0DWHZ64uWxAktzgywQDw2okNCfS6khkneEjFHhqwTS+uPX/iG6Q86dlRJ2xuE7jSoISl
         RNJp0n3eiwmS7J4k7HCQeaTWTPabpJBtazBr6HhaJeWVuPhMIWByT19m6MQCcrnbV/Rx
         Lp3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JXIMZyeHIiCmjMKrbWzQzcTbZ+nhaZipBFXLjdQJfi8=;
        b=w7TVWwc8MhlrjQlCl/PVHuXP2hNU0G4Lb3ProzBDc4TRxlMMCoKdlvNii1sJG6seYj
         fmQvobpbTuhX93xC9DHdeMlKL+NubGC8HKoWlR/rvhjep4wVAc5+U7XRECToMNkBqSd0
         0t3Oa9IOsX4Us+gx64ibvFQxon6jmx8KsQ9rgywZ1+X5UHKS4nnHZknl6/2opiWgveoX
         P2epc+RzuwkTvvn0AolZqj7CaQNrtQMpBW3TJIkptYZpkJ4Ck/s1EgPWGGMCQd9KES6T
         Q7H4M5QjnI+XuYB1FxlWKaF4/5Nk50ExSdfrMQajiY3Vw+JwieqEpufH5HUtdiDlBzIo
         7+zw==
X-Gm-Message-State: ACrzQf111vnqRDlsqLRAVnKM8xeyu4A9daUni+5na+pMU6W0RyssYirz
        bwX1FbktCrh34giSjojTIj8jLA==
X-Google-Smtp-Source: AMsMyM4jJuYEK5loTCVz2Mg57OSG5BQADotG0zeIMY8PR10zHO2hvuKgA/yruOmZkhLOL0hruMvbkw==
X-Received: by 2002:a05:6a00:24c2:b0:52e:7181:a8a0 with SMTP id d2-20020a056a0024c200b0052e7181a8a0mr10311040pfv.57.1666208960507;
        Wed, 19 Oct 2022 12:49:20 -0700 (PDT)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 72-20020a62194b000000b00562362dbbc1sm11531811pfz.157.2022.10.19.12.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 12:49:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org
In-Reply-To: <20221019145042.446477-1-dylany@meta.com>
References: <20221019145042.446477-1-dylany@meta.com>
Subject: Re: [PATCH liburing 0/2] liburing: fix shortening api issues
Message-Id: <166620895960.131373.1254090404604128877.b4-ty@kernel.dk>
Date:   Wed, 19 Oct 2022 12:49:19 -0700
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

On Wed, 19 Oct 2022 07:50:40 -0700, Dylan Yudaken wrote:
> The liburing public API has a couple of int shortening issues found by
> compiling with cc="clang -Wshorten-64-to-32 -Werror"
> 
> There are a few more in the main library, and a *lot* in the tests, which
> would be nice to fix up at some point. The public API changes are
> particularly useful for build systems that include these files and run
> with these errors enabled.
> 
> [...]

Applied, thanks!

[1/2] fix int shortening bug in io_uring_recvmsg_validate
      commit: d916aa80993438dbcec700202b21b550edc03941
[2/2] fix len type of fgettxattr etc
      commit: 5698e179a1308aa8019a482ca910a832b5737e5f

Best regards,
-- 
Jens Axboe


