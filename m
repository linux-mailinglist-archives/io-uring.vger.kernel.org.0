Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358E05E672F
	for <lists+io-uring@lfdr.de>; Thu, 22 Sep 2022 17:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiIVPdh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Sep 2022 11:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbiIVPdb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Sep 2022 11:33:31 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF21FB30F
        for <io-uring@vger.kernel.org>; Thu, 22 Sep 2022 08:33:26 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220922153323epoutp02803a3ac9c61b6c7276902aca7ab8dca6~XOJXrOjxX2809728097epoutp02Y
        for <io-uring@vger.kernel.org>; Thu, 22 Sep 2022 15:33:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220922153323epoutp02803a3ac9c61b6c7276902aca7ab8dca6~XOJXrOjxX2809728097epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663860803;
        bh=C81qtWO5E2zgqe+FAcHdBTKT4T0bT/5nCLsYZNOSs0I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K0s54Ba7TN+MawLq2p/1j0r1y2hNuclSuXKy7k3Jerqd6p7kHyAkwKmPSLqvo86vL
         WqFIfIgZRsOEXAo1X5LV9MY9fMvHhThmH09h9kTxW+O5ptSHbZI50B5cbfkb5rYP4X
         xxDRs7UpoAHWAEyoWPST1LwrUrc0C3ofWrP8SPYQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220922153323epcas5p493e554822c3858b4612676a7039a3951~XOJXLsMDE2442124421epcas5p4z;
        Thu, 22 Sep 2022 15:33:23 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MYK744wR0z4x9Pv; Thu, 22 Sep
        2022 15:33:20 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9A.48.39477.0408C236; Fri, 23 Sep 2022 00:33:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220922153319epcas5p1edab5d5bc06594d0ffa1c89944c2bc83~XOJT7-7sp1909019090epcas5p1H;
        Thu, 22 Sep 2022 15:33:19 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220922153319epsmtrp2569d97d2764b73dd09e3208c254ba3f4~XOJT7Nfg21775817758epsmtrp2y;
        Thu, 22 Sep 2022 15:33:19 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-77-632c80409203
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BC.5F.14392.F308C236; Fri, 23 Sep 2022 00:33:19 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220922153317epsmtip143a075c61865f5cf72b75201a9d95020~XOJSET6Fr1695316953epsmtip1g;
        Thu, 22 Sep 2022 15:33:17 +0000 (GMT)
Date:   Thu, 22 Sep 2022 20:53:31 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH for-next v7 4/5] block: add helper to map bvec iterator
 for passthrough
