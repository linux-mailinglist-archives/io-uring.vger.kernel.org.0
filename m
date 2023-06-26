Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04ECE73E0F4
	for <lists+io-uring@lfdr.de>; Mon, 26 Jun 2023 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjFZNqu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jun 2023 09:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjFZNqu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jun 2023 09:46:50 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F57109
        for <io-uring@vger.kernel.org>; Mon, 26 Jun 2023 06:46:46 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230626134643epoutp032da79c15cd83dc740bddf9472118f8b2~sOYTuO7az1424614246epoutp03R
        for <io-uring@vger.kernel.org>; Mon, 26 Jun 2023 13:46:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230626134643epoutp032da79c15cd83dc740bddf9472118f8b2~sOYTuO7az1424614246epoutp03R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1687787203;
        bh=WL9SVVjRoCkVSNhRCWDmk0wAp/BWdmHxcSJBkJ2ukg8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L0Lb9OJ3tbmVfHtyrfcgbWUFa+R5Ch7nlCZ6iUY5oXGVOhbtqSFCPxQh4CIxBK+/s
         413zhOqiuhkz6O24LW8INcRrbiHjVzw8yzHMBW3cCEke1evtfKMerakBClHf8TfGh9
         E/0lb2CGUV8uWAFYN4YWbGi4JCLjAMETPBSvQ0mM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230626134642epcas5p1336c0d6c07900af85150cebef0e707d0~sOYSkdvKO0338603386epcas5p1l;
        Mon, 26 Jun 2023 13:46:42 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4QqTf83KgCz4x9Pt; Mon, 26 Jun
        2023 13:46:40 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.C4.44250.0C699946; Mon, 26 Jun 2023 22:46:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230626134639epcas5p3a8df4eb93a7505cf668a3549322c5e88~sOYPx2iz81437214372epcas5p3Q;
        Mon, 26 Jun 2023 13:46:39 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230626134639epsmtrp1c593e18e86f0c70a6e638168197a090b~sOYPxHz6P2081420814epsmtrp1E;
        Mon, 26 Jun 2023 13:46:39 +0000 (GMT)
X-AuditID: b6c32a4a-ec1fd7000000acda-f9-649996c03be8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8B.C7.34491.FB699946; Mon, 26 Jun 2023 22:46:39 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230626134638epsmtip2fec30ac705a703ad013645da98467bf4~sOYO8lyUw2826328263epsmtip2W;
        Mon, 26 Jun 2023 13:46:38 +0000 (GMT)
Date:   Mon, 26 Jun 2023 19:13:29 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Ferry Meng <mengferry@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, axboe@kernel.dk,
        joseph.qi@linux.alibaba.com, linux-block@vger.kernel.org
Subject: Re: [bug report] nvme passthrough: request failed when blocksize
 exceeding max_hw_sectors
