Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E25B571172
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 06:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiGLE3I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jul 2022 00:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiGLE3G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jul 2022 00:29:06 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59CD201BB
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 21:29:03 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220712042900epoutp03aa273831aa4b3b7f26f28829ffcc533b~A_ou-pzcI0701307013epoutp03b
        for <io-uring@vger.kernel.org>; Tue, 12 Jul 2022 04:29:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220712042900epoutp03aa273831aa4b3b7f26f28829ffcc533b~A_ou-pzcI0701307013epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657600141;
        bh=5z2gX6y0myCBh6ZuMjAWANk6nPcosCHwF9rl1LdxhR0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o3VPf8UfCmLYuTPymMYF0evgKqnQdTrCMFY+SCKWqslEoB0hnZOp6OkgrkDnQOmsP
         ELgFlSBvvtW3zNqqxpv8c5NaAmtd+7BkK9+XGbPmj2Agskceg6JEeu6wFbcRcWABaZ
         Z3CSz4XaQ/FaK0HHFwpOsOK1oJBibwl18L6SYLWU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220712042900epcas5p23b4e425afe9d719cae809e653ea86090~A_ouh8hWr0121601216epcas5p2D;
        Tue, 12 Jul 2022 04:29:00 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Lhnnj5dNNz4x9Q9; Tue, 12 Jul
        2022 04:28:57 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DC.31.09662.988FCC26; Tue, 12 Jul 2022 13:28:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220712042856epcas5p3bccafa2a81b82e0f301c043079c0de4d~A_orDuq4J0146301463epcas5p3L;
        Tue, 12 Jul 2022 04:28:56 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220712042856epsmtrp2ec5999b058994aeddca0b6312fa86b1a~A_orCyZPk2461724617epsmtrp2W;
        Tue, 12 Jul 2022 04:28:56 +0000 (GMT)
X-AuditID: b6c32a49-86fff700000025be-f2-62ccf8894d47
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DA.50.08905.888FCC26; Tue, 12 Jul 2022 13:28:56 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220712042855epsmtip175f8710d6acbfaf45431f39677403913~A_ope5uFg2127421274epsmtip1E;
        Tue, 12 Jul 2022 04:28:54 +0000 (GMT)
