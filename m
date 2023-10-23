Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A469F7D2A31
	for <lists+io-uring@lfdr.de>; Mon, 23 Oct 2023 08:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbjJWGS2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Oct 2023 02:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbjJWGS0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Oct 2023 02:18:26 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EECD6E
        for <io-uring@vger.kernel.org>; Sun, 22 Oct 2023 23:18:23 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20231023061819epoutp02d87f474367040c5d75d49fffeb5b4749~QqBxQEEDU1543115431epoutp02F
        for <io-uring@vger.kernel.org>; Mon, 23 Oct 2023 06:18:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20231023061819epoutp02d87f474367040c5d75d49fffeb5b4749~QqBxQEEDU1543115431epoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1698041899;
        bh=aQ2O1uOtyo1JkIU277HDw5ahVIEYtuKwjIlvUsXKgRI=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=gsmeCRIgZxxmCfj1BuFa+OLkIviTcwyKFzbPv0bYxPm4Rp/1X5hac/8j8zPCyJyAv
         +1JKsFGNnIhEt6Agvsl7HEGQXdvgHseR5qby9EdjnfJFv97a9hsb6XcB29csYsixkq
         3hgzp3p4bz/1JIbYYohELTAAq1o3dLUaAIt5/v0k=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20231023061818epcas5p10c14d4e1d84610002f836bec83c330ac~QqBw2Ni472543525435epcas5p1R;
        Mon, 23 Oct 2023 06:18:18 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4SDQ3s1gkfz4x9Q6; Mon, 23 Oct
        2023 06:18:17 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B2.6F.08567.92016356; Mon, 23 Oct 2023 15:18:17 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20231023061816epcas5p2240c0537747ac96007f17715adedcf09~QqBvHnlxI0206302063epcas5p2V;
        Mon, 23 Oct 2023 06:18:16 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20231023061816epsmtrp1274b08bf956f3e4423b22e712eb71547~QqBvG8I1N0348003480epsmtrp14;
        Mon, 23 Oct 2023 06:18:16 +0000 (GMT)
X-AuditID: b6c32a44-617fd70000002177-a8-653610293e7a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        17.48.07368.82016356; Mon, 23 Oct 2023 15:18:16 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20231023061815epsmtip1e7a9de290f1094c0fe7dfaf9dd4b565e~QqBty5DHS2963929639epsmtip1d;
        Mon, 23 Oct 2023 06:18:15 +0000 (GMT)
Message-ID: <5cb1908c-781d-e769-67f3-00d76cfb7bd3@samsung.com>
Date:   Mon, 23 Oct 2023 11:48:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH 3/4] iouring: remove IORING_URING_CMD_POLLED
Content-Language: en-US
To:     Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
        Keith Busch <kbusch@kernel.org>
