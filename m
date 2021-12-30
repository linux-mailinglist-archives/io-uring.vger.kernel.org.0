Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49235481F65
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 20:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236868AbhL3TJP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Dec 2021 14:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236940AbhL3TJP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Dec 2021 14:09:15 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010EDC061574
        for <io-uring@vger.kernel.org>; Thu, 30 Dec 2021 11:09:15 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 8so22070345pfo.4
        for <io-uring@vger.kernel.org>; Thu, 30 Dec 2021 11:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fysHuqj+dz2GT8PfjvEueGj5F+LE15D/0WG+fpJBFj8=;
        b=dr0oMzHttPZio81W+Cvd202qGfrnrosKh+GXHoWdp6Uu7WsAsLwplCsJXEXh4RWhH6
         4jn3xb+6L/GqOpblnrGCxXth6KXVoNLUF2ayc+ALarKa9HtUA22jq7qHpiFjAgzUForX
         VD9QSmf9gHbz9cRh4z6UNhmwBRO+cytxEO464zC0kUZ9lSXEwAcfhpcHi4KfvmMDG/AM
         vIZW10av4d5R+xgOxNCLS6wNGk5YiA2dNRMV8R0/rOjyrky13OX9h+Cv1Qv3i9P1D+G3
         iNpAuJRdTkTL1uxoPLWyPzvc8LYCxd5Dg1RfXuv14XTdciBAhFoJY3eqlPosUe5Q8nU+
         oPbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fysHuqj+dz2GT8PfjvEueGj5F+LE15D/0WG+fpJBFj8=;
        b=7gqwvc6UISXjeBI0I27hFG2CGIaTi0sZDoDoBeDbiLONeg9agWNQ/gcj3X3jiSYegV
         PdK4AithAgRUIyXIYhZbFi72dhN0W7O9zeWUn3ryHgDIClJu5MxFY3V3ekYIoCQLocZG
         oOu+b8mmDr2bCSJI77cPo8xX3ftbj8nVlYH8WpFFZw9BxVn6u7ayng7If694KbnDL71H
         m2sipBt2pGnir7Je285bcfC9Yyq+UyapEnRvEMCNRal2UhAyFnV8e39Pgr9hUH5EUEBr
         pPm2Nwe1y6Lj5m1fi0RVSxdPvIwHfaABJQzmbBwV5zEQcmO5PoybeGcBZF8P+rWpFvGj
         2jvQ==
X-Gm-Message-State: AOAM5325Du1Qp6jdP+a4I1eX5VOBlaGxfxZWyWQkGUeJ58D7gEXifpFu
        75wajA27sIrePk90+R2LC40nrw==
X-Google-Smtp-Source: ABdhPJy3bvE4xvTWtBoPuqhngT5QK0vpda0T7b2brmUMNDRQHdIyd+zcEUX+BhqO14U7BnjRF5RPmQ==
X-Received: by 2002:a63:9d8a:: with SMTP id i132mr14004425pgd.329.1640891354045;
        Thu, 30 Dec 2021 11:09:14 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id y32sm29575892pfa.92.2021.12.30.11.09.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Dec 2021 11:09:13 -0800 (PST)
Subject: Re: [PATCH v10 4/5] io_uring: add fsetxattr and setxattr support
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        torvalds@linux-foundation.org
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-5-shr@fb.com>
 <Yc0Ws8LevbWc+N1q@zeniv-ca.linux.org.uk>
 <Yc0hwttkEu4wSPGa@zeniv-ca.linux.org.uk>
 <20211230101242.j6jzxc4ahmx2plqx@wittgenstein>
 <Yc3bYj33YPwpAg8q@zeniv-ca.linux.org.uk>
 <20211230180114.vuum3zorhafd2zta@wittgenstein>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5030f5fa-79c3-b3b7-857d-3ac62bf2b982@kernel.dk>
Date:   Thu, 30 Dec 2021 11:09:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211230180114.vuum3zorhafd2zta@wittgenstein>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/30/21 10:01 AM, Christian Brauner wrote:
>> However, what I really want to see is the answer to my question re control
>> flow and the place where we do copy the arguments from userland.  Including
>> the pathname.
>>
>> *IF* there's a subtle reason that has to be done from prep phase (and there
>> might very well be - figuring out the control flow in io_uring is bloody
>> painful), I would really like to see it spelled out, along with the explanation
>> of the reasons why statx() doesn't need anything of that sort.
>>
>> If there's no such reasons, I would bloody well leave marshalling to the
> 
> That's really something the io_uring folks should explain to us. I can't
> help much there either apart from what I can gather from looking through
> the io_req_prep() switch.
> 
> Where it's clear that nearly all syscall-operations immediately do a
> getname() and/or copy their arguments in the *_prep() phase as, not in
> the actual "do-the-work" phase. For example, io_epoll_ctl_prep() which
> copies struct epoll_event via copy_from_user(). It doesn't do it in
> io_epoll_ctl(). So as such io_statx_prep() is the outlier...

For each command, there are two steps:

- The prep of it, this happens inline from the system call where the
  request, or requests, are submitted. The prep phase should ensure that
  argument structs are stable. Hence a caller can prep a request and
  have memory on stack, as long as it submits before it becomes invalid.
  An example of that are iovecs for readv/writev. The caller does not
  need to have them stable for the duration of the request, just across
  submit. That's the io_${cmd}_prep() helpers.

- The execution of it. May be separate from prep and from an async
  worker. Where the lower layers don't support a nonblocking attempt,
  they are always done async. The statx stuff is an example of that.

Hence prep needs to copy from userland on the prep side always for the
statx family, as execution will happen out-of-line from the submission.

Does that explain it?

-- 
Jens Axboe

