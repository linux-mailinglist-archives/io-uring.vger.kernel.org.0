Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB945EF4B7
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 13:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbiI2LvO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 07:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbiI2LvK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 07:51:10 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B74010F72D
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 04:51:08 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220929115103epoutp0346ff6ac3f676c7b718cf5fe3dea874cd~ZUoO9MAu82734527345epoutp03G
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 11:51:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220929115103epoutp0346ff6ac3f676c7b718cf5fe3dea874cd~ZUoO9MAu82734527345epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664452263;
        bh=UusulqRpysVUIzAkvHawID4SCo7MWa2AUVyepONB3Wo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U/1PLVkC9KOD0xdtCg9gNxnb3p8U1w4spj1wx6y6QT+IH0KnAIa4+a8dK5iBPiTdt
         aQqBtwvoenyjS7CSzQUr1t8TtDfotSJG8jsaEEXU44bMXE7CMMYGfwuaZ0h9U8/Itn
         LsVCj3vEDdSga0bXY3PxNolNtLtUZmZ6HBNO74AU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220929115102epcas5p1e0c4c4d15df514e5bd0a603ee635c168~ZUoOYFvpB2371223712epcas5p1V;
        Thu, 29 Sep 2022 11:51:02 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MdWsH6YZnz4x9Pp; Thu, 29 Sep
        2022 11:50:59 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        27.F1.39477.3A685336; Thu, 29 Sep 2022 20:50:59 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220929114553epcas5p111cafe19d8d682c30ebcb8621ed7ffb3~ZUjuMvSsl1005010050epcas5p1X;
        Thu, 29 Sep 2022 11:45:53 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220929114552epsmtrp15e4da8243d6d99c7d3daf39c14aa010f~ZUjuL-gEi3217132171epsmtrp1V;
        Thu, 29 Sep 2022 11:45:52 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-3f-633586a38b54
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C8.9A.18644.07585336; Thu, 29 Sep 2022 20:45:52 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220929114551epsmtip21ee60e9491898e1eba29d65718088cba~ZUjs9eW2s1348113481epsmtip2N;
        Thu, 29 Sep 2022 11:45:51 +0000 (GMT)
Date:   Thu, 29 Sep 2022 17:06:03 +0530
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        kbusch@kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com
Subject: Re: [PATCH for-next v10 7/7] nvme: wire up fixed buffer support for
 nvme passthrough
Message-ID: <20220929113603.GE27633@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220928175904.GA17899@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsWy7bCmlu7iNtNkg5WXDCxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpuwOHx+WzpR6bVnWyeWxeUu+x+2YDm0ff
        llWMHp83yQWwRWXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
        6Lpl5gBdo6RQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkpMCnQK07MLS7NS9fLSy2x
        MjQwMDIFKkzIzth3TbFgtUTFxY9LmRsYNwh3MXJySAiYSLzZMpW1i5GLQ0hgN6PE6kP7GCGc
        T4wSjY/WskE4nxkltt49zArT8qijCSqxi1HiVvMWJgjnGaPE/2mv2UGqWARUJfrn/wDrYBNQ
        lzjyvJURxBYRUJJ4+uos2A5mgT2MEuuvbwYrEhaIl2j/vxbM5hXQldhzYTOULShxcuYTFhCb
        U0BHYv2x82CDRAWUJQ5sOw62WUKglUNiwe7HLBD3uUhs/vScEcIWlnh1fAs7hC0l8bK/DcpO
        l/hx+SkThF0g0XxsH1S9vUTrqX5mEJtZIEPi98xpzBBxWYmpp9YxQcT5JHp/P4Hq5ZXYMQ/G
        VpJoXzkHypaQ2HuuAcr2kGj9/pQdEkQ3GSVe3Gtmn8AoPwvJc7OQ7IOwdYD++cQ2i5EDyJaW
        WP6PA8LUlFi/S38BI+sqRsnUguLc9NRi0wKjvNRyeJQn5+duYgQnVy2vHYwPH3zQO8TIxMF4
        iFGCg1lJhFe8wDRZiDclsbIqtSg/vqg0J7X4EKMpMLYmMkuJJucD03teSbyhiaWBiZmZmYml
        sZmhkjjv4hlayUIC6YklqdmpqQWpRTB9TBycUg1M2e475jXOVP4rGD/X22iSso9WyM6/t0WY
        lu5//f/EwspXyY9EfgZMm7ll7mX2lAmX+y7ZsE1SZjL1MzR8+YSNwTds292M4EV6Zq1R4s+r
        fDge/7s8/cqbW0di4/LvRTbXNIVwaXmUGnDeelO/rcKrat1lqadzD/t/+54lxOGZ+7Pm/Dud
        qWbKd1RyrjqmHE7imu56ueFJ6BT5iUGiHuq63OYrRBcc/a0u73A2bPqbt52P5d1XHXdVPSHJ
        wKHxQvwYo2iu4AqFKpWmmYv3svrvqXrgGLh0Yo/OGvl9gc2h536/uX1kO8+LJbbZ3HU8Xdd8
        NlzX234uNG5qUs7J5/Ou26xavVZn+RH+nbGcBa82KLEUZyQaajEXFScCAFY8Z8g3BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSvG5Bq2mywYZ/Zhar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3YHD4/LZUo9NqzrZPDYvqffYfbOBzaNv
        yypGj8+b5ALYorhsUlJzMstSi/TtErgyFje8Yy94LVpx6toEpgbGTsEuRk4OCQETiUcdTWxd
        jFwcQgI7GCUe/5/HApGQkDj1chkjhC0ssfLfc3aIoieMEktvXWUCSbAIqEr0z//BCmKzCahL
        HHneCtYgIqAk8fTVWUaQBmaBPYwS669vBisSFoiXaP+/FszmFdCV2HMBJA4y9TajxI/5M5gg
        EoISJ2c+ATuDWUBL4sa/l0BxDiBbWmL5Pw6QMKeAjsT6Y+fBlokKKEsc2HacaQKj4Cwk3bOQ
        dM9C6F7AyLyKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4KrS0djDuWfVB7xAjEwfj
        IUYJDmYlEV7xAtNkId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZ
        ODilGpjCZha0nlLJSWwpKXq95OPNKROvmyR8ihT+Wensf+C/DOfSM7OW3Js/I5/XnDGY6Un6
        scywe11Z1679MPwipB/oYfhVfr4M3/2iMtGrTpXsga93JfPXNr9yXKUhJvBIn9sgb5bsrUyx
        iZe85O7eUmQqnGd+vXOOsefbSa35MY0yxxfKyEqVuIUuV1zWciTfI2yiz5ONGedixbxaszfG
        JDuHPPfVzglrUVxbla7cq3h6h9vErSvYKl6qmX6XYV7jaF3Rv9P8dV7YTdcfM5SKHBxlv3yT
        cXUQOFPQu4Pr+vGGMs0os8fcx/XF7u19s5tr9Wu5rXqsbO7vtu0KUXfYU39gw4stj5+Iv+j5
        eGjzKiWW4oxEQy3mouJEAEjgjkP5AgAA
