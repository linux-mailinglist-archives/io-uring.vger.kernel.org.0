Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47AAA5B1ABE
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 12:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiIHK5a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 06:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiIHK52 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 06:57:28 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD5352082
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 03:57:24 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220908105722epoutp01526275b1d2cfd5fdf5b8b17217dd8ca0~S3WX2yxWJ1118411184epoutp01e
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 10:57:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220908105722epoutp01526275b1d2cfd5fdf5b8b17217dd8ca0~S3WX2yxWJ1118411184epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662634642;
        bh=WCme1aYTyqbvRVk/gZZfUAz8p0NMlfrGWOhsd5PGpS0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I9ep2PtPr9VMH5RGKync8/6Mfx9TLO71X0dDah4nOs0R0tAHlzSUr9YkQ14dTj6Nm
         OYlq+0gwj+fhyYsHCAPmaME5dKDmYiVPNVpjigEuNlOsKbmiRNfJsUcVVl7IqD8ksV
         28RIcPYyKjlO+BjtUoWTzdWDvWoz7YVFakoB0Lno=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220908105722epcas5p313b5d287914ab898af687b0676cc5aa4~S3WXbuDDe0170001700epcas5p3-;
        Thu,  8 Sep 2022 10:57:22 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MNbg34zbqz4x9Pr; Thu,  8 Sep
        2022 10:57:19 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        80.55.59633.F8AC9136; Thu,  8 Sep 2022 19:57:19 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220908105719epcas5p3188ed6057a199556851e54aa4539ead0~S3WU_mXQf2942929429epcas5p3M;
        Thu,  8 Sep 2022 10:57:19 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220908105719epsmtrp12f20d97a8f4983aa160adffbbcbc16f6~S3WU901751413214132epsmtrp1R;
        Thu,  8 Sep 2022 10:57:19 +0000 (GMT)
X-AuditID: b6c32a49-dfdff7000000e8f1-55-6319ca8f7b34
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.F1.18644.F8AC9136; Thu,  8 Sep 2022 19:57:19 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220908105718epsmtip227b1ee1a026a0bdf6e1c6049637b7b58~S3WT4_qsn0629906299epsmtip2d;
        Thu,  8 Sep 2022 10:57:18 +0000 (GMT)
Date:   Thu, 8 Sep 2022 16:17:34 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH for-next v5 4/4] nvme: wire up fixed buffer support for
 nvme passthrough
Message-ID: <20220908104734.GA15034@test-zns>
MIME-Version: 1.0
In-Reply-To: <26490329-5b51-7334-1e2a-44edfe75d8fa@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42LZdlhTQ7f/lGSywfNVahar7/azWbw/+JjV
        YuXqo0wW71rPsVhMOnSN0WLvLW2L+cuesjuwe1w+W+qxaVUnm8fmJfUeu282sHn0Nr9j8/i8
        SS6ALSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfo
        ECWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEp
        UGFCdsaK/jesBbudK9b/Os/SwDhBu4uRk0NCwESi4eJlti5GLg4hgd2MEg9nr2SFcD4xSmx7
        vJsZwvnMKHG8cS1QGQdYy+22Uoj4LkaJjWuWQXU8Y5SY1zaZCaSIRUBFYv/COhCTTUBT4sLk
        UpBtIgJ6Eldv3WAHKWcWWMUk0dm/ix0kISwQJ3F5804wm1dAV+L0wffMELagxMmZT1hAbE4B
        O4kTFx6A2aICyhIHth1nAhkkIdDIIbH5znwmiONcJLpXx0O8Jizx6vgWdghbSuJlfxuUnSxx
        aeY5Jgi7ROLxnoNQtr1E66l+sL3MAhkSnxonQdl8Er2/n0CN55XoaBOCKFeUuDfpKSuELS7x
        cMYSKNtD4u/NOYyQIHnPKHH/9if2CYxys5C8MwvJCgjbSqLzQxPrLKAVzALSEsv/cUCYmhLr
        d+kvYGRdxSiZWlCcm55abFpgmJdaDo/i5PzcTYzglKnluYPx7oMPeocYmTgYDzFKcDArifCK
        rpVIFuJNSaysSi3Kjy8qzUktPsRoCoydicxSosn5wKSdVxJvaGJpYGJmZmZiaWxmqCTOO0Wb
        MVlIID2xJDU7NbUgtQimj4mDU6qBKfmdU+mGL+1i85kll2kvWvNlXXfMlD89qj4r2e9Ma/dI
        KEoMn7Z7jvo+FuPErnUnJx/+v9RzV/wvQwXNG0v4bpdNeLehhGGr5z6VoE1St9oFfzJ+PzlT
        Pvj2+u1xJ74LxB8SnH8t8ckZs3edvMsMHuxZ2Ft54tj64OvKTmtmRzefEv9tGamg/f1NjKn4
        xdsMzOsbl/uu26p/cKJrIStTSHfXUoabKh4WUR5Tt63a8aJhq/rxIIcfE87Gcy6eeSU7vZI1
        /6bpKzZW5tXC0b/sOhTrg99whsh/Y+6TOvC+IOLh05pvRzfddZzlo7/fgsf2Gtf6S+p7p3QG
        3/yS6mYvlmzSt/VW895g42P7wrdEPFBiKc5INNRiLipOBADN4K45IgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWy7bCSvG7/Kclkg3OrBCxW3+1ns3h/8DGr
        xcrVR5ks3rWeY7GYdOgao8XeW9oW85c9ZXdg97h8ttRj06pONo/NS+o9dt9sYPPobX7H5vF5
        k1wAWxSXTUpqTmZZapG+XQJXxsK1+9gK3jpUHNp/lrmB8Y5GFyMHh4SAicTtttIuRi4OIYEd
        jBIvjvxg6WLkBIqLSzRf+8EOYQtLrPz3nB2i6AmjxPwjHUwgzSwCKhL7F9aBmGwCmhIXJpeC
        lIsI6ElcvXUDrJxZYBWTxPqFjWBzhAXiJC5v3glm8wroSpw++J4ZYuZ7RomJXzezQCQEJU7O
        fAJmMwuYSczb/JAZZAGzgLTE8n8cIGFOATuJExcegJWICihLHNh2nGkCo+AsJN2zkHTPQuhe
        wMi8ilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOAq0tHYw7ln1Qe8QIxMH4yFGCQ5m
        JRFe0bUSyUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUw
        yXqs9ZKrrDm2r+nX5ic7uR8/dGfP38bC7h9m+MC1d5vbH8Gn7SvmXXwzt8J35317lqpZT/WU
        zkts4jM5+fBl0jFHj51fky/FBnFoSq7gtLFQNmTyi/i63SZN6afqqTON2ib9exelP/y+6ZjZ
        z7Z/nzYe8rJK/rxolV/98hsP3ZnStjI06NzfV8C1cG64SY2b01Wfcw//nYg8t+gk+ye/qm+X
        rp9bt5kv1fb0hb2RjybPnRPnbDJBv7SxXeCWgt2isNMS/GKhed/v8FlpB585/ODYwm9cax/t
        /V8WezBbgMOq88VMxnuSFb2qFy4IKXzSv2bR6CrUHMQien0z58e//cVf4iYfz5yyjJlfM+3A
        FCWW4oxEQy3mouJEAGxmMO7xAgAA
