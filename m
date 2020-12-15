Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102992DA54E
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 02:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgLOBHy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 20:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbgLOBHr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 20:07:47 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD80C061793;
        Mon, 14 Dec 2020 17:07:07 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id q18so10685544wrn.1;
        Mon, 14 Dec 2020 17:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k+K/DZUEOzK/FQdjk7VqHxa5bhLpoT0KZ6XUenKr/m4=;
        b=nuP+UqiRHhLGz4gGtD2Vo5H7UxvUsullWHNiG0+Kgvw1dG6LKHf+qha3LGG6jOtBDI
         4U9aD7comb9UXrFPzF6lAJX5elYArM3OsMiTFHc86CaRljL9RrCSWwIGghcXTwtvs5Gt
         gyOyoTMZypF/zeH2AOpJ/wxGyxTM9wxMpel3S34IEFkeG6zQOfg7RuLYtxZNs0jPaHJS
         bjveKb9dn7K4EBEVqDqod0Ov6mVUQIwYZ4/0s1kwImyfEHya+SKmsYXobZzta/SJgB7c
         Dl1kHsLdcsvCznY9YSt8GnEUJDCm6mv6r3o7TYkcAf+Wep55ktjJ/QZG181UDIS8vWdk
         PwJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=k+K/DZUEOzK/FQdjk7VqHxa5bhLpoT0KZ6XUenKr/m4=;
        b=r2CCORBu6HjmQ6yJUT/3DLo0jQ/rVTzXcGGylfUJHj4KaXnZpEGb+M5J+NMq1RI6t3
         hB1HrDHu/zX9rj5oPL9YsYxDWNPPd1m3WuXCT8J19GVOQsJy66+7F1r3lwjz80EszVZt
         Xe2DN2WBI58hPua2OcvEKbwTCche2zd9ZncNmDDUQ0uMjAaXNy8A+ypdI0bfqaE3nIIQ
         I07vOgWdL+i6v+o/iknYJoU5YslBZnoWXXiRE8ZrmlqoQVoQfCwjJYgUOQC9vBpmTLUV
         NEVs49RmeLypTlTqefHirgr6ePXFBEaHVcnfciArlX21e87I6Bt5GbIHBADN/jpsLH2b
         Fd7Q==
X-Gm-Message-State: AOAM531mPY/hq/JEZdyQ6x+P24ee4DPtncVRQbSUoe+p7+YRuIeYNTJO
        Ym0yFwEXiorJJbRvtMNLSwr90VmOfVer3/Oi
X-Google-Smtp-Source: ABdhPJzNAJ69SYxc2+3AnYnnzUZLzrBdhFYCN0Eo2OWt0+vefWkjttQl02GVRddyR0PVFYsl+4G9ng==
X-Received: by 2002:adf:f684:: with SMTP id v4mr32245705wrp.387.1607994425766;
        Mon, 14 Dec 2020 17:07:05 -0800 (PST)
Received: from [192.168.8.128] ([85.255.232.163])
        by smtp.gmail.com with ESMTPSA id k10sm31006061wrq.38.2020.12.14.17.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 17:07:04 -0800 (PST)
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1607976425.git.asml.silence@gmail.com>
 <1d3cf86668e44b3a3d35b5dbe759a086a157e434.1607976425.git.asml.silence@gmail.com>
 <20201215005659.GF632069@dread.disaster.area>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v1 4/6] block/psi: remove PSI annotations from direct IO
Message-ID: <e8adf941-9901-b54c-d7a0-b785923558fb@gmail.com>
Date:   Tue, 15 Dec 2020 01:03:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201215005659.GF632069@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/12/2020 00:56, Dave Chinner wrote:
> On Tue, Dec 15, 2020 at 12:20:23AM +0000, Pavel Begunkov wrote:
>> As reported, we must not do pressure stall information accounting for
>> direct IO, because otherwise it tells that it's thrashing a page when
>> actually doing IO on hot data.
>>
>> Apparently, bio_iov_iter_get_pages() is used only by paths doing direct
>> IO, so just make it avoid setting BIO_WORKINGSET, it also saves us CPU
>> cycles on doing that. For fs/direct-io.c just clear the flag before
>> submit_bio(), it's not of much concern performance-wise.
>>
>> Reported-by: Christoph Hellwig <hch@infradead.org>
>> Suggested-by: Christoph Hellwig <hch@infradead.org>
>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  block/bio.c    | 25 ++++++++++++++++---------
>>  fs/direct-io.c |  2 ++
>>  2 files changed, 18 insertions(+), 9 deletions(-)
> .....
>> @@ -1099,6 +1103,9 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
>>   * fit into the bio, or are requested in @iter, whatever is smaller. If
>>   * MM encounters an error pinning the requested pages, it stops. Error
>>   * is returned only if 0 pages could be pinned.
>> + *
>> + * It also doesn't set BIO_WORKINGSET, so is intended for direct IO. If used
>> + * otherwise the caller is responsible to do that to keep PSI happy.
>>   */
>>  int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>>  {
>> diff --git a/fs/direct-io.c b/fs/direct-io.c
>> index d53fa92a1ab6..914a7f600ecd 100644
>> --- a/fs/direct-io.c
>> +++ b/fs/direct-io.c
>> @@ -426,6 +426,8 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
>>  	unsigned long flags;
>>  
>>  	bio->bi_private = dio;
>> +	/* PSI is only for paging IO */
>> +	bio_clear_flag(bio, BIO_WORKINGSET);
> 
> Why only do this for the old direct IO path? Why isn't this
> necessary for the iomap DIO path?

It's in the description. In short, block and iomap dio use
bio_iov_iter_get_pages(), which with this patch doesn't use
[__]bio_add_page() and so doesn't set the flag. 

-- 
Pavel Begunkov
