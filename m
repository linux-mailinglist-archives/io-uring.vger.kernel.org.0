Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAEC53489D
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 04:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345922AbiEZCJL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 22:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345920AbiEZCJJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 22:09:09 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151D269CC6
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 19:09:07 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id f21so544987pfa.3
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 19:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=M2TEc+VN8ww8Lp8ENs3+Mthxz3r9BEn65AccCpCLe/s=;
        b=kvCRgwloV4Hac9ZR+qFJT0jprP1cRUkc64YURxHTvvYRkqzc3eGYVw1LDOu/0vQxra
         s5wYVkFKpk4A8M6HnqEyuBvsnci1jao7xyjYyvKehKIvig6SxYnfHxQs6jDXzU2z1DC8
         0Z8fCzTZ2e9Y24wsyRSY5YifE2lpU9wJnsoN103ewvvWM8FjQSzfUcFM7gdYq1jv0GE0
         M0LnPoS3x1KPlNUE47rrZOoQA1vFC2bWiL99JM2SgqlD3gGA2Zegi4IHXx7pBKjA4Pu0
         TVa3KJQ8ypJtd5kH58Vcd2TywcEEd6KeDbH+WmQ+y7ISzKv3YO/nTzft3QgdSzILUE1c
         Csfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M2TEc+VN8ww8Lp8ENs3+Mthxz3r9BEn65AccCpCLe/s=;
        b=vG7kd9El1uPwUuIh4Ui4D9Wqa1OxrRh1ZO6cGvG9N1mSqLN5Aam3QB9ygc37QC9cZo
         m/SrP8uhNCg4duhEcDQK5qHLkK0WbKSZ4uJohu0Wn1+ciJWAOpjHDz5uekCZNq9OH0GF
         LHQSLcjf2mPviklMH1p/J26HAniy7mAJqVR88jaT1MKL66WPY74kfBFSXm+h81QAx3HU
         Kja0J7VKjonw4SJ/o7F8Z2Qyu7x1+tTHL0Dg9jRJXL8YkT3VuXLWCv4d7qkgAnRMYlJI
         s1A61ZT2iLbpVbLjC+LYEjWQXqNHoOTtPK0L9QIL08fR8m1ZcWEaTqaqsFKBEK4SxF9L
         oMsw==
X-Gm-Message-State: AOAM533Z0Iab92uk5ezqH7TDGOUsE9MMMvCX407h/4aORWgU7pEEymHN
        6lhahvvEdNb3bssUAFoajXnxNA==
X-Google-Smtp-Source: ABdhPJzCMiuZVBGgvK4ih39RVSwlcm+MlbBjxFnw8EHsi5Q/wLI3mC6JjddV4yWpXni4TwRwVw8m7A==
X-Received: by 2002:a05:6a00:1a11:b0:512:6f59:f5cf with SMTP id g17-20020a056a001a1100b005126f59f5cfmr23228762pfv.45.1653530947342;
        Wed, 25 May 2022 19:09:07 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id gz4-20020a17090b0ec400b001df3a3c9381sm2303533pjb.5.2022.05.25.19.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 19:09:06 -0700 (PDT)
Message-ID: <7327b4bb-8d2c-ae86-de5e-311cc180e062@kernel.dk>
Date:   Wed, 25 May 2022 20:09:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: improve register file feature's usability
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <d8829873-4e68-1da0-f326-0af2dc40c3e1@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d8829873-4e68-1da0-f326-0af2dc40c3e1@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/25/22 6:08 AM, Xiaoguang Wang wrote:
> hello,
> 
> I raised this issue last year and have had some discussions with Pavel, but
> didn't come to an agreement and didn't come up with better solution. You
> can see my initial patch and discussions in below mail:
>     https://lore.kernel.org/all/20211012084811.29714-1-xiaoguang.wang@linux.alibaba.com/T/
> 
> The most biggest issue with file registration feature is that it needs
> user space apps to maintain free slot info about io_uring's fixed file
> table, which really is a burden. Now I see io_uring starts to return
> file slot from kernel by using IORING_FILE_INDEX_ALLOC flag in accept
> or open operations, but they need app to uses direct accept or direct
> open, which is not convenient. As far as I know, some apps are not
> prepared to use direct accept or open:
>   1) App uses one io_uring instance to accept one connection, but
>   later it will route this new connection to another io_uring instance
>   to complete read/write, which achieves load balance. In this case,
>   direct accept won't work. We still need a valid fd, then another
>   io_uring instance can register it again.

This one very well could work. We already have MSG_RING for sending a
message from one ring to the next, that could definitely be used to pass
a direct descriptor as well and drop (or not) it from the source ring.

>   2) After getting a new connection, if later apps wants to call
>   fcntl(2) or setsockopt or similar on it, we will need a true fd, not
>   a flle slot in io_uring's file table, unless we can make io_uring
>   support all existing syscalls which use fd.

That is definitely a problem, and actually the reason why eg
IORING_OP_SOCKET now exists. Seems the best solution there is pretty
simple - wire up fcntl() and setsockopt(). The latter is actually
trivial now that we have file_operations->uring_cmd().

> So we may still need to make io_uring file registration feature easier
> to use. I'd like io_uring in kernel returns prepared file slot. For
> example, for IORING_OP_FILES_UPDATE, we support user passes one fd and
> returns found free slot in cqe->res, just like what
> IORING_FILE_INDEX_ALLOC does.
> 
> This is my current rough idea, any more thoughts? Thanks.

I'm all for making it easier to use, but avoiding the "normal" file
table is preferable for a lot of reasons. Proof is in the pudding, feel
free to send an actual patch we can discuss.

-- 
Jens Axboe

