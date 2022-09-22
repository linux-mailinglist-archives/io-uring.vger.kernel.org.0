Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDC65E67B6
	for <lists+io-uring@lfdr.de>; Thu, 22 Sep 2022 17:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiIVP43 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Sep 2022 11:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbiIVP4Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Sep 2022 11:56:16 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C6AE5F88
        for <io-uring@vger.kernel.org>; Thu, 22 Sep 2022 08:56:13 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220922155610epoutp02695d39bba6f8ad195d3a1df2434a571b~XOdQqbke81588115881epoutp02C
        for <io-uring@vger.kernel.org>; Thu, 22 Sep 2022 15:56:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220922155610epoutp02695d39bba6f8ad195d3a1df2434a571b~XOdQqbke81588115881epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663862170;
        bh=UkxivZhau5LRH0K8tFZwpqXYL8OFy1DA3kVYajQnwgY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QzTyqb/jcQewfXFhQ8iT2ieBJC8u1mIlFmxuQwE3FEbnPHxHtXS6Y06Vrz36uVb0x
         CuDF5FPCaOEov+Pq1waBHnBqjIi/3fKVU4O1BBtH4Zustc2vJ3j9O5rbLmz/bPnjEa
         xrfShK84cjaMUzZE2wPd6l3XJ9PQXXL3iMRCz5ck=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220922155609epcas5p3c3bb0961d63d9046cb14a00197a0f17a~XOdPcEl8S1990919909epcas5p3D;
        Thu, 22 Sep 2022 15:56:09 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MYKdM5h8Tz4x9Pv; Thu, 22 Sep
        2022 15:56:07 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        28.F8.26992.7958C236; Fri, 23 Sep 2022 00:56:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220922155607epcas5p15acde484ad3637e2abf5a954474ab40c~XOdNgdlZi0856508565epcas5p1z;
        Thu, 22 Sep 2022 15:56:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220922155607epsmtrp1c79cb6ce4f60d7de06b684c2fcfe990f~XOdNfv2aZ2191221912epsmtrp1M;
        Thu, 22 Sep 2022 15:56:07 +0000 (GMT)
X-AuditID: b6c32a49-0c7ff70000016970-f2-632c85973619
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        65.EF.14392.7958C236; Fri, 23 Sep 2022 00:56:07 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220922155606epsmtip2ad8c87efd291f8363997959e7066677b~XOdMTBdQZ2539425394epsmtip2G;
        Thu, 22 Sep 2022 15:56:05 +0000 (GMT)
