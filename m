Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55682522C90
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 08:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiEKGsb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 02:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239344AbiEKGsa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 02:48:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D32D56C32;
        Tue, 10 May 2022 23:48:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D15ACB82147;
        Wed, 11 May 2022 06:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D99C385DB;
        Wed, 11 May 2022 06:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652251705;
        bh=tNrWqK8tIdU6SRxiHlLOa4Ph699/dL/O0qY7uyHGK20=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2E8wh/pxdT3LjtP3qRls4LA304qih347csoxuQFXIPbuaes3Z9rbPOfMIG7nKgla3
         hWRhiFcbydbFx5ZZ4cM2Ph5eW1uQLN0bg8nfCUX/J2MkcgHXNtrVlsR8YBB0ILET7e
         N6WPXUGcgwIT4FGi+bL1aYGavHIlVfxDgt2+nvTc=
Date:   Wed, 11 May 2022 08:48:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "zhanghongtao (A)" <zhanghongtao22@huawei.com>
Cc:     akpm@linux-foundation.org, linfeilong@huawei.com,
        suweifeng1@huawei.com, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH] drivers:uio: Fix system crashes during driver switchover
Message-ID: <YntcNunjPdb3Clry@kroah.com>
References: <d204cc88-887c-b203-5a5b-01c307fda4fb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d204cc88-887c-b203-5a5b-01c307fda4fb@huawei.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 11, 2022 at 02:34:28PM +0800, zhanghongtao (A) wrote:
> From: Hongtao Zhang <zhanghongtao22@huawei.com>
> 
> Switch the driver of the SPDK program that is being read and written from the uio_pci_generic driver to the NVMe driver
> (Unbind the UIO driver from the device and bind the NVMe driver to the device.) ,the system crashes and restarts.
> Bug reproduction: When the SPDK is reading or writing data, run the following command: /opt/spdk/setup.sh reset

Please properly wrap your lines at 72 columns like the editor asked you
to.

> The one with a higher probability of occurrence is as follows:
> PANIC: "BUG: unable to handle kernel NULL pointer dereference at 0000000000000008"
>     [exception RIP: _raw_spin_lock_irqsave+30]
>     RIP: ffffffff836a1cae  RSP: ffff8bca9ecc3f20  RFLAGS: 00010046
>     RAX: 0000000000000000  RBX: 0000000000000246  RCX: 0000000000000017
>     RDX: 0000000000000001  RSI: 0000000000000000  RDI: 0000000000000008
>     RBP: 0000000000000000   R8: 000000afb34e50f9   R9: 0000000000000000
>     R10: 0000000000000000  R11: 0000000000000000  R12: ffff8bca9ecc3f50
>     R13: 0000000000000004  R14: 0000000000000004  R15: 0000000000000000
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #7 [ffff8bca9ecc3f28] complete at ffffffff82f09bb8
> reason:After the driver switchover, the upper-layer program can still access the bar space of the NVMe disk controller and knock the doorbell.
> To solve this problem, a reference counting is added to prevent unbind execution before the application is closed or exited.
> 
> Signed-off-by: Hongtao Zhang <zhanghongtao22@huawei.com>
> Reviewed-by: Weifeng Su <suweifeng1@huawei.com>
> ---
>  drivers/uio/uio.c          | 13 +++++++++++++
>  include/linux/uio_driver.h |  1 +
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 43afbb7c5ab9..cb8ed29a8648 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -31,6 +31,7 @@ static int uio_major;
>  static struct cdev *uio_cdev;
>  static DEFINE_IDR(uio_idr);
>  static const struct file_operations uio_fops;
> +static DECLARE_WAIT_QUEUE_HEAD(refc_wait);
> 
>  /* Protect idr accesses */
>  static DEFINE_MUTEX(minor_lock);
> @@ -501,6 +502,7 @@ static int uio_open(struct inode *inode, struct file *filep)
>  	mutex_unlock(&idev->info_lock);
>  	if (ret)
>  		goto err_infoopen;
> +	refcount_inc(&idev->dev_refc);
> 
>  	return 0;
> 
> @@ -536,6 +538,9 @@ static int uio_release(struct inode *inode, struct file *filep)
>  		ret = idev->info->release(idev->info, inode);
>  	mutex_unlock(&idev->info_lock);
> 
> +	if (refcount_dec_and_test(&idev->dev_refc))
> +			wake_up(&refc_wait);
> +
>  	module_put(idev->owner);
>  	kfree(listener);
>  	put_device(&idev->dev);
> @@ -937,6 +942,7 @@ int __uio_register_device(struct module *owner,
> 
>  	idev->owner = owner;
>  	idev->info = info;
> +	refcount_set(&idev->dev_refc, 0);
>  	mutex_init(&idev->info_lock);
>  	init_waitqueue_head(&idev->wait);
>  	atomic_set(&idev->event, 0);
> @@ -1045,6 +1051,7 @@ void uio_unregister_device(struct uio_info *info)
>  {
>  	struct uio_device *idev;
>  	unsigned long minor;
> +	unsigned int dref_count;
> 
>  	if (!info || !info->uio_dev)
>  		return;
> @@ -1052,6 +1059,12 @@ void uio_unregister_device(struct uio_info *info)
>  	idev = info->uio_dev;
>  	minor = idev->minor;
> 
> +	dref_count = refcount_read(&idev->dev_refc);
> +	if (dref_count > 0) {

You can not do this, it could have changed right after reading this.

Also we went through this many times in the past already, why submit
this type of change again?

thanks,

greg k-h
