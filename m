Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5195ADB8B
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 00:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiIEWvf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 18:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiIEWve (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 18:51:34 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6D0696F0
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 15:51:33 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso985569pjq.1
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 15:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=qU3jGavE03rEnvpk8EEW4BOFFNIw+qE6zh6QKGqfP1o=;
        b=HHorfd81MIAZHKA0tlH6MuHXwVQ1ZJamo5Vw8j5FQwjtxrFzhfLjriTLXgPWoz3Uqv
         wQdnAx7FWALmiSwzRpz8Xtb8yd4r/Zn6ETj5extic07V2HRlXgkM8jsHUXQWRYKNIPPM
         FKZgVSpZii9D9j3VBew5UVWybRjcSCx/DpN2FUFdW3OeO1n2oDcCQIA1H4Sab2LFjssr
         c5f7nHr1ToTQe2mmVvbKhxe7ZHQZD0GtLc1zPmminy1XixGSk/PFDvWI3QlYQ8TaUKYS
         BVfo4Wf9bYBDTzhgXNltWBL3J+oMx0yQSsrtDkJY4zdZNRhgC8vCfPcITgm6I3sdeSLR
         W4Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=qU3jGavE03rEnvpk8EEW4BOFFNIw+qE6zh6QKGqfP1o=;
        b=G/KK0/v8AxrhM5tYnmFf4tb9pb07MnVwLXfKhBEfJqcQ/kkLtzW0rWzQ++LUBd3veO
         TNMru+MK5N6qTcmP0tEKZXW6wsjJKg3nnoeGLImnGIKZEMGdLLytlUhSd9RsPiiOA2xm
         lzWuZwr4Fambd2UX/N93EQgtMlwNNolLpmM3Bhk2kQa5WX67cbv+1NldSutLCeZxIXYa
         KyQ+uAJZn+2Lz+VW69jtZ6fClJ5iGXWujxhO1w82fJjgGYHZlJa6C+xaaOv9OtA+Jpd6
         S82suEpXLfEEa0M6jpeYuNjqshaFnw7/C67/hQJkcxKM9ieTS5AUw1fK5eIZ4OdzNr0k
         bBiw==
X-Gm-Message-State: ACgBeo2540ilTriQ6cgEEOLq2eaKcQaqRmXr5UNPnviQ+901FsTiuaEV
        Ek6QOkJ8KCQmmT9jQc5lnvrsMh5LK51wjw==
X-Google-Smtp-Source: AA6agR5xeRg1Wq0hJlZBho7Aok5Pcs5NZxosDsFdRkmZvqE5HJxPMn4zWt8qpcEfIcZ5tRr0L+fRmA==
X-Received: by 2002:a17:902:f683:b0:176:cc02:ce83 with SMTP id l3-20020a170902f68300b00176cc02ce83mr1280096plg.88.1662418292985;
        Mon, 05 Sep 2022 15:51:32 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y13-20020a655a0d000000b00434a8e676b0sm67871pgs.45.2022.09.05.15.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 15:51:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <cover.1662404421.git.asml.silence@gmail.com>
References: <cover.1662404421.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 0/5] zc tests improvements
Message-Id: <166241829140.462526.10540188211710260669.b4-ty@kernel.dk>
Date:   Mon, 05 Sep 2022 16:51:31 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 5 Sep 2022 23:05:57 +0100, Pavel Begunkov wrote:
> Return accidentially disabled UDP testing, reduce runtime, and clean it up
> in preparation for zc sendmsg.
> 
> v2: kill __BUF_T_MAX
>     add patch 5/5
> 
> Pavel Begunkov (5):
>   tests/zc: move send size calc into do_test_inet_send
>   tests/zc: use io_uring for rx
>   tests/zc: fix udp testing
>   tests/zc: name buffer flavours
>   tests/zc: skip tcp w/ addr
> 
> [...]

Applied, thanks!

[1/5] tests/zc: move send size calc into do_test_inet_send
      commit: 7f80be601474ed3702ecf9a39da14534df897560
[2/5] tests/zc: use io_uring for rx
      commit: ec19550c0fec57bef77c49a1326e4e6837b039ae
[3/5] tests/zc: fix udp testing
      commit: 3674cb90514a316ce83fe17c3ac5bfff3da453d3
[4/5] tests/zc: name buffer flavours
      commit: 74970081956c2d9a937c3a98fac60173d479f394
[5/5] tests/zc: skip tcp w/ addr
      commit: c7ad43212d4aa576171ae7465f31b047e880da9e

Best regards,
-- 
Jens Axboe


