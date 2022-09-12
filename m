Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D564D5B5F2D
	for <lists+io-uring@lfdr.de>; Mon, 12 Sep 2022 19:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiILRWI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Sep 2022 13:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiILRWH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Sep 2022 13:22:07 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25F41C907
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 10:22:05 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id bq9so16490451wrb.4
        for <io-uring@vger.kernel.org>; Mon, 12 Sep 2022 10:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=TotLyiE56zuju2bIR0/IixXlh9n/Os8RM6b6LuIDxo0=;
        b=pLDRwI453Kf9TuMk6M3OM00Aa6W4kFDR5Nh5GDnkOb/KJM+O3oscdnAylaxfCA7TLY
         cRPQoXuihM3MrPSH3vra0min4DvaT4rb37+2kOxmFZ4paASdIsowpMpO2FgZqQ2uxA/N
         sl+r+5B02VS8qTKDFYFMmuKynZ/1bTfXEPdgtqcPMzND/uPETw384w04ZCR0JrN1NPt9
         g0ZRLPBd/jkMMIeibflUkpXxvf2/CRnutSgDI5RNHFbQzNlo7RVGw39ULai6++zfkJIn
         q05kPIJQpv506UwxU2o9JnyVX3BQpuRDjMIyDDTKTJjTgefInHuDU5witL66eWXUz0Sn
         oKvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=TotLyiE56zuju2bIR0/IixXlh9n/Os8RM6b6LuIDxo0=;
        b=I461L5bU2Mm2O/pQKKIru/zuhwGePm/1jBIFC24W09fbQpirfdLUDQQVMxqem0YH8h
         fhHfQVUCg5+0qZeLw5bIWp1D/7ZnhCzh6Lzk4bTImN+9oPaZl5QGl2h4cc0j3885tfhk
         /Tz2XeYlpq78hS9NJell0dPKTY66jNFhvfea2snnFM6sqTKYJSpuXpn3E+FYWps+Zrc+
         E7i+haVgBqEFSbVn6Eo5wtL3QgPwmoXkEunrZEaHxrPrb0eJp/J7a1zlEYxSRqb7CQBA
         qoBbZaQfKiuJS1aOLu96Mn96ZAyK1SNfTBkhzbxp/wcl7CwmOBmJgkxKwwln89oXsmZp
         4slA==
X-Gm-Message-State: ACgBeo3gzPWZAu+ilqUX3URraQoPknSJ36zp01qC2zDL2sFOnYdqum1b
        j50OhnUeEE0FN0rrm6t162ANag==
X-Google-Smtp-Source: AA6agR5+RLpYhQ1H+qYkMBJdVwUlHyuBw4wpuglz4UxjSk/g11oXBbZ62RqU2DEu9kdu/bv3Yq18zQ==
X-Received: by 2002:a05:6000:1687:b0:22a:3516:4f98 with SMTP id y7-20020a056000168700b0022a35164f98mr11705056wrd.525.1663003324247;
        Mon, 12 Sep 2022 10:22:04 -0700 (PDT)
Received: from [172.16.38.121] ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id l5-20020a05600c1d0500b003b477532e66sm10244180wms.2.2022.09.12.10.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 10:22:03 -0700 (PDT)
Message-ID: <601dac34-c3e3-5e86-852f-aaa489226733@kernel.dk>
Date:   Mon, 12 Sep 2022 11:22:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v1] block: blk_queue_enter() / __bio_queue_enter() must
 return -EAGAIN for nowait
To:     Bart Van Assche <bvanassche@acm.org>, Stefan Roesch <shr@fb.com>,
        kernel-team@fb.com, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org
References: <20220912165325.2858746-1-shr@fb.com>
 <24aad185-fc3e-420b-b638-227c4564bcf8@acm.org>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <24aad185-fc3e-420b-b638-227c4564bcf8@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/12/22 11:14 AM, Bart Van Assche wrote:
> On 9/12/22 09:53, Stefan Roesch wrote:
>> Today blk_queue_enter() and __bio_queue_enter() return -EBUSY for the
>> nowait code path. This is not correct: they should return -EAGAIN
>> instead.
> 
> Why is this considered incorrect? Please explain.
> 
> Since this patch also affects other code, e.g. NVMe pass-through, can
> this patch break existing user space code by changing the value
> returned to user space?

It is currently broken because we always return EAGAIN/EWOULDBLOCK for
these cases, if a non-block flag is set of some sort. I strongly suspect
that nobody has really being doing non-blocking IO to devices before
io_uring made it a lot more common. EAGAIN means "try again later, or
without nonblock said".

We should be consistent here.

-- 
Jens Axboe
