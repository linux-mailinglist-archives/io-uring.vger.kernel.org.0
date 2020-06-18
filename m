Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D9D1FFBBB
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 21:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgFRTYT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 15:24:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35937 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgFRTYS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 15:24:18 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200618192413epoutp011e5fd01b5b9dd4353ff8ff43d4858889~ZudHJsxW41633216332epoutp01Q
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 19:24:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200618192413epoutp011e5fd01b5b9dd4353ff8ff43d4858889~ZudHJsxW41633216332epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592508253;
        bh=PNDwEXUhe4Z5R6YzmbzYY6hZ1xH0XR1DBPEnNK7p1tI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lLUnGXHlr6qSu7M/OPm7SVjLO0TODfW6Q6vr8mImGwUprfgDoeHPn9voLsDAZwplT
         aHAcybVCOg5iVs/5cYS58uulTsRDJuXsLMtkrzA3qus4SHMlu5T+U+sGD/htOSt7OJ
         f4ND0mRsa6LGXvAqgYkb5H8fFXOyfynTV5ZnCOMI=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200618192412epcas5p2cfa4400050784112b5770049bd872e0e~ZudF5DtoL2132421324epcas5p2a;
        Thu, 18 Jun 2020 19:24:12 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        02.B4.09703.C5FBBEE5; Fri, 19 Jun 2020 04:24:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200618192411epcas5p125327503f93cafa1d019052f00e54946~ZudEu7YuE0642806428epcas5p1b;
        Thu, 18 Jun 2020 19:24:11 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200618192411epsmtrp1be04fabaafb545c456cfff7ca2250b59~ZudEuEM1J2323623236epsmtrp1G;
        Thu, 18 Jun 2020 19:24:11 +0000 (GMT)
X-AuditID: b6c32a4a-4cbff700000025e7-a0-5eebbf5c8a50
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B7.F1.08303.B5FBBEE5; Fri, 19 Jun 2020 04:24:11 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200618192409epsmtip1ebaea2b37a4874e993f7a9a07d76a840~ZudCksJZi2274422744epsmtip1D;
        Thu, 18 Jun 2020 19:24:08 +0000 (GMT)
Date:   Fri, 19 Jun 2020 00:51:53 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Matias =?utf-8?B?QmrDuHJsaW5n?= <mb@lightnvm.io>
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, javier.gonz@samsung.com,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <keith.busch@wdc.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] zone-append support in aio and io-uring
Message-ID: <20200618192153.GA4141485@test-zns>
MIME-Version: 1.0
In-Reply-To: <f503c488-fa00-4fe2-1ceb-7093ea429e45@lightnvm.io>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsWy7bCmhm7M/tdxBgvOy1usvtvPZtH1bwuL
        RWv7NyaLlauPMlm8az3HYvH4zmd2i237D7JZTJnWxGix95a2xZ69J1ksLu+aw2axYvsRFott
        v+czW1yZsojZ4vWPk2wW5/8eZ3UQ8Lh8ttRj06dJ7B7dV38weuy+2cDm0bdlFaPH501yHu0H
        upk8Nj15yxTAEcVlk5Kak1mWWqRvl8CVcfnUEpaCm7wVzV3rGBsYz3N3MXJySAiYSExcc50F
        xBYS2M0o0XUlpYuRC8j+xCgx/8BiZgjnM6PExXUdjDAdjec6GSESu4CqJm5kg3CeMUocvn2E
        CaSKRUBVYvvyiUBVHBxsApoSFyaXgoRFgJpX904Ha2YWaGGW+NK0mBUkISzgIHFj/kywDbwC
        +hL/fk1kgbAFJU7OfAJmcwrYS1zY/gNsvqiAssSBbceZQAZJCDzhkDi2bT7UeS4Sq/4+Yoaw
        hSVeHd/CDmFLSbzsb4OyiyV+3TnKDNHcwShxvWEmC0TCXuLinr9gG5gFMiQuvt7CBmHzSfT+
        fsIE8o2EAK9ER5sQRLmixL1JT1khbHGJhzOWQNkeEpN62qBBdJpRYs/G7cwTGOVmIXloFpIV
        ELaVROeHJlYIW16ieets5llA65gFpCWW/+OAMDUl1u/SX8DItopRMrWgODc9tdi0wCgvtVyv
        ODG3uDQvXS85P3cTIzj9aXntYHz44IPeIUYmDsZDjBIczEoivM6/X8QJ8aYkVlalFuXHF5Xm
        pBYfYpTmYFES51X6cSZOSCA9sSQ1OzW1ILUIJsvEwSnVwLTi8f93uyWWMXyQWDq7V3nTpT3T
        vn16++PQvxV7fsVqnbnGfmzxys3duknOgSIR6q/WrFNhkVz27cJWizU1a6VKrt7uuvlSRLP0
        Q51y69yH9dJztdW+7vX2DHl6yOvUq1OCv/gK/GJaAhsS9eWCurqnFJxYfvLp6rvxRRWPul4c
        PXlhMjvP0Zu6H289Dzj+du6yL++XZHtGCjLvkHhlFmQm767xc2Xj4d1BZ9y6pSQf/jysPOc7
        454HN5q3VM/g2+p2Pmre9er7z9lmy1bN9raxCvg4227S+0dSym665wpvB0xf9bJt4+WQ1PfZ
        1v865i2d+mrT1/jV3zoOTL0p/WXij45J1zZw3lz7Ql3dQt1bcK8SS3FGoqEWc1FxIgAv9xCf
        7gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsWy7bCSnG70/tdxBr0X+CxW3+1ns+j6t4XF
        orX9G5PFytVHmSzetZ5jsXh85zO7xbb9B9kspkxrYrTYe0vbYs/ekywWl3fNYbNYsf0Ii8W2
        3/OZLa5MWcRs8frHSTaL83+PszoIeFw+W+qx6dMkdo/uqz8YPXbfbGDz6NuyitHj8yY5j/YD
        3Uwem568ZQrgiOKySUnNySxLLdK3S+DK+P74J3PBK66KI/NfsjYw/uXoYuTkkBAwkWg818nY
        xcjFISSwg1Fiw9TfbBAJcYnmaz/YIWxhiZX/nrNDFD1hlFg79QdYEYuAqsT25ROBujk42AQ0
        JS5MLgUJiwANXd07HWwos0Abs8Ss25/A6oUFHCRuzJ/JCGLzCuhL/Ps1kQVi6GlGiemTz7BC
        JAQlTs58wgJiMwuYSczb/JAZZAGzgLTE8n8cEGF5ieats5lBbE4Be4kL238wgdiiAsoSB7Yd
        Z5rAKDQLyaRZSCbNQpg0C8mkBYwsqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxgiNV
        S2sH455VH/QOMTJxMB5ilOBgVhLhdf79Ik6INyWxsiq1KD++qDQntfgQozQHi5I479dZC+OE
        BNITS1KzU1MLUotgskwcnFINTE0xDCKKdlW6937I9TyceG7aqYlp0xxvPZvvKLxs7tJL3lf3
        hna9ur3p0xqdsCDVlSZGq0LVE0Ocb4QodDQ+eaSVku2jUeH6PLzB+WCiFGfxwk75HxNf9jvH
        lmurHipucPmnnea6p5I1cnq3AY/LnHilFNvgd/9bI2Tdl8V3sc0Qbdnl9vHYmzWWs8MzDmzr
        YPnjoDixxVF4RdGrur50e9UPTVX6Vlx7wzea6q79IBFhy7tJ5LQgQ06Q+JM9ByboPQwt2q/M
        syr7SwIfC69FadJU1bMPLs3f/FWa4cjyuKqUuTOfXng6e6vFv/QrO6/+rlXn/vDj0LmehXdC
        ba+el2S6szWiNlB0dvqT3I2nlViKMxINtZiLihMB/ZbRc0MDAAA=
