Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C1060557F
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 04:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiJTC0n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 22:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiJTC0g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 22:26:36 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B5D1974E2
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 19:26:25 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id f140so18991417pfa.1
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 19:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J7j5s/3y3L0TcS/Xu+YsR880d4O9w0DGxhU3uPuTkds=;
        b=wvIK3tvMFI86qjUETxieBz/roit2/LYjgenT8NNVdNH1PVGrwNru3lG9RTH+/DXefv
         gXrI3vbagDo99RNk8vKv/rNHgJH2g5n0cKah07n5D7SMkJJ+6VKTL+kCPLjRtc79yhKz
         tVnIyHs3iVXqS5H5BP/1V2dEWnRPdqDeYUA6pRSnmhFSkkKq5C+GLylPFWq+mwQEafSH
         tGG53CVNZKX0oPiuwgPSO4bKCKlLatjX6CF2+WUrzLb7XVOjWzQqOWZosV14dUGxySrt
         cNS1m0YBb3nDRRdT03tspU4BtTNvbEXmpOBF22cJXPuK5dEkm1gqu5wb8r4a3p9f+tBl
         chDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J7j5s/3y3L0TcS/Xu+YsR880d4O9w0DGxhU3uPuTkds=;
        b=30uth01oLs6+OtlgR/jeeqeT128ZMYsw7SDCrkQsFSaHvm7YnZtFEhp0djbTNV/csP
         PPK6S/Jr7znU4a3Z7DHo5y0T/6qpHxG16ZQfWBAExPbK08r2bnJ0d0+AbotDp2ZM6Dse
         A3L82CfvYb9ECqQp7VPI+eiG2dLiZ/Kps916YDirO5olasdUhoE09GjzU4CC+rR+FyXy
         ymcsHidmui9/qQSAKGt5XF/ddmfc0nEYTAjBuLeC5Sus1M0Wv/id7Lm4qViNyU4x3nWU
         2SGEPIlF1SO/ugo3vwsYMsvaNhj0A5Q3Pzy+ngKISqdrLZk2EtD65MNf9z9dBtZI0xBB
         doYw==
X-Gm-Message-State: ACrzQf3fnx5EYKqtBa9Paghi/suLTUBOEfWtm7YHszw52w6zscAQR46l
        fWJeCQ8fpSwMEAuDYscdq8pgCZDJ4lucQEV5
X-Google-Smtp-Source: AMsMyM7DpNl/x9+vlmjztWS6OhafbncNuSFe2VGx0PY+m2NxTCotWDdLNlNZJU5TrSMCfcIb4yoy/A==
X-Received: by 2002:a65:6c11:0:b0:46a:eec8:19f7 with SMTP id y17-20020a656c11000000b0046aeec819f7mr9998712pgu.478.1666232784744;
        Wed, 19 Oct 2022 19:26:24 -0700 (PDT)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id s5-20020a625e05000000b005631f2b9ba2sm12314259pfb.14.2022.10.19.19.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 19:26:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1666230529.git.asml.silence@gmail.com>
References: <cover.1666230529.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing for-next 0/5] expand send / zc tests
Message-Id: <166623278402.153320.17837453222365546552.b4-ty@kernel.dk>
Date:   Wed, 19 Oct 2022 19:26:24 -0700
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

On Thu, 20 Oct 2022 02:49:50 +0100, Pavel Begunkov wrote:
> Patch 4 adds sendmsg testing with various iov lengths and configurations.
> Patch 5 tests IORING_RECVSEND_POLL_FIRST. And patch 3 enables same testing
> for non-zerocopy sends as we currently have poor coverage.
> 
> Pavel Begunkov (5):
>   tests: improve zc cflags handling
>   tests: pass params in a struct
>   tests: add non-zc tests in send-zerocopy.c
>   tests: add tests for retries with long iovec
>   tests: test poll_first
> 
> [...]

Applied, thanks!

[1/5] tests: improve zc cflags handling
      (no commit info)
[2/5] tests: pass params in a struct
      (no commit info)
[3/5] tests: add non-zc tests in send-zerocopy.c
      (no commit info)
[4/5] tests: add tests for retries with long iovec
      (no commit info)
[5/5] tests: test poll_first
      (no commit info)

Best regards,
-- 
Jens Axboe