Date:   Tue, 12 Jul 2022 09:53:32 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     hch@lst.de, kbusch@kernel.org, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Message-ID: <20220712042332.GA14780@test-zns>
MIME-Version: 1.0
In-Reply-To: <5f30c7de-03b1-768a-d44f-594ed2d1dc75@grimberg.me>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGJsWRmVeSWpSXmKPExsWy7bCmlm7njzNJBrd2aVs0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLM6/PcxkMenQNUaLvbe0LeYve8puse71exYHbo+ds+6y
        e5y/t5HF4/LZUo9NqzrZPDYvqffYfbOBzaNvyypGj8+b5AI4orJtMlITU1KLFFLzkvNTMvPS
        bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DOVFIoS8wpBQoFJBYXK+nb2RTll5ak
        KmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ2xbdJa5YG52ReuSWywNjHej
        uhg5OSQETCSuTH7G0sXIxSEksJtR4umdl0wgCSGBT4wSB19UQyS+MUpM7toMVMUB1rHukQBE
        fC+jxPtlB5lB4kICzxgljmqDmCwCqhIvntWBmGwCmhIXJpeCmCICKhJv3uSCNDILvGCUWDhv
        ISvIJmGBZIlNTyaBbeUV0JX43HOCHcIWlDg58wkLiM0pYC/x5NU3sLiogLLEgW3HmUAGSQgc
        4JB4eXsuI8QvLhKNk/ayQdjCEq+Ob2GHsKUkPr+DiSdLXJp5jgnCLpF4vOcglG0v0XqqnxnE
        ZhbIlDg67zIrhM0n0fv7CRPE57wSHW1CEOWKEvcmPWWFsMUlHs5YAmV7SHyc38wOCZ3TTBI/
        fvSyTWCUm4Xkn1lIVkDYVhKdH5qgbHmJ5q2zmWcBrWMWkJZY/o8DwtSUWL9LfwEj2ypGydSC
        4tz01GLTAsO81HJ4XCfn525iBCdgLc8djHcffNA7xMjEwXiIUYKDWUmE98/ZU0lCvCmJlVWp
        RfnxRaU5qcWHGE2BMTWRWUo0OR+YA/JK4g1NLA1MzMzMTCyNzQyVxHm9rm5KEhJITyxJzU5N
        LUgtgulj4uCUamASS+DJSnhfelog+tP2iN6d36decFR7llx0b+3X4F+sAqUTW3Or333RmFfN
        Ub8ueMvPQ7r35/9p2+5yJiE60oT/1d38dsvdXnPE+RxdXVZ+nvtm8w6+4vD7LdK/7WOvbPz5
        4fgekSVloQeU53GdKP7ueCXmheHsTRs9/j55cu55atl55zDOU5Vezit1vx5ePLncrqYzZvOp
        RLtn3R32nCEvWg59XSnO0BHDcnXLQ6lbzAfV037x9ok8LHhS4V/ln/O+z6NuSzJzSbe5U+H8
        y484fUJ5378QMavd2/laVaNFZ5/i5Ak7LDNl7536s2HZnNlzJj/fE/IwQybGp3P71n7P+oNX
        Kh8pxWbGSyZ4eHErsRRnJBpqMRcVJwIAvA7/dkkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSnG7HjzNJBmvfa1g0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLM6/PcxkMenQNUaLvbe0LeYve8puse71exYHbo+ds+6y
        e5y/t5HF4/LZUo9NqzrZPDYvqffYfbOBzaNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyXr5f
        xFqwOqPi4dybrA2MHRFdjBwcEgImEuseCXQxcnEICexmlNh06idjFyMnUFxcovnaD3YIW1hi
        5b/n7BBFTxgluo59YwdpZhFQlXjxrA7EZBPQlLgwuRTEFBFQkXjzJhekmlngBaPExStbWEDG
        CAskS2x6MokJxOYV0JX43HMCauRpJonmXSdZIRKCEidnPgFrYBYwk5i3+SEzyFBmAWmJ5f84
        IMLyEs1bZzOD2JwC9hJPXn0DO1NUQFniwLbjTBMYhWYhmTQLyaRZCJNmIZm0gJFlFaNkakFx
        bnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcLxpae5g3L7qg94hRiYOxkOMEhzMSiK8f86eShLi
        TUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qBSW7ft4BEbj0B
        BQmdmuMhR9N+Wdpu2M30cnHb92MeR3d/ufN2bR6rZbYv5+29dv99oqxXTNr20SHBLe1f8aWY
        FNs/IfL/du5zvNItKF33pvnNh/J/Hu5mryZpCQkp+ExrvV2m+8nBLOFlr8imY0mTmXrvcbBL
        CFmZVHDlKVnPM/ZcV8+/UdryVmOj45rH9d1c8Z6sy+vzC1786T7g949Z/9j1Dwt+qS9OTNzg
        tlbW6ynjijKxWBbP0sZAg2dSr6dsX3yp5sqcZamzD4aWTvxXnfu04UR7JGdDVEzCla/iAcWp
        nx4/P79/0zXeyo3f7qTrBNc++76q59POexKbTrOG6zbl5J21spyoFWHrUWejxFKckWioxVxU
        nAgAUCcT8CYDAAA=
