Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D17458BC3B
	for <lists+io-uring@lfdr.de>; Sun,  7 Aug 2022 20:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiHGSHg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Aug 2022 14:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbiHGSHf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Aug 2022 14:07:35 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CB76543
        for <io-uring@vger.kernel.org>; Sun,  7 Aug 2022 11:07:34 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220807180731epoutp033b0e68d606a6ed1cb81cfe591630c493~JIkzVgZkx0122301223epoutp03T
        for <io-uring@vger.kernel.org>; Sun,  7 Aug 2022 18:07:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220807180731epoutp033b0e68d606a6ed1cb81cfe591630c493~JIkzVgZkx0122301223epoutp03T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659895651;
        bh=jUN5QvlR9Uy8Pfnu+8DKscjyRJsVvIsxU/bQybv/KcE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CSIIRjnfE10WYAFycah0tH4Iz5/rd1Bu8M1jcHrdeE5EHaUYTLKRM8T8LWqRVItAD
         Fr9Lh8kTxkCAcGuPtCWcxgLWsMad5r0r73o47bakGQG4n0qNm+LRgKaMDK7lLijVEY
         A/41pLiftEI8Mwv5R+sG/kDU2ZjBkyi9cMn3TYB0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220807180729epcas5p4d37be7d1fd26a57b6b302007ae4c9106~JIkyQvsh32437724377epcas5p4f;
        Sun,  7 Aug 2022 18:07:29 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4M16k80Vxfz4x9Pt; Sun,  7 Aug
        2022 18:07:28 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        18.31.42669.F5FFFE26; Mon,  8 Aug 2022 03:07:27 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220807180727epcas5p204005d5094b9904b03c4d8b2e0c4ea9a~JIkwCjGS21226712267epcas5p22;
        Sun,  7 Aug 2022 18:07:27 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220807180727epsmtrp184ceb6a4741dd7dc34b4105b718bc933~JIkwByUVf1302613026epsmtrp1M;
        Sun,  7 Aug 2022 18:07:27 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff7000001a6ad-87-62efff5f4fbd
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        98.D4.08905.F5FFFE26; Mon,  8 Aug 2022 03:07:27 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220807180726epsmtip20b1de544073579885ae5decb1c1b2607~JIkus4M9A0243902439epsmtip2N;
        Sun,  7 Aug 2022 18:07:25 +0000 (GMT)
Date:   Sun, 7 Aug 2022 23:28:03 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Keith Busch <kbusch@kernel.org>, hch@lst.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        joshiiitr@gmail.com, gost.dev@samsung.com
Subject: Re: [PATCH 0/4] iopoll support for io_uring/nvme passthrough
Message-ID: <20220807175803.GA13140@test-zns>
MIME-Version: 1.0
In-Reply-To: <6bd091d6-e0e6-3095-fc6b-d32ec89db054@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsWy7bCmlm78//dJBu82W1msvtvPZnHzwE4m
        i5WrjzJZvGs9x2Jx/u1hJotJh64xWuy9pW0xf9lTdotDk5uZHDg9ds66y+5x+Wypx6ZVnWwe
        m5fUe+y+2cDm8X7fVTaPvi2rGD0+b5IL4IjKtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
        1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCS
        U2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ2x4ONWpoKdghU7b7ewNDAe5u1i5OSQEDCReNxx
        jK2LkYtDSGA3o8SOU9MYQRJCAp8YJe4eMoVIfGOUOLS7gbWLkQOso79FHCK+l1Hi+/m9TBDO
        M0aJ5a8PMIF0swioSDybv5kJpIFNQFPiwuRSkLCIgIJEz++VYNuYBU4xSqyYfoMZJCEs4Cox
        4dIisM28AroSCzcuh7IFJU7OfMICYnMK2ErcbD8KFhcVUJY4sO042GIJgYUcEtenPGCC+MdF
        4sLSNnYIW1ji1fEtULaUxMt+mHiyxKWZ56DqSyQe7zkIZdtLtJ7qBzuIWSBD4vm31UwQNp9E
        7+8nTBDf80p0tAlBlCtK3Jv0lBXCFpd4OGMJlO0hcW9tEzskUG4zSbyb0sk+gVFuFpJ/ZiFZ
        AWFbSXR+aGKdBbSCWUBaYvk/DghTU2L9Lv0FjKyrGCVTC4pz01OLTQuM8lLL4XGcnJ+7iRGc
        XLW8djA+fPBB7xAjEwfjIUYJDmYlEd4ja98nCfGmJFZWpRblxxeV5qQWH2I0BcbPRGYp0eR8
        YHrPK4k3NLE0MDEzMzOxNDYzVBLn9bq6KUlIID2xJDU7NbUgtQimj4mDU6qByWHXk5KH6j8U
        It4Vx+XklbFaC38pf3FazPDwybojfZ7RreFNxxyy5m0teJggO+M8+768xl/1+iXWDPfU7WZ4
        nG1yP7ZWI/m9lXs0u7B4ycH8Vds9vwc4htm8v7fB5nzM9j/c88sZWFmvfnBLM53OGc9WLF76
        PSS2ZZdevcVpU+HqcuHw5bW7E16JJ/EyCJSujhD6WrPa7+StksObcrbarf7Fl1BWcfyOXutV
        ib4bqsc2vQgsMFis6P7snciU1S+u/Tv/nvVl1+eovHcXfnwR+CfY/fOn6+PMF0efP9vycPGB
        GQ09c2pvTk/wT1uyTVbS8FW1mlTZp0luv+4uUZwRob3sTOv6hvQXr+b3LtsUoMRSnJFoqMVc
        VJwIAE5QTB83BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWy7bCSvG78//dJBqu+S1qsvtvPZnHzwE4m
        i5WrjzJZvGs9x2Jx/u1hJotJh64xWuy9pW0xf9lTdotDk5uZHDg9ds66y+5x+Wypx6ZVnWwe
        m5fUe+y+2cDm8X7fVTaPvi2rGD0+b5IL4IjisklJzcksSy3St0vgyrj/dC5LwWu+imWTXrE1
        MPZzdzFycEgImEj0t4h3MXJxCAnsZpRYtvEuSxcjJ1BcXKL52g92CFtYYuW/5+wQRU8YJRpu
        rAArYhFQkXg2fzMTyCA2AU2JC5NLQcIiAgoSPb9XsoHUMwucYpRYMf0GM0hCWMBVYsKlRYwg
        Nq+ArsTCjcsZIYbeZpJ4/ewnM0RCUOLkzCdgC5gFzCTmbX7IDLKAWUBaYvk/DpAwp4CtxM32
        o2BzRAWUJQ5sO840gVFwFpLuWUi6ZyF0L2BkXsUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpec
        n7uJERwvWpo7GLev+qB3iJGJg/EQowQHs5II75G175OEeFMSK6tSi/Lji0pzUosPMUpzsCiJ
        817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYMpy10n0uPvu2NbSA/usnzl+vznF+PRK5q7yb1cK
        5nhdzM7h3in/rKVjtp6F2J7N7EvKf0z3uK8WI6n7eb8a16kJ24Ic77Udktz1KKhYwkvM4a3G
        TXvPgALd9RND/Q+82Mcqz2Z4fP/3C2t8mBN+W3WEREkfnPCw4CpjacXHHr3zP0SM67MLZGU/
        TZM/LGpR9IEn9gxrkMlZZaXL/xnLz/pUzD75ONUmWMPgr/PRj46/Zjvs6Dmy66/K457Lfw0E
        n7X6ivM+2rY0JsjkZsO8kMvTL2ZNf7XGpbyy/kCw9AdX/7rso711S9qm9OxLeyzD+6QurLPB
        /JDbe6FFnE6qjYerpU6llf4U+CAo9Fb6lRJLcUaioRZzUXEiAOeQ3vYGAwAA
