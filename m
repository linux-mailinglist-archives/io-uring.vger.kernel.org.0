Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C89621A1F2
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 16:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgGIOS4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 10:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgGIOS4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 10:18:56 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F320C08C5CE
        for <io-uring@vger.kernel.org>; Thu,  9 Jul 2020 07:18:56 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id c16so2449552ioi.9
        for <io-uring@vger.kernel.org>; Thu, 09 Jul 2020 07:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X4KpwNdFtQiGHjsO5ffa2ermVz96yVtvqz/sg3i1C6A=;
        b=YT+6Jryc2oxEA3r/LUrC2kmVMfR85v5nPHrgBaTga4b3kuQAqIkgtGMlMXWykGufc4
         rE0CEVpbksXO5F3cnA3XCiP769skpyoN50mD28+rRT1hBgM1YhissjR4hqxxtWDdBm5E
         N+sew36CCKf8JDuDnED5kzXVRWyINHWnlITUv9NKKYF8JnwA1lsbC5JISbRl8jgBmPsL
         xnyJTikTf7yTKA3ONaezqjuEk9oYFsgwB19Zi6QsC4m71Qx/3RlvSITVk1ImI2UfLbhB
         uTNNDirkP/fu+uApTicidwW25ts+6m1i+VC45e1jFN6/Tx3hTSJXPLN/5vQZH4uNgTsF
         SP4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X4KpwNdFtQiGHjsO5ffa2ermVz96yVtvqz/sg3i1C6A=;
        b=S02W/g4oGJOKp25I2P0vsR7jvnOJeGg9RCoT2OJy1o4jSVqXQBJDwa2/+AEu11PMkK
         tY+EDeSUlwmLqpT3IDRNme0qz49r4aQpTGvfy9CggzE5tEGN//fYQBJvASy4cNxdxt+7
         Py/x+A0bzpMBpTD/9sJSJKcFbuW0xCoWam0SJbock8GzCnJt1zBZcBqeag5QY9RTorlE
         0TvaQeMBnS465l9XqmIquOeJWJ4hcdAVTvN1x8DkSRQLL9KcCLgBsVevNpBHXrRbqYin
         mMpRwElh1EIT+JllaLeaCx+1N4jG7pCU1YEH+LzNU3ScFmXqjpN43MAHrsG5228ElfOY
         Uuuw==
X-Gm-Message-State: AOAM530yLHBEbKjM/amO2rjQweizJAsjBmGm09ax2lROFIY2SmlXEQqK
        tDkkg4OkZIsr2DdpWSH3MfhrdJsf8qNbcA==
X-Google-Smtp-Source: ABdhPJyGiLBTUcjaXVLrg2zZ8+CwUb3yrYNu3UEkopCGemY6YeHNC663nnLHL4cjpBgPQu5VRo4dnw==
X-Received: by 2002:a05:6638:2a9:: with SMTP id d9mr66789130jaq.111.1594304335062;
        Thu, 09 Jul 2020 07:18:55 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c29sm2078820ilg.53.2020.07.09.07.18.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 07:18:54 -0700 (PDT)
Subject: Re: [PATCH] io_uring_peek_batch_cqe should also check cq ring
 overflow
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200709073349.31860-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <68bea06c-5fb0-0e66-9eaf-342d9a99793a@kernel.dk>
Date:   Thu, 9 Jul 2020 08:18:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200709073349.31860-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/9/20 1:33 AM, Xiaoguang Wang wrote:
> In io_uring_peek_batch_cqe(), if the first peek could not find any
> cqes, we check cq ring overflow, and if cq ring has been overflowed,
> enter kernel to flush cqes, and do the second peek.

Applied, thanks.

-- 
Jens Axboe

