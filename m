Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26F65757E0
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 01:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbiGNXLC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 19:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbiGNXLB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 19:11:01 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E9113EB9
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 16:10:58 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220714231052epoutp02c3564b8828576f3a365d3d6ef655dc64~B1O0Mo_p-0108801088epoutp02U
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 23:10:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220714231052epoutp02c3564b8828576f3a365d3d6ef655dc64~B1O0Mo_p-0108801088epoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657840252;
        bh=XKjcKrBiNJPIvHm3Pc2IEOcF6ugpBtjk6hvCUBodlt0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i2HYImPFPsgmSGXbeTjyn901pQKgwL52cir0nTdeFc9vAeNbzNsw8V0rf3sMzb4Oy
         oY2n2bxZSpHIxDYo77jEUtXCfH4QqBG2VCxhq+gFUM/rvJpeAsP5lTCh/yz8Bf2y3U
         Wco59c+yP04knttxwXQXfehdmNC6LaBIPCkMO22Y=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220714231051epcas5p4b3caa5ff4752700aa15940f21eae0240~B1Ozjy64R2828228282epcas5p4Y;
        Thu, 14 Jul 2022 23:10:51 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4LkVbF1vf4z4x9Pp; Thu, 14 Jul
        2022 23:10:49 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.0F.09662.972A0D26; Fri, 15 Jul 2022 08:10:49 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220714231048epcas5p14495dd43b5e169ee533cc185f72addac~B1OwwKDkG2822628226epcas5p1G;
        Thu, 14 Jul 2022 23:10:48 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220714231048epsmtrp2fa8cbc7ae1ae03b4d1dc1e094684c385~B1OwuO9KX2203722037epsmtrp2M;
        Thu, 14 Jul 2022 23:10:48 +0000 (GMT)
X-AuditID: b6c32a49-885ff700000025be-d2-62d0a2791e39
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        38.9E.08905.872A0D26; Fri, 15 Jul 2022 08:10:48 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220714231046epsmtip2d59211587a5e568e2ae354c6648668bb~B1OvDrAlM0098600986epsmtip2b;
        Thu, 14 Jul 2022 23:10:46 +0000 (GMT)
