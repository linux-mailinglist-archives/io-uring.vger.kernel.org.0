Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B51A6EAA2B
	for <lists+io-uring@lfdr.de>; Fri, 21 Apr 2023 14:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjDUMTK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Apr 2023 08:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDUMTJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Apr 2023 08:19:09 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F90E8A46
        for <io-uring@vger.kernel.org>; Fri, 21 Apr 2023 05:19:08 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230421121905epoutp02dc8f7b9cdf075cd8bf56613e2572c144~X8m83gtfW0040800408epoutp02d
        for <io-uring@vger.kernel.org>; Fri, 21 Apr 2023 12:19:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230421121905epoutp02dc8f7b9cdf075cd8bf56613e2572c144~X8m83gtfW0040800408epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682079545;
        bh=aG6CvdnKAQ/G7eThPVIYT4X7N/OR4iJxhfybZE60YQs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VHnEt9Sz8DL6dH7PL/djzxUJk1a2lO8RhCghWoJ9xZMlKqDfwWlrVH1TmOobfCXMj
         dpINhCZuIt1FhyUrQ/4jhANC7107dsSLV7d+Gwyh9Q6vW8VV2WFPDlpPm+BHnLDBCH
         bUtxswmuEO/NlP8hGuMtbNcUuFZNws23nDQsrBf0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230421121904epcas5p1bc7ae5c34a38da71bfa4dc20ea87a478~X8m8fQQX00882608826epcas5p1I;
        Fri, 21 Apr 2023 12:19:04 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Q2tqW2Sv0z4x9Pt; Fri, 21 Apr
        2023 12:19:03 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.6D.09961.73F72446; Fri, 21 Apr 2023 21:19:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230421121902epcas5p476b16ea1b5ca093afcee51662331189f~X8m6k818u2683326833epcas5p4G;
        Fri, 21 Apr 2023 12:19:02 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230421121902epsmtrp24c7f5a6c3cc979d5f83c481b3f964be4~X8m6j6WCb2454524545epsmtrp2m;
        Fri, 21 Apr 2023 12:19:02 +0000 (GMT)
X-AuditID: b6c32a49-2c1ff700000026e9-dc-64427f3728e1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        12.E6.08609.63F72446; Fri, 21 Apr 2023 21:19:02 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230421121901epsmtip1e58fc934cbfd3ec05ffda0f2b5ca2c0a~X8m41Ufbo1246212462epsmtip1D;
        Fri, 21 Apr 2023 12:19:00 +0000 (GMT)
Date:   Fri, 21 Apr 2023 17:46:05 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Breno Leitao <leitao@debian.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk, leit@fb.com,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org,
        ming.lei@redhat.com
