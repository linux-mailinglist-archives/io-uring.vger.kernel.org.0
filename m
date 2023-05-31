Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE014717CF3
	for <lists+io-uring@lfdr.de>; Wed, 31 May 2023 12:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbjEaKNa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 May 2023 06:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbjEaKN3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 May 2023 06:13:29 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE249132
        for <io-uring@vger.kernel.org>; Wed, 31 May 2023 03:13:25 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230531101323epoutp017e453374b8c8ce10e80258ae7d410b3d~kMsoQJZDo2549025490epoutp01z
        for <io-uring@vger.kernel.org>; Wed, 31 May 2023 10:13:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230531101323epoutp017e453374b8c8ce10e80258ae7d410b3d~kMsoQJZDo2549025490epoutp01z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1685528004;
        bh=9l2Z2oAcGHCRMkQsEPmwo78F4hANn3IhhsC7gL0Quzw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A/tCRE0MyP+IW3cPkcAKIO0WdmAkM1OLd7Q2PMQDVkTiGAm93MRHfHE19Pa5SkCrl
         BFTyfyOc/Dh5aArBeajIQhS97/i9LzToL6nlv6t4HCfLEEwn+MQnxMjJ1ywfTh8+6d
         oATbMHYxCm34PJkE/YWxQvzLQzR0a8lZQsH/GhF4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230531101323epcas5p373d4efa70286d3921949f94ff0f91598~kMsn8MuBp1841618416epcas5p3c;
        Wed, 31 May 2023 10:13:23 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4QWQ8271Czz4x9Q5; Wed, 31 May
        2023 10:13:22 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.AE.44881.2CD17746; Wed, 31 May 2023 19:13:22 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230531101322epcas5p3448a17bb2283baaa1e0697088a5f4271~kMsm_4bF42018420184epcas5p3L;
        Wed, 31 May 2023 10:13:22 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230531101322epsmtrp18e4cc0f370e8cedaa5508e5a62974976~kMsm9lYcu2991229912epsmtrp10;
        Wed, 31 May 2023 10:13:22 +0000 (GMT)
X-AuditID: b6c32a4a-c47ff7000001af51-9e-64771dc26cf2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.D1.28392.2CD17746; Wed, 31 May 2023 19:13:22 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230531101320epsmtip2ba7616988cb7dc2f6ee22856cab4d60d~kMslQQxpF1128111281epsmtip2q;
        Wed, 31 May 2023 10:13:20 +0000 (GMT)
Date:   Wed, 31 May 2023 15:40:20 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Keith Busch <kbusch@meta.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, hch@lst.de, axboe@kernel.dk,
        sagi@grimberg.me, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 2/2] nvme: improved uring polling
