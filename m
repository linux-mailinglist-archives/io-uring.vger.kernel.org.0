Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C2950FDB4
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 14:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbiDZM45 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 08:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbiDZM4z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 08:56:55 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961E217D48D
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 05:53:48 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id s14so30059075plk.8
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 05:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XGZuj6mfM0WiW7dFClmKDN/m8Wp8N5NVkKRnuNf5FHI=;
        b=jUW+XerKm+gckNXcPR28kn671NB9irnirM7ke2RCRs49GzhQfZMNn6mc3xAym1/8Gz
         XUvegXuQo6TlMheUzNqzVDwv6nolmPNKjYQ7Oo/NO+t1B2vD/fHU4sbkctaA0LE1jb/X
         OvC5Fv2iyqHlI4wNq+jvO/8WpfmflFPbGW0WNOwgo3EOocCKMbOy3o0hoo5x4ilJ//Jn
         L8qNyv32alr3Q/9go11ew4oiij4atIIxXNVf7vDEWMeuOFaoir54dM8WAYH/2gU4wL5+
         15JnMsYugKBlY7Ol0I4KmNdySqkmR/ojxWf0uOsQGQlQ2NimozxK5atRqr7AdvTjGvB4
         zLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XGZuj6mfM0WiW7dFClmKDN/m8Wp8N5NVkKRnuNf5FHI=;
        b=RcThiYSbnmmP7jM6RiIt0aFVrUQjaaQU+5esZPmrL+fGAJ51qWGQ90+4qV15Vw7vYx
         oAgJrI2LxL+UU/53QsYE2Snu3mErfaB5Qb7Phc+6qC5Zszu+00y2F4+n6g7ZTx1fIdfo
         RWUg1xWHFK7iLKLH7WI9psqpSkj+/uUUuXxubmegkTw6DanvGdyasMhR47gy78nTc/oU
         thsjyZGoQYtNzFlvgLfS6+doha7mJc810qhQRnDV/8w95vdLZE70AkOBkyXf8+Jire8B
         V8pG/sBtEmoEMu6B/imr+bm/2jGog7UHwSLuCX3mu26EUe9BV5oQ2buKB7Ik2dgS2eSk
         CLRg==
X-Gm-Message-State: AOAM533a94X1Fh3t0gwOZ5h/RlwxfK8K0cm5xIchM6K43bIcNCZlrzOu
        7Ls3f+LDuEe4cDxs2/dxq70ujg==
X-Google-Smtp-Source: ABdhPJy/WEj9zweDE/V+h2hN87dJgN2vLon9Ml/lvxLnl0k+2f2FZENIKar4FtjLlI8bpwfUnSa4ZQ==
X-Received: by 2002:a17:902:7045:b0:157:144:57c5 with SMTP id h5-20020a170902704500b00157014457c5mr23215069plt.86.1650977627984;
        Tue, 26 Apr 2022 05:53:47 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p12-20020a63ab0c000000b00381f7577a5csm12498921pgf.17.2022.04.26.05.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 05:53:47 -0700 (PDT)
Message-ID: <53b9382d-83a0-5d20-784b-3a7403713f94@kernel.dk>
Date:   Tue, 26 Apr 2022 06:53:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 08/12] io_uring: overflow processing for CQE32
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        kernel-team@fb.com
References: <20220425182530.2442911-1-shr@fb.com>
 <CGME20220425182611epcas5p2c999ed62c22300b8483c576523198c4e@epcas5p2.samsung.com>
 <20220425182530.2442911-9-shr@fb.com> <20220426062826.GC14174@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220426062826.GC14174@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/22 12:28 AM, Kanchan Joshi wrote:
> On Mon, Apr 25, 2022 at 11:25:26AM -0700, Stefan Roesch wrote:
>> This adds the overflow processing for large CQE's.
>>
>> This adds two parameters to the io_cqring_event_overflow function and
>> uses these fields to initialize the large CQE fields.
>>
>> Allocate enough space for large CQE's in the overflow structue. If no
>> large CQE's are used, the size of the allocation is unchanged.
>>
>> The cqe field can have a different size depending if its a large
>> CQE or not. To be able to allocate different sizes, the two fields
>> in the structure are re-ordered.
>>
>> Co-developed-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>> fs/io_uring.c | 31 ++++++++++++++++++++++---------
>> 1 file changed, 22 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 68b61d2b356d..3630671325ea 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -220,8 +220,8 @@ struct io_mapped_ubuf {
>> struct io_ring_ctx;
>>
>> struct io_overflow_cqe {
>> -    struct io_uring_cqe cqe;
>>     struct list_head list;
>> +    struct io_uring_cqe cqe;
>> };
>>
>> struct io_fixed_file {
>> @@ -2017,10 +2017,14 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
>> static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>> {
>>     bool all_flushed, posted;
>> +    size_t cqe_size = sizeof(struct io_uring_cqe);
>>
>>     if (!force && __io_cqring_events(ctx) == ctx->cq_entries)
>>         return false;
>>
>> +    if (ctx->flags & IORING_SETUP_CQE32)
>> +        cqe_size <<= 1;
>> +
>>     posted = false;
>>     spin_lock(&ctx->completion_lock);
>>     while (!list_empty(&ctx->cq_overflow_list)) {
>> @@ -2032,7 +2036,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>>         ocqe = list_first_entry(&ctx->cq_overflow_list,
>>                     struct io_overflow_cqe, list);
>>         if (cqe)
>> -            memcpy(cqe, &ocqe->cqe, sizeof(*cqe));
>> +            memcpy(cqe, &ocqe->cqe, cqe_size);
> 
> Maybe a nit, but if we do it this way -
> memcpy(cqe, &ocqe->cqe,     sizeof(*cqe) << (ctx->flags & IORING_SETUP_CQE32));

Unless you make that:

memcpy(cqe, &ocqe->cqe, sizeof(*cqe) << !!(ctx->flags & IORING_SETUP_CQE32));

that will end in tears, and that just makes it less readable. So I don't
think that's a good idea at all.

-- 
Jens Axboe

