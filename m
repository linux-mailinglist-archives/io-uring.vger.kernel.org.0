Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46764F5B4B
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 12:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiDFKUk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 06:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377603AbiDFKSo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 06:18:44 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D455B189B
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 23:45:55 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220406064549epoutp0199c0e5878b1e815bc50513c5ccaf6bed~jO7f7sIKV2001720017epoutp01B
        for <io-uring@vger.kernel.org>; Wed,  6 Apr 2022 06:45:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220406064549epoutp0199c0e5878b1e815bc50513c5ccaf6bed~jO7f7sIKV2001720017epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1649227549;
        bh=9ZGC5nPz4vs36wkDfHq/2KkGNRaEd3dASQtum6t0mzc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FmJ2PAZzE1O/wojPRTQemhlOgSHoM3jHgsu87Fq63XyvcjDcifEHbr2JdRv7tPY6S
         l6Ln+O9+dX3yvRQOHpBO+VtiqtPg+0HrLcnheQJsk6JwA0wqzUrmrCXRpxSCxkVwhW
         3dRzB9qCGhBuXU4npge4rqlh4q3gT4U4jAmXqAPs=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220406064549epcas5p3af7c870adbbe012a599438bf70a60e75~jO7fa8hcP0942609426epcas5p3U;
        Wed,  6 Apr 2022 06:45:49 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KYFQJ6mHKz4x9Qh; Wed,  6 Apr
        2022 06:45:44 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7A.9F.09952.F073D426; Wed,  6 Apr 2022 15:45:35 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220406064209epcas5p19d8d0c5fb4609e7252bd04beb1974d10~jO4S-XYxP0113001130epcas5p1U;
        Wed,  6 Apr 2022 06:42:09 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220406064209epsmtrp1dc3fe9eb85674803d0a55edd1413b14c~jO4S_k8o32449224492epsmtrp1a;
        Wed,  6 Apr 2022 06:42:09 +0000 (GMT)
X-AuditID: b6c32a4b-4cbff700000226e0-79-624d370ffa82
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2B.DF.03370.1463D426; Wed,  6 Apr 2022 15:42:09 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220406064207epsmtip2d12e289d43ee3fe802bff6688dc4abfa~jO4RBcrpo0937509375epsmtip2G;
        Wed,  6 Apr 2022 06:42:07 +0000 (GMT)
Date:   Wed, 6 Apr 2022 12:07:03 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        ming.lei@redhat.com, mcgrof@kernel.org, pankydev8@gmail.com,
        javier@javigon.com, joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [RFC 3/5] io_uring: add infra and support for
 IORING_OP_URING_CMD
