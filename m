Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A355371C5
	for <lists+io-uring@lfdr.de>; Sun, 29 May 2022 18:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiE2QZn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 May 2022 12:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiE2QZl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 May 2022 12:25:41 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57EF18383
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 09:25:39 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id m14-20020a17090a414e00b001df77d29587so11329210pjg.2
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 09:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vq6MyDcKhkhvgsDs22DEU8RtmaDsg4rSOA8ZDSZIVGU=;
        b=TuZ9aXjfzG3D9E6Blnqai6/L8hfJ9P1iWecHKEOtSzzE6t8FF1VQqkFpyr4PjOyJ5P
         NelhMeJlYCboCYqgMSYjDL5QFEdwmh3wYNkNoaNCGYYyBJ8zQK3WiLFZKI5Jt4mCsEf4
         M5upsG7iP6oy2p5q0w2jONiiLhkppzSskKerDcDiiocnBt1y9ioeMuPOwZm1QH4pTMzW
         oOts1OIw4hNtQiE12shfRSBflPiz5UB/DXdXofbbwKfmK2YqdB0cZ1zsCyrVmdX9UFjU
         2XKm+399v3qr1DVjVUjPr3UDZd2Mn/AUk7V757ybUg4dqv7MVSlAD4KsLtRGJriQlMsD
         vBIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vq6MyDcKhkhvgsDs22DEU8RtmaDsg4rSOA8ZDSZIVGU=;
        b=1Z1IEkJUgTtqOl5lK1PH8/dHBJ/nTS7+vK+19nxEFzwXo5SuVIbgusa5m4Xalo9WYg
         VW2cJHsHvaV8AgMhyZO6piR49o7PY8bksanf6TsBp4aeRyTVkWiQvLC/gX3XuhOS+7xr
         pVjkAkNWgkaNamSMWY4N6V6I0vHeUCbSPlcHyiVVmDBdVUTmaYZmnwMZ4JWZG1W3TZzp
         8tfZZGxijk3NMCTjMNH8fZ+0Jnzu1m2ClsYyuBAQrE5e0ixFjvi9i8KSAcc+WW0sYtPz
         AdEGmT0BZFjCjcm6SHCgbdicN6XvxsYzFI4cqwZdmr8qUV9F6Z6dCHbFwFqHlQFQ8pp2
         p/hg==
X-Gm-Message-State: AOAM5329DE4w2khyd1HORyzu8+abfOMQlWDK0V0rNWn44VUoM91LDi6r
        ++Z2NbnLfOFlc3EmihD4SPf5D62zQfW2kg==
X-Google-Smtp-Source: ABdhPJwkzD4CAPkj+rQW9+MX6xoiQdONdPj9OQnJ748kMam6wMO84ZVKp13LKjo/LcETQwzY983KuA==
X-Received: by 2002:a17:902:bf06:b0:14d:8c72:96c6 with SMTP id bi6-20020a170902bf0600b0014d8c7296c6mr52475328plb.156.1653841539208;
        Sun, 29 May 2022 09:25:39 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m15-20020aa7900f000000b00518ebba4462sm7081143pfo.119.2022.05.29.09.25.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 May 2022 09:25:38 -0700 (PDT)
Message-ID: <37c50986-8a47-5eb4-d416-cbbfd54497b0@kernel.dk>
Date:   Sun, 29 May 2022 10:25:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/2] io_uring: switch cancel_hash to use per list spinlock
Content-Language: en-US
To:     Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20220529162000.32489-1-haoxu.linux@icloud.com>
 <20220529162000.32489-3-haoxu.linux@icloud.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220529162000.32489-3-haoxu.linux@icloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/29/22 10:20 AM, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> From: Hao Xu <howeyxu@tencent.com>
> 
> Use per list lock for cancel_hash, this removes some completion lock
> invocation and remove contension between different cancel_hash entries

Interesting, do you have any numbers on this?

Also, I'd make a hash bucket struct:

struct io_hash_bucket {
	spinlock_t lock;
	struct hlist_head list;
};

rather than two separate structs, that'll have nicer memory locality too
and should further improve it. Could be done as a prep patch with the
old locking in place, making the end patch doing the per-bucket lock
simpler as well.

Hmm?

-- 
Jens Axboe

