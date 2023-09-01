Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92DE878FFC2
	for <lists+io-uring@lfdr.de>; Fri,  1 Sep 2023 17:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350152AbjIAPNi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Sep 2023 11:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350138AbjIAPNg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Sep 2023 11:13:36 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7FE10E5
        for <io-uring@vger.kernel.org>; Fri,  1 Sep 2023 08:13:33 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-34ca6863743so1806375ab.1
        for <io-uring@vger.kernel.org>; Fri, 01 Sep 2023 08:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1693581213; x=1694186013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=edIR+17IRvQEwvaIneCldAoQziG2QEd+kuiT3QxzLp8=;
        b=fUqxqROy+5EJ/mMW95HeCr/kNkK50OcY6sVGcvE53eRVqAF2ReE1qZwMO/ULPZQOVg
         TeyrcFYrl3pK81VgklF5G1dVPALhJ+sP9BVgndfr2TUiNKb+RKWHLApyzOpEKEK4v0TI
         NsQgJRfZjp1V6tVnyWtkqbPlnt9No8gCaWEFwxuag1/P4WM6kFgu3K2D25ToAhzxFDW7
         bVU/LrAiWOGbAL8c1qRAGToYdr5n3h0Kr8wxD7t5bJsA7kDBuIl2/zjTUT9oXPVmY14w
         pT4Qz1H7QGhTdESQrv/4E4C3zuRTVa6Wdm5lyjlNgslBAtSx/Z1vVHrrI35GcPiSwIsP
         qjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693581213; x=1694186013;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=edIR+17IRvQEwvaIneCldAoQziG2QEd+kuiT3QxzLp8=;
        b=PD+7DP9k+Hp7NdAUNVLBfwy6C68Lt9Uh00uQubvOwg8LlSTW5lzGnJL4YI8gRMM40o
         xqWvPXqM/NPfeMHBWzegU7TfNgpebtbDq5Py7tYq/sNMzB7qqgA6S/hIn44HrGyY7jxI
         /RYRIzcne56IJyPRweaB1JpwUgX2RhD5GAlZG/JPANsOfFGjN1t91FABdgnuFhJ76UYM
         d2FQN4MUIP4Lsi6zpQCR+EGvWupXTLznpaieez+pFCZdq8gP77sRnYF6L5CEhTdiiHJa
         9jp4mppI+6yL6GsXE0S95d0GHvKR4N2lZQza3ZuGxGsTqkkD1ttm7A4QykuS3b5vC5zo
         Gq8Q==
X-Gm-Message-State: AOJu0Yykta2+OYXXj5kzDXZgn0dMq+MOvztS7yxxH//Etw7F5Sr510Bp
        pyhkTDJEXo91xCDauF5LApg+qY3PviLqVmGv6v71gg==
X-Google-Smtp-Source: AGHT+IGqlIx9GJ9FZunCEA6Fzch8LLHhTfhQHpYi/vWX0iHn1PyagtxMV9eMvflVEncOwxrnQt+syg==
X-Received: by 2002:a6b:3f82:0:b0:792:5f79:ef9b with SMTP id m124-20020a6b3f82000000b007925f79ef9bmr2525872ioa.1.1693581212733;
        Fri, 01 Sep 2023 08:13:32 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h13-20020a6b7a0d000000b00777b94e8efasm1096099iom.18.2023.09.01.08.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 08:13:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <20230901134916.2415386-1-ming.lei@redhat.com>
References: <20230901134916.2415386-1-ming.lei@redhat.com>
Subject: Re: [PATCH V2] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Message-Id: <169358121201.335729.4270950770834703042.b4-ty@kernel.dk>
Date:   Fri, 01 Sep 2023 09:13:32 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 01 Sep 2023 21:49:16 +0800, Ming Lei wrote:
> io_wq_put_and_exit() is called from do_exit(), but all FIXED_FILE requests
> in io_wq aren't canceled in io_uring_cancel_generic() called from do_exit().
> Meantime io_wq IO code path may share resource with normal iopoll code
> path.
> 
> So if any HIPRI request is submittd via io_wq, this request may not get resouce
> for moving on, given iopoll isn't possible in io_wq_put_and_exit().
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix IO hang in io_wq_put_and_exit from do_exit()
      commit: b484a40dc1f16edb58e5430105a021e1916e6f27

Best regards,
-- 
Jens Axboe



