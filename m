Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5382E20BC56
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 00:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgFZWSt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 18:18:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43682 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgFZWSt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 18:18:49 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200626221843epoutp0294ab29dadbf0dfa7b70a726a2292edb0~cN-vliGna1421114211epoutp02Z
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 22:18:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200626221843epoutp0294ab29dadbf0dfa7b70a726a2292edb0~cN-vliGna1421114211epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593209923;
        bh=pTlK/esDfoE0xSN5xYJeTXmHhNjP+FadJb3AhpKF/Vo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=keMieciTRzpmJys0Jh7g3Ka4WDjUy3Xamw3IYOR+kQYJjZL53wfOQldCjSLBQFNoz
         B5X1cH6JorMd4kRA3joLal7ulZMmY+xNXOxz8QtKJdS1zDPinHQoZ50zmRIWf8hvLb
         JYcmKimBFrnRLfrp1EGFf4w/V/pdsRgDUPJjMKpc=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200626221842epcas5p256e35e7ef4c1c428b09cf93c9a3bed32~cN-uuXUfP2841028410epcas5p2Y;
        Fri, 26 Jun 2020 22:18:42 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        72.EE.09475.24476FE5; Sat, 27 Jun 2020 07:18:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200626221841epcas5p18a8b150e8a6651c7d1501f8f798e3765~cN-uUEgfq0840108401epcas5p1f;
        Fri, 26 Jun 2020 22:18:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200626221841epsmtrp11a47025986e630baf096f69606f28b40~cN-uTPJpr1774817748epsmtrp1i;
        Fri, 26 Jun 2020 22:18:41 +0000 (GMT)
X-AuditID: b6c32a4b-39fff70000002503-2f-5ef67442534e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F6.D6.08382.14476FE5; Sat, 27 Jun 2020 07:18:41 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200626221839epsmtip2d93c2ef780cf3c7bdd3a47d5fd0d1628~cN-sRC8OU0157801578epsmtip2E;
        Fri, 26 Jun 2020 22:18:39 +0000 (GMT)
