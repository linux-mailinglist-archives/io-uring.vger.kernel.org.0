Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CBD74B603
	for <lists+io-uring@lfdr.de>; Fri,  7 Jul 2023 19:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbjGGRx7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Jul 2023 13:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjGGRx6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Jul 2023 13:53:58 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94131709
        for <io-uring@vger.kernel.org>; Fri,  7 Jul 2023 10:53:56 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-760dff4b701so33270139f.0
        for <io-uring@vger.kernel.org>; Fri, 07 Jul 2023 10:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1688752436; x=1691344436;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SslnkP80X51uSIcroqhn4NwluHxYbq7es0S39E9aqHU=;
        b=bHrhMZ/xB4SQzlpnZvtgT17dBX0gt63OtmfrAhjeGSfFfXqFnUUnsLWTyo38zsHvwx
         eW1gnVsgBQaGJl+pXfLYIn4CaPguC68ET5ihHXFn8iAt/uoOztvNETF4hf0rcs5lwoiu
         OJfR+VsJgoxUs42nU0HIUtt+Dd5cTHGBDPF8tvU+o7Az+eSW1bw+garJQt6Qcvm0/aB6
         1t8ommkcffJbz6e3y4eTLLsouoI8Kd605t7iOU6hKRHOGZf5gclh64nTrfX31MdxTvOA
         yj+FrDtCxNwv+lOlg4vG9chE4rnpcSJP2I3qqfbUZSFWIV1Pp+//fb8qUSIlo7BS1XRP
         MBeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688752436; x=1691344436;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SslnkP80X51uSIcroqhn4NwluHxYbq7es0S39E9aqHU=;
        b=fE0h37uIGRIdYW8cyRsC6EB+ul3fUdQ0qfF7zlVthXlXylMunzREmnOjYqMGlLloxR
         wJTqLhoZrMEEgU0SRsf9PBwfpFuDHJ04eiD99cFHRj/KSVnAZnHF7f5De9gheWOtct29
         di4PyAcaCo/hdbWm/uolNKl89tkjTYiFV0fy3oDczY02EuPiqQAiQwkUfcy7jXsXmd+9
         IZCJM6gNBfKXEnGIn+uWT7wqT2SJfjIry7S2nhbznrXXWysj/SHmFl2+C755ti1qmc+T
         nXrStTcPUBDzeEZhQaJDjr28+fELENZs5Q6TahwePl+nbx9ChxAJXGu3wl2VnIUSzzdS
         S37A==
X-Gm-Message-State: ABy/qLb4OmA67H1PDngA8D7eg/tyfEwcU/u4ovJ9YIV824RnhtGc6h6P
        IO99IEpQwe/vDSiSuGrFZr6z6aMYGkSorjcnviA=
X-Google-Smtp-Source: APBJJlFnOdOYUadwtC3XIOBPxBNcAjlXXau2HXXmsfLddxVCYrYNkRy9A6JdF41dH75gTI9iowwPBw==
X-Received: by 2002:a05:6e02:e04:b0:345:e438:7381 with SMTP id a4-20020a056e020e0400b00345e4387381mr6005599ilk.2.1688752436306;
        Fri, 07 Jul 2023 10:53:56 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cu3-20020a05663848c300b0042b72208aa6sm1353173jab.77.2023.07.07.10.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jul 2023 10:53:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Freund <andres@anarazel.de>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230707162007.194068-1-andres@anarazel.de>
References: <20230707162007.194068-1-andres@anarazel.de>
Subject: Re: [PATCH v1] io_uring: Use io_schedule* in cqring wait
Message-Id: <168875243541.1538686.6247556523906342367.b4-ty@kernel.dk>
Date:   Fri, 07 Jul 2023 11:53:55 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-099c9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 07 Jul 2023 09:20:07 -0700, Andres Freund wrote:
> I observed poor performance of io_uring compared to synchronous IO. That
> turns out to be caused by deeper CPU idle states entered with io_uring,
> due to io_uring using plain schedule(), whereas synchronous IO uses
> io_schedule().
> 
> The losses due to this are substantial. On my cascade lake workstation,
> t/io_uring from the fio repository e.g. yields regressions between 20%
> and 40% with the following command:
> ./t/io_uring -r 5 -X0 -d 1 -s 1 -c 1 -p 0 -S$use_sync -R 0 /mnt/t2/fio/write.0.0
> 
> [...]

Applied, thanks!

[1/1] io_uring: Use io_schedule* in cqring wait
      (no commit info)

Best regards,
-- 
Jens Axboe



