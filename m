Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5DB50F077
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 07:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbiDZFzF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 01:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbiDZFzE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 01:55:04 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649B369CD0
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 22:51:56 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220426055154epoutp04412d944bfe22b759e9588017ec8cd30d~pXGHv610R3092230922epoutp04U
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 05:51:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220426055154epoutp04412d944bfe22b759e9588017ec8cd30d~pXGHv610R3092230922epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1650952314;
        bh=9Db/508AmvfW1GoNfrH5ak1B7+TSKMCY2QVtJKQtJoU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bKoMO5cObSWqIQA/kWWiV5dukZRHDlgMYE2fMqkJr4HwDMlcwjyY5KQJLcOmZNlpe
         FFfftN7G1+PF0FJ8ECd7O5uEw1TkbH2Pwlo8LLS6pR30l8TAuck+WtiC8Kaa7WlpkD
         Gjfr4DcJ88U2dOWmhfsQFaZ4FmEkoPtaZRwB4hvQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220426055153epcas5p49f0aed0990742c312b710582e004df53~pXGG500fr1748017480epcas5p44;
        Tue, 26 Apr 2022 05:51:53 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KnWGq38DSz4x9QP; Tue, 26 Apr
        2022 05:51:47 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AA.86.09827.F6887626; Tue, 26 Apr 2022 14:51:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220426052744epcas5p4c7871d9ddd0085ec7fc01277d0554bfe~pWxB1tW5v1691416914epcas5p4b;
        Tue, 26 Apr 2022 05:27:44 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220426052744epsmtrp11219054c97b8d0c670be7a8b8b452558~pWxB1C9111229212292epsmtrp1R;
        Tue, 26 Apr 2022 05:27:44 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-92-6267886f5e2b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        48.5A.08924.0D287626; Tue, 26 Apr 2022 14:27:44 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220426052743epsmtip16c5fe201430e10970bc1c3a7f9cad345~pWxA-y0qm2755527555epsmtip1t;
        Tue, 26 Apr 2022 05:27:43 +0000 (GMT)