Subject: Re: [PATCH v2 0/3] io_uring: Pass the whole sqe to commands
Message-ID: <20230421121605.GA30924@green245>
MIME-Version: 1.0
In-Reply-To: <20230421114440.3343473-1-leitao@debian.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNJsWRmVeSWpSXmKPExsWy7bCmlq55vVOKwZL7AhZzVm1jtFh9t5/N
        YuXqo0wW71rPsVhMOnSN0WLVrHtMFm8nbGG02HtL2+LyrjlsFvOXPWW3ODS5mcli3ev3LA48
        Hr/a5jJ7TGx+x+6xc9Zddo/z9zayeFw+W+qxaVUnm8fmJfUeu282sHm833eVzePzJrkArqhs
        m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygq5UUyhJz
        SoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWleel6eaklVoYGBkamQIUJ2RlH
        1zxlKTjGUbFz2k7WBsa17F2MnBwSAiYSrX3LGEFsIYHdjBJNf+K7GLmA7E+MEos7VrNDOJ8Z
        JWbO3MwC03Gtv58RIrELKNGwmgnCecYoceXfZ1aQKhYBVYnlF7YAJTg42AQ0JS5MLgUJiwio
        SEw82wM2lVngJ6PEzoX3wO4QFnCR2PRlHxuIzSugK/Hn3CtWCFtQ4uTMJywgczgFLCUWnXAC
        CYsKKEsc2HYcbK+EwAkOiUWfrjOC1EgAzTm0QQjiUGGJV8e3QL0pJfH53V42CDtZ4tLMc0wQ
        donE4z0HoWx7idZT/cwgNrNAhsTH7f/ZIWw+id7fT5ggxvNKdLRBjVeUuDfpKSuELS7xcMYS
        VogSD4n+g9Dg6WGU6Lxyn3kCo9wsJM/MQrIBwraS6PzQxDoLqJ1ZQFpi+T8OCFNTYv0u/QWM
        rKsYJVMLinPTU4tNCwzzUsvhMZycn7uJEZyKtTx3MN598EHvECMTB+MhRgkOZiURXo9SpxQh
        3pTEyqrUovz4otKc1OJDjKbAyJnILCWanA/MBnkl8YYmlgYmZmZmJpbGZoZK4rzqtieThQTS
        E0tSs1NTC1KLYPqYODilGpgyZYOeHpgcP3/SWZnyFR+TZe2nKKydYbnwnqdNd3B91qGmNUa1
        1u/ToxfNDAxe+IX35aTnrAylCt0vV7mFnvzIpbZpunXE63vHlh44/5HZjfX5kf/Wd8slGN0/
        m++QWK8sInl2d4pAp8Qldr1nndci2f/yahUGGCrObUvwfBfnviNvhs7C3QWa7wOd9metPJYk
        ebP6TMLZfdEuGT7xcod+yXNx7PwY2RO4re4F2yPFhKK7X7SPiu/38/l99sBlZbNZnF3fIh1f
        H+oJ+KUiLObUazR9f7vBA7mHiTtzdQ9cLLCzlN3IprW09eCkuocPeGdzrjl4XNC4uf2cFfvF
        JdkMXSGyVm8eNwSph/QocCqxFGckGmoxFxUnAgByXh1eTgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42LZdlhJTtes3inFYNlKPYs5q7YxWqy+289m
        sXL1USaLd63nWCwmHbrGaLFq1j0mi7cTtjBa7L2lbXF51xw2i/nLnrJbHJrczGSx7vV7Fgce
        j19tc5k9Jja/Y/fYOesuu8f5extZPC6fLfXYtKqTzWPzknqP3Tcb2Dze77vK5vF5k1wAVxSX
        TUpqTmZZapG+XQJXxuIV71kKfrBWtB3rYWpg/MnSxcjJISFgInGtv5+xi5GLQ0hgB6PE6d+X
        2SES4hLN135A2cISK/89Z4coesIocfX7ETaQBIuAqsTyC1uYuhg5ONgENCUuTC4FCYsIqEhM
        PNsDVs8s8JtRYsqn1awgCWEBF4lNX/aB9fIK6Er8OfeKFWJoD6PEzBvXGCESghInZz4BO49Z
        wExi3uaHzCALmAWkJZb/4wAxOQUsJRadcAKpEBVQljiw7TjTBEbBWUiaZyFpnoXQvICReRWj
        ZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnCEaWntYNyz6oPeIUYmDsZDjBIczEoivB6l
        TilCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MB38YmPN
        ePEgz8T75x6f6f+twGWuI/PwkcrB60cvHGg73tv38sPTwiBFn1nVBw0Xy2xjOmj03Dup9aCP
        w5+t8zySns/bpaUrmG4ybwujhsj9izef9TX0ZJieS37GM0fcr6np1mzzlJmyj0IvzrlWHH13
        TsJR65UP+v/FbeTLVA6clbNynRVzeWfkbA7/02LXFW2ba0s7ZBUO1eed3Gox64g6y7VZfFtE
        dJ2Z95ZWrWBwanGoPxl0as6ThQ/F521733mGWdRuWsuFwuky5h86nvFotJ6fFR9y5Njnyw7T
        Kn4xvJbadEGiLdJV8uSDadPXsM0KnZY7P/2cUenW0xdalkW+W296QOjBAbnPnO7mKWeUWIoz
        Eg21mIuKEwGi4fDXHwMAAA==
X-CMS-MailID: 20230421121902epcas5p476b16ea1b5ca093afcee51662331189f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----DBoZ3SwRANBUL.4oxx5P7t7PoRgN1JiEjGDoy8d5VOZGQ23m=_36c71_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230421114703epcas5p37cd0ddb29674d8f3d5fe2f1fa494d1f0
References: <CGME20230421114703epcas5p37cd0ddb29674d8f3d5fe2f1fa494d1f0@epcas5p3.samsung.com>
        <20230421114440.3343473-1-leitao@debian.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------DBoZ3SwRANBUL.4oxx5P7t7PoRgN1JiEjGDoy8d5VOZGQ23m=_36c71_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Apr 21, 2023 at 04:44:37AM -0700, Breno Leitao wrote:
>These three patches prepare for the sock support in the io_uring cmd, as
>described in the following RFC:
>
>	https://lore.kernel.org/lkml/20230406144330.1932798-1-leitao@debian.org/
>
>Since the support linked above depends on other refactors, such as the sock
>ioctl() sock refactor[1], I would like to start integrating patches that have
>consensus and can bring value right now.  This will also reduce the patchset
>size later.
>
>Regarding to these three patches, they are simple changes that turn
>io_uring cmd subsystem more flexible (by passing the whole SQE to the
>command), and cleaning up an unnecessary compile check.

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

------DBoZ3SwRANBUL.4oxx5P7t7PoRgN1JiEjGDoy8d5VOZGQ23m=_36c71_
Content-Type: text/plain; charset="utf-8"


------DBoZ3SwRANBUL.4oxx5P7t7PoRgN1JiEjGDoy8d5VOZGQ23m=_36c71_--