Date:   Thu, 22 Sep 2022 21:16:19 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
Subject: Re: [PATCH for-next v7 3/5] nvme: refactor nvme_alloc_user_request
Message-ID: <20220922154619.GB24701@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220920120226.GB2809@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmlu70Vp1kg2nLNSzmrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8WkQ9cYLfbe0raYv+wpuwOHx85Zd9k9Lp8t9di0qpPNY/OSeo/d
        NxvYPPq2rGL0+LxJLoA9KtsmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
        1VbJxSdA1y0zB+gkJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BSYFecWJucWle
        ul5eaomVoYGBkSlQYUJ2xu2PR9kLTjJXTPxznrmBcTJzFyMnh4SAiUTLt2NANheHkMBuRomL
        239AOZ8YJWZ/Pc8GUiUk8I1R4vdUYZiOBeca2CCK9jJK9K78B+U8Y5RYuOc4I0gVi4CqxKId
        p5i6GDk42AQ0JS5MLgUJiwgoSTx9dZYRpJ5ZYD3QhrXzGUFqhAW8Jc4e8gOp4RXQldhzqZkd
        whaUODnzCQuIzSmgLbGx/zQriC0qoCxxYNtxJpA5EgITOSRe73oA9Y+LxKLWBUwQtrDEq+Nb
        2CFsKYmX/W1QdrLEpZnnoGpKJB7vOQhl20u0nuoHm8MskCYxY9YkFgibT6L39xOwXyQEeCU6
        2oQgyhUl7k16ygphi0s8nLEEyvaQaFzzjgUSJjcYJQ69vM46gVFuFpJ/ZiFZAWFbSXR+aGKd
        BbSCWUBaYvk/DghTU2L9Lv0FjKyrGCVTC4pz01OLTQsM81LL4XGcnJ+7iRGcSLU8dzDeffBB
        7xAjEwfjIUYJDmYlEd7ZdzSThXhTEiurUovy44tKc1KLDzGaAqNnIrOUaHI+MJXnlcQbmlga
        mJiZmZlYGpsZKonzLp6hlSwkkJ5YkpqdmlqQWgTTx8TBKdXA5LZ9JvOiKXnxkzfVf9Rm/sRo
        63DUu7p6oXC56OkNfyLro174/nBhDvh7iWH73jtyvbpHMsK4vPnqVFyNLQyX7ZgjZzdndVTz
        /F3PuUU05zrc4Fl+udgsqurMoRfaXi1Bc9q5L0avePQo17r5kNMdm+3LZQrU0gNeXXQ8EL5h
        5ewq58QrXnF/6kWkC4zc1NzOuX/ivaF984h6u3n4K98/Dxs//Dise/bRjU8Lu9ak37384sJ6
        LweO1rZ71rXTr/xkl9R/vfmDx0nzl1Mt4qauu8Zi5rW5sKSovjnC8dn0/5du10Wrf3v1VHqF
        SngA3/S+8JLHFhdd9aRmLmrYMulC0kX7lI5Mud8MLScmNhR9UGIpzkg01GIuKk4EAGyABjot
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSvO70Vp1kg8m3+C3mrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8WkQ9cYLfbe0raYv+wpuwOHx85Zd9k9Lp8t9di0qpPNY/OSeo/d
        NxvYPPq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj2tRLLAWNjBXzG7+xNjCmdjFyckgImEgs
        ONfA1sXIxSEksJtR4tmB56wQCXGJ5ms/2CFsYYmV/56zQxQ9YZToONYElmARUJVYtOMUUxcj
        BwebgKbEhcmlIGERASWJp6/OMoLUMwusZ5SYvXY+I0iNsIC3xNlDfiA1vAK6EnsuNUPNvMUo
        cXTiGnaIhKDEyZlPWEBsZgEziXmbHzKD9DILSEss/8cBEuYU0JbY2H8a7E5RAWWJA9uOM01g
        FJyFpHsWku5ZCN0LGJlXMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIER4aW5g7G7as+
        6B1iZOJgPMQowcGsJMI7+45mshBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNT
        UwtSi2CyTBycUg1MUYcm/Vk89ch99XV58vHnyvszEvs3zt5Tta7vmMbm6NxHV59sa1n8pO9M
        ibTmHaf9j3+ql6o9Petx27g3akn4Ywlt5ez2m0vPPPhb8OzFqm2pm2ZG3dytfpzDoNduHeu5
        xf6X7n3NfXLzSIbt2vmRq/0LxFj+uEw4OIdtqUHSjqp4U2nVS6W/WZ3m1FZ39v1i0p5ha+9b
        tzs9TPn6dCXZ8y/Vtihz7T4lH7g8QP8u4/89Kx4xVoa78GV7M2WqWk6Nmif+ovtt4a3UlpVM
        tx07L07Kf3XG18bjvfJRLy/G6dvnN144K3Xx+G3WaeqK/nt+pkYnXQ5Xu/9r9/WJCbdudlXN
        vfFW+abo//wPviJ/TJRYijMSDbWYi4oTAW85nLn7AgAA
X-CMS-MailID: 20220922155607epcas5p15acde484ad3637e2abf5a954474ab40c
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----MqMoGWHj7w70ixSxIQQUJpQDpxeWNW7xlUV_NBkU4rXoYOVD=_d71_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220909103143epcas5p2eda60190cd23b79fb8f48596af3e1524
References: <20220909102136.3020-1-joshi.k@samsung.com>
        <CGME20220909103143epcas5p2eda60190cd23b79fb8f48596af3e1524@epcas5p2.samsung.com>
        <20220909102136.3020-4-joshi.k@samsung.com> <20220920120226.GB2809@lst.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------MqMoGWHj7w70ixSxIQQUJpQDpxeWNW7xlUV_NBkU4rXoYOVD=_d71_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Sep 20, 2022 at 02:02:26PM +0200, Christoph Hellwig wrote:

I should be able to fold all the changes you mentioned.


------MqMoGWHj7w70ixSxIQQUJpQDpxeWNW7xlUV_NBkU4rXoYOVD=_d71_
Content-Type: text/plain; charset="utf-8"


------MqMoGWHj7w70ixSxIQQUJpQDpxeWNW7xlUV_NBkU4rXoYOVD=_d71_--
