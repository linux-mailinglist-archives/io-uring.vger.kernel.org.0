Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68C16DC63A
	for <lists+io-uring@lfdr.de>; Mon, 10 Apr 2023 13:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjDJL0F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Apr 2023 07:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjDJL0E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Apr 2023 07:26:04 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5B63AA7
        for <io-uring@vger.kernel.org>; Mon, 10 Apr 2023 04:26:01 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230410112558epoutp0487615b93f141197c172db90d4262d77f~Ujyb-HWpv1188611886epoutp04X
        for <io-uring@vger.kernel.org>; Mon, 10 Apr 2023 11:25:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230410112558epoutp0487615b93f141197c172db90d4262d77f~Ujyb-HWpv1188611886epoutp04X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1681125958;
        bh=UHIxLy9rr2FhoG6rYbGSve7hP2xwzs8NruR/TyQFIMM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vvozc/AX+2UFkrE+m2OcNf4q65qf2xw32IL3ehSFZp5VeUxoFGaKZo3Wj7G7gkL0i
         X8sapoO/2iHGZ+1eiV5iLmfCnCnD57XWYTE4zC4Wn+SLbotCV/IKVKPdHB5f6emif3
         NCMO0tlBX/KwiFBi08bov4U294zx5byClF4smXf8=
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230410112558epcas5p1a0b28653aae0af8be020cd6dff0fd2ef~Ujybe8Jay0835008350epcas5p1k;
        Mon, 10 Apr 2023 11:25:58 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230410112558epsmtrp20642811a51e760e70ba63e118986d2ff~Ujybebwfu3173131731epsmtrp2Y;
        Mon, 10 Apr 2023 11:25:58 +0000 (GMT)
Received: from green5 (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230410112556epsmtip1c29299c2d6bd2368d392525783eafae0~UjyaK_cPT2849828498epsmtip1N;
        Mon, 10 Apr 2023 11:25:56 +0000 (GMT)
Date:   Mon, 10 Apr 2023 16:55:03 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Keith Busch <kbusch@meta.com>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        sagi@grimberg.me, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 2/5] nvme: simplify passthrough bio cleanup
Message-ID: <20230410112503.GA16047@green5>
MIME-Version: 1.0
In-Reply-To: <20230407191636.2631046-3-kbusch@meta.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-CMS-MailID: 20230410112558epcas5p1a0b28653aae0af8be020cd6dff0fd2ef
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----6TPaBgSVJHTP5aYW_KCyJfD-AyyqAIDIArT8HI0pnVcs47o3=_5835_"
CMS-TYPE: 105P
X-CMS-RootMailID: 20230407191711epcas5p3b9b27aa2477b12ec116b85ea3c7d54b7
References: <20230407191636.2631046-1-kbusch@meta.com>
        <CGME20230407191711epcas5p3b9b27aa2477b12ec116b85ea3c7d54b7@epcas5p3.samsung.com>
        <20230407191636.2631046-3-kbusch@meta.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------6TPaBgSVJHTP5aYW_KCyJfD-AyyqAIDIArT8HI0pnVcs47o3=_5835_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Apr 07, 2023 at 12:16:33PM -0700, Keith Busch wrote:
>From: Keith Busch <kbusch@kernel.org>
>
>Set the bio's bi_end_io to handle the cleanup so that uring_cmd doesn't
>need this complex pdu->{bio,req} switchero and restore.
>
>Signed-off-by: Keith Busch <kbusch@kernel.org>
>---
> drivers/nvme/host/ioctl.c | 26 +++++++++-----------------
> 1 file changed, 9 insertions(+), 17 deletions(-)
>
>diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
>index d24ea2e051564..278c57ee0db91 100644
>--- a/drivers/nvme/host/ioctl.c
>+++ b/drivers/nvme/host/ioctl.c
>@@ -159,6 +159,11 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
> 	return req;
> }
>
>+static void nvme_uring_bio_end_io(struct bio *bio)
>+{
>+	blk_rq_unmap_user(bio);
>+}
>+
> static int nvme_map_user_request(struct request *req, u64 ubuffer,
> 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
> 		u32 meta_seed, void **metap, struct io_uring_cmd *ioucmd,
>@@ -204,6 +209,7 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
> 		*metap = meta;
> 	}
>
>+	bio->bi_end_io = nvme_uring_bio_end_io;
> 	return ret;
>
> out_unmap:
>@@ -249,8 +255,6 @@ static int nvme_submit_user_cmd(struct request_queue *q,
> 	if (meta)
> 		ret = nvme_finish_user_metadata(req, meta_buffer, meta,
> 						meta_len, ret);
>-	if (bio)
>-		blk_rq_unmap_user(bio);

Is it safe to call blk_rq_unamp_user in irq context?
Agree that current code does some complex stuff, but that's to ensure
what the code-comment [1] says.

Also for polled-io, new-code will hit this warn-on [2] on calling
bio_put_percpu_cache.

[1] 
623  *    A matching blk_rq_unmap_user() must be issued at the end of I/O, while
624  *    still in process context.
625  */
626 int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
627                         struct rq_map_data *map_data,


[2]
773         if ((bio->bi_opf & REQ_POLLED) && !WARN_ON_ONCE(in_interrupt())) {
774                 bio->bi_next = cache->free_list;

------6TPaBgSVJHTP5aYW_KCyJfD-AyyqAIDIArT8HI0pnVcs47o3=_5835_
Content-Type: text/plain; charset="utf-8"


------6TPaBgSVJHTP5aYW_KCyJfD-AyyqAIDIArT8HI0pnVcs47o3=_5835_--
