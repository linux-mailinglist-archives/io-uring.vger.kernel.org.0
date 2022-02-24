Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59194C2C43
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 13:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbiBXM5u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 07:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbiBXM5t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 07:57:49 -0500
X-Greylist: delayed 597 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Feb 2022 04:57:18 PST
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28506C945
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 04:57:18 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220224124716euoutp02e5d03f97d141901232d70bbb8dda9e02~WuaXzWUjc0963509635euoutp02K
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 12:47:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220224124716euoutp02e5d03f97d141901232d70bbb8dda9e02~WuaXzWUjc0963509635euoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1645706836;
        bh=xxpoyoGbQg4LNrod2vNervS4A2SM9N3Sjh6gPLxH4jo=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=bkE1Q85CPYxAA54/MjcKzYJhYMUmz262fa1eSXcXamqRTobF3NQrXQceCq/JJGFcB
         nreuFKA4xGSixjMKpVWZO+eq224zXbz87YRyKW6DuWDKtnSQeHQu5R7YwqYHEyW4zZ
         oijlYEzjmX7Z72uLOqex3k/4Mg4n4SKmuzR7lphY=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220224124715eucas1p27f90b11c289c929016282c4ca43bed21~WuaXfaaCh2796627966eucas1p2F;
        Thu, 24 Feb 2022 12:47:15 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 96.9F.09887.35E77126; Thu, 24
        Feb 2022 12:47:15 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220224124715eucas1p2a7d1b7f2a5131ef1dd5b8280c1d3749b~WuaXEZdNQ2764927649eucas1p2H;
        Thu, 24 Feb 2022 12:47:15 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220224124715eusmtrp110023745f66a8013d226cbb34ce1610f~WuaXDk_wk1264812648eusmtrp1C;
        Thu, 24 Feb 2022 12:47:15 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-2d-62177e533687
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 2E.98.09404.35E77126; Thu, 24
        Feb 2022 12:47:15 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220224124715eusmtip1bcb3e89ba5ad7ea3d3e4d8e6e6b40734~WuaWqOH9U3086130861eusmtip1G;
        Thu, 24 Feb 2022 12:47:14 +0000 (GMT)
