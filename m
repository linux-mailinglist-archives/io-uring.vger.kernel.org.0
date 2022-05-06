Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A4F51D429
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 11:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388609AbiEFJXO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 05:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239497AbiEFJXL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 05:23:11 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A05B63519
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 02:19:27 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220506091923epoutp0429af22ea8ffb62cc9b4453ec9e0d2475~seYIg1XQ70407104071epoutp04U
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 09:19:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220506091923epoutp0429af22ea8ffb62cc9b4453ec9e0d2475~seYIg1XQ70407104071epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651828763;
        bh=S4HReQDClt8TbQAFd2IAkzhG9B+wnxBxy4kOy2VqH6Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iiWCOXUa/Q+FRIT+aKoICYadWv/nAokP26xlQvf84ePox4mAKr+4VDogLtkWFf82t
         essHUcrojimlteklvYzzsCk9yPI4IzgYuzFK8HE28lYGgghr5j9S5JSoUk5ZzaXINt
         uImntQdLEKWkiGjmrIDSFaCYspazulcs1GE3jOsE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220506091922epcas5p11a01ed56670d661fd92b22cecfcb241a~seYH-zUnw2070620706epcas5p1i;
        Fri,  6 May 2022 09:19:22 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4KvlPf2G31z4x9Px; Fri,  6 May
        2022 09:19:18 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C5.64.09762.618E4726; Fri,  6 May 2022 18:19:18 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220506064800epcas5p2d2e484da98c3c7b89db9e63e9b1c860f~scT9tYtFl0356903569epcas5p2C;
        Fri,  6 May 2022 06:48:00 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220506064800epsmtrp1d0cfd6fb9d77fa84a5e3f9ab815c33f7~scT9sj0Ck0666706667epsmtrp1O;
        Fri,  6 May 2022 06:48:00 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-7c-6274e816fd70
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.4F.08924.0A4C4726; Fri,  6 May 2022 15:48:00 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220506064758epsmtip2c69b757057782fb2c42874b69bd9b574~scT8CpmaM1442114421epsmtip2m;
        Fri,  6 May 2022 06:47:58 +0000 (GMT)
Date:   Fri, 6 May 2022 12:12:49 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v4 0/5] io_uring passthrough for nvme
Message-ID: <20220506064249.GA20217@test-zns>
MIME-Version: 1.0
In-Reply-To: <a715cc61-97e7-2292-ec7d-59389b00e779@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJsWRmVeSWpSXmKPExsWy7bCmpq7Yi5Ikg7nfeC2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymL/sKbvFjQlPGS0OTW5msrj68gC7A7fHxOZ3
        7B47Z91l97h8ttRj06pONo/NS+o9dt9sYPN4v+8qm0ffllWMHp83yQVwRmXbZKQmpqQWKaTm
        JeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdq6RQlphTChQKSCwuVtK3
        synKLy1JVcjILy6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzph/6ipLwQKRimsX
        p7E3MH4V6GLk5JAQMJF48mQ/I4gtJLCbUeLbL6EuRi4g+xOjxIaz/1ggnM+MEguvnGGE6Vhz
        /BozRGIXo8TES39YIZxnjBIr7s1nAqliEVCRON2zHaiDg4NNQFPiwuRSkLCIgIJEz++VbCD1
        zAI3GSX6T+0FmyosYCnxfO9ZZhCbV0BXYtrU++wQtqDEyZlPWEBsTgFbiZ3v77GB2KICyhIH
        th1nAhkkIbCDQ+L76RXsEOe5SBz6d4cFwhaWeHV8C1RcSuJlfxuUnSzRuv0yO8hxEgIlEksW
        qEOE7SUu7vkLdj+zQIbE9pYTzBBxWYmpp9ZBxfkken8/YYKI80rsmAdjK0rcm/SUFcIWl3g4
        YwmU7SFxorWVHRK+wGC8M8ljAqP8LCSvzUKyDsK2kuj80MQ6C+g6ZgFpieX/OCBMTYn1u/QX
        MLKuYpRMLSjOTU8tNi0wzksth8d3cn7uJkZwUtby3sH46MEHvUOMTByMhxglOJiVRHiFZ5Uk
        CfGmJFZWpRblxxeV5qQWH2I0BUbVRGYp0eR8YF7IK4k3NLE0MDEzMzOxNDYzVBLnPZW+IVFI
        ID2xJDU7NbUgtQimj4mDU6qBaW9eKme4+z8fV4fvrhc2L5y16mRXmNIS+92VCdGPRY5Eal7j
        2rfa+O/yC84vLaI4rR+357+v0tRyTjrzKG3S7DYWQcElV4wn2S9XbHzVqTVNWGqfO6+/SOLz
        Pq6cn0zPJ9SU5tWc9wlceE5PKzgik3u/2dPpIpNL/WskX1tt3hlz6LS3bvuDVZZMzzZt2DF5
        x7QL/eeythikHNnbILRPcNWPI7rnt3H9D5x3d4vZ188Lrt5vN5p+v9V/9SauiSbVlt9YO25E
        rQ+L4UoNEF2uZZvZ0HIga8eyt9EXTLzffqp2nNWx/n1+42bH2I1hM5L+7t2auWbZ20/8Z380
        tludfiwRwPA067WqyNnNlVud3iqxFGckGmoxFxUnAgCR/nj2UwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJXnfBkZIkg8XTpCyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymL/sKbvFjQlPGS0OTW5msrj68gC7A7fHxOZ3
        7B47Z91l97h8ttRj06pONo/NS+o9dt9sYPN4v+8qm0ffllWMHp83yQVwRnHZpKTmZJalFunb
        JXBldG7sZC24JFjxtnsLcwPjQb4uRk4OCQETiTXHrzF3MXJxCAnsYJTYfXoeO0RCXKL52g8o
        W1hi5b/nYLaQwBNGiTnH40FsFgEVidM92xm7GDk42AQ0JS5MLgUJiwgoSPT8XskGMpNZ4Daj
        xMOJV1lAEsIClhLP955lBrF5BXQlpk29DzXzM1DRZF2IuKDEyZlPwOqZBcwk5m1+yAwyn1lA
        WmL5Pw6QMKeArcTO9/fYQGxRAWWJA9uOM01gFJyFpHsWku5ZCN0LGJlXMUqmFhTnpucWGxYY
        5aWW6xUn5haX5qXrJefnbmIER5OW1g7GPas+6B1iZOJgPMQowcGsJMIrPKskSYg3JbGyKrUo
        P76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQamFfcyTqd3N/Np3r3y4LSI
        sOC8mM5ixcbIktJHxdNlGYU3/w5xuCCxIn3tse+b1r/RiI77sPp7n+GeTXflHW7fnHB43c0H
        +49kXa3hlps4p/PHeo/6ifzpcf8673Qldtx5+6kgZu90wbIdK3ZtDZlvJTr7VuvuS6uWFV9s
        vtzxNzfUIeNanXDgQrXmNSXxjztu/6nl7mAJ9POee2OfodRC45hLJmskl83IqtZrnTbJ3ZZ5
        apTdmjTTabtWd4mHSi1KWKvV8GNp9Y2Fcun/mkpvqjJ+MXVrFTFmNn0s6J2yZM7ercfE4t74
        Tvkk9O9MA6PGVelgNZd7s+oeB9ccFXQuel6sIjfLPfr0Xs7c9TO7lViKMxINtZiLihMB0Agw
        1xUDAAA=
