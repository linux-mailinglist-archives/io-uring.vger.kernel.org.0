Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97FD5693B96
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 02:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjBMBHT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Feb 2023 20:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBMBHT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Feb 2023 20:07:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20E893CE
        for <io-uring@vger.kernel.org>; Sun, 12 Feb 2023 17:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676250388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I4w4+pIAJC6L4MJoTuvjbtqnVtxqrIwf9W0nUZC8tVI=;
        b=B4nw5s9CjmX3pFH5oDI5cZa+8nGcGUkW0k0QwQjuJ+JUfHLIxf5M98o6ydOCRKZRAQ+o12
        ih5nEEkSfm4MFsuNzVeBeEVTBvuKxwunJtpvYk0DlkqG+/mvtXfavYgvqfHDRFbAXSfvqj
        59wQJ+yLgsFNrM95S4shQsEdJzDTB6Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-bn6-nGPpMea0uwUfi-099A-1; Sun, 12 Feb 2023 20:06:25 -0500
X-MC-Unique: bn6-nGPpMea0uwUfi-099A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 144F71869B6C;
        Mon, 13 Feb 2023 01:06:25 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F0F0BC16022;
        Mon, 13 Feb 2023 01:06:09 +0000 (UTC)
Date:   Mon, 13 Feb 2023 09:06:03 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        ming.lei@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/4] io_uring: add IORING_OP_READ[WRITE]_SPLICE_BUF
Message-ID: <Y+mM+z519WhoOZpk@T590>
References: <20230210153212.733006-1-ming.lei@redhat.com>
 <20230210153212.733006-4-ming.lei@redhat.com>
 <a487261c-cc0e-134b-cd8e-26460fe7cf59@kernel.dk>
 <Y+e+i5BXQHcqdDGo@T590>
 <22772531-bf55-f610-be93-3d53c9ce1c6d@kernel.dk>
 <Y+hbggDCm9wViPAv@T590>
 <44355d28-776a-0134-b087-c11cf4e82f34@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44355d28-776a-0134-b087-c11cf4e82f34@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Feb 11, 2023 at 08:55:23PM -0700, Jens Axboe wrote:
> On 2/11/23 8:22?PM, Ming Lei wrote:
> >>>> Also seems like this should be separately testable. We can't add new
> >>>> opcodes that don't have a feature test at least, and should also have
> >>>> various corner case tests. A bit of commenting outside of this below.
> >>>
> >>> OK, I will write/add one very simple ublk userspace to liburing for
> >>> test purpose.
> >>
> >> Thanks!
> > 
> > Thinking of further, if we use ublk for liburing test purpose, root is
> > often needed, even though we support un-privileged mode, which needs
> > administrator to grant access, so is it still good to do so?
> 
> That's fine, some tests already depend on root for certain things, like
> passthrough. When I run the tests, I do a pass as both a regular user
> and as root. The important bit is just that the tests skip when they are
> not root rather than fail.

OK, that is nice! I am going to write one minimized ublk userspace,
which can be used in both liburing & blktests for test purpose.

> 
> > It could be easier to add ->splice_read() on /dev/zero for test
> > purpose, just allocate zeroed pages in ->splice_read(), and add
> > them to pipe like ublk->splice_read(), and sink side can read
> > from or write to these pages, but zero's read_iter_zero() won't
> > be affected. And normal splice/tee won't connect to zero too
> > because we only allow it from kernel use.
> 
> Arguably /dev/zero should still support splice_read() as a regression
> fix as I argued to Linus, so I'd just add that as a prep patch.

Understood.

> 
> >>>> Seems like this should check for SPLICE_F_FD_IN_FIXED, and also use
> >>>> io_file_get_normal() for the non-fixed case in case someone passed in an
> >>>> io_uring fd.
> >>>
> >>> SPLICE_F_FD_IN_FIXED needs one extra word for holding splice flags, if
> >>> we can use sqe->addr3, I think it is doable.
> >>
> >> I haven't checked the rest, but you can't just use ->splice_flags for
> >> this?
> > 
> > ->splice_flags shares memory with rwflags, so can't be used.
> > 
> > I think it is fine to use ->addr3, given io_getxattr()/io_setxattr()/
> > io_msg_ring() has used that.
> 
> This is part of the confusion, as you treat it basically like a
> read/write internally, but the opcode names indicate differently. Why
> not just have a separate prep helper for these and then use a layout

