Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980CF3D3843
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 12:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhGWJTv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 05:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbhGWJTv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 05:19:51 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CA2C061575;
        Fri, 23 Jul 2021 03:00:24 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 14-20020a05600c028eb0290228f19cb433so3196040wmk.0;
        Fri, 23 Jul 2021 03:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CA2X675ItP12Zp92GzuD5HfBHHhr6X6ENpeeC3TGVxE=;
        b=NyE4+sAxq8OJYIkO1TU31L7vm7qElZuRZryYgxcly5F+DLHMMNENH0UFaaT82QGiq0
         VcEgPeL0iPhmLRqpKZ9QnO9qR/9pft/2PYMif//667h+q5GhBi83idtPykYP4AbHobo5
         N5qRBGzXf8QBCOicZhzmy5CYHMvH8ibV941iT/RlZZhrRpu8Dcx1es8Iv1+2co23XyGN
         zIY17ANk0QFNdQzUgTZCjdz6I3UPkblT3YksMSfJPHQlZz1Zlr6xkBMOLkGLVmd0hqU0
         8WPI5QsMCXeJNB0bD4AYByzcYLcXk5uPZ53Q6i7jtn50qszsTm8jZ9T1lFKp4r7Gn8r2
         pD9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CA2X675ItP12Zp92GzuD5HfBHHhr6X6ENpeeC3TGVxE=;
        b=B8C8UT36eCUk621LlqEjwBV4WA9l1QsuYBbLswH/vmqYIXsTp892xDWjL9bxNbuzmP
         EAY97hYibWVE7kUCt/azvnHexdruFUnZ2v/7y1sRI0vvWn2dtKrLiYOHeGAEKpg3ebmc
         uicifGceuDsZ330mcJdDlrk3ueQUqFFC/2bhcA0iwqYlBJwt6T0uD+pocKAxH+S+QuyI
         4wd+PF5qoUllAU9NJbdQdMopZNbUJX4xbrr7+IiK7NBMyyqDn6QD2IIDLhrHFbbisxuH
         4qMnxmF4o38Z03QmSb8vkYYY/kW40OQZW+xpMy9QJetvr0E66ECT7okWlMzNFi51LcS3
         DLyQ==
X-Gm-Message-State: AOAM530p65021eXhVhaMn8Ah9nvm27WFf+ERL8ZWog78VRzl42AYE16S
        mwdYqCkEWKnVQOFWgjfGOek=
X-Google-Smtp-Source: ABdhPJxKm6ITtVs5aTn1HawnRLqR3orgoVUvBQP/w5gl/5z0oIp6Kwhj+RBzWrOCyVC3VFRhAagSMg==
X-Received: by 2002:a7b:c042:: with SMTP id u2mr3650213wmc.86.1627034423300;
        Fri, 23 Jul 2021 03:00:23 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.234.52])
        by smtp.gmail.com with ESMTPSA id w185sm4134561wmb.11.2021.07.23.03.00.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 03:00:22 -0700 (PDT)
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <cover.1618916549.git.asml.silence@gmail.com>
 <939776f90de8d2cdd0414e1baa29c8ec0926b561.1618916549.git.asml.silence@gmail.com>
 <YPnqM0fY3nM5RdRI@zeniv-ca.linux.org.uk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
Message-ID: <a60c45c1-cfe3-53f1-332c-eb1271c968f8@gmail.com>
Date:   Fri, 23 Jul 2021 10:59:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPnqM0fY3nM5RdRI@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/22/21 10:59 PM, Al Viro wrote:
> On Tue, Apr 20, 2021 at 12:03:33PM +0100, Pavel Begunkov wrote:
>> Just a bit of code tossing in io_sq_offload_create(), so it looks a bit
>> better. No functional changes.
> 
> Does a use-after-free count as a functional change?
> 
>>  		f = fdget(p->wq_fd);
> 
> Descriptor table is shared with another thread, grabbed a reference to file.
> Refcount is 2 (1 from descriptor table, 1 held by us)
> 
>>  		if (!f.file)
>>  			return -ENXIO;
> 
> Nope, not NULL.
> 
>> -		if (f.file->f_op != &io_uring_fops) {
>> -			fdput(f);
>> -			return -EINVAL;
>> -		}
>>  		fdput(f);
> 
> Decrement refcount, get preempted away.  f.file->f_count is 1 now.
> 
> Another thread: close() on the same descriptor.  Final reference to
> struct file (from descriptor table) is gone, file closed, memory freed.
> 
> Regain CPU...
> 
>> +		if (f.file->f_op != &io_uring_fops)
>> +			return -EINVAL;
> 
> ... and dereference an already freed structure.
> 
> What scares me here is that you are playing with bloody fundamental objects,
> without understanding even the basics regarding their handling ;-/

Yes, it's a stupid bug and slipped through accidentally, not proud of
it. And it's obvious to anyone that it shouldn't be touched after a
put, so have no clue why there is such a long explanation.
Anyway, thanks for letting know.

By luck, it should be of low severity, as it's a compatibility check,
the result of which is not depended upon by any code after. To
fault would need some RAM hot-remove (?). Not an excuse, how you
put it, but useful to notice.


> 1) descriptor tables can be shared.
> 2) another thread can close file right under you.
> 3) once all references to opened file are gone, it gets shut down and
> struct file gets freed.
> 4) inside an fdget()/fdput() pair you are guaranteed that (3) won't happen.
> As soon as you've done fdput(), that promise is gone.
> 
> 	In the above only (1) might have been non-obvious, because if you
> accept _that_, you have to ask yourself what the fuck would prevent file
> disappearing once you've done fdput(), seeing that it might be the last
> thing your syscall is doing to the damn thing.  So either that would've
> leaked it, or _something_ in the operations you've done to it must've
> made it possible for close(2) to get the damn thing.  And dereferencing
> ->f_op is unlikely to be that, isn't it?  Which leaves fdput() the
> only candidate.  It's common sense stuff...
> 
> 	Again, descriptor table is a shared resource and threads sharing
> it can issue syscalls at the same time.  Sure, I've got fewer excuses
> than you do for lack of documentation, but that's really basic...
> 

-- 
Pavel Begunkov
