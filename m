Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104B020EFC0
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 09:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbgF3Hn1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 03:43:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10906 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731139AbgF3HnJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 03:43:09 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200630074304epoutp04b9746c83a964dafb9287e543b8cc317c~dQoWKkqAS0736007360epoutp04B
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:43:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200630074304epoutp04b9746c83a964dafb9287e543b8cc317c~dQoWKkqAS0736007360epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593502984;
        bh=OyE6nCakjN8L2TXqjWPoLxfFg3bpeI7JuV8HbCeOFNM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vcbfoAZpPPBhSVutbqHBsNBvU/UpYvHOQrlTKfikhWSwTkSwHOFmMfFBPYGKVsGgV
         BUySFFTNXrTznkWYdDnhhkqpqbdv99wF/lrH+Z7s2CD1/WXoRxD0dHdQx6zuhGspds
         xR8nz0gXkaIKHqFTjVaCE4rPuQZTLj3CkQXfvS4U=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200630074303epcas5p32ef759ffbbf09c7c0f2ad71cec50deb4~dQoVlnqSh1977419774epcas5p3n;
        Tue, 30 Jun 2020 07:43:03 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8D.85.09467.70DEAFE5; Tue, 30 Jun 2020 16:43:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200630074302epcas5p3d0791c46509137e448c4cc610048bec7~dQoUlKlDN1977419774epcas5p3m;
        Tue, 30 Jun 2020 07:43:02 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200630074302epsmtrp228e13e67d0e4f4e02af8176a34428f50~dQoUkI-4X1041310413epsmtrp2b;
        Tue, 30 Jun 2020 07:43:02 +0000 (GMT)
X-AuditID: b6c32a49-a3fff700000024fb-d0-5efaed076f04
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E9.23.08303.60DEAFE5; Tue, 30 Jun 2020 16:43:02 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200630074300epsmtip101ce30976cb10709db63d8a7c976bcb7~dQoSY4SHy2852328523epsmtip1C;
        Tue, 30 Jun 2020 07:43:00 +0000 (GMT)
Date:   Tue, 30 Jun 2020 13:10:05 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "mb@lightnvm.io" <mb@lightnvm.io>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>,
        Arnav Dawn <a.dawn@samsung.com>
Subject: Re: [PATCH v2 1/2] fs,block: Introduce RWF_ZONE_APPEND and handling
 in direct IO path
