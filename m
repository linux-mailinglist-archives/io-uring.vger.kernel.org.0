Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53AD5EF4A9
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 13:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbiI2Ltu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 07:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiI2Ltt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 07:49:49 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C172646
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 04:49:40 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220929114937epoutp019bbdcd4fdae567f272d0f0a0ade81a52~ZUm-je-pF0967709677epoutp01N
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 11:49:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220929114937epoutp019bbdcd4fdae567f272d0f0a0ade81a52~ZUm-je-pF0967709677epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664452177;
        bh=hn0G0WNcN3oMwshfKu0rKWJ7e8tbf2wi1jt7J5R7isg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L7dsR5Y1dnzsASxUtQQ/VpX6zxDOFCxEZyE3Wd5caVEL0eBR+ffiMpm8BCxVvDPBZ
         hfkI3kCGGV0MxMWgJH1BfWz1cPtFun/isPD0NUzo+3He7CpiSoPb+y1RmNeXSSTi9F
         5ErX+/S/HqcEOYzM/hBl+Kj+xK7LjKZ3ZS35Bo+k=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220929114937epcas5p2e0a04b76bea798a3ad46692fd5464b09~ZUm-FuV323251432514epcas5p2U;
        Thu, 29 Sep 2022 11:49:37 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MdWqg26QMz4x9Q9; Thu, 29 Sep
        2022 11:49:35 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2B.3B.26992.F4685336; Thu, 29 Sep 2022 20:49:35 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220929113852epcas5p4196b88a5db829b7406b7dad2e41144f7~ZUdmXp_8O1549215492epcas5p4W;
        Thu, 29 Sep 2022 11:38:52 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220929113852epsmtrp15eed6b17171d24952c4ea46316f7a218~ZUdmW8C862774127741epsmtrp1P;
        Thu, 29 Sep 2022 11:38:52 +0000 (GMT)
X-AuditID: b6c32a49-319fb70000016970-8c-6335864f86bf
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E9.A0.14392.CC385336; Thu, 29 Sep 2022 20:38:52 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220929113850epsmtip1e7feb6edcf78a9ecd29ef83cd480d9e1~ZUdk0pHi61231512315epsmtip1_;
        Thu, 29 Sep 2022 11:38:50 +0000 (GMT)
