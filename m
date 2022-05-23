Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D74F531357
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 18:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbiEWO5G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 10:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237417AbiEWO46 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 10:56:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7475A15C;
        Mon, 23 May 2022 07:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653317814; x=1684853814;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kt7b9LLaTfA52fM3CoAr+iwZKWbwibeMswffviI6OJ8=;
  b=Pdg6bAQeVYlGzdFKn112u3fXdOhJk8tTOFUo2KbYzSTAFAvdq2s3Ig7h
   3H+/LI1W/3btpEKnjC1qLKm2SzhoB1DJ3sf3Jv8eGDrIW1rnT9sLViMBs
   y01Ivkdv6cvc8957ONVjOA9646EQdtL75a0LGEeMgJp1t9o05f7oMEF10
   78eiWooGgvzWrsSCRS3Y4Mn9cMJjnCbJcbgGCE1kDQTFKRCUxVf+heNhE
   BswzjXbAX5J8LXdgnp98dAHcnz50FKdcycQHKjvLjkM7pLwSoZXpJlXma
   DEUohwk02aa04RKP5uNhQiL75h7ubywcqGiDh1WRGKx4Alit0G/zEhsox
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="273363190"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="273363190"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 07:56:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="663467052"
Received: from storage2.sh.intel.com (HELO localhost) ([10.67.110.197])
  by FMSMGA003.fm.intel.com with ESMTP; 23 May 2022 07:56:49 -0700
Date:   Mon, 23 May 2022 10:56:43 -0400
From:   Liu Xiaodong <xiaodong.liu@intel.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, ming.lei@redhat.com,
        xiaodong.liu@intel.com
Subject: Re: [PATCH V2 0/1] ubd: add io_uring based userspace block driver
Message-ID: <20220523145643.GA232396@storage2.sh.intel.com>
References: <20220518063808.GA168577@storage2.sh.intel.com>
 <YoTyNVccpIYDpx9q@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoTyNVccpIYDpx9q@T590>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 18, 2022 at 09:18:45PM +0800, Ming Lei wrote:
> Hello Liu,
> 
> On Wed, May 18, 2022 at 02:38:08AM -0400, Liu Xiaodong wrote:
> > On Tue, May 17, 2022 at 01:53:57PM +0800, Ming Lei wrote:
> > > Hello Guys,
> > > 
> > > ubd driver is one kernel driver for implementing generic userspace block
> > > device/driver, which delivers io request from ubd block device(/dev/ubdbN) into
> > > ubd server[1] which is the userspace part of ubd for communicating
> > > with ubd driver and handling specific io logic by its target module.
> > > 
> > > Another thing ubd driver handles is to copy data between user space buffer
> > > and request/bio's pages, or take zero copy if mm is ready for support it in
> > > future. ubd driver doesn't handle any IO logic of the specific driver, so
> > > it is small/simple, and all io logics are done by the target code in ubdserver.
> > > 
> > > The above two are main jobs done by ubd driver.
> > 
> > Not like UBD which is straightforward and starts from scratch, VDUSE is
> > embedded in virtio framework. So its implementation is more complicated, but
> > all virtio frontend utilities can be leveraged.
> > When considering security/permission issues, feels UBD would be easier to
> > solve them.
> 
> Stefan Hajnoczi and I are discussing related security/permission
> issues, can you share more details in your case?

Hi, Ming
Security/permission things covered by your discussion are more than I've
considered.
 
> > 
> > So my questions are:
> > 1. what do you think about the purpose overlap between UBD and VDUSE?
> 
> Sorry, I am not familiar with VDUSE, motivation of ubd is just to make one
> high performance generic userspace block driver. ubd driver(kernel part) is
> just responsible for communication and copying data between userspace buffers
> and kernel io request pages, and the ubdsrv(userspace) target handles io
> logic.
> 
> > 2. Could UBD be implemented with SPDK friendly functionalities? (mainly about
> > io data mapping, since HW devices in SPDK need to access the mapped data
> > buffer. Then, in function ubdsrv.c/ubdsrv_init_io_bufs(),
> > "addr = mmap(,,,,dev->cdev_fd,)",
> 
> No, that code is actually for supporting zero copy.
> 
> But each request's buffer is allocated by ubdsrv and definitely available for any
> target, please see loop_handle_io_async() which handles IO from /dev/ubdbN about
> how to use the buffer. Fro READ, the target code needs to implement READ
> logic and fill data to the buffer, then the buffer will be copied to
> kernel io request pages; for WRITE, the target code needs to use the buffer to handle
> WRITE and the buffer has been updated with kernel io request.
> 

Oh, I see. Yes, you are right. Mmapped addr in ubdsrv_init_io_bufs is not
used yet. Request's buffer is allocated by ubdsrv.


> > SPDK needs to know the PA of "addr".
> 
> What is PA? and why?

Physical address. Sorry, I forgot to expand it.
Previously I've thought Request data buffer is from mmap addr on corresponding
ubd cdev, then I just thought SPDK need to know the PA of the buffer for
its backend hardware devices.
If the request data buffer is allocated by srv process, then it was not
needed. So maybe SPDK can be efficiently working on your corrent implementation.
I'll try to draft an SPDK service backend later.

Thanks
Xiaodong

 