X-CMS-MailID: 20220929114553epcas5p111cafe19d8d682c30ebcb8621ed7ffb3
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----MqMoGWHj7w70ixSxIQQUJpQDpxeWNW7xlUV_NBkU4rXoYOVD=_23360_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220927174642epcas5p1dafa31776d4eb8180e18f149ed25640c
References: <20220927173610.7794-1-joshi.k@samsung.com>
        <CGME20220927174642epcas5p1dafa31776d4eb8180e18f149ed25640c@epcas5p1.samsung.com>
        <20220927173610.7794-8-joshi.k@samsung.com> <20220928175904.GA17899@lst.de>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------MqMoGWHj7w70ixSxIQQUJpQDpxeWNW7xlUV_NBkU4rXoYOVD=_23360_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Sep 28, 2022 at 07:59:04PM +0200, Christoph Hellwig wrote:
> > -static int nvme_map_user_request(struct request *req, void __user *ubuffer,
> > +static int nvme_map_user_request(struct request *req, u64 ubuffer,
> 
> The changes to pass ubuffer as an integer trip me up every time.
> They are obviously fine as we do the pointer conversion less often,
> but maybe they'd be easier to follow if split into a prep patch.

ok, will separate these changes in a separate prep patch
> 
> > +	bool fixedbufs = ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED);
> >  
> > -	if (!vec)
> > -		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
> > -			GFP_KERNEL);
> > -	else {
> > +	if (vec) {
> 
> If we check IORING_URING_CMD_FIXED first this becomes a bit simpler,
> and also works better with the block helper suggested earlier:

will create a block helper for this and the scsi counterparts in the next iteration
> 
> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> index 1a45246f0d7a8..f46142dcb8f1e 100644
> --- a/drivers/nvme/host/ioctl.c
> +++ b/drivers/nvme/host/ioctl.c
> @@ -94,34 +94,33 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
>  	struct bio *bio = NULL;
>  	void *meta = NULL;
>  	int ret;
> -	bool fixedbufs = ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED);
>  
> -	if (vec) {
> -		struct iovec fast_iov[UIO_FASTIOV];
> -		struct iovec *iov = fast_iov;
> +	if (ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED)) {
>  		struct iov_iter iter;
>  
>  		/* fixedbufs is only for non-vectored io */
> -		WARN_ON_ONCE(fixedbufs);
> -		ret = import_iovec(rq_data_dir(req), nvme_to_user_ptr(ubuffer),
> -				bufflen, UIO_FASTIOV, &iov, &iter);
> +		if (WARN_ON_ONCE(vec))
> +			return -EINVAL;
> +		ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
> +				rq_data_dir(req), &iter, ioucmd);
>  		if (ret < 0)
>  			goto out;
> -
>  		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
> -		kfree(iov);
> -	} else if (fixedbufs) {
> +	} else if (vec) {
> +		struct iovec fast_iov[UIO_FASTIOV];
> +		struct iovec *iov = fast_iov;
>  		struct iov_iter iter;
>  
> -		ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
> -				rq_data_dir(req), &iter, ioucmd);
> +		ret = import_iovec(rq_data_dir(req), nvme_to_user_ptr(ubuffer),
> +				bufflen, UIO_FASTIOV, &iov, &iter);
>  		if (ret < 0)
>  			goto out;
>  		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
> -	} else
> +		kfree(iov);
> +	} else {
>  		ret = blk_rq_map_user(q, req, NULL,
> -					nvme_to_user_ptr(ubuffer), bufflen,
> -					GFP_KERNEL);
> +				nvme_to_user_ptr(ubuffer), bufflen, GFP_KERNEL);
> +	}
>  	if (ret)
>  		goto out;
>  	bio = req->bio;
> 

--
Anuj Gupta

------MqMoGWHj7w70ixSxIQQUJpQDpxeWNW7xlUV_NBkU4rXoYOVD=_23360_
Content-Type: text/plain; charset="utf-8"


------MqMoGWHj7w70ixSxIQQUJpQDpxeWNW7xlUV_NBkU4rXoYOVD=_23360_--
