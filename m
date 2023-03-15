Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C733C6BA547
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 03:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjCOChF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 22:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjCOCgy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 22:36:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECE623D99
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 19:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678847772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=liFrkbl8/pWAAeZ9NlRPA0XwLoQCiHNQ8AUuy28xdJw=;
        b=JwasmC6jFFLEf9dVmSOeAhoElqqL8gt30cY+Q6623uiAGNj11t4Co6EVVO9izJKaA4WwCX
        +/08fMKckLqiyDMN+xZCXR5ABY5Sy9u8AGohiPAasa8IRLVEQbv32XrGZbi0xS0MCVAlsC
        w+h6orDSTacD20fUd+vHdzHsmJYjTOc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-66xJvKqrNgyD-S4fHovT8w-1; Tue, 14 Mar 2023 22:36:08 -0400
X-MC-Unique: 66xJvKqrNgyD-S4fHovT8w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 441608027FD;
        Wed, 15 Mar 2023 02:36:08 +0000 (UTC)
Received: from ovpn-8-22.pek2.redhat.com (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DDC0D40C6E67;
        Wed, 15 Mar 2023 02:36:04 +0000 (UTC)
Date:   Wed, 15 Mar 2023 10:35:59 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [RFC 0/2] optimise local-tw task resheduling
Message-ID: <ZBEvD04sH/JzN7MJ@ovpn-8-22.pek2.redhat.com>
References: <cover.1678474375.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1678474375.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Pavel

On Fri, Mar 10, 2023 at 07:04:14PM +0000, Pavel Begunkov wrote:
> io_uring extensively uses task_work, but when a task is waiting
> for multiple CQEs it causes lots of rescheduling. This series
> is an attempt to optimise it and be a base for future improvements.
> 
> For some zc network tests eventually waiting for a portion of 
> buffers I've got 10x descrease in the number of context switches,
> which reduced the CPU consumption more than twice (17% -> 8%).
> It also helps storage cases, while running fio/t/io_uring against
> a low performant drive it got 2x descrease of the number of context
> switches for QD8 and ~4 times for QD32.

ublk uses io_uring_cmd_complete_in_task()(io_req_task_work_add())
heavily. So I tried this patchset, looks not see obvious change
on both IOPS and context switches when running 't/io_uring /dev/ublkb0',
and it is one null ublk target(ublk add -t null -z -u 1 -q 2), IOPS
is ~2.8M.

But ublk applies batch schedule similar with io_uring before calling
io_uring_cmd_complete_in_task().

thanks,
Ming

