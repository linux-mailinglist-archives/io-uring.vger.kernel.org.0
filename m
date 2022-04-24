Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963AD50D3D9
	for <lists+io-uring@lfdr.de>; Sun, 24 Apr 2022 19:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbiDXRTc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Apr 2022 13:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236263AbiDXRTa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Apr 2022 13:19:30 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531C26D953
        for <io-uring@vger.kernel.org>; Sun, 24 Apr 2022 10:16:25 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220424171619epoutp01b51da81585330d804e4c450db57bbfc2~o5JIAFVWQ2903529035epoutp01e
        for <io-uring@vger.kernel.org>; Sun, 24 Apr 2022 17:16:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220424171619epoutp01b51da81585330d804e4c450db57bbfc2~o5JIAFVWQ2903529035epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1650820579;
        bh=nAIoypRHCZA/hvejHR9v9mOw1ui2vYofBsobvQhl5Ak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JvZqUevyboF+sciGVXhaOMuSQcnDr2hsN0bbL0qvSG7l1+bnuyFfTqQsuaWdCPtIH
         lhhMKJPyrDr0T5IPIVHmWyE4cL94YWEHdPQMu+NP9qbKwsdLTpOnk3n77uSh2pkdcS
         yzxZMVk77BFy7zHXAwMRo51a+qJVzGu8a7Ol9UUc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220424171617epcas5p257001a85af4d8f638b300c5a61c1ebed~o5JG12c3_0617806178epcas5p2u;
        Sun, 24 Apr 2022 17:16:17 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KmZYW3SpCz4x9Pq; Sun, 24 Apr
        2022 17:16:15 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4A.9C.10063.FD585626; Mon, 25 Apr 2022 02:16:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220424062750epcas5p171327153c4d84f0925fa93cf749eef5f~owS7DeYky2034420344epcas5p12;
        Sun, 24 Apr 2022 06:27:50 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220424062750epsmtrp12536629ad32b9d9e3d51c6291caa0119~owS7Cxe5w3189231892epsmtrp1c;
        Sun, 24 Apr 2022 06:27:50 +0000 (GMT)
X-AuditID: b6c32a49-4cbff7000000274f-28-626585df9085
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        AA.41.08924.5EDE4626; Sun, 24 Apr 2022 15:27:49 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220424062749epsmtip281f72d85007bf7327e1b76856156a47b~owS6ZcCbv1426214262epsmtip2H;
        Sun, 24 Apr 2022 06:27:49 +0000 (GMT)