Date:   Sat, 27 Jun 2020 03:45:45 +0530
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
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [PATCH v2 0/2] zone-append support in io-uring and aio
Message-ID: <20200626221545.GA25892@test-zns>
MIME-Version: 1.0
In-Reply-To: <CY4PR04MB37511E3B19035012A143D006E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTHee5bL511d8WNI2rJrpKFoiBxc3dTR7ehu3FZ2Cc/kMgscFeM
        UEgvnZsu2rEI9ZoOQcK0s1RxAQcLIx0rE1rkzTUEqSLI2FLdZIU5eRkrG2FDyGwvJn77nXP+
        5/mfc/LQuHqAjKMPGosFk1Gfz1JKwt2TqN3yRvF81lbpEs2db3AjrvFOOcVJyy0Ed6JsHuP6
        T9di3MwJP8H9FphTcFXVJYjz/pzEebx9BDfUdp7iLrf2Epx70Ylzkwt9FHdjyUfqnuav2O8o
        +G8va/mhATPvClUq+FO3FxD/WUsD4udcGr6s8xTGu4LT2LvRmcqduUL+wQ8EU8prB5R5Pmd6
        kVfzYeWiA7cgaa2EomlgXoT+gIOUkJJWM+0IrJ4mSg5CCO73h8iwSs3MIyhrPPS445Z/FMki
        LwL/7BghBxMIJEcbFVYRTAJ0XfkJkxBNU0wi3DxjDqfXMFqo65iJ2OHMTRJq6trxcCGGeRMG
        Qv1EmFXMFqj/vJqS+RnoOxeM5KOZ/XC1yxGZ6FlmI3S6fVj4IWCGaZgcOkvJ46XDVxOP1otw
        DDzwtShkjoM/yktXWIT/AtdwudmK4EfLOUIupMGgZwkLM87kwZk/3ZTMq8G2GIxsA4wKrKVq
        Wf483K0cJ2WOhXtnv1xhHkYqKlau8gDBDzYHOo009icWsj9hIfOrcHK2hLQ/ssCZdVC/TMuY
        CN+0pVxAZANaKxSJBQZBfKlom1E4nCzqC0Sz0ZCcU1jgQpEfp337ezT262xyN8Jo1I2Axtk1
        qrkd81lqVa7+oyOCqfA9kzlfELvROppgY1XswvUsNWPQFwuHBKFIMD2uYnR0nAXLj/LsPKZL
        0zSNHjfEL/VsdL71aeqY/aHU8fVwcMM/m66/Y9m/amnV8O4Dqc/lLXrc9T3rfdoL8a0K97XC
        7d6MEIPdb60a3Wa9euSX8ddVGWbd5rb2QbZz1+8vjyi+U02ytVIwM/Pv8ok63e6aFxJubf3C
        uTnBVXN0k8bz8XSU8+hA7fK/U/V7L2YJsNrQZJzVvIId0+Wo39+xPEVZbBti3c1J7OHmEZ4i
        9oA4nLQvM+qG4qncv1KyewO23I5sV7a/wjY9Y88xj+4Zax5kq4K3Gyat/otpd4dKZ0g0Xp1+
        r8sz1amrebjdGfPJSKNVy/qPB0ro2JKTvev3WeMzlLtYQszTp2pxk6j/H7dqGHfgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWy7bCSvK5jybc4gyUHdC3mrNrGaLH6bj+b
        Rde/LSwWre3fmCxOT1jEZPGu9RyLxeM7n9ktpkxrYrTYe0vbYs/ekywWl3fNYbNYsf0Ii8W2
        3/OZLV7/OMlmcf7vcVYHfo+ds+6ye2xeoeVx+Wypx6ZPk9g9uq/+YPTo27KK0ePzJjmP9gPd
        TB6bnrxlCuCM4rJJSc3JLEst0rdL4MpYfnM+S8F76Yqbdz4wNzBeE+ti5OSQEDCRuHTuBmMX
        IxeHkMBuRon1k/cyQiTEJZqv/WCHsIUlVv57DmYLCTxhlJi/kwnEZhFQlTi48yaQzcHBJqAp
        cWFyKUhYREBLYtm+d6wgM5kFrrFKdJ54ADZTWMBZ4uyn0ywgNq+ArsTy6dPYIBa/YpR48Hsi
        VEJQ4uTMJ2A2s4CZxLzND5lBFjALSEss/8cBEuYUiJXYf3AuK4gtKqAscWDbcaYJjIKzkHTP
        QtI9C6F7ASPzKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4KjT0tzBuH3VB71DjEwc
        jIcYJTiYlUR4P1t/ixPiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6NwYZyQQHpiSWp2ampBahFM
        lomDU6qByadvGWNl826PmbP+qnOuVOA+93S7TPyEe/tc33gqxdsVRmpFrW/KNbr7uC03VGOf
        iTSrxDW2M1wRLAq5fcVLNs3Y7qFWEqh6V1Ns67p/k/hl1pvN+6ShYLn/kNWEWXN7kgsPddxS
        y9QKnpf8e6fgOr+Zou7nDr3iZUw2aMswzlRtsAyIjn51Sjhb7prOVq4dCTeOb5N+c1HoJd+q
        l4pVDK8vuihs29XCYn+mk2XZl00xha3/PLKVfXwZZrC+C+3JZg04Olcyy4HX6vXkfoZNBkff
        ss758v3fZJ/ls62VX6wSNqmYF3JhRqpQXH5zc9y61K3Ox+43rViwKqnD1LVt/tHQ+Q8ufDzV
        dzqnQslGiaU4I9FQi7moOBEAay1WoSkDAAA=
X-CMS-MailID: 20200626221841epcas5p18a8b150e8a6651c7d1501f8f798e3765
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----_kWsYTlEiWgRcgg3slXo3.6fqMwSg3MgpFIky2YSZcHasXdW=_9ecda_"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200625171829epcas5p268486a0780571edb4999fc7b3caab602
References: <CGME20200625171829epcas5p268486a0780571edb4999fc7b3caab602@epcas5p2.samsung.com>
        <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
        <CY4PR04MB37511E3B19035012A143D006E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------_kWsYTlEiWgRcgg3slXo3.6fqMwSg3MgpFIky2YSZcHasXdW=_9ecda_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Jun 26, 2020 at 03:11:55AM +0000, Damien Le Moal wrote:
>On 2020/06/26 2:18, Kanchan Joshi wrote:
>> Semantics --->
>> Zone-append, by its nature, may perform write on a different location than what
>> was specified. It does not fit into POSIX, and trying to fit may just undermine
>> its benefit. It may be better to keep semantics as close to zone-append as
>> possible i.e. specify zone-start location, and obtain the actual-write location
>> post completion. Towards that goal, existing async APIs seem to fit fine.
>> Async APIs (uring, linux aio) do not work on implicit write-pointer and demand
>> explicit write offset (which is what we need for append). Neither write-pointer
>
>What do you mean by "implicit write pointer" ? Are you referring to the behavior
>of AIO write with a block device file open with O_APPEND ? The yes, it does not
>work. But that is perfectly fine for regular files, that is for zonefs.
Sorry, I meant file pointer.
Yes, block-device opened with O_APPEND does not increase the file-pointer
to end-of-device. That said, for uring and aio, file-pointer position
plays no role, and it is application responsibility to pass the right write
location.
>I would prefer that this paragraph simply state the semantic that is implemented
>first. Then explain why the choice. But first, clarify how the API works, what
>is allowed, what's not etc. That will also simplify reviewing the code as one
>can then check the code against the goal.

In this path (block IO) there is hardly any scope/attempt to abstract away anything.
So raw zoned-storage rule/semantics apply. I expect zone-aware
applications, which are already aware of rules, to be consumer of this.

>> is taken as input, nor it is updated on completion. And there is a clear way to
>> get zone-append result. Zone-aware applications while using these async APIs
>> can be fine with, for the lack of better word, zone-append semantics itself.
>>
>> Sync APIs work with implicit write-pointer (at least few of those), and there is
>> no way to obtain zone-append result, making it hard for user-space zone-append.
>
>Sync API are executed under inode lock, at least for regular files. So there is
>absolutely no problem to use zone append. zonefs does it already. The problem is
>the lack of locking for block device file.
Yes. I was refering to the problem of returning actual write-location using
sync APIs like write, pwrite, pwritev/v2.
>>
>> Tests --->
>> Using new interface in fio (uring and libaio engine) by extending zbd tests
>> for zone-append: https://protect2.fireeye.com/url?k=e21dd5e0-bf837b7a-e21c5eaf-0cc47a336fae-c982437ed1be6cc8&q=1&u=https%3A%2F%2Fgithub.com%2Faxboe%2Ffio%2Fpull%2F1026
>>
>> Changes since v1:
>> - No new opcodes in uring or aio. Use RWF_ZONE_APPEND flag instead.
>> - linux-aio changes vanish because of no new opcode
>> - Fixed the overflow and other issues mentioned by Damien
>> - Simplified uring support code, fixed the issues mentioned by Pavel
>> - Added error checks
>>
>> Kanchan Joshi (1):
>>   fs,block: Introduce RWF_ZONE_APPEND and handling in direct IO path
>>
>> Selvakumar S (1):
>>   io_uring: add support for zone-append
>>
>>  fs/block_dev.c          | 28 ++++++++++++++++++++++++----
>>  fs/io_uring.c           | 32 ++++++++++++++++++++++++++++++--
>>  include/linux/fs.h      |  9 +++++++++
>>  include/uapi/linux/fs.h |  5 ++++-
>>  4 files changed, 67 insertions(+), 7 deletions(-)
>>
>
>
>-- 
>Damien Le Moal
>Western Digital Research
>

------_kWsYTlEiWgRcgg3slXo3.6fqMwSg3MgpFIky2YSZcHasXdW=_9ecda_
Content-Type: text/plain; charset="utf-8"


------_kWsYTlEiWgRcgg3slXo3.6fqMwSg3MgpFIky2YSZcHasXdW=_9ecda_--
