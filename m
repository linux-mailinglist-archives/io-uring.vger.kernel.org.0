Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B475A1669
	for <lists+io-uring@lfdr.de>; Thu, 25 Aug 2022 18:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242120AbiHYQMK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Aug 2022 12:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239716AbiHYQMJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Aug 2022 12:12:09 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7CD74B8D
        for <io-uring@vger.kernel.org>; Thu, 25 Aug 2022 09:12:02 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220825161157epoutp0116143ce05736896a6701998424e273bf~OonCx9mQ00886308863epoutp01w
        for <io-uring@vger.kernel.org>; Thu, 25 Aug 2022 16:11:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220825161157epoutp0116143ce05736896a6701998424e273bf~OonCx9mQ00886308863epoutp01w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661443917;
        bh=B3+7ZZpZdGVJ5aj4TWVcECjWNi9AeCdrD+mPvrF7Tbs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qoiHElmdE9MFankpYyn8I7RS1Y+Uur4zXp32PF6yIt/3Ygwg7c2zqHj1vK2jSMGtI
         nT+ZCSloHjvL2dBLF/KRslzgweYvyakaPZdrgNxs/LMK4wB20bcNT0hewUKK1scS3S
         3wHjPQb7atNK5dlakLy6Td4lf/kiyxjUPTmcoMQk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220825161156epcas5p4c4eb538b4d7d704d6f14bd288f956818~OonB-UYBK1709517095epcas5p4H;
        Thu, 25 Aug 2022 16:11:56 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MD7JV6lxLz4x9Pp; Thu, 25 Aug
        2022 16:11:54 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F8.D2.53458.A4F97036; Fri, 26 Aug 2022 01:11:54 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220825161154epcas5p31f4005e26691089dd1184d65d8936be9~Oom-nyvZb2413724137epcas5p3C;
        Thu, 25 Aug 2022 16:11:54 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220825161154epsmtrp21edc9025a9b465828804f80ead49491b~Oom-mxKxn1173811738epsmtrp2v;
        Thu, 25 Aug 2022 16:11:54 +0000 (GMT)
X-AuditID: b6c32a4a-a5bff7000000d0d2-61-63079f4acc5c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        84.33.14392.94F97036; Fri, 26 Aug 2022 01:11:53 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220825161152epsmtip14da160af07e9e33b8623cf73e98d32e1~Oom_GxGfn1946819468epsmtip1U;
        Thu, 25 Aug 2022 16:11:52 +0000 (GMT)
Date:   Thu, 25 Aug 2022 21:32:11 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH for-next 2/4] io_uring: introduce fixed buffer support
 for io_uring_cmd
