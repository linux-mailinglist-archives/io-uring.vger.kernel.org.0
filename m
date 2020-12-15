Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCCD2DA57E
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 02:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgLOBTj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 20:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbgLOBTj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 20:19:39 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7D4C061793;
        Mon, 14 Dec 2020 17:18:58 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id 91so18213728wrj.7;
        Mon, 14 Dec 2020 17:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sThOrhp2Jm3ClsF9DN8GXzoj1By2BPC+ziqGGyYmU5A=;
        b=KM76NqpzcJSDKm3cruux4IlQHXvEhtmcz10NaKxb//LUYyGO1ASdDQBfEovObajuEj
         KWYqzIV1Kbzx6hOZsvXuKTicFgQ48/2MKZIbOBpycwNSXc9sbsQpSpK7kbUUhjnGkA8x
         q5kfmA+6GTt3OHmGh+AxvM15+H8404SAZWg0G7PzJZTJyTrGbB1JijfelwiPQKAImQJH
         4Znn9m2RRDbAjoLYDXFyFHBZ0AYFHXRnLqJfhYdoscLi0DFKbC7Emw8uczphtYRvp1iQ
         IMV0MSrJUAvnzYD2lq7usdNfebh7pwQ/wyUjG8o1XNECJUmYmNwPbcHsxLsdbpCdM9Ki
         0Z4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sThOrhp2Jm3ClsF9DN8GXzoj1By2BPC+ziqGGyYmU5A=;
        b=uKxmq10580MOy0NpGGIkdbKq+bRY++vEXmuwnV8JbPeY1PjppBtXaFkL/7fSq5vNAZ
         Krm5PSCXHlcPejNUI0kwzhL0p61Hou9ObIAnKlfnkQ21zI0R3edsnylDjTDjFLjjl4Bi
         tCmhLdgXDjm30ldinglxvkE6I0Ca56A6MkOq8oAv7+RO3VopdKTC2zC3NC/sZYA1oI/M
         h65tNxgeeRMwMPxVumfQ96gjXqO1uLjUrz8Dogvh++oAcK4mOtSwtYwq3T+wnEYN3m5c
         8bzy+lc5S0zFIb1DCM6aOrx7M5OZM2fDPolWzD55RlJD2HRaT+Q2lcGIxmZX1dG2k7rb
         7zfQ==
X-Gm-Message-State: AOAM531/89iuvuwn6op3AGxiN0K5rgNQE4QlCCu/FIEWWQtKND0ehDnW
        OCnvVyVOEhJFI+IFxXu/KmeYndAu4mx+dtAO
X-Google-Smtp-Source: ABdhPJyzahnkaqmwFFVkAJTKRinIOi3K9sMDapjeEStepwDn+7cr4XNXPZWg4fgfpEG/Swb/DJgePg==
X-Received: by 2002:adf:e64b:: with SMTP id b11mr31361359wrn.257.1607995137148;
        Mon, 14 Dec 2020 17:18:57 -0800 (PST)
Received: from [192.168.8.128] ([85.255.232.163])
        by smtp.gmail.com with ESMTPSA id t16sm35394801wri.42.2020.12.14.17.18.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 17:18:56 -0800 (PST)
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
 <498b34d746627e874740d8315b2924880c46dbc3.1607976425.git.asml.silence@gmail.com>
 <20201215010921.GH632069@dread.disaster.area>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v1 6/6] block/iomap: don't copy bvec for direct IO
Message-ID: <d2689b7c-7200-24cc-761c-bcbaa21c40ae@gmail.com>
Date:   Tue, 15 Dec 2020 01:15:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201215010921.GH632069@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/12/2020 01:09, Dave Chinner wrote:
> On Tue, Dec 15, 2020 at 12:20:25AM +0000, Pavel Begunkov wrote:
>> The block layer spends quite a while in blkdev_direct_IO() to copy and
>> initialise bio's bvec. However, if we've already got a bvec in the input
>> iterator it might be reused in some cases, i.e. when new
>> ITER_BVEC_FLAG_FIXED flag is set. Simple tests show considerable
>> performance boost, and it also reduces memory footprint.
>>
>> Suggested-by: Matthew Wilcox <willy@infradead.org>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  Documentation/filesystems/porting.rst |  9 ++++
>>  block/bio.c                           | 64 +++++++++++----------------
>>  include/linux/bio.h                   |  3 ++
>>  3 files changed, 38 insertions(+), 38 deletions(-)
> 
> This doesn't touch iomap code, so the title of the patch seems
> wrong...

yeah, should be bio.

> 
>> +For bvec based itererators bio_iov_iter_get_pages() now doesn't copy bvecs but
>> +uses the one provided. Anyone issuing kiocb-I/O should ensure that the bvec and
>> +page references stay until I/O has completed, i.e. until ->ki_complete() has
>> +been called or returned with non -EIOCBQUEUED code.
> 
> This is hard to follow. Perhaps:
> 
> bio_iov_iter_get_pages() uses the bvecs  provided for bvec based
> iterators rather than copying them. Hence anyone issuing kiocb based
> IO needs to ensure the bvecs and pages stay referenced until the
> submitted I/O is completed by a call to ->ki_complete() or returns
> with an error other than -EIOCBQUEUED.

Agree, that's easier to read, thanks

> 
>> diff --git a/include/linux/bio.h b/include/linux/bio.h
>> index 2a9f3f0bbe0a..337f4280b639 100644
>> --- a/include/linux/bio.h
>> +++ b/include/linux/bio.h
>> @@ -444,6 +444,9 @@ static inline void bio_wouldblock_error(struct bio *bio)
>>  
>>  static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
>>  {
>> +	/* reuse iter->bvec */
>> +	if (iov_iter_is_bvec(iter))
>> +		return 0;
>>  	return iov_iter_npages(iter, max_segs);
> 
> Ah, I'm a blind idiot... :/
> 
> Cheers,
> 
> Dave.
> 

-- 
Pavel Begunkov