Message-ID: <20220406063703.GA24055@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220405055835.GC23698@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmui6/uW+SwYmFxhZNE/4yW8xZtY3R
        YvXdfjaLlauPMlm8az3HYtF5+gKTxfm3h5ks5i97ym5xY8JTRotDk5uZLNbcfMriwO2xc9Zd
        do/mBXdYPC6fLfXYtKqTzWPzknqP3Tcb2Dze77vK5tG3ZRWjx+dNcgGcUdk2GamJKalFCql5
        yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDHKimUJeaUAoUCEouLlfTt
        bIryS0tSFTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM07syCo4b1DR/3gl
        awPjdaUuRk4OCQETiW9P/7N2MXJxCAnsZpT4vng1lPOJUWLby43sEM5nRommdRMZYVo6/v5l
        hEjsYpT4fPMlVNUzRon9006BVbEIqEh8aj/C0sXIwcEmoClxYXIpSFhEQEni6auzYM3MAj8Y
        JfbNOgFWLywQIPGq9SwLiM0roCux9shRKFtQ4uTMJ2A2p4COxLVlLewgtqiAssSBbceZQAZJ
        CJzhkHiw4QYLxHkuErsaPzFB2MISr45vYYewpSRe9rdB2ckSrdsvs4McJyFQIrFkgTpE2F7i
        4p6/TCBhZoEMiRsT3SHCshJTT60Dm8gswCfR+/sJ1HReiR3zYGxFiXuTnrJC2OISD2csgbI9
        JCauvc0CCZ8NTBLbJp5mm8AoPwvJa7MQ1s0CW2El0fmhiRXClpdo3jqbGaJEWmL5Pw4IU1Ni
        /S79BYxsqxglUwuKc9NTi00LjPNSy+FRn5yfu4kRnKq1vHcwPnrwQe8QIxMH4yFGCQ5mJRHe
        qlyfJCHelMTKqtSi/Pii0pzU4kOMpsBYm8gsJZqcD8wWeSXxhiaWBiZmZmYmlsZmhkrivKfS
        NyQKCaQnlqRmp6YWpBbB9DFxcEo1MHn+lmBI0w3N/Hsqx8XozT7pF/Zq4vwmDRoh9+2uK6l1
        8msY2EgLs+00UPs6xfTcafvVm15ni4q/Kpsjnfl2p81y2eYVe1Xkf5vfs/m1VTC5aF337AiN
        z/efx3zp+N102CNIPeHWcYMF/rmzr/CKmvMf3GJxf2Fh10yh4uCpa2+Y5SRuctjItqapIHPu
        hskhl9PYswrc/y8rPxr86uWC+yt7pze8a5TLPivZdOMPT8nHmP3nmteGvr31sSyqxf7NU/mk
        0PdOrVHz3BOWPGGR+7sxsHLbLXEu1xemCwweTS/5U7XW7lVtvdxdU8uVmX2HfP8sqZH8Nl/G
        7WmVUtC363P8uYNf7z+n8VKte1bOWyWW4oxEQy3mouJEADs+p9BeBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWy7bCSvK6jmW+SwfbphhZNE/4yW8xZtY3R
        YvXdfjaLlauPMlm8az3HYtF5+gKTxfm3h5ks5i97ym5xY8JTRotDk5uZLNbcfMriwO2xc9Zd
        do/mBXdYPC6fLfXYtKqTzWPzknqP3Tcb2Dze77vK5tG3ZRWjx+dNcgGcUVw2Kak5mWWpRfp2
        CVwZ0y6fYiy4p1vRt7KLtYGxVaGLkZNDQsBEouPvX8YuRi4OIYEdjBLXnzQwQyTEJZqv/WCH
        sIUlVv57zg5R9IRR4nvfbiaQBIuAisSn9iMsXYwcHGwCmhIXJpeChEUElCSevjoLNpRZ4Aej
        xL5ZJxhBEsICfhL7pt9lBbF5BXQl1h45ygJiCwlsYpLo/68GEReUODnzCVicWcBMYt7mh8wg
        85kFpCWW/+OACMtLNG+dDXYnp4COxLVlLWB3igooSxzYdpxpAqPQLCSTZiGZNAth0iwkkxYw
        sqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAiOPy2tHYx7Vn3QO8TIxMF4iFGCg1lJ
        hLcq1ydJiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqYJ
        Rzcl6rOvT4i8Nlny48OsT1HLTYu9fU1f2r3SPRUa2Zpwvy1KIv7UQpsHn7acOKk7ZfPTmolS
        fJPjedOunRP7fe30h9JDvlGMifxJ3p+SyiYoCkRVCd+pPLbztf4fu7ccm2ee545V/plX5sW0
        92HHyjka1Q3+V5o5NsQ8qxRPk/nYdbTpI2+YQsTOC44W/Zn529gTIjQyu4W19pyXfnpCZrXa
        nSIe5c+f57BYrD97/eDPDKaHHecYb7exn1I4dFf71bLpGYd8twQ7Lrly54Vp6JnnM/byXl53
        KHNPvGjqHHajxnVMteWztS7Y7C5SSmlz63vAMXfev+U6eWd/fuw43hNnueSe6lu94GO9fQZK
        LMUZiYZazEXFiQDSMRwVLgMAAA==
X-CMS-MailID: 20220406064209epcas5p19d8d0c5fb4609e7252bd04beb1974d10
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----gbnykvOd6C.90mo2l7850Ojzk4ApqQRG0eelL.ATEz0EXqIh=_42bab_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220401110834epcas5p4d1e5e8d1beb1a6205d670bbcb932bf77
References: <20220401110310.611869-1-joshi.k@samsung.com>
        <CGME20220401110834epcas5p4d1e5e8d1beb1a6205d670bbcb932bf77@epcas5p4.samsung.com>
        <20220401110310.611869-4-joshi.k@samsung.com> <20220404071656.GC444@lst.de>
        <e039827d-ab7b-1791-d06c-a52ebc949de8@gmail.com>
        <20220405055835.GC23698@lst.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------gbnykvOd6C.90mo2l7850Ojzk4ApqQRG0eelL.ATEz0EXqIh=_42bab_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline


>>>> +	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
>>>> +
>>>> +	if (ret < 0)
>>>> +		req_set_fail(req);
>>>> +	io_req_complete(req, ret);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(io_uring_cmd_done);
>>>
>>> It seems like all callers of io_req_complete actually call req_set_fail
>>> on failure.  So maybe it would be nice pre-cleanup to handle the
>>> req_set_fail call from ĩo_req_complete?
>>
>> Interpretation of the result is different, e.g. io_tee(), that was the
>> reason it was left in the callers.
>
>Yes, there is about two of them that would then need to be open coded
>using __io_req_complete.

And this is how it looks. 
Pavel, Jens: would you prefer this as independent patch?

