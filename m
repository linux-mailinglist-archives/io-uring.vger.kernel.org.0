Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A82C5E9528
	for <lists+io-uring@lfdr.de>; Sun, 25 Sep 2022 19:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiIYR4c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Sep 2022 13:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiIYR42 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Sep 2022 13:56:28 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A752EF31
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 10:56:25 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220925175623epoutp02eeff4004efab372278c54dd06640e902~YLCFHEWtZ2456024560epoutp02M
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 17:56:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220925175623epoutp02eeff4004efab372278c54dd06640e902~YLCFHEWtZ2456024560epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664128583;
        bh=MqWLYp1SB7EUsYn9X6M7FGOrixEdwkfp1gsuzC3iQOI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hedfUs65lhPSlGSCRYgtuOU4DLnehqMgXZ8IaLDoxVHOqM8tLnoe0g/k2jgnNLCqq
         A4/T05ocy5A5JuuJqDDQkzgKHeJsBlonCqMnrJQf4fjXoGDN6xz5W/UVEsRmLUxmGk
         rgBeRD6epBmilRL/yks85U9hXKafCgUpg5JwVln8=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220925175622epcas5p178c6aa5bddc1fd6c603cef22cab01a09~YLCEYMDup2503425034epcas5p19;
        Sun, 25 Sep 2022 17:56:22 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MbD8h3Ycmz4x9Pp; Sun, 25 Sep
        2022 17:56:20 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DB.B7.26992.44690336; Mon, 26 Sep 2022 02:56:20 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220925175619epcas5p2b91ed5b776b599122f25bb7da1cf895f~YLCBKuuGP1919819198epcas5p2f;
        Sun, 25 Sep 2022 17:56:19 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220925175619epsmtrp11664321642fdce99aef06dfbd0eef0e7~YLCBJ-TH-2827728277epsmtrp1_;
        Sun, 25 Sep 2022 17:56:19 +0000 (GMT)
X-AuditID: b6c32a49-0c7ff70000016970-75-63309644ef9d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        11.97.18644.34690336; Mon, 26 Sep 2022 02:56:19 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220925175617epsmtip10c2b58ac21bb994f2dd1d5c971770ad4~YLB-dvuu40107201072epsmtip1W;
        Sun, 25 Sep 2022 17:56:17 +0000 (GMT)
Date:   Sun, 25 Sep 2022 23:16:29 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH for-next v7 4/5] block: add helper to map bvec iterator
 for passthrough
