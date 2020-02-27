Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58BA171419
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2020 10:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgB0JZj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Feb 2020 04:25:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43184 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbgB0JZj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Feb 2020 04:25:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01R9NpfU034096;
        Thu, 27 Feb 2020 09:25:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8zQDK/9jHRAQFv7hVcZo9tYgIQ+A21KFnO314sYNNq0=;
 b=VtMPzVUFig/EpQoIyPmevr7a2HzESUZJ+FSg6qu2XhZ5M7/xS3YE7C2uI+YY5ouHrbv+
 XYmyIhwUbE5g+cGSDoE5VAspdWSSNlg0RVpehGuQKuaNZGbMqbxVggBNNi767eaOU9TX
 YbOl7EwhNJIHN7r/A86hL3r7CgQsxE6mjVW0p5tlqhaxIArnNejz/eV15Btn87VpWPtd
 73GFH711TLr6BwCIUvELcszhDXuD1TR/ItcDCjYh6UW36Ef+BKHV1AZZCIh6BSInB/BL
 6qMEZBmIR3ghfE+ffIVYg/5cyj2JGJje3EklnZ7kvJoVOAvZuvlTX85KmO5DvaY8q7vr CQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ydcsnhkpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 09:25:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01R9ECHV122368;
        Thu, 27 Feb 2020 09:23:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ydj4m0n3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 09:23:36 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01R9NZoU002791;
        Thu, 27 Feb 2020 09:23:35 GMT
