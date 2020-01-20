Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 789CB143499
	for <lists+io-uring@lfdr.de>; Tue, 21 Jan 2020 00:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgATX44 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jan 2020 18:56:56 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:55550 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbgATX44 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jan 2020 18:56:56 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2020 18:56:55 EST
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id B565F72CC6C;
        Tue, 21 Jan 2020 02:51:46 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 8A2B77CC68F; Tue, 21 Jan 2020 02:51:46 +0300 (MSK)
Date:   Tue, 21 Jan 2020 02:51:46 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Eugene Syromiatnikov <esyr@redhat.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] io_uring: fix compat for IORING_REGISTER_FILES_UPDATE
Message-ID: <20200120235146.GA12351@altlinux.org>
References: <20200115163538.GA13732@asgard.redhat.com>
 <cce5ac48-641d-3051-d22c-dab7aaa5704c@kernel.dk>
 <20200115165017.GI1333@asgard.redhat.com>
 <a039f869-6377-b8b0-e170-0b5c17ebd4da@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a039f869-6377-b8b0-e170-0b5c17ebd4da@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jan 15, 2020 at 09:53:27AM -0700, Jens Axboe wrote:
> On 1/15/20 9:50 AM, Eugene Syromiatnikov wrote:
> > On Wed, Jan 15, 2020 at 09:41:58AM -0700, Jens Axboe wrote:
> >> On 1/15/20 9:35 AM, Eugene Syromiatnikov wrote:
> >>> fds field of struct io_uring_files_update is problematic with regards
> >>> to compat user space, as pointer size is different in 32-bit, 32-on-64-bit,
> >>> and 64-bit user space.  In order to avoid custom handling of compat in
> >>> the syscall implementation, make fds __u64 and use u64_to_user_ptr in
> >>> order to retrieve it.  Also, align the field naturally and check that
> >>> no garbage is passed there.
> >>
> >> Good point, it's an s32 pointer so won't align nicely. But how about
> >> just having it be:
> >>
> >> struct io_uring_files_update {
> >> 	__u32 offset;
> >> 	__u32 resv;
> >> 	__s32 *fds;
> >> };
> >>
> >> which should align nicely on both 32 and 64-bit?
> > 
> > The issue is that 32-bit user space would pass a 12-byte structure with
> > a 4-byte pointer in it to the 64-bit kernel, that, in turn, would treat it
> > as a 8-byte value (which might sometimes work on little-endian architectures,
> > if there are happen to be zeroes after the pointer, but will be always broken
> > on big-endian ones). __u64 is used in order to avoid special compat wrapper;
> > see, for example, __u64 usage in btrfs or BPF for similar purposes.
> 
> Ah yes, I'm an idiot, apparently not enough coffee yet. We'd need it in
> a union for this to work. I'll just go with yours, it'll work just fine.
> I will fold it in, I need to make some updates and rebase anyway.

I see the patch has missed v5.5-rc7.
Jens, please make sure a fix is merged before v5.5 is out.
Thanks,


-- 
ldv
