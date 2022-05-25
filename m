Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079125336F4
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 08:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242537AbiEYGwB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 02:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244260AbiEYGv7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 02:51:59 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F0726544
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 23:51:58 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220525065154epoutp020a64e385b6b3ba97e3e2fd37e601905c~yRnyvAgkf0512105121epoutp02d
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 06:51:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220525065154epoutp020a64e385b6b3ba97e3e2fd37e601905c~yRnyvAgkf0512105121epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653461514;
        bh=3m/e4WBGQkM9HeE51hTJw4lOlxjtWlDOK1sICKDyxk0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rYFnv7ot6VKIHDKR1hxPO5ShmwQQbwarNrJwqy3T0NcY2sUDcNE8nSDg4YcIn1VZE
         tjEvtUNxmaG6MbMr6X8ndSykGQLbMG/r0t420Dt8DcteJFQHFgmIWqa/rEgWTu3Spz
         eK1vJ41wN/w4OyMjhZ2umkWnlYaZpgl+mStRzgx0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220525065153epcas5p2a46f26d4fed4dc27426d70c571e18211~yRnyIdoYH1961919619epcas5p2h;
        Wed, 25 May 2022 06:51:53 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4L7MDk3zwcz4x9QB; Wed, 25 May
        2022 06:51:50 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        44.B0.09827.302DD826; Wed, 25 May 2022 15:51:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220525064713epcas5p2fd7d25b66b54108f29265e7b51091e1b~yRjtZGGTQ0296702967epcas5p2B;
        Wed, 25 May 2022 06:47:13 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220525064713epsmtrp2592da526f9db8c5928852e3d1eb0ef37~yRjtXaFCJ1148211482epsmtrp2N;
        Wed, 25 May 2022 06:47:13 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-7b-628dd203a970
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.2E.08924.1F0DD826; Wed, 25 May 2022 15:47:13 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220525064713epsmtip169a2f4afa2fa7465aced2d4a71d9e9d7~yRjst2nBd1372513725epsmtip1H;
        Wed, 25 May 2022 06:47:13 +0000 (GMT)
Date:   Wed, 25 May 2022 12:11:59 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 3/6] io_uring: add io_op_defs 'def' pointer in req init
 and issue
