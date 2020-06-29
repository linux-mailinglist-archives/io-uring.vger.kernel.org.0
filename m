Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5994120D0AC
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 20:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgF2SfJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 14:35:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63878 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgF2SfF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 14:35:05 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200629183500epoutp015adeb389b939229751e238b6190b0116~dF4RqBjdu1331313313epoutp01n
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 18:35:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200629183500epoutp015adeb389b939229751e238b6190b0116~dF4RqBjdu1331313313epoutp01n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593455700;
        bh=GOb5F6IEPqqUzppfmpm5q/EtUDLSZpl8Hl/nDzpT/II=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s2IxXCxlP0DxRQWjQCAElJjGgGLZwVziDdmjh6WwL1NUfVg7PtLaxqxPj1yS/b9Jq
         6K3jcZ/sVaZ4EPg5JmlFC/cvjxywO9MEnxDx/ErMuDRGPqlEnZc2N1z8LPV9jaQMkq
         //6kLW40RNAyxr4Aewxvu0iXbnU0qA2JxQ4N7SZk=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200629183459epcas5p3e5d54b1bd9edce6f19f739b187e730bb~dF4Q0gKG30377803778epcas5p3y;
        Mon, 29 Jun 2020 18:34:59 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DB.07.09703.3543AFE5; Tue, 30 Jun 2020 03:34:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200629183459epcas5p464fdcdf272ea360bcd50901ccc79ca6e~dF4QV4RQj0162001620epcas5p4P;
        Mon, 29 Jun 2020 18:34:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200629183459epsmtrp29abb784126e5b438d6071a9f61937274~dF4QU9PJ80229002290epsmtrp2j;
        Mon, 29 Jun 2020 18:34:59 +0000 (GMT)
X-AuditID: b6c32a4a-4b5ff700000025e7-6e-5efa34533fce
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A1.55.08303.3543AFE5; Tue, 30 Jun 2020 03:34:59 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200629183456epsmtip268cd4e9ea0911be74ab0ec579850ff0c~dF4OJ4uE21597515975epsmtip2a;
        Mon, 29 Jun 2020 18:34:56 +0000 (GMT)
Date:   Tue, 30 Jun 2020 00:02:02 +0530
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
Message-ID: <20200629183202.GA24003@test-zns>
MIME-Version: 1.0
In-Reply-To: <CY4PR04MB37511FB1D3B3491A2CED5470E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7bCmum6wya84g20vVC1+b3vEYjFn1TZG
        i9V3+9ksuv5tYbFobf/GZHF6wiImi3et51gsHt/5zG4xZVoTo8XeW9oWe/aeZLG4vGsOm8WK
        7UdYLLb9ns9s8frHSTaL83+PszoIeOycdZfdY/MKLY/LZ0s9Nn2axO7RffUHo0ffllWMHp83
        yXm0H+hm8tj05C1TAGcUl01Kak5mWWqRvl0CV8ah8xuYC+YJVqxceo+xgXEXXxcjJ4eEgInE
        wqurmLsYuTiEBHYzSjxesJcFwvnEKLF54QVWCOczo0Tnne0sMC3fH74Es4UEdjFKfN7OAVH0
        jFHi2L5XrCAJFgFViWW/O9i6GDk42AQ0JS5MLgUJiwhoSSzb9w5sKLPAZ1aJ1jvrwWqEBRIk
        1n72BKnhFdCVmP20iQXCFpQ4OfMJmM0pECvx+NBuMFtUQFniwLbjTCBzJARucEhMn70N6jgX
        ibN/HkHZwhKvjm9hh7ClJD6/28sGYRdL/LpzlBmiuYNR4nrDTKgGe4mLe/4ygdjMAhkSC6Zc
        hLL5JHp/P2ECOVRCgFeio00IolxR4t6kp6wQtrjEwxlLoGwPiWP7+9kgAbSESeLK9KIJjHKz
        kPwzC8kGCNtKovNDE+ssoA3MAtISy/9xQJiaEut36S9gZF3FKJlaUJybnlpsWmCUl1quV5yY
        W1yal66XnJ+7iRGc6rS8djA+fPBB7xAjEwfjIUYJDmYlEd7TBr/ihHhTEiurUovy44tKc1KL
        DzFKc7AoifMq/TgTJySQnliSmp2aWpBaBJNl4uCUamBauZNXf6/s58OZcRmpPrzCgi+uvght
        WJd37p6TBtOZ3aYvGb68yzLe6L//XHmI1eu/PRrHDAsy1LWDPV46vDMS6DvAkLAwf17c1rN3
        Jnw/4mBZHWk+4UH65leh/9sPP7r/PFf+84U1EWG2V7VPKP/W3vTwQ+keJcFtO3bn/jOwmm6X
        I7vplNdtiek+S6q8nRef5jgVVzGjm+nkGbPj6jrLxbVnqt/nXH/vYkbQa5FNN/f5vFthECC6
        +vu6iGjNwgTezGNPb6wtnd75m5Ox1P1zmahCk83jW/aHGPItmEs3q6eslWXxM9vDvVJPrTU0
        rtXitqPNXvHNAR9u+xQlSz6KiDG9Vejkxfuqp3xZcL4SS3FGoqEWc1FxIgCanNv45AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWy7bCSvG6wya84g7fX2S1+b3vEYjFn1TZG
        i9V3+9ksuv5tYbFobf/GZHF6wiImi3et51gsHt/5zG4xZVoTo8XeW9oWe/aeZLG4vGsOm8WK
        7UdYLLb9ns9s8frHSTaL83+PszoIeOycdZfdY/MKLY/LZ0s9Nn2axO7RffUHo0ffllWMHp83
        yXm0H+hm8tj05C1TAGcUl01Kak5mWWqRvl0CV0bz5EbGggt8FRdmvWNpYGzj6WLk5JAQMJH4
        /vAlSxcjF4eQwA5GiUWv5rNAJMQlmq/9YIewhSVW/nvODlH0hFHizJKTTCAJFgFViWW/O9i6
        GDk42AQ0JS5MLgUJiwhoSSzb944VpJ5Z4CerxKUfGxhBaoQFEiTWfvYEqeEV0JWY/bQJavES
        JomLH+6zQSQEJU7OfAJ2BLOAmcS8zQ+ZQXqZBaQllv/jAAlzCsRKPD60G6xEVEBZ4sC240wT
        GAVnIemehaR7FkL3AkbmVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwfGnpbWDcc+q
        D3qHGJk4GA8xSnAwK4nwnjb4FSfEm5JYWZValB9fVJqTWnyIUZqDRUmc9+ushXFCAumJJanZ
        qakFqUUwWSYOTqkGJjbJG7cM+jIOWtrnMTw7aMCbOivG5RObtItF8CZDLhMFj05fsWXO6xfM
        cpBYExTwRjrh0fc0V2eWNQmhlQ55DEUrb64Qm/7wX2arFneq88TLr5dyy6pX+DtPm8u2/Upc
        3P8mmxypK/8kijslOfcEP/LhibU1WMQh076vxLMhefqTlIuZBqJzM1uaNFtz4w0etOWULJX3
        sW7YWanv/vgGr9vO3YX+xSucqv5PzXr05UMtJ0eEwt7QHaK79gud2arydN5spp/3JXfw96R9
        rjrBofVQ6rXEmXO8+RUzFarjygV/Km0WTReYcSJHrifUy5BPRHi6QaTX+uqau027lbQXcfld
        le9fqCv2O+LEbSWW4oxEQy3mouJEAFK+Z2ouAwAA
