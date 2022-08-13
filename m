Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE30591A09
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 13:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239401AbiHMLp2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Aug 2022 07:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiHMLp2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Aug 2022 07:45:28 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129DF1A054
        for <io-uring@vger.kernel.org>; Sat, 13 Aug 2022 04:45:24 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220813114520epoutp0328136c5b19853887bb705a8668f2a021~K5O1FTyfB1042710427epoutp03L
        for <io-uring@vger.kernel.org>; Sat, 13 Aug 2022 11:45:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220813114520epoutp0328136c5b19853887bb705a8668f2a021~K5O1FTyfB1042710427epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660391120;
        bh=C+Z9+Hh51/GATncydt5AQuyqbUl6t40G6G27ctdztO8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qF5KrovxBA0FwoDImhcb3c/jf91ns8crjsmWbwqZAhKbiLuFbeZokdkCdj7PWoaVO
         JoA+LUKauLm4EX7vFkBZkd8eF98HdAhXpW52CS617exv8ZbSEmSrPAYaVcIuERmOyO
         O3kWcY++pw4Wkz2h1ls4P0VfrDG4Ai0BoeW/Vfkk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220813114519epcas5p230392e38d05f140adf7455990faad2ca~K5O0fhNo20988609886epcas5p2a;
        Sat, 13 Aug 2022 11:45:19 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4M4dyP3xwhz4x9Pr; Sat, 13 Aug
        2022 11:45:17 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EE.5D.49477.DCE87F26; Sat, 13 Aug 2022 20:45:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220813114516epcas5p29fbfc50f5bb0c9f43583ee5b12e73154~K5OxNS8T40550805508epcas5p2V;
        Sat, 13 Aug 2022 11:45:16 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220813114516epsmtrp2d42f3c4348d6d4d197b79ceb4c6d64c8~K5OxH3qWP2533425334epsmtrp25;
        Sat, 13 Aug 2022 11:45:16 +0000 (GMT)
X-AuditID: b6c32a49-843ff7000000c145-68-62f78ecd0b9c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.B5.08802.BCE87F26; Sat, 13 Aug 2022 20:45:16 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220813114515epsmtip1f7decd4c9cc71c212f169c9c26518512~K5OwSnGzk3172331723epsmtip1S;
        Sat, 13 Aug 2022 11:45:15 +0000 (GMT)
Date:   Sat, 13 Aug 2022 17:05:42 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>,
        Ankit Kumar <ankit.kumar@samsung.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH liburing 0/5] Add basic test for nvme uring passthrough
 commands
Message-ID: <20220813113542.GA27790@test-zns>
MIME-Version: 1.0
In-Reply-To: <6e90dc31-e4bb-b5c4-6e8c-112e18f3654f@schaufler-ca.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42LZdlhTQ/ds3/ckg/XfJS3WXPnNbrH6bj+b
        xb1tv9gs3rWeY7G4PWk6iwOrx+WzpR5r975g9OjbsorR4+j+RWwenzfJBbBGZdtkpCampBYp
        pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAO1WUihLzCkFCgUkFhcr
        6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnvHq3jLXgoUDF
        z01nWRsY2/m6GDk5JARMJJ7v7mXsYuTiEBLYzSix6FQbO4TziVFi9fpGVgjnM6PE4WMX2GFa
        lj34AZXYxSixb85VJgjnGaPEzt0fmECqWARUJR5P62XpYuTgYBPQlLgwuRQkLCKgI7Fvz3Ow
        FcwCrYwSPy8fZgVJCAuESSxb9A5sA6+ArsSzKWuYIGxBiZMzn7CA2JwCLhIv9v0Di4sKKEsc
        2HYcbLGEwEd2iWePvkGd5yKxbP0PNghbWOLV8S1QcSmJz+/2QsWTJS7NPMcEYZdIPN5zEMq2
        l2g91c8MYjMLZEjc+XKcFcLmk+j9/YQJ5BkJAV6JjjYhiHJFiXuTnrJC2OISD2csgbI9JD4/
        mwgNlH9MEn/XHmOdwCg3C8k/s5CsgLCtJDo/NAHZHEC2tMTyfxwQpqbE+l36CxhZVzFKphYU
        56anFpsWGOallsNjOTk/dxMjOD1qee5gvPvgg94hRiYOxkOMEhzMSiK8ZYs+JwnxpiRWVqUW
        5ccXleakFh9iNAXGz0RmKdHkfGCCziuJNzSxNDAxMzMzsTQ2M1QS5/W6uilJSCA9sSQ1OzW1
        ILUIpo+Jg1Oqgck5IMs5qVGed8/R3wFaoT0PgkJ/iIcejfb8N63kQ6L/7gDVt4b3Py7t4v/6
        pfON+rVCict1j+POL7j+yJQj7szMu49Vc/b5/N78MKq/bG+QdkfAqVlvuGoi30aIv1klsPzx
        yeQMo3ucB0WtH/XM+Cei39xlu8qsR1TU/bEEt1jsbqc9vRsv9vL9eex38gDX2d9Hg/8cXqK5
        4bIY8wGtq1Fy79Y+ftzF/tkhcdHbH5UxJumSX5iMbe/cXsnk1ezNOWP/2+t7A9wShV11p+o1
        znc94vxx+8xtm85WJSTbVZoLNpn+fLb7/aYGkc0382Y8anj9JjQ1fBUXi8Pvy5vfnRaaeO9s
        Yt48i7yZYfOslpsqsRRnJBpqMRcVJwIA7/DNoxgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSnO6Zvu9JBltbGC3WXPnNbrH6bj+b
        xb1tv9gs3rWeY7G4PWk6iwOrx+WzpR5r975g9OjbsorR4+j+RWwenzfJBbBGcdmkpOZklqUW
        6dslcGVM3bqUqWAyX8WS698YGxgvc3cxcnJICJhILHvwgxXEFhLYwShx7aAwRFxcovnaD3YI
        W1hi5b/nQDYXUM0TRomtN58zgSRYBFQlHk/rZeli5OBgE9CUuDC5FCQsIqAjsW8PRD2zQCuj
        xM5l25hBEsICYRLLFr0DG8oroCvxbMoaJoih/5gk7k2awwSREJQ4OfMJC4jNLGAmMW/zQ2aQ
        BcwC0hLL/3GAhDkFXCRe7PsHVi4qoCxxYNtxpgmMgrOQdM9C0j0LoXsBI/MqRsnUguLc9Nxi
        wwKjvNRyveLE3OLSvHS95PzcTYzgYNfS2sG4Z9UHvUOMTByMhxglOJiVRHjLFn1OEuJNSays
        Si3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoFJ+F5Tfg7DTX/toFp7
        5g4pib3z3ZJc8hOkDZ+FzsmoXv0q//7Mmw11v80faLFOVi7ft57ZNT1+hexZ+0XRzLYv1B/8
        eXk6vWu59hWenZVfVq9Zbt13v2Hy93v1yXP+73moYRxTOvnk19gby0XKzS6vmrmBuabx8MWG
        UIV4N6GvGx5vXPJWjvlK/6p40yx2yc1Ky+7fn6V4TLyuifvk3qIdi9smdWWyuz9u33+tvOf+
        HtMnryVFs6XlHZTUPYyO3LgjVxqmre/Je/RSIZ/T4vgT582SWK/evfVbV0l9imHjsV7Xyp2y
        HD9eTQy5f6L+bkZjrEvDJWlu/xntH/l0zxz70eNYfaHGVcv54rPuY+lKLMUZiYZazEXFiQAk
        LUrJ5QIAAA==
