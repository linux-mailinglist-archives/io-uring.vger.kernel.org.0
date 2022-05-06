Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF94351D42A
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 11:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239497AbiEFJXS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 05:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347361AbiEFJXR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 05:23:17 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4186350E
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 02:19:33 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220506091930epoutp032b19772179ca2cbc9b0d3c208f2198cd~seYO6jiaK2698226982epoutp03K
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 09:19:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220506091930epoutp032b19772179ca2cbc9b0d3c208f2198cd~seYO6jiaK2698226982epoutp03K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651828770;
        bh=id4nfVK4NNq8KQPijTahXyh7yUxqOf6jmHfQsrdx4BU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WzQohPsKVl0g48vlu/Mbhd+Fy8zjUo+hf0iFY7u3PalE4y6QKCtoD30MGD1OGAtOq
         daWn/FgRZglEGfMxGb7jz6mPhnuNDfLCuTPv9b3K28FgmvH/u6WCLfcEjTbw+lHVOi
         sfEUr2+V1EQMFsXQJtZOX43iyy/+6xYDZ+ITH4Eg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220506091929epcas5p30c9a0408595b8700d3d7b8bf90ce58f8~seYOS0dRZ1846418464epcas5p3x;
        Fri,  6 May 2022 09:19:29 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KvlPn2DV0z4x9Ps; Fri,  6 May
        2022 09:19:25 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6C.29.09827.D18E4726; Fri,  6 May 2022 18:19:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220506071727epcas5p2d2001078335f117788f5ac433ccbceae~sctroZ2L20746107461epcas5p2H;
        Fri,  6 May 2022 07:17:27 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220506071727epsmtrp2f060a8daf135545eef9b2a5bebc6a5b0~sctrniV5t2974429744epsmtrp2O;
        Fri,  6 May 2022 07:17:27 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-e9-6274e81d0ee3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C6.49.11276.78BC4726; Fri,  6 May 2022 16:17:27 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220506071726epsmtip2f8eb2c26f36d8351e2fd6050dd87d519~sctp-NwPd0090200902epsmtip2X;
        Fri,  6 May 2022 07:17:25 +0000 (GMT)
Date:   Fri, 6 May 2022 12:42:16 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v4 1/5] fs,io_uring: add infrastructure for uring-cmd
Message-ID: <20220506071216.GB20217@test-zns>
MIME-Version: 1.0
In-Reply-To: <1af73495-d4a6-d6fd-0a03-367016385c92@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIJsWRmVeSWpSXmKPExsWy7bCmhq7si5Ikg5Ob+C2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymL/sKbvFjQlPGS0OTW5msrj68gC7A7fHxOZ3
        7B47Z91l97h8ttRj06pONo/NS+o9dt9sYPN4v+8qm0ffllWMHp83yQVwRmXbZKQmpqQWKaTm
        JeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdq6RQlphTChQKSCwuVtK3
        synKLy1JVcjILy6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzpj9bhdrwV7Jipkb
        dzI3MD4X6WLk5JAQMJE4ebiNqYuRi0NIYDejxOFtB9khnE+MEscf9rGCVAkJfGOUeLHJC6Zj
        +fsOqKK9jBKfV95lhHCeMUrMPXORCaSKRUBF4uzz9UAJDg42AU2JC5NLQcIiAgoSPb9XsoHU
        MwvcZJToP7WXESQhLOAp8XzRdWYQm1dAV2L9ntVQtqDEyZlPWEBsTgFbidf3HoDZogLKEge2
        HQe7W0JgB4fE80u7mSDOc5E4e62ZFcIWlnh1fAs7hC0l8fndXjYIO1midftldpDjJARKJJYs
        UIcI20tc3PMXbAyzQIZE/85VUCNlJaaeWgcV55Po/f0EKs4rsWMejK0ocW/SU6i14hIPZyyB
        sj0kLrdeYIME0AdGid9P3rNNYJSfheS3WUj2QdhWEp0fmlhnAZ3HLCAtsfwfB4SpKbF+l/4C
        RtZVjJKpBcW56anFpgVGeanl8AhPzs/dxAhOy1peOxgfPvigd4iRiYPxEKMEB7OSCK/wrJIk
        Id6UxMqq1KL8+KLSnNTiQ4ymwLiayCwlmpwPzAx5JfGGJpYGJmZmZiaWxmaGSuK8p9M3JAoJ
        pCeWpGanphakFsH0MXFwSjUwqS88/WxD8TGhiOtP2xJv/2ycebJ6sxv3dJ6qhTxr16YtvszU
        s6xpZVdn35vtGZO5Yic+nzvt0cZPs2sXVPRtdFx0XDRt8mMVoQWX5EMeX9l3UmLh3YdnGFcH
        rly8NS77+sr+Q6Ll51zmCM1yk9SVTueIf98lanfB4g9TSEnurZU6jGvvm79l1LCXzrro5Zzy
        0jHhgoVF0CzO1yytvX0FCbyeM5/5pn91uJ1wPTr52v2ZrcePB7a88jq/If7y5LmCR76e+VjH
        1On1eZagx3Z7IQnTfZvuxmTVn/Ktm2ypFTazauvbX0sdZ619puvY+Yb94IYKa53phW8kWdhm
        Rnx5zvPIO+vyC50pz8/EaU085a/EUpyRaKjFXFScCACDkOczVAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJXrf9dEmSwY9/uhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7hsUlJzMstSi/Tt
        Ergy5kxuZSx4L1Zx+OgZpgbGzUJdjJwcEgImEsvfd7B3MXJxCAnsZpSY9noSG0RCXKL52g92
        CFtYYuW/51BFTxglemc8ZgFJsAioSJx9vp6xi5GDg01AU+LC5FKQsIiAgkTP75VsIPXMArcZ
        JR5OvApWLyzgKfF80XVmEJtXQFdi/Z7VzBBDPzBKXH60lwkiIShxcuYTsAZmATOJeZsfMoMs
        YBaQllj+jwMkzClgK/H63gOwElEBZYkD244zTWAUnIWkexaS7lkI3QsYmVcxSqYWFOem5xYb
        FhjmpZbrFSfmFpfmpesl5+duYgRHlJbmDsbtqz7oHWJk4mA8xCjBwawkwis8qyRJiDclsbIq
        tSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBibrot4nHH8vTFDcPO14
        N/PrtH7rtV/8Jm8/F/P3RiBHTM6sSunW5aX9M/vO8C020K1Zz7c0pCmx3uXAvPQzDZ+apDYn
        7VPvKn+kKxXm4helN1V42d27fpVi05vDo4P319m/9SljbLnC/7f9gXZz1M1pMzOL+IP6PLOC
        193U6LrpuIavLrI5MFU4P3P+eXtR14TrvBMuO9TcdwyS4O+vcLwqbsLO5yf7bWbk0jbRlw4W
        6ZF3FT2VChzNNla+vSSV03LrpkOf7HmuTzeCn3Qr7WfYxHCi5jPjtNznV2Q6BA1lWvIXG3x8
        onZ8x60/3pELSzi+HrlpU/fSpJjzeIQw95vdc534ououHDRon+2lxFKckWioxVxUnAgA/NaP
        sBcDAAA=
