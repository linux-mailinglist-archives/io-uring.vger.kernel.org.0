Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A325F0CC4
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 15:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiI3Nvl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 09:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiI3Nvi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 09:51:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF67112BD99;
        Fri, 30 Sep 2022 06:51:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 82BB4218E2;
        Fri, 30 Sep 2022 13:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1664545895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4GdU9yhf2cWOLwfKEktqz2k86HrzmLHXXLi7u9FGdEc=;
        b=LKiOAiPNHKE8u6bKwBFJV5F4RnmPPex++wXBAh28wlvaTB7z+Wc9vhcvw7ykgslcTKJIH/
        ZkrIuMDZHoIbC3pQkOl9OLLn2Fi43fU42U4wxdKydFQH5+lhwM0g8jSYaDiifoYhQ3BrpN
        p0aXavbJ9UlBEE2W/wCJRtpMYmfxM80=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1664545895;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4GdU9yhf2cWOLwfKEktqz2k86HrzmLHXXLi7u9FGdEc=;
        b=X7UOV5cPGmi/Nv1sosGTP2P2dZT3VTzpD9DqzGCdAVxPQgU4Cbz46QLtup5sqn45sFa7Bn
        MyWcB7RnUZKEn0CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4DFAF13776;
        Fri, 30 Sep 2022 13:51:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cGf6Emf0NmOcSgAAMHmgww
        (envelope-from <jack@suse.cz>); Fri, 30 Sep 2022 13:51:35 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 7852BA0668; Fri, 30 Sep 2022 15:51:34 +0200 (CEST)
Date:   Fri, 30 Sep 2022 15:51:34 +0200
From:   Jan Kara <jack@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
        syzbot <syzbot+dfcc5f4da15868df7d4d@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, keescook@chromium.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        mhiramat@kernel.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@suse.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Matthew Bobrowski <repnop@google.com>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org
Subject: Re: [syzbot] inconsistent lock state in kmem_cache_alloc
Message-ID: <20220930135134.6retnj7vqm6i5ypo@quack3>
References: <00000000000074b50005e997178a@google.com>
 <edef9f69-4b29-4c00-8c1a-67c4b8f36af0@suse.cz>
 <20220929135627.ykivmdks2w5vzrwg@quack3>
 <0f7a2712-5252-260c-3b0f-ec584e1066a3@kernel.dk>
 <77a66454-8d18-6a92-803b-76273ec998eb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77a66454-8d18-6a92-803b-76273ec998eb@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu 29-09-22 10:54:07, Jens Axboe wrote:
> On 9/29/22 8:07 AM, Jens Axboe wrote:
> > On 9/29/22 7:56 AM, Jan Kara wrote:
> >> On Thu 29-09-22 15:24:22, Vlastimil Babka wrote:
> >>> On 9/26/22 18:33, syzbot wrote:
> >>>> Hello,
> >>>>
> >>>> syzbot found the following issue on:
> >>>>
> >>>> HEAD commit:    105a36f3694e Merge tag 'kbuild-fixes-v6.0-3' of git://git...
> >>>> git tree:       upstream
> >>>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=152bf540880000
> >>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=7db7ad17eb14cb7
> >>>> dashboard link: https://syzkaller.appspot.com/bug?extid=dfcc5f4da15868df7d4d
> >>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> >>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1020566c880000
> >>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=104819e4880000
> >>>>
> >>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >>>> Reported-by: syzbot+dfcc5f4da15868df7d4d@syzkaller.appspotmail.com
> >>>
> >>> +CC more folks
> >>>
> >>> I'm not fully sure what this report means but I assume it's because there's
> >>> a GFP_KERNEL kmalloc() allocation from softirq context? Should it perhaps
> >>> use memalloc_nofs_save() at some well defined point?
> >>
> >> Thanks for the CC. The problem really is that io_uring is calling into
> >> fsnotify_access() from softirq context. That isn't going to work. The
> >> allocation is just a tip of the iceberg. Fsnotify simply does not expect to
> >> be called from softirq context. All the dcache locks are not IRQ safe, it
> >> can even obtain some sleeping locks and call to userspace if there are
> >> suitable watches set up.
> >>
> >> So either io_uring needs to postpone fsnotify calls to a workqueue or we
> >> need a way for io_uring code to tell iomap dio code that the completion
> >> needs to always happen from a workqueue (as it currently does for writes).
> >> Jens?
> > 
> > Something like this should probably work - I'll write a test case and
> > vet it.
> 
> Ran that with the attached test case, triggers it before but not with
> the patch. Side note - I do wish that the syzbot reproducers were not
> x86 specific, I always have to go and edit them for arm64. For this
> particular one, I just gave up and wrote one myself.
> 
> Thanks for the heads-up Jan, I'll queue up this fix and mark for stable
> with the right attributions.

Thanks for fixing this so quickly! The test looks good to me.

								Honza

> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <sys/fanotify.h>
> #include <sys/wait.h>
> #include <liburing.h>
> 
> int main(int argc, char *argv[])
> {
> 	struct io_uring_sqe *sqe;
> 	struct io_uring_cqe *cqe;
> 	struct io_uring ring;
> 	int fan, ret, fd;
> 	void *buf;
> 
> 	fan = fanotify_init(FAN_CLASS_NOTIF|FAN_CLASS_CONTENT, 0);
> 	if (fan < 0) {
> 		if (errno == ENOSYS)
> 			return 0;
> 		perror("fanotify_init");
> 		return 1;
> 	}
> 
> 	if (argc > 1) {
> 		fd = open(argv[1], O_RDONLY | O_DIRECT);
> 		if (fd < 0) {
> 			perror("open");
> 			return 1;
> 		}
> 	} else {
> 		fd = open("file0", O_RDONLY | O_DIRECT);
> 		if (fd < 0) {
> 			perror("open");
> 			return 1;
> 		}
> 	}
> 
> 	ret = fanotify_mark(fan, FAN_MARK_ADD, FAN_ACCESS|FAN_MODIFY, fd, NULL);
> 	if (ret < 0) {
> 		perror("fanotify_mark");
> 		return 1;
> 	}
> 
> 	ret = 0;
> 	if (fork()) {
> 		int wstat;
> 
> 		io_uring_queue_init(4, &ring, 0);
> 		if (posix_memalign(&buf, 4096, 4096))
> 			return 0;
> 		sqe = io_uring_get_sqe(&ring);
> 		io_uring_prep_read(sqe, fd, buf, 4096, 0);
> 		io_uring_submit(&ring);
> 		ret = io_uring_wait_cqe(&ring, &cqe);
> 		if (ret) {
> 			fprintf(stderr, "wait_ret=%d\n", ret);
> 			return 1;
> 		}
> 		wait(&wstat);
> 		ret = WEXITSTATUS(wstat);
> 	} else {
> 		struct fanotify_event_metadata m;
> 		int fret;
> 
> 		fret = read(fan, &m, sizeof(m));
> 		if (fret < 0)
> 			perror("fanotify read");
> 		/* fail if mask isn't right or pid indicates non-task context */
> 		else if (!(m.mask & 1) || !m.pid)
> 			exit(1);
> 		exit(0);
> 	}
> 
> 	return ret;
> }
> 
> -- 
> Jens Axboe
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