X-CMS-MailID: 20200618192411epcas5p125327503f93cafa1d019052f00e54946
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----O02wVW_TA_CRdKetSaQOVhdyQBrcCciqckW4gUYQTxE5eUA6=_781db_"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200617172653epcas5p488de50090415eb802e62acc0e23d8812
References: <CGME20200617172653epcas5p488de50090415eb802e62acc0e23d8812@epcas5p4.samsung.com>
        <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
        <f503c488-fa00-4fe2-1ceb-7093ea429e45@lightnvm.io>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------O02wVW_TA_CRdKetSaQOVhdyQBrcCciqckW4gUYQTxE5eUA6=_781db_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Thu, Jun 18, 2020 at 10:04:32AM +0200, Matias Bjørling wrote:
>On 17/06/2020 19.23, Kanchan Joshi wrote:
>>This patchset enables issuing zone-append using aio and io-uring direct-io interface.
>>
>>For aio, this introduces opcode IOCB_CMD_ZONE_APPEND. Application uses start LBA
>>of the zone to issue append. On completion 'res2' field is used to return
>>zone-relative offset.
>>
>>For io-uring, this introduces three opcodes: IORING_OP_ZONE_APPEND/APPENDV/APPENDV_FIXED.
>>Since io_uring does not have aio-like res2, cqe->flags are repurposed to return zone-relative offset
>
>Please provide a pointers to applications that are updated and ready 
>to take advantage of zone append.
>
>I do not believe it's beneficial at this point to change the libaio 
>API, applications that would want to use this API, should anyway 
>switch to use io_uring.
>
>Please also note that applications and libraries that want to take 
>advantage of zone append, can already use the zonefs file-system, as 
>it will use the zone append command when applicable.

AFAIK, zonefs uses append while serving synchronous I/O. And append bio
is waited upon synchronously. That maybe serving some purpose I do
not know currently. But it seems applications using zonefs file
abstraction will get benefitted if they could use the append themselves to
carry the I/O, asynchronously.

------O02wVW_TA_CRdKetSaQOVhdyQBrcCciqckW4gUYQTxE5eUA6=_781db_
Content-Type: text/plain; charset="utf-8"


------O02wVW_TA_CRdKetSaQOVhdyQBrcCciqckW4gUYQTxE5eUA6=_781db_--
