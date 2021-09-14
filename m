Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A9840B5D1
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 19:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhINRW6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 13:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhINRW5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 13:22:57 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97ACAC061764
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 10:21:39 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id a15so18133211iot.2
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 10:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HJeSsYgQRVDOXArrHFehpnuVseRW7IDoqgU8Iq6wjuY=;
        b=zjZ5W5/AmarCVboMmPdZkSvi785lk4FXK8wUe+OEL+SFdyM18MM1PSpnW/jHz8maJj
         MV1SUsSxMlv9Ljgaj0BVNJUljIw0/E9b+OGUZm08OBY7/2litP+YQVjp1T8jbRk2K9HE
         osv8gzgyyyRQGmz4vz17CzHNbDT++mxXIQ7eOUQsGHbO3OcQTPdJAcPYLWfaG0rotgIJ
         Kxx+MbsRo86RlueaXx0QLoxTxio4PlBfkUUVmD15DnVAMA2SrBNeEW1BJpVMy5Uu7k+H
         Vma8+SieaLe0/X2Oi9UZynuJyRjTtW9E0oF+P1dh27hQw+0RjeNq1AWJE3xtrpZs15c9
         8wlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HJeSsYgQRVDOXArrHFehpnuVseRW7IDoqgU8Iq6wjuY=;
        b=BR2Io/zMLB5LQzxzAbNb8gZUNcO3YxA1l3nj3XNWBPeRW/xeompFuGkLz8+u+zjCYS
         o+CpFPnDb0mZFPwkqDEoqOk0nRLbAKxI6w/ktsuaJEME04FVjw5+frDa4fjNdP8IPamv
         /DrNBodz46kYMDukAmY1nlZA5Xcjj2yoAyj80UCBotTL9CTx3eRQYVFXmcx7P2cKqjyc
         WvlGVTTVSPL2RVfJh2D1wqO3JNdtMEsMMa2Au2VtwWHRDYpVUp24a/opQV2D4kUNFTcY
         qGk1Wp4m9R77qEpJMZRHp3twSLn+l314jh6dl3GPeJAa9olso0sHWhWSHpUynOxxKPM8
         1o9A==
X-Gm-Message-State: AOAM531XE4geK8tAlBoEgYvaRNWwFi6IESSUV7qSNOJ8y6jSGiuv3TPn
        R1/DBTIFM941wCKakq6w8OJ02Tb3IxBeMtqwKeI=
X-Google-Smtp-Source: ABdhPJzWXqtQDXDuF4UXRQScjIWGsl7N3FA2c+XsuXVG+OYbHhRIenGhiQ8wgr4mAsbVOuu3ZKAjHA==
X-Received: by 2002:a05:6638:1444:: with SMTP id l4mr1336808jad.41.1631640098735;
        Tue, 14 Sep 2021 10:21:38 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f17sm5069263ilq.44.2021.09.14.10.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 10:21:38 -0700 (PDT)
Subject: Re: [PATCH liburing 1/1] tests: test open into taken fixed slot
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <d87d67a95dc816556e3e38440bf34163fba3861f.1631632805.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fee0bc16-46d0-f54e-2306-a9335bc1f5ef@kernel.dk>
Date:   Tue, 14 Sep 2021 11:21:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d87d67a95dc816556e3e38440bf34163fba3861f.1631632805.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 9:20 AM, Pavel Begunkov wrote:
> Add a test case verifying opening into an already teaken fixed file
> slot.

Applied, thanks. Will fail before the change is into 5.15, but that's
probably not a big issue.

-- 
Jens Axboe