Looks separate prep is cleaner.

> that makes more sense,surely rwflags aren't applicable for these
> anyway? I think that'd make it a lot cleaner.
> 
> Yeah, addr3 could easily be used, but it's makes for a really confusing
> command structure when the command is kinda-read but also kinda-splice.
> And it arguable makes more sense to treat it as the latter, as it takes
> the two fds like splice.

Yeah, it can be thought as one direct splice between device and generic
file, and I'd take more words to share the whole story here.

1) traditional splice is: 

file A(read file A to pipe buffer) -> pipe -> file B(write pipe buffer to file B)

which implements zero copy for 'cp file_A file_B'.

2) device splice (device -> pipe -> file)

If only for doing 'cp device file', the current splice works just fine, however
we do not have syscall for handling the following more generic scenario:

	dev(produce buffer to pipe) -> pipe -> file(consume buffer from pipe)

splice is supposed for transferring pages over pipe, so the above model
is reasonable. And we do have kernel APIs for doing the above by direct
pipe: splice_direct_to_actor & __splice_from_pipe.

That is basically what this patch does, and consumer could be READ
or WRITE. The current splice syscall only supports WRITE consumer(
write pipe buffer to file) in pipe's read end.

It can be used for fuse to support READ zero copy(fuse write zero copy
was supported in 2010, but never support read zero copy because of missing
such syscall), and for supporting ublk zero copy.

Actually it can help to implement any "virt" drivers, most of which just
talks with file or socket, or anything which can be handled in userspace
efficiently.

Follows the usage, suppose the syscall is named as dev_splice()

	1) "poll" device A for incoming request
	- "poll' just represents one kernel/user communication, once it
	returns, there is request peeked

    - device is one virt device and exposed to userspace and for
	receiving request from userspace

	2) handling driver specific logic
	   - it could be request mapping, such as logical volume manager,
		 the logic can be quite complicated to require Btree to map
		 request from A to underlying files, such as dm-thin or bcache

	   - it could be network based device, nbd, ceph RBD, drbd, ..., usb
	   over IP, .., there could be meta lookup over socket, send
	   command/recv reply, crypto enc/dec, ...

	3) dev_splice(A, A_offset, len, B, B_offset, OP)
	- A is the device
	- B is one generic file(regular file, block device, socket, ...)
	- OP is the consumer operation(could just be read/write or net
	  recv/send)
	- A(produce buffer) -> direct pipe -> B(consume the buffer from
	pipe by OP)

	4) after the above device_splice() is completed, request is
	completed, and send notification to userspace

Now we have io_uring command for handling 1) & 4) efficiently, the
test over ublk has shown this point. If 3) can be supported, the
complicated driver/device logic in 2) can be moved to userspace.
Then the whole driver can be implemented in userspace efficiently,
performance could even be better than kernel driver[1][2].

The trouble is that when dev_splice() becomes much more generic, it is
harder to define it as syscall. It could be easier with io_uring
compared with splice() syscall, but still not easy enough:

- if the sqe interface(for providing parameters) can be stable from
  beginning, or can be extended in future easily

- REQ_F_* has been used up

- may cause some trouble inside io_uring implementation, such as, how
to convert to other io_uring OP handling with the provide consumer op code.

That is why I treat it as io_uring read/write from the beginning, the other
two could be just treated as net recv/send, and only difference is that
buffer is retrieved from direct pipe via splice(device, offset, len).

So which type is better?  Treating it as dev_spice() or specific consumer
OP? If we treat it as splice, is it better to define it as one single
generic OP, or muliple OPs and each one is mapped to single consumer OP?

I am open about the interface definition, any comment/suggestion is
highly welcome!

[1] https://lore.kernel.org/linux-block/Yza1u1KfKa7ycQm0@T590/
[2] https://lore.kernel.org/lkml/20230126040822.GA2858@1wt.eu/T/

Thanks,
Ming