X-CMS-MailID: 20220506064800epcas5p2d2e484da98c3c7b89db9e63e9b1c860f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----KqMzgBRJR.Fsk82YJsMcER2lgAm37zzR_kphVf-KeEbAMdws=_4572a_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220505061142epcas5p2c943572766bfd5088138fe0f7873c96c
References: <CGME20220505061142epcas5p2c943572766bfd5088138fe0f7873c96c@epcas5p2.samsung.com>
        <20220505060616.803816-1-joshi.k@samsung.com>
        <d99a828b-94ed-97a0-8430-cfb49dd56b74@kernel.dk>
        <a715cc61-97e7-2292-ec7d-59389b00e779@kernel.dk>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------KqMzgBRJR.Fsk82YJsMcER2lgAm37zzR_kphVf-KeEbAMdws=_4572a_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, May 05, 2022 at 12:29:27PM -0600, Jens Axboe wrote:
>On 5/5/22 12:20 PM, Jens Axboe wrote:
>> On 5/5/22 12:06 AM, Kanchan Joshi wrote:
>>> This iteration is against io_uring-big-sqe brach (linux-block).
>>> On top of a739b2354 ("io_uring: enable CQE32").
>>>
>>> fio testing branch:
>>> https://protect2.fireeye.com/v1/url?k=b0d23f72-d1592a52-b0d3b43d-74fe485fb347-02541f801e3b5f5f&q=1&e=ef4bb07a-7707-4854-819c-98abcabb5d2d&u=https%3A%2F%2Fgithub.com%2Fjoshkan%2Ffio%2Ftree%2Fbig-cqe-pt.v4
>>
>> I folded in the suggested changes, the branch is here:
>>
>> https://protect2.fireeye.com/v1/url?k=40e9c3d0-2162d6f0-40e8489f-74fe485fb347-f8e801be1f796980&q=1&e=ef4bb07a-7707-4854-819c-98abcabb5d2d&u=https%3A%2F%2Fgit.kernel.dk%2Fcgit%2Flinux-block%2Flog%2F%3Fh%3Dfor-5.19%2Fio_uring-passthrough
>>
>> I'll try and run the fio test branch, but please take a look and see what
>> you think.
>
>Tested that fio branch and it works for me with what I had pushed out.
>Also tested explicit deferral of requests.

Thanks for sorting everything out! I could test this out now only :-(
Fio scripts ran fine (post refreshing SQE128/CQE32 flag values;repushed fio).

I think these two changes are needed in your branch:

1. since uring-cmd can be without large-cqe, we need to add that
condition in io_uring_cmd_done(). This change in patch 1 - 

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 884f40f51536..c24469564ebc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4938,7 +4938,10 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)

        if (ret < 0)
                req_set_fail(req);
-       __io_req_complete32(req, 0, ret, 0, res2, 0);
+       if (req->ctx->flags & IORING_SETUP_CQE32)
+               __io_req_complete32(req, 0, ret, 0, res2, 0);
+       else
+               io_req_complete(req, ret);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);

2. In the commit-message of patch 1, we should delete last line.
i.e.
"This operation can be issued only on the ring that is
setup with both IORING_SETUP_SQE128 and IORING_SETUP_CQE32 flags."

And/or we can move this commit-message of patch 4.

You can either take these changes in, or I can respin the series. LMK.

------KqMzgBRJR.Fsk82YJsMcER2lgAm37zzR_kphVf-KeEbAMdws=_4572a_
Content-Type: text/plain; charset="utf-8"


------KqMzgBRJR.Fsk82YJsMcER2lgAm37zzR_kphVf-KeEbAMdws=_4572a_--
