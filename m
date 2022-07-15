Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016AA575FD2
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 13:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbiGOLMl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 07:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiGOLMk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 07:12:40 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C5A87216
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 04:12:35 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220715111230epoutp022c9a869940586ecfdfa763151ebb5faf~B-E4oOT8M3162831628epoutp02L
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 11:12:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220715111230epoutp022c9a869940586ecfdfa763151ebb5faf~B-E4oOT8M3162831628epoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657883550;
        bh=Ji9OfW4MTOZofKIL3li59siIKM0d+5nNRqymbyXJlds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RtfcvVhl77Quvi1PE3X2uXnb1Zq/HuHYTkEMhjC0GoEa5xt6yoW5CkvpruTi0zG30
         8806yF7OOUj2NU19I23aI+JJe4qDTeVCGYZ2I3iXK577w/YX09IP6bJ3+igBBcDObV
         KOFQnMHDNYikWJaeX7lcugA2ycjkQkWshXYC40HQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220715111229epcas5p24cdb6c2dedae889189ca6cd8518586ad~B-E4MiZHX0850708507epcas5p21;
        Fri, 15 Jul 2022 11:12:29 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Lkpbt2TW0z4x9Py; Fri, 15 Jul
        2022 11:12:26 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.46.09662.A9B41D26; Fri, 15 Jul 2022 20:12:26 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220715111225epcas5p174b037b8b850300e1ff2d1b96dd0a64d~B-E0ZA86c1396213962epcas5p12;
        Fri, 15 Jul 2022 11:12:25 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220715111225epsmtrp191da074f2d6e26c34a8a4fc31f69d141~B-E0YGCWd1475014750epsmtrp1q;
        Fri, 15 Jul 2022 11:12:25 +0000 (GMT)
X-AuditID: b6c32a49-885ff700000025be-44-62d14b9a3566
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1C.63.08802.99B41D26; Fri, 15 Jul 2022 20:12:25 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220715111223epsmtip243bea6f75bf92c0416d33c21c9e224ea~B-EycOCFr1601816018epsmtip2b;
        Fri, 15 Jul 2022 11:12:23 +0000 (GMT)
Date:   Fri, 15 Jul 2022 16:37:00 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     Ming Lei <ming.lei@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
        Jens Axboe <axboe@kernel.dk>, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH for-next 3/4] io_uring: grow a field in struct
 io_uring_cmd
