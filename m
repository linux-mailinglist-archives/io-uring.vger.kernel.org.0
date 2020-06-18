Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6437C1FFB32
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 20:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgFRShh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 14:37:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27874 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgFRShf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 14:37:35 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200618183731epoutp010820b308ccbcd3043ed4a9e9547caf4d~Zt0U67jl61859818598epoutp01j
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 18:37:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200618183731epoutp010820b308ccbcd3043ed4a9e9547caf4d~Zt0U67jl61859818598epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592505451;
        bh=K04fZAG2yktTyADi5oC7xE22YZv49ewmuhJVMtxM5Pc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NSVarNJPX2Kv2hjAkYpHKkrwWFMmlSYbuJsZDdwG834nEZknNoOHV2AkeuNsrfNAv
         sjghauKlwYOjdyZhshjBWrWXBblof/0G9NpBu8tl7BRHYKvBaR7MTsriCpZER4ubPP
         l4SHFWo+gToZdiSFUbRrjzlXVjx6dJDzkg4neM/g=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200618183729epcas5p2f440c318c04e6c03ec7a637749609d42~Zt0Txma9v1141511415epcas5p2T;
        Thu, 18 Jun 2020 18:37:29 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BE.B8.09475.964BBEE5; Fri, 19 Jun 2020 03:37:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200618183729epcas5p4a836264b54541560df639344b6200ed9~Zt0S3FU5f1185611856epcas5p4f;
        Thu, 18 Jun 2020 18:37:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200618183728epsmtrp10373703db48f86d6b55818a4b8a6e55f~Zt0S2UxtO2407024070epsmtrp1L;
        Thu, 18 Jun 2020 18:37:28 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-06-5eebb4695af4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.5D.08382.864BBEE5; Fri, 19 Jun 2020 03:37:28 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200618183727epsmtip19bb8dc634bf2bd1aa83fe31b1fcddcea~Zt0RFJDJL2914929149epsmtip1p;
        Thu, 18 Jun 2020 18:37:26 +0000 (GMT)
Date:   Fri, 19 Jun 2020 00:05:11 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [PATCH 1/3] fs,block: Introduce IOCB_ZONE_APPEND and direct-io
 handling
