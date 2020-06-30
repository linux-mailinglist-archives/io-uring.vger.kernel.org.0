Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBE620F05B
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 10:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgF3ITy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 04:19:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32871 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730861AbgF3ITx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 04:19:53 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200630081947epoutp024a4bc045793c2eb13c472897a4bcfc2b~dRIZeVwGr1288412884epoutp02r
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 08:19:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200630081947epoutp024a4bc045793c2eb13c472897a4bcfc2b~dRIZeVwGr1288412884epoutp02r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593505187;
        bh=dX0FYDHshD/4zGJfTcc4+t2LjsR9tjhAB44sOSmgAmc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Cjnu/cgBJ2ihbsbozbaSpsj81xCkfPIvvVafF/x1gmSoJoFU0T77FeJjZKhoEJw4C
         c99SQ2NIBYLDXyFiKCjD7Sw6TAG66NTbNsYjki4nTBaJzml8zjdFfORTnhxSuONrgW
         t9TvYIkWY07l+WlMjpEVdF64dh9HL9Xk2b39RbFY=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200630081945epcas5p40380ad27e58f2ab4bbc202733f2c7f59~dRIYatnrD0326303263epcas5p4l;
        Tue, 30 Jun 2020 08:19:45 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3B.91.09475.1A5FAFE5; Tue, 30 Jun 2020 17:19:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200630081945epcas5p2b4e11af3deed14541cb5d7be7c87142f~dRIX3LFHK2545625456epcas5p2J;
        Tue, 30 Jun 2020 08:19:45 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200630081945epsmtrp1254a459dfb062293ae5f67e5a20457dc~dRIX2PU4t2572725727epsmtrp1Q;
        Tue, 30 Jun 2020 08:19:45 +0000 (GMT)
X-AuditID: b6c32a4b-39fff70000002503-a9-5efaf5a10d82
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        09.B3.08382.1A5FAFE5; Tue, 30 Jun 2020 17:19:45 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200630081942epsmtip106e29c3ceba5015773cebc742c2a9b50~dRIVrtLlG1232312323epsmtip1Q;
        Tue, 30 Jun 2020 08:19:42 +0000 (GMT)
