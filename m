Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76943FCBF6
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 19:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239443AbhHaRBJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 13:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239112AbhHaRBJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 13:01:09 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF70CC061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 10:00:13 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id b10so25832971ioq.9
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 10:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zVqqmoTpN10xzq9NTm+EY13FgEzEBYASgRTUGEVAknQ=;
        b=k9bc1mEqLwI9g50vdLf5rGXIwcRCZyMz2r3j+HYv5C8DrNXALBjShWLmpGeleswE3m
         kVUJdAyOB1Ag4IBDVCvnyQL/YuqDqb28Atzp2Kt8uie0atUp9e7m/zVK3J+jam9Bhwmh
         BgFcEwHC9bUwyoM3iI7M9w5VnLlzo4zSi9wIHVWv7VQ3fmRyRZijUE9A1hn53/kpZ2ni
         /Rdg1gy7xz+soY3CFbo+fQHjx+OJesB3Sa/DSQCCsx6to8wk52eLJodj7dbgEfA/JVNG
         FWakOlkmSE1skulhF95NX4/kI/3jTNdhFJjBl1L0BYY0HTO2E/4o4V5Ec9skO59zAzdY
         oVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zVqqmoTpN10xzq9NTm+EY13FgEzEBYASgRTUGEVAknQ=;
        b=QVkxE6QwbnuHnGFPZQV5oOQuO+qesCORtmk6LJICyKUMveDLC2Gl5TaF20CeFV+3oy
         Q+Djz06zmXLIe6S1oTMFejIwuhMLeQ2XroJTMl/lYfNY/bk8vhqXkYJBpufPyz0cW23I
         7oWFRbGoV0j9fJSV+1OvYZildlCs4qPCDg6YOwAksxtgCZNXleVyLV89TEl6AnmgS0bu
         iKhayZjQu/hN3OSKn9naa7CgcqbtRgyuaI2VqMy8KjCVaE005/0bNwvUNGWpKAVKI1o5
         Q8zy6uXET62LG/YNNKwC7/frxqz//n2huhHcOSPsyKESaxSVU0rkTpd5FnJfbG2ln4bx
         PjDg==
X-Gm-Message-State: AOAM532xGtVHpGsyBgynlNYx6b2VAowCEmdtFPrvhaRvVi1t/g+X6RpX
        QfBE2ObYFTqKkiUfkJRFwZQzIaK+aVwRzA==
X-Google-Smtp-Source: ABdhPJxxz24knao+lwoN3JG4HXFtoXC/4pBp84wJPs1VcmEqkxukhPfhfnet4gU8RzWjVnCmKzaEpA==
X-Received: by 2002:a05:6602:2219:: with SMTP id n25mr23000937ion.185.1630429212972;
        Tue, 31 Aug 2021 10:00:12 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a25sm6368365ioq.46.2021.08.31.10.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 10:00:12 -0700 (PDT)
Subject: Re: [PATCH liburing 0/2] add direct open/accept helpers
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1630427247.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7941d255-27c4-6467-5d61-c85bef8ab341@kernel.dk>
Date:   Tue, 31 Aug 2021 11:00:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1630427247.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/31/21 10:30 AM, Pavel Begunkov wrote:
> Add helpers for direct open/accept. Also, use them in tests as an
> example.
> 
> Pavel Begunkov (2):
>   liburing: add helpers for direct open/accept
>   tests: use helpers for direct open/accept
> 
>  src/include/liburing.h | 38 ++++++++++++++++++++++++++++++++++++++
>  test/accept.c          |  7 ++++---
>  test/openat2.c         | 27 +++++++++++++++------------
>  3 files changed, 57 insertions(+), 15 deletions(-)

Applied, thanks.

-- 
Jens Axboe