From:   Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20231018151843.3542335-4-kbusch@meta.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMJsWRmVeSWpSXmKPExsWy7bCmuq6mgFmqwZkn3Bar7/azWaxcfZTJ
        4l3rORaLSYeuMVqcubqQxWLvLW2L+cueslssP/6PyYHD4/LZUo9NqzrZPDYvqffYfbOBzePc
        xQqPj09vsXh83iQXwB6VbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtq
        q+TiE6DrlpkDdJGSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9d
        Ly+1xMrQwMDIFKgwITvjc89apoKT7BU9uy+wNTDOYuti5OSQEDCRWP+njxnEFhLYzSixbEpq
        FyMXkP2JUeL459/sEM43Rol/928wwXRMe7+GCSKxl1Fixb8WqKq3jBK3N/QydjFycPAK2Em8
        WycH0sAioCrR/6EDrJlXQFDi5MwnLCC2qECSxK+rcxhBbGEBB4lVd86A1TALiEvcejIfzBYR
        qJLom/aTDSIeJ7H0yAxmkPFsApoSFyaXgpicAuYSj25HQFTIS2x/O4cZ5BoJgakcEvcnPWGG
        uNlF4tH0I1AfC0u8Or6FHcKWknjZ3wZlJ0tcmnkO6scSicd7DkLZ9hKtp/rB1jIDrV2/Sx9i
        F59E7+8nTCBhCQFeiY42IYhqRYl7k56yQtjiEg9nLIGyPSRWTb8BDajtjBJ/Jl1jnMCoMAsp
        UGYheX4WkndmIWxewMiyilEytaA4Nz012bTAMC+1HB7byfm5mxjBqVXLZQfjjfn/9A4xMnEw
        HmKU4GBWEuGdHW6SKsSbklhZlVqUH19UmpNafIjRFBg7E5mlRJPzgck9ryTe0MTSwMTMzMzE
        0tjMUEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGpj1hBVUJD6eWMUyev+eB87l9V5i3xS59
        WDWn84lAd1vw9EP88z/kf/D/2FbhlLnvWP1ZkzuMigEdaVUi3AtlI6TXGchVTI7WLosum3oj
        roonL3jxTuF5Kyr2M9XuutQVOf+T6R7njX8zX2stytu3Nfws37sfJvMzzx5+bri27nPn7L7j
        QtsO16ReK1u50iZK6XV5oOcG/ms/tm951v3q3JJjDW1xDxl79Or1+zIfvqy5eFozbVbql+u5
        aytLppXd3+H1Zfq+LxGv5W9H71x8PfIVu9f7A68q1Q6mfDWT7Wbd+ePdOe26vnP1BTHuD4P+
        Xl75vrxP7jNDXEfEqnVWqn/tJnxR/6HD8n/xxzd8c/SUWIozEg21mIuKEwF6moIHNgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42LZdlhJTldDwCzV4OlFbYvVd/vZLFauPspk
        8a71HIvFpEPXGC3OXF3IYrH3lrbF/GVP2S2WH//H5MDhcflsqcemVZ1sHpuX1HvsvtnA5nHu
        YoXHx6e3WDw+b5ILYI/isklJzcksSy3St0vgyvjcs5ap4CR7Rc/uC2wNjLPYuhg5OSQETCSm
        vV/D1MXIxSEksJtRYv6dJUwQCXGJ5ms/2CFsYYmV/56zQxS9ZpSYeHIlkMPBwStgJ/FunRxI
        DYuAqkT/hw6wXl4BQYmTM5+wgNiiAkkSe+43gsWFBRwkVt05A2YzA82/9WQ+mC0iUCWx/8dZ
        qHicxP9LjVAHbWeUWLrqHxPILjYBTYkLk0tBTE4Bc4lHtyMgys0kurZ2MULY8hLb385hnsAo
        NAvJFbOQbJuFpGUWkpYFjCyrGCVTC4pz03OTDQsM81LL9YoTc4tL89L1kvNzNzGCI0lLYwfj
        vfn/9A4xMnEwHmKU4GBWEuGdHW6SKsSbklhZlVqUH19UmpNafIhRmoNFSZzXcMbsFCGB9MSS
        1OzU1ILUIpgsEwenVAOT6os9CvzfNKwWJ/yRYY/rYDp+1D9u/kbjPXGz30/WlSrPObnvX+VS
        kWernEMaki5saP/TO+PaWY5jW9Ru8zR+Kdh7d9/9n/yvxf5dSv3Ft/vVNGnn2Z90WpOWph46
        Wbe8I3fpYSGBt47LN3Jk/H3lffWHbcGxSeV2PyUaZzME6dabm60qEOx8vV2R1ygica2P8dbL
        fr7z3jrxbvVfVhBvMHVJ65F/n0LN7n7PeTr/35zWbrGgjb84P7iU8gecfr116cX5BiuEHqk/
        EvjkPitZbMb5pJwThzW+Wai95hJ6ckX5laH+9Y2du1sKAsufhpx6zDF7leHTJxWl4v9yamXu
        c4W13nA8dvatqXUsT/2yX0osxRmJhlrMRcWJAISnd0UTAwAA
X-CMS-MailID: 20231023061816epcas5p2240c0537747ac96007f17715adedcf09
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231018152441epcas5p38a06f590cbe59c76ee43465de3e0be4f
References: <20231018151843.3542335-1-kbusch@meta.com>
        <CGME20231018152441epcas5p38a06f590cbe59c76ee43465de3e0be4f@epcas5p3.samsung.com>
        <20231018151843.3542335-4-kbusch@meta.com>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/18/2023 8:48 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> No more users of this flag.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   include/uapi/linux/io_uring.h | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 8e61f8b7c2ced..10e724370b612 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -249,10 +249,8 @@ enum io_uring_op {
>    * sqe->uring_cmd_flags
>    * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
>    *				along with setting sqe->buf_index.
> - * IORING_URING_CMD_POLLED	driver use only
>    */
>   #define IORING_URING_CMD_FIXED	(1U << 0)
> -#define IORING_URING_CMD_POLLED	(1U << 31)
>   

This is bit outdated. This flag got moved to a different file since this 
patch.
https://lore.kernel.org/io-uring/20230928124327.135679-2-ming.lei@redhat.com/
