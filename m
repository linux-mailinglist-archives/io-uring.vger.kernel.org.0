Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF160218E11
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 19:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgGHRQc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 13:16:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36342 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgGHRQb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 13:16:31 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200708171629epoutp03a445f3986f465e55a856e8e282a306bb~f1nSfZQc70185701857epoutp03i
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 17:16:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200708171629epoutp03a445f3986f465e55a856e8e282a306bb~f1nSfZQc70185701857epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594228589;
        bh=cZw9uZ/B94t2YKJtaGtYKp2wPZ7theQ3oHVkcgqIa8A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LORxdn5j8CSVPSOVBEb9zJkzfy/P5yQc+KIQ2qUFrTd3SguIwD6ovDEY+/jY6IepJ
         jljSEI+g3di9TdZjQ77C5yDDAwem6IP7fa91Z9jN4dKsP/WTVl8n6RzLKB2HN+CTXd
         TP3FZgxYuSsRtHrmlQiSauhXIZCrjPlQDpG3W++I=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200708171628epcas5p124f3b7ca4c149e7e6c037eb5c8c25458~f1nRz-8Pg2838928389epcas5p1o;
        Wed,  8 Jul 2020 17:16:28 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2B.4B.09467.C6FF50F5; Thu,  9 Jul 2020 02:16:28 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200708171600epcas5p4a8494e7dcb887a7f1f39492007b3b78c~f1m3kn-U_0927809278epcas5p4U;
        Wed,  8 Jul 2020 17:16:00 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200708171600epsmtrp2f9d5e955264893831a5c37846de7cc39~f1m3jsuZ70366303663epsmtrp2Q;
        Wed,  8 Jul 2020 17:16:00 +0000 (GMT)
X-AuditID: b6c32a49-a29ff700000024fb-96-5f05ff6ca0f1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A8.15.08303.05FF50F5; Thu,  9 Jul 2020 02:16:00 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200708171558epsmtip2b1b0a9859675abb5073230211ffdb391~f1m1PKiQU2709227092epsmtip2x;
        Wed,  8 Jul 2020 17:15:57 +0000 (GMT)
Date:   Wed, 8 Jul 2020 22:43:02 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>,
        viro@zeniv.linux.org.uk, bcrl@kvack.org, hch@infradead.org,
        damien.lemoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200708171302.GB26480@test-zns>
MIME-Version: 1.0
In-Reply-To: <481e512a-0dd3-ae19-8f32-ed781af28038@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsWy7bCmum7Of9Z4g6OPVC3mrNrGaLH6bj+b
        Rde/LSwWre3fmCxOT1jEZPGu9RyLxeM7n9ktOk9fYLKYMq2J0WLvLW2LPXtPslhc3jWHzWLF
        9iMsFtt+z2e2eP3jJJvF+b/HWS1+/5jD5iDosXPWXXaPzSu0PJoX3GHxuHy21GPTp0nsHt1X
        fzB69G1ZxejxeZOcR/uBbiaPTU/eMgVwRXHZpKTmZJalFunbJXBlfDmfX7CXv2Lxo2OMDYy3
        eLoYOTgkBEwkdn8M6GLk4hAS2M0ocevHHHYI5xOjxOL385ghnM+MEn9XbGDqYuQE67h47Toj
        RGIXo8Sjhy+YIJxnjBJvf9xnBpnLIqAi8WSbEYjJJqApcWFyKUiviICCRM/vlWwg5cwCL5kl
        mjeDDOLkEBZwlPi88ySYzSugK/Fi6V92CFtQ4uTMJywgNqeArcTOpQfAbFEBZYkD245DHfSD
        Q+LbAj4I20Xi16S57BC2sMSr41ugbCmJz+/2skHYxRK/7hwF+0xCoINR4nrDTBaIhL3ExT1/
        mUCOZhbIkOh8UAsRlpWYemod2C5mAT6J3t9PoPbySuyYB2MrStyb9JQVwhaXeDhjCZTtIfF/
        92xoKK5gktiz6jHzBEb5WUh+m4WwbhbYCiuJzg9NrBC2vETz1tnMECXSEsv/cUCYmhLrd+kv
        YGRbxSiZWlCcm55abFpgmJdarlecmFtcmpeul5yfu4kRnCq1PHcw3n3wQe8QIxMH4yFGCQ5m
        JRFeA0XWeCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8Sj/OxAkJpCeWpGanphakFsFkmTg4pRqY
        Kg+Yvvhz44bfWrvqp/eUXsWZ6Zh5ae+e8rQysrDewW358y9Z361qkkU2L7T5VM606ih3tcWC
        En7vre08JbGPLpS/Kaz3L4iYyXdlksLiGY0HPN4VfJsRvEk0+BBHJJ/VEiPXzJ1CF/UYkq44
        r5smyFOUG3T4GPOW6+yT5dzWnvgsWpDy7vw288ln3kbcvZRwKz35wrFFtZdPJF3tmNR8685t
        3t7uxx8XqRiL3tr+5vWOtAMKvG7SvYfDd6X/Kc4xy2W2dxCuXyR8Kfrd3UCnDI2Ono9Z22/e
        2JMQ5fpQV1ZDznfT7AkPL3RdiQy58uN1bFeS5RxjhUTJdXO8io4unVAv/8u3d4v8vpMPLIsD
        lViKMxINtZiLihMBjbWFdAQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWy7bCSvG7Af9Z4g8kPpSzmrNrGaLH6bj+b
        Rde/LSwWre3fmCxOT1jEZPGu9RyLxeM7n9ktOk9fYLKYMq2J0WLvLW2LPXtPslhc3jWHzWLF
        9iMsFtt+z2e2eP3jJJvF+b/HWS1+/5jD5iDosXPWXXaPzSu0PJoX3GHxuHy21GPTp0nsHt1X
        fzB69G1ZxejxeZOcR/uBbiaPTU/eMgVwRXHZpKTmZJalFunbJXBl3L3TwlZwjqfiw53qBsYO
        ri5GTg4JAROJi9euM3YxcnEICexglLhy7CgrREJcovnaD3YIW1hi5b/n7BBFTxglOv8uBurg
        4GARUJF4ss0IxGQT0JS4MLkUpFxEQEGi5/dKNpByZoH3zBIvzmxhA0kICzhKfN55khHE5hXQ
        lXix9C/UzBVMEg//zIdKCEqcnPmEBcRmFjCTmLf5ITPIAmYBaYnl/zggwvISzVtnM4PYnAK2
        EjuXHgArFxVQljiw7TjTBEahWUgmzUIyaRbCpFlIJi1gZFnFKJlaUJybnltsWGCUl1quV5yY
        W1yal66XnJ+7iREcwVpaOxj3rPqgd4iRiYPxEKMEB7OSCK+BImu8EG9KYmVValF+fFFpTmrx
        IUZpDhYlcd6vsxbGCQmkJ5akZqemFqQWwWSZODilGpiMV5gJqrxfk7bOYKK6sYn4jU62d9dU
        dcsbVi9bfNnfhL2Bx35h+uL3ZzgMp03MW3p9/vNXs/1d1ugt9PH+ZHqYbdneIDP+jzG6HD5c
        fvYLjmptKTXZvVdgfVL5j72tP7Ya8rfdskzYKb0yk6PQVsZw7nct40mKq8OeyNz4a+LuwG0v
        Ybb4vfNx5y81xxVMnbovh75YXerLt/xfnscHpuSrz68lS0cw634LXb2DeWY+Z+JZ/dveMo68
        5hNMMipOF17gFa0OnnvO+u3VwM9lLXKT3NoOz/UrPHFalenfmbwAlZNfzpooxG874Ou3Sphh
        qo5Te8WeB0vOfrbcNPtC9FH5qW5HpMP/GvywehA48YESS3FGoqEWc1FxIgCqDvw8TwMAAA==
