Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300175ECA7F
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 19:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbiI0RII (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 13:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiI0RHw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 13:07:52 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31AF883CE
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 10:07:45 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220927170743epoutp038e4245619b02dec6e9f622b54524fdbc~YxqKMVXA93102531025epoutp034
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 17:07:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220927170743epoutp038e4245619b02dec6e9f622b54524fdbc~YxqKMVXA93102531025epoutp034
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664298463;
        bh=6C1maRmnQShkYnoGnKw8z2XB1hU1X8ZjRGem4o/4QYI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DuWRP5PIfr+vigBfbUdNnVNcrAy5pcXTUyMxYIYD4FYjC7o/pCFTc/Tx9lIl+CKBz
         Eni4el2wsg6QpHSxzxf/5ohzpAd+sAbyoy5S4incxhmzJvjGyJnCYbJvzFvFxI/IE6
         e469lrBx9tw0gRMrhScxAsXybmKrTVdDC8fxa4BI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220927170743epcas5p31a0a49712e187a477adceb91f8b96746~YxqJ4LAW-1205712057epcas5p3F;
        Tue, 27 Sep 2022 17:07:43 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4McQzc6gjVz4x9Pv; Tue, 27 Sep
        2022 17:07:40 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7E.F5.26992.CDD23336; Wed, 28 Sep 2022 02:07:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220927170740epcas5p42508665faac2d17e4afa5feb200acf16~YxqG1441r0904409044epcas5p4y;
        Tue, 27 Sep 2022 17:07:40 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220927170740epsmtrp17d6765ee655c865e08f600650a22f11b~YxqG1AkN02765427654epsmtrp1M;
        Tue, 27 Sep 2022 17:07:40 +0000 (GMT)
X-AuditID: b6c32a49-0c7ff70000016970-92-63332ddcc2ea
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        59.95.18644.CDD23336; Wed, 28 Sep 2022 02:07:40 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220927170739epsmtip19d740ee2050dfefa7658119f34811b0f~YxqFyi-4H2251322513epsmtip1e;
        Tue, 27 Sep 2022 17:07:38 +0000 (GMT)
Date:   Tue, 27 Sep 2022 22:27:51 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, kbusch@kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com
Subject: Re: [PATCH for-next v8 3/5] nvme: refactor nvme_alloc_user_request
Message-ID: <20220927165751.GB23874@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220926145159.GB20424@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsWy7bCmpu4dXeNkg7NnTC1W3+1ns7h5YCeT
        xcrVR5ks3rWeY7GYdOgao8XeW9oW85c9ZXdg97h8ttRj06pONo/NS+o9dt9sYPPo27KK0ePz
        JrkAtqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
        Q5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWleel6eaklVoYGBkam
        QIUJ2Rmrrz9nLZjPXTHnyyumBsYFnF2MnBwSAiYS009MYOti5OIQEtjNKLFyTgMLhPOJUeL6
        /XtMIFVCAp8ZJebPrYHpuL+hmR2iaBejxKS396HanzFKfN7+gxGkikVAVWLKip1ACQ4ONgFN
        iQuTS0HCIgJKEk9fnWUEqWcWmM4osff1HrANwgLeEnPmbWEHsXkFdCXOTX4DZQtKnJz5hAXE
        5hTQkVh8ewUriC0qoCxxYNtxJpBBEgKNHBLfzs1mhzjPReLnio9sELawxKvjW6DiUhIv+9ug
        7GSJSzPPMUHYJRKP9xyEsu0lWk/1M4PYzAIZEltbl7NC2HwSvb+fMIE8IyHAK9HRJgRRrihx
        b9JTVghbXOLhjCVQtofEvdVvWCGBMpdJYuu8yewTGOVmIflnFpIVELaVROeHJiCbA8iWllj+
        jwPC1JRYv0t/ASPrKkbJ1ILi3PTUYtMCw7zUcngkJ+fnbmIEp00tzx2Mdx980DvEyMTBeIhR
        goNZSYT391HDZCHelMTKqtSi/Pii0pzU4kOMpsD4mcgsJZqcD0zceSXxhiaWBiZmZmYmlsZm
        hkrivItnaCULCaQnlqRmp6YWpBbB9DFxcEo1MK01+OGX2WG9VO7G7pnyLvxxdwRmrXhxy6kg
        1+O7aP7lzO0aWh/sPSO43RnPNXz/1m8rJfmoKMIh8sD80usGh11b7q9aMO9GaNpehjOa2g2H
        ciX46qUVLyXKf7iex7TyHIvyU4OS/4tW7ZXTd93r8WPt7V3/uw9N7J9wZPqlLGG/8AqW7+Is
        rjFsP8V5AsQ+vJi/MCrirPi9rVqS9a18L6w0OItqVQpUtj1uWbfLJ1phUsG1UInM2I6oqAfs
        l1qeN4fHZqeqhrEvE2QLuvF2stIfc65jXt+trzOvnJJbtGqlfuLZgzNecqzZ8T9sjsGdNXrv
        f6w6ytL2/cWmaTuTbiy5uvNMyISnu0qn7GZaI6XEUpyRaKjFXFScCAAGi6FqJAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSnO4dXeNkgwXvWSxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7GYdOgao8XeW9oW85c9ZXdg97h8ttRj06pONo/NS+o9dt9sYPPo27KK0ePz
        JrkAtigum5TUnMyy1CJ9uwSujEl/nAsuclS8ufGKpYHxDVsXIyeHhICJxP0NzexdjFwcQgI7
        GCV6ri1gh0iISzRf+wFlC0us/PccqugJo8Tpj/dZQRIsAqoSU1bsBJrEwcEmoClxYXIpSFhE
        QEni6auzjCD1zALTGSX2vt7DBJIQFvCWmDNvC9hQXgFdiXOT30ANXcgk8aDvCQtEQlDi5EwI
        m1nATGLe5ofMIAuYBaQllv/jAAlzCuhILL69AuwGUQFliQPbjjNNYBSchaR7FpLuWQjdCxiZ
        VzFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBMeBltYOxj2rPugdYmTiYDzEKMHBrCTC
        +/uoYbIQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTG1f
        1jgH2WtMYRc8v/FDtd9KJ5Vvx45e2/HR0Un8rOGL+YXmUlVro/IZr0wrD1Kd5Zluc8Cz7UPm
        wgceEzsOJy4qvdmx/MuqjaphL3jn5ayyuepzsmTejPWR/sad7g7Ld65ZJ531MEbygVLHTNt9
        lreP1zNPCcs8fvaK0Qzf/U8ltO2Vg05kbTguFlDIV5nbqb77SZ24jHmYe+D+vtWCzgrTZA9d
        zrvx2G9m38PJC4WuaKbG3rszYYlBlP2dkwLbTr42PvFfuXdF2Supe1Wzkl7HLj3fONuXhb3Z
        3ofPuy7zxY1167ZeFrWbYz6r/5bJ+SVNsjIbP887YqQ0e+qV8HLd84s4VGfpPl7p93K9sKcS
        S3FGoqEWc1FxIgC5wkWv8gIAAA==
X-CMS-MailID: 20220927170740epcas5p42508665faac2d17e4afa5feb200acf16
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----Bhr1nD2Bk2LUmll8nJ7f302jVE_Mn2nZjP.Hr2fL4.Csl-BK=_17872_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220923093916epcas5p387fdd905413f6d90babecf5d14da5b67
References: <20220923092854.5116-1-joshi.k@samsung.com>
        <CGME20220923093916epcas5p387fdd905413f6d90babecf5d14da5b67@epcas5p3.samsung.com>
        <20220923092854.5116-4-joshi.k@samsung.com> <20220923153819.GC21275@lst.de>
        <20220925194354.GA29911@test-zns> <20220926145159.GB20424@lst.de>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------Bhr1nD2Bk2LUmll8nJ7f302jVE_Mn2nZjP.Hr2fL4.Csl-BK=_17872_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Mon, Sep 26, 2022 at 04:51:59PM +0200, Christoph Hellwig wrote:
>On Mon, Sep 26, 2022 at 01:13:54AM +0530, Kanchan Joshi wrote:
>>>> +	if (ret)
>>>> +		goto out;
>>>> +	bio = req->bio;
>>>
>>> I think we can also do away with this bio local variable now.
>>>
>>>> +	if (bdev)
>>>> +		bio_set_dev(bio, bdev);
>>>
>>> We don't need the bio_set_dev here as mentioned last time, so I think
>>> we should remove it in a prep patch.
>>
>> we miss completing polled io with this change.
>> bdev needs to be put in bio to complete polled passthrough IO.
>> nvme_ns_chr_uring_cmd_iopoll uses bio_poll and that in turn makes use of
>> this.
>
>Oh, indeed - polling is another and someone unexpected user in
>addition to the I/O accounting that does not apply to passthrough
>requests.  That also means we can't poll admin commands at all.

Yes. That falls back to IRQ completions.

I think it should be possible to support if we use request-only
interface. Most of the information in bio-poll interface comes from
request.
But I doubt if polling for admin command is a useful thing.

------Bhr1nD2Bk2LUmll8nJ7f302jVE_Mn2nZjP.Hr2fL4.Csl-BK=_17872_
Content-Type: text/plain; charset="utf-8"


------Bhr1nD2Bk2LUmll8nJ7f302jVE_Mn2nZjP.Hr2fL4.Csl-BK=_17872_--
