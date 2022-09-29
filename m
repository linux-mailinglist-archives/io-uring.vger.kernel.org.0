Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115045EF4B5
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 13:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbiI2Lu6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 07:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbiI2Luo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 07:50:44 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFE613D878
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 04:50:33 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220929115031epoutp04b760b39f1dd983950b8e3c5551d78d29~ZUnx-wMRM1440714407epoutp04f
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 11:50:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220929115031epoutp04b760b39f1dd983950b8e3c5551d78d29~ZUnx-wMRM1440714407epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664452232;
        bh=q+yy6mLwua956cm+yCU08PmFElUdfxbJLpE7ClWn5QM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D4Mu3LoUa/75+RQZiv0dYHu6K8mpME2rUoGhsmOZFLxWV57K+Y3r1nO1NO/qGEkHA
         hfXHENTkw8r/NPLwJ3LpJU1iucq55Y38SH9pRQkwxZTfLvPzRgUjEheTctnN68gvO3
         CfrpIl4fEvUji+G1+KvNEZb+N7qniZ9KU3xW/OKM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220929115029epcas5p2401126184e8bc8ce5dafec96ea7c5417~ZUnwEQhQd1961119611epcas5p2O;
        Thu, 29 Sep 2022 11:50:29 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MdWrg6XYlz4x9Q1; Thu, 29 Sep
        2022 11:50:27 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        95.9B.26992.38685336; Thu, 29 Sep 2022 20:50:27 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220929114435epcas5p490f0ae22862547b0522dda2271fd7b8e~ZUimD6DNL2654926549epcas5p44;
        Thu, 29 Sep 2022 11:44:35 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220929114435epsmtrp2cb243ed1ca2891762dc2637bcfe75475~ZUimDKsWM3195931959epsmtrp2f;
        Thu, 29 Sep 2022 11:44:35 +0000 (GMT)
X-AuditID: b6c32a49-319fb70000016970-52-63358683b8fa
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        19.61.14392.32585336; Thu, 29 Sep 2022 20:44:35 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220929114433epsmtip2b7d4a8dd877514d8e0b0b08cdda950dd~ZUikh3_Sq0948209482epsmtip2X;
        Thu, 29 Sep 2022 11:44:33 +0000 (GMT)