Date:   Tue, 30 Jun 2020 13:46:48 +0530
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
Message-ID: <20200630081648.GB5701@test-zns>
MIME-Version: 1.0
In-Reply-To: <CY4PR04MB375162ABFFA5BB660869C57DE76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7bCmhu7Cr7/iDB6eN7L4ve0Ri8WcVdsY
        LVbf7Wez6Pq3hcWitf0bk8XpCYuYLN61nmOxeHznM7vFlGlNjBZ7b2lb7Nl7ksXi8q45bBYr
        th9hsdj2ez6zxesfJ9kszv89zuog4LFz1l12j80rtDwuny312PRpErtH99UfjB59W1Yxenze
        JOfRfqCbyWPTk7dMAZxRXDYpqTmZZalF+nYJXBkHFvexFyyQrfi6cBtbA+NBiS5GTg4JAROJ
        F68fM3UxcnEICexmlFi99wYjhPOJUWLdjLvMEM43RokPa5qYYVpurLzFApHYyygxbWkXE0hC
        SOAZo8SUTjsQm0VAVeLyo1fsXYwcHGwCmhIXJpeChEUEtCSW7XvHCtLLLPCZVaL1zno2kBph
        gQSJtZ89QWp4BXQk1r7dyghhC0qcnPmEBaSEUyBW4tcjsLCogLLEgW3Hwa6WELjDIdE9ZyEj
        xG0uEsevf2eCsIUlXh3fwg5hS0m87G+Dsoslft05ygzR3MEocb1hJgtEwl7i4p6/YM3MAhkS
        XevesELYfBK9v58wgRwhIcAr0dEmBFGuKHFv0lNWCFtc4uGMJVC2h8Sx/f1skPB5wiKx9MtE
        1gmMcrOQ/DMLyQoI20qi80MTkM0BZEtLLP/HAWFqSqzfpb+AkXUVo2RqQXFuemqxaYFxXmq5
        XnFibnFpXrpecn7uJkZwqtPy3sH46MEHvUOMTByMhxglOJiVRHhPG/yKE+JNSaysSi3Kjy8q
        zUktPsQozcGiJM6r9ONMnJBAemJJanZqakFqEUyWiYNTqoEpl92iiP8j3wkfg6hec4fTq705
        M0oWmqUYdrDzNzIannC3O1aYPOeTEIPK8otVs5wtLlnKK9dNjt60+qaX9dd7/hLzl7UEsO6d
        4Lnj3vXHvz7u3qhyIM/mWMKa4IuvZyzkZFaJ3Tg9kqXowjmWrEcyjD9UQiaLJSjNznt1+tn6
        r+qTqtRObpjm9m+OvfLqhz8Mu47s+r28g8m6SWhy28rY/X+6V7y8uTsokt1HT+v+x9rj0k65
        m19OjLJZY930/t2RcGG/w2vY9iQ41C2atKcu5rdttbjy/g+uGopCNlwdH928Q94usDTT2h7x
        Xb06IDThVe6JKSYhZd5PN+5gFXIzyneRSUjt1G9R23pKRl+JpTgj0VCLuag4EQD+MBEo5AMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWy7bCSnO7Cr7/iDP7v47X4ve0Ri8WcVdsY
        LVbf7Wez6Pq3hcWitf0bk8XpCYuYLN61nmOxeHznM7vFlGlNjBZ7b2lb7Nl7ksXi8q45bBYr
        th9hsdj2ez6zxesfJ9kszv89zuog4LFz1l12j80rtDwuny312PRpErtH99UfjB59W1Yxenze
        JOfRfqCbyWPTk7dMAZxRXDYpqTmZZalF+nYJXBmvm++zFVySqnh25wpzA2OvWBcjJ4eEgInE
        jZW3WLoYuTiEBHYzSqyY+5sZIiEu0XztBzuELSyx8t9zdoiiJ4wSE1ZNZgVJsAioSlx+9Aoo
        wcHBJqApcWFyKUhYREBLYtm+d6wg9cwCP1klLv3YwAhSIyyQILH2sydIDa+AjsTat1sZoWay
        SDSsW8QEkRCUODnzCQuIzSxgJjFv80NmkF5mAWmJ5f84QExOgViJX48YQSpEBZQlDmw7zjSB
        UXAWkuZZSJpnITQvYGRexSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHH1amjsYt6/6
        oHeIkYmD8RCjBAezkgjvaYNfcUK8KYmVValF+fFFpTmpxYcYpTlYlMR5bxQujBMSSE8sSc1O
        TS1ILYLJMnFwSjUwLdIrM53fd/a5Vf064U/m3Mu71Fon6ykdz9z5u8euu9jlZVHdgkIDidZ1
        Pn83s508qXdtsq2w8oQ5l7e6iU5p0Hdf++Gxos58nmc7Zj04trN1T+WbPsGemCTRYI4D58X/
        zg/bfFmglUWmsWH/1q3Muz/P+cTo2zW9RuLDw6m5Cm+eLNS+HXSVe4/1S4YktnqFlv/3appk
        DbgOv74rs+5dakFuT1KqyrlnN9f0f1/xcWrzldxAp3VcN9unT5H0jpRgjZz9PjdwTsfGVXNv
        aD6IiHq6yfpQ4aY/r26bsi9j/ru05ODSq6bHlkh/0v7XaDhtQfFV/V4VF5tcMf2nzrIJRtlq
        cgwhriy/zwrf5nU6p8RSnJFoqMVcVJwIAF+M/2wtAwAA
X-CMS-MailID: 20200630081945epcas5p2b4e11af3deed14541cb5d7be7c87142f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_ae588_"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85
References: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
        <CGME20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85@epcas5p2.samsung.com>
        <1593105349-19270-2-git-send-email-joshi.k@samsung.com>
        <CY4PR04MB37511FB1D3B3491A2CED5470E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
        <20200629183202.GA24003@test-zns>
        <CY4PR04MB3751213DD4B370F58A63368BE76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
        <20200630074005.GA5701@test-zns>
        <CY4PR04MB37517AAE0B475F631C81B404E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
        <CY4PR04MB375162ABFFA5BB660869C57DE76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_ae588_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Jun 30, 2020 at 07:56:46AM +0000, Damien Le Moal wrote:
