Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2848D2059FE
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 19:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733012AbgFWRyz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 13:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732973AbgFWRyz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 13:54:55 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF83EC061573
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 10:54:53 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t8so20270480ilm.7
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 10:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JJjWqg7tcKBVo75aZXm2q06PHgxmjpf/xa1nFI4jIFs=;
        b=WlAR2EYlO32R38xsgvCcSDosglkAjZFc+lQ+q9hNZE8uplGqEM/O7eIxEdyIXNshFl
         hHvSu4w0bO/LzCFQ/9alRyZo8wh/XqtgalooUSAF9RfCArJzdV8Rfx9/hOp9GGzf4Cr/
         i6xVqi3QckT6ZUb4ap/Qzfg9/I5q435J/iQtbeUOFEnZiKljmBaNjAOrdQUatdcLes7j
         /BDHdIbSq2sWAgfSuYOMsiLdektLfCd313POki/bqCgSBMOilIk6clYgm6CzO9yY0YHV
         ny67z4q0OGk7DI3Ef+Dv42yl0t8AMS/nE7JPg/V3sgfxnpiiTo1nQhrjVNLHYQYm6GgF
         noZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JJjWqg7tcKBVo75aZXm2q06PHgxmjpf/xa1nFI4jIFs=;
        b=PSB4dfqBNirlAQvnngWegOF2Hq4prionunTV9DZcAzwIJGIifRSxBLNA+9zNmyoO7U
         9jHcMvsMjQ3AQa0zOh1CY6fxDfMbWniyTUN+yP8SWJPGAgrJ0qBMSvp6xCB/26qHAfBz
         6yCR7srm/i45IgoJYIQXt85G02iYS5yZgvTil/61mxp7zYxbQUWgqt0baMDZeQVrvPFl
         0JbK8ookeIN4+yx5acUU4hZRMyHBw7xBhJ+XSfL/2XHL53dU7TPter9/xe9wb55w10K/
         Xl0pMEuYHvM7aLMrbAnKHqI6OWa1rgTv5MnjJ3HEzTMD7Z7tS5terAxtzJcvUUER8h0+
         uoIw==
X-Gm-Message-State: AOAM531H7aY5hQMdgLeks7GL9OmYFYXB4MuyYFGm0oKeoTJSyYjEuuux
        tJUcL0ae5xixUPjAAkLKeOcT68YLo/Q=
X-Google-Smtp-Source: ABdhPJwVpX2jfGBBcYU9m5APXHRQcwpT11CPMaS9oXBb3qNnwVd0Lg+5o4qNWI3OzcLzHFj6Xh8pGw==
X-Received: by 2002:a92:b684:: with SMTP id m4mr15922425ill.153.1592934893191;
        Tue, 23 Jun 2020 10:54:53 -0700 (PDT)
Received: from [192.168.1.56] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c3sm9913567ilr.45.2020.06.23.10.54.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 10:54:52 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: fix io_sq_thread no schedule when busy
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Dust.li@linux.alibaba.com
References: <a932f437e5337cbfb42db660473fa55fa7aff9f6.1592804776.git.xuanzhuo@linux.alibaba.com>
 <bb5be3f3976e1c56f4bcc309ea417a20ea384853.1592912043.git.xuanzhuo@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <86bb504b-1961-54c0-8a96-79e8f75f010f@kernel.dk>
Date:   Tue, 23 Jun 2020 11:54:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <bb5be3f3976e1c56f4bcc309ea417a20ea384853.1592912043.git.xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/20 5:34 AM, Xuan Zhuo wrote:
> When the user consumes and generates sqe at a fast rate,
> io_sqring_entries can always get sqe, and ret will not be equal to -EBUSY,
> so that io_sq_thread will never call cond_resched or schedule, and then
> we will get the following system error prompt:
> 
> rcu: INFO: rcu_sched self-detected stall on CPU
> or
> watchdog: BUG: soft lockup-CPU#23 stuck for 112s! [io_uring-sq:1863]
> 
> This patch checks whether need to call cond_resched() by checking
> the need_resched() function every cycle.

Applied, thanks.

-- 
Jens Axboe