Message-ID: <20220525064159.GD4491@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220524213727.409630-4-axboe@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsWy7bCmui7zpd4kg5171C1W3+1ns3jXeo7F
        gcnj8tlSj8+b5AKYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22V
        XHwCdN0yc4CmKymUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0ihNzi0vz0vXy
        UkusDA0MjEyBChOyMz4cm8VSMIu1YtP7L6wNjCdZuhg5OSQETCRmTrnM2MXIxSEksJtR4uqd
        CVDOJ0aJe0cOMkE4nxkltv/ZyA7T8un6DzaIxC5GiWUH5rFDOM8YJTYsn84KUsUioCrx7s0V
        oAQHB5uApsSFyaUgYREBBYme3yvZQGxmARmJyXMug5UIC4RL9C8D6+QV0JE42/+YBcIWlDg5
        8wmYzSlgJvHk839GEFtUQFniwLbjYMdJCOxjlzi05hsrxHEuEn33TzND2MISr45vgTpaSuLz
        u71sEHayROt2iL0SAiUSSxaoQ4TtJS7u+csEcVqGxOcJWxkh4rISU0+tg4rzSfT+fsIEEeeV
        2DEPxlaUuDfpKdQJ4hIPZyyBsj0kzk3ZCA2erYwSOx+dYJ3AKD8LyW+zkOyDsK0kOj80sc4C
        Oo9ZQFpi+T8OCFNTYv0u/QWMrKsYJVMLinPTU4tNC4zyUsvh8Z2cn7uJEZz2tLx2MD588EHv
        ECMTB+MhRgkOZiUR3pzFvUlCvCmJlVWpRfnxRaU5qcWHGE2BMTWRWUo0OR+YePNK4g1NLA1M
        zMzMTCyNzQyVxHkF/jcmCQmkJ5akZqemFqQWwfQxcXBKNTDtPT/H6sbrfB9XsUQ+tkKDn44L
        WC/rMLtfTp/y6K/YqSkFClyL0h2cF3EV1rluzFkhfu+C4+0jHxftCphizmhzg+G41PkWi4gH
        3NcE55RM2d2yaM5D07ACrRNc+/9N6Xz2+NgplZw9B/lNOliOWS2qunFh94b50bZNr3P+F5t4
        rSh1YUjwXZgtsXDW9yY1YYf5p6RX1IX68YvKv37/6ucan189nC1CgptS0v0PnF2sf/SMVHqP
        heb9x2fu5Uz7rv3e+xjPTvnU1qqYxpiH6jMUfx+o+vM1hPfoyqgd5l+2n6jgvafIJ2ooxmFu
        4ZqY9eVecvtvkwsOnmfrNhW1S6Wk36uef7pV994E3V3NGepKLMUZiYZazEXFiQBhFxbaBAQA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWy7bCSnO7HC71JBndn6lmsvtvPZvGu9RyL
        A5PH5bOlHp83yQUwRXHZpKTmZJalFunbJXBlNB9YzlpwhqniyZZ9LA2MU5m6GDk5JARMJD5d
        /8HWxcjFISSwg1Fie99CFoiEuETztR/sELawxMp/z9khip4wShx91sgMkmARUJV49+YKUIKD
        g01AU+LC5FKQsIiAgkTP75VsIDazgIzE5DmXwUqEBcIl+pexgoR5BXQkzvY/ZoEYuZVR4uWZ
        R+wQCUGJkzOfsED0mknM2/yQGaSXWUBaYvk/DpAwJ1D4yef/jCC2qICyxIFtx5kmMArOQtI9
        C0n3LITuBYzMqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxgsNVS2sH455VH/QOMTJx
        MB5ilOBgVhLhzVncmyTEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKY
        LBMHp1QDkxLfA0HNmEz9hsKdhRJeGv1hwqx3DO+rnbJcPMPVZ1q6xZXHz37n7KyVnFXqH2Zw
        hEF1t432ZP2pcnH8Gkue3z3DOdWq2kAhZV33vCmlSRfrHd4Z+IgKLZypmv7PbWNP1Omby+5m
        lfw9tnaX7WPZGOtVK1bd3nnmlGX9pu134pW7DpkvOz0vmaf5398puYdrT9asef/v0bzg5Sm3
        fdSfruOM1Kjt8JhpL1d4RWBH+GuTnmnOevfy6tfy6ZiG9z180Scz9+QiASV+kaI7l8Ofyxrs
        2CB/MfhLgf7m546vt2S/neLZz/VVWWl+D9//e5NizxntU1slc87D5KpAeT3rwQ6j/W9vPMgu
        DuP6lNefoMRSnJFoqMVcVJwIADxGmLHGAgAA
X-CMS-MailID: 20220525064713epcas5p2fd7d25b66b54108f29265e7b51091e1b
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----OaRT8jiSLvKUs3WAABZSk-FavpLm249Qe.Imk-d4uY-X0TwC=_1f9c5_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220524213742epcas5p19444ad9556b07159c8fca0512792ea48
References: <20220524213727.409630-1-axboe@kernel.dk>
        <CGME20220524213742epcas5p19444ad9556b07159c8fca0512792ea48@epcas5p1.samsung.com>
        <20220524213727.409630-4-axboe@kernel.dk>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------OaRT8jiSLvKUs3WAABZSk-FavpLm249Qe.Imk-d4uY-X0TwC=_1f9c5_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, May 24, 2022 at 03:37:24PM -0600, Jens Axboe wrote:
>Define and set it when appropriate, and use it consistently in the
>function rather than using io_op_defs[opcode].

seems you skipped doing this inside io_alloc_async_data() because
access is not that repetitive.

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

------OaRT8jiSLvKUs3WAABZSk-FavpLm249Qe.Imk-d4uY-X0TwC=_1f9c5_
Content-Type: text/plain; charset="utf-8"


------OaRT8jiSLvKUs3WAABZSk-FavpLm249Qe.Imk-d4uY-X0TwC=_1f9c5_--