X-CMS-MailID: 20220506071727epcas5p2d2001078335f117788f5ac433ccbceae
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----B60c1XsBAYLlAvSr_Hnug5kZhc5LtmZ3tZiwVK7tFSQflFGl=_45848_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220505061144epcas5p3821a9516dad2b5eff5a25c56dbe164df
References: <20220505060616.803816-1-joshi.k@samsung.com>
        <CGME20220505061144epcas5p3821a9516dad2b5eff5a25c56dbe164df@epcas5p3.samsung.com>
        <20220505060616.803816-2-joshi.k@samsung.com>
        <1af73495-d4a6-d6fd-0a03-367016385c92@kernel.dk>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------B60c1XsBAYLlAvSr_Hnug5kZhc5LtmZ3tZiwVK7tFSQflFGl=_45848_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, May 05, 2022 at 10:17:39AM -0600, Jens Axboe wrote:
>On 5/5/22 12:06 AM, Kanchan Joshi wrote:
>> +static int io_uring_cmd_prep(struct io_kiocb *req,
>> +			     const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_uring_cmd *ioucmd = &req->uring_cmd;
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +
>> +	if (ctx->flags & IORING_SETUP_IOPOLL)
>> +		return -EOPNOTSUPP;
>> +	/* do not support uring-cmd without big SQE/CQE */
>> +	if (!(ctx->flags & IORING_SETUP_SQE128))
>> +		return -EOPNOTSUPP;
>> +	if (!(ctx->flags & IORING_SETUP_CQE32))
>> +		return -EOPNOTSUPP;
>> +	if (sqe->ioprio || sqe->rw_flags)
>> +		return -EINVAL;
>> +	ioucmd->cmd = sqe->cmd;
>> +	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
>> +	return 0;
>> +}
>
>While looking at the other suggested changes, I noticed a more
>fundamental issue with the passthrough support. For any other command,
>SQE contents are stable once prep has been done. The above does do that
>for the basic items, but this case is special as the lower level command
>itself resides in the SQE.
>
>For cases where the command needs deferral, it's problematic. There are
>two main cases where this can happen:
>
>- The issue attempt yields -EAGAIN (we ran out of requests, etc). If you
>  look at other commands, if they have data that doesn't fit in the
>  io_kiocb itself, then they need to allocate room for that data and have
>  it be persistent
>
>- Deferral is specified by the application, using eg IOSQE_IO_LINK or
>  IOSQE_ASYNC.
>
>We're totally missing support for both of these cases. Consider the case
>where the ring is setup with an SQ size of 1. You prep a passthrough
>command (request A) and issue it with io_uring_submit(). Due to one of
>the two above mentioned conditions, the internal request is deferred.
>Either it was sent to ->uring_cmd() but we got -EAGAIN, or it was
>deferred even before that happened. The application doesn't know this
>happened, it gets another SQE to submit a new request (request B). Fills
>it in, calls io_uring_submit(). Since we only have one SQE available in
>that ring, when request A gets re-issued, it's now happily reading SQE
>contents from command B. Oops.
>
>This is why prep handlers are the only ones that get an sqe passed to
>them. They are supposed to ensure that we no longer read from the SQE
>past that. Applications can always rely on that fact that once
>io_uring_submit() has been done, which consumes the SQE in the SQ ring,
>that no further reads are done from that SQE.
>
Thanks for explaining; gives great deal of clarity.
Are there already some tests (liburing, fio etc.) that you use to test
this part?
Different from what you mentioned, but I was forcing failure scenario by
setting low QD in nvme and pumping commands at higher QD than that. 
But this was just testing that we return failure to usespace (since
deferral was not there). 

------B60c1XsBAYLlAvSr_Hnug5kZhc5LtmZ3tZiwVK7tFSQflFGl=_45848_
Content-Type: text/plain; charset="utf-8"


------B60c1XsBAYLlAvSr_Hnug5kZhc5LtmZ3tZiwVK7tFSQflFGl=_45848_--
