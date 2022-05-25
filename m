Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DEB5339D9
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 11:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiEYJWp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 05:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiEYJWn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 05:22:43 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2489B8A302
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 02:22:41 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220525092238epoutp045c5da85823082948d92c06a3307142cc~yTraCxCNy2497224972epoutp04g
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 09:22:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220525092238epoutp045c5da85823082948d92c06a3307142cc~yTraCxCNy2497224972epoutp04g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653470559;
        bh=XPUJg8ivdpPamcmqfiVqNDr+tvT32I8Bh8Wg2+Zp1Wo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BFOj+kZdzdreFioCSyo4NKH6mJFdwcdiQri5gB02dY6UNtGkdTvuf5cQIr150VJGr
         kQIhxWxfwnLouKGUg5o8q/663xl2CQc93E3xzq3iZ5ryApsmPJH5+5HeB5QOjh5sJW
         mC9b5IaGlH2BoJ7BVR7qec5IN0ncuSQzIiqi4JaE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220525092238epcas5p4be490e3c1bb4182043505c5ab36684df~yTrZmQCWM2088920889epcas5p48;
        Wed, 25 May 2022 09:22:38 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4L7QZf0ZFyz4x9Py; Wed, 25 May
        2022 09:22:34 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        17.71.09827.455FD826; Wed, 25 May 2022 18:22:28 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220525085148epcas5p339c046544073cfaefee21dbcd0747329~yTQenQAW10516705167epcas5p3H;
        Wed, 25 May 2022 08:51:48 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220525085148epsmtrp2be82d6efd57a5fb300d69d471a94d3c4~yTQemkyiV2033120331epsmtrp2o;
        Wed, 25 May 2022 08:51:48 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-2e-628df554fa6b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9F.EC.08924.42EED826; Wed, 25 May 2022 17:51:48 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220525085147epsmtip1162c5d628ee4f6daf5418bf9f2793e5e~yTQeDSgIV2404624046epsmtip1C;
        Wed, 25 May 2022 08:51:47 +0000 (GMT)
Date:   Wed, 25 May 2022 14:16:32 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 5/6] io_uring: drop confusion between cleanup flags
Message-ID: <20220525084632.GA7442@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220524213727.409630-6-axboe@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsWy7bCmhm7I194kg5d7eSxW3+1ns3jXeo7F
        gcnj8tlSj8+b5AKYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22V
        XHwCdN0yc4CmKymUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0ihNzi0vz0vXy
        UkusDA0MjEyBChOyM04/+MlccIG74m7/NPYGxtecXYycHBICJhKn5j1i7mLk4hAS2M0o8f3z
        cTYI5xOjxJ8dM9hAqoQEPjNKHP7hCtPx9uldRoiiXYwS1w99gGp/xijxdsUaJpAqFgFViSfd
        U4BsDg42AU2JC5NLQcIiAgoSPb9Xgg1lFpCRmDznMjuILSzgLtG7YgcjiM0roCNxaOMpZghb
        UOLkzCcsIDangJnE2/vbwHpFBZQlDmw7zgSyV0LgELvE00W3wXZJCLhI3PwbD3GosMSr41vY
        IWwpic/v9rJB2MkSrdtB9oKUl0gsWaAOEbaXuLjnLxPEaRkSKz+3skDEZSWmnloHFeeT6P39
        hAkiziuxYx6MrShxb9JTVghbXOLhjCVQtofE6ivHocGzlVHia9MZ5gmM8rOQvDYLyT4I20qi
        80MT6yyg85gFpCWW/+OAMDUl1u/SX8DIuopRMrWgODc9tdi0wCgvtRwe3cn5uZsYwUlPy2sH
        48MHH/QOMTJxMB5ilOBgVhLhvfC0N0mINyWxsiq1KD++qDQntfgQoykwpiYyS4km5wPTbl5J
        vKGJpYGJmZmZiaWxmaGSOK/A/8YkIYH0xJLU7NTUgtQimD4mDk6pBqaE6Bhmi6PyWTOWb7xi
        o77CLn/GotiLD1VvzKuO+fOV2fVLQNvke382//N+/WjNvMkiTxa2bfu9OXWJUOSWjScUk78d
        P32HS+/XTqV99+zn6l/RVnHOvDpTYu3xtZd//r5Y+/3kc/cjt0wZqiYLyq562F/LVcxsfCj6
        y5a4e5sWXpi4yGnlh3dhn9qWSl9ln3Xtws0LLxWP/M1KfnXivc9xY8Z/saqid9JlU3ZPjvWs
        TLR6WdCp1TP187b4/fwth6oWiZtx3TJ+nj1544uPl9pWTj22POTr4cgrF5MVVYKvfL8bIJl1
        7vaVFYcb7jd8mc3y2utqjNoO0ag4S5+Vr8xSxO68VQ+rDJQ3FEsVd/RKWK/EUpyRaKjFXFSc
        CAClO5sSAwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWy7bCSnK7Ku94kg1lnhC1W3+1ns3jXeo7F
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyXj6Yw1rQxFnReWgeSwPjdvYuRk4OCQETibdP
        7zJ2MXJxCAnsYJT4cOwcM0RCXKL52g+oImGJlf+es0MUPWGUWLHgAAtIgkVAVeJJ9xSmLkYO
        DjYBTYkLk0tBwiICChI9v1eygdjMAjISk+dcBpsjLOAu0btiByOIzSugI3Fo4ymwXUICWxkl
        3h7Qh4gLSpyc+YQFotdMYt7mh8wg45kFpCWW/+MACXMChd/e3wY2XlRAWeLAtuNMExgFZyHp
        noWkexZC9wJG5lWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMHhqqW1g3HPqg96hxiZ
        OBgPMUpwMCuJ8F542pskxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQi
        mCwTB6dUAxPPg5NS16xF87l9P/xlslV+4WZyZvK5RYdsW3uYJ3x7ZLblKM+9zJzDnrNDpt07
        7Hyw/EupzvLvE8w02X3+vH+n17ujKVfP5Jf0CefQake2BXzqrDtOVF+Kr+9Zm+DYxbE9cE3W
        9j0XK1Z2KDelLFfxjEycuWmN7cN5Kesm3HrzZuKxV5caWr6muf2K5i9ZpvLxpmfKo5+/otJE
        rn4yXxl7+KOAndLyg8YH/m6Z8EfxUs4Pp0TTv8FrzUPbtrh9O3ZeZmG9JLepjq1F4IUVM/do
        bbmw3PT6101Gh7ZsW9e28b+GTYUm95y1d+c5CQfX8R+0V+ptKzmhIyOlKp8sqDH9BzufTkRQ
        99PTRrefLVNTYinOSDTUYi4qTgQAG1TprcYCAAA=