Message-ID: <20200630074005.GA5701@test-zns>
MIME-Version: 1.0
In-Reply-To: <CY4PR04MB3751213DD4B370F58A63368BE76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7bCmhi77219xBpd2GVj83vaIxWLOqm2M
        Fqvv9rNZdP3bwmLR2v6NyeL0hEVMFu9az7FYPL7zmd1iyrQmRou9t7Qt9uw9yWJxedccNosV
        24+wWGz7PZ/Z4vWPk2wW5/8eZ3UQ8Ng56y67x+YVWh6Xz5Z6bPo0id2j++oPRo++LasYPT5v
        kvNoP9DN5LHpyVumAM4oLpuU1JzMstQifbsErow1P54wFRwUq1jU8YGlgfGtUBcjJ4eEgInE
        7ZvLWbsYuTiEBHYzSpxf8ogJwvnEKNH48Qo7hPOZUeLyyZeMXYwcYC1nvydDxHcxSnz+9x+q
        /RmjxIKdy1hA5rIIqEr8uX+NFaSBTUBT4sLkUpCwiICWxLJ978DqmQU+s0q03lnPBlIjLJAg
        sfazJ0gNr4COxMpXPxkhbEGJkzOfsICUcArESpw45gISFhVQljiw7TjYoRICdzgkvrwHuQHk
        HReJ789/s0DYwhKvjm9hh7ClJD6/28sGYRdL/LpzlBmiuYNR4nrDTKgGe4mLe/4ygdjMAhkS
        3d/fsUDYfBK9v58wQTzPK9HRBg06RYl7k55C7RWXeDhjCZTtIXFsfz8bJExmM0s8mfiSaQKj
        3Cwk/8xCsgLCtpLo/NDEOgtoBbOAtMTyfxwQpqbE+l36CxhZVzFKphYU56anFpsWGOallusV
        J+YWl+al6yXn525iBKc6Lc8djHcffNA7xMjEwXiIUYKDWUmE97TBrzgh3pTEyqrUovz4otKc
        1OJDjNIcLErivEo/zsQJCaQnlqRmp6YWpBbBZJk4OKUamFYLOJQ+eXvjhy9j4EPnabvexNmF
        sRt+2v7GTdhAWTff3s881PFIvE0F07YNrq++2umkM37p97rOsPC6pO1Z1dvxep1+566c0Z09
        o9t2Rs+nfTp37fsu9kq9OPKz0sI7e6fQlAKTbxODC7ZO+7f9uE/B4q1zNm/dsG/CteI7QSkz
        JjwRu1LdHfiq7IRKcmnFTf/9j0SbXv/+fd0g68e/eoupn/JW5OZqhZxb3V+efbXRe2l10ZGC
        hJydkaEaZR/rTt3kMfKpW7Rh2+xGMf+TfsXReRunrP5wd8FO/qlM67Is3fb1ei3Iz9Xffjmr
        VoLffpnj2zdsG5Zp5X3pO/k/NqSZX3KlBtPUGYcNJ6TpLlRiKc5INNRiLipOBADpryth5AMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsWy7bCSnC7b219xBhu+qlv83vaIxWLOqm2M
        Fqvv9rNZdP3bwmLR2v6NyeL0hEVMFu9az7FYPL7zmd1iyrQmRou9t7Qt9uw9yWJxedccNosV
        24+wWGz7PZ/Z4vWPk2wW5/8eZ3UQ8Ng56y67x+YVWh6Xz5Z6bPo0id2j++oPRo++LasYPT5v
        kvNoP9DN5LHpyVumAM4oLpuU1JzMstQifbsErozJTSwFn4UrJp64wNTAuFOgi5GDQ0LAROLs
        9+QuRi4OIYEdjBIv/t5m6mLkBIqLSzRf+8EOYQtLrPz3nB2i6AmjxJTjbYwgCRYBVYk/96+x
        ggxiE9CUuDC5FCQsIqAlsWzfO1aQemaBn6wSl35sYASpERZIkFj72ROkhldAR2Llq5+MEDNn
        M0vsa/zEDJEQlDg58wkLiM0sYCYxb/NDZpBeZgFpieX/OEBMToFYiRPHXEAqRAWUJQ5sO840
        gVFwFpLmWUiaZyE0L2BkXsUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERx5Wlo7GPes
        +qB3iJGJg/EQowQHs5II72mDX3FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeb/OWhgnJJCeWJKa
        nZpakFoEk2Xi4JRqYNI/Jhz6d9Ptpsu2DS0xH0JMQ0vPzbmga2Rh6M6/JyG632AJtwfzoY6v
        p30uvWC8wlj6h6MlQ+rgh/hZykVTFFZNjfr0UWryjZVFHyp03mVc8qhJyl7LHBNltuDU5Hld
        ElbfxLXsNzhniGtwnrqmb6H+b2nAev5Gya6jberse8zZc+SKHRWn97jn/jo0MeCQv5TNat7p
        73daJWyvzS7g6xU6/H3hi9XS/eXss5j7OH8ITglYyb9k7r0zO2R+/pgzIT/yaunjEiGrPfty
        toZsnS6lvn/+Vv9tt4LsdyTbnXJ2cV09p+5YTKevlIteQ8iio9EeMy/+iO27E719t/iujDNf
        AkUkNk96dPpxwfFMDiWW4oxEQy3mouJEADlCgVsrAwAA