Date:   Tue, 26 Apr 2022 10:52:35 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        kernel-team@fb.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 01/12] io_uring: support CQE32 in io_uring_cqe
Message-ID: <20220426052235.GA14174@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220425182530.2442911-2-shr@fb.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdlhTSze/Iz3JYN88RYvVd/vZLN61nmOx
        ONb3ntVi/rKn7BZXXx5gd2D1mNj8jt3j8tlSj81L6j0+b5ILYInKtslITUxJLVJIzUvOT8nM
        S7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2qqkUJaYUwoUCkgsLlbSt7Mpyi8t
        SVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM448dGh4ApLxexbx9kaGLtY
        uhg5OSQETCS239nA3MXIxSEksJtR4u/JGywQzidGibMT77BDOJ8ZJY79aGOFafnzaT6YLSSw
        i1Gi4bg1RNEzRokJpw+xgyRYBFQlTq65DTSKg4NNQFPiwuRSkLCIgJzErKX72UBsZoECiTM7
        JoLZwgKuEp/+TmMEsXkFdCXetE2FsgUlTs58AnYqp4CRxOPDk8HGiwooSxzYdpwJZK+EwCN2
        idfPeqH+cZFY8Xgf1KHCEq+Ob2GHsKUkXva3QdnJEq3bL7OD3CYhUCKxZIE6RNhe4uKev0wQ
        t6VLXHi2BmqkrMTUU+ug4nwSvb+fMEHEeSV2zIOxFSXuTXoKtVZc4uGMJVC2h8TjvsNskPBZ
        yyjxbXIP+wRG+VlIfpuFZB+EbSXR+aGJdRbQecwC0hLL/3FAmJoS63fpL2BkXcUomVpQnJue
        WmxaYJSXWg6P7uT83E2M4CSp5bWD8eGDD3qHGJk4GA8xSnAwK4nwTlVNSxLiTUmsrEotyo8v
        Ks1JLT7EaAqMqonMUqLJ+cA0nVcSb2hiaWBiZmZmYmlsZqgkzns6fUOikEB6YklqdmpqQWoR
        TB8TB6dUA5Pnl7WdKtenah/ave08I4tfdYy50InY3NZJrkxb6yZmxtpHChewPp5dI6O2wHCp
        9IrV9ep3O+oW7H7N/0jcsFZ2gXDEJBfdW8UdnCl7eXVb60Wmebe9XW59I8yp81qA59k63/Rs
        DW7x/+8kOq+dcygLSg/Mzmz4lcs+aeFBNfHTMXvDNafnbKpV29qwWdVh7fSyHGGPJ/+rNu+I
        uS3UFsHffejZ7LTjus6c0sKLvyuV3xepV36+cNcSzdcRrdfO77geVL8uct2Sr53/FMtXCx0r
        O7Fq9iruz/p3g41dgq4Kn2ptOLFUvzsl+Qu7/VapXVNlrspdeT/5i43Gps/SZbrSZW3a8bLM
        8Z9W+Ch/VmIpzkg01GIuKk4EAHK1r4EbBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWy7bCSnO6FpvQkgy87VCxW3+1ns3jXeo7F
        4ljfe1aL+cuesltcfXmA3YHVY2LzO3aPy2dLPTYvqff4vEkugCWKyyYlNSezLLVI3y6BK+PS
        qrWMBZ1MFa+a1rA2MN5k7GLk5JAQMJH482k+axcjF4eQwA5GifNf1rFAJMQlmq/9YIewhSVW
        /nsOZgsJPGGUeP1ZHMRmEVCVOLnmNlA9BwebgKbEhcmlIGERATmJWUv3s4HYzAIFEmd2TASz
        hQVcJT79nQa2l1dAV+JN21RGiJFrGSXuXZCFiAtKnJz5hAWi10xi3uaHzCDjmQWkJZb/4wAJ
        cwoYSTw+PBnsGlEBZYkD244zTWAUnIWkexaS7lkI3QsYmVcxSqYWFOem5xYbFhjlpZbrFSfm
        Fpfmpesl5+duYgQHt5bWDsY9qz7oHWJk4mA8xCjBwawkwjtVNS1JiDclsbIqtSg/vqg0J7X4
        EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqZjkjqB6SJZRb90g/4Xfi/fZ6Yb/coj
        m0nhccH1VKlNQQsuB2fMnZRVKWv7aVvez7N3dT49rVXqD1gVMzd7S+zfh+1zbvBtnqfxdGWZ
        1iSz2ZdffO25/p7l4eW4q+aSORmRTS51Eq8SlpzPPva//if3F7vbRjemTihoUpo5SeJFt5l6
        q+fZvH02usWbjPbGTLrlcaHyzS8Jd9fe1Chr3rpXdWcm6Mw60ZP6VHWyk4P2uZPfQt3uNO3X
        3i9qN/t+/Y7Te+6a3Ws49kTbS+ZnTtyV8BuiIfVTli3YL2538pBmc6niPTGBmg9MC1d3R3pW
        J6tOe9VV+i7/2L1tRo4LD/6beLMxdsr7s8rWkiFLzfiVWIozEg21mIuKEwF2TTNB3QIAAA==
X-CMS-MailID: 20220426052744epcas5p4c7871d9ddd0085ec7fc01277d0554bfe
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----s4qM-aiFeEq2P5kV4uOTWgulZH1WlgWPmjzluR0KuqNjv6bB=_dd3c_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220425182605epcas5p2b986b804ae339ceacd79b66c5e5e3bd7
References: <20220425182530.2442911-1-shr@fb.com>
        <CGME20220425182605epcas5p2b986b804ae339ceacd79b66c5e5e3bd7@epcas5p2.samsung.com>
        <20220425182530.2442911-2-shr@fb.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------s4qM-aiFeEq2P5kV4uOTWgulZH1WlgWPmjzluR0KuqNjv6bB=_dd3c_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Mon, Apr 25, 2022 at 11:25:19AM -0700, Stefan Roesch wrote:
>This adds the struct io_uring_cqe_extra in the structure io_uring_cqe to
>support large CQE's.
>
since we decided to kill that and now using "__u64 big_cqe[]" instead,
this too can be refreshed.

------s4qM-aiFeEq2P5kV4uOTWgulZH1WlgWPmjzluR0KuqNjv6bB=_dd3c_
Content-Type: text/plain; charset="utf-8"


------s4qM-aiFeEq2P5kV4uOTWgulZH1WlgWPmjzluR0KuqNjv6bB=_dd3c_--
