Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6C750B28D
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 10:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445449AbiDVIFY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 04:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445447AbiDVIFW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 04:05:22 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6BD527CA
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 01:02:27 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220422080223epoutp0161c887fd9802da056436afa66e606ff0~oKS6s5hl93177931779epoutp01b
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 08:02:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220422080223epoutp0161c887fd9802da056436afa66e606ff0~oKS6s5hl93177931779epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1650614543;
        bh=qvC6U5XQAed16ncQMRpoN5eTEk3Cxt5oi9kVbMzo9Uk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U/dEUJozUsBR12fpgD81n6HFw1Ez/vXU3Xpt99lEwRnAY99Z7lCPvR561/gf95RFR
         DpMbvR3cBxHCzFeJQeHsL1RhEcdWICtYSH60IICUGLjyGAJKfi1zZ3/Z392Ta13B3Z
         Q1WdM1zhtghFHwszryz5KKQrjXm6zp5MQ0bYVyXE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220422080223epcas5p1b78cc67d9cd30f5908afed47a4a1df85~oKS6d8R2f2354623546epcas5p1t;
        Fri, 22 Apr 2022 08:02:23 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Kl6MH2NtTz4x9QN; Fri, 22 Apr
        2022 08:02:19 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        70.84.12523.B0162626; Fri, 22 Apr 2022 17:02:19 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220422052335epcas5p4cba87896faca5be8818015f883b63041~oIIRCj-H21476214762epcas5p43;
        Fri, 22 Apr 2022 05:23:35 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220422052335epsmtrp28bc2dc2ee7aad5344bd38634b48afc34~oIIRB6TOy0790707907epsmtrp2b;
        Fri, 22 Apr 2022 05:23:35 +0000 (GMT)
X-AuditID: b6c32a4a-5b7ff700000030eb-44-6262610b10e7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6A.3A.24342.7DB32626; Fri, 22 Apr 2022 14:23:35 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220422052334epsmtip2d8a9359f6a3e9eb95a389cb2686833ff~oIIQGcy0x0732407324epsmtip2c;
        Fri, 22 Apr 2022 05:23:34 +0000 (GMT)
Date:   Fri, 22 Apr 2022 10:48:27 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v1 01/11] io_uring: support CQE32 in io_uring_cqe
Message-ID: <20220422051827.GC14949@test-zns>
MIME-Version: 1.0
In-Reply-To: <CA+1E3rLem2p+FMhni3DLek5Bcwt_HtYRFmfuQirdRhBEz=Qabg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmk+LIzCtJLcpLzFFi42LZdlhTU5c7MSnJoGWfgMXqu/1sFu9az7FY
        nH97mMniWN97VourLw+wO7B6TGx+x+6xc9Zddo/LZ0s9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/J
        zEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqrpFCWmFMKFApILC5W0rezKcov
        LUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOmDftNlvBGeGK13dmsDQw
        TuLvYuTkkBAwkTj08ixTFyMXh5DAbkaJt/+mMkI4nxglnt/uYoFwvjFKbHnTygbT8u3MITaI
        xF5GibtN16BanjFKLDn3gBmkikVAVWLnhHtAVRwcbAKaEhcml4KERQTUJb6sn8gIYjML5Ehs
        e3kBbKiwgKvE+ZOrweK8AroSCx9OgbIFJU7OfMICYnMKBEpsfH0WbLyogLLEgW3Hwe6WEHjJ
        LtHWuIQF4joXiX2znjBB2MISr45vYYewpSQ+v9sL9UGyROv2y+wgt0kIlEgsWaAOEbaXuLjn
        LxPEbRkSD46uZ4aIy0pMPbUOKs4n0fsbZjyvxI55MLaixL1JT1khbHGJhzOWQNkeEteXXGeH
        hM8XRokf+54zTWCUn4Xkt1lI9kHYVhKdH5pYZwGdxywgLbH8HweEqSmxfpf+AkbWVYySqQXF
        uempxaYFRnmp5fAIT87P3cQITpVaXjsYHz74oHeIkYmD8RCjBAezkghv6Mz4JCHelMTKqtSi
        /Pii0pzU4kOMpsComsgsJZqcD0zWeSXxhiaWBiZmZmYmlsZmhkrivKfTNyQKCaQnlqRmp6YW
        pBbB9DFxcEo1MM0Xu7T8zJoXnNtcDjq8b8/MW7r70Oblj5QWe2UwcSh6Z3XNkLhe/1y4Sd/I
        1zxz1nvBqndMx833LZXuswjLmb5X9h3T/DS3/nOFG7P2SV5Py1DLTVr2MzTolrrwOcWDTB+n
        z03nnnGp2Gyu6eNFxyO+Fjz8kTJPwqvvNcuOB+cMny7Pj+WusLb98LLXWe9ISYKzxOzdiiW/
        s3e8u/de8aTthd/akzZOZeu7+0Lywu1my0dTV/21tDrz6c1Bo+6EKwprXl17ZebbG28zVebN
        4aezJE5eu3sj9X5irHSbfMiDApGL5b/6Em9ctFoSEPnucJfhVDWG3PD9kXs281f0L1ePTXt8
        MkC40a0uifv7DEYlluKMREMt5qLiRADtFDshHgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWy7bCSvO5166Qkg13XtSxW3+1ns3jXeo7F
        4vzbw0wWx/res1pcfXmA3YHVY2LzO3aPnbPusntcPlvq8XmTXABLFJdNSmpOZllqkb5dAlfG
        9pZ7TAX/BCq2duxib2C8x9PFyMkhIWAi8e3MIbYuRi4OIYHdjBKXjnxngkiISzRf+8EOYQtL
        rPz3nB2i6AmjxL5PT1lBEiwCqhI7J9wD6ubgYBPQlLgwuRQkLCKgLvFl/URGEJtZIEdi28sL
        bCC2sICrxPmTq8HivAK6EgsfTmGEmPmFUaJ9110WiISgxMmZT1ggms0k5m1+yAwyn1lAWmL5
        Pw6QMKdAoMTG12eZQWxRAWWJA9uOM01gFJyFpHsWku5ZCN0LGJlXMUqmFhTnpucWGxYY5qWW
        6xUn5haX5qXrJefnbmIEh7iW5g7G7as+6B1iZOJgPMQowcGsJMIbOjM+SYg3JbGyKrUoP76o
        NCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQamZr7ue0K2rtyu8537lln9SPJx
        8HGcH2/wYIWsjJ30f5eG6JeeLTYWTD/qK/8ZlpjvM04L2rxfICZz35RtyU9late95u9Zdj/8
        rJ2H4TXbpIV/XwRLHBAy2Prw1uaNkzVmzvlzrDrPeaZtm2NAfNyK8A894W/b9816/8K9eGXK
        keBbGx2Wd5Z+m9KclB7ar5HU29i2t3Cl8CNpjgUXt9l2f+jvYwpP4lkdFP7x0R65lNWXJM2/
        nFtd9CRTsHpTpUnlhl9Xn97h3G3MbTJdoMAyWmS6dJTMfeWLk5z4eOLu8FRsKokxVVd32rpk
        Vv+7lL+ue17OTzJhsLfXTQlkiF+8e9snnbPBE06cvdS2hU2JpTgj0VCLuag4EQAqqdh34AIA
        AA==
