Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77646DE97A
	for <lists+io-uring@lfdr.de>; Wed, 12 Apr 2023 04:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjDLCem (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 22:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDLCel (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 22:34:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4BF172B
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 19:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681266836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xh3vi0ofSx2QU0YO2XPzgPE7lLpEQCLz4mn3+VeIaYI=;
        b=T2dNLn6zTLt7QkoHwZZ2AccX+iaWTUCzAzvysWWLHqcHXCqf1UDd2AQLlJAucMcgd/mYuu
        rhyVbc+vsj/v5GRienSkAczuSxBXuyLgLle5RH//IkPLAUstBlBW31uW5SHDdJGALPDyeo
        uGPnnpaTu0RvW9+QoHFTVPDatLLCi6Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-inwUphz5MJKiZgElRWbuDg-1; Tue, 11 Apr 2023 22:33:55 -0400
X-MC-Unique: inwUphz5MJKiZgElRWbuDg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C4E5811E7C;
        Wed, 12 Apr 2023 02:33:54 +0000 (UTC)
Received: from ovpn-8-26.pek2.redhat.com (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D8F7740C83A9;
        Wed, 12 Apr 2023 02:33:45 +0000 (UTC)
Date:   Wed, 12 Apr 2023 10:33:40 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
        lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        hch@lst.de, kbusch@kernel.org, ming.lei@redhat.com
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
Message-ID: <ZDYYhE1h1qvCvVmt@ovpn-8-26.pek2.redhat.com>
References: <CGME20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d@epcas5p1.samsung.com>
 <20230210180033.321377-1-joshi.k@samsung.com>
 <39a543d7-658c-0309-7a68-f07ffe850d0e@kernel.dk>
 <CA+1E3rLLu2ZzBHp30gwXBWzkCvOA4KD7PS70mLuGE8tYFpNEmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rLLu2ZzBHp30gwXBWzkCvOA4KD7PS70mLuGE8tYFpNEmA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 12, 2023 at 04:18:16AM +0530, Kanchan Joshi wrote:
> > > 4. Direct NVMe queues - will there be interest in having io_uring
> > > managed NVMe queues?  Sort of a new ring, for which I/O is destaged from
> > > io_uring SQE to NVMe SQE without having to go through intermediate
> > > constructs (i.e., bio/request). Hopefully,that can further amp up the
> > > efficiency of IO.
> >
> > This is interesting, and I've pondered something like that before too. I
> > think it's worth investigating and hacking up a prototype. I recently
> > had one user of IOPOLL assume that setting up a ring with IOPOLL would
> > automatically create a polled queue on the driver side and that is what
> > would be used for IO. And while that's not how it currently works, it
> > definitely does make sense and we could make some things faster like
> > that. It would also potentially easier enable cancelation referenced in
> > #1 above, if it's restricted to the queue(s) that the ring "owns".
> 
> So I am looking at prototyping it, exclusively for the polled-io case.
> And for that, is there already a way to ensure that there are no
> concurrent submissions to this ring (set with IORING_SETUP_IOPOLL
> flag)?
> That will be the case generally (and submissions happen under
> uring_lock mutex), but submission may still get punted to io-wq
> worker(s) which do not take that mutex.
> So the original task and worker may get into doing concurrent submissions.

It seems one defect for uring command support, since io_ring_ctx and
io_ring_submit_lock() can't be exported for driver.

It could be triggered if the request is in one link chain too.

Probably the issue may be workaround by:

	if (issue_flags & IO_URING_F_UNLOCKED)
		io_uring_cmd_complete_in_task(task_work_cb);


Thanks,
Ming

