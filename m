Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFAE519EF9
	for <lists+io-uring@lfdr.de>; Wed,  4 May 2022 14:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345769AbiEDMNV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 May 2022 08:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242185AbiEDMNT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 May 2022 08:13:19 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D197252AB
        for <io-uring@vger.kernel.org>; Wed,  4 May 2022 05:09:43 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so4995098pjv.4
        for <io-uring@vger.kernel.org>; Wed, 04 May 2022 05:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WN26lsagJL4pdNyPEQ7HfFpD1NYMfhKOpFKAu+2HvXc=;
        b=eB+RA9Xn/HO7qvVXckDmKIxv3Rdk20fFxZXIJsbgSnU5xH11QlIbEk+41sSRfiGIYb
         2nvMYN3XJZB6LOyjUWjkt7VOrYe2d7LS7aJFstRKrw3vqC/Oqclo21b2nvOg5itOwE7A
         ZDNy7cs9VaTmKQUCQM4TdYrN21zXtxmWPKdHQQCZTqQnQ+U0QHrw3XuoED2zq6aNxSNd
         8wZajNjmxNv+5uEK9tmaV+jxKTHQAP26KDyjLr+7YJcBag7DYjVE8aiQV6ltpWAOjDjv
         upIuyuyU4KNewWXWIrN7VsA7foTz4EruCxYif6Tb7cNy1nAzX0pIH2NpQI3DYzM1k8S3
         trQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WN26lsagJL4pdNyPEQ7HfFpD1NYMfhKOpFKAu+2HvXc=;
        b=0tzm0si39AJ0HRxS9O38L6JRFf4oMwwpZU3NxM+kfPfPnjsVnPAH3H3qnyFcE5Qb6y
         /NNtkKrB7b+0hBrFqG0XNClTjN+wvjksAyTrsRUgkmpnWCvxG7RLN1iFPZ5FvNyvbeWE
         1wOvYg+8O9mmtRnX84rNFKbHhCnmF33SPk41xwhHkXbJh5kcf0Xb9JVMmrM2VTsMbKw4
         XbIO4nYDtID69f1x8AlgxOuK3YCbcNglsrWve0BjhFGNt7pESOw8skiTZGVrf+E5mCX/
         5yDBlLn0gAxtXCAYO0nD/J1aKZweEQmQSa5jQ1Lqfh1x28GHKDZKbBHhNMLkJTmlBKi8
         4b0A==
X-Gm-Message-State: AOAM533kacnjZR+LtVW/4k03xS4kXSnxAMa5+c4ryWR1K0DwemoBhlyP
        GFqjTPim7TDb48nNjeuMClSjng==
X-Google-Smtp-Source: ABdhPJyI9yHw5N7Z274pvOUBNLkDQslDEoywKffSOV3ZxsSOQ1SpbdjrK0LJm3PQ5VuOZ6r4UCKqPQ==
X-Received: by 2002:a17:90b:4f92:b0:1cd:3a73:3a46 with SMTP id qe18-20020a17090b4f9200b001cd3a733a46mr10136443pjb.66.1651666182660;
        Wed, 04 May 2022 05:09:42 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id p4-20020a1709028a8400b0015e8d4eb257sm8186529plo.161.2022.05.04.05.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 05:09:42 -0700 (PDT)
Message-ID: <812fe134-3e69-294b-fd05-9a8366e17467@kernel.dk>
Date:   Wed, 4 May 2022 06:09:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 1/5] fs,io_uring: add infrastructure for uring-cmd
Content-Language: en-US
To:     Kanchan Joshi <joshiiitr@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc:     Pankaj Raghav <p.raghav@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Stefan Roesch <shr@fb.com>, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
References: <20220503184831.78705-1-p.raghav@samsung.com>
 <CGME20220503184912eucas1p1bb0e3d36c06cfde8436df3a45e67bd32@eucas1p1.samsung.com>
 <20220503184831.78705-2-p.raghav@samsung.com> <20220503205202.GA9567@lst.de>
 <CA+1E3rKe6G8UC9Pzkm4Wbu50X=TT5tise8g6umduhj1eTbN0+w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+1E3rKe6G8UC9Pzkm4Wbu50X=TT5tise8g6umduhj1eTbN0+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/4/22 9:12 AM, Kanchan Joshi wrote:
>> @@ -64,16 +63,19 @@ struct io_uring_sqe {
>>                 __u32   file_index;
>>         };
>>         union {
>> -               __u64   addr3;
>> -               __u64   cmd;
>> +               struct {
>> +                       __u64   addr3;
>> +                       __u64   __pad2[1];
>> +               } small;
> 
> Thinking if this can cause any issue for existing users of addr3, i.e.
> in the userspace side? Since it needs to access this field with
> small.addr3.
> Jens - is xattr infra already frozen?

It's not, as it's not upstream yet. But I don't think we need to change
it, just make the two structs unnamed instead. That also avoids awkward
small/big prefixes.

-- 
Jens Axboe