X-CMS-MailID: 20200629183459epcas5p464fdcdf272ea360bcd50901ccc79ca6e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_aa309_"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85
References: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
        <CGME20200625171834epcas5p226a24dfcb84cfa83fe29a2bd17795d85@epcas5p2.samsung.com>
        <1593105349-19270-2-git-send-email-joshi.k@samsung.com>
        <CY4PR04MB37511FB1D3B3491A2CED5470E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_aa309_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Jun 26, 2020 at 02:50:20AM +0000, Damien Le Moal wrote:
>On 2020/06/26 2:18, Kanchan Joshi wrote:
>> Introduce RWF_ZONE_APPEND flag to represent zone-append. User-space
>> sends this with write. Add IOCB_ZONE_APPEND which is set in
>> kiocb->ki_flags on receiving RWF_ZONE_APPEND.
>> Make direct IO submission path use IOCB_ZONE_APPEND to send bio with
>> append op. Direct IO completion returns zone-relative offset, in sector
>> unit, to upper layer using kiocb->ki_complete interface.
>> Report error if zone-append is requested on regular file or on sync
>> kiocb (i.e. one without ki_complete).
>>
>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
>> Signed-off-by: Arnav Dawn <a.dawn@samsung.com>
>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
>> ---
>>  fs/block_dev.c          | 28 ++++++++++++++++++++++++----
>>  include/linux/fs.h      |  9 +++++++++
>>  include/uapi/linux/fs.h |  5 ++++-
>>  3 files changed, 37 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>> index 47860e5..5180268 100644
>> --- a/fs/block_dev.c
>> +++ b/fs/block_dev.c
>> @@ -185,6 +185,10 @@ static unsigned int dio_bio_write_op(struct kiocb *iocb)
>>  	/* avoid the need for a I/O completion work item */
>>  	if (iocb->ki_flags & IOCB_DSYNC)
>>  		op |= REQ_FUA;
>> +
>> +	if (iocb->ki_flags & IOCB_ZONE_APPEND)
>> +		op |= REQ_OP_ZONE_APPEND;
>
>This is wrong. REQ_OP_WRITE is already set in the declaration of "op". How can
>this work ?
REQ_OP_ZONE_APPEND will override the REQ_WRITE op, while previously set op
flags (REQ_FUA etc.) will be retained. But yes, this can be made to look
cleaner.
V3 will include the other changes you pointed out. Thanks for the review.


------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_aa309_
Content-Type: text/plain; charset="utf-8"


------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_aa309_--
