Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE45342140
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 16:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhCSPwL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 11:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbhCSPwE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 11:52:04 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FCDC06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 08:52:04 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j7so9610764wrd.1
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 08:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=DmeuvXUI5SwyPsVHyaBLKt6xd0PJg6XWq41TdTiiNOo=;
        b=KQ794fpeumPekJMwn3FmnUwWpHn7yIrLN0naYB8nfb4Yj/ADr6bVTMUf45H3SVCetL
         GIT31Lh10DYqjcPczBHwly7xA4Ana2pHnwCWjs0qCz78ZsuYh6RIBGNE8TKvlJgyQ63d
         iMUjFKxUSxUgvJRSnsZ7cKup3tp8DrHhavAy9TeSPCTF8gG8xqbtirPsfHYKcZLCcm/4
         BSdMiBVKg9CZqP+yaBorHhhb00tjO1IBXXwqoCogDy/7ORj/kkW3PT/Ehj9oXh2U9Ofc
         EPW0P1L5LJJbnvSuHuoEdQXPtsyjxu19pnEDRNqr0izkzL21sZC46zQzVl+BE/mKruvb
         UrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:autocrypt:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=DmeuvXUI5SwyPsVHyaBLKt6xd0PJg6XWq41TdTiiNOo=;
        b=nYpXM4p8d964N3lN62jnuf0HqUWuVsFcRmWXD3Zai9ynbHv+QbNyVa7a+q35xSrCNn
         C4j+NsZ8RztC3kS4Cb+1r6INYbKjY4Nw191/jOKXW2sIJow6/wOCoA90u9VlqjZpgh9C
         19zbFxi5knEF45deQBCdCtjdaY2RtTvApR9nzsROfTWo0OSHD1Nkh4tRUlIx5IouCaYl
         EyebbXqdQsc2YTT0FNMRxu3sJsSv2PHo6y1iGJVPq/hhHxyU484jlHNSzggJiLRVna9r
         XbT5os2znQ64mj1EybWn49K0ZFYR1bZptd2irjEn/8ysJ80rK3ck/i5VvnrfxjZPQ1E7
         LZww==
X-Gm-Message-State: AOAM531qc694U52y0vBxPsZWgCjKKTFdInaHhSoXxDdJ331gbsDEbvQg
        RYuKTAqTaKyBLZFGDulJHkg=
X-Google-Smtp-Source: ABdhPJz36y9WNBae0Ps/GJIGpmVoKZPCw7pQTnjrN3yCZeT1+U+5l0rZnPvQ5djsSC5vZvyzt1TNtQ==
X-Received: by 2002:adf:f587:: with SMTP id f7mr5229833wro.147.1616169123417;
        Fri, 19 Mar 2021 08:52:03 -0700 (PDT)
Received: from [192.168.8.176] ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id k4sm11119380wrd.9.2021.03.19.08.52.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 08:52:03 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: [ANNOUNCEMENT] io_uring SQPOLL sharing changes
Message-ID: <ca41ede6-7040-5eac-f4f0-9467427b1589@gmail.com>
Date:   Fri, 19 Mar 2021 15:48:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hey,

You may have already noticed, but there will be a change how SQPOLL
is shared in 5.12. In particular, SQPOLL may be shared only by processes
belonging to the same thread group. If this condition is not fulfilled,
then it silently creates a new SQPOLL task.

Just FYI, but may also yield some discussion on the topic.

-- 
Pavel Begunkov