Message-ID: <20230626134250.GA30651@green245>
MIME-Version: 1.0
In-Reply-To: <34696152-3ae8-138a-d426-aa4fdde4e7ab@linux.alibaba.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42LZdlhTS/fAtJkpBsc6RC1W3+1ns3jXeo7F
        YuWyH+wWe29pWzxctp/NgdXj8tlSj50PLT0+b5ILYI7KtslITUxJLVJIzUvOT8nMS7dV8g6O
        d443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2qekUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8u
        sVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM74MqObreCTfMW5p1/YGhjPS3cxcnJI
        CJhILGm7z9TFyMUhJLCbUaKh7yILhPOJUeLyyi42COcbo8SMmzMYYVqOXDjOCmILCexllNi2
        ix3CfsYocfSjaRcjBweLgKrEmXfZICabgKbEhcmlIBUiAjoSC78uYQOxmQUyJfZueckMYgsL
        pEisfjoJbDqvgK7E8t0nWCBsQYmTM5+A2ZwCrhKfnzSB1YgKKEsc2HacCeKaj+wS5xZLQdgu
        EhMblkLFhSVeHd/CDmFLSbzsb4OykyUuzTwHVVMi8XjPQSjbXqL1VD8zxG0ZEusP3mCCsPkk
        en8/YQJ5RUKAV6KjTQiiXFHi3qSnrBC2uMTDGUugbA+JRQvvQkNtBqPEp2dXGScwys1C8s4s
        JCsgbCuJzg9NrBC2vETz1tnMs4DWMQtISyz/xwFhakqs36W/gJFtFaNkakFxbnpqsWmBUV5q
        OTyyk/NzNzGCk6KW1w7Ghw8+6B1iZOJgPMQowcGsJMIr9mN6ihBvSmJlVWpRfnxRaU5q8SFG
        U2BETWSWEk3OB6blvJJ4QxNLAxMzMzMTS2MzQyVx3mVXelOEBNITS1KzU1MLUotg+pg4OKUa
        mKrn/z100zzF5cQHMxOTHad1ZBLey7DvvOR7/7hNX/V1xYVnwrhau58UbCv/s2Xn4/h/wX99
        X0avDc31vh1ttmClh7of19KsJ9sXCt7/sUFxDWORc01fWeTZZTtmt7UsN+fZtPW3I6/V9/D9
        XcsNlrYkdy4/MfdJsKT512enbpnt+cS9pGr6zAlRGxJci/ZtXlJrM+VI/cGJq+98ecWv63ep
        2KVpR3nZO/2zcxj5uMQM338P/6Gy4LA5T+rX1yKHG3j4b3/a3Wl4N+w7/6XJjycpnShcrbBm
        Vn11z4NvS5n/WcVXx3fkNCxp0OixOXg0VfvuLbtkY5nD1utD2XNaKhLNcrij3q0JzHkht3tv
        n54SS3FGoqEWc1FxIgBu3zRREwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWy7bCSvO7+aTNTDN7+ZbdYfbefzeJd6zkW
        i5XLfrBb7L2lbfFw2X42B1aPy2dLPXY+tPT4vEkugDmKyyYlNSezLLVI3y6BK+PPmYvsBc2y
        FZ9mdjI1MP6V6GLk5JAQMJE4cuE4axcjF4eQwG5GidVzO9kgEuISzdd+sEPYwhIr/z0Hs4UE
        njBKzL+u38XIwcEioCpx5l02iMkmoClxYXIpSIWIgI7Ewq9LwKYwC2RK7N3ykhnEFhZIkVj9
        dBIjiM0roCuxfPcJFoi1MxglZlzqYoNICEqcnPmEBaLZTGLe5ofMIPOZBaQllv/jgAjLSzRv
        nQ02k1PAVeLzkyawmaICyhIHth1nmsAoNAvJpFlIJs1CmDQLyaQFjCyrGCVTC4pz03OLDQsM
        81LL9YoTc4tL89L1kvNzNzGCI0BLcwfj9lUf9A4xMnEwHmKU4GBWEuEV+zE9RYg3JbGyKrUo
        P76oNCe1+BCjNAeLkjiv+IveFCGB9MSS1OzU1ILUIpgsEwenVAPT9oYQ+exlkU0T53Vs1LZe
        sX5L4TvRQ3MmPbERjV/21+R078NJIdN8xV58Ptgw3fxMVcLqZTl7Ulg8n7KafREPq8ji+ha9
        /2bhjlfPp5QbNwmu+KH4897nr1937Zj8f++q2VNk0t8oiFgX1JxNOvtwb6p5sW/pkZvugekH
        vvuJL8/cu876qeA3Ft6z830nvYq4/b9qzwm5w2m5zz4eWDXv7KOPj1TnCCdJsh8ocojRNOUq
        /LqQMeDRZbWPV0N0Xs/o1VjGNyu/fFni+cpDS9uOWk5a6Pn0zf+fzBzN8dxMuvmvXBmK93+t
        kApQ0AvR/Dtn/lKH+8oSUf92szN+eLrX6vnHsqtp7nmaf1V+7n3Sm6PEUpyRaKjFXFScCACu
        U/Rt7wIAAA==
X-CMS-MailID: 20230626134639epcas5p3a8df4eb93a7505cf668a3549322c5e88
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----ezSqbjh_78x.qE2qCBFN.jB5nzVHXmUaWLA63T4a1BcreeST=_8ef9f_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230626091231epcas5p48cbbb13c9579da9b11d3409c66f8ba71
References: <CGME20230626091231epcas5p48cbbb13c9579da9b11d3409c66f8ba71@epcas5p4.samsung.com>
        <34696152-3ae8-138a-d426-aa4fdde4e7ab@linux.alibaba.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------ezSqbjh_78x.qE2qCBFN.jB5nzVHXmUaWLA63T4a1BcreeST=_8ef9f_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Mon, Jun 26, 2023 at 05:09:59PM +0800, Ferry Meng wrote:
>Hello:
>
>I'm testing the io-uring nvme passthrough via fio. But I have 
>encountered the following issue:
>When I specify 'blocksize' exceeding 128KB (actually the maximum size 
>per request can send 'max_sectors_kb'), the creation of request failed 
>and directly returned -22 (-EINVAL).
>
>For example:
>
># cat fio.job
>
>    [global]
>    ioengine=io_uring_cmd
>    thread=1
>    time_based
>    numjobs=1
>    iodepth=1
>    runtime=120
>    rw=randwrite
>    cmd_type=nvme
>    hipri=1
>
>    [randwrite]
>    bs=132k
>    filename=/dev/ng1n1
>
># fio fio.job
>randwrite: (g=0): rw=randwrite, bs=(R) 132KiB-132KiB, (W) 
>132KiB-132KiB, (T) 132KiB-132KiB, ioengine=io_uring_cmd, iodepth=1
>fio-3.34-10-g2fa0-dirty
>Starting 1 thread
>fio: io_u error on file /dev/ng1n1: Invalid argument: write 
>offset=231584956416, buflen=135168
>fio: pid=148989, err=22/file:io_u.c:1889, func=io_u error, 
>error=Invalid argument
>
>I tracked the position that returns the error val in kernel and dumped 
>calltrace.
>
>[   83.352715] nvme nvme1: 15/0/1 default/read/poll queues
>[   83.363273] nvme nvme1: Ignoring bogus Namespace Identifiers
>[   91.578457] CPU: 14 PID: 3993 Comm: fio Not tainted 
>6.4.0-rc7-00014-g692b7dc87ca6-dirty #2
>[   91.578462] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS 
>2221b89 04/01/2014
>[   91.578463] Call Trace:
>[   91.578476]  <TASK>
>[   91.578478]  dump_stack_lvl+0x36/0x50
>[   91.578484]  ll_back_merge_fn+0x20d/0x320
>[   91.578490]  blk_rq_append_bio+0x6d/0xc0
>[   91.578492]  bio_map_user_iov+0x24a/0x3d0
>[   91.578494]  blk_rq_map_user_iov+0x292/0x680
>[   91.578496]  ? blk_mq_get_tag+0x249/0x280
>[   91.578500]  blk_rq_map_user+0x56/0x80
>[   91.578503]  nvme_map_user_request.isra.15+0x90/0x1e0 [nvme_core]
>[   91.578515]  nvme_uring_cmd_io+0x29d/0x2f0 [nvme_core]
>[   91.578522]  io_uring_cmd+0x89/0x110
>[   91.578526]  ? __pfx_io_uring_cmd+0x10/0x10
>[   91.578528]  io_issue_sqe+0x1e0/0x2d0
>[   91.578530]  io_submit_sqes+0x1e3/0x650
>[   91.578532]  __x64_sys_io_uring_enter+0x2da/0x450
>[   91.578534]  do_syscall_64+0x3b/0x90
>[   91.578537]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
>
>Here in bio_map_user_iov()->blk_rq_append_bio(), I found the error val 
>-EINVAL:
>
>blk_rq_append_bio:
>    ...
>    if (!ll_back_merge_fn(rq, bio, nr_segs))
>        return -EINVAL;
>    rq->biotail->bi_next = bio;
>    ...
>
>And in ll_back_merge_fn(), returns 0 if merge can't happen. It checks 
>the request size:
>ll_back_merge_fn:
>    if (blk_rq_sectors(req) + bio_sectors(bio) >
>        blk_rq_get_max_sectors(req, blk_rq_pos(req))) {
>            req_set_nomerge(req->q, req);
>            return 0;
>    }
>
>The ROOT cause is: In blk_rq_get_max_sectors, it returns 
>'max_hw_sectors' directly(in my device ,it's 256 sector, which means 
>128KB), causing the above inequality to hold true.
>blk_rq_get_max_sectors:
>    ...
>    if (blk_rq_is_passthrough(rq)){
>        return q->limits.max_hw_sectors;
>    }
>    ...
>
>I checked my disk's specs(cat 
>/sys/block/<mydisk>/queue/max_hw_sectors_kb 
>/sys/block/<mydisk>/queue/max_sectors_kb), both are 128KB.So I think 
>this arg causing the issue.
>
>I'm not sure if this is a designed restriction. Or should I have to 
>take care of it in application?

Right, passthrough interface does not abstract the device limits.
This needs to be handled in application.

------ezSqbjh_78x.qE2qCBFN.jB5nzVHXmUaWLA63T4a1BcreeST=_8ef9f_
Content-Type: text/plain; charset="utf-8"


------ezSqbjh_78x.qE2qCBFN.jB5nzVHXmUaWLA63T4a1BcreeST=_8ef9f_--
