Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E106E7FF5
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 18:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbjDSQ7b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 12:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjDSQ7a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 12:59:30 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6836726B6
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:59:29 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1a67189a64fso398745ad.0
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681923569; x=1684515569;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GZA/Y2Xcvpydl47ecxb70c5FYkq2jeab6dGCHqHNDLM=;
        b=XzJ1HS3/fHRLsOUi5jteCYlLIRtuVLu997uZN/qGqPd6zMDOa8KMT5WStPJuEf/gs0
         Wpa4XHqd48KpIIcr4U5Q1ETw4ixS2x4TNAUBa5uVY/dWirkK9vkjEpk2CUyL7jpJ8cFf
         0HxDu50X8eO7z2xnWVhyls5YoqwZVE3mEKSKA6Y5ZciI9xYo9VPGInsWwK6WfgXFBj3N
         xq2SPGIxhEKidNtEh/iKm/wSnFQ3wA08rI9A64MtAN0M1uIORdfkkml8Afr/YRt8W0Gl
         E7VuMGz1QJzcqy4O0jkeMge2wNTWvSZKBa9e7JomIbf0R2Q3T6pPbOlfCJSMYXDojjKU
         owRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681923569; x=1684515569;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GZA/Y2Xcvpydl47ecxb70c5FYkq2jeab6dGCHqHNDLM=;
        b=TAu8rH+mol8h9vatOjsCBCUB7NbQwsMTS85Bf+VNnjaoglUY8aU9tIx3poCL0Adp6f
         htc+QFK2pwsoh+LpsifEpflJ27nzhsOP9g+p+dEwHLo3k6t/SnE2uhdNMbnza0hwUsip
         7JmqG51OQdk3k4d1KfS1Jg0d4yN1v+7Ki/x6rM5Yq9TNSpdGef9TB+aS3QGaYhr3bYZy
         fhHjWxazS/OvyGsqn+F1Vj6VLMeq+iHNdtVi+gWm8LKhcGIJaFNAabEU8t4TknZycnQv
         LhVtk6jSFGCDML4BKM8GWASNG1v3Z2IrgvWv3j3ACRjYhANYgeUGAoVM9OPqKt0PmUeS
         ki6A==
X-Gm-Message-State: AAQBX9fe1l791SX5EcT5VaP/DXMId0Ale64eL5F1BcEQ2VQUOrfd6ZOV
        XLJDMyAxtAjn2QWEtUNsFUXsbw==
X-Google-Smtp-Source: AKy350aamir0cPVa7O53h6wHMNxFh+fRJJlOQij5wyUIks3kjZ3NbBXKg3I5OtxJn3qCySkm+Depxw==
X-Received: by 2002:a17:903:11c9:b0:1a6:6bdb:b548 with SMTP id q9-20020a17090311c900b001a66bdbb548mr22281935plh.1.1681923568889;
        Wed, 19 Apr 2023 09:59:28 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g7-20020a170902740700b001a0448731c2sm11655079pll.47.2023.04.19.09.59.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 09:59:28 -0700 (PDT)
Message-ID: <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
Date:   Wed, 19 Apr 2023 10:59:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
In-Reply-To: <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/23 10:35?AM, Jens Axboe wrote:
> On 4/18/23 9:49?AM, Lorenzo Stoakes wrote:
>> We are shortly to remove pin_user_pages(), and instead perform the required
>> VMA checks ourselves. In most cases there will be a single VMA so this
>> should caues no undue impact on an already slow path.
>>
>> Doing this eliminates the one instance of vmas being used by
>> pin_user_pages().
> 
> First up, please don't just send single patches from a series. It's
> really annoying when you are trying to get the full picture. Just CC the
> whole series, so reviews don't have to look it up separately.
> 
> So when you're doing a respin for what I'll mention below and the issue
> that David found, please don't just show us patch 4+5 of the series.

I'll reply here too rather than keep some of this conversaion
out-of-band.

I don't necessarily think that making io buffer registration dumber and
less efficient by needing a separate vma lookup after the fact is a huge
deal, as I would imagine most workloads register buffers at setup time
and then don't change them. But if people do switch sets at runtime,
it's not necessarily a slow path. That said, I suspect the other bits
that we do in here, like the GUP, is going to dominate the overhead
anyway.

My main question is, why don't we just have a __pin_user_pages or
something helper that still takes the vmas argument, and drop it from
pin_user_pages() only? That'd still allow the cleanup of the other users
that don't care about the vma at all, while retaining the bundled
functionality for the case/cases that do? That would avoid needing
explicit vma iteration in io_uring.

-- 
Jens Axboe

