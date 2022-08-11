Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA26F590614
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 19:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiHKRqA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 13:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235433AbiHKRpe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 13:45:34 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FBA9C2DD
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 10:45:32 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220811174530epoutp014877ff3eacdf7a5f52600d273c0d85f3~KW2uzG2s60371503715epoutp01V
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 17:45:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220811174530epoutp014877ff3eacdf7a5f52600d273c0d85f3~KW2uzG2s60371503715epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660239930;
        bh=kluM3ERjzLNLJK7UBqKQf7qt4+06nBej6tiY5H+gZUs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z4W3o8PGh69YbWMdK40gM45WJ3Y7vNjKq99Df0xmejRi+8/V+YdaxtkqvPX3EsCPm
         CJmRH2LN7I49qIdrMVPa1yVi/5VR0CqmdFmnVzb9EfE062aFpggyD3HddfrqQRfhJC
         RBy2NCi6GU29YZ4PnHskWxzT2c4wYw8uqQifXFZg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220811174530epcas5p4543717385ff0ab0b93a29369e77ced46~KW2uYfgZG3193831938epcas5p4Y;
        Thu, 11 Aug 2022 17:45:30 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4M3Z2w54XBz4x9Pp; Thu, 11 Aug
        2022 17:45:28 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3D.07.49477.83045F26; Fri, 12 Aug 2022 02:45:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220811174527epcas5p357ed7058ad9c1f3b3ca708c60040d924~KW2rwv16k2259922599epcas5p3y;
        Thu, 11 Aug 2022 17:45:27 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220811174527epsmtrp14a0d6a427773528f2d509e3daa3480de~KW2rwD2WL2771427714epsmtrp1I;
        Thu, 11 Aug 2022 17:45:27 +0000 (GMT)
X-AuditID: b6c32a49-82dff7000000c145-84-62f540385f25
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        5B.2F.08802.73045F26; Fri, 12 Aug 2022 02:45:27 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220811174526epsmtip21b9c08c0a662eb249ee106588056c165~KW2q8HfSu1677816778epsmtip2V;
        Thu, 11 Aug 2022 17:45:26 +0000 (GMT)