>On 2020/06/30 16:53, Damien Le Moal wrote:
>> On 2020/06/30 16:43, Kanchan Joshi wrote:
>>> On Tue, Jun 30, 2020 at 12:37:07AM +0000, Damien Le Moal wrote:
>>>> On 2020/06/30 3:35, Kanchan Joshi wrote:
>>>>> On Fri, Jun 26, 2020 at 02:50:20AM +0000, Damien Le Moal wrote:
>>>>>> On 2020/06/26 2:18, Kanchan Joshi wrote:
>>>>>>> Introduce RWF_ZONE_APPEND flag to represent zone-append. User-space
>>>>>>> sends this with write. Add IOCB_ZONE_APPEND which is set in
>>>>>>> kiocb->ki_flags on receiving RWF_ZONE_APPEND.
>>>>>>> Make direct IO submission path use IOCB_ZONE_APPEND to send bio with
>>>>>>> append op. Direct IO completion returns zone-relative offset, in sector
>>>>>>> unit, to upper layer using kiocb->ki_complete interface.
>>>>>>> Report error if zone-append is requested on regular file or on sync
>>>>>>> kiocb (i.e. one without ki_complete).
>>>>>>>
>>>>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>>>>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
>>>>>>> Signed-off-by: Arnav Dawn <a.dawn@samsung.com>
>>>>>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>>>>>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
>>>>>>> ---
>>>>>>>  fs/block_dev.c          | 28 ++++++++++++++++++++++++----
>>>>>>>  include/linux/fs.h      |  9 +++++++++
>>>>>>>  include/uapi/linux/fs.h |  5 ++++-
>>>>>>>  3 files changed, 37 insertions(+), 5 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>>>>>>> index 47860e5..5180268 100644
>>>>>>> --- a/fs/block_dev.c
>>>>>>> +++ b/fs/block_dev.c
>>>>>>> @@ -185,6 +185,10 @@ static unsigned int dio_bio_write_op(struct kiocb *iocb)
>>>>>>>  	/* avoid the need for a I/O completion work item */
>>>>>>>  	if (iocb->ki_flags & IOCB_DSYNC)
>>>>>>>  		op |= REQ_FUA;
>>>>>>> +
>>>>>>> +	if (iocb->ki_flags & IOCB_ZONE_APPEND)
>>>>>>> +		op |= REQ_OP_ZONE_APPEND;
>>>>>>
>>>>>> This is wrong. REQ_OP_WRITE is already set in the declaration of "op". How can
>>>>>> this work ?
>>>>> REQ_OP_ZONE_APPEND will override the REQ_WRITE op, while previously set op
>>>>> flags (REQ_FUA etc.) will be retained. But yes, this can be made to look
>>>>> cleaner.
>>>>> V3 will include the other changes you pointed out. Thanks for the review.
>>>>>
>>>>
>>>> REQ_OP_WRITE and REQ_OP_ZONE_APPEND are different bits, so there is no
>>>> "override". A well formed BIO bi_opf is one op+flags. Specifying multiple OP
>>>> codes does not make sense.
>>>
>>> one op+flags behavior is retained here. OP is not about bits (op flags are).
>>> Had it been, REQ_OP_WRITE (value 1) can not be differentiated from
>>> REQ_OP_ZONE_APPEND (value 13).
>>> We do not do "bio_op(bio) & REQ_OP_WRITE", rather we look at the
>>> absolute value "bio_op(bio) == REQ_OP_WRITE".
>>
>> Sure, the ops are not bits like the flags, but (excluding the flags) doing:
>>
>> op |= REQ_OP_ZONE_APPEND;
>>
>> will give you op == (REQ_OP_WRITE | REQ_OP_ZONE_APPEND). That's not what you want...
>
>And yes, REQ_OP_WRITE | REQ_OP_ZONE_APPEND == REQ_OP_ZONE_APPEND... But still
>not a reason for not setting the op correctly :)
Right, this is what op override was about, and intent was to minimize
the changes in the existing function. As said before, completely agree about
changing, code should not draw suspicion. 

------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_ae588_
Content-Type: text/plain; charset="utf-8"


------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_ae588_--
