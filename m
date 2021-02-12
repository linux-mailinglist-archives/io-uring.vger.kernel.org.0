Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC9B31A557
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 20:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbhBLT0g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 14:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbhBLT0f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 14:26:35 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9617C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 11:25:54 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id t11so303457pgu.8
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 11:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SfHQp2PN2omMLBUyJOfHo/korR/YRmYl8GE0K09rv0g=;
        b=v/y/sX0OIfUUr30ATel6/LliZiU+YgtxuEYWJy4Rgz5SkzMFRhjY38NPAF/aKDgEgG
         3HpNCSx51AOC9hOUJw7BvgLx71V+dQ/E/4MkislcxVaX21bntsvJWkapJ/7K1dYKcekC
         j8R1CuNIVUjPlZ1YElSZv9AOF1zyMcIYyhx7cu/9v+38SdA+1D2qsluZjTKFXshBpbTH
         GpvRL85CCjoUu2Xnt+B3zm8JLBofFQqQ7U4MNNLkfiBI/E0G/lQjTld2t4BG4LosWVi1
         IeM/AVmw4o7Mx9eQiIzSBQ8QMyZhUCJKelJVe/DJ783jBvjopS8Hq3n3SJYDb1/U8UqM
         HybA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SfHQp2PN2omMLBUyJOfHo/korR/YRmYl8GE0K09rv0g=;
        b=OM9aQZiaDv/A2LHgs2nGRPVV11PNlO+QqCYu+D/O129R0SXN86OU2tkgU6QVcrXLKq
         +RGh698vjIXklbImU31keMtPvDtJ21ydUjQxUMmOVsEv9EzrFp0ETC5eGKxWY5kn4iAh
         Yhs7jNoyn9xIg16iocYaZLW18IOU6uANQbpFZJ+Y39+sfunxtCHQG5dpT9RNZCiEabKN
         Ys4hjHcbjEc4d9wt8hzilddCCM8o70jIp+WeVXzToQkKw9aI+BhPD5nLbYjcffCoJH40
         l/ghFLc5Wi4ITEtMLR0uLYykQAP6P2h5JpczF7YZm9IpZa6I1GSG1sAdar5fPLVxaMNT
         tq6g==
X-Gm-Message-State: AOAM530jWRMMJJ/zUFwNRV4SRm5EX7m8lFbRXGRQLZ4D5jcimoAYY+ab
        66qX9O37hWQYK8OkIulqIS+9AgI1pPWuMQ==
X-Google-Smtp-Source: ABdhPJxNpL7wKcrjYtbWZ55blpo133u5AJTX6ouzKB50Gi3G+VBDC+ZILHnI4FoDxupIkBf8m2xQDA==
X-Received: by 2002:a63:30c5:: with SMTP id w188mr4538086pgw.375.1613157953893;
        Fri, 12 Feb 2021 11:25:53 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21e8::16bf? ([2620:10d:c090:400::5:2056])
        by smtp.gmail.com with ESMTPSA id t17sm11238378pgk.25.2021.02.12.11.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 11:25:53 -0800 (PST)
Subject: Re: [PATCH 0/3] small cleanups for 5.12
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1613154861.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d61e33a8-7b24-2f2b-8cb7-d040ae1eeb15@kernel.dk>
Date:   Fri, 12 Feb 2021 12:25:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1613154861.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/21 11:41 AM, Pavel Begunkov wrote:
> Final easy 5.12 cleanups.
> 
> Pavel Begunkov (3):
>   io_uring: don't check PF_EXITING from syscall
>   io_uring: clean io_req_find_next() fast check
>   io_uring: optimise io_init_req() flags setting
> 
>  fs/io_uring.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)

Nice little cleanups, applied.

-- 
Jens Axboe

