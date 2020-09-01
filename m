Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCD7258FC3
	for <lists+io-uring@lfdr.de>; Tue,  1 Sep 2020 16:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgIAOEH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Sep 2020 10:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbgIAOCs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Sep 2020 10:02:48 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A09C061245
        for <io-uring@vger.kernel.org>; Tue,  1 Sep 2020 07:02:35 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id v196so173355pfc.1
        for <io-uring@vger.kernel.org>; Tue, 01 Sep 2020 07:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wgKJRdxrENyKgbDWy5by6NGP3hpksrhJ23fBZKvrI2s=;
        b=i4XrRkysiK1ue0Yn7g8d27VrXCizc66C5zu3KEk1FHo0FjaLqup7jZlavzSV/4wYSi
         +8l3XWVHYoHXbJIjgj0+hDEuzFn4Hi9qH2ZEL1T+gFEKKIIP7r4lifr6kjk9N3m2K++b
         ILAmofWadahiW33YuEkNLxRTNn2zonr3H3DHxdzfmSMuyyyJrtuE4vyvdCT0CpPy2xTm
         4TW7aBVZxgJmng72hfOx9gJ7lWoQhp9dkDhQabrYiuouehEkKqu1e81KIwZqNWEMUsEp
         ybVSa/dg5txtL4w+Xxxt9ioHvwFOF9tws21OS397Mc+wJyZLMVRemjwXDoJa3lr5kF/9
         OZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wgKJRdxrENyKgbDWy5by6NGP3hpksrhJ23fBZKvrI2s=;
        b=KYA6qMxF9Rj1kPBsz5n0B0IPsZLgXkWowutDh674ZI03ItllLnXj/rLgvVjZz01xcy
         g09b5fnny3cq1fjcXIYB1i+Q7IcsKLz2P/bns6AAYvlawNYAlwXWPU226c20NRri3tZd
         /oO0VZUFRl6naKS2BJPLInnxRsti/CwRgtuco5xES169nduInuan38KleA2U91Fe1XNK
         aHG7ZC/iHrCnZkZZ/EbetST7BF0vi3cXuCXdfnyAm1Efg1modnkDowISXvl1r4++Jc2N
         Hl4+qa2XbUfnBn2uA6iql+7wbMxOSQdgx0V3KSU6zYGPQke7qA4Obap8sluDAWB6D8tg
         s50w==
X-Gm-Message-State: AOAM532x752/kC4oEEZKuJ9QtNsZILKX2nQSiEeKM2zZLbWQpq2IX/XO
        F7V56hXkKkXrMZPVcwuLjqihjv0sQqK0vZ22
X-Google-Smtp-Source: ABdhPJy9iRU3uUKpAuhHwm5ErSe4hG3i01SYcwKObfcbnbwxHGk1Bd7zTsmsY32prUcb7LwVvd6VQQ==
X-Received: by 2002:a63:fe06:: with SMTP id p6mr1591783pgh.337.1598968954468;
        Tue, 01 Sep 2020 07:02:34 -0700 (PDT)
Received: from [192.168.1.187] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g17sm1631636pjl.30.2020.09.01.07.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 07:02:33 -0700 (PDT)
Subject: Re: Unclear documentation about IORING_OP_READ
To:     Shuveb Hussain <shuveb@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAF=AFaLzf=B28CXt0qJ0z7wXfRosqLPYQYtC-DrVogA0J_5AKw@mail.gmail.com>
 <81700e99-21cb-c338-f1f7-8019b2cb6928@kernel.dk>
 <CAF=AFaLxuUutwB94JXdRuCf0vWHNUPNeX71Pk8VpHpKML5PntQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7993aa30-4847-725d-c9ff-4a09f4c45546@kernel.dk>
Date:   Tue, 1 Sep 2020 08:02:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF=AFaLxuUutwB94JXdRuCf0vWHNUPNeX71Pk8VpHpKML5PntQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/1/20 6:51 AM, Shuveb Hussain wrote:
> Hello,
> 
>> This is intended behavior, you should consider the READV to be just
>> like preadv2() in that it takes the offset/iov/flags, and ditto on
>> the write side. READ is basically what a pread2 would be, if it
>> existed.
>>
>> That said, you can use off == -1 if IORING_FEAT_RW_CUR_POS is set
>> in the feature flags upon ring creation, and that'll use (and updated)
>> the current file offset. This works for any non-stream/pipe file
>> type.
>>
> 
> That clarifies it. Thanks, Jens.

Great! BTW, thanks for working on the io_uring(7) man page, I'm pretty
excited about that.

-- 
Jens Axboe