X-CMS-MailID: 20220807180727epcas5p204005d5094b9904b03c4d8b2e0c4ea9a
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----NuB4zix05mrs21-izUqZH_CfDXeHJwDu-cyxw2zCq-3u00NA=_54e9a_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220805155300epcas5p1b98722e20990d0095238964e2be9db34
References: <CGME20220805155300epcas5p1b98722e20990d0095238964e2be9db34@epcas5p1.samsung.com>
        <20220805154226.155008-1-joshi.k@samsung.com>
        <78f0ac8e-cd45-d71d-4e10-e6d2f910ae45@kernel.dk>
        <a2a5184d-f3ab-0941-6cc4-87cf231d5333@kernel.dk>
        <Yu1dTRhrcOSXmYoN@kbusch-mbp.dhcp.thefacebook.com>
        <6bd091d6-e0e6-3095-fc6b-d32ec89db054@kernel.dk>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------NuB4zix05mrs21-izUqZH_CfDXeHJwDu-cyxw2zCq-3u00NA=_54e9a_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Aug 05, 2022 at 12:15:24PM -0600, Jens Axboe wrote:
>On 8/5/22 12:11 PM, Keith Busch wrote:
>> On Fri, Aug 05, 2022 at 11:18:38AM -0600, Jens Axboe wrote:
>>> On 8/5/22 11:04 AM, Jens Axboe wrote:
>>>> On 8/5/22 9:42 AM, Kanchan Joshi wrote:
>>>>> Hi,
>>>>>
>>>>> Series enables async polling on io_uring command, and nvme passthrough
>>>>> (for io-commands) is wired up to leverage that.
>>>>>
>>>>> 512b randread performance (KIOP) below:
>>>>>
>>>>> QD_batch    block    passthru    passthru-poll   block-poll
>>>>> 1_1          80        81          158            157
>>>>> 8_2         406       470          680            700
>>>>> 16_4        620       656          931            920
>>>>> 128_32      879       1056        1120            1132
>>>>
>>>> Curious on why passthru is slower than block-poll? Are we missing
>>>> something here?
>>>
>>> I took a quick peek, running it here. List of items making it slower:
>>>
>>> - No fixedbufs support for passthru, each each request will go through
>>>   get_user_pages() and put_pages() on completion. This is about a 10%
>>>   change for me, by itself.
>>
>> Enabling fixed buffer support through here looks like it will take a
>> little bit of work. The driver needs an opcode or flag to tell it the
>> user address is a fixed buffer, and io_uring needs to export its
>> registered buffer for a driver like nvme to get to.
>
>Yeah, it's not a straight forward thing. But if this will be used with
>recycled buffers, then it'll definitely be worthwhile to look into.

Had posted bio-cache and fixedbufs in the initial round but retracted
to get the foundation settled first.
https://lore.kernel.org/linux-nvme/20220308152105.309618-1-joshi.k@samsung.com/

I see that you brought back bio-cache already. I can refresh fixedbufs.
Completion-batching seems too tightly coupled to block-path.

------NuB4zix05mrs21-izUqZH_CfDXeHJwDu-cyxw2zCq-3u00NA=_54e9a_
Content-Type: text/plain; charset="utf-8"


------NuB4zix05mrs21-izUqZH_CfDXeHJwDu-cyxw2zCq-3u00NA=_54e9a_--
