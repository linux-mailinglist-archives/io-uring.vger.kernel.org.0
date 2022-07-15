Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDCA575A78
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 06:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiGOEaM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 00:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiGOEaL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 00:30:11 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C1673906
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 21:30:03 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220715042958epoutp03d9b291853ca77e91c2dc8c6cf92f0050~B5la-iBmZ0277102771epoutp03l
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 04:29:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220715042958epoutp03d9b291853ca77e91c2dc8c6cf92f0050~B5la-iBmZ0277102771epoutp03l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657859398;
        bh=owXIalaytMURHG6CjRoCr9xwf2wpv/aRsk0K3EbdcAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AgTieWTzil+LEE6v5Mhy2PH3/XxjyQIgxE2CYVFIAxFSoFwzs4n6/8ZpU9lG47c/s
         VWUunbLlQRzhZJuWU6jdpIGxEvVHASAxME9T6/6iYmQ5UCT4DLpAhDGLBE4yjjit3L
         ELqtAWAKtsxZYx2kaZhjVCchYbS/Dvbzk5os0XfE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220715042957epcas5p181a4ec4dbf9728e65f127f2bd60ab6ab~B5ladyb_52844328443epcas5p1H;
        Fri, 15 Jul 2022 04:29:57 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4LkdgQ524Jz4x9Q9; Fri, 15 Jul
        2022 04:29:54 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CD.EB.09662.E3DE0D26; Fri, 15 Jul 2022 13:29:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220715042950epcas5p23f82a6eb0d750e1aa4558edc357600d3~B5lTj9zcv2170621706epcas5p2_;
        Fri, 15 Jul 2022 04:29:50 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220715042950epsmtrp17091cb76f3a0b875962dc597fb03d715~B5lTjGNz-0311303113epsmtrp1q;
        Fri, 15 Jul 2022 04:29:50 +0000 (GMT)
X-AuditID: b6c32a49-885ff700000025be-17-62d0ed3e4f66
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        04.BC.08802.D3DE0D26; Fri, 15 Jul 2022 13:29:49 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220715042947epsmtip2f1726cf7d3e972350a2caebcff06d381~B5lRLayV_3122531225epsmtip2R;
        Fri, 15 Jul 2022 04:29:47 +0000 (GMT)
