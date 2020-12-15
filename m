Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152022DB143
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 17:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbgLOQTk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Dec 2020 11:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730757AbgLOQSm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Dec 2020 11:18:42 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9049EC0617B0
        for <io-uring@vger.kernel.org>; Tue, 15 Dec 2020 08:18:02 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id q1so19749278ilt.6
        for <io-uring@vger.kernel.org>; Tue, 15 Dec 2020 08:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=diFiOdC7jji4ApRY/TN7q4luYnhO42+izDOiqW6c7fQ=;
        b=hQiDU6yz9paRrn/W1FNtwDtULkqHPLtXCn25y/0+TcdmbJHBjmxRjJooAwo88AHHYo
         GWlaKO9W1fmFP2jWgFhgh4aQn4igIqu5dcHf8kKhQsjTs5XaojT6fB0kfy5cCsjqBkMX
         DaloqW6SHdXcFPT4+53Lv3NRDvv4kU6HfwNkKxQZASOb6WE2dhRYTCkZX3zaXwZu52oi
         yu3YAcsq4yBnKbC9SYeQXEDN10LS7Kx7SjI4AH68SEWC93LRAX6hd4u4ZVTUHBWuJC3U
         4zrCQ5SexpPVD8VIH+gae+aCEby/KtQ8ozpGagIWTz5lECzsZTv8IMfuw1M/BA+JcOqL
         kb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=diFiOdC7jji4ApRY/TN7q4luYnhO42+izDOiqW6c7fQ=;
        b=k+W23fIGfgJEqCSmQ3LGlNT4rSfsybc8Dioo3gO5ZXJeWW3WosmRoa2s5nCdO177Nt
         IXYJ1/sS/eoXmu/W5JqfBbyT+PuJ/1n2R36Oyd6jOnI45c1iimQl3/huSW1Xky/ynA3y
         dVZMm7XWqy7lhBjiZ+pGRf/20v2uu7VuArZPL7e6i7mUYZDZ6/iQKcpXhYaGXwwQAm/7
         UaTXGFL/8RW4XGZK5ZUuNkCYxuwwtXZfUo8hSNN013PCEX49AzZfEshW8ItD55Ih5uiQ
         D/CAtbd3DES5VvhVTCyDd045lPVx5smV4FeW5MIdYz+FQUI0eeltsj8p1tH9GSP+n+Ry
         TWgw==
X-Gm-Message-State: AOAM533MX+sEUDzB35iKBHPDOkm2xzICrnDUYBCL/POwPp2wsUL7ehE4
        moVY85zvolZCt9mpaGLI21eSKg==
X-Google-Smtp-Source: ABdhPJyha0KEja10VFJnNgShAOa3IQYWTiFNHSiERzn5YuU3MU0Ys3JRHhSfLDy5+rZySGnWYXS+uw==
X-Received: by 2002:a05:6e02:1185:: with SMTP id y5mr42582830ili.119.1608049081777;
        Tue, 15 Dec 2020 08:18:01 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r5sm13084632ile.80.2020.12.15.08.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 08:18:01 -0800 (PST)
Subject: Re: Lockdep warning on io_file_data_ref_zero() with 5.10-rc5
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Nadav Amit <nadav.amit@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <C3012989-5B09-4A88-B271-542C1ED91ABE@gmail.com>
 <c16232dd-5841-6e87-bbd0-0c18f0fc982b@gmail.com>
 <13baf2c4-a403-41fc-87ca-6f5cb7999692@kernel.dk>
 <e9f232a9-f28e-a987-c971-d8185c0060f5@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8bb82057-1fdf-cb99-0549-2a1a27600d15@kernel.dk>
Date:   Tue, 15 Dec 2020 09:18:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e9f232a9-f28e-a987-c971-d8185c0060f5@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/14/20 11:58 PM, Xiaoguang Wang wrote:
> hi,
> 
>> On 11/28/20 5:13 PM, Pavel Begunkov wrote:
>>> On 28/11/2020 23:59, Nadav Amit wrote:
>>>> Hello Pavel,
>>>>
>>>> I got the following lockdep splat while rebasing my work on 5.10-rc5 on the
>>>> kernel (based on 5.10-rc5+).
>>>>
>>>> I did not actually confirm that the problem is triggered without my changes,
>>>> as my iouring workload requires some kernel changes (not iouring changes),
>>>> yet IMHO it seems pretty clear that this is a result of your commit
>>>> e297822b20e7f ("io_uring: order refnode recycling”), that acquires a lock in
>>>> io_file_data_ref_zero() inside a softirq context.
>>>
>>> Yeah, that's true. It was already reported by syzkaller and fixed by Jens, but
>>> queued for 5.11. Thanks for letting know anyway!
>>>
>>> https://lore.kernel.org/io-uring/948d2d3b-5f36-034d-28e6-7490343a5b59@kernel.dk/T/#t
>>>
>>>
>>> Jens, I think it's for the best to add it for 5.10, at least so that lockdep
>>> doesn't complain.
>>
>> Yeah maybe, though it's "just" a lockdep issue, it can't trigger any
>> deadlocks. I'd rather just keep it in 5.11 and ensure it goes to stable.
>> This isn't new in this series.
> Sorry, I'm not familiar with lockdep implementation, here I wonder why you say
> it can't trigger any deadlocks, looking at that the syzbot report, seems that
> the deadlock may happen.

Because the only time the lock is actually grabbed in bh context is when
it has dropped to zero and is no longer used. The classic deadlock for this
is if regular use has both contexts, so you can get:

CPU0			CPU1
grab_lock()
			bh context, grab_lock()

deadlock. But this simply cannot happen here, as by the time we get to
grabbing it from bh context, there can by definition be no other users
of it left (or new ones).

-- 
Jens Axboe