Message-ID: <20220825160211.GC22496@test-zns>
MIME-Version: 1.0
In-Reply-To: <6e899ca1-bebb-5f94-1fa5-090a37ea03f2@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCJsWRmVeSWpSXmKPExsWy7bCmuq7XfPZkg4anxhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi0mHrjFa7L2lbTF/2VN2i0OTm5kcuDx2zrrL7nH5bKnH
        plWdbB6bl9R77L7ZwObxft9VNo++LasYPT5vkgvgiMq2yUhNTEktUkjNS85PycxLt1XyDo53
        jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6UEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xi
        q5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnfF6SgdLwWm+ir+7P7I1MO7n6WLk5JAQ
        MJGY0nCLGcQWEtjNKNG0Pa6LkQvI/sQoMfdkOzOE841R4syM62xdjBxgHXOnFUDE9zJKHHh9
        B6roGaPEzzPbWEFGsQioSrxrfc8I0sAmoClxYXIpSFhEQFvi9fVD7CA2s8BdRoktf7RAbGGB
        WIn3s1qZQGxeAV2JGW1t7BC2oMTJmU9YQGxOAVuJGU0djCC2qICyxIFtx5lA9koI7OGQ2Lp+
        BRPEOy4Si259ZIewhSVeHd8CZUtJfH63lw3CTpa4NPMcVH2JxOM9B6Fse4nWU/3MEMdlSHTs
        aGCEsPkken8/YYJ4nleio00IolxR4t6kp6wQtrjEwxlLoGwPiQ9bGpggYXKcSWL9qmbGCYxy
        s5D8MwvJCgjbSqLzQxMrhC0v0bx1NvMsoHXMAtISy/9xQJiaEut36S9gZFvFKJlaUJybnlps
        WmCUl1oOj+7k/NxNjODkq+W1g/Hhgw96hxiZOBgPMUpwMCuJ8FodY0kW4k1JrKxKLcqPLyrN
        SS0+xGgKjKqJzFKiyfnA9J9XEm9oYmlgYmZmZmJpbGaoJM47RZsxWUggPbEkNTs1tSC1CKaP
        iYNTqoGpqj8pznON0rkJrisD9ymrbHi1XpjD/Nwfu7ANs1Snl4qUfOm5vWFaf2XW9xsVH2dF
        8ZlwTXWaxfjAeevlC+9Phz/ydGzQvjb3ea5pBqPUxX8bJ6epC9w1X95/r8Bv+a/9POvU9YMX
        nT7xvnHt+kkm+pvOXQp9nFvLtTx12tpH0wXWe519sixH98PVLp6LVxf0VCg6q/NENwStsmv2
        altdIfvCOTQqPl/k7FGTd2d3bxHIfKMrw5OVlhh54RGjSNu6gG+L3GRPWJfvCN553TyQr3nv
        wZaXig/YFuhKsn48/0jGUOCWpWtz05F9ju5sxnHJdtcyH91UvW1ReeL92tI5S+ZJLIxmvz3p
        9p7uriNySizFGYmGWsxFxYkAn9mCMUcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSnK7nfPZkg8lHrC2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02HtL22L+sqfsFocmNzM5cHnsnHWX3ePy2VKP
        Tas62Tw2L6n32H2zgc3j/b6rbB59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CV0bBmBlvBHe6K
        S6cWsDQwvuXsYuTgkBAwkZg7raCLkYtDSGA3o8TzqW1sXYycQHFxieZrP9ghbGGJlf+es0MU
        PWGUaHx7nRkkwSKgKvGu9T0jyCA2AU2JC5NLQcIiAtoSr68fAqtnFrjLKHHz4X0mkISwQKzE
        +1mtYDavgK7EjLY2qKHHmSTmHrjADpEQlDg58wkLiM0sYCYxb/NDZpAFzALSEsv/cUCE5SWa
        t84Gu4FTwFZiRlMHI4gtKqAscWDbcaYJjEKzkEyahWTSLIRJs5BMWsDIsopRMrWgODc9t9iw
        wDAvtVyvODG3uDQvXS85P3cTIzjStDR3MG5f9UHvECMTB+MhRgkOZiURXqtjLMlCvCmJlVWp
        RfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MK2Xsr+ZG+h7fi7nEc6V
        V94vkTosvc9s88Uol5U5CasjHxfwz8/vTzp/YMYCOcej76t0A4zzmYW/Sn8VE5D4+WrFZHkF
        7m3PI4LfaB83rTl7SPmRmlWW/IIcn/4QaXsxt3uTt3EdXOO15O3Bnk7Zg4yiueuE7thOlXMx
        2KS2qU1xUuGjquJpCZOsDf+31UzZfKDwZD5P38s2FfUt/cqWc9ImnqwWXvz++9zlSrEaiREa
        BsUqCe3X+cIYJ5bN6332d+/58x8COafurM7Y/ecm9/SmNafC1OsvzlOSaLy15t4RxvLD93Tm
        rvj3NyLy/9ePOW2bTJVZ71huYvv75ZNx0FaPbzlOEmarLjE7v2KX/q3EUpyRaKjFXFScCACs
        gOo/IwMAAA==
X-CMS-MailID: 20220825161154epcas5p31f4005e26691089dd1184d65d8936be9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_aaf61_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220819104038epcas5p265c9385cfd9189d20ebfffeaa4d5efae
References: <20220819103021.240340-1-joshi.k@samsung.com>
        <CGME20220819104038epcas5p265c9385cfd9189d20ebfffeaa4d5efae@epcas5p2.samsung.com>
        <20220819103021.240340-3-joshi.k@samsung.com>
        <3294f1e9-1946-2fbf-d5cd-fcdff9288f72@gmail.com>
        <20220822113341.GA31599@test-zns>
        <6e899ca1-bebb-5f94-1fa5-090a37ea03f2@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_aaf61_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Thu, Aug 25, 2022 at 10:34:11AM +0100, Pavel Begunkov wrote:
>On 8/22/22 12:33, Kanchan Joshi wrote:
>>On Mon, Aug 22, 2022 at 11:58:24AM +0100, Pavel Begunkov wrote:
>[...]
>>>>diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>index 1463cfecb56b..80ea35d1ed5c 100644
>>>>--- a/include/uapi/linux/io_uring.h
>>>>+++ b/include/uapi/linux/io_uring.h
>>>>@@ -203,6 +203,7 @@ enum io_uring_op {
>>>>     IORING_OP_SOCKET,
>>>>     IORING_OP_URING_CMD,
>>>>     IORING_OP_SENDZC_NOTIF,
>>>>+    IORING_OP_URING_CMD_FIXED,
>>>
>>>I don't think it should be another opcode, is there any
>>>control flags we can fit it in?
>>
>>using sqe->rw_flags could be another way.
>
>We also use ->ioprio for io_uring opcode specific flags,
>e.g. like in io_sendmsg_prep() for IORING_RECVSEND_POLL_FIRST,
>might be even better better.
>
>>But I think that may create bit of disharmony in user-space.
>>Current choice (IORING_OP_URING_CMD_FIXED) is along the same lines as
>>IORING_OP_READ/WRITE_FIXED.
>
>And I still believe it was a bad choice, I don't like this encoding
>of independent options/features by linearising toggles into opcodes.
>A consistent way to add vectored fixed bufs would be to have a 4th
>opcode, e.g. READV_FIXED, which is not great.
>
>>User-space uses new opcode, and sends the
>>buffer by filling sqe->buf_index. So must we take a different way?
>
>I do think so

I see. Will change this in next iteration.

------_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_aaf61_
Content-Type: text/plain; charset="utf-8"


------_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_aaf61_--