X-CMS-MailID: 20220813114516epcas5p29fbfc50f5bb0c9f43583ee5b12e73154
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----NuB4zix05mrs21-izUqZH_CfDXeHJwDu-cyxw2zCq-3u00NA=_73535_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
        <20220719135234.14039-1-ankit.kumar@samsung.com>
        <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
        <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk>
        <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
        <6e90dc31-e4bb-b5c4-6e8c-112e18f3654f@schaufler-ca.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------NuB4zix05mrs21-izUqZH_CfDXeHJwDu-cyxw2zCq-3u00NA=_73535_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Aug 12, 2022 at 09:03:12AM -0700, Casey Schaufler wrote:
>On 8/12/2022 8:33 AM, Paul Moore wrote:
>> On Thu, Aug 11, 2022 at 9:51 PM Jens Axboe <axboe@kernel.dk> wrote:
>>> On 8/11/22 6:43 PM, Casey Schaufler wrote:
>>>> On 7/19/2022 6:52 AM, Ankit Kumar wrote:
>>>>> This patchset adds test/io_uring_passthrough.c to submit uring passthrough
>>>>> commands to nvme-ns character device. The uring passthrough was introduced
>>>>> with 5.19 io_uring.
>>>>>
>>>>> To send nvme uring passthrough commands we require helpers to fetch NVMe
>>>>> char device (/dev/ngXnY) specific fields such as namespace id, lba size.
>>>> There wouldn't be a way to run these tests using a more general
>>>> configuration, would there? I spent way too much time trying to
>>>> coax my systems into pretending it has this device.
>>> It's only plumbed up for nvme. Just use qemu with an nvme device?
>>>
>>> -drive id=drv1,if=none,file=nvme.img,aio=io_uring,cache.direct=on,discard=on \
>>> -device nvme,drive=drv1,serial=blah2
>>>
>>> Paul was pondering wiring up a no-op kind of thing for null, though.
>> Yep, I started working on that earlier this week, but I've gotten
>> pulled back into the SCTP stuff to try and sort out something odd.
>>
>> Casey, what I have isn't tested, but I'll toss it into my next kernel
>> build to make sure it at least doesn't crash on boot and if it looks
>> good I'll send it to you off-list.
>
>Super. Playing with qemu configuration always seems to suck time
>and rarely gets me where I want to be.

FWIW, one more option (not easier than no-op/null though) is to emulate
nvme over a regular-file using loopback-fabrics target.
A coarse script is here -
https://github.com/joshkan/loopback-nvme-uring/commit/96853963a196f2d307d4d8e60d1276a08b520307


------NuB4zix05mrs21-izUqZH_CfDXeHJwDu-cyxw2zCq-3u00NA=_73535_
Content-Type: text/plain; charset="utf-8"


------NuB4zix05mrs21-izUqZH_CfDXeHJwDu-cyxw2zCq-3u00NA=_73535_--
