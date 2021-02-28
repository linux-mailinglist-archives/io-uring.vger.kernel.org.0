Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976A63274C5
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhB1WSV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhB1WSU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:18:20 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DCAC06174A
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:17:40 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id j12so10179249pfj.12
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=c+THXwXHz5BnQOVXMOtZYhw55QtfTQIKYhxn4AVc1v4=;
        b=qPW/jcnaedRWUcQAbIdjlzoqkxeWdB2XVwMAIwO3N0iea91PYjn6fMtjILUuV2TkSm
         9f87CCFBCXgjCQxY2WwoOgW3WI81VbnuRxwA/OJdEXWNLjEj904vRoBwyUO+lOU5YUP4
         mLGMNL1nTIsEwdrnnzBcX9AVZyQ1njRQ0J4n4m/VXpqI1WIjO9J5eOy/nkAD1Rx9GnBg
         xzFff3VybdUJIazbugS1bpX9lcpHuA/tMJZBPsa1b7IqJkPdsL5khtJ6xNwUZ8D9O7Rt
         RjYZyfV0i4wS7Km72rrDYvn3q1adNqyyG3biyaPZGWI1pAZ9jUSITKOEVPzbSmMfIlUl
         sThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c+THXwXHz5BnQOVXMOtZYhw55QtfTQIKYhxn4AVc1v4=;
        b=i3F/ncYjGCHaaGSHq9LabfiF0XlktiU4VP0n/QxTfnDKQYWSv+QaauaBcE2lWaXLH4
         bxwQi97u2AgvY0H5uTb+3LkpFIuSOHM3MYcJqijyG3EB2AXy83JplZLFn+VVeuVcQRe+
         AgIKCXAmEwr1Nmj8WJEtMdoXSb0l0g3g0cJaSRWC5iCytJ6ZHqut0Z/I3wMnCG9HHTsU
         Jlu+1zYKBIzTevYktqyKmEIBw/rYdrM11LUbsCfFMXmtQmredLC9N18Z4hRAXrPnXNNP
         AlIhMJO1U1O40vOekY3uExHiHwduRbzRZoHVdJmk6296KsKrjmAumSTT5KBbwRYXbfSC
         6EtA==
X-Gm-Message-State: AOAM533ivir6aLuwgii/rmWHiVGPGjRFGX+obZQbRZGR+sF/kRg5tXrw
        CYgp9+DOXy+nb1ivF71py7VSwmvhrTn1Xg==
X-Google-Smtp-Source: ABdhPJzMknPmOnzWZ2iFa2LAdAy4b+G1uuUXVnajgp6DXrT3ShdAF9gvCGxF6CLA7Og7mCP3/2raHQ==
X-Received: by 2002:a65:64d3:: with SMTP id t19mr11307688pgv.208.1614550659729;
        Sun, 28 Feb 2021 14:17:39 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d7sm5099429pfh.73.2021.02.28.14.17.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Feb 2021 14:17:38 -0800 (PST)
Subject: Re: [PATCH 5.12 0/2] task_work ctx refs fix + xchg cleanup
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1614549667.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <de9b6f55-5db0-86c4-ae17-5b4cf8ebd856@kernel.dk>
Date:   Sun, 28 Feb 2021 15:17:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1614549667.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/28/21 3:04 PM, Pavel Begunkov wrote:
> Two easy patches on top of io_uring-worker.v4, 1/2 is supposed to be a
> fix, 2/2 is a cleanup was mentioned before.
> 
> Pavel Begunkov (2):
>   io_uring: fix __tctx_task_work() ctx race
>   io_uring: replace cmpxchg in fallback with xchg
> 
>  fs/io_uring.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)

Applied, with wording fixed up in 2/2.

-- 
Jens Axboe

