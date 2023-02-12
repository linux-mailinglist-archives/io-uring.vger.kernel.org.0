Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473346935EA
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 04:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjBLDzb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 22:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBLDzb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 22:55:31 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5D811EB9
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 19:55:26 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id e10-20020a17090a630a00b0022bedd66e6dso13925695pjj.1
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 19:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EhWxFB4ODTurP+Bbh4zJn7gAxthxpyL6UKX+g4y+ZjQ=;
        b=4oXWD6WwwvKtE7IE7ek3e8RvqRagQZ8C8ZrVALBgqtBxdRjm/aG7oxpBqUnFwwM4DJ
         ek/S+kJ9IUeThE7HJuw7gpf7HnWARkN688eLl24wK0jaNeXhgDkFMWm0NfKMMJn1y6SE
         h4EA/zeco7f8KQFXqBOXxVOPDf13kk+VjrfQQ7bZyHvYFEvs9qdQjwn1PPKGX+s5ShQ5
         tKUPaXqT5Cu/VF3Afq8HKMWuhPcNDkMsOmtEgIMUaSFUcO5ihZ/plT4S3Rx6zU8mFNOH
         g5Zee/a2NpptVNbnAIkNNH6nT3tQKF4AxjMi81qPNsjzLk52oa+VmL15tBMLA11JguiU
         zNKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EhWxFB4ODTurP+Bbh4zJn7gAxthxpyL6UKX+g4y+ZjQ=;
        b=iwyrQrMHpe2rfziV1Tj3dckfitLTgeaVWeAVVdmXOc8D2UT3K3jSckPY4TivT7Aw9r
         MqNrlXhc77WtE+SGS77ZwGAcPSF6ODmljU5zGn/pOVLJ+gB1ywgz/mcINz9yfmYFAdpL
         GSV1wWqTiE+eeVbCAJn+dzTkVrkonlGLnFWDzty0BMml6kCnTTreRX0LpqRojRSdKjpj
         PHLLD2p2rw1D9XlSMGWmNrRwx0s/JwMCe2VvouFv3EiCgpCGmSgN2sHZy2qtd/M/u52/
         QYxSwZPpkyq/M+Gdo+HFg3pK+6KTv/d4p8hisAgQ9DWQQCRQRl4lngckHzgYoNlVZk3F
         UNtQ==
X-Gm-Message-State: AO0yUKUEQmSJJf3QQeumsWjLHXdOcJiTsKUgQImgcPiaNW6rlFE4YZbx
        oue/Bvfd9nyHpm9vJQXHUdO/MQ==
X-Google-Smtp-Source: AK7set9jwghXObjJgAAtgV3PvPOahGO37nT0OGYuWJMwgbbwncNytT3Wwxr2VE0SCOTnwxETr7ru1w==
X-Received: by 2002:a17:903:182:b0:198:a5d9:f2fd with SMTP id z2-20020a170903018200b00198a5d9f2fdmr21711336plg.6.1676174125887;
        Sat, 11 Feb 2023 19:55:25 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a10-20020a170902ee8a00b001992e74d058sm975727pld.7.2023.02.11.19.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Feb 2023 19:55:25 -0800 (PST)
Message-ID: <44355d28-776a-0134-b087-c11cf4e82f34@kernel.dk>
Date:   Sat, 11 Feb 2023 20:55:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 3/4] io_uring: add IORING_OP_READ[WRITE]_SPLICE_BUF
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
References: <20230210153212.733006-1-ming.lei@redhat.com>
 <20230210153212.733006-4-ming.lei@redhat.com>
 <a487261c-cc0e-134b-cd8e-26460fe7cf59@kernel.dk> <Y+e+i5BXQHcqdDGo@T590>
 <22772531-bf55-f610-be93-3d53c9ce1c6d@kernel.dk> <Y+hbggDCm9wViPAv@T590>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y+hbggDCm9wViPAv@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/23 8:22?PM, Ming Lei wrote:
>>>> Also seems like this should be separately testable. We can't add new
>>>> opcodes that don't have a feature test at least, and should also have
>>>> various corner case tests. A bit of commenting outside of this below.
>>>
>>> OK, I will write/add one very simple ublk userspace to liburing for
>>> test purpose.
>>
>> Thanks!
> 
> Thinking of further, if we use ublk for liburing test purpose, root is
> often needed, even though we support un-privileged mode, which needs
> administrator to grant access, so is it still good to do so?

That's fine, some tests already depend on root for certain things, like
passthrough. When I run the tests, I do a pass as both a regular user
and as root. The important bit is just that the tests skip when they are
not root rather than fail.

> It could be easier to add ->splice_read() on /dev/zero for test
> purpose, just allocate zeroed pages in ->splice_read(), and add
> them to pipe like ublk->splice_read(), and sink side can read
> from or write to these pages, but zero's read_iter_zero() won't
> be affected. And normal splice/tee won't connect to zero too
> because we only allow it from kernel use.

Arguably /dev/zero should still support splice_read() as a regression
fix as I argued to Linus, so I'd just add that as a prep patch.

>>>> Seems like this should check for SPLICE_F_FD_IN_FIXED, and also use
>>>> io_file_get_normal() for the non-fixed case in case someone passed in an
>>>> io_uring fd.
>>>
>>> SPLICE_F_FD_IN_FIXED needs one extra word for holding splice flags, if
>>> we can use sqe->addr3, I think it is doable.
>>
>> I haven't checked the rest, but you can't just use ->splice_flags for
>> this?
> 
> ->splice_flags shares memory with rwflags, so can't be used.
> 
> I think it is fine to use ->addr3, given io_getxattr()/io_setxattr()/
> io_msg_ring() has used that.

This is part of the confusion, as you treat it basically like a
read/write internally, but the opcode names indicate differently. Why
not just have a separate prep helper for these and then use a layout
that makes more sense, surely rwflags aren't applicable for these
anyway? I think that'd make it a lot cleaner.

Yeah, addr3 could easily be used, but it's makes for a really confusing
command structure when the command is kinda-read but also kinda-splice.
And it arguable makes more sense to treat it as the latter, as it takes
the two fds like splice.

-- 
Jens Axboe