Message-ID: <20200618183511.GA4141250@test-zns>
MIME-Version: 1.0
In-Reply-To: <CY4PR04MB3751810405442801C115CAEBE79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsWy7bCmhm7mltdxBgf+mlisvtvPZtH1bwuL
        RWv7NyaLd63nWCwe3/nMbjFlWhOjxd5b2hZ79p5ksbi8aw6bxbbf85ktXv84yWZx/u9xVgce
        j8tnSz02fZrE7tG3ZRWjx+dNch7tB7qZPDY9ecsUwBbFZZOSmpNZllqkb5fAlbFqm3TBZ7mK
        TXOdGhgXSnYxcnJICJhIXDi8gLGLkYtDSGA3o8TzS3OYQBJCAp8YJVa+koBIfGOUOPj6HAtM
        R//9eWwQib2MElfblzJDOM8YJeZsewlWxSKgKjFleStrFyMHB5uApsSFyaUgYREBLYll+96x
        gtjMAmdZJJ79UAWxhQXCJCZvnALWyiugL/HlzzUmCFtQ4uTMJ2BxToFYia63i9hAbFEBZYkD
        244zgeyVEFjJIfFy3zuo61wk5px9zQZhC0u8Or6FHcKWknjZ3wZlF0v8unOUGaK5g1HiesNM
        qGZ7iYt7/jKBHM0skCGx/YQ6xKF8Er2/n4CFJQR4JTrahCCqFSXuTXrKCmGLSzycsQTK9pBY
        +P8oNBQXMUlM7vOdwCg3C8k7sxAWzAJbYCXR+aGJFSIsLbH8HweEqSmxfpf+AkbWVYySqQXF
        uempxaYFxnmp5XrFibnFpXnpesn5uZsYwelJy3sH46MHH/QOMTJxMB5ilOBgVhLhdf79Ik6I
        NyWxsiq1KD++qDQntfgQozQHi5I4r9KPM3FCAumJJanZqakFqUUwWSYOTqkGpsf+eXdiF7x4
        prD43Xk3td+HL2fuS5i0MCg8oO/FRIb5y1TU373/U3ehkSvTN0u6eqputrdj9YX5f2ZzHQio
        fTOl8uyprfvsry6QfD0z9ZTQ+4MOJZtvsm0qeuT41PbzCo4jr4TlGJfm9spuK9uaNC/8UkQy
        Q8NuhVrn1Uv3K3BM7ImcdCDr7pTIFSuvtCnP1ktil5ThrzSeUukZ1vX0b+DJN0+UeDuZ/5xj
        4Xqswyy+9dE6vUMZSR7u9a4t/UKi1UmBLC9VHKpqLi5zfzM/XJq3YN0b1uCcLw/CBZ32Ve1X
        /vzy4KzN8QlP9Bbv833l3bpcbGvguSs+ypeY2KadeqqXuvP/29/6qbY6Ic4v45RYijMSDbWY
        i4oTAQFVHQW+AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWy7bCSnG7GltdxBi/+G1usvtvPZtH1bwuL
        RWv7NyaLd63nWCwe3/nMbjFlWhOjxd5b2hZ79p5ksbi8aw6bxbbf85ktXv84yWZx/u9xVgce
        j8tnSz02fZrE7tG3ZRWjx+dNch7tB7qZPDY9ecsUwBbFZZOSmpNZllqkb5fAldH19ilLwVKZ
        iqMTShoY34p1MXJySAiYSPTfn8fWxcjFISSwm1Fi14rbzBAJcYnmaz/YIWxhiZX/nrNDFD1h
        lLg/6xwbSIJFQFViyvJW1i5GDg42AU2JC5NLQcIiAloSy/a9YwWpZxa4yCIx+8hzJpCEsECY
        xOSNU1hAbF4BfYkvf64xQQxdxCTR+GINE0RCUOLkzCdgRcwCZhLzNj9kBlnALCAtsfwfB0iY
        UyBWouvtIrAbRAWUJQ5sO840gVFwFpLuWUi6ZyF0L2BkXsUomVpQnJueW2xYYJiXWq5XnJhb
        XJqXrpecn7uJERw7Wpo7GLev+qB3iJGJg/EQowQHs5IIr/PvF3FCvCmJlVWpRfnxRaU5qcWH
        GKU5WJTEeW8ULowTEkhPLEnNTk0tSC2CyTJxcEo1MJ1dmp7b7qQ1v4lhh27nsvAoW757i1vl
        1V57i/RppR6dFczSVrksUXuWVPWi269C7v+P2HriaROjrWTiu/5z2+5oFNoGsLjMcL3kKlSy
        jyPg8Jpdpwtc0rmMF3O167feyu47FH8qett+E4Euc6M/RtFu9pXbLWYzCbN8t15/rVRcRD65
        +o2i38yz0fcaY2a9dmDfFbp4rsJSQdlbp4wd8h7Eb2HvUvIIFD1iG/bxgdf6gJkTRTi3rN80
        7dO0lm06Uo1+K9c9vNtUPvtxsuDuIzyhZ9INrvtLXp4XF336md/SrWY10hbTj61m2TVJv8zA
        610xn1r9ppafQm9YNZi8D+RsiZjz16Vt+T0Ty+OTlViKMxINtZiLihMBhbGQgwwDAAA=
X-CMS-MailID: 20200618183729epcas5p4a836264b54541560df639344b6200ed9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_7803b_"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200617172702epcas5p4dbf4729d31d9a85ab1d261d04f238e61
References: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
        <CGME20200617172702epcas5p4dbf4729d31d9a85ab1d261d04f238e61@epcas5p4.samsung.com>
        <1592414619-5646-2-git-send-email-joshi.k@samsung.com>
        <CY4PR04MB3751810405442801C115CAEBE79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_7803b_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, Jun 18, 2020 at 07:16:19AM +0000, Damien Le Moal wrote:
>On 2020/06/18 2:27, Kanchan Joshi wrote:
>> From: Selvakumar S <selvakuma.s1@samsung.com>
>>
>> Introduce IOCB_ZONE_APPEND flag, which is set in kiocb->ki_flags for
>> zone-append. Direct I/O submission path uses this flag to send bio with
>> append op. And completion path uses the same to return zone-relative
>> offset to upper layer.
>>
>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
>> ---
>>  fs/block_dev.c     | 19 ++++++++++++++++++-
>>  include/linux/fs.h |  1 +
>>  2 files changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>> index 47860e5..4c84b4d0 100644
>> --- a/fs/block_dev.c
>> +++ b/fs/block_dev.c
>> @@ -185,6 +185,10 @@ static unsigned int dio_bio_write_op(struct kiocb *iocb)
>>  	/* avoid the need for a I/O completion work item */
>>  	if (iocb->ki_flags & IOCB_DSYNC)
>>  		op |= REQ_FUA;
>> +#ifdef CONFIG_BLK_DEV_ZONED
>> +	if (iocb->ki_flags & IOCB_ZONE_APPEND)
>> +		op |= REQ_OP_ZONE_APPEND | REQ_NOMERGE;
>> +#endif
>
>No need for the #ifdef. And no need for the REQ_NOMERGE either since
>REQ_OP_ZONE_APPEND requests are defined as not mergeable already.
>
>>  	return op;
>>  }
>>
>> @@ -295,6 +299,14 @@ static int blkdev_iopoll(struct kiocb *kiocb, bool wait)
>>  	return blk_poll(q, READ_ONCE(kiocb->ki_cookie), wait);
>>  }
>>
>> +#ifdef CONFIG_BLK_DEV_ZONED
>> +static inline long blkdev_bio_end_io_append(struct bio *bio)
>> +{
>> +	return (bio->bi_iter.bi_sector %
>> +		blk_queue_zone_sectors(bio->bi_disk->queue)) << SECTOR_SHIFT;
>
>A zone size is at most 4G sectors as defined by the queue chunk_sectors limit
>(unsigned int). It means that the return value here can overflow due to the
>shift, at least on 32bits arch.
>
>And as Pavel already commented, zone sizes are power of 2 so you can use
>bitmasks instead of costly divisions.
>
>> +}
>> +#endif
>> +
>>  static void blkdev_bio_end_io(struct bio *bio)
>>  {
>>  	struct blkdev_dio *dio = bio->bi_private;
>> @@ -307,15 +319,20 @@ static void blkdev_bio_end_io(struct bio *bio)
>>  		if (!dio->is_sync) {
>>  			struct kiocb *iocb = dio->iocb;
>>  			ssize_t ret;
>> +			long res = 0;
>>
>>  			if (likely(!dio->bio.bi_status)) {
>>  				ret = dio->size;
>>  				iocb->ki_pos += ret;
>> +#ifdef CONFIG_BLK_DEV_ZONED
>> +				if (iocb->ki_flags & IOCB_ZONE_APPEND)
>> +					res = blkdev_bio_end_io_append(bio);
>
>overflow... And no need for the #ifdef.
>
>> +#endif
>>  			} else {
>>  				ret = blk_status_to_errno(dio->bio.bi_status);
>>  			}
>>
>> -			dio->iocb->ki_complete(iocb, ret, 0);
>> +			dio->iocb->ki_complete(iocb, ret, res);
>
>ki_complete interface also needs to be changed to have a 64bit last argument to
>avoid overflow.
>
>And this all does not work anyway because __blkdev_direct_IO() and
>__blkdev_direct_IO_simple() both call bio_iov_iter_get_pages() *before*
>dio_bio_write_op() is called. This means that bio_iov_iter_get_pages() will not
>see that it needs to get the pages for a zone append command and so will not
>call __bio_iov_append_get_pages(). That leads to BIO split and potential
>corruption of the user data as fragments of the kiocb may get reordered.
>
>There is a lot more to do to the block_dev direct IO code for this to work.

Thanks a lot for the great review. Very helpful. We'll fix in V2. 

------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_7803b_
Content-Type: text/plain; charset="utf-8"


------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_7803b_--
