Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5078352B2E4
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 09:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbiERHKO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 03:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiERHKM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 03:10:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFC10E64FB
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 00:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652857810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=prrUFOxxPGBXsAVaNBQls2o1O45l2Jpg1ONT+gGV6XE=;
        b=dYbimIiwSm/8kDK01UFsfNz5+OHEEERZlY/hyxmFdXjXiDyq/861AvxKw6eoGskF+zj44E
        IiuT4jR5tffMkxis4kDYJE0oW0OR4ZFj008DmuiuCRA9voPPw+8kugOjVcrnZuTmA5vB3Z
        7139hxcz8HTa6gWqQIWAnE6DJMEnWmI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-f4PwmSjFMrK1OTWJQfOgjw-1; Wed, 18 May 2022 03:10:03 -0400
X-MC-Unique: f4PwmSjFMrK1OTWJQfOgjw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC9DD85A5BE;
        Wed, 18 May 2022 07:10:02 +0000 (UTC)
Received: from T590 (ovpn-8-29.pek2.redhat.com [10.72.8.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CF6E492C3B;
        Wed, 18 May 2022 07:09:54 +0000 (UTC)
Date:   Wed, 18 May 2022 15:09:46 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        ming.lei@redhat.com
Subject: Re: [PATCH V2 0/1] ubd: add io_uring based userspace block driver
Message-ID: <YoSbuvT88sG5UkfG@T590>
References: <20220517055358.3164431-1-ming.lei@redhat.com>
 <YoOr6jBfgVm8GvWg@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoOr6jBfgVm8GvWg@stefanha-x1.localdomain>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 17, 2022 at 03:06:34PM +0100, Stefan Hajnoczi wrote:
> Here are some more thoughts on the ubd-control device:
> 
> The current patch provides a ubd-control device for processes with
> suitable permissions (i.e. root) to create, start, stop, and fetch
> information about devices.
> 
> There is no isolation between devices created by one process and those

I understand linux hasn't device namespace yet, so can you share the
rational behind the idea of device isolation, is it because ubd device
is served by ubd daemon which belongs to one pid NS? Or the user creating
/dev/ubdbN belongs to one user NS?

IMO, ubd device is one file in VFS, and FS permission should be applied,
then here the closest model should be user NS, and process privilege &
file ownership.

> created by another. Therefore two processes that do not trust each other
> cannot both use UBD without potential interference. There is also no

Can you share what the expectation is for this situation?

It is the created UBD which can only be used in this NS, or can only be
visible inside this NS? I guess the latter isn't possible since we don't
have this kind of isolation framework yet.

> isolation for containers.
> 
> I think it would be a mistake to keep the ubd-control interface in its
> current form since the current global/root model is limited. Instead I
> suggest:
> - Creating a device returns a new file descriptor instead of a global
>   dev_id. The device can be started/stopped/configured through this (and
>   only through this) per-device file descriptor. The device is not
>   visible to other processes through ubd-control so interference is not
>   possible. In order to give another process control over the device the
>   fd can be passed (e.g. SCM_RIGHTS). 
> 

/dev/ubdcN can only be opened by the process which is the descendant of
the process which creates the device by sending ADD_DEV.

But the device can be deleted/queried by other processes, however, I
think it is reasonable if all these processes has permission to do that,
such as all processes owns the device with same uid.

So can we apply process privilege & file ownership for isolating ubd device?

If per-process FD is used, it may confuse people, because process can
not delete/query ubd device even though its uid shows it has the
privilege.

> Now multiple applications/containers/etc can use ubd-control without
> interfering with each other. The security model still requires root
> though since devices can be malicious.
> 
> FUSE allows unprivileged mounts (see fuse_allow_current_process()). Only
> processes with the same uid as the FUSE daemon can access such mounts
> (in the default configuration). This prevents security issues while
> still allowing unprivileged use cases.

OK, looks FUSE applies process privilege & file ownership for dealing
with unprivileged mounts.

> 
> I suggest adapting the FUSE security model to block devices:
> - Devices can be created without CAP_SYS_ADMIN but they have an
>   'unprivileged' flag set to true.
> - Unprivileged devices are not probed for partitions and LVM doesn't
>   touch them. This means the kernel doesn't access these devices via
>   code paths that might be exploitable.

The above two makes sense.

> - When another process with a different uid from ubdsrv opens an
>   unprivileged device, -EACCES is returned. This protects other
>   uids from the unprivileged device.

OK, only the user who owns the device can access unprivileged device.

> - When another process with a different uid from ubdsrv opens a
>   _privileged_ device there is no special access check because ubdsrv is
>   privileged.

IMO, it depends if uid of this process has permission to access the
ubd device, and we can set ubd device's owership by the process
credentials.

> 
> With these changes UBD can be used by unprivileged processes and
> containers. I think it's worth discussing the details and having this
> model from the start so UBD can be used in a wide range of use cases.

I am pretty happy to discuss & figure out the details, but not sure
it is one blocker for ubd:

1) kernel driver of loop/nbd or others haven't support the isolation

2) still don't know exact ubd use case for containers


Thanks, 
Ming

