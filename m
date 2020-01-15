Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F6313C9F9
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2020 17:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgAOQuc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jan 2020 11:50:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48183 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726566AbgAOQu3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jan 2020 11:50:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579107027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VfoUnG2aUMrp0ODubFwJ9CqBpCcuIJ4gL3/SrqOoXF8=;
        b=UffcExkXGrkvbSk4bZgmfz3UBZsyIIJfN7si7QaV+b+WvFvanqvYGWMV0wAcV2/Ilcf6SF
        rdZZrp36KVs68Fi0q6jVdngOISn/+EQihgqZT/1gd4zlnGuIGAjtNOegW+02VASNhvRy/q
        +YBVxlR9Lo/qlJAEE88QgV31gl6qoqU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-j9uCFyAdPkalB9qb-hno5w-1; Wed, 15 Jan 2020 11:50:24 -0500
X-MC-Unique: j9uCFyAdPkalB9qb-hno5w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DE95DB20;
        Wed, 15 Jan 2020 16:50:23 +0000 (UTC)
Received: from asgard.redhat.com (ovpn-112-36.ams2.redhat.com [10.36.112.36])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8ED3E6609E;
        Wed, 15 Jan 2020 16:50:20 +0000 (UTC)
Date:   Wed, 15 Jan 2020 17:50:17 +0100
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH] io_uring: fix compat for IORING_REGISTER_FILES_UPDATE
Message-ID: <20200115165017.GI1333@asgard.redhat.com>
References: <20200115163538.GA13732@asgard.redhat.com>
 <cce5ac48-641d-3051-d22c-dab7aaa5704c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cce5ac48-641d-3051-d22c-dab7aaa5704c@kernel.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jan 15, 2020 at 09:41:58AM -0700, Jens Axboe wrote:
> On 1/15/20 9:35 AM, Eugene Syromiatnikov wrote:
> > fds field of struct io_uring_files_update is problematic with regards
> > to compat user space, as pointer size is different in 32-bit, 32-on-64-bit,
> > and 64-bit user space.  In order to avoid custom handling of compat in
> > the syscall implementation, make fds __u64 and use u64_to_user_ptr in
> > order to retrieve it.  Also, align the field naturally and check that
> > no garbage is passed there.
> 
> Good point, it's an s32 pointer so won't align nicely. But how about
> just having it be:
> 
> struct io_uring_files_update {
> 	__u32 offset;
> 	__u32 resv;
> 	__s32 *fds;
> };
> 
> which should align nicely on both 32 and 64-bit?

The issue is that 32-bit user space would pass a 12-byte structure with
a 4-byte pointer in it to the 64-bit kernel, that, in turn, would treat it
as a 8-byte value (which might sometimes work on little-endian architectures,
if there are happen to be zeroes after the pointer, but will be always broken
on big-endian ones). __u64 is used in order to avoid special compat wrapper;
see, for example, __u64 usage in btrfs or BPF for similar purposes.

> -- 
> Jens Axboe
> 