Message-ID: <20220922152331.GA24701@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220920120802.GC2809@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfVCTdRzA/T3Pw8MD1+px6PFzxsCHeR4vA4YDHhYQXeTNNIOzw85O4bnx
        tHF7vb1kdl2tGYWcBEEXMKzsRIktZgyYEoxsTmdceBVqo2sSx+CMK44TsxPC2niw87/P9/2V
        QPm9uICo1ZlZo47RUHg85rmUli4utWYqckZ/FNG25lWUPunwANoZasLpyYtDCN3jvIzQC3XX
        MLrFdxPQ3l8y6M/OzsaWxsmH7KFY+cS4Re52HMfl/V1vy4cnrbj8gwEHkC+5heWxB9VFKpap
        YY0prE6hr6nVKYupPfurnq3Ky8+RiCWFdAGVomO0bDFVtrdcvKtWE+mLSnmN0VgiqnLGZKKy
        S4qMeouZTVHpTeZiijXUaAxSQ5aJ0ZosOmWWjjXLJDk5uXkRx2q1qjP8TYyhbdvrN09cwqzg
        7y0NII6ApBR6+39GG0A8wSeHAVy9ugg44Q6AjdN+jBPuRSz+LvAwZPn8CZwzeAF0nJ9ZF+YA
        vPVJBx71wsjtcNEViiQmCJxMgz+0WqLqTSQFZ+fH10qg5HUAww0uJGpIIA/BPv8KGmUeKYZn
        7PdjON4Iv+sIY1GOIzNgoLl/jTeTqfCiJ4BEE0Gyh4DBtnAs114ZdF6+gnGcAOcDA+t6AVxa
        8OIcK+BPHdcQjs1wZuTbdX4a1o01rTWBkq9C319+jOPHYeNKGIkOA0kerH+Pz7lvg7daZmM4
        ToTT7V3rLIdfnry+vscggMFBB9YMhPZH5rE/UoJjGTy+aIvhOBkeG+xE7ZFyKLkVdj8gOEyD
        577OPgVwB9jCGkxaJWvKM+Tq2CP/X1yh17rB2t+mP38BTP+2mOUDCAF8ABIotYnX+Wuags+r
        YY6+wRr1VUaLhjX5QF7kVh+igs0KfeTxdeYqibQwR5qfny8t3JkvoRJ5p9vTFXxSyZhZNcsa
        WOPDOISIE1gRoeP9bpFnVeZd3LH748x3W38v6D4w1lgyFHYVTUwd6ut5pmKaPHu790Vj02rv
        OxsHLhxxtyaa/xh5arUaFxfcpx6MocnKGVGI3IB9lJrbNrpUOues/ly5oeKf+MpByWNHDfgB
        6H4l+/t9AdnOeutp0cJkS83++sMu/tgxm0corVdLbYbBWdz11d7OTM+TvDtv2fZ4k7Q7Ru5O
        vfzvCys3BOpxVZtIZJ769NTt0bp4YSj1cDBwT6woWxrxFM3J4Bfbw0nWyq3DsnPl7Rn253a1
        vrmcpC2+emZfhdmpQ5bvgnBB+hN92TO4vzkzq5Ka0JZ4kPmDyTfwP68EW3cPziW8RGEmFSNJ
        R40m5j81oTy8QAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LZdlhJTte+QSfZ4PBhA4umCX+ZLeas2sZo
        sfpuP5vFzQM7mSxWrj7KZPGu9RyLxaRD1xgt9t7Stpi/7Cm7A6fHzll32T0uny312LSqk81j
        85J6j903G9g8+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK6P/83S2gnVyFZ///mNuYFwt3sXI
        ySEhYCLxa3sPWxcjF4eQwG5GiQWdB1khEuISzdd+sEPYwhIr/z1nhyh6wijxZ/UHsCIWAVWJ
        D+vuMncxcnCwCWhKXJhcChIWEVCSePrqLCNIPbPAFaD6/UvA6oUFYiU2HvnNDGLzCuhKLJ31
        kxVi6C1GiY2rlrJDJAQlTs58wgJiMwuYSczb/BBsAbOAtMTyfxwQYXmJ5q2zweZwCmhLHJ+w
        GaxcVEBZ4sC240wTGIVmIZk0C8mkWQiTZiGZtICRZRWjZGpBcW56brFhgWFearlecWJucWle
        ul5yfu4mRnBcaWnuYNy+6oPeIUYmDsZDjBIczEoivLPvaCYL8aYkVlalFuXHF5XmpBYfYpTm
        YFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwFQoMV30tejC2qSLBVI52ybNXha0VDruxfx1
        ps8i66VOvXzAa3BYaH5hlrXGIQspCcXYbTksH7YEGM4XsV0memxp7pnLXQUTg3vYT5xLmrOH
        ccqxC62bNQ8u9lL7oGJ9cK+V/ef9HTlX/BZsCfx8wu971g1DvS0SBTeMkt5mXmGfKs8m3L/j
        raupqofJ3FOd5l3/FmUUMfkHfpBLzlpbI8lz//3dF7dCOw15ZCxe6a69+SyCRyshO7/AXODY
        7N+id49EHv3z0XH+y+n+L/NPumx0rLtkHSvczzvrO2sd59q8b0Ivrn3jdNzx8+0ViQyd+54/
        GWMXpJ9fc26P32StM5Nfbr3bosAw97PZpZXKaxSUWIozEg21mIuKEwFGDvG0GgMAAA==
X-CMS-MailID: 20220922153319epcas5p1edab5d5bc06594d0ffa1c89944c2bc83
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----Iofw26EFbNSGL_UgXoU1XVs5LxhMn2U4r7Cvdd9q_.3L.-0Y=_cd5_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220909103147epcas5p2a83ec151333bcb1d2abb8c7536789bfd
References: <20220909102136.3020-1-joshi.k@samsung.com>
        <CGME20220909103147epcas5p2a83ec151333bcb1d2abb8c7536789bfd@epcas5p2.samsung.com>
        <20220909102136.3020-5-joshi.k@samsung.com> <20220920120802.GC2809@lst.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------Iofw26EFbNSGL_UgXoU1XVs5LxhMn2U4r7Cvdd9q_.3L.-0Y=_cd5_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Tue, Sep 20, 2022 at 02:08:02PM +0200, Christoph Hellwig wrote:
>> -static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
>> +static struct bio *bio_map_get(struct request *rq, unsigned int nr_vecs,
>>  		gfp_t gfp_mask)
>
>bio_map_get is a very confusing name.

So I chose that name because functionality is opposite of what we do
inside existing bio_map_put helper. In that way it is symmetric.

>And I also still think this is
>the wrong way to go.  If plain slab allocations don't use proper
>per-cpu caches we have a MM problem and need to talk to the slab
>maintainers and not use the overkill bio_set here.

This series is not about using (or not using) bio-set. Attempt here has
been to use pre-mapped buffers (and bvec) that we got from io_uring.

>> +/* Prepare bio for passthrough IO given an existing bvec iter */
>> +int blk_rq_map_user_bvec(struct request *rq, struct iov_iter *iter)
>
>I'm a little confused about the interface we're trying to present from
>the block layer to the driver here.
>
>blk_rq_map_user_iov really should be able to detect that it is called
>on a bvec iter and just do the right thing rather than needing different
>helpers.

I too explored that possibility, but found that it does not. It maps the
user-pages into bio either directly or by doing that copy (in certain odd
conditions) but does not know how to deal with existing bvec.
Reason, I guess, is no one felt the need to try passthrough for bvecs
before. It makes sense only in context of io_uring passthrough.
And it really felt cleaner to me write a new function rather than 
overloading the blk_rq_map_user_iov with multiple if/else canals.
I tried that again after your comment, but it does not seem to produce
any good-looking code.
The other factor is - it seemed safe to go this way as I am more sure
that I will not break something else (using blk_rq_map_user_iov).

>> +		/*
>> +		 * If the queue doesn't support SG gaps and adding this
>> +		 * offset would create a gap, disallow it.
>> +		 */
>> +		if (bvprvp && bvec_gap_to_prev(lim, bvprvp, bv->bv_offset))
>> +			goto out_err;
>
>So now you limit the input that is accepted?  That's not really how
>iov_iters are used.   We can either try to reshuffle the bvecs, or
>just fall back to the copy data version as blk_rq_map_user_iov does
>for 'weird' iters˙

Since I was writing a 'new' helper for passthrough only, I thought it
will not too bad to just bail out (rather than try to handle it using
copy) if we hit this queue_virt_boundary related situation. 

To handle it the 'copy data' way we would need this -

585         else if (queue_virt_boundary(q))
586                 copy = queue_virt_boundary(q) & iov_iter_gap_alignment(iter);
587

But iov_iter_gap_alignment does not work on bvec iters. Line #1274 below

1264 unsigned long iov_iter_gap_alignment(const struct iov_iter *i)
1265 {
1266         unsigned long res = 0;
1267         unsigned long v = 0;
1268         size_t size = i->count;
1269         unsigned k;
1270
1271         if (iter_is_ubuf(i))
1272                 return 0;
1273
1274         if (WARN_ON(!iter_is_iovec(i)))
1275                 return ~0U;

Do you see a way to overcome this. Or maybe this can be revisted as we
are not missing a lot?

>> +
>> +		/* check full condition */
>> +		if (nsegs >= nr_segs || bytes > UINT_MAX - bv->bv_len)
>> +			goto out_err;
>> +
>> +		if (bytes + bv->bv_len <= nr_iter &&
>> +				bv->bv_offset + bv->bv_len <= PAGE_SIZE) {
>> +			nsegs++;
>> +			bytes += bv->bv_len;
>> +		} else
>> +			goto out_err;
>
>Nit: This would read much better as:
>
>		if (bytes + bv->bv_len > nr_iter)
>			goto out_err;
>		if (bv->bv_offset + bv->bv_len > PAGE_SIZE)
>			goto out_err;
>
>		bytes += bv->bv_len;
>		nsegs++;

Indeed, cleaner. Thanks.

------Iofw26EFbNSGL_UgXoU1XVs5LxhMn2U4r7Cvdd9q_.3L.-0Y=_cd5_
Content-Type: text/plain; charset="utf-8"


------Iofw26EFbNSGL_UgXoU1XVs5LxhMn2U4r7Cvdd9q_.3L.-0Y=_cd5_--