Received: from [192.168.1.14] (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 01:23:35 -0800
Subject: Re: [PATCH 2/4] bio-integrity: introduce two funcs handle protect
 information
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-block@vger.kernel.org, axboe@kernel.dk,
        martin.petersen@oracle.com, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org
References: <20200226083719.4389-1-bob.liu@oracle.com>
 <20200226083719.4389-3-bob.liu@oracle.com> <20200226160310.GA8044@magnolia>
From:   Bob Liu <bob.liu@oracle.com>
Message-ID: <fb215042-6882-d51c-0ff9-a8d2487db08f@oracle.com>
Date:   Thu, 27 Feb 2020 17:23:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20200226160310.GA8044@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270075
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270075
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/27/20 12:03 AM, Darrick J. Wong wrote:
> On Wed, Feb 26, 2020 at 04:37:17PM +0800, Bob Liu wrote:
>> Introduce two funcs handle protect information passthrough from
>> user space.
>>
>> iter_slice_protect_info() will slice the last segment as protect
>> information.
>>
>> bio_integrity_prep_from_iovec() attach the protect information to
>> a bio.
>>
>> Signed-off-by: Bob Liu <bob.liu@oracle.com>
>> ---
>>  block/bio-integrity.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/bio.h   | 14 ++++++++++
>>  2 files changed, 91 insertions(+)
>>
>> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
>> index 575df98..0b22c5d 100644
>> --- a/block/bio-integrity.c
>> +++ b/block/bio-integrity.c
>> @@ -12,6 +12,7 @@
>>  #include <linux/bio.h>
>>  #include <linux/workqueue.h>
>>  #include <linux/slab.h>
>> +#include <linux/uio.h>
>>  #include "blk.h"
>>  
>>  #define BIP_INLINE_VECS	4
>> @@ -305,6 +306,53 @@ bool bio_integrity_prep(struct bio *bio)
>>  }
>>  EXPORT_SYMBOL(bio_integrity_prep);
>>  
>> +int bio_integrity_prep_from_iovec(struct bio *bio, struct iovec *pi_iov)
>> +{
>> +	struct blk_integrity *bi = blk_get_integrity(bio->bi_disk);
>> +	struct bio_integrity_payload *bip;
>> +	struct page *user_pi_page;
>> +	int nr_vec_page = 0;
>> +	int ret = 0, interval = 0;
>> +
>> +	if (!pi_iov || !pi_iov->iov_base)
>> +		return 1;
>> +
>> +	nr_vec_page = (pi_iov->iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
>> +	if (nr_vec_page > 1) {
>> +		printk("Now only support 1 page containing integrity "
>> +			"metadata, while requires %d pages.\n", nr_vec_page);
>> +		return 1;
> 
> I would've thought this would be -EINVAL or something given the -ENOMEM
> below...?
> 
>> +	}
>> +
>> +	interval = bio_integrity_intervals(bi, bio_sectors(bio));
>> +	if ((interval * bi->tuple_size) != pi_iov->iov_len)
>> +		return 1;
>> +
>> +	bip = bio_integrity_alloc(bio, GFP_NOIO, nr_vec_page);
>> +	if (IS_ERR(bip))
>> +		return PTR_ERR(bip);
>> +
>> +	bip->bip_iter.bi_size = pi_iov->iov_len;
>> +	bip->bio_iter = bio->bi_iter;
>> +	bip_set_seed(bip, bio->bi_iter.bi_sector);
>> +
>> +	if (bi->flags & BLK_INTEGRITY_IP_CHECKSUM)
>> +		bip->bip_flags |= BIP_IP_CHECKSUM;
>> +
>> +	ret = get_user_pages_fast((unsigned long)(pi_iov->iov_base), nr_vec_page,
>> +			op_is_write(bio_op(bio)) ?  FOLL_WRITE : 0,
>> +			&user_pi_page);
>> +	if (unlikely(ret < 0))
>> +		return 1;
>> +
>> +	ret = bio_integrity_add_page(bio, user_pi_page, pi_iov->iov_len, 0);
>> +	if (unlikely(ret != pi_iov->iov_len))
>> +		return -ENOMEM;
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(bio_integrity_prep_from_iovec);
>> +
>>  /**
>>   * bio_integrity_verify_fn - Integrity I/O completion worker
>>   * @work:	Work struct stored in bio to be verified
>> @@ -378,6 +426,35 @@ void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
>>  }
>>  
>>  /**
>> + * iter_slice_protect_info
>> + *
>> + * Description: slice protection information from iter.
>> + * The last iovec contains protection information pass from user space.
> 
> What do the return values here mean?
> 

Will update.

> Also kinda wondering about the slice & dice of the iovec here, but
> <shrug> I guess this is RFC. :)
> 

Hmm, I also very hesitate to put it here or lib/iov_iter.c. 

> --D
> 
>> + */
>> +int iter_slice_protect_info(struct iov_iter *iter, int nr_pages,
>> +		struct iovec **pi_iov)
>> +{
>> +	size_t len = 0;
>> +
>> +	/* TBD: now only support one bio. */
>> +	if (!iter_is_iovec(iter) || nr_pages >= BIO_MAX_PAGES - 1)
>> +		return 1;
>> +
>> +	/* Last iovec contains protection information. */
>> +	iter->nr_segs--;
>> +	*pi_iov = (struct iovec *)(iter->iov + iter->nr_segs);
>> +
>> +	len = (*pi_iov)->iov_len;
>> +	if (len > 0 && len < iter->count) {
>> +		iter->count -= len;
>> +		return 0;
>> +	}
>> +
>> +	return 1;
>> +}
>> +EXPORT_SYMBOL(iter_slice_protect_info);
>> +
>> +/**
>>   * bio_integrity_trim - Trim integrity vector
>>   * @bio:	bio whose integrity vector to update
>>   *
>> diff --git a/include/linux/bio.h b/include/linux/bio.h
>> index 3cdb84c..6172b13 100644
>> --- a/include/linux/bio.h
>> +++ b/include/linux/bio.h
>> @@ -749,6 +749,8 @@ static inline bool bioset_initialized(struct bio_set *bs)
>>  extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
>>  extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
>>  extern bool bio_integrity_prep(struct bio *);
>> +extern int bio_integrity_prep_from_iovec(struct bio *bio, struct iovec *pi_iov);
>> +extern int iter_slice_protect_info(struct iov_iter *iter, int nr_pages, struct iovec **pi_iov);
>>  extern void bio_integrity_advance(struct bio *, unsigned int);
>>  extern void bio_integrity_trim(struct bio *);
>>  extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t);
>> @@ -778,6 +780,18 @@ static inline bool bio_integrity_prep(struct bio *bio)
>>  	return true;
>>  }
>>  
>> +static inline int bio_integrity_prep_from_iovec(struct bio *bio,
>> +		struct iovec *pi_iov)
>> +{
>> +	return 0;
>> +}
>> +
>> +static inline int iter_slice_protect_info(struct iov_iter *iter, int nr_pages,
>> +		struct iovec **pi_iov)
>> +{
>> +	return 0;
>> +}
>> +
>>  static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
>>  				      gfp_t gfp_mask)
>>  {
>> -- 
>> 2.9.5
>>

