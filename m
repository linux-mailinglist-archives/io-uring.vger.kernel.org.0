Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680473935EF
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 21:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhE0THa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 15:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhE0TH3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 15:07:29 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DBCC061574
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 12:05:55 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id c196so1783929oib.9
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 12:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AtePo78USGjM3CkiUbWSbKFiAWNBQCSE9nyEjfs9ZzE=;
        b=xH55kIN4Bp0gX8TZO0BC2hCTEs0TwNhQpNkMAPoWkx3LOHYlBThouaFz0ui8me5JSe
         EQjCQZjWrpdOVy0K/hgF58boHGs2dukkpaL9FyipttxPAoF8EHS3NR47zxGtpB29oLjt
         rpSCGHexZABwAm+AgRITloXSUtRSWC44029vjSGZinsDZnsF2bcdl9oGu3CLuOqtWGV0
         +G8PV3jr3XgIlEMglJVxJOyIx9k8pXvSN23qDevd4O5DvSuKEPaelZmmKOTXsdiywFV6
         GAJNs/6ApLGe+fTy232YllQvyRRd6XL8VTZQMpfxFV1arFcZTwNRgvuAHTRyZh/xD7Lq
         I4sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AtePo78USGjM3CkiUbWSbKFiAWNBQCSE9nyEjfs9ZzE=;
        b=qdy6EZt5O5NDPbqmeO0pZmsDLDG0Ic6bAa92sfu1EebzuIDWRuWD40hqoEBshMb4d+
         bwqtGaHU849DmeZwYDG+RBPSVpNECwuX1T1SUeejXzcYjIqdvmNY1ue+4/8X3SOE6hRu
         ZtLoA20SI2ky1Ww3C4VLzL7KaEVCo3YHAgqulq6ZVWWFI1z7qDWR58sm3E73MxGAUTfR
         Kln7oWmyoEx6creZVFtCJrM3AkVMIh529shrhZJ0HowKENe+kTqzdTwAzsxPF0PkitNw
         iRqhm1hLPsDH0wW4KbKS+omkexNsxYa7QdBP1w0mHIYvMHDscGGjHl7IpNC7g//Vtwj9
         nBwA==
X-Gm-Message-State: AOAM530u5W4W/FnBGMVUMZvLubw5OAHjbnwT8NhbzZxHVOVmD+/RgaKt
        b2nDD7h50G7eGJmEpztmtMQ6Ww==
X-Google-Smtp-Source: ABdhPJw74TAHk12Ebfje3xrFsvihvIMgNNrUWvm/E876tscEm+bJh4jGYMpXsgMW0ZqaK8sGimPEIA==
X-Received: by 2002:a05:6808:9b0:: with SMTP id e16mr6894040oig.152.1622142354485;
        Thu, 27 May 2021 12:05:54 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id r7sm607721oom.46.2021.05.27.12.05.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 12:05:54 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring_enter(2): clarify OP_READ and OP_WRITE
To:     Drew DeVault <sir@cmpwn.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20210523164437.22784-1-sir@cmpwn.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <43af392a-9a01-ecee-25cd-54072e0633b4@kernel.dk>
Date:   Thu, 27 May 2021 13:05:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210523164437.22784-1-sir@cmpwn.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/23/21 10:44 AM, Drew DeVault wrote:
> These do not advance the internal file offset unless the offset is set
> to -1, making them behave more like pread/pwrite than read/write.

Applied, thanks.

-- 
Jens Axboe