X-CMS-MailID: 20220908105719epcas5p3188ed6057a199556851e54aa4539ead0
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_f071b_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220906063733epcas5p22984174bd6dbb2571152fea18af90924
References: <20220906062721.62630-1-joshi.k@samsung.com>
        <CGME20220906063733epcas5p22984174bd6dbb2571152fea18af90924@epcas5p2.samsung.com>
        <20220906062721.62630-5-joshi.k@samsung.com>
        <26490329-5b51-7334-1e2a-44edfe75d8fa@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_f071b_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Wed, Sep 07, 2022 at 02:51:31PM +0000, Chaitanya Kulkarni wrote:
>
>>   	req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
>> -			meta_len, meta_seed, &meta, timeout, vec, 0, 0);
>> +			meta_len, meta_seed, &meta, timeout, vec, 0, 0, NULL, 0);
>>   	if (IS_ERR(req))
>>   		return PTR_ERR(req);
>
>14 Arguments to the function!
>
>Kanchan, I'm not pointing out to this patch it has happened over
>the years, I think it is high time we find a way to trim this
>down.
>
>Least we can do is to pass a structure member than 14 different
>arguments, is everyone okay with it ?
>
Maybe it's just me, but there is something (unrelatedness) about these
fields which makes packing all these into a single container feel bit 
unnatural (or do you already have a good name for such struct?). 

So how about we split the nvme_alloc_user_request into two.
That will also serve the purpose. 
Here is a patch that creates
- new nvme_alloc_user_request with 5 parameters
- new nvme_map_user_request with 8 parameters


diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 548aca8b5b9f..cb2fa4db50dd 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -65,18 +65,10 @@ static int nvme_finish_user_metadata(struct request *req, void __user *ubuf,
 }

 static struct request *nvme_alloc_user_request(struct request_queue *q,
-               struct nvme_command *cmd, void __user *ubuffer,
-               unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-               u32 meta_seed, void **metap, unsigned timeout, bool vec,
+               struct nvme_command *cmd, unsigned timeout,
                blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags)
 {
-       bool write = nvme_is_write(cmd);
-       struct nvme_ns *ns = q->queuedata;
-       struct block_device *bdev = ns ? ns->disk->part0 : NULL;
        struct request *req;
-       struct bio *bio = NULL;
-       void *meta = NULL;
-       int ret;

        req = blk_mq_alloc_request(q, nvme_req_op(cmd) | rq_flags, blk_flags);
        if (IS_ERR(req))
@@ -86,49 +78,61 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
        if (timeout)
                req->timeout = timeout;
        nvme_req(req)->flags |= NVME_REQ_USERCMD;
+       return req;
+}