Date:   Thu, 11 Aug 2022 23:05:53 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     anuj20.g@samsung.com, io-uring@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH] io_uring: fix error handling for io_uring_cmd
Message-ID: <20220811173553.GA16993@test-zns>
MIME-Version: 1.0
In-Reply-To: <f172af9b-2321-c819-2e29-357d4f130159@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmpq6Fw9ckg9MdGhZNE/4yW6y+289m
        8a71HIvFocnNTA4sHpfPlnq833eVzaNvyypGj8+b5AJYorJtMlITU1KLFFLzkvNTMvPSbZW8
        g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4A2KimUJeaUAoUCEouLlfTtbIryS0tSFTLy
        i0tslVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM168WMJUsJ6r4v/utSwNjHc4uhg5
        OSQETCS+9P9kBLGFBHYzSqxYIdfFyAVkf2KUeNF7nwnC+cwo8XziNmaYjnftXcwQiV2MEqdm
        f2SDcJ4xSmz6Np0NpIpFQFWib+5SoCoODjYBTYkLk0tBwiICChI9v1eClTALuEs8vLOBHcQW
        FnCSmP3kMAuIzSugK/HyySdGCFtQ4uTMJywgYzgFbCXWzGMCCYsKKEsc2HYc7DgJgVvsEjeO
        3mWCOM5FYtrBBnYIW1ji1fEtULaUxMv+Nig7WeLSzHNQ9SUSj/cchLLtJVpP9TND3JYh8e3h
        IRYIm0+i9/cTJpAbJAR4JTrahCDKFSXuTXrKCmGLSzycsQTK9pDY8uEqOyRI/jBK7DoykXEC
        o9wsJO/MQrICwraS6PzQxDoLaAWzgLTE8n8cEKamxPpd+gsYWVcxSqYWFOempxabFhjmpZbD
        ozg5P3cTIzgJannuYLz74IPeIUYmDsZDjBIczEoivGWLPicJ8aYkVlalFuXHF5XmpBYfYjQF
        xs5EZinR5HxgGs4riTc0sTQwMTMzM7E0NjNUEuf1uropSUggPbEkNTs1tSC1CKaPiYNTqoFJ
        8Oy373wvXk4TyXabpKTmuVGu27Zlnnjy0qhuuT8Xn8pt3zNJWZmXe+7+rL/VQTYPv61Yqp50
        bIHahHWOP7/9vvekm2FPxt6os05zbGtkD+1iPPRt/u6XTqr/1wRuu7ptwQ2/SQ/3FtlMC/p6
        tdrl8JrpTbc0ZFaZlcx22u3czM5pxOMZLhtY7tS/d9EOx9mJu3pdWYwtRT4+3PX6r1mw8fSp
        q6prz2v+1a35qqWo2rDhWYr/Ez2ewCaFO1sPH4jZUS9zfkmqTlDicdEEd9mo6EVTpG/It/Vv
        EMl0Ylc19ll49tv+07IszWHtk9cGLbA4d/3K/xIpUSuxVw2X6mJK73U9bjveukF37rwgaaZE
        JZbijERDLeai4kQAbaOJ4AsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWy7bCSvK65w9ckgxdTxCyaJvxltlh9t5/N
        4l3rORaLQ5ObmRxYPC6fLfV4v+8qm0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBlzNn4k7Hg
        IXvF6eXHGBsYV7B1MXJySAiYSLxr72LuYuTiEBLYwSjRvfYzM0RCXKL52g92CFtYYuW/5+wQ
        RU8YJS7vXAiWYBFQleibuxSogYODTUBT4sLkUpCwiICCRM/vlWALmAXcJR7e2QBWLizgJDH7
        yWEWEJtXQFfi5ZNPjBAz/zBKbGifwQSREJQ4OfMJC0SzmcS8zQ/B5jMLSEss/8cBYnIK2Eqs
        mQdWLSqgLHFg23GmCYyCs5A0z0LSPAuheQEj8ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k
        /NxNjOCw1tLawbhn1Qe9Q4xMHIyHGCU4mJVEeMsWfU4S4k1JrKxKLcqPLyrNSS0+xCjNwaIk
        znuh62S8kEB6YklqdmpqQWoRTJaJg1OqgSngn4+Yqfz+zvzVisb1ab3nlXZuCH3z2UtVIDBH
        eOL8/HczdTSNJz/RMzlg6eDt6XW2Iyzi/Prbj9z+nXSbdLKjzS4zg/V56BWFx9Oce2Xvf3dP
        9pf5mzzt1Ey2S4cqn8y4K7Tbo2Pp9+41797OPyF6XfvDBaGMS7eXdc61tJ4++9Or6x/v3pi8
        WdZM8/Dmx2ayV5/vPutcr9m4OMbD89SMyAtKPxufy+e8SW2b4teVsEzJgS2hkClwQdD7aqb7
        q84p2Adv2XkmgKl1g9GN36tezZkYnfV26pHYyUt+LdJbekF24t++XnsDjW3ui0pb4xIN2a7P
        +voj7ob7KQ3+DD+ZJ3N/Cvb8b0md1Z2xlVlCiaU4I9FQi7moOBEA9FfSYNoCAAA=
X-CMS-MailID: 20220811174527epcas5p357ed7058ad9c1f3b3ca708c60040d924
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_6adb0_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220811092503epcas5p2e945f7baa5cb0cd7e3d326602c740edb
References: <CGME20220811092503epcas5p2e945f7baa5cb0cd7e3d326602c740edb@epcas5p2.samsung.com>
        <20220811091459.6929-1-anuj20.g@samsung.com>
        <166023229266.192493.17453600546633974619.b4-ty@kernel.dk>
        <f172af9b-2321-c819-2e29-357d4f130159@kernel.dk>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_6adb0_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, Aug 11, 2022 at 10:55:29AM -0600, Jens Axboe wrote:
>On 8/11/22 9:38 AM, Jens Axboe wrote:
>> On Thu, 11 Aug 2022 14:44:59 +0530, Anuj Gupta wrote:
>>> Commit 97b388d70b53 ("io_uring: handle completions in the core") moved the
>>> error handling from handler to core. But for io_uring_cmd handler we end
>>> up completing more than once (both in handler and in core) leading to
>>> use_after_free.
>>> Change io_uring_cmd handler to avoid calling io_uring_cmd_done in case
>>> of error.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/1] io_uring: fix error handling for io_uring_cmd
>>       commit: f1bb0fd63c374e1410ff05fb434aa78e1ce09ae4
>
>Ehm, did you compile this:
Sorry. Version that landed here got a upgrade in
commit-description but downgrade in this part :-(

BTW, we noticed the original issue while testing fixedbufs support.
Thinking to add a liburing test that involves sending a command which
nvme will fail during submission. Can come in handy.

------3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_6adb0_
Content-Type: text/plain; charset="utf-8"


------3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_6adb0_--