Date:   Fri, 15 Jul 2022 04:35:23 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, hch@lst.de, kbusch@kernel.org,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        asml.silence@gmail.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Message-ID: <20220714230523.GA14373@test-zns>
MIME-Version: 1.0
In-Reply-To: <YtAy2PUDoWUUE9Bl@T590>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTZxjG953Tnp661Z0ViJ+VuXq8TFgKrWvLQWFbBrqjm0kTFmXO2BU4
        oQRom17o3BLsRCZyEaybaLMFMho7WwaDEQYUTK0XNqeFXZiRpKRqC5t2XJRoZEHXenDxv9/3
        vM97+W44KuzDRHiJzswYdZoyElvG6T2fslGy/5vRAunA1eepg02LKPWVuxdQnmAjRl339SPU
        Gc9FhJquDnCokX/OI5Td/yeghsZfo1pOR3iU/3gVQnXcmeG89QLd7wjy6JGJLg79+1UL3e0+
        gtE/OA/Q3us2jJ45O4bRR3vcgL7XvVrF31OapWU0RYxRzOgK9UUluuJs8t08dY5aoZTKJLJM
        KoMU6zTlTDaZ+55Ksq2kLDYwKa7QlFlikkpjMpHpb2QZ9RYzI9bqTeZskjEUlRnkhjSTptxk
        0RWn6RjzZplUukkRM35Uqr0wVocavlv38WzzSdQG/Mm1gI9DQg5d55rRWrAMFxJeAB9Uj2Ps
        4i6AHt/Zpch9AI/OB8DTlGjfOC/OQmIIwF/+ymVNkwC2fRZ6EuAQ62FnYIBbC3AcI1Lg6HFL
        XE4kSBgMenhxP0rUItBjq+LEAwlEIewO25E4CwgJPP31Ay7LL8GfT4U58Tp8Yh2M/L01LicR
        a6GvdxiJ14HEIA7b3WMcdrhc2HJoCmM5Ad4e7uGxLIL3poeW9EL426kAwrIZ3ho8t8RvwurL
        jWicUUILF9q+R1heDhv+DSPxGSAhgDWfC1n7Gjhhj3BZXgFvnHQuMQ3nWqp47JmEUDh4qQNt
        Aqsdz2zH8UwLljfDI7MHuY5YC5RYBV2PcBZTYOdAeivgusFKxmAqL2ZMCoNMx1j/v+NCfXk3
        ePKEU7f3gWBoNs0PEBz4AcRRMlFQ5w8UCAVFmv2fMEa92mgpY0x+oIhdzzFUlFSoj/0BnVkt
        k2dK5UqlUp75ulJGrhDsGOsuEBLFGjNTyjAGxvg0D8H5IhuC3xQ31Guj73+L1XExDIT2Tbf2
        jphrOuYzyPzk5KkDOVFRc8LD1NGBcP5j+LAiCXe3198sn56oy8of9jrs6sRA8adXrILADftG
        gWV2+8xyR5J7wV/TpR/Pu7ty37HH0RM9ezdcJsW7nHsadnIkOVt8rvuyqefeeeVWDs9t3bTz
        R9+u6FDrNdsVV2nF/CXGHAlN2u78FPHOHV5b8sXu1jMZqldffLTQ5l+sbEqn5/7o+tWq9qxx
        zF3I62937g4Nhr1Vh3PhB4cgf+/bFp9UgCo6pSqhdP2is7FVWVu/o22cG7724ctbgwuLqxYk
        zZMX8S1fWh0bZjsqg9OugdsTlSTHpNXIUlGjSfMfrw8XSUsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LZdlhJXrdi0YUkg/4zyhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZTDp0jdFi7y1ti/nLnrJbHJrczGSx7vV7Fgce
        j52z7rJ7nL+3kcXj8tlSj02rOtk8Ni+p99h9s4HN4/2+q2wefVtWMXp83iQXwBnFZZOSmpNZ
        llqkb5fAlbHnUTtTwX3FiiPnz7E1MPZJdTFyckgImEi82XGLvYuRi0NIYDejxPX7U9ggEuIS
        zdd+sEPYwhIr/z2HKnrCKDF5xxZWkASLgKrE+nO7gGwODjYBTYkLk0tBwiICShJ3764G62UW
        6GGS2L6GEcQWFkiW2PRkEhOIzSugK7Fs7ndWiJmPmCX+L1/ADJEQlDg58wkLRLOZxLzND5lB
        5jMLSEss/8cBYnIKqEg8fekKUiEqoCxxYNtxpgmMgrOQNM9C0jwLoXkBI/MqRsnUguLc9Nxi
        wwLDvNRyveLE3OLSvHS95PzcTYzgqNLS3MG4fdUHvUOMTByMhxglOJiVRHi7D51LEuJNSays
        Si3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoFpw2aj5Fm/+ji/rytI
        89awfHP8h5/2qY4JxUkmq/QCv6q7639PDvwy84V89Yp/Ys2Jhyu/u/ssnd3JxDFpQ//XpWzr
        vCe8qn99+QiTrU5Uvb90Vi2Xu9Xh/NqIQmH3WbpP8ybt0sh8Ua6t43b8xk9rs8v/bzDMXdXf
        /S7PZHfmiQztupfs9/6zfW7bvj+M+cK7f9mv9DfefM715PnMR28WTVapPdWStPU6w4xQs1yP
        R5ufeu9Yavva9/IFKaYqfv93f/8aXAnX9f6am/71XylLsrzwm5m9AtNvuWxQ3ZSz8cj6o2wH
        vjhkdpRr+9qfTeJjOGRhGFm7/UZr8T1ficcKl91djt2exRrDZpfcZXlQiaU4I9FQi7moOBEA
        FcrZKBkDAAA=
X-CMS-MailID: 20220714231048epcas5p14495dd43b5e169ee533cc185f72addac
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_90150_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089
References: <20220711110155.649153-1-joshi.k@samsung.com>
        <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
        <20220711110155.649153-5-joshi.k@samsung.com>
        <3fc68482-fb24-1f39-5428-faa3a8db9ecb@grimberg.me>
        <20220711183746.GA20562@test-zns>
        <5f30c7de-03b1-768a-d44f-594ed2d1dc75@grimberg.me>
        <20220712042332.GA14780@test-zns>
        <3a2b281b-793b-b8ad-6a27-138c89a46fac@grimberg.me>
        <20220713053757.GA15022@test-zns> <YtAy2PUDoWUUE9Bl@T590>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_90150_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, Jul 14, 2022 at 11:14:32PM +0800, Ming Lei wrote:
>On Wed, Jul 13, 2022 at 11:07:57AM +0530, Kanchan Joshi wrote:
>> > > > > > The way I would do this that in nvme_ioucmd_failover_req (or in the
>> > > > > > retry driven from command retriable failure) I would do the above,
>> > > > > > requeue it and kick the requeue work, to go over the requeue_list and
>> > > > > > just execute them again. Not sure why you even need an explicit retry
>> > > > > > code.
>> > > > > During retry we need passthrough command. But passthrough command is not
>> > > > > stable (i.e. valid only during first submission). We can make it stable
>> > > > > either by:
>> > > > > (a) allocating in nvme (b) return -EAGAIN to io_uring, and
>> > > > > it will do allocate + deferral
>> > > > > Both add a cost. And since any command can potentially fail, that
>> > > > > means taking that cost for every IO that we issue on mpath node. Even if
>> > > > > no failure (initial or subsquent after IO) occcured.
>> > > >
>> > > > As mentioned, I think that if a driver consumes a command as queued,
>> > > > it needs a stable copy for a later reformation of the request for
>> > > > failover purposes.
>> > >
>> > > So what do you propose to make that stable?
>> > > As I mentioned earlier, stable copy requires allocating/copying in fast
>> > > path. And for a condition (failover) that may not even occur.
>> > > I really think currrent solution is much better as it does not try to make
>> > > it stable. Rather it assembles pieces of passthrough command if retry
>> > > (which is rare) happens.
>> >
>> > Well, I can understand that io_uring_cmd is space constrained, otherwise
>> > we wouldn't be having this discussion.
>>
>> Indeed. If we had space for keeping passthrough command stable for
>> retry, that would really have simplified the plumbing. Retry logic would
>> be same as first submission.
>>
>> > However io_kiocb is less
>> > constrained, and could be used as a context to hold such a space.
>> >
>> > Even if it is undesired to have io_kiocb be passed to uring_cmd(), it
>> > can still hold a driver specific space paired with a helper to obtain it
>> > (i.e. something like io_uring_cmd_to_driver_ctx(ioucmd) ). Then if the
>> > space is pre-allocated it is only a small memory copy for a stable copy
>> > that would allow a saner failover design.
>>
>> I am thinking along the same lines, but it's not about few bytes of
>> space rather we need 80 (72 to be precise). Will think more, but
>> these 72 bytes really stand tall in front of my optimism.
>>
>> Do you see anything is possible in nvme-side?
>> Now also passthrough command (although in a modified form) gets copied
>> into this preallocated space i.e. nvme_req(req)->cmd. This part -
>
>I understand it can't be allocated in nvme request which is freed
>during retry,

Why not. Yes it gets freed, but we have control over when it gets freed
and we can do if anything needs to be done before freeing it. Please see
below as well.

>and looks the extra space has to be bound with
>io_uring_cmd.

if extra space is bound with io_uring_cmd, it helps to reduce the code
(and just that. I don't see that efficiency will improve - rather it
will be tad bit less because of one more 72 byte copy opeation in fast-path).

Alternate is to use this space that is bound with request i.e.
nvme_req(req)->cmd. This is also preallocated and passthru-cmd
already gets copied. But it is ~80% of the original command. 
Rest 20% includes few fields (data/meta buffer addres, rspective len)
which are not maintained (as bio/request can give that). 
During retry, we take out stuff from nvme_req(req)->cmd and then free
req. Please see nvme_uring_cmd_io_retry in the patch. And here is the
fragement for quick glance -

+       memcpy(&c, nvme_req(oreq)->cmd, sizeof(struct nvme_command));
+       d.metadata = (__u64)pdu->meta_buffer;
+       d.metadata_len = pdu->meta_len;
+       d.timeout_ms = oreq->timeout;
+       d.addr = (__u64)ioucmd->cmd;
+       if (obio) {
+               d.data_len = obio->bi_iter.bi_size;
+               blk_rq_unmap_user(obio);
+       } else {
+               d.data_len = 0;
+       }
+       blk_mq_free_request(oreq);

Do you see chinks in above?

------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_90150_
Content-Type: text/plain; charset="utf-8"


------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_90150_--