-       if (ubuffer && bufflen) {
-               if (!vec)
-                       ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
-                               GFP_KERNEL);
-               else {
-                       struct iovec fast_iov[UIO_FASTIOV];
-                       struct iovec *iov = fast_iov;
-                       struct iov_iter iter;
-
-                       ret = import_iovec(rq_data_dir(req), ubuffer, bufflen,
-                                       UIO_FASTIOV, &iov, &iter);
-                       if (ret < 0)
-                               goto out;
-                       ret = blk_rq_map_user_iov(q, req, NULL, &iter,
-                                       GFP_KERNEL);
-                       kfree(iov);
-               }
-               if (ret)
+static int nvme_map_user_request(struct request *req, void __user *ubuffer,
+               unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
+               u32 meta_seed, void **metap, bool vec)
+{
+       struct request_queue *q = req->q;
+       struct nvme_ns *ns = q->queuedata;
+       struct block_device *bdev = ns ? ns->disk->part0 : NULL;
+       struct bio *bio = NULL;
+       void *meta = NULL;
+       int ret;
+
+       if (!ubuffer || !bufflen)
+               return 0;
+
+       if (!vec)
+               ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
+                       GFP_KERNEL);
+       else {
+               struct iovec fast_iov[UIO_FASTIOV];
+               struct iovec *iov = fast_iov;
+               struct iov_iter iter;
+
+               ret = import_iovec(rq_data_dir(req), ubuffer, bufflen,
+                               UIO_FASTIOV, &iov, &iter);
+               if (ret < 0)
                        goto out;
-               bio = req->bio;
-               if (bdev)
-                       bio_set_dev(bio, bdev);
-               if (bdev && meta_buffer && meta_len) {
-                       meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
-                                       meta_seed, write);
-                       if (IS_ERR(meta)) {
-                               ret = PTR_ERR(meta);
-                               goto out_unmap;
-                       }
-                       req->cmd_flags |= REQ_INTEGRITY;
-                       *metap = meta;
+               ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
+               kfree(iov);
+       }
+       bio = req->bio;
+       if (ret)
+               goto out_unmap;
+       if (bdev)
+               bio_set_dev(bio, bdev);
+       if (bdev && meta_buffer && meta_len) {
+               meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
+                               meta_seed, req_op(req) == REQ_OP_DRV_OUT);
+               if (IS_ERR(meta)) {
+                       ret = PTR_ERR(meta);
+                       goto out_unmap;
                }
+               req->cmd_flags |= REQ_INTEGRITY;
+               *metap = meta;
        }

-       return req;
+       return ret;

 out_unmap:
        if (bio)
                blk_rq_unmap_user(bio);
 out:
-       blk_mq_free_request(req);
-       return ERR_PTR(ret);
+       return ret;
 }

 static int nvme_submit_user_cmd(struct request_queue *q,
@@ -141,13 +145,16 @@ static int nvme_submit_user_cmd(struct request_queue *q,
        struct bio *bio;
        int ret;

-       req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
-                       meta_len, meta_seed, &meta, timeout, vec, 0, 0);
+       req = nvme_alloc_user_request(q, cmd, timeout, 0, 0);
        if (IS_ERR(req))
                return PTR_ERR(req);

-       bio = req->bio;
+       ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
+                       meta_len, meta_seed, &meta, vec);
+       if (ret)
+               goto out;

+       bio = req->bio;
        ret = nvme_execute_passthru_rq(req);

        if (result)
@@ -157,6 +164,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
                                                meta_len, ret);
        if (bio)
                blk_rq_unmap_user(bio);
+out:
        blk_mq_free_request(req);
        return ret;
 }
@@ -418,6 +426,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
        blk_opf_t rq_flags = 0;
        blk_mq_req_flags_t blk_flags = 0;
        void *meta = NULL;
+       int ret;

        if (!capable(CAP_SYS_ADMIN))
                return -EACCES;
@@ -457,13 +466,17 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
                rq_flags |= REQ_POLLED;

 retry:
-       req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
-                       d.data_len, nvme_to_user_ptr(d.metadata),
-                       d.metadata_len, 0, &meta, d.timeout_ms ?
-                       msecs_to_jiffies(d.timeout_ms) : 0, vec, rq_flags,
-                       blk_flags);
+       req = nvme_alloc_user_request(q, &c,
+                       d.timeout_ms ? msecs_to_jiffies(d.timeout_ms) : 0,
+                       rq_flags, blk_flags);
        if (IS_ERR(req))
                return PTR_ERR(req);
+
+       ret = nvme_map_user_request(req, nvme_to_user_ptr(d.addr),
+                       d.data_len, nvme_to_user_ptr(d.metadata),
+                       d.metadata_len, 0, &meta, vec);
+       if (ret)
+               goto out_err;
        req->end_io = nvme_uring_cmd_end_io;
        req->end_io_data = ioucmd;

@@ -486,6 +499,9 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,

        blk_execute_rq_nowait(req, false);
        return -EIOCBQUEUED;
+out_err:
+       blk_mq_free_request(req);
+       return ret;
 }

 static bool is_ctrl_ioctl(unsigned int cmd)


------3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_f071b_
Content-Type: text/plain; charset="utf-8"


------3GC0G0c67CHFz-pUzO9qV37oeXJmKwYP9xQRy1YHFCjbzJ45=_f071b_--
