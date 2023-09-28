Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2A57B10C3
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 04:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjI1Cay (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Sep 2023 22:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjI1Cax (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Sep 2023 22:30:53 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9BC10A
        for <io-uring@vger.kernel.org>; Wed, 27 Sep 2023 19:30:48 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230928023044epoutp023fdd187236dd754e40bc9efeaf030d79~I7y7f2Ces1143411434epoutp02g
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 02:30:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230928023044epoutp023fdd187236dd754e40bc9efeaf030d79~I7y7f2Ces1143411434epoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1695868244;
        bh=2XNiWv3EiXVqpow5w0n8GvnEXonI3MHQ19BqXIlj2yE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=EDzsy0keB3RP0Dv4bDtrpsBY5DoSB44E4M2sut3LgFy0x4PAh97eCescO+qBHWD3k
         W7P5bBuVUVH5DyFTokBOE8ixHycYr1XQGYYa+1gNFKWZDiXMmb5Znsaa6FMojJzAGx
         9ruzD0v57mHm6t8Mic315o0TFmP/eNwgMCiLAwlE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230928023043epcas5p1179c293653e95b42026e84f545ed9987~I7y67QM0J0086800868epcas5p1i;
        Thu, 28 Sep 2023 02:30:43 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4RwyBp1gg6z4x9Py; Thu, 28 Sep
        2023 02:30:42 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        72.E8.09949.255E4156; Thu, 28 Sep 2023 11:30:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230928023004epcas5p4a6dac4cda9c867f3673690521a8c18b6~I7yWbRz1l0852208522epcas5p4F;
        Thu, 28 Sep 2023 02:30:04 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230928023004epsmtrp1c5d3a89b362438f1a591a4a3d8704892~I7yWaLsEM1037210372epsmtrp1b;
        Thu, 28 Sep 2023 02:30:04 +0000 (GMT)
X-AuditID: b6c32a49-98bff700000026dd-a4-6514e552880b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        54.49.08788.C25E4156; Thu, 28 Sep 2023 11:30:04 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230928023002epsmtip1805a97e7ada65d3a99a24271b3d1dc5c~I7yUcJbvD1182111821epsmtip16;
        Thu, 28 Sep 2023 02:30:02 +0000 (GMT)
From:   Xiaobing Li <xiaobing.li@samsung.com>
To:     mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, axboe@kernel.dk,
        asml.silence@gmail.com
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, kun.dou@samsung.com,
        peiwei.li@samsung.com, joshi.k@samsung.com,
        kundan.kumar@samsung.com, wenwen.chen@samsung.com,
        ruyi.zhang@samsung.com, Xiaobing Li <xiaobing.li@samsung.com>
Subject: [PATCH 0/3] Sq thread real utilization statistics.
Date:   Thu, 28 Sep 2023 10:22:25 +0800
Message-Id: <20230928022228.15770-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJsWRmVeSWpSXmKPExsWy7bCmum7QU5FUg/4NnBZzVm1jtFh9t5/N
        4tLjq2wW0182slg8nbCV2eJd6zkWi6P/37JZ3O2fymLxq/suo8XWL19ZLfbsPclicXnXHDaL
        ye+eMVpcOrCAyeLZXk6L470HmCz2dTxgsvhy+Du7RceRb8wWW48CWVO37GCy6Gi5zOgg5rFm
        3hpGj52z7rJ7tOy7xe6xYFOpx+YVWh6Xz5Z63Lm2h83j/b6rbB59W1Yxemw+Xe3xeZNcAHdU
        tk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0KtKCmWJ
        OaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyM
        vY17GQt+CVVsv9rF0sB4gq+LkZNDQsBE4u+SdvYuRi4OIYHdjBLTr05ghXA+MUocPPOcDaRK
        SOAbo0TH+0iYjgl9vUwQ8b2MEs/nyEM0vGSUmHdwAgtIgk1AW+L6ui6wSSICnUwSuxbfB3OY
        BSYxSazZch7I4eAQFrCWuLmhAqSBRUBV4s3ddWBTeQVsJGaf72WD2CYvsf/gWWaIuKDEyZlP
        wBYwA8Wbt85mBpkpIfCEQ+J09ysmiAYXidMz9kM1C0u8Or6FHcKWknjZ3wZlF0sc6fnOCtHc
        APT07atQCWuJf1f2sIAcxyygKbF+lz5EWFZi6imI45gF+CR6fz+B2sUrsWMejK0qsfrSQxYI
        W1ridcNvqLiHxMm3PdBgjJW4+nQx8wRG+VlI/pmF5J9ZCJsXMDKvYpRMLSjOTU8tNi0wzEst
        h8dscn7uJkZwktfy3MF498EHvUOMTByMhxglOJiVRHgf3hZKFeJNSaysSi3Kjy8qzUktPsRo
        CgzkicxSosn5wDyTVxJvaGJpYGJmZmZiaWxmqCTO+7p1boqQQHpiSWp2ampBahFMHxMHp1QD
        U/e8x906C5ym8HhPXr4orT1sn2rq7rMSvY/X24UKxK04xzfZMZc9aPbHr1/52uPNqjV/e64/
        On8Tz8s1K10efGnesaVUlC3h85RZL7cnlW8qLLwpuELcW6F1nWnMg3gfS1mTe7e+rSxM3rT3
        UTAzx8yq1b0uvh4C03PTjectnPfBkKMpbOKbqR9Fsk6Eyk0/c3uG3Rr/9ALdXu+TgasnvcuL
        2iY2S1Swn/2MwYKzJ9IN70Uc6dJ5Hj53wdOnDmpOuR/ne+TF8c4KW7+ravKmypk/0u5nRjYs
        fcLKwjsr+nbSj0OzrHenrO72q7h1btEJtt3f7hfwhfFFJladELujon7UNa/57XzfXz5aB/4q
        MyixFGckGmoxFxUnAgAGN8szewQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWy7bCSnK7OU5FUg1P3JC3mrNrGaLH6bj+b
        xaXHV9kspr9sZLF4OmErs8W71nMsFkf/v2WzuNs/lcXiV/ddRoutX76yWuzZe5LF4vKuOWwW
        k989Y7S4dGABk8WzvZwWx3sPMFns63jAZPHl8Hd2i44j35gtth4FsqZu2cFk0dFymdFBzGPN
        vDWMHjtn3WX3aNl3i91jwaZSj80rtDwuny31uHNtD5vH+31X2Tz6tqxi9Nh8utrj8ya5AO4o
        LpuU1JzMstQifbsEroy9jXsZC34JVWy/2sXSwHiCr4uRk0NCwERiQl8vUxcjF4eQwG5GicXb
        21i7GDmAEtISf/6UQ9QIS6z895wdouY5o8SdqdeYQRJsAtoS19d1sYLYIgIzmSQm/IgEKWIW
        mMck0XvjLhvIIGEBa4mbGypAalgEVCXe3F3HBGLzCthIzD7fywaxQF5i/8GzzBBxQYmTM5+w
        gNjMQPHmrbOZJzDyzUKSmoUktYCRaRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnC0
        aWntYNyz6oPeIUYmDsZDjBIczEoivA9vC6UK8aYkVlalFuXHF5XmpBYfYpTmYFES5/32ujdF
        SCA9sSQ1OzW1ILUIJsvEwSnVwLRTu6BmXdBLHZ3801eSv5j0FZVmFwgY3tU8tLzd3PmC2VHz
        +pSJ3b9q/68U8bM4Z/S9ZnvSSRffr8uXPWtKt8/7y3SJ2UHB3MmLdXcQ+2nbsrTyj1OdUmaX
        3z9xuOXBXS/9JwL73LYlO1y/IGotZLvaXmqm3Lb4Xd/2N+x9yn6JmZutbrNOTHFoj9RB6YXr
        s84KRASvfB6ac9rHIbiaTXd91U/OtYV6b490zc6sN99nkhJ4LPxFkbbXpE0Hfv3sejTXO/tj
        r7JMTlvx9b2TVu5Wqq2Pfr7zTIFZ4w+mBM/4JIX1U88f36m8da3Fsr2Z0ccbGLfIytXkTH/o
        zG6UaupeOGH1lM97vBZsq9PfrsRSnJFoqMVcVJwIAHz6G+8lAwAA
X-CMS-MailID: 20230928023004epcas5p4a6dac4cda9c867f3673690521a8c18b6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230928023004epcas5p4a6dac4cda9c867f3673690521a8c18b6
References: <CGME20230928023004epcas5p4a6dac4cda9c867f3673690521a8c18b6@epcas5p4.samsung.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Summary:

The current kernel's pelt scheduling algorithm is calculated based on
the running time of the thread. However, this algorithm may cause a
waste of CPU resources for some threads, such as the sq thread in
io_uring.
Since the sq thread has a while(1) structure, during this process, there
may be a lot of time when IO is not processed but the timeout period is
not exceeded, so the sqpoll thread will keep running, thus occupying the
CPU. Obviously, the CPU is wasted at this time.
our goal is to count the part of the time the sqpoll thread actually
processes IO, thereby reflecting the part of its CPU used to process IO,
which can be used to help improve the actual utilization of the CPU in
the future.
Modifications to the scheduling module are also applicable to other
threads with the same needs.

We use fio (version 3.28) to test the performance. In the experiments,
an fio process are viewed as an application, it starts job with sq_poll
enabled. The tests are performed on a host with 256 CPUs and 64G memory,
the IO tasks are performed on a PM1743 SSD, and the OS is Ubuntu 22.04
with kernel version of 6.4.0.

Some parameters for sequential reading and writing are as follows:
bs=128k, numjobs=1, iodepth=64.
Some parameters for random reading and writing are as follows:
bs=4k, numjobs=16, iodepth=64.

The test results are as follows:
Before modification
         read   write   randread   randwrite
IOPS(K)  53.7   46.1    849        293
BW(MB/S) 7033   6037    3476       1199

After modification
         read   write   randread   randwrite
IOPS(K)  53.7   46.1    847        293
BW(MB/S) 7033   6042    3471       1199

It can be seen from the test results that my modifications have almost
no impact on performance.

Xiaobing Li (3):
  SCHEDULER: Add an interface for counting real utilization.
  PROC FILESYSTEM: Add real utilization data of sq thread.
  IO_URING: Statistics of the true utilization of sq threads.

 fs/proc/stat.c              | 25 ++++++++++++++++++++++++-
 include/linux/kernel.h      |  7 ++++++-
 include/linux/kernel_stat.h |  3 +++
 include/linux/sched.h       |  1 +
 io_uring/sqpoll.c           | 26 +++++++++++++++++++++++++-
 kernel/sched/cputime.c      | 36 +++++++++++++++++++++++++++++++++++-
 kernel/sched/pelt.c         | 14 ++++++++++++++
 7 files changed, 108 insertions(+), 4 deletions(-)

-- 
2.34.1

