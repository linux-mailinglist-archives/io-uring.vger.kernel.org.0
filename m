Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D79F6BB5BD
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 15:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbjCOOQ5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 10:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbjCOOQm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 10:16:42 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3A625B87
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 07:16:22 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id o14so2321570ioa.3
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 07:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678889781;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LUr6Z/8eVKfwqMAALi/Nq7GM0PMlYZHl9znx9hFSWjM=;
        b=NJuoGSTtVhz9FRn0ds9YLYb/zkKXmMoHej1HFmJ68Vj4DHe/UrwzfhHGh19RBbgsLv
         p9G1Hzs6uJpf3WW42yECxFCi/WFFnICxpL0iYZc1ExEppbUlTD3Nrlr/M8aBspZWgOHs
         YZIpOmEmO5rIAx3pt3qx4504XOE5tNpowqNF/eYpnjBHBVIwRL7hSSe1SKotUQvnr5HK
         sH702rXQb/mh1MAuax4Rx2hLEjjGejcWFPyfm/a6AKmqUMQ+3DAEm/SeUAKEkd0Aeva1
         w5JY40XOZr3xCUEKTyvPuC8YpvXRe5MyqGznnMCrlVGHJTRsLXBPd5NoU5oQ7s03c1Eu
         zJ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678889781;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LUr6Z/8eVKfwqMAALi/Nq7GM0PMlYZHl9znx9hFSWjM=;
        b=bldPYclbmRq0CQfcHbqOZ8qkZP7UbGrswQNgtUhaxpJCIdXqCwFYIHfh/AB6DuJt7U
         JUr0zzmeoXQ3hwDd0OGuFikohn8HOO3r7jBdi8lbYiTMnl5GWZ+a1Yyig9e7BoQquObG
         vEk7D3nU3kQfHEGe54YrW2QiKSC+NHbfH2BwqaEjqawgErd4jlxlV6BmgBAuHd/XN0hM
         350yBAqKR99kzrEQaifFrOyuNuMhdfkDgDIAm7qvAuhbTZQtVb2fMiuZIYBu0QjrOOId
         FcHBM51m0x7T+1DO+nsvagb5Ggx2tXUfZ7c81sDYXbnWubUgmwRU8sYh3sIk0xfTaKKg
         57iw==
X-Gm-Message-State: AO0yUKV6Uij5roDYDkB6CvS9mgLTFpwG7/Hp41GfG5osFaw9nWFizXHe
        5dRBGnkirZ7tBQJZWc3tC87eeX32vXflXl0AW5UcXg==
X-Google-Smtp-Source: AK7set8ksOR6hwFFHfW/ngnN7iiN0RpsWWGboYgCAZHSy6wmeciNhN5f05fOmv9Dr5fx41KCZse6KA==
X-Received: by 2002:a05:6602:368a:b0:74c:de17:fa3 with SMTP id bf10-20020a056602368a00b0074cde170fa3mr9760617iob.0.1678889781515;
        Wed, 15 Mar 2023 07:16:21 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g21-20020a02bb95000000b004051a7ef7f3sm1655405jan.71.2023.03.15.07.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 07:16:20 -0700 (PDT)
Message-ID: <38781e4c-29b7-2fbc-44a9-f365189f5381@kernel.dk>
Date:   Wed, 15 Mar 2023 08:16:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 2/3] pipe: enable handling of IOCB_NOWAIT
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
References: <20230314154203.181070-1-axboe@kernel.dk>
 <20230314154203.181070-3-axboe@kernel.dk>
 <20230315082321.47mw5essznhejv7z@wittgenstein>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230315082321.47mw5essznhejv7z@wittgenstein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/15/23 2:23 AM, Christian Brauner wrote:
> On Tue, Mar 14, 2023 at 09:42:02AM -0600, Jens Axboe wrote:
>> In preparation for enabling FMODE_NOWAIT for pipes, ensure that the read
>> and write path handle it correctly. This includes the pipe locking,
>> page allocation for writes, and confirming pipe buffers.
>>
>> Acked-by: Dave Chinner <dchinner@redhat.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
> 
> Looks good,
> Reviewed-by: Christian Brauner <brauner@kernel.org>

Thanks for the review, I'll add that. Are you OK with me carrying
these patches, or do you want to stage them for 6.4?

-- 
Jens Axboe