Date:   Thu, 29 Sep 2022 17:04:45 +0530
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        kbusch@kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com
Subject: Re: [PATCH for-next v10 5/7] block: factor out bio_map_get helper
Message-ID: <20220929113445.GD27633@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220928173121.GC17153@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsWy7bCmlm5zm2mywaIPhhar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3YHD4/LZUo9NqzrZPDYvqffYfbOBzaNv
        yypGj8+b5ALYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
        dN0yc4CuUVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZY
        GRoYGJkCFSZkZyyZOJOxYA53xa7evywNjJM5uxg5OSQETCQ+btnC1MXIxSEksJtR4uuiA2wQ
        zidGiZdzzrNCON8YJTY9fcDSxcgB1nLuRjlEfC+jxO5j36GKnjFKNG78yQ4yl0VAVWLlxrOs
        IDabgLrEkeetjCC2iICSxNNXZxlBGpgF9jBKrL++GaxIWMBLYufHd0wgNq+ArkT78X1QtqDE
        yZlPWEBsTgEdiaU7VjKD2KICyhIHth0HO1xCoJdD4mj/a2aIj1wkpvSfYYSwhSVeHd/CDmFL
        SXx+t5cNwk6X+HH5KROEXSDRfGwfVL29ROupfrA5zAIZEh/W7GKBiMtKTD21jgkizifR+/sJ
        VC+vxI55MLaSRPvKOVC2hMTecw1QtofEvJeboYF6k1Hi+fpJjBMY5WcheW4Wkn0Qto7Egt2f
        2GYBg5tZQFpi+T8OCFNTYv0u/QWMrKsYJVMLinPTU4tNCwzzUsvhUZ6cn7uJEZxctTx3MN59
        8EHvECMTB+MhRgkOZiURXvEC02Qh3pTEyqrUovz4otKc1OJDjKbA2JrILCWanA9M73kl8YYm
        lgYmZmZmJpbGZoZK4ryLZ2glCwmkJ5akZqemFqQWwfQxcXBKNTDpyX6u6czevpBZ7rTuvYVb
        VS/VRS48UXX1X3VQ1Dvn26LsH5xvTFX1DT6wVlQ99d9P33P1J6V7/n9y2cwQLMkqtvfG77BX
        q8sU15b/kLute1s80jLpSHmoS532QoHZiZLukzkPrjtTst5InYOtw+fsXdE8lz5vc5a454dX
        BfhUGy5UvLzSp/PcVucE/Zbp+x75P1//wVumZ+Our6rJWT/lTy71W3r03Hen5Dvvpr6dqFio
        fTxGtsZ+yjsR/huzdhvNUGSrWH5/S5mufbkpX36g6Sv58J7Cos+BN7PzT1s8CJG0EbxZvzsj
        qmeBVsTSyUWdwkoxp3YcSb/02L7s/ImVWwz7/T483uKpKJvqukiJpTgj0VCLuag4EQAlxI4n
        NwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSvK5yq2mywY+5khar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3YHD4/LZUo9NqzrZPDYvqffYfbOBzaNv
        yypGj8+b5ALYorhsUlJzMstSi/TtErgyvj37xlJwh6Ni+c0DjA2Mb9i6GDk4JARMJM7dKO9i
        5OIQEtjNKPH102/mLkZOoLiExKmXyxghbGGJlf+es0MUPWGU2HfqKCtIgkVAVWLlxrNgNpuA
        usSR561gDSICShJPX51lBGlgFtjDKLH++mawImEBL4mdH98xgdi8AroS7cf3MUFMvc0ocfoF
        RBGvgKDEyZlPWEBsZgEtiRv/XjKBnMosIC2x/B8HSJhTQEdi6Y6VYJeKCihLHNh2nGkCo+As
        JN2zkHTPQuhewMi8ilEytaA4Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMjOCa0NHcwbl/1Qe8Q
        IxMH4yFGCQ5mJRFe8QLTZCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphak
        FsFkmTg4pRqYFhRJ6Vf8unV6YTXr8t+tx85mlXY6KzNIlDGZ/67/oa57SN/3Gffclw/Vpz19
        IGmw+fEN+9t7vosUJrkpb5nsMP/os/6Y6ukpuVz1H4PL3jJa8d/fUfRJqGh9/lRBwYyKjc23
        J1UmxvxK14m1eC7fJJ5u0X00f0V7poXF9q/zY9T3WnbKBImtOn/5ndyC0+JvZ+9OUHMXeHF2
        +bo30ziK9ZWKJDUvlcse45xzw+X7hl7ZWt1tz8Rc7ZxKQndvC3k/YWuQzLsuZ9nURP7QoDtc
        +dP7WZ9qsS4PDv9zze/v992JEks3dLXo9Z6/0O37oT+NrTI1kLcxecaNntnbE1OtD+/lqZyc
        5yC+KTHu8nwlluKMREMt5qLiRABLJjSr+AIAAA==
X-CMS-MailID: 20220929114435epcas5p490f0ae22862547b0522dda2271fd7b8e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----hXhhLlTPEJEAuBfojHalMaoqUrqdtcRK870WvTI8zmI2Z-rh=_23241_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220927174636epcas5p49008baa36dcbf2f61c25ba89c4707c0c
References: <20220927173610.7794-1-joshi.k@samsung.com>
        <CGME20220927174636epcas5p49008baa36dcbf2f61c25ba89c4707c0c@epcas5p4.samsung.com>
        <20220927173610.7794-6-joshi.k@samsung.com> <20220928173121.GC17153@lst.de>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------hXhhLlTPEJEAuBfojHalMaoqUrqdtcRK870WvTI8zmI2Z-rh=_23241_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Sep 28, 2022 at 07:31:21PM +0200, Christoph Hellwig wrote:
> On Tue, Sep 27, 2022 at 11:06:08PM +0530, Kanchan Joshi wrote:
> > Move bio allocation logic from bio_map_user_iov to a new helper
> > bio_map_get. It is named so because functionality is opposite of what is
> > done inside bio_map_put. This is a prep patch.
> 
> I'm still not a fan of using bio_sets for passthrough and would be
> much happier if we could drill down what the problems with the
> slab per-cpu allocator are, but it seems like I've lost that fight
> against Jens..
> 
> > +static struct bio *bio_map_get(struct request *rq, unsigned int nr_vecs,
> >  		gfp_t gfp_mask)
> 
> But these names just seems rather misleading.  Why not someting
> like blk_rq_map_bio_alloc and blk_mq_map_bio_put?

Agreed, will rename the alloc and put function in the next iteration

> 
> Not really new in this code but a question to Jens:  The existing
> bio_map_user_iov has no real upper bounds on the number of bios
> allocated, how does that fit with the very limited pool size of
> fs_bio_set?

--
Anuj Gupta

> 
> 

------hXhhLlTPEJEAuBfojHalMaoqUrqdtcRK870WvTI8zmI2Z-rh=_23241_
Content-Type: text/plain; charset="utf-8"


------hXhhLlTPEJEAuBfojHalMaoqUrqdtcRK870WvTI8zmI2Z-rh=_23241_--
