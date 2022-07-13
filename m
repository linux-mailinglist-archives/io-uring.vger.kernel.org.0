Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95222572D88
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 07:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiGMFnf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 01:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiGMFne (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 01:43:34 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDFEDE5
        for <io-uring@vger.kernel.org>; Tue, 12 Jul 2022 22:43:30 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220713054328epoutp03efdf0afab7fc786f1aebaeb5b5ecfff4~BTTCE5wsC0181701817epoutp03Y
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 05:43:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220713054328epoutp03efdf0afab7fc786f1aebaeb5b5ecfff4~BTTCE5wsC0181701817epoutp03Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657691008;
        bh=4wt4WsiJya8ykf4QAqXzdPL0w8cT2KSvdLPlVWjsnxQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iT2pZ3o6hUl423uXaBk2+tiIzMW9Ql2jWETLL3HKS6uquTlAfzkWwEbi5o5exaKVx
         Nihx0xHbMbyRj3WWlKa90cHFuo1Vw8z3h7bG2i+XxnL7qQp7iHBXSmzW7icNC00GM0
         1mj/julBY7JHAOZn8YfvvheRXN5xqDuVWh4Rxjxg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220713054327epcas5p29a6d8001720a018a635795324317ae1d~BTTBYADKc1855418554epcas5p2N;
        Wed, 13 Jul 2022 05:43:27 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4LjRP94LbDz4x9QH; Wed, 13 Jul
        2022 05:43:25 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.0B.09662.B7B5EC26; Wed, 13 Jul 2022 14:43:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220713054323epcas5p42f653c6987abcc04adfadf5e992f4fdb~BTS9UIA8g2841528415epcas5p4J;
        Wed, 13 Jul 2022 05:43:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220713054323epsmtrp13ff18c92d88b84d7b8bab90081ce4340~BTS9TbWMI3156531565epsmtrp1C;
        Wed, 13 Jul 2022 05:43:23 +0000 (GMT)
X-AuditID: b6c32a49-86fff700000025be-d2-62ce5b7b68a8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.DE.08905.B7B5EC26; Wed, 13 Jul 2022 14:43:23 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220713054321epsmtip22b97f4691832d04cb323f096487e5097~BTS7JGYGT0918209182epsmtip2n;
        Wed, 13 Jul 2022 05:43:21 +0000 (GMT)
Date:   Wed, 13 Jul 2022 11:07:57 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     hch@lst.de, kbusch@kernel.org, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Message-ID: <20220713053757.GA15022@test-zns>
MIME-Version: 1.0
In-Reply-To: <3a2b281b-793b-b8ad-6a27-138c89a46fac@grimberg.me>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBJsWRmVeSWpSXmKPExsWy7bCmlm519Lkkg50vjS2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymHToGqPF3lvaFvOXPWW3WPf6PYsDt8fOWXfZ
        Pc7f28jicflsqcemVZ1sHpuX1HvsvtnA5tG3ZRWjx+dNcgEcUdk2GamJKalFCql5yfkpmXnp
        tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBnKimUJeaUAoUCEouLlfTtbIryS0tS
        FTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyMyY0d7EXdDhW/H6+mbWB8blZ
        FyMnh4SAicTmV1fZuhi5OIQEdjNK3O1tZYFwPjFK7NrfzgThfGOUWH36JSNMy5TFO5hBbCGB
        vYwST/fWQBQ9Y5Q49/U6UBEHB4uAqsTKGcogJpuApsSFyaUgpoiAisSbN7kg1cwCLxglFs5b
        yAoyRlggWWLTk0lMIDavgK7E0gk7WCFsQYmTM5+wgNicAvYS8/esA6sRFVCWOLDtONhtEgJH
        OCTu7/nBCrJAQsBFYv0+ZogzhSVeHd/CDmFLSbzsb4OykyUuzTzHBGGXSDzecxDKtpdoPdUP
        1ssskCGxZ+JpKJtPovf3EyaI8bwSHW1CEOWKEvcmPWWFsMUlHs5YAmV7SHyc38wOCZElzBLz
        505mmsAoNwvJO7OQrICwrSQ6PzSxQtjyEs1bZwPFOYBsaYnl/zggTE2J9bv0FzCyrWKUTC0o
        zk1PLTYtMMxLLYfHdnJ+7iZGcBLW8tzBePfBB71DjEwcjIcYJTiYlUR4/5w9lSTEm5JYWZVa
        lB9fVJqTWnyI0RQYUROZpUST84F5IK8k3tDE0sDEzMzMxNLYzFBJnNfr6qYkIYH0xJLU7NTU
        gtQimD4mDk6pBiYnYEDOlUiePutvXPz6izs6d1oGJGdpqEbcdPJ8a9Lkdkz9ivK9OrdTOR9Y
        3x9slf9Wc3qaguuWCUkyySEOU59l8hkJH316YFPcDx1Wca61fAGmE4qOOQj4cjWY6M3Y7cUr
        srJC7Nh9XvsHQqJ7FOdl58RvXOMQl6JrkjH5c+Dz26vWc5+qj+qt+dApURgxxe35/ktvBPuC
        dq9Wv3xs9VrbgJ8Psyblta3qmJ13+f7ijcnWDMnB3v8O3Qq4Ky7rIrPvSvjUu6x1cYeiNFdr
        zGPYfKGA6fVeziR5cVlNfsFT6iu23fKT5xRp/J2zVuEoy9ZdssX/j2/5Pjko7VhcbU5yZ/c0
        l31Sk2LKDEpYlFiKMxINtZiLihMBPvcLIUsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvG519Lkkg1M/pCyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymHToGqPF3lvaFvOXPWW3WPf6PYsDt8fOWXfZ
        Pc7f28jicflsqcemVZ1sHpuX1HvsvtnA5tG3ZRWjx+dNcgEcUVw2Kak5mWWpRfp2CVwZ1w83
        sRTMtKuYcm4NWwPjVJMuRk4OCQETiSmLdzCD2EICuxklTmyKh4iLSzRf+8EOYQtLrPz3HMjm
        Aqp5wiix9tph1i5GDg4WAVWJlTOUQUw2AU2JC5NLQUwRARWJN29yQaqZBV4wSly8soUFZIyw
        QLLEpieTmEBsXgFdiaUTdrBCjFzCLDH7x0FmiISgxMmZT8AamAXMJOZtfsgMMpRZQFpi+T8O
        iLC8RPPW2WDlnAL2EvP3rAObKSqgLHFg23GmCYxCs5BMmoVk0iyESbOQTFrAyLKKUTK1oDg3
        PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM43rQ0dzBuX/VB7xAjEwfjIUYJDmYlEd4/Z08lCfGm
        JFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cC01Fr5sqzw1Gwr
        +5PTXXYcvl+0521r/ER1tl7X8I6G1G7Bk58Zzz/kaHmQ8YYl+b1J+txdp+4cs3pWvHbPEu/e
        mQVTa0VKuxMKz2fNZl6f/u7nw1O3XY8WntVbPGmV6rJ0p2aX/2ejdn1yk9/16+PFneuf7Fse
        9S14WsSkFTHhHIxrhTcsCL21MnPi9zdbGThfr9L4cHTS5YUGFzcx7FI0TWtk2Xv7mpbllbSb
        q+Vi4jsfPfysJNG6NGKNl2LLm08udrN3/5z19OfFnsLXrvJt9bw/W0V0a5Oavr0583BhCvPD
        M09v7np7ff/lkNWB689ltESWR887O+PRJZ40k4+Zk3Imnzi6NiCs9afdLNG3e7iVWIozEg21
        mIuKEwG6o6MwJgMAAA==
X-CMS-MailID: 20220713054323epcas5p42f653c6987abcc04adfadf5e992f4fdb
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_85ad0_"
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
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_85ad0_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

>>>>>The way I would do this that in nvme_ioucmd_failover_req (or in the
>>>>>retry driven from command retriable failure) I would do the above,
>>>>>requeue it and kick the requeue work, to go over the requeue_list and
>>>>>just execute them again. Not sure why you even need an explicit retry
>>>>>code.
>>>>During retry we need passthrough command. But passthrough command is not
>>>>stable (i.e. valid only during first submission). We can make it stable
>>>>either by:
>>>>(a) allocating in nvme (b) return -EAGAIN to io_uring, and it 
>>>>will do allocate + deferral
>>>>Both add a cost. And since any command can potentially fail, that
>>>>means taking that cost for every IO that we issue on mpath node. Even if
>>>>no failure (initial or subsquent after IO) occcured.
>>>
>>>As mentioned, I think that if a driver consumes a command as queued,
>>>it needs a stable copy for a later reformation of the request for
>>>failover purposes.
>>
>>So what do you propose to make that stable?
>>As I mentioned earlier, stable copy requires allocating/copying in fast
>>path. And for a condition (failover) that may not even occur.
>>I really think currrent solution is much better as it does not try to make
>>it stable. Rather it assembles pieces of passthrough command if retry
>>(which is rare) happens.
>
>Well, I can understand that io_uring_cmd is space constrained, otherwise
>we wouldn't be having this discussion. 

Indeed. If we had space for keeping passthrough command stable for
retry, that would really have simplified the plumbing. Retry logic would
be same as first submission.

>However io_kiocb is less
>constrained, and could be used as a context to hold such a space.
>
>Even if it is undesired to have io_kiocb be passed to uring_cmd(), it
>can still hold a driver specific space paired with a helper to obtain it
>(i.e. something like io_uring_cmd_to_driver_ctx(ioucmd) ). Then if the
>space is pre-allocated it is only a small memory copy for a stable copy
>that would allow a saner failover design.

I am thinking along the same lines, but it's not about few bytes of
space rather we need 80 (72 to be precise). Will think more, but
these 72 bytes really stand tall in front of my optimism.

Do you see anything is possible in nvme-side?
Now also passthrough command (although in a modified form) gets copied
into this preallocated space i.e. nvme_req(req)->cmd. This part -

void nvme_init_request(struct request *req, struct nvme_command *cmd) 
{
	...
	memcpy(nvme_req(req)->cmd, cmd, sizeof(*cmd)); 
}

>>>>So to avoid commmon-path cost, we go about doing nothing (no allocation,
>>>>no deferral) in the outset and choose to recreate the passthrough
>>>>command if failure occured. Hope this explains the purpose of
>>>>nvme_uring_cmd_io_retry?
>>>
>>>I think it does, but I'm still having a hard time with it...
>>>
>>Maybe I am reiterating but few main differences that should help -
>>
>>- io_uring_cmd is at the forefront, and bio/request as secondary
>>objects. Former is persistent object across requeue attempts and the
>>only thing available when we discover the path, while other two are
>>created every time we retry.
>>
>>- Receiving bio from upper layer is a luxury that we do not have for
>>  passthrough. When we receive bio, pages are already mapped and we
>>  do not have to deal with user-specific fields, so there is more
>>  freedom in using arbitrary context (workers etc.). But passthrough
>>  command continues to point to user-space fields/buffers, so we need
>>  that task context.
>>
>>>>
>>>>>>+    req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
>>>>>>+            d.data_len, nvme_to_user_ptr(d.metadata),
>>>>>>+            d.metadata_len, 0, &meta, d.timeout_ms ?
>>>>>>+            msecs_to_jiffies(d.timeout_ms) : 0,
>>>>>>+            ioucmd->cmd_op == NVME_URING_CMD_IO_VEC, 0, 0);
>>>>>>+    if (IS_ERR(req))
>>>>>>+        return PTR_ERR(req);
>>>>>>+
>>>>>>+    req->end_io = nvme_uring_cmd_end_io;
>>>>>>+    req->end_io_data = ioucmd;
>>>>>>+    pdu->bio = req->bio;
>>>>>>+    pdu->meta = meta;
>>>>>>+    req->cmd_flags |= REQ_NVME_MPATH;
>>>>>>+    blk_execute_rq_nowait(req, false);
>>>>>>+    return -EIOCBQUEUED;
>>>>>>+}
>>>>>>+
>>>>>>+void nvme_ioucmd_mpath_retry(struct io_uring_cmd *ioucmd)
>>>>>>+{
>>>>>>+    struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
>>>>>>+    struct nvme_ns_head *head = container_of(cdev, struct 
>>>>>>nvme_ns_head,
>>>>>>+            cdev);
>>>>>>+    int srcu_idx = srcu_read_lock(&head->srcu);
>>>>>>+    struct nvme_ns *ns = nvme_find_path(head);
>>>>>>+    unsigned int issue_flags = IO_URING_F_SQE128 | IO_URING_F_CQE32 |
>>>>>>+        IO_URING_F_MPATH;
>>>>>>+    struct device *dev = &head->cdev_device;
>>>>>>+
>>>>>>+    if (likely(ns)) {
>>>>>>+        struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>>>>>>+        struct request *oreq = pdu->req;
>>>>>>+        int ret;
>>>>>>+
>>>>>>+        if (oreq == NULL) {
>>>>>>+            /*
>>>>>>+             * this was not submitted (to device) earlier. For this
>>>>>>+             * ioucmd->cmd points to persistent memory. Free that
>>>>>>+             * up post submission
>>>>>>+             */
>>>>>>+            const void *cmd = ioucmd->cmd;
>>>>>>+
>>>>>>+            ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
>>>>>>+            kfree(cmd);
>>>>>>+        } else {
>>>>>>+            /*
>>>>>>+             * this was submitted (to device) earlier. Use old
>>>>>>+             * request, bio (if it exists) and nvme-pdu to recreate
>>>>>>+             * the command for the discovered path
>>>>>>+             */
>>>>>>+            ret = nvme_uring_cmd_io_retry(ns, oreq, ioucmd, pdu);
>>>>>
>>>>>Why is this needed? Why is reuse important here? Why not always call
>>>>>nvme_ns_uring_cmd?
>>>>
>>>>Please see the previous explanation.
>>>>If condition is for the case when we made the passthrough command stable
>>>>by allocating beforehand.
>>>>Else is for the case when we avoided taking that cost.
>>>
>>>The current design of the multipath failover code is clean:
>>>1. extract bio(s) from request
>>>2. link in requeue_list
>>>3. schedule requeue_work that,
>>>3.1 takes bios 1-by-1, and submits them again (exactly the same way)
>>
>>It is really clean, and fits really well with bio based entry interface.
>>But as I said earlier, it does not go well with uring-cmd based entry
>>interface, and bunch of of other things which needs to be done
>>differently for generic passthrough command.
>>
>>>I'd like us to try to follow the same design where retry is
>>>literally "do the exact same thing, again". That would eliminate
>>>two submission paths that do the same thing, but slightly different.
>>
>>Exact same thing is possible if we make the common path slow i.e.
>>allocate/copy passthrough command and keep it alive until completion.
>>But that is really not the way to go I suppose.
>
>I'm not sure. With Christoph's response, I'm not sure it is
>universally desired to support failover (in my opinion it should). But
>if we do in fact choose to support it, I think we need a better
>solution. If fast-path allocation is your prime concern, then let's try
>to address that with space pre-allocation.

Sure. I understand the benefit that space pre-allocation will give.

And overall, these are the top three things to iron out: 
- to do (failover) or not to do
- better way to keep the passthrough-cmd stable
- better way to link io_uring_cmd

------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_85ad0_
Content-Type: text/plain; charset="utf-8"


------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_85ad0_--
