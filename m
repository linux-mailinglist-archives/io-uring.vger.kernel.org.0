Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A109D5F6436
	for <lists+io-uring@lfdr.de>; Thu,  6 Oct 2022 12:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiJFKOJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Oct 2022 06:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiJFKOH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Oct 2022 06:14:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A766C13E
        for <io-uring@vger.kernel.org>; Thu,  6 Oct 2022 03:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665051245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dAdYI9+QG+yvH01DAjeN7mJ9hlotsPkqRPFvWXOIksI=;
        b=Qgnyv9ecFAPqGx6XXytI+AikxS82KmI1YXCSDg+FySGh1GLzHZI+03rHWAsPvtRoK+svrn
        eXgbz68sKIOaP7JTlVMnEnRsrAuKS5V/dHpoek0LGJlemqowZOqO2ZCGvCxetMS5apcS1E
        d1WRGGJjeqR+wkmiu3BpksbLoeTCK9g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-SWus2_ThNQC2TQKOd7pj9g-1; Thu, 06 Oct 2022 06:14:02 -0400
X-MC-Unique: SWus2_ThNQC2TQKOd7pj9g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B209C29AA2F4;
        Thu,  6 Oct 2022 10:14:01 +0000 (UTC)
Received: from localhost (unknown [10.39.194.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24E49477F55;
        Thu,  6 Oct 2022 10:14:01 +0000 (UTC)
Date:   Thu, 6 Oct 2022 11:14:00 +0100
From:   "Richard W.M. Jones" <rjones@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Ming Lei <tom.leiming@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Message-ID: <20221006101400.GC7636@redhat.com>
References: <Yza1u1KfKa7ycQm0@T590>
 <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590>
 <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wrote:
> qemu-nbd doesn't use io_uring to handle the backend IO,

Would this be fixed by your (not yet upstream) libblkio driver for
qemu?

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into KVM guests.
http://libguestfs.org/virt-v2v