Message-ID: <20230531101020.GB19592@green245>
MIME-Version: 1.0
In-Reply-To: <20230530172343.3250958-2-kbusch@meta.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGJsWRmVeSWpSXmKPExsWy7bCmuu4h2fIUg7PzzSxW3+1ns1i5+iiT
        xbvWcywWkw5dY7Q4c3Uhi8XeW9oW85c9ZbdY9/o9iwOHx/l7G1k8Lp8t9di0qpPNY/OSeo/d
        NxvYPM5drPD4vEkugD0q2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
        VsnFJ0DXLTMH6CIlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66
        Xl5qiZWhgYGRKVBhQnbG2s92BZNZK+6t2s/cwHiWpYuRk0NCwESi88w2xi5GLg4hgd2MElsO
        tUI5nxglvvV/YYFwPjNKTPq6ka2LkQOsZdtXB4j4LkaJrnNr2CGcZ4wSG/ofMoMUsQioSty8
        owxisgloSlyYXAqyTURAUeI8MAhAbGaBtYwSu7elg9jCAqYSf7deBYvzCuhKzOp6zwphC0qc
        nPmEBWQMp4C5ROsMa5CwqICyxIFtx5lAtkoIdHJIXGu8ywTxjYvEiwOzoT4Tlnh1fAs7hC0l
        8bK/DcpOlrg08xxUfYnE4z0HoWx7idZT/cwQt2VILD28jhHC5pPo/f2ECeJ1XomONiGIckWJ
        e5OeskLY4hIPZyyBsj0kZr7tY4WEyHZGic+7WpknMMrNQvLOLCQrIGwric4PTayzgFYwC0hL
        LP/HAWFqSqzfpb+AkXUVo2RqQXFuemqxaYFRXmo5PIKT83M3MYITqJbXDsaHDz7oHWJk4mA8
        xCjBwawkwmubWJwixJuSWFmVWpQfX1Sak1p8iNEUGDkTmaVEk/OBKTyvJN7QxNLAxMzMzMTS
        2MxQSZxX3fZkspBAemJJanZqakFqEUwfEwenVAPTpOnqB/IVLiSFH5iduIp1dmPtp9u/k3Zu
        XvzpvJfd2ms6nG/l9/E9M1Oerc55baZmTXRuqbXOeoeFh0Pvmau6ZGmZeP35cHSZ6t65O2Jr
        Dx24vUprVo7kJoMJMk/j+F0uby8IUhd959KjdOpI8JHtP518o70X33g+/VHFfolYx2Auo0vu
        ecsCgkOKF0wxt13yU1/i7Bq3RxtTjtnMfvavxiF01qO0eVNlzZdVOs1ap3wuqEXUI6b6d9zd
        dfevyHB8n504l98moigsdO65oprJBiJiBw7LP7umY+9/7tqco7mutilt+4vnHEhiO8h/8Uzj
        pYfHGtUYz4e/eNrHcaukf+HjpyEPjm7y05BSn507WYmlOCPRUIu5qDgRAAEqNHQpBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSvO4h2fIUg9m7pS1W3+1ns1i5+iiT
        xbvWcywWkw5dY7Q4c3Uhi8XeW9oW85c9ZbdY9/o9iwOHx/l7G1k8Lp8t9di0qpPNY/OSeo/d
        NxvYPM5drPD4vEkugD2KyyYlNSezLLVI3y6BK+PN06+sBUeZKm40vWRvYJzJ1MXIwSEhYCKx
        7atDFyMXh5DADkaJDzuXAMU5geLiEs3XfrBD2MISK/89Z4coesIo8Wv/VVaQZhYBVYmbd5RB
        TDYBTYkLk0tBykUEFCXOA90BYjMLrGWU2L0tHcQWFjCV+Lv1KlicV0BXYlbXe1aIkdsZJR7N
        fcIEkRCUODnzCQtEs5nEvM0PmUHmMwtISyz/xwFicgqYS7TOsAapEBVQljiw7TjTBEbBWUia
        ZyFpnoXQvICReRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnBMaGntYNyz6oPeIUYm
        DsZDjBIczEoivLaJxSlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2C
        yTJxcEo1MNVl3j/bfzrwhnGtr+OPl/bGd503zz6qK+ha+G6hf90XT/VINZWP8x571Jjeen3t
        vMjEWJ9Z148rHFDyePgmr7MxZO3Hc3+SLv6dnC+xTkxmh6nZtHDZxcvtFe+5fTXZL+xhdkP3
        wpKwJTO6s1UDrthcOfpgOaPUqfj7cXc/nXN70qPYddda9sKBz+f5fB0UizqiNbd5bLxUc8LO
        OcB653x+we/nbB9u26EmrFuvaqyqHnvysUvKv7PvN1v5hHGq5aa+8+2aqXagwLbs+o+tOmHG
        L2Vz2D+HVsXu1YoTnpDcqGvEtt7cJinCNm3lJKeN2040b12oduRv8/nJErZebrLZV1TdH+kz
        ZbxbEO6docRSnJFoqMVcVJwIAAsGpwD4AgAA
X-CMS-MailID: 20230531101322epcas5p3448a17bb2283baaa1e0697088a5f4271
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----JBF_njb0NWiSS48ThI00c_Y9Zxz.JAos93qymBy6wSZnW6dc=_36b7f_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230530172444epcas5p18e5bc9bdf2017e00c6f7bbdfa463473c
References: <20230530172343.3250958-1-kbusch@meta.com>
        <CGME20230530172444epcas5p18e5bc9bdf2017e00c6f7bbdfa463473c@epcas5p1.samsung.com>
        <20230530172343.3250958-2-kbusch@meta.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------JBF_njb0NWiSS48ThI00c_Y9Zxz.JAos93qymBy6wSZnW6dc=_36b7f_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, May 30, 2023 at 10:23:43AM -0700, Keith Busch wrote:
>From: Keith Busch <kbusch@kernel.org>

This may need to be wired up against the code after
https://lore.kernel.org/linux-nvme/168502647392.717124.7925068931544884226.b4-ty@kernel.dk/

Looks good otherwise.
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

------JBF_njb0NWiSS48ThI00c_Y9Zxz.JAos93qymBy6wSZnW6dc=_36b7f_
Content-Type: text/plain; charset="utf-8"


------JBF_njb0NWiSS48ThI00c_Y9Zxz.JAos93qymBy6wSZnW6dc=_36b7f_--