commit 2be578326b80f7a9e603b2a3224644b0cb620e25
Author: Kanchan Joshi <joshi.k@samsung.com>
Date:   Wed Apr 6 11:22:07 2022 +0530

    io_uring: cleanup error handling

    Move common error handling to io_req_complete, so that various callers
    avoid repeating that.
    Callers requiring different handling still keep that outside, and call
    __io_req_complete instead.

    Suggested-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7445084e48ce..7df465bd489a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2162,6 +2162,8 @@ static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,

 static inline void io_req_complete(struct io_kiocb *req, s32 res)
 {
+       if (res < 0)
+               req_set_fail(req);
        __io_req_complete(req, 0, res, 0);
 }

@@ -4100,8 +4102,6 @@ static int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
                                ren->newpath, ren->flags);

        req->flags &= ~REQ_F_NEED_CLEANUP;
-       if (ret < 0)
-               req_set_fail(req);
        io_req_complete(req, ret);
        return 0;
 }
@@ -4122,8 +4122,6 @@ static void io_xattr_finish(struct io_kiocb *req, int ret)
        req->flags &= ~REQ_F_NEED_CLEANUP;

        __io_xattr_finish(req);
-       if (ret < 0)
-               req_set_fail(req);

        io_req_complete(req, ret);
 }
@@ -4443,8 +4441,6 @@ static int io_mkdirat(struct io_kiocb *req, unsigned int issue_flags)
        ret = do_mkdirat(mkd->dfd, mkd->filename, mkd->mode);

        req->flags &= ~REQ_F_NEED_CLEANUP;
-       if (ret < 0)
-               req_set_fail(req);
        io_req_complete(req, ret);
        return 0;
 }
@@ -4492,8 +4488,6 @@ static int io_symlinkat(struct io_kiocb *req, unsigned int issue_flags)
        ret = do_symlinkat(sl->oldpath, sl->new_dfd, sl->newpath);

        req->flags &= ~REQ_F_NEED_CLEANUP;
-       if (ret < 0)
-               req_set_fail(req);
        io_req_complete(req, ret);
        return 0;
 }
@@ -4543,8 +4537,6 @@ static int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
                                lnk->newpath, lnk->flags);

        req->flags &= ~REQ_F_NEED_CLEANUP;
-       if (ret < 0)
-               req_set_fail(req);
        io_req_complete(req, ret);
        return 0;
 }
@@ -4580,8 +4572,6 @@ static int io_shutdown(struct io_kiocb *req, unsigned int issue_flags)
                return -ENOTSOCK;

        ret = __sys_shutdown_sock(sock, req->shutdown.how);
-       if (ret < 0)
-               req_set_fail(req);
        io_req_complete(req, ret);
        return 0;
 #else
@@ -4641,7 +4631,7 @@ static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 done:
        if (ret != sp->len)
                req_set_fail(req);
-       io_req_complete(req, ret);
+       __io_req_complete(req, 0, ret, 0);
        return 0;
 }

@@ -4685,7 +4675,7 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 done:
        if (ret != sp->len)
                req_set_fail(req);
-       io_req_complete(req, ret);
+       __io_req_complete(req, 0, ret, 0);
        return 0;
 }

@@ -4777,8 +4767,6 @@ static int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
        ret = vfs_fsync_range(req->file, req->sync.off,
                                end > 0 ? end : LLONG_MAX,
                                req->sync.flags & IORING_FSYNC_DATASYNC);
-       if (ret < 0)
-               req_set_fail(req);
        io_req_complete(req, ret);
        return 0;
 }
@@ -4807,9 +4795,7 @@ static int io_fallocate(struct io_kiocb *req, unsigned int issue_flags)
                return -EAGAIN;
        ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
                                req->sync.len);
-       if (ret < 0)
-               req_set_fail(req);
-       else
+       if (ret >= 0)
                fsnotify_modify(req->file);
        io_req_complete(req, ret);
        return 0;
@@ -5221,8 +5207,6 @@ static int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
                return -EAGAIN;

        ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice);
-       if (ret < 0)
-               req_set_fail(req);
        io_req_complete(req, ret);
        return 0;
 #else
@@ -5309,8 +5293,6 @@ static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
        ret = do_statx(ctx->dfd, ctx->filename, ctx->flags, ctx->mask,
                       ctx->buffer);

-       if (ret < 0)
-               req_set_fail(req);
        io_req_complete(req, ret);
        return 0;
 }
@@ -5410,8 +5392,6 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)

        ret = sync_file_range(req->file, req->sync.off, req->sync.len,
                                req->sync.flags);
-       if (ret < 0)
-               req_set_fail(req);
        io_req_complete(req, ret);
        return 0;

------gbnykvOd6C.90mo2l7850Ojzk4ApqQRG0eelL.ATEz0EXqIh=_42bab_
Content-Type: text/plain; charset="utf-8"


------gbnykvOd6C.90mo2l7850Ojzk4ApqQRG0eelL.ATEz0EXqIh=_42bab_--
