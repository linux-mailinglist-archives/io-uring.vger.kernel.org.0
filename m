Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B470C6367AB
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 18:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238645AbiKWRvp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 12:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239231AbiKWRvi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 12:51:38 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9D3C4C3F
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 09:51:37 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id b21so17294963plc.9
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 09:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hy8s+DCRcXtDwa/+H44sqhcqDdCKS202MVYuq+TnU7c=;
        b=gwLLZr0hN0SxbWDOIpxGamsg/Wx7zkp7rWQEgNM7JKBskSXHZw14363FDJ0qKrRp0s
         8gkFrktVWOuBDODEnnsFGScW0+JLmUkqOGuUtSe8Ud7+ci46WOOHpy4P/dhbUliUoA+u
         6Duk6xLsVd7073tZsC+loLjn0Q2xXWz8BbUAMn7DRu3Ieto0N/YAJljL2kYZuo0onbgV
         DkcqkxodbhDEfStDoGwQ855v46UWfnAzivYcrc42tk7QCusAnZmCe+ULuoG/EMTII+rz
         97ns5TbCDl7VO2+WJ/KTSwEa12AvnA8ESTw+g1Vz78aGJbi4RB0gam0ntzCwaKwXV6el
         6WGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hy8s+DCRcXtDwa/+H44sqhcqDdCKS202MVYuq+TnU7c=;
        b=QYwfTxS5uv5WjlW+Ic15iEamgU/tNoim8RHKiShcZokJ1HFyde2XwAmomNKGtfKe/C
         bhh65PH2Nv+aYHtEV4NWcIcn33fybWXcarQn776KNswxFidCpQcgVmD48ClwxvsHQZVR
         PRFRkaEvgKNZYx3XrSOk8svlfpu8rVUCe5X9tVzl88xeyIigIW6Q1b4ND0R66+eSWTF9
         KNl6+H6Ajzd+FAS2OIyNdPUmzdzDKWs8bkBGAaAHP6C1IbyaXMkWbY91w2DwUxvc4sHD
         p/6RNo0i+QG8/WB+gdRtklKpIZb6vIJoxMWRbEPhTZCK0iscLcXY7hSZR3/Yxwd84j1c
         j/iA==
X-Gm-Message-State: ANoB5plvM1C698wh8CIfkMqN0XTYI+3Bhqkmh5ZUn4iO15LIq6odVrlZ
        lIsY8jpVSgiH0kB7S94I0iF9NA==
X-Google-Smtp-Source: AA0mqf7zWbuB2/MXogXtc0SdYaEQPsFIGGy/MUx2FEnmR5Ezzruagxm4zPItCVZBiwE2DrLRoLxF3A==
X-Received: by 2002:a17:90a:d190:b0:20d:747a:c507 with SMTP id fu16-20020a17090ad19000b0020d747ac507mr31912340pjb.145.1669225896869;
        Wed, 23 Nov 2022 09:51:36 -0800 (PST)
Received: from [127.0.0.1] ([2600:380:4a4b:9d2c:aa9c:d2b:66c9:e23f])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b00172e19c5f8bsm14744438pla.168.2022.11.23.09.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 09:51:36 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <cover.1669079092.git.asml.silence@gmail.com>
References: <cover.1669079092.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/3] test poll missing events
Message-Id: <166922589554.11624.10192538518579626520.b4-ty@kernel.dk>
Date:   Wed, 23 Nov 2022 10:51:35 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-28747
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 23 Nov 2022 11:35:07 +0000, Pavel Begunkov wrote:
> Pavel Begunkov (3):
>   tests: remove sigalarm from poll.c
>   tests: refactor poll.c
>   tests: check for missing multipoll events
> 
> test/poll.c | 146 ++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 120 insertions(+), 26 deletions(-)
> 
> [...]

Applied, thanks!

[1/3] tests: remove sigalarm from poll.c
      commit: b532e9cb82a320186d6f9860ee2fdf2af0012dec
[2/3] tests: refactor poll.c
      commit: 81107fed5e17217caf7c6c51e6b468269de6403f
[3/3] tests: check for missing multipoll events
      commit: b90a28636e5b5efe6dc1383acc90aec61814d9ba

Best regards,
-- 
Jens Axboe