Date:   Sun, 24 Apr 2022 11:52:41 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] io_uring: cleanup error-handling around io_req_complete
Message-ID: <20220424062241.GA17917@test-zns>
MIME-Version: 1.0
In-Reply-To: <ca1767ba-0398-e26e-4e80-fe339e769c01@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmhu791tQkgw/fhS1W3+1ns1i5+iiT
        xbvWcywOzB6Xz5Z67L7ZwObxeZNcAHNUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
        pYW5kkJeYm6qrZKLT4CuW2YO0B4lhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJ
        gV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGg2kz2Au62CsWb3nJ3sDYz9bFyMkhIWAisfzjT6Yu
        Ri4OIYHdjBKr32+Dcj4xSry+1skC4XxmlPgx4wQjTMvJmzNYIRK7GCV2dR+Acp4BVXW2sYJU
        sQioSsyYtx+onYODTUBT4sLkUpCwiICCRM/vlWC7mQU0JHq2rwcbKizgI3Fm+yImkHJeAV2J
        yT8jQcK8AoISJ2c+YQGxOQVsJZ5PucQOYosKKEsc2HYc7FIJgUvsErvPbgVbJSHgInG10xDi
        TmGJV8e3sEPYUhIv+9ug7GSJ1u2X2SHKSySWLFCHCNtLXNzzlwnisnSJ1r33oMplJaaeWgcV
        55Po/f2ECSLOK7FjHoytKHFv0lNWCFtc4uGMJVC2h8TTe5+hoXOAUWLa92nsExjlZyF5bRaS
        fRC2lUTnhybWWUDnMQtISyz/xwFhakqs36W/gJF1FaNkakFxbnpqsWmBYV5qOTy6k/NzNzGC
        E6GW5w7Guw8+6B1iZOJgPMQowcGsJML7ujc5SYg3JbGyKrUoP76oNCe1+BCjKTCiJjJLiSbn
        A1NxXkm8oYmlgYmZmZmJpbGZoZI47+n0DYlCAumJJanZqakFqUUwfUwcnFINTNFNyRGSm/fO
        mVivNKGt21fY1X6O/+WzF9a+sH/yi32ra59A/8VSJwYn7y9Lp4qpmFi/nvtwXr55zKXqr+XW
        x37wcYUVpzBuvn/mgNaslqPPYkwWF1UfkWP53LS9wCp5ho681Wc/R5alzZn1E8uy/vc/v3nw
        hdfpF3pse9SCXgY+DrQo+7HW+o2w61TV8AUzX4a7X7odeW7m4YtFt+retQvf/vDL7GPMiqDb
        qcn9P6U0/mftnSb0Ijryw824M59lv/ltCPM8PK85evHetQ0+WW0PP647ESdYsCjTd1buFrUH
        /V+Nk9S+5y4RvXhTO+6OmYKT69nyzLrGjfqiNxbnXPCPerl8Zv0Me6EHJvt2vlJiKc5INNRi
        LipOBABl2TbvDQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsWy7bCSvO7TtylJBo8/m1msvtvPZrFy9VEm
        i3et51gcmD0uny312H2zgc3j8ya5AOYoLpuU1JzMstQifbsErowPh5wL9rNU3Ol6z97AeI+5
        i5GTQ0LAROLkzRmsXYxcHEICOxglln/8ywaREJdovvaDHcIWllj57zk7RNETRolP7w6CJVgE
        VCVmzNvP0sXIwcEmoClxYXIpSFhEQEGi5/dKsDnMAhoSPdvXM4LYwgI+Eme2L2ICKecV0JWY
        /DMSYuQBRokfTUvAangFBCVOznzCAtFrJjFv80NmkHpmAWmJ5f84QMKcArYSz6dcArtAVEBZ
        4sC240wTGAVnIemehaR7FkL3AkbmVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwQGs
        pbWDcc+qD3qHGJk4GA8xSnAwK4nwvu5NThLiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQ
        QHpiSWp2ampBahFMlomDU6qB6fy1Do0V7UdP3t6ZOU1K9Irou5iFyk/afvcIqtzlvZ8x7UFJ
        d8qXZ5enluY6ZN2bciLs9VGBe7Z1T+duv9fVc3hf9udZ1fqijo4r2+ZyqlxWtnpr8yFIWuDJ
        nLzdL3/vqpRIld77UK9/4QoN/43n4mr/beOd7twQdvcyk9KyjgmLtLg/vLZ+lOD/im1rYY9d
        vcLuI7N/Sgk18byv/uf4S+D7isPLlHfxeyVfsM9b89J476QGezdW6afmfe8m/P90hyHi4jv/
        5eJm4rl55h7iIVuClee0TrPVZFNMm+HUvCt1NUs6z9LZb3V/zluy/O72vVPUszWOTV2UW9y6
        7U7vhDY5ZytbOdt5v9k+asyyPa7EUpyRaKjFXFScCAACAeO0zwIAAA==
X-CMS-MailID: 20220424062750epcas5p171327153c4d84f0925fa93cf749eef5f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----KqMzgBRJR.Fsk82YJsMcER2lgAm37zzR_kphVf-KeEbAMdws=_174c_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220422101608epcas5p22e9c82eb1b3beef6bf6e1c2e83b4b19b
References: <CGME20220422101608epcas5p22e9c82eb1b3beef6bf6e1c2e83b4b19b@epcas5p2.samsung.com>
        <20220422101048.419942-1-joshi.k@samsung.com>
        <ca1767ba-0398-e26e-4e80-fe339e769c01@kernel.dk>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------KqMzgBRJR.Fsk82YJsMcER2lgAm37zzR_kphVf-KeEbAMdws=_174c_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Sat, Apr 23, 2022 at 12:06:05PM -0600, Jens Axboe wrote:
>On 4/22/22 4:10 AM, Kanchan Joshi wrote:
>> Move common error-handling to io_req_complete, so that various callers
>> avoid repeating that. Few callers (io_tee, io_splice) require slightly
>> different handling. These are changed to use __io_req_complete instead.
>
>This seems incomplete, missing msgring and openat2 at least? I do like
>the change though. Care to respin a v2?

But both (io_msg_ring, and io_openat2) are already using
__io_req_complete (and not io_req_complete). So nothing is amiss?

------KqMzgBRJR.Fsk82YJsMcER2lgAm37zzR_kphVf-KeEbAMdws=_174c_
Content-Type: text/plain; charset="utf-8"


------KqMzgBRJR.Fsk82YJsMcER2lgAm37zzR_kphVf-KeEbAMdws=_174c_--
