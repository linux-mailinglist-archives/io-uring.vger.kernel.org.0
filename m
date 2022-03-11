Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509B94D681B
	for <lists+io-uring@lfdr.de>; Fri, 11 Mar 2022 18:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350319AbiCKR6H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 12:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350354AbiCKR6H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 12:58:07 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2F71C1EF1;
        Fri, 11 Mar 2022 09:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=psnf2vdFKAXENOq8/6XBZUZW2zI3JLp3NA3ERkqxEA8=; b=T70rAqZKUfG6gAOdpjYiYM5Fml
        LRYWnV4P15wi2p18JaBEiLnO/57xcO6XaFzR+QC6RYyc9M4qALmWQIpttC9OmZEk9Z9x1BQUH0MfU
        CQJU8J2fCyR5s2pXXFkDfCBkqNIh4awosb6gXTWOInVHRQQ0M7vwmmQ2IAaeLn+qbDyQD8iFqlFWP
        yW+ypP9IQYq95aB8O4NXoturP+pWMPmTNwXtK/o3u50MupWv3SztMvwKY9FFRiuTHqOSjM5UULtjt
        NPB34MI3JHz6P/Qa2H0o0WvgsHVvkjoJDxfB8pEWDKAyGajf+MyeuPwrmGGztC53Dtgz0ill5NeJk
        nywOl+Lg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nSjVX-00HY4Q-94; Fri, 11 Mar 2022 17:56:55 +0000
Date:   Fri, 11 Mar 2022 09:56:55 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Kanchan Joshi <joshi.k@samsung.com>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-security-module@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        sbates@raithlin.com, logang@deltatee.com, pankydev8@gmail.com,
        javier@javigon.com, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Message-ID: <YiuNZ7+KUjLtuYkr@bombadil.infradead.org>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com>
 <20220308152105.309618-6-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308152105.309618-6-joshi.k@samsung.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 08, 2022 at 08:50:53PM +0530, Kanchan Joshi wrote:
> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> index 5c9cd9695519..1df270b47af5 100644
> --- a/drivers/nvme/host/ioctl.c
> +++ b/drivers/nvme/host/ioctl.c
> @@ -369,6 +469,33 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	return __nvme_ioctl(ns, cmd, (void __user *)arg);
>  }
>  
> +static int nvme_ns_async_ioctl(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
> +{
> +	int ret;
> +
> +	BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) > sizeof(ioucmd->pdu));
> +
> +	switch (ioucmd->cmd_op) {
> +	case NVME_IOCTL_IO64_CMD:
> +		ret = nvme_user_cmd64(ns->ctrl, ns, NULL, ioucmd);
> +		break;
> +	default:
> +		ret = -ENOTTY;
> +	}
> +
> +	if (ret >= 0)
> +		ret = -EIOCBQUEUED;
> +	return ret;
> +}

And here I think we'll need something like this:

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index ddb7e5864be6..83529adf130d 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -5,6 +5,7 @@
  */
 #include <linux/ptrace.h>	/* for force_successful_syscall_return */
 #include <linux/nvme_ioctl.h>
+#include <linux/security.h>
 #include "nvme.h"
 
 /*
@@ -524,6 +525,11 @@ static int nvme_ns_async_ioctl(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
 
 	BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) > sizeof(ioucmd->pdu));
 
+	ret = security_file_ioctl(ioucmd->file, ioucmd->cmd_op,
+				  (unsigned long) ioucmd->cmd);
+	if (ret)
+		return ret;
+
 	switch (ioucmd->cmd_op) {
 	case NVME_IOCTL_IO64_CMD:
 		ret = nvme_user_cmd64(ns->ctrl, ns, NULL, ioucmd);