X-CMS-MailID: 20220422052335epcas5p4cba87896faca5be8818015f883b63041
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----9xePhvBs7L.CmQYP2EuM5i8QaKGj7GHgcW4toGXxqW8MJ5yL=_9f168_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220422015157epcas5p1b55ef38322371b8a301833c8b38cdc38
References: <20220419205624.1546079-1-shr@fb.com>
        <20220419205624.1546079-2-shr@fb.com>
        <CGME20220422015157epcas5p1b55ef38322371b8a301833c8b38cdc38@epcas5p1.samsung.com>
        <CA+1E3rLem2p+FMhni3DLek5Bcwt_HtYRFmfuQirdRhBEz=Qabg@mail.gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------9xePhvBs7L.CmQYP2EuM5i8QaKGj7GHgcW4toGXxqW8MJ5yL=_9f168_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Apr 22, 2022 at 07:21:12AM +0530, Kanchan Joshi wrote:
>On Thu, Apr 21, 2022 at 12:02 PM Stefan Roesch <shr@fb.com> wrote:
>>
>> This adds the struct io_uring_cqe_extra in the structure io_uring_cqe to
>> support large CQE's.
>>
>> Co-developed-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  include/uapi/linux/io_uring.h | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index ee677dbd6a6d..6f9f9b6a9d15 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -111,6 +111,7 @@ enum {
>>  #define IORING_SETUP_R_DISABLED        (1U << 6)       /* start with ring disabled */
>>  #define IORING_SETUP_SUBMIT_ALL        (1U << 7)       /* continue submit on error */
>>  #define IORING_SETUP_SQE128    (1U << 8)       /* SQEs are 128b */
>> +#define IORING_SETUP_CQE32     (1U << 9)       /* CQEs are 32b */
>>
>>  enum {
>>         IORING_OP_NOP,
>> @@ -201,6 +202,11 @@ enum {
>>  #define IORING_POLL_UPDATE_EVENTS      (1U << 1)
>>  #define IORING_POLL_UPDATE_USER_DATA   (1U << 2)
>>
>> +struct io_uring_cqe_extra {
>> +       __u64   extra1;
>> +       __u64   extra2;
>> +};
>> +
>>  /*
>>   * IO completion data structure (Completion Queue Entry)
>>   */
>> @@ -208,6 +214,12 @@ struct io_uring_cqe {
>>         __u64   user_data;      /* sqe->data submission passed back */
>>         __s32   res;            /* result code for this event */
>>         __u32   flags;
>> +
>> +       /*
>> +        * If the ring is initialized with IORING_SETUP_CQE32, then this field
>> +        * contains 16-bytes of padding, doubling the size of the CQE.
>> +        */
>> +       struct io_uring_cqe_extra       b[0];
>>  };
>Will it be any better to replace struct b[0]  with "u64 extra[ ]" ?
>With that new fields will be referred as cqe->extra[0] and cqe->extra[1].
>
>And if we go that route, maybe "aux" sounds better than "extra".

sorry, picked v1 (rather than v2) here. This part in same though.

------9xePhvBs7L.CmQYP2EuM5i8QaKGj7GHgcW4toGXxqW8MJ5yL=_9f168_
Content-Type: text/plain; charset="utf-8"


------9xePhvBs7L.CmQYP2EuM5i8QaKGj7GHgcW4toGXxqW8MJ5yL=_9f168_--