Message-ID: <20220925174629.GB6320@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220923184349.GA3394@test-zns>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmpq7LNINkg8Y7khZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi0mHrjFa7L2lbTF/2VN2B06PnbPusntcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAHtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
        kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3i
        xNzi0rx0vbzUEitDAwMjU6DChOyMk9/Wshac0aw4d+Q8YwPjPYUuRk4OCQETie1fDzB3MXJx
        CAnsZpRYte42G4TziVHibPNrdgjnM6PEr8/HmWFafq1byghiCwnsYpT4eI0TougZo8SKq7tY
        QRIsAqoSm34sAerm4GAT0JS4MLkUJCwioCTx9NVZRpB6ZoErjBJPutYxgSSEBWIlNh75DbaA
        V0BH4vHNyewQtqDEyZlPWEBsTgFdiXsbm9hAbFEBZYkD244zgQySEJjJIfG8bQ4TxHUuEicm
        nISyhSVeHd/CDmFLSbzsb4OykyUuzTwHVVMi8XjPQSjbXqL1VD/YEcwC6RJP161mhbD5JHp/
        P2ECeUZCgFeio00IolxR4t6kp6wQtrjEwxlLoGwPiTVzrjBCAmU/k8TdKc9ZJjDKzULyzywk
        KyBsK4nOD01ANgeQLS2x/B8HhKkpsX6X/gJG1lWMkqkFxbnpqcWmBYZ5qeXwSE7Oz93ECE6q
        Wp47GO8++KB3iJGJg/EQowQHs5IIb8pF3WQh3pTEyqrUovz4otKc1OJDjKbA+JnILCWanA9M
        63kl8YYmlgYmZmZmJpbGZoZK4ryLZ2glCwmkJ5akZqemFqQWwfQxcXBKNTCZnjSrYFEwV25k
        /vRGQf32yWVHzN5yzd/QOPEY16XCZVO5ju4PPefdq/Zt8zyRRxITmFL4/gtpruFs2Ri9+d2D
        LdKBUhk3douYfWqKjGNLcWIQ6Lzof9Mzjcd+M7PxX79SscLM7U4HdJI3Nqbb7w0K6+aObLqx
        TDBfe2Vulmizro2TZrk7z+3S31NmXDc7P6nd44TPgzTPQq0dzpcN2F4sYFJ6t8YsPDl1D8Pt
        Q7JR27qc0wWTjXxifxqLTBOfnm7/9IiA/auF75kyGy8vmPfszIQvhwyL50i12x///fn1Qr/O
        1hMyNcbLo6edXrf9iWLiPf8X70IsJjUuNj2/XO1za5mSyZd1pgtW3mSs7lBiKc5INNRiLipO
        BADUoep0MwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSnK7zNINkg2vLxS2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02HtL22L+sqfsDpweO2fdZfe4fLbUY9OqTjaP
        zUvqPXbfbGDz6NuyitHj8ya5APYoLpuU1JzMstQifbsEroyXO2MLGtUrTv/9x9TAuFaui5GT
        Q0LAROLXuqWMXYxcHEICOxglTs58xwKREJdovvaDHcIWllj57zk7RNETRokV646CFbEIqEps
        +rEEKMHBwSagKXFhcilIWERASeLpq7NgQ5kFrjBK/Nm/hBUkISwQK7HxyG9mEJtXQEfi8c3J
        YAuEBA4zSWy/HQMRFwQ64gnYfGYBM4l5mx8yg8xnFpCWWP6PAyTMKaArcW9jExuILSqgLHFg
        23GmCYyCs5B0z0LSPQuhewEj8ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOAY0dLa
        wbhn1Qe9Q4xMHIyHGCU4mJVEeFMu6iYL8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9
        sSQ1OzW1ILUIJsvEwSnVwOSx8trB70uLdFyPPEr1jHufd2rFEV6NGzXT9vFbTb667KiVzp7z
        xxmimaY4zfU15//71oZLUDnr9nyN+Zd2K4u8KD7ROSncuFGffeevjKgAtbggpajMRaFKCh8r
        5sXc2joj2fdxkYabu96kKXEykb8dj7crnzJWmyV7JG3h+6f5zis9dwbpvM3f8POa8+9bj+zu
        //zqp3xn9iubm5YeFlNunO1prbkuK8D5xPQWQ87mQ+fYXUVSGLnsT1hxn283PcctuvHz+Wyd
        JyFuBmzrtcOXLbvCeHD20k0OOgmc07+oPui9Jr3KLmSmO8vkux4iKzlePAnerSZnzOlksIjD
        WT9N/8rBVzme91aZJJpp2yixFGckGmoxFxUnAgBuofPGAAMAAA==
X-CMS-MailID: 20220925175619epcas5p2b91ed5b776b599122f25bb7da1cf895f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----zXa1yWTdJy36.cdAFXt1mnTNG7drKMUjG1kd-arILwPMI.kl=_b7de_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220909103147epcas5p2a83ec151333bcb1d2abb8c7536789bfd
References: <20220909102136.3020-1-joshi.k@samsung.com>
        <CGME20220909103147epcas5p2a83ec151333bcb1d2abb8c7536789bfd@epcas5p2.samsung.com>
        <20220909102136.3020-5-joshi.k@samsung.com> <20220920120802.GC2809@lst.de>
        <20220922152331.GA24701@test-zns> <20220923152941.GA21275@lst.de>
        <20220923184349.GA3394@test-zns>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------zXa1yWTdJy36.cdAFXt1mnTNG7drKMUjG1kd-arILwPMI.kl=_b7de_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Sat, Sep 24, 2022 at 12:13:49AM +0530, Kanchan Joshi wrote:
>On Fri, Sep 23, 2022 at 05:29:41PM +0200, Christoph Hellwig wrote:
>>On Thu, Sep 22, 2022 at 08:53:31PM +0530, Kanchan Joshi wrote:
>>>>blk_rq_map_user_iov really should be able to detect that it is called
>>>>on a bvec iter and just do the right thing rather than needing different
>>>>helpers.
>>>
>>>I too explored that possibility, but found that it does not. It maps the
>>>user-pages into bio either directly or by doing that copy (in certain odd
>>>conditions) but does not know how to deal with existing bvec.
>>
>>What do you mean with existing bvec?  We allocate a brand new bio here
>>that we want to map the next chunk of the iov_iter to, and that
>>is exactly what blk_rq_map_user_iov does.  What blk_rq_map_user_iov
>>currently does not do is to implement this mapping efficiently
>>for ITER_BVEC iters
>
>It is clear that it was not written for ITER_BVEC iters.
>Otherwise that WARN_ON would not have hit.
>
>And efficency is the concern as we are moving to more heavyweight
>helper that 'handles' weird conditions rather than just 'bails out'.
>These alignment checks end up adding a loop that traverses
>the entire ITER_BVEC.
>Also blk_rq_map_user_iov uses bio_iter_advance which also seems
>cycle-consuming given below code-comment in io_import_fixed():
>
>if (offset) {
>       /*
>        * Don't use iov_iter_advance() here, as it's really slow for
>        * using the latter parts of a big fixed buffer - it iterates
>        * over each segment manually. We can cheat a bit here, because
>        * we know that:
>
>So if at all I could move the code inside blk_rq_map_user_iov, I will
>need to see that I skip doing iov_iter_advance.
>
>I still think it would be better to take this route only when there are
>other usecases/callers of this. And that is a future thing. For the current
>requirement, it seems better to prioritze efficency.
>
>>, but that is something that could and should
>>be fixed.
>>
>>>And it really felt cleaner to me write a new function rather than
>>>overloading the blk_rq_map_user_iov with multiple if/else canals.
>>
>>No.  The whole point of the iov_iter is to support this "overload".
>
>Even if I try taking that route, WARN_ON is a blocker that  prevents 
>me to put this code inside blk_rq_map_user_iov.
>
>>>But iov_iter_gap_alignment does not work on bvec iters. Line #1274 below
>>
>>So we'll need to fix it.
>
>Do you see good way to trigger this virt-alignment condition? I have
>not seen this hitting (the SG gap checks) when running with fixebufs.
>
>>>1264 unsigned long iov_iter_gap_alignment(const struct iov_iter *i)
>>>1265 {
>>>1266         unsigned long res = 0;
>>>1267         unsigned long v = 0;
>>>1268         size_t size = i->count;
>>>1269         unsigned k;
>>>1270
>>>1271         if (iter_is_ubuf(i))
>>>1272                 return 0;
>>>1273
>>>1274         if (WARN_ON(!iter_is_iovec(i)))
>>>1275                 return ~0U;
>>>
>>>Do you see a way to overcome this. Or maybe this can be revisted as we
>>>are not missing a lot?
>>
>>We just need to implement the equivalent functionality for bvecs.  It
>>isn't really hard, it just wasn't required so far.
>
>Can the virt-boundary alignment gap exist for ITER_BVEC iter in first
>place? Two reasons to ask this question:
>
>1. Commit description of this code (from Al viro) says -
>
>"iov_iter_gap_alignment(): get rid of iterate_all_kinds()
>
>For one thing, it's only used for iovec (and makes sense only for
>those)."
>
>2. I did not hit it so far as I mentioned above.

And we also have below condition (patch of Linus) that restricts
blk_rq_map_user_iov to only iovec iterator

commit a0ac402cfcdc904f9772e1762b3fda112dcc56a0
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Dec 6 16:18:14 2016 -0800

    Don't feed anything but regular iovec's to blk_rq_map_user_iov

    In theory we could map other things, but there's a reason that function
    is called "user_iov".  Using anything else (like splice can do) just
    confuses it.

    Reported-and-tested-by: Johannes Thumshirn <jthumshirn@suse.de>
    Cc: Al Viro <viro@ZenIV.linux.org.uk>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/block/blk-map.c b/block/blk-map.c
index b8657fa8dc9a..27fd8d92892d 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -118,6 +118,9 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
        struct iov_iter i;
        int ret;

+       if (!iter_is_iovec(iter))
+               goto fail;
+
        if (map_data)
                copy = true;
        else if (iov_iter_alignment(iter) & align)
@@ -140,6 +143,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,

 unmap_rq:
        __blk_rq_unmap_user(bio);
+fail:
        rq->bio = NULL;
        return -EINVAL;
 }


------zXa1yWTdJy36.cdAFXt1mnTNG7drKMUjG1kd-arILwPMI.kl=_b7de_
Content-Type: text/plain; charset="utf-8"


------zXa1yWTdJy36.cdAFXt1mnTNG7drKMUjG1kd-arILwPMI.kl=_b7de_--
