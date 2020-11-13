Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38412B2969
	for <lists+io-uring@lfdr.de>; Sat, 14 Nov 2020 00:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgKMX5Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Nov 2020 18:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgKMX5P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Nov 2020 18:57:15 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0FFC0613D1
        for <io-uring@vger.kernel.org>; Fri, 13 Nov 2020 15:57:15 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id i13so8375572pgm.9
        for <io-uring@vger.kernel.org>; Fri, 13 Nov 2020 15:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6PReU8kIuLpD05kRWqXp55kYvz7oTf3RLad+p34Hppo=;
        b=iawKu2hg6X0NbVar1b9Brp+0LR6uu32hyEn8HQJuXkfpK2lm2vsQ6CVvISWGdq/MHe
         lq7w+VxCU5zfd2lsgmeCAE+xjW57fsevnCjf/O5fZFCUAH+HzSQC1mlGj9VzjS7PBpz8
         8FV5iLANyPiKubfqwjRPwZKCCAvS/oZQsQP9co0ohU+FJr62wqZB/B4G1WbpxbPHnqBW
         sl5A+ANEpI9W2bPghosJhiSZkpB1kMAbeGc3p9xprPo03cX+KFppoMPR/6+u5mkHT2Mc
         iMIPSl+Cj35buMOaMKWnb91C0Ewfivs7aBl3WFcux3tk1lrTY6UajtqGMiACyqBIJx5x
         BNnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6PReU8kIuLpD05kRWqXp55kYvz7oTf3RLad+p34Hppo=;
        b=L3dsIeS2lq96anpSw5WGa60vWwgll3OaiZX0txXEP503efu/p2MvrVpu2+Lnt7he8A
         H7nZhTWg/tRr9gGLp5H3d0JU7DCQjZ5kxlN9Zy4JOcscw1/vRb3SVsL/QZGb46qUqrH7
         kMu2ok4iyChzrn7/RxB8HesJ0y7BxmavgBjZRDPXwNr3wjQ3cvsf+J6is5pGuMf7A+o0
         gLOVTgJUkoRA6nWiV06suoJx1ImUHeVQML0jb5IyuZDcwYKQYtxXl2B6Xj2Hfmd9LO5f
         2Di98FDKfXIb4nOHT56L/IAfeXvltKVf7rIjM75H49VPFwoDvsrRGRJ4zs49zUjDhcRl
         0BZw==
X-Gm-Message-State: AOAM533Rr1DzeOYD0HkY1oo8BYKkv/7J8OWIJSGkefQ3+eax14HMzQ01
        gXYb07xVtfwzXSyvuA2efhMbxK0vmZEibg==
X-Google-Smtp-Source: ABdhPJxnCpKbAaWPRCy+NZvu8F+Bp5LOhBGLr0Lu8Yfuv4eNOYcNDxs55j5MMPlkRa+qqqT4MxSOmA==
X-Received: by 2002:aa7:9308:0:b029:18b:3a1b:f46a with SMTP id 8-20020aa793080000b029018b3a1bf46amr4070017pfj.64.1605311835174;
        Fri, 13 Nov 2020 15:57:15 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w13sm10928999pfd.49.2020.11.13.15.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 15:57:14 -0800 (PST)
Subject: Re: [PATCH 0/2] io_uring: add mkdirat support
To:     Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org
References: <20201111132551.3536296-1-dkadashev@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <06d8f82f-e406-9fa3-b8a1-7ff865c9b064@kernel.dk>
Date:   Fri, 13 Nov 2020 16:57:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201111132551.3536296-1-dkadashev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/11/20 6:25 AM, Dmitry Kadashev wrote:
> This adds mkdirat support to io_uring and is heavily based on recently
> added renameat() / unlinkat() support.
> 
> The first patch is preparation with no functional changes, makes
> do_mkdirat accept struct filename pointer rather than the user string.
> 
> The second one leverages that to implement mkdirat in io_uring.

Looks good to me - you should send the first patch to linux-fsdevel (and
CC Al Viro), really needs to be acked on that side before it can go in.

Also, have you written some test cases?

-- 
Jens Axboe

