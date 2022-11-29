Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C6B63C25F
	for <lists+io-uring@lfdr.de>; Tue, 29 Nov 2022 15:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbiK2OYK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Nov 2022 09:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbiK2OYJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Nov 2022 09:24:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0158A10B;
        Tue, 29 Nov 2022 06:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fz04soVIIxstbn3F7s2xAQwLGgrsxhbGusIGRw7EDcA=; b=LqNhmDidQYzCiTE/JGo6cVudGr
        WD0WqUJW1Z9OeMnJbRX7eOLh/fTIj+6UNLwQTR/aeR71RFbjyHbL0tCgfBWtVXvLOySXK5bcOq+eA
        skkE2K8c+mn19piPsFYQO0Mq6rWRlKs3ThRNn+6cu/Uvi+ypHb5AN95Q2lbHnu+DvYbasGouc5M4B
        itDUEVtWV6WT4xyA94ClTlK3BdyB2YeS64Gclx4BOA3i82ffAeKUx4sM47Iegjk0kYPjwR5JhmtV8
        VAWflCgcd4sYeZgTRnHoIOypcj+5hw1UqMoo5qGK0+RfHs/dvD3aDcYEI2VNUb05m45OxcOVJRJu2
        F7VfRX3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p01Wi-009DFv-MU; Tue, 29 Nov 2022 14:24:00 +0000
Date:   Tue, 29 Nov 2022 06:24:00 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Joel Granados <j.granados@samsung.com>
Cc:     mcgrof@kernel.org, ddiss@suse.de, joshi.k@samsung.com,
        paul@paul-moore.com, ming.lei@redhat.com,
        linux-security-module@vger.kernel.org, axboe@kernel.dk,
        io-uring@vger.kernel.org
Subject: Re: [RFC v2 1/1] Use a fs callback to set security specific data
Message-ID: <Y4YWACJqlhQ80Xby@infradead.org>
References: <20221122103144.960752-1-j.granados@samsung.com>
 <CGME20221122103536eucas1p28f1c88f2300e49942c789721fe70c428@eucas1p2.samsung.com>
 <20221122103144.960752-2-j.granados@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122103144.960752-2-j.granados@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This seems to be missing any kind of changelog.  Also the
subject should say file_operations.  Most of the instances here are
not in a file system, and they most certainly aren't callbacks.

I think you've also missed a whole lot of maintainers.

> +#include "linux/security.h"

That's now how we include kernel-wide headers.

>  #include <linux/blkdev.h>
>  #include <linux/blk-mq.h>
>  #include <linux/blk-integrity.h>
> @@ -3308,6 +3309,13 @@ static int nvme_dev_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> +int nvme_uring_cmd_sec(struct io_uring_cmd *ioucmd,  struct security_uring_cmd *sec)

Douple white space and overly long line.

> +{
> +	sec->flags = 0;
> +	sec->flags = SECURITY_URING_CMD_TYPE_IOCTL;

Double initialization of ->flags.  But how is this supposed to work
to start with?