X-CMS-MailID: 20200630074302epcas5p3d0791c46509137e448c4cc610048bec7
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----_kWsYTlEiWgRcgg3slXo3.6fqMwSg3MgpFIky2YSZcHasXdW=_adde7_"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85
References: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
        <CGME20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85@epcas5p2.samsung.com>
        <1593105349-19270-2-git-send-email-joshi.k@samsung.com>
        <CY4PR04MB37511FB1D3B3491A2CED5470E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
        <20200629183202.GA24003@test-zns>
        <CY4PR04MB3751213DD4B370F58A63368BE76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------_kWsYTlEiWgRcgg3slXo3.6fqMwSg3MgpFIky2YSZcHasXdW=_adde7_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Jun 30, 2020 at 12:37:07AM +0000, Damien Le Moal wrote:
>On 2020/06/30 3:35, Kanchan Joshi wrote:
>> On Fri, Jun 26, 2020 at 02:50:20AM +0000, Damien Le Moal wrote:
>>> On 2020/06/26 2:18, Kanchan Joshi wrote:
>>>> Introduce RWF_ZONE_APPEND flag to represent zone-append. User-space
>>>> sends this with write. Add IOCB_ZONE_APPEND which is set in
>>>> kiocb->ki_flags on receiving RWF_ZONE_APPEND.
>>>> Make direct IO submission path use IOCB_ZONE_APPEND to send bio with
>>>> append op. Direct IO completion returns zone-relative offset, in sector
>>>> unit, to upper layer using kiocb->ki_complete interface.
>>>> Report error if zone-append is requested on regular file or on sync
>>>> kiocb (i.e. one without ki_complete).
>>>>
>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
>>>> Signed-off-by: Arnav Dawn <a.dawn@samsung.com>
>>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
>>>> ---
>>>>  fs/block_dev.c          | 28 ++++++++++++++++++++++++----
>>>>  include/linux/fs.h      |  9 +++++++++
>>>>  include/uapi/linux/fs.h |  5 ++++-
>>>>  3 files changed, 37 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>>>> index 47860e5..5180268 100644
>>>> --- a/fs/block_dev.c
>>>> +++ b/fs/block_dev.c
>>>> @@ -185,6 +185,10 @@ static unsigned int dio_bio_write_op(struct kiocb *iocb)
>>>>  	/* avoid the need for a I/O completion work item */
>>>>  	if (iocb->ki_flags & IOCB_DSYNC)
>>>>  		op |= REQ_FUA;
>>>> +
>>>> +	if (iocb->ki_flags & IOCB_ZONE_APPEND)
>>>> +		op |= REQ_OP_ZONE_APPEND;
>>>
>>> This is wrong. REQ_OP_WRITE is already set in the declaration of "op". How can
>>> this work ?
>> REQ_OP_ZONE_APPEND will override the REQ_WRITE op, while previously set op
>> flags (REQ_FUA etc.) will be retained. But yes, this can be made to look
>> cleaner.
>> V3 will include the other changes you pointed out. Thanks for the review.
>>
>
>REQ_OP_WRITE and REQ_OP_ZONE_APPEND are different bits, so there is no
>"override". A well formed BIO bi_opf is one op+flags. Specifying multiple OP
>codes does not make sense.

one op+flags behavior is retained here. OP is not about bits (op flags are).
Had it been, REQ_OP_WRITE (value 1) can not be differentiated from
REQ_OP_ZONE_APPEND (value 13).
We do not do "bio_op(bio) & REQ_OP_WRITE", rather we look at the
absolute value "bio_op(bio) == REQ_OP_WRITE".

------_kWsYTlEiWgRcgg3slXo3.6fqMwSg3MgpFIky2YSZcHasXdW=_adde7_
Content-Type: text/plain; charset="utf-8"


------_kWsYTlEiWgRcgg3slXo3.6fqMwSg3MgpFIky2YSZcHasXdW=_adde7_--