X-CMS-MailID: 20220712042856epcas5p3bccafa2a81b82e0f301c043079c0de4d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----fdgKPeBBSv2AmZNwmNmcr-uT4EHTSQ452lPRzqrrVt0epNMO=_11ed62_"
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
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------fdgKPeBBSv2AmZNwmNmcr-uT4EHTSQ452lPRzqrrVt0epNMO=_11ed62_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Mon, Jul 11, 2022 at 10:56:56PM +0300, Sagi Grimberg wrote:
>
>>>>@@ -448,6 +442,14 @@ static int nvme_uring_cmd_io(struct 
>>>>nvme_ctrl *ctrl, struct nvme_ns *ns,
>>>>     pdu->meta_buffer = nvme_to_user_ptr(d.metadata);
>>>>     pdu->meta_len = d.metadata_len;
>>>>+    if (issue_flags & IO_URING_F_MPATH) {
>>>>+        req->cmd_flags |= REQ_NVME_MPATH;
>>>>+        /*
>>>>+         * we would need the buffer address (d.addr field) if we have
>>>>+         * to retry the command. Store it by repurposing ioucmd->cmd
>>>>+         */
>>>>+        ioucmd->cmd = (void *)d.addr;
>>>
>>>What does repurposing mean here?
>>
>>This field (ioucmd->cmd) was pointing to passthrough command (which
>>is embedded in SQE of io_uring). At this point we have consumed
>>passthrough command, so this field can be reused if we have to. And we
>>have to beceause failover needs recreating passthrough command.
>>Please see nvme_uring_cmd_io_retry to see how this helps in recreating
>>the fields of passthrough command. And more on this below.
>
>so ioucmd->cmd starts as an nvme_uring_cmd pointer and continues as
>an address of buffer for a later processing that may or may not
>happen in its lifetime?

Yes. See this as a no-cost way to handle fast/common path. We manage by
doing just this assignment.
Otherwise this would have involved doing high-cost (allocate/copy/deferral)
stuff for later processing that may or may not happen.

>Sounds a bit of a backwards design to me.
>
>>>>+    }
>>>>     blk_execute_rq_nowait(req, false);
>>>>     return -EIOCBQUEUED;
>>>> }
>>>>@@ -665,12 +667,135 @@ int nvme_ns_head_chr_uring_cmd(struct 
>>>>io_uring_cmd *ioucmd,
>>>>     int srcu_idx = srcu_read_lock(&head->srcu);
>>>>     struct nvme_ns *ns = nvme_find_path(head);
>>>>     int ret = -EINVAL;
>>>>+    struct device *dev = &head->cdev_device;
>>>>+
>>>>+    if (likely(ns)) {
>>>>+        ret = nvme_ns_uring_cmd(ns, ioucmd,
>>>>+                issue_flags | IO_URING_F_MPATH);
>>>>+    } else if (nvme_available_path(head)) {
>>>>+        struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>>>>+        struct nvme_uring_cmd *payload = NULL;
>>>>+
>>>>+        dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
>>>>+        /*
>>>>+         * We may requeue two kinds of uring commands:
>>>>+         * 1. command failed post submission. pdu->req will be non-null
>>>>+         * for this
>>>>+         * 2. command that could not be submitted because path was not
>>>>+         * available. For this pdu->req is set to NULL.
>>>>+         */
>>>>+        pdu->req = NULL;
>>>
>>>Relying on a pointer does not sound like a good idea to me.
>>>But why do you care at all where did this command came from?
>>>This code should not concern itself what happened prior to this
>>>execution.
>>Required, please see nvme_uring_cmd_io_retry. And this should be more
>>clear as part of responses to your other questions.
>
>I think I understand. But it looks fragile to me.
>
>>
>>>>+        /*
>>>>+         * passthrough command will not be available during retry as it
>>>>+         * is embedded in io_uring's SQE. Hence we allocate/copy here
>>>>+         */
>>>
>>>OK, that is a nice solution.
>>Please note that prefered way is to recreate the passthrough command,
>>and not to allocate it. We allocate it here because this happens very early
>>(i.e. before processing passthrough command and setting that up inside
>>struct request). Recreating requires a populated 'struct request' .
>
>I think that once a driver consumes a command as queued, it needs a
>stable copy of the command (could be in a percpu pool).
>
>The current design of nvme multipathing is that the request is stripped
>from its bios and placed on a requeue_list, and if a request was not
>formed yet (i.e. nvme available path exist but no usable) the bio is
>placed on the requeue_list.
>
>So ideally we have something sufficient like a bio, that can be linked
>on a requeue list, and is sufficient to build a request, at any point in
>time...

we could be dealing with any passthrough command here. bio is not
guranteed to exist in first place. It can very well be NULL.
As I mentioned in cover letter, this was tested for such passthrough
commands too.
And bio is not a good fit for this interface. For block-path, entry
function is nvme_ns_head_submit_bio() which speaks bio. Request is
allocated afterwards. But since request formation can happen only after
discovering a valid path, it may have to queue the bio if path does not
exist.
For passthrough, interface speaks/understands struct io_uring_cmd.
Request is allocated after. And bio may (or may not) be attached with
this request. It may have to queue the command even before request/bio
gets formed. So cardinal structure (which is
really available all the time) in this case is struct io_uring_cmd.
Hence we use that as the object around which requeuing/failover is
built.
Conceptually io_uring_cmd is the bio of this interface.

>>>>+        payload = kmalloc(sizeof(struct nvme_uring_cmd), GFP_KERNEL);
>>>>+        if (!payload) {
>>>>+            ret = -ENOMEM;
>>>>+            goto out_unlock;
>>>>+        }
>>>>+        memcpy(payload, ioucmd->cmd, sizeof(struct nvme_uring_cmd));
>>>>+        ioucmd->cmd = payload;
>>>>-    if (ns)
>>>>-        ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
>>>>+        spin_lock_irq(&head->requeue_ioucmd_lock);
>>>>+        ioucmd_list_add(&head->requeue_ioucmd_list, ioucmd);
>>>>+        spin_unlock_irq(&head->requeue_ioucmd_lock);
>>>>+        ret = -EIOCBQUEUED;
>>>>+    } else {
>>>>+        dev_warn_ratelimited(dev, "no available path - failing I/O\n");
>>>
>>>ret=-EIO ?
>>Did not do as it was initialized to -EINVAL. Do you prefer -EIO instead.
>
>It is not an invalid argument error here, it is essentially an IO error.
>So yes, that would be my preference.

sure, will change.

>>>>+    }
>>>>+out_unlock:
>>>>     srcu_read_unlock(&head->srcu, srcu_idx);
>>>>     return ret;
>>>> }
>>>>+
>>>>+int nvme_uring_cmd_io_retry(struct nvme_ns *ns, struct request *oreq,
>>>>+        struct io_uring_cmd *ioucmd, struct nvme_uring_cmd_pdu *pdu)
>>>>+{
>>>>+    struct nvme_ctrl *ctrl = ns->ctrl;
>>>>+    struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
>>>>+    struct nvme_uring_data d;
>>>>+    struct nvme_command c;
>>>>+    struct request *req;
>>>>+    struct bio *obio = oreq->bio;
>>>>+    void *meta = NULL;
>>>>+
>>>>+    memcpy(&c, nvme_req(oreq)->cmd, sizeof(struct nvme_command));
>>>>+    d.metadata = (__u64)pdu->meta_buffer;
>>>>+    d.metadata_len = pdu->meta_len;
>>>>+    d.timeout_ms = oreq->timeout;
>>>>+    d.addr = (__u64)ioucmd->cmd;
>>>>+    if (obio) {
>>>>+        d.data_len = obio->bi_iter.bi_size;
>>>>+        blk_rq_unmap_user(obio);
>>>>+    } else {
>>>>+        d.data_len = 0;
>>>>+    }
>>>>+    blk_mq_free_request(oreq);
>>>
>>>The way I would do this that in nvme_ioucmd_failover_req (or in the
>>>retry driven from command retriable failure) I would do the above,
>>>requeue it and kick the requeue work, to go over the requeue_list and
>>>just execute them again. Not sure why you even need an explicit retry
>>>code.
>>During retry we need passthrough command. But passthrough command is not
>>stable (i.e. valid only during first submission). We can make it stable
>>either by:
>>(a) allocating in nvme (b) return -EAGAIN to io_uring, and it will 
>>do allocate + deferral
>>Both add a cost. And since any command can potentially fail, that
>>means taking that cost for every IO that we issue on mpath node. Even if
>>no failure (initial or subsquent after IO) occcured.
>
>As mentioned, I think that if a driver consumes a command as queued,
>it needs a stable copy for a later reformation of the request for
>failover purposes.

So what do you propose to make that stable?
As I mentioned earlier, stable copy requires allocating/copying in fast
path. And for a condition (failover) that may not even occur.
I really think currrent solution is much better as it does not try to make
it stable. Rather it assembles pieces of passthrough command if retry
(which is rare) happens.

>>So to avoid commmon-path cost, we go about doing nothing (no allocation,
>>no deferral) in the outset and choose to recreate the passthrough
>>command if failure occured. Hope this explains the purpose of
>>nvme_uring_cmd_io_retry?
>
>I think it does, but I'm still having a hard time with it...
>
Maybe I am reiterating but few main differences that should help -

- io_uring_cmd is at the forefront, and bio/request as secondary
objects. Former is persistent object across requeue attempts and the
only thing available when we discover the path, while other two are
created every time we retry.

- Receiving bio from upper layer is a luxury that we do not have for
  passthrough. When we receive bio, pages are already mapped and we
  do not have to deal with user-specific fields, so there is more
  freedom in using arbitrary context (workers etc.). But passthrough
  command continues to point to user-space fields/buffers, so we need
  that task context.

>>
>>>>+    req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
>>>>+            d.data_len, nvme_to_user_ptr(d.metadata),
>>>>+            d.metadata_len, 0, &meta, d.timeout_ms ?
>>>>+            msecs_to_jiffies(d.timeout_ms) : 0,
>>>>+            ioucmd->cmd_op == NVME_URING_CMD_IO_VEC, 0, 0);
>>>>+    if (IS_ERR(req))
>>>>+        return PTR_ERR(req);
>>>>+
>>>>+    req->end_io = nvme_uring_cmd_end_io;
>>>>+    req->end_io_data = ioucmd;
>>>>+    pdu->bio = req->bio;
>>>>+    pdu->meta = meta;
>>>>+    req->cmd_flags |= REQ_NVME_MPATH;
>>>>+    blk_execute_rq_nowait(req, false);
>>>>+    return -EIOCBQUEUED;
>>>>+}
>>>>+
>>>>+void nvme_ioucmd_mpath_retry(struct io_uring_cmd *ioucmd)
>>>>+{
>>>>+    struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
>>>>+    struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head,
>>>>+            cdev);
>>>>+    int srcu_idx = srcu_read_lock(&head->srcu);
>>>>+    struct nvme_ns *ns = nvme_find_path(head);
>>>>+    unsigned int issue_flags = IO_URING_F_SQE128 | IO_URING_F_CQE32 |
>>>>+        IO_URING_F_MPATH;
>>>>+    struct device *dev = &head->cdev_device;
>>>>+
>>>>+    if (likely(ns)) {
>>>>+        struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>>>>+        struct request *oreq = pdu->req;
>>>>+        int ret;
>>>>+
>>>>+        if (oreq == NULL) {
>>>>+            /*
>>>>+             * this was not submitted (to device) earlier. For this
>>>>+             * ioucmd->cmd points to persistent memory. Free that
>>>>+             * up post submission
>>>>+             */
>>>>+            const void *cmd = ioucmd->cmd;
>>>>+
>>>>+            ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
>>>>+            kfree(cmd);
>>>>+        } else {
>>>>+            /*
>>>>+             * this was submitted (to device) earlier. Use old
>>>>+             * request, bio (if it exists) and nvme-pdu to recreate
>>>>+             * the command for the discovered path
>>>>+             */
>>>>+            ret = nvme_uring_cmd_io_retry(ns, oreq, ioucmd, pdu);
>>>
>>>Why is this needed? Why is reuse important here? Why not always call
>>>nvme_ns_uring_cmd?
>>
>>Please see the previous explanation.
>>If condition is for the case when we made the passthrough command stable
>>by allocating beforehand.
>>Else is for the case when we avoided taking that cost.
>
>The current design of the multipath failover code is clean:
>1. extract bio(s) from request
>2. link in requeue_list
>3. schedule requeue_work that,
> 3.1 takes bios 1-by-1, and submits them again (exactly the same way)

It is really clean, and fits really well with bio based entry interface.
But as I said earlier, it does not go well with uring-cmd based entry
interface, and bunch of of other things which needs to be done
differently for generic passthrough command.

>I'd like us to try to follow the same design where retry is
>literally "do the exact same thing, again". That would eliminate
>two submission paths that do the same thing, but slightly different.

Exact same thing is possible if we make the common path slow i.e.
allocate/copy passthrough command and keep it alive until completion.
But that is really not the way to go I suppose.


------fdgKPeBBSv2AmZNwmNmcr-uT4EHTSQ452lPRzqrrVt0epNMO=_11ed62_
Content-Type: text/plain; charset="utf-8"


------fdgKPeBBSv2AmZNwmNmcr-uT4EHTSQ452lPRzqrrVt0epNMO=_11ed62_--