Message-ID: <5e0084b9-0090-c2a6-ab64-58fd1887d95f@samsung.com>
Date:   Thu, 24 Feb 2022 13:47:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v3 0/2] io-uring: Make statx api stable
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <164555550976.110748.6933069169641927964.b4-ty@kernel.dk>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsWy7djP87rBdeJJBptfmlqsvtvPZvGu9RyL
        xbG+96wWe/aeZLG4+vIAu8X5v8dZHdg8Jja/Y/e4fLbU4/MmOY9NT94yBbBEcdmkpOZklqUW
        6dslcGV8eyxf0MdT0dL7hrWB8RpnFyMnh4SAicT813PZuxi5OIQEVjBKzDo/hQnC+cIoMXXD
        KSjnM6PEg2sbGWFaPu7dyAZiCwksZ5T4fFUFougjo8Sl+T1ACQ4OXgE7ifZ7YCtYBFQlXm39
        BVbPKyAocXLmExYQW1QgSeLBgT52EFtYwFri5ISHYHFmAXGJW0/mgy0WEehmlFj19xsbREJa
        YsqV3WBFbAKGEl1vu8DinAJuEg33zzJC1MhLbH87hxni0DMcEruu1EPYLhI/TnxghbCFJV4d
        38IOYctInJ7cwwKyTEKgmVHi4bm17BBOD6PE5aYZUC9bS9w59wvsM2YBTYn1u/Qhwo4Sy7tA
        lnEA2XwSN94KQtzAJzFp23SoMK9ER5sQRLWaxKzj6+DWHrxwiXkCo9IspGCZheT9WUi+mYWw
        dwEjyypG8dTS4tz01GKjvNRyveLE3OLSvHS95PzcTYzAVHP63/EvOxiXv/qod4iRiYPxEKME
        B7OSCK9poViSEG9KYmVValF+fFFpTmrxIUZpDhYlcd7kzA2JQgLpiSWp2ampBalFMFkmDk6p
        BqaaR2HfFvZOtXa/oruk58TapDexwd47tU1+Mxc/eJzzaNFsxt50rZ0CZ9gEgo42pDgf3d3e
        V9p8yGjp/TcLTa69lv1vvM6s+talXVGrJ+1dxBPUfUdp4ezuhmrBjJc/L+yMtF4fF/23V21a
        T94ks7uTtflOll2Zu8b/knVUGh+Dc8nz5GXntpmuVjUviU8r4Nm2pb0h7LfLQVXVjeYv3Wey
        T01tT/Q/KBxpULLI5S3LgpMzS3zmH5etn79xxsONu0Tfyb/afk9po5Ht2UO5UyK9hNe5mSv9
        Usi21Mic3lTreNl5h8IGu7eScxmVdpzRrfm2ZfVWT54PF5dFr976+lbztq/rlxTmvOL0n73U
        OTJBiaU4I9FQi7moOBEA2ph4RqQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t/xu7rBdeJJBqvvSlisvtvPZvGu9RyL
        xbG+96wWe/aeZLG4+vIAu8X5v8dZHdg8Jja/Y/e4fLbU4/MmOY9NT94yBbBE6dkU5ZeWpCpk
        5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GV8eyxf0MdT0dL7hrWB
        8RpnFyMnh4SAicTHvRvZuhi5OIQEljJKLN31khEiISNxcloDK4QtLPHnWhdU0XtGiTdtjSxd
        jBwcvAJ2Eu33wAaxCKhKvNr6iw3E5hUQlDg58wkLiC0qkCTxcttGsDnCAtYSJyc8BIszC4hL
        3HoynwlkpohAL6PE7uUz2SES0hJTruwGKxISyJU49/UYmM0mYCjR9bYLbAGngJtEw/2zjBD1
        ZhJdW7ugbHmJ7W/nME9gFJqF5I5ZSPbNQtIyC0nLAkaWVYwiqaXFuem5xUZ6xYm5xaV56XrJ
        +bmbGIHRte3Yzy07GFe++qh3iJGJg/EQowQHs5IIr2mhWJIQb0piZVVqUX58UWlOavEhRlNg
        YExklhJNzgfGd15JvKGZgamhiZmlgamlmbGSOK9nQUeikEB6YklqdmpqQWoRTB8TB6dUA5NG
        66Ylvosj1L9OSVVfu7833e7yuxKuN3/tov/WuC0UDrnIGBz3LJlru0XcpaczjHUqKiV+a+m+
        +fVD71jxebP7D475dC3syPl70O/05cfP2mNEloqejVtxQ6Fh0d7L3zVCe6RU4rbMnBfMeU3U
        3aX5fcEtddNdynsPfUvM8ec43XrrQu0bJWub9MAfC3JWKerInShbLfRol5g006zAbvbw61ov
        zkZs4nzJtyn16aamc/09Bgx97iGL43fnrCk229GqnGm7MPu9TP3a12X/jwfFLNIxn92cxNA1
        tfmt2dlHrJPm/zO6eSWK+1C8w7/7OgWCFvW99+1ZKpbUTPV6X5jFnMVb3f9y8s6AFTOu5Cqx
        FGckGmoxFxUnAgAk7f+xNwMAAA==
X-CMS-MailID: 20220224124715eucas1p2a7d1b7f2a5131ef1dd5b8280c1d3749b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220224124715eucas1p2a7d1b7f2a5131ef1dd5b8280c1d3749b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220224124715eucas1p2a7d1b7f2a5131ef1dd5b8280c1d3749b
References: <20220215180328.2320199-1-shr@fb.com>
        <164555550976.110748.6933069169641927964.b4-ty@kernel.dk>
        <CGME20220224124715eucas1p2a7d1b7f2a5131ef1dd5b8280c1d3749b@eucas1p2.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 22.02.2022 19:45, Jens Axboe wrote:
> On Tue, 15 Feb 2022 10:03:26 -0800, Stefan Roesch wrote:
>> One of the key architectual tenets of io-uring is to keep the
>> parameters for io-uring stable. After the call has been submitted,
>> its value can be changed.  Unfortunaltely this is not the case for
>> the current statx implementation.
>>
>> Patches:
>>   Patch 1: fs: replace const char* parameter in vfs_statx and do_statx with
>>            struct filename
>>     Create filename object outside of do_statx and vfs_statx, so io-uring
>>     can create the filename object during the prepare phase
>>
>> [...]
> Applied, thanks!
>
> [1/2] fs: replace const char* parameter in vfs_statx and do_statx with struct filename
>        commit: 30512d54fae354a2359a740b75a1451b68aa3807
> [2/2] io-uring: Copy path name during prepare stage for statx
>        commit: 1e0561928e3ab5018615403a2a1293e1e44ee03e

Those 2 commits landed in todays Linux next-20220223. They affect 
userspace in a way that breaks systemd opration:

...

Freeing unused kernel image (initmem) memory: 1024K
Run /sbin/init as init process
systemd[1]: System time before build time, advancing clock.
systemd[1]: Cannot be run in a chroot() environment.
systemd[1]: Freezing execution.

Reverting them on top of next-20220223 fixes the boot issue. Btw, those 
patches are not bisectable. The code at 
30512d54fae354a2359a740b75a1451b68aa3807 doesn't compile.


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