X-CMS-MailID: 20200708171600epcas5p4a8494e7dcb887a7f1f39492007b3b78c
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_e97d3_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200708163850epcas5p36f1f61ee4d77d31dc34c3bbe1d19f6fd
References: <33b9887b-eaba-c7be-5dfd-fc7e7d416f48@kernel.dk>
        <36C0AD99-0D75-40D4-B704-507A222AEB81@javigon.com>
        <20200708163327.GU25523@casper.infradead.org>
        <CGME20200708163850epcas5p36f1f61ee4d77d31dc34c3bbe1d19f6fd@epcas5p3.samsung.com>
        <481e512a-0dd3-ae19-8f32-ed781af28038@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_e97d3_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Wed, Jul 08, 2020 at 10:38:44AM -0600, Jens Axboe wrote:
>On 7/8/20 10:33 AM, Matthew Wilcox wrote:
>> On Wed, Jul 08, 2020 at 06:08:12PM +0200, Javier González wrote:
>>>> I just wanted to get clarification there, because to me it sounded like
>>>> you expected Kanchan to do it, and Kanchan assuming it "was sorted". I'd
>>>> consider that a prerequisite for the append series as far as io_uring is
>>>> concerned, hence _someone_ needs to actually do it ;-)
>>
>> I don't know that it's a prerequisite in terms of the patches actually
>> depend on it.  I appreciate you want it first to ensure that we don't bloat
>> the kiocb.
>
>Maybe not for the series, but for the io_uring addition it is.
>
>>> I believe Kanchan meant that now the trade-off we were asking to
>>> clear out is sorted.
>>>
>>> We will send a new version shortly for the current functionality - we
>>> can see what we are missing on when the uring interface is clear.
>>
>> I've started work on a patch series for this.  Mostly just waiting for
>> compilation now ... should be done in the next few hours.
>
>Great!

Jens, Matthew - I'm sorry for creating the confusion. By "looks sorted"
I meant the performance-implications and the room-for-pointer. For the
latter I was thinking to go by your suggestion not to bloat the kiocb, and
use io_kiocb instead.
If we keep, there will be two paths to update that pointer, one using
ki_complete(....,ret2) and another directly - which does not seem good.

On a different note: trimming kiocb by decoupling ki_complete work looks
too good to be done by me :-)

------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_e97d3_
Content-Type: text/plain; charset="utf-8"


------nai8lIH9ngBNHun9R6qswQcIIemhXBCkNXu5CagZqSM5j8ea=_e97d3_--
