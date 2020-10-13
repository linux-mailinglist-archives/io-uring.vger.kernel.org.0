Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A1528D106
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 17:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbgJMPOP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 11:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730376AbgJMPOM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 11:14:12 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F20EC0613D0
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 08:14:11 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id p16so159879ilq.5
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 08:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NmoAKQiAoWMuaPqCLt2mXv6O6q+0xLl8+DkiP7MAABg=;
        b=uCq3MN1tkd3IH5OetYkr6yXgCbLw7KZ7xOMggvO1xOhCDj4NLL5Qw4dx4q7c89PqpU
         GsqiRUxOZ/516Ni4JqwylkvTDmslKG7M8QI8xMYRofHMY8uGQyaP2AnY+d9B+Gav9Sun
         vATd5OkN/ELdLB78A7h3E9bupFndpjGy3Hx3X03CHfrOQa4BA8BiZPThthaIU1C6Dk1Y
         e6dL/1fxaVCVQUOkBqWRz+6kijlNb1gY/3DrYM5kVqm6BEOtqNsyC9zXTuZbl7Qr1K3z
         BMJglBReKRRAkeCEJ70gYErxd57fgB8Lc/81/xj4D4VUwBZLiFQ1e+WuAitXSRwplDrP
         Rbqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NmoAKQiAoWMuaPqCLt2mXv6O6q+0xLl8+DkiP7MAABg=;
        b=VFV9J+j6XR7eO7xANHrs+koa+2mnXxji5smK1/d/81g/vq+D93IsiqwHsgLYSIda+T
         7Z601/aAdU5HClC3mCxrz7pZK5blKc9y+JftERhgCUV8czwcrT8cUWHALsSvfICn4Rg1
         yW6whgP9o0/mqsj+8MwBGrcT0a2NjSi56+iD7XPdGbfZTzGPEpL9/cvz6/LSOtKiAZIm
         pdYOduwTpdH1CIVTPR7gvDd5M9qo42BmQq/LIUIeJLxeE67XbdYJ+5KtdN8mMX9vgK7l
         iQwhjWKdGLvtqzpIXbbY0MCbcrMeWsodFZ+XcNp5Gf6d1D15KZJa4hko/bU9h0pKuMKY
         KnQg==
X-Gm-Message-State: AOAM533XGDna+/QrEcKRmrMyN01vOBocrjhdCSLc4++hJkiXBXT9finY
        4PrdMxsgz4AS6p6XOoPaTU1nVFrDAtMczA==
X-Google-Smtp-Source: ABdhPJzJY/EWK75uC3sfb8MbqJLjkT7J4EdnnZWYXlKTZfotyXSlL+i7hJ8/tYeJS4CcgFVaaUzYRw==
X-Received: by 2002:a05:6e02:543:: with SMTP id i3mr394049ils.22.1602602050212;
        Tue, 13 Oct 2020 08:14:10 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e17sm53953ile.60.2020.10.13.08.14.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 08:14:09 -0700 (PDT)
Subject: Re: [PATCH 0/5] fixes for REQ_F_COMP_LOCKED
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1602577875.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <10ef3c29-31ba-a495-c7fd-7c72917ca4f8@kernel.dk>
Date:   Tue, 13 Oct 2020 09:14:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1602577875.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/13/20 2:43 AM, Pavel Begunkov wrote:
> This removes REQ_F_COMP_LOCKED to fix a couple of problems with it.
> 
> [5/5] is harsh and some work should be done to ease the aftermath,
> i.e. io_submit_flush_completions() and maybe fail_links().
> 
> Another way around would be to replace the flag with an comp_locked
> argument in put_req(), free_req() and so on, but IMHO in a long run
> removing it should be better.
> 
> note: there is a new io_req_task_work_add() call in [5/5]. Jens,
> could you please verify whether passed @twa_signal_ok=true is ok,
> because I don't really understand the difference.

As mentioned in the other email, looks good to me.

Thanks, I have applied the series.

-- 
Jens Axboe