Message-ID: <20220715110700.GA27117@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220714153051.5e53zgkcabb7ajms@carbon.lan>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEJsWRmVeSWpSXmKPExsWy7bCmuu4s74tJBtO6+C2aJvxltpizahuj
        xeq7/WwWhx9PYre4eWAnk8XK1UeZLN61nmOxOP/2MJPFpEPXGC323tK2mL/sKbvFocnNTBbr
        Xr9nceD12DnrLrvH+XsbWTwuny312LSqk81j85J6j903G9g83u+7yubRt2UVo8fm09UenzfJ
        BXBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2u
        pFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUq
        TMjOeNd5irngF1fFonV7WRsYp3F2MXJySAiYSEx9sIMFxBYS2M0ocW2maxcjF5D9iVFiT1sT
        I4TzmVHi8cObzDAdq+4eZoFI7GKU6Lp1mBXCecYocfTMLjaQKhYBVYl7hycwdTFycLAJaEpc
        mFwKEhYRUJbY/n8bWDOzwE4miUcPNjCCJIQFAiVW9+5hB7F5BXQlnl8/xgRhC0qcnPkE7D5O
        AUuJgyfPgtWIAg06sO04E8ggCYELHBKbu64yQZznIjH903OoU4UlXh3fwg5hS0m87G+DspMl
        Ls08B1VfIvF4z0Eo216i9VQ/WC+zQKbEpQ/T2CBsPone30/AnpEQ4JXoaBOCKFeUuDfpKSuE
        LS7xcMYSKNtD4uatvWyQQDnKLHHl4HnWCYxys5D8MwvJCgjbSqLzQxPrLKAVzALSEsv/cUCY
        mhLrd+kvYGRdxSiZWlCcm55abFpgmJdaDo/k5PzcTYzgxKzluYPx7oMPeocYmTgYDzFKcDAr
        ifB2HzqXJMSbklhZlVqUH19UmpNafIjRFBg/E5mlRJPzgbkhryTe0MTSwMTMzMzE0tjMUEmc
        1+vqpiQhgfTEktTs1NSC1CKYPiYOTqkGJo2oH5PqSrbPmBd0JkjIOWHdHrN3vz57FN+PulPP
        FJN+yKw2Ypvn+n1PyrZ0bwhPfOWrmigZwuJ7dUdd6aMENzaHpllKolNePP900YUld5XVJ/3z
        2Qu2qeXKukYrsy41nD5X2Ma6JWWZ5B032zM2/za1HL63bHNO8cZJ+5UWG0w4WNhtN3P1xy6d
        vaHzA+aWyfue+LafM/irfsO5En2NShG1vMsnlMVlb7Ib/30zhfVW6+wJTucFjBleelcfuMMt
        HW24jWHy+54iVw/Jsw2/3l4uaGZg/5dmM4/jZc4k+3TlgBKJB/95ej2X6dTcXjeNoeL8m/DJ
        lfkRuu/SmXd7PjL6/+k2X/1GnWO2Vn7iSizFGYmGWsxFxYkAy3CCulUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSvO5M74tJBk9ajSyaJvxltpizahuj
        xeq7/WwWhx9PYre4eWAnk8XK1UeZLN61nmOxOP/2MJPFpEPXGC323tK2mL/sKbvFocnNTBbr
        Xr9nceD12DnrLrvH+XsbWTwuny312LSqk81j85J6j903G9g83u+7yubRt2UVo8fm09UenzfJ
        BXBFcdmkpOZklqUW6dslcGXcb/jGVrCSo2Lr9F9MDYz32boYOTkkBEwkVt09zNLFyMUhJLCD
        UWLxtzWMEAlxieZrP9ghbGGJlf+eg9lCAk8YJX5dCAGxWQRUJe4dnsDUxcjBwSagKXFhcilI
        WERAWWL7/21gM5kFdjJJrDv5EmyZsECgxOrePWBzeAV0JZ5fP8YEsfg4s8SyBxtZIRKCEidn
        PmEBsZkFzCTmbX7IDLKAWUBaYvk/DpAwp4ClxMGTZ8HmiAItO7DtONMERsFZSLpnIemehdC9
        gJF5FaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcKRpae1g3LPqg94hRiYOxkOMEhzM
        SiK83YfOJQnxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXA
        VP3tjxETa9gMGcurEnpMOWufxU9qD7B3/f7xouNLln3n+R2fSjEs3Fwb02jk/XbbRP/zO/v/
        PjcytVXdc+9Hxfqu77+szyy2n2s4ua1POHzynQ6rlRMv7U+x3vzbuMXy8ozm1PIn0w6uMhXJ
        +ceqcMO/sK7v2T/rkmfBX5Y+a9AyU5nWrHXi4SLDSXzW/aLJy5grLfU0r2zb9vaW6drv597u
        PrHRZfGcH8cunJrxYu58C5ZnHMt8uP4YPOHdOZ3HPL3llFuI2oTQlC3Ma/69vzvlxqnVU89/
        Z/64+6bXiazJyeUWB2fqahXPF5H8IPtLMkcmZGlEnC3DlLerVjuZH5yze/nxP92f7Dacyn5x
        wvitEktxRqKhFnNRcSIAQmnjCyMDAAA=
X-CMS-MailID: 20220715111225epcas5p174b037b8b850300e1ff2d1b96dd0a64d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_13446e_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b
References: <20220711110155.649153-1-joshi.k@samsung.com>
        <CGME20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b@epcas5p2.samsung.com>
        <20220711110155.649153-4-joshi.k@samsung.com>
        <2b644543-9a54-c6c4-fd94-f2a64d0701fa@kernel.dk>
        <43955a42-7185-2afc-9a55-80cc2de53bf9@grimberg.me>
        <96fcba9a-76ad-8e04-e94e-b6ec5934f84e@grimberg.me> <Ys+QPjYBDoByrfw1@T590>
        <20220714081923.GE30733@test-zns>
        <20220714153051.5e53zgkcabb7ajms@carbon.lan>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_13446e_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, Jul 14, 2022 at 05:30:51PM +0200, Daniel Wagner wrote:
>On Thu, Jul 14, 2022 at 01:49:23PM +0530, Kanchan Joshi wrote:
>> If path is not available, retry is not done immediately rather we wait for
>> path to be available (as underlying controller may still be
>> resetting/connecting). List helped as command gets added into
>> it (and submitter/io_uring gets the control back), and retry is done
>> exact point in time.
>> But yes, it won't harm if we do couple of retries even if path is known
>> not to be available (somewhat like iopoll). As this situation is
>> not common. And with that scheme, we don't have to link io_uring_cmd.
>
>Stupid question does it only fail over immediately when the path is not
>available or any failure? If it fails over for everything it's possible
>the target gets the same request twice. FWIW, we are just debugging this
>scenario right now.

failover is only for path-related failure, and not otherwise.
you might want to take a look at nvme_decide_disposition routine where
it makes that decision.

------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_13446e_
Content-Type: text/plain; charset="utf-8"


------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_13446e_--