X-CMS-MailID: 20220525085148epcas5p339c046544073cfaefee21dbcd0747329
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----OaRT8jiSLvKUs3WAABZSk-FavpLm249Qe.Imk-d4uY-X0TwC=_207dc_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220524213745epcas5p20d52948d7d4a07ff8b7830d19ae4596d
References: <20220524213727.409630-1-axboe@kernel.dk>
        <CGME20220524213745epcas5p20d52948d7d4a07ff8b7830d19ae4596d@epcas5p2.samsung.com>
        <20220524213727.409630-6-axboe@kernel.dk>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------OaRT8jiSLvKUs3WAABZSk-FavpLm249Qe.Imk-d4uY-X0TwC=_207dc_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, May 24, 2022 at 03:37:26PM -0600, Jens Axboe wrote:
>If the opcode only stores data that needs to be kfree'ed in
>req->async_data, then it doesn't need special handling in
>our cleanup handler.
>
>This has the added bonus of removing knowledge of those kinds of
>special async_data to the io_uring core.
>
>Signed-off-by: Jens Axboe <axboe@kernel.dk>
>---
> fs/io_uring.c | 18 ------------------
> 1 file changed, 18 deletions(-)
>
>diff --git a/fs/io_uring.c b/fs/io_uring.c
>index 408265a03563..8188c47956ad 100644
>--- a/fs/io_uring.c
>+++ b/fs/io_uring.c
>@@ -8229,24 +8229,6 @@ static void io_clean_op(struct io_kiocb *req)
>
> 	if (req->flags & REQ_F_NEED_CLEANUP) {
> 		switch (req->opcode) {
>-		case IORING_OP_READV:
>-		case IORING_OP_READ_FIXED:
>-		case IORING_OP_READ:
>-		case IORING_OP_WRITEV:
>-		case IORING_OP_WRITE_FIXED:
>-		case IORING_OP_WRITE: {
>-			struct io_async_rw *io = req->async_data;
>-
>-			kfree(io->free_iovec);

Removing this kfree may cause a leak.
For READV/WRITEV atleast, io->free_iovec will hold the address of
allocated iovec array if input was larger than UIO_FASTIOV.

------OaRT8jiSLvKUs3WAABZSk-FavpLm249Qe.Imk-d4uY-X0TwC=_207dc_
Content-Type: text/plain; charset="utf-8"


------OaRT8jiSLvKUs3WAABZSk-FavpLm249Qe.Imk-d4uY-X0TwC=_207dc_--
