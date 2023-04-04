Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1C56D59F4
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 09:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbjDDHtt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 03:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbjDDHtt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 03:49:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D434810FA
        for <io-uring@vger.kernel.org>; Tue,  4 Apr 2023 00:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680594548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Im5L/NmV1DuxZwE4hnbXnlwO/3Ionh4NNqvKa/4qFqc=;
        b=JqLguYw9EKssbUP8FqNB0jhixRfmBzHOaqKhu9LkfxVFqi9pfEiC4Na6o2y63L9W1PAzKX
        OiWzmeYkggrKhEJAVA5lXSuXLmzMPCJNuPPeCAeN0Qtf7quAbofEThbHaolgCp5koT7kBU
        YwiYGpuhLk/Y0YNgH3DnnhMS7bDL+xw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-jwH89YmNPK-iUr1YjTs6Bg-1; Tue, 04 Apr 2023 03:49:03 -0400
X-MC-Unique: jwH89YmNPK-iUr1YjTs6Bg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F2431C0A59B;
        Tue,  4 Apr 2023 07:49:03 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 432FA440BC;
        Tue,  4 Apr 2023 07:48:55 +0000 (UTC)
Date:   Tue, 4 Apr 2023 15:48:50 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>, ming.lei@redhat.com
Subject: Re: [PATCH V6 00/17] io_uring/ublk: add generic IORING_OP_FUSED_CMD
Message-ID: <ZCvWYoDk0dnJbHhW@ovpn-8-16.pek2.redhat.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
 <ZConr0f8e/mEL0Cl@ovpn-8-18.pek2.redhat.com>
 <d696eb70-9dac-9334-7aec-1b5af62442e3@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d696eb70-9dac-9334-7aec-1b5af62442e3@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Jens and Everyone,

On Sun, Apr 02, 2023 at 07:24:17PM -0600, Jens Axboe wrote:
> On 4/2/23 7:11?PM, Ming Lei wrote:
> > On Thu, Mar 30, 2023 at 07:36:13PM +0800, Ming Lei wrote:
> >> Hello Jens and Guys,
> >>
> >> Add generic fused command, which can include one primary command and multiple
> >> secondary requests. This command provides one safe way to share resource between
> >> primary command and secondary requests, and primary command is always
> >> completed after all secondary requests are done, and resource lifetime
> >> is bound with primary command.
> >>
> >> With this way, it is easy to support zero copy for ublk/fuse device, and
> >> there could be more potential use cases, such as offloading complicated logic
> >> into userspace, or decouple kernel subsystems.
> >>
> >> Follows ublksrv code, which implements zero copy for loop, nbd and
> >> qcow2 targets with fused command:
> >>
> >> https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-for-v6
> >>
> >> All three(loop, nbd and qcow2) ublk targets have supported zero copy by passing:
> >>
> >> 	ublk add -t [loop|nbd|qcow2] -z .... 
> >>
> >> Also add liburing test case for covering fused command based on miniublk
> >> of blktest.
> >>
> >> https://github.com/ming1/liburing/tree/fused_cmd_miniublk_for_v6
> >>
> >> Performance improvement is obvious on memory bandwidth related workloads,
> >> such as, 1~2X improvement on 64K/512K BS IO test on loop with ramfs backing file.
> >> ublk-null shows 5X IOPS improvement on big BS test when the copy is avoided.
> >>
> >> Please review and consider for v6.4.
> >>
> >> V6:
> >> 	- re-design fused command, and make it more generic, moving sharing buffer
> >> 	as one plugin of fused command, so in future we can implement more plugins
> >> 	- document potential other use cases of fused command
> >> 	- drop support for builtin secondary sqe in SQE128, so all secondary
> >> 	  requests has standalone SQE
> >> 	- make fused command as one feature
> >> 	- cleanup & improve naming
> > 
> > Hi Jens,
> > 
> > Can you apply ublk cleanup patches 7~11 on for-6.4? For others, we may
> > delay to 6.5, and I am looking at other approach too.
> 
> Done - and yes, we're probably looking at 6.5 for the rest. But that's

Thanks!

> fine, I'd rather end up with the right interface than try and rush one.

