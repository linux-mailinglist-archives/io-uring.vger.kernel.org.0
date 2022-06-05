Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FBA53DCEA
	for <lists+io-uring@lfdr.de>; Sun,  5 Jun 2022 18:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346008AbiFEQQR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jun 2022 12:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345605AbiFEQQQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Jun 2022 12:16:16 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44EE4D9F1;
        Sun,  5 Jun 2022 09:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=k0GdkbNDkasejj3kFBrsT8Gqu51kpsqMIcWZEZu6ukg=; b=nmfeBVtpMsoJcxuqepI3QEi1JJ
        zH2x0OL0814+dLD0PfySc77wJNU3QK7ZjuetHTPRmCQnLCPtruWd3jj1/QvwJBTMQS9CQwwEvR9/x
        MdBjDrj7SOGxE2XFnxEu+LYWQETJY333TVYZRdRyEtY6qNSM28sxPoafPyMwLVeZuAa4660BTZU3z
        EwXbxFDOh6V41lf9ljFZaBietjmwREAmDLwWBlGKINaVS2bQV2lYPQeYNrmm4nSWEGDb/qCXrsAq0
        dx33q6jE6zFo4sXThCrkEwtdXtFQ1wzmj6vLUJ9lqCQUP/ygEfTapGECjKxeyMY33WoqCoNqc+CSx
        NmpUn9Fg==;
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nxsv0-003ooh-Vh; Sun, 05 Jun 2022 16:15:59 +0000
Date:   Sun, 5 Jun 2022 16:15:58 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     syzbot <syzbot+47dd250f527cb7bebf24@syzkaller.appspotmail.com>
Cc:     arve@android.com, asml.silence@gmail.com, axboe@kernel.dk,
        brauner@kernel.org, gregkh@linuxfoundation.org, hdanton@sina.com,
        hridya@google.com, io-uring@vger.kernel.org,
        joel@joelfernandes.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, maco@android.com, surenb@google.com,
        syzkaller-bugs@googlegroups.com, tkjos@android.com
Subject: Re: [syzbot] KASAN: use-after-free Read in filp_close
Message-ID: <YpzWvkNcq0llgdkW@zeniv-ca.linux.org.uk>
References: <000000000000fd54f805e0351875@google.com>
 <00000000000061dcef05e0b3d4e3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000061dcef05e0b3d4e3@google.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jun 05, 2022 at 07:04:10AM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 6319194ec57b0452dcda4589d24c4e7db299c5bf
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Thu May 12 21:08:03 2022 +0000
> 
>     Unify the primitives for file descriptor closing
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=134cbe4ff00000
> start commit:   952923ddc011 Merge tag 'pull-18-rc1-work.namei' of git://g..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10ccbe4ff00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=174cbe4ff00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3096247591885bfa
> dashboard link: https://syzkaller.appspot.com/bug?extid=47dd250f527cb7bebf24
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114f7bcdf00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1659a94ff00000
> 
> Reported-by: syzbot+47dd250f527cb7bebf24@syzkaller.appspotmail.com
> Fixes: 6319194ec57b ("Unify the primitives for file descriptor closing")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Argh...  I see what's going on.  Check if the following fixes the problem,
please.

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 27c9b004823a..73beea5dc18c 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1857,6 +1857,8 @@ static void binder_deferred_fd_close(int fd)
 	init_task_work(&twcb->twork, binder_do_fd_close);
 	twcb->file = close_fd_get_file(fd);
 	if (twcb->file) {
+		// pin it until binder_do_fd_close(); see comments there
+		get_file(twcb->file);
 		filp_close(twcb->file, current->files);
 		task_work_add(current, &twcb->twork, TWA_RESUME);
 	} else {
diff --git a/fs/file.c b/fs/file.c
index dd6692048f4f..3bcc1ecc314a 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -800,8 +800,7 @@ struct file *__close_fd_get_file(unsigned int fd)
 
 /*
  * variant of close_fd that gets a ref on the file for later fput.
- * The caller must ensure that filp_close() called on the file, and then
- * an fput().
+ * The caller must ensure that filp_close() called on the file.
  */
 struct file *close_fd_get_file(unsigned int fd)
 {
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7257b0870353..33da5116cc38 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5110,7 +5110,7 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
 	struct files_struct *files = current->files;
 	struct io_close *close = &req->close;
 	struct fdtable *fdt;
-	struct file *file = NULL;
+	struct file *file;
 	int ret = -EBADF;
 
 	if (req->close.file_slot) {
@@ -5127,7 +5127,6 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
 	file = fdt->fd[close->fd];
 	if (!file || file->f_op == &io_uring_fops) {
 		spin_unlock(&files->file_lock);
-		file = NULL;
 		goto err;
 	}
 
@@ -5147,8 +5146,6 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
 err:
 	if (ret < 0)
 		req_set_fail(req);
-	if (file)
-		fput(file);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
