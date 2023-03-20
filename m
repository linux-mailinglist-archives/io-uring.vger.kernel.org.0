Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEAEA6C1DAC
	for <lists+io-uring@lfdr.de>; Mon, 20 Mar 2023 18:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbjCTRVh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 13:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbjCTRVF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 13:21:05 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9511634C03
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 10:17:01 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id h2so2523867iow.0
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 10:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679332603; x=1681924603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AFbCUolBatTymQNgJp0wJPKSHgjza09h9Rdg1vRQ8dQ=;
        b=gPY90wHag5Nnr5j+QO3RXOqEIGdIIcl4SDuDDHILEF8mp8u4Z2NyhcOiz1SSoXkA1F
         vo6JHV50H1231KyGblXMhlAN6feDEBhRFpZSf7vgjMdM+jqsVguDpJytvpZsvWzkBX5h
         QaJOIY88/H2RErsl9TSBuI/4mrNGW08zhPsMIbLus+LU9t1a4zWnOCT/PFQPNZyXNQW1
         VixrQgczflJ0c3+ImdK+axHWuR4yZBuexQMT9unb5+eLBrCaHIdqHW2U16aS9BvCXJKf
         dnrYUU81UStdNN+FMMgSEwotmRXmS6Ge2zg6D5JYlwsXPBGJ6nB8wPFDEgngWmuHeXga
         JMBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679332603; x=1681924603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AFbCUolBatTymQNgJp0wJPKSHgjza09h9Rdg1vRQ8dQ=;
        b=QC3mID/m2ns9vUJBVKgpxczthZifU16b6MHNJ8gIYPQowZby3HyTYiOKFNlaWE0N1G
         +B0fcIAE9XqZ/54G63n14YBAuYcdlKm/VIEfQvix7NvoaAcNHLf+J1Lb2Y8PVhetM4aD
         p72fxS3d4WnLWzHECEYRTnYDZ7JSIzDJh90aSQtds90tO6XfB6klYrOyXJp4gYAUOoc5
         QwXDeXtVZGSM1YL2X5MEiEHhejhYJt0IV3E/r945gOxLXxe1VvV3d/u6/wg0AnPQl2x8
         vagYfqahObbPjip6d7HtmLtMSXVu4P4831rZQHxyJGUJs631JWTQgEz8OP0bkrO8lDtq
         gK3w==
X-Gm-Message-State: AO0yUKVwQBbJSUtuYpKz5ls8YsXiyVxvGBNH8dRfQ8qtsZbo7bVw2UdX
        q3DdwoOnGu7zFSkt2Cg1sJEgwA==
X-Google-Smtp-Source: AK7set/S5YoRkSon5TRgMJ8/iDveOb13i/31OKu3EHFKuusNZSdAgSOCjWAjwROE2tV0eiHnRtlJvw==
X-Received: by 2002:a05:6602:2d82:b0:752:dcbc:9f12 with SMTP id k2-20020a0566022d8200b00752dcbc9f12mr248164iow.2.1679332602929;
        Mon, 20 Mar 2023 10:16:42 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q15-20020a6bf20f000000b00704608527d1sm3030576ioh.37.2023.03.20.10.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 10:16:42 -0700 (PDT)
Message-ID: <5aecde5b-c709-c8b3-28cd-5a361bd492b9@kernel.dk>
Date:   Mon, 20 Mar 2023 11:16:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] blk-mq: remove hybrid polling
To:     Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Keith Busch <kbusch@kernel.org>
References: <20230320161205.1714865-1-kbusch@meta.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230320161205.1714865-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index f1fce1c7fa44b..c6c231f3d0f10 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -408,36 +408,7 @@ queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
>  
>  static ssize_t queue_poll_delay_show(struct request_queue *q, char *page)
>  {
> -	int val;
> -
> -	if (q->poll_nsec == BLK_MQ_POLL_CLASSIC)
> -		val = BLK_MQ_POLL_CLASSIC;
> -	else
> -		val = q->poll_nsec / 1000;
> -
> -	return sprintf(page, "%d\n", val);
> -}
> -
> -static ssize_t queue_poll_delay_store(struct request_queue *q, const char *page,
> -				size_t count)
> -{
> -	int err, val;
> -
> -	if (!q->mq_ops || !q->mq_ops->poll)
> -		return -EINVAL;
> -
> -	err = kstrtoint(page, 10, &val);
> -	if (err < 0)
> -		return err;
> -
> -	if (val == BLK_MQ_POLL_CLASSIC)
> -		q->poll_nsec = BLK_MQ_POLL_CLASSIC;
> -	else if (val >= 0)
> -		q->poll_nsec = val * 1000;
> -	else
> -		return -EINVAL;
> -
> -	return count;
> +	return sprintf(page, "%d\n", -1);
>  }

Do we want to retain the _store setting here to avoid breaking anything?
Yes, it won't do anything, but it's not like hybrid or classic poll had
differences that would be user visible (outside of perhaps using
different amounts of CPU).

Apart from that, not any major comments. Killing all of this (now)
unused code is great! Thanks for doing it.

-- 
Jens Axboe