Date:   Thu, 29 Sep 2022 16:58:59 +0530
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        kbusch@kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com
Subject: Re: [PATCH for-next v10 3/7] nvme: refactor nvme_add_user_metadata
Message-ID: <20220929112859.GA27633@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220928171805.GA17153@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKJsWRmVeSWpSXmKPExsWy7bCmuq5/m2mywdUmXovVd/vZLG4e2Mlk
        sXL1USaLd63nWCyO/n/LZjHp0DVGi723tC3mL3vK7sDhcflsqcemVZ1sHpuX1HvsvtnA5tG3
        ZRWjx+dNcgFsUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
        um6ZOUDXKCmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkus
        DA0MjEyBChOyMz5te8JScJ+tYsHti0wNjKdZuxg5OSQETCTa/r9i7GLk4hAS2M0ocf3kamYI
        5xOjxLarp1kgnG+MEnd3z2WCadnxeTFUy15GieY7u6CcZ4wSX7vms4FUsQioSny4MY0dxGYT
        UJc48ryVEcQWEVCSePrqLFgDs8AeRon11zeDXSIs4C2x6NAGsCJeAV2Jjrlr2CBsQYmTM5+w
        gNicAjoS3+98A6sXFVCWOLDtOBPIIAmBXg6Ja+/fQb3kInFlwyYWCFtY4tXxLewQtpTEy/42
        KDtd4sflp1D/FEg0H9vHCGHbS7Se6mcGsZkFMiQebp7GBhGXlZh6ah0TRJxPovf3E6heXokd
        82BsJYn2lXOgbAmJvecaoGwPiVMLfjJBgugmo8TBvfvYJjDKz0Ly3Cwk+yBsHYkFuz8B2RxA
        trTE8n8cEKamxPpd+gsYWVcxSqYWFOempxabFhjmpZbD4zw5P3cTIzi9annuYLz74IPeIUYm
        DsZDjBIczEoivOIFpslCvCmJlVWpRfnxRaU5qcWHGE2BsTWRWUo0OR+Y4PNK4g1NLA1MzMzM
        TCyNzQyVxHkXz9BKFhJITyxJzU5NLUgtgulj4uCUamAq5XcxtqhnfL+zYYWN1JrcA/lPZ/Hn
        Wsibz9mtfH1DaqC85vMTVuZLN73tErE4K/JaTY1hp7/xym+T2ddPeNO8S/9os+1+o8zyb7te
        7Drpu2FFYfhje4YQT70luRNnOPR4Hcn6W+MbXFnvLtP4fsqdDU93R1ZdL67bVCt+gVvL/CjH
        yd0Sar38QeWHdzIeX2bN/nTZi4z/GWuXtDVuetTx99X1qmB5M7+y089aj5peZnDTY8l/ZLf6
        5t47PHpVIR6uU5kO3Xk33zJAl//bK+WNQfqVltuS/VWF5XmFXpguz3Wpkyla1/C9sq347QIX
        uV92mrw/Wk93Te70enXbc6VWbK9w36mUzRNvG+e8F1ZiKc5INNRiLipOBACUjh5+OAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSnO6ZZtNkg+WvOC1W3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpuwOHx+WzpR6bVnWyeWxeUu+x+2YDm0ff
        llWMHp83yQWwRXHZpKTmZJalFunbJXBlTJl/ir1gPkvFlkXXGBsYlzB3MXJySAiYSOz4vJgR
        xBYS2M0osfGjEERcQuLUy2WMELawxMp/z9m7GLmAap4wSuybNZ8JJMEioCrx4cY0dhCbTUBd
        4sjzVrAGEQEliaevzjKCNDAL7GGUWH99MytIQljAW2LRoQ1gRbwCuhIdc9ewQUy9zSix5PVx
        NoiEoMTJmU9YQGxmAS2JG/9eAm3jALKlJZb/4wAJcwroSHy/8w1spqiAssSBbceZJjAKzkLS
        PQtJ9yyE7gWMzKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYJjQktzB+P2VR/0DjEy
        cTAeYpTgYFYS4RUvME0W4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoR
        TJaJg1OqgaloRqX89If897WyhRc/iMl7qirNMOfdI0e2kw/XFqYYrzb/GBrMvywk/6z9RQlP
        oRS9UyeNd2eb/mkU2JqcpdXk2TZtz6HetuLdE5/vznpYveLUpx0z9yq4sDReW1+xqv5B/fTH
        NbrWxyLk7mh9sS+T/dQ7bW+G3P2wBVGV/QHS0y/U/DTVtTB96T9vxvRpwdp5aYvLWSa5ts7M
        vLJRRjzzf5bsstdS7N7WjPrfefITjFheMc5SluqYv3xq77byFD7n1/2v9VsevwqTrb/9JiXq
        gVqm63fDVf+1p1UG2KXO+CvXyMHAstPcPHL6o1m3fr98mn3uSQf/PM9JYsLMO4/W/jnL83zH
        i91rhN0OrlViKc5INNRiLipOBAC5jWlE+AIAAA==
X-CMS-MailID: 20220929113852epcas5p4196b88a5db829b7406b7dad2e41144f7
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----zXa1yWTdJy36.cdAFXt1mnTNG7drKMUjG1kd-arILwPMI.kl=_2328c_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220927174631epcas5p12cd6ffbd7dad819b0af75733ce6cdd2c
References: <20220927173610.7794-1-joshi.k@samsung.com>
        <CGME20220927174631epcas5p12cd6ffbd7dad819b0af75733ce6cdd2c@epcas5p1.samsung.com>
        <20220927173610.7794-4-joshi.k@samsung.com> <20220928171805.GA17153@lst.de>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------zXa1yWTdJy36.cdAFXt1mnTNG7drKMUjG1kd-arILwPMI.kl=_2328c_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Sep 28, 2022 at 07:18:05PM +0200, Christoph Hellwig wrote:
> On Tue, Sep 27, 2022 at 11:06:06PM +0530, Kanchan Joshi wrote:
> >  		if (bdev && meta_buffer && meta_len) {
> > -			meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
> > -					meta_seed, write);
> > +			meta = nvme_add_user_metadata(req, meta_buffer, meta_len,
> 
> Pleae avoid the overly long line here.
> 

sure, will fold it in, in the next iteration
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

--
Anuj Gupta


------zXa1yWTdJy36.cdAFXt1mnTNG7drKMUjG1kd-arILwPMI.kl=_2328c_
Content-Type: text/plain; charset="utf-8"


------zXa1yWTdJy36.cdAFXt1mnTNG7drKMUjG1kd-arILwPMI.kl=_2328c_--