Also I'd provide one summery about this work here so that it may help
for anyone interested in this work, follows three approaches we have
tried or proposed:

1) splice can't do this job[1][2]

2) fused command in this patchset
- it is more like sendfile() or copy_file_range(), because the internal
  buffer isn't exposed outside

- v6 becomes a bit more generic, the theory is that one SQE list is submitted
as a whole request logically; the 1st sqe is the primary command, which
provides buffer for others, and is responsible for submitting other SQEs
(secondary)in this list; the primary command isn't completed until all secondary
requests are done

- this approach solves two problems efficiently in one simple way:

	a) buffer lifetime issue, and buffer lifetime is same with primary command, so
	all secondary OPs can be submitted & completely safely

	b) request dependency issue, all secondary requests depend on primary command,
	and secondary request itself could be independent, we start to allow to submit
	secondary request in non-async style, and all secondary requests can be issued
	concurrently

- this approach is simple, because we don't expose buffer outside, and
  buffer is just shared among these secondary requests; meantime
  internal buffer saves us complicated OPs' dependency issue, avoid
  contention by registering buffer anywhere between submission and
  completion code path

- the drawback is that we add one new SQE usage/model of primary SQE and
  secondary SQEs, and the whole logical request in concept, which is
  like sendfile() or copy_file_range()

3) register transient buffers for OPs[3]
- it is more like splice(), which is flexible and could be more generic, but
internal pipe buffer is added to pipe which is visible outside, so the
implementation becomes complicated; and it should be more than splice(),
because the io buffer needs to be shared among multiple OPs

- inefficiently & complicated

	a) buffer has to be added to one global container(suppose it is
	io_uring context pipe) by ADD_BUF OP, and either buffer needs to be removed after
	consumer OPs are completed, or DEL_OP is run for removing buffer explicitly, so
	either contention on the io_uring pipe is added, or another new dependency is
	added(DEL_OP depends on all normal OPs)

	b) ADD_BUF OP is needed, and normal OPs have to depend on this new
	OP by IOSQE_IO_LINK, then all normal OPs will be submitted in async way,
	even worse, each normal OP has to be issued one by one, because io_uring
	isn't capable of handling 1:N dependency issue[5]

    c) if DEL_BUF OP is needed, then it is basically not possible
	to solve 1:N dependency any more, given DEL_BUF starts to depends on the previous
	N OPs; otherwise, contention on pipe is inevitable.

	d) solving 1:N dependency issue generically

- advantage

Follows current io_uring SQE usage, and looks more generic/flexible,
like splice().

4) others approaches or suggestions?

Any idea is welcome as usual.


Finally from problem viewpoint, if the problem domain is just ublk/fuse zero copy
or other similar problems[6], fused command might be the simpler & more efficient
approach, compared with approach 3). However, are there any other problems we
want to cover by one more generic/flexible interface? If not, would we
like to pay the complexity & inefficiency for one kind of less generic
problem?


[1] https://lore.kernel.org/linux-block/ZCQnHwrXvSOQHfAC@ovpn-8-26.pek2.redhat.com/T/#m1bfa358524b6af94731bcd5be28056f9f4408ecf
[2] https://github.com/ming1/linux/blob/my_v6.3-io_uring_fuse_cmd_v6/Documentation/block/ublk.rst#zero-copy
[3] https://lore.kernel.org/linux-block/ZCQnHwrXvSOQHfAC@ovpn-8-26.pek2.redhat.com/T/#mbe428dfeb0417487cd1db7e6dabca7399a3c265b
[4] https://lore.kernel.org/linux-block/ZCQnHwrXvSOQHfAC@ovpn-8-26.pek2.redhat.com/T/#md035ffa4c6b69e85de2ab145418a9849a3b33741
[5] https://lore.kernel.org/linux-block/20230330113630.1388860-5-ming.lei@redhat.com/T/#m5e0c282ad26d9f3d8e519645168aeb3a19b5740b
[6] https://lore.kernel.org/linux-block/20230330113630.1388860-5-ming.lei@redhat.com/T/#me5cca4db606541fae452d625780635fcedcd5c6c

Thanks,
Ming