Date:   Fri, 15 Jul 2022 09:54:23 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, hch@lst.de, kbusch@kernel.org,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        asml.silence@gmail.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Message-ID: <20220715042423.GA8414@test-zns>
MIME-Version: 1.0
In-Reply-To: <YtDG6BUZvJRO/4DR@T590>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJJsWRmVeSWpSXmKPExsWy7bCmhq7d2wtJBlffmls0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLM6/PcxkMenQNUaLvbe0LeYve8pucWhyM5PFutfvWRx4
        PHbOusvucf7eRhaPy2dLPTat6mTz2Lyk3mP3zQY2j/f7rrJ59G1ZxejxeZNcAGdUtk1GamJK
        apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0MFKCmWJOaVAoYDE
        4mIlfTubovzSklSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyM+S9OMxb0
        GVS0vrnN1MC4T7WLkZNDQsBE4lTLU+YuRi4OIYHdjBIH539mgnA+MUp8XLyGEcL5zCgx5dBs
        NpiW+e9bmUFsIYFdjBJXZihDFD1jlPh2YRcLSIJFQFXiQFMX0CgODjYBTYkLk0tBwiICShJ3
        765mB6lnFuhikljd0AxWLyyQLLHpySQmEJtXQEdi++nXrBC2oMTJmU/AajgFVCQ2714FdoSo
        gLLEgW3HwU6VENjDIXHz5R0WiOtcJK4uWs0IYQtLvDq+hR3ClpJ42d8GZSdLXJp5jgnCLpF4
        vOcglG0v0XqqH+wzZoEMibZJT9ghbD6J3t9PwJ6REOCV6GgTgihXlLg36SkrhC0u8XDGEijb
        Q2LBpsnQYFzILPHvyUWmCYxys5D8MwvJCgjbSqLzQxPrLKAVzALSEsv/cUCYmhLrd+kvYGRd
        xSiZWlCcm55abFpgmJdaDo/k5PzcTYzgNKzluYPx7oMPeocYmTgYDzFKcDArifB2HzqXJMSb
        klhZlVqUH19UmpNafIjRFBg/E5mlRJPzgZkgryTe0MTSwMTMzMzE0tjMUEmc1+vqpiQhgfTE
        ktTs1NSC1CKYPiYOTqkGpm1BQh9Mis87Kyws+yO312jqtRtchgu+LNtgHGOlNK+qOPpRvU3s
        0z8Sp22+z7rpGhQ1V/qy6O/TgsluE3SWZOy4+UF734q54gVeH5OXnPtw1GPzuxdH1SqU2SdY
        TZ+atvhd3l7O05ZshSYul9uM2g93Lta7e969UtCjvrF4q811OS92hjMHD3yNX7N62zedHZME
        LCYv22w/c12tFsvT8O0vHaOY11U9Ljgtdin6FvOT901ZKvl7hDfP4jNLXiZ1/xPnmxmbn1xn
        +9nqy7GuqWzRs4AclU0BIibyN1a5BHKdeLsjUP7LxW6Zc8ou+71qxY8uX92wxChoS+ShB+y3
        WH8ouP5dtz3/3KOdjKmNXg+UWIozEg21mIuKEwEKnprzTAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LZdlhJXtf27YUkg9krbCyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymHToGqPF3lvaFvOXPWW3ODS5mcli3ev3LA48
        Hjtn3WX3OH9vI4vH5bOlHptWdbJ5bF5S77H7ZgObx/t9V9k8+rasYvT4vEkugDOKyyYlNSez
        LLVI3y6BK+PfxV/MBQd0K76u2c3WwNil3MXIySEhYCIx/30rcxcjF4eQwA5GiS2r/jJCJMQl
        mq/9YIewhSVW/nvODlH0hFHi6bvHzCAJFgFViQNNXUxdjBwcbAKaEhcml4KERQSUJO7eXQ3W
        yyzQwySxfQ3YTGGBZIlNTyYxgdi8AjoS20+/ZoWYuZRZomt/L1RCUOLkzCcsEM1mEvM2P2QG
        mc8sIC2x/B8HSJhTQEVi8+5VbCC2qICyxIFtx5kmMArOQtI9C0n3LITuBYzMqxglUwuKc9Nz
        iw0LjPJSy/WKE3OLS/PS9ZLzczcxguNKS2sH455VH/QOMTJxMB5ilOBgVhLh7T50LkmINyWx
        siq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGprLwZTliMp+CY/bW
        Jv2ee/e55fHGO82M2Zd5Pm+RPjuTeVbwVpNb97qtbujznc+quda4r/jrfcmTp7+Gdl/h79Ju
        SjJt8CwMX/eocXsvo4ie86aGd9Vhy79l31rHqr+gtcAu4RDL+dtvZTyuS73Jaj8c7SM0/2je
        lJ4J1e9k9xZ3+T7bOIn727xZN5I1t/1rZWjxfW3YX2nD6v5czSdNdCGL+NH3fEcNNkj2nuUy
        MVvRc9AldobNHf7NW89P41DbZrKf/VN508304uSwvH1Pzh9JyufSUmHfV/Mw5vnxrdXXP8lc
        a19+cJfZpjPfV014JO8btOezsav9BuH+2LM7/fZydyTc7GidPnVWrY3naSWW4oxEQy3mouJE
        AHOk5kQaAwAA
X-CMS-MailID: 20220715042950epcas5p23f82a6eb0d750e1aa4558edc357600d3
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----4uDYvwK9rXuYswNs9kxv-nhSWtPVY2S1yu-00HbrDFo3a9vl=_9151a_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220715015054epcas5p1250190e9a9c5f33b464a3e2da87a8fd0
References: <20220711183746.GA20562@test-zns>
        <5f30c7de-03b1-768a-d44f-594ed2d1dc75@grimberg.me>
        <20220712042332.GA14780@test-zns>
        <3a2b281b-793b-b8ad-6a27-138c89a46fac@grimberg.me>
        <20220713053757.GA15022@test-zns> <YtAy2PUDoWUUE9Bl@T590>
        <20220714230523.GA14373@test-zns> <YtDEatX54KA2Q5XU@T590>
        <CGME20220715015054epcas5p1250190e9a9c5f33b464a3e2da87a8fd0@epcas5p1.samsung.com>
        <YtDG6BUZvJRO/4DR@T590>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------4uDYvwK9rXuYswNs9kxv-nhSWtPVY2S1yu-00HbrDFo3a9vl=_9151a_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Jul 15, 2022 at 09:46:16AM +0800, Ming Lei wrote:
>On Fri, Jul 15, 2022 at 09:35:38AM +0800, Ming Lei wrote:
>> On Fri, Jul 15, 2022 at 04:35:23AM +0530, Kanchan Joshi wrote:
>> > On Thu, Jul 14, 2022 at 11:14:32PM +0800, Ming Lei wrote:
>> > > On Wed, Jul 13, 2022 at 11:07:57AM +0530, Kanchan Joshi wrote:
>> > > > > > > > > The way I would do this that in nvme_ioucmd_failover_req (or in the
>> > > > > > > > > retry driven from command retriable failure) I would do the above,
>> > > > > > > > > requeue it and kick the requeue work, to go over the requeue_list and
>> > > > > > > > > just execute them again. Not sure why you even need an explicit retry
>> > > > > > > > > code.
>> > > > > > > > During retry we need passthrough command. But passthrough command is not
>> > > > > > > > stable (i.e. valid only during first submission). We can make it stable
>> > > > > > > > either by:
>> > > > > > > > (a) allocating in nvme (b) return -EAGAIN to io_uring, and
>> > > > > > > > it will do allocate + deferral
>> > > > > > > > Both add a cost. And since any command can potentially fail, that
>> > > > > > > > means taking that cost for every IO that we issue on mpath node. Even if
>> > > > > > > > no failure (initial or subsquent after IO) occcured.
>> > > > > > >
>> > > > > > > As mentioned, I think that if a driver consumes a command as queued,
>> > > > > > > it needs a stable copy for a later reformation of the request for
>> > > > > > > failover purposes.
>> > > > > >
>> > > > > > So what do you propose to make that stable?
>> > > > > > As I mentioned earlier, stable copy requires allocating/copying in fast
>> > > > > > path. And for a condition (failover) that may not even occur.
>> > > > > > I really think currrent solution is much better as it does not try to make
>> > > > > > it stable. Rather it assembles pieces of passthrough command if retry
>> > > > > > (which is rare) happens.
>> > > > >
>> > > > > Well, I can understand that io_uring_cmd is space constrained, otherwise
>> > > > > we wouldn't be having this discussion.
>> > > >
>> > > > Indeed. If we had space for keeping passthrough command stable for
>> > > > retry, that would really have simplified the plumbing. Retry logic would
>> > > > be same as first submission.
>> > > >
>> > > > > However io_kiocb is less
>> > > > > constrained, and could be used as a context to hold such a space.
>> > > > >
>> > > > > Even if it is undesired to have io_kiocb be passed to uring_cmd(), it
>> > > > > can still hold a driver specific space paired with a helper to obtain it
>> > > > > (i.e. something like io_uring_cmd_to_driver_ctx(ioucmd) ). Then if the
>> > > > > space is pre-allocated it is only a small memory copy for a stable copy
>> > > > > that would allow a saner failover design.
>> > > >
>> > > > I am thinking along the same lines, but it's not about few bytes of
>> > > > space rather we need 80 (72 to be precise). Will think more, but
>> > > > these 72 bytes really stand tall in front of my optimism.
>> > > >
>> > > > Do you see anything is possible in nvme-side?
>> > > > Now also passthrough command (although in a modified form) gets copied
>> > > > into this preallocated space i.e. nvme_req(req)->cmd. This part -
>> > >
>> > > I understand it can't be allocated in nvme request which is freed
>> > > during retry,
>> >
>> > Why not. Yes it gets freed, but we have control over when it gets freed
>> > and we can do if anything needs to be done before freeing it. Please see
>> > below as well.
>>
>> This way requires you to hold the old request until one new path is
>> found, and it is fragile.
>>
>> What if there isn't any path available then controller tries to
>> reset the path? If the requeue or io_uring_cmd holds the old request,
>> it might cause error recovery hang or make error handler code more
>> complicated.

no, no, this code does not hold the old request until path is found.
It is not tied to path discovery at all.
old request is freed much early, just after extracting pieces of
passthrough-commands from it (i.e. from nvme_req(req)->cmd).
Seems you are yet to look at the snippet I shared.

>> >
>> > > and looks the extra space has to be bound with
>> > > io_uring_cmd.
>> >
>> > if extra space is bound with io_uring_cmd, it helps to reduce the code
>> > (and just that. I don't see that efficiency will improve - rather it
>>
>> Does retry have to be efficient?

I also do not care about that. But as mentioned earlier, it is each-io
cost not failure-only. Lifetime of original passthrough-cmd is
first submission. So if we take this route, we need to do extra copy or
allocate+copy (which is trivial by just returing -EAGAIN to io_uring) 
for each io that is issued on mpath-node.  

>> > will be tad bit less because of one more 72 byte copy opeation in fast-path).
>>
>> Allocating one buffer and bind it with io_uring_cmd in case of retry is actually
>> similar with current model, retry is triggered by FS bio, and the allocated
>> buffer can play similar role with FS bio.
>
>oops, just think of SQE data only valid during submission, so the buffer
>has to be allocated during 1st submission, 

Exactly.

> but the allocation for each io_uring_cmd
>shouldn't cost much by creating one slab cache, especially inline data
>size of io_uring_cmd has been 56(24 + 32) bytes.

io_uring_cmd does not take any extra memory currently. It is part of the
existing (per-op) space of io_kiocb. Is it a good idea to amplify + decouple 
that into its own slab cache for each io (that may not be going to mpath
node, and may not be failing either).

I really wonder why current solution using  nvme_req(req)->cmd (which is
also preallocated stable storage) is not much better.

------4uDYvwK9rXuYswNs9kxv-nhSWtPVY2S1yu-00HbrDFo3a9vl=_9151a_
Content-Type: text/plain; charset="utf-8"


------4uDYvwK9rXuYswNs9kxv-nhSWtPVY2S1yu-00HbrDFo3a9vl=_9151a_--
