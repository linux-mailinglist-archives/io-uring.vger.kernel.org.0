Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D1F6E8271
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 22:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDSUPx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 16:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjDSUPx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 16:15:53 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BEBDD
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 13:15:52 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a7111e0696so707625ad.1
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 13:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681935351; x=1684527351;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uEZv1+Sjy8aPaSMjtOnGV5vUYFV+uw4lXf3C6WgeEKE=;
        b=kqmbcIMcU4sefLMfBO5v9IBowedzR2UPkBRN2Gq1QQgY4Y/4fl2cWlTgxRnT3tn90r
         Hk70xLyL/z9yAbzvABd8SjQeVaX23dgCpELjiH4Bpwh+zTOAKdhHR2+BRXe48JsUmv3D
         Phs/qFbZDTIG2/TpbtXAsxTbJ12fcLZTusv6B4dKMhI0CaLjKYdlR4N/Dy+JphMT8M2/
         ZW0DToCtqFmCpq2BDM2pwjxeidP2NslWcUpx/idDtTJx3yn8L2HnRHDdEEwcc73vE0TW
         KXxw8Z9EIdKr492C9nRvzfKxfcF71FqMNunb3J9asiO6L7WjQFXwxi/F6y+tr+/+J6LZ
         AGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681935351; x=1684527351;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uEZv1+Sjy8aPaSMjtOnGV5vUYFV+uw4lXf3C6WgeEKE=;
        b=TTIxuoDWb1L1VtcOgfKJtCJNGhgeuPcgr7c+EywnJXa36w/bvKaHgRkLznZeU6swOv
         1/P/9HfNwzqRNIAaWnST2vxxblegpqtPktnXPWG4MLSCS5U2X+W4NHLoznmCqR9mHSjf
         0tvAGtQwBZyXno7d2/NDPZfyvAMMy0k6UkM7m1iI8xCxWBgyvL/DoZAzIrsD9bWYIW4r
         m13sMFQPUw/mJzinVYuTPgubKDfod1SRvcmwsDfROiy+2cvbDi+8w8vkg4fGc+X2dQwO
         oqN2JEJ5xzt8jfkL4y+ic+55I3puL500e986iGWT4xSRcKW0NDeBUPyUSUE1Mk0eYUpq
         RDCg==
X-Gm-Message-State: AAQBX9cMV3NKSTQOF6DOa9k33iFuMKDMsFDlEnYSnjgmogzGdkIS9MHI
        nwv0GJ0yKcO+2SzAo1rFqmC7tw==
X-Google-Smtp-Source: AKy350YabKeWFagAMyyryCcLxhkrECa4iIsx2RGdrmHhx+B7W3FNw6MnNvf/b3L2CGRQg/VOxFkOVg==
X-Received: by 2002:a17:902:e751:b0:1a6:3ba2:c896 with SMTP id p17-20020a170902e75100b001a63ba2c896mr23159358plf.3.1681935351470;
        Wed, 19 Apr 2023 13:15:51 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902bd4500b001a19cf1b37esm11831037plx.40.2023.04.19.13.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 13:15:51 -0700 (PDT)
Message-ID: <567b593e-2ad0-9bec-4e6f-4bbb3301524c@kernel.dk>
Date:   Wed, 19 Apr 2023 14:15:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
 <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
 <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
 <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
 <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
 <ZEAxhHx/4Ql6AMt2@casper.infradead.org> <ZEAx90C2lDMJIux1@nvidia.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZEAx90C2lDMJIux1@nvidia.com>
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

On 4/19/23 12:24?PM, Jason Gunthorpe wrote:
> On Wed, Apr 19, 2023 at 07:23:00PM +0100, Matthew Wilcox wrote:
>> On Wed, Apr 19, 2023 at 07:18:26PM +0100, Lorenzo Stoakes wrote:
>>> So even if I did the FOLL_ALLOW_BROKEN_FILE_MAPPING patch series first, I
>>> would still need to come along and delete a bunch of your code
>>> afterwards. And unfortunately Pavel's recent change which insists on not
>>> having different vm_file's across VMAs for the buffer would have to be
>>> reverted so I expect it might not be entirely without discussion.
>>
>> I don't even understand why Pavel wanted to make this change.  The
>> commit log really doesn't say.
>>
>> commit edd478269640
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Wed Feb 22 14:36:48 2023 +0000
>>
>>     io_uring/rsrc: disallow multi-source reg buffers
>>
>>     If two or more mappings go back to back to each other they can be passed
>>     into io_uring to be registered as a single registered buffer. That would
>>     even work if mappings came from different sources, e.g. it's possible to
>>     mix in this way anon pages and pages from shmem or hugetlb. That is not
>>     a problem but it'd rather be less prone if we forbid such mixing.
>>
>>     Cc: <stable@vger.kernel.org>
>>     Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> It even says "That is not a problem"!  So why was this patch merged
>> if it's not fixing a problem?
>>
>> It's now standing in the way of an actual cleanup.  So why don't we
>> revert it?  There must be more to it than this ...
> 
> https://lore.kernel.org/all/61ded378-51a8-1dcb-b631-fda1903248a9@gmail.com/

Let's just kill that patch that, I can add a revert for 6.4. I had
forgotten about that patch and guess I didn't realize that most of the
issue do in fact just stem from that.

-- 
Jens Axboe

