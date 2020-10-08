Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC63E28771F
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 17:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbgJHP2r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 11:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730550AbgJHP2r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 11:28:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF17C061755;
        Thu,  8 Oct 2020 08:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KTnCY2TC0EEDY87TJ5e0IxZJrc3I29yWn7wm8w//0YU=; b=cn4jHTWHF0dMQGfH+Wlmn7RoRc
        wKxkeGZGZX5O0bvFm1r83vQWN7GJbqR6S0K+eJQ/13r99OV/DCtx/Jmtf9z5x7hj3S0iB4FYDMs9Z
        XwhZ5tdZXLHej+oIqdV7VuTXMrN1KFIvsHz3UoY3jOWbznZZdqNpPF8v5kwJhg8BhE/xcvgyz51Sq
        8ZA2QvO64ZgK1Jfj+SHPqy+8jyOPGCNZGunwf2SYrFRVSIN3bQcn2a7UWPyuUNWEA3OJA3x3YcZNA
        QOngRmq70pf/bcKP77QCMQx8faIAMZ3T+rxnnc6kHKnFnB1xUntDLLwWpON61lWVaPozN76OAVhYi
        Hz93dyqQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQXqW-00007S-Lh; Thu, 08 Oct 2020 15:28:44 +0000
Date:   Thu, 8 Oct 2020 16:28:44 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     syzbot <syzbot+cdcbdc0bd42e559b52b9@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Subject: Re: inconsistent lock state in xa_destroy
Message-ID: <20201008152844.GI20115@casper.infradead.org>
References: <00000000000045ac4605b12a1720@google.com>
 <de842e7f-fa50-193b-b1d7-c573e515ef8b@kernel.dk>
 <20201008150518.GG20115@casper.infradead.org>
 <ecfb657e-91fe-5e53-20b7-63e9e6105986@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecfb657e-91fe-5e53-20b7-63e9e6105986@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 08, 2020 at 09:06:56AM -0600, Jens Axboe wrote:
> On 10/8/20 9:05 AM, Matthew Wilcox wrote:
> > On Thu, Oct 08, 2020 at 09:01:57AM -0600, Jens Axboe wrote:
> >> On 10/8/20 9:00 AM, syzbot wrote:
> >>> Hello,
> >>>
> >>> syzbot found the following issue on:
> >>>
> >>> HEAD commit:    e4fb79c7 Add linux-next specific files for 20201008
> >>> git tree:       linux-next
> >>> console output: https://syzkaller.appspot.com/x/log.txt?x=12555227900000
> >>> kernel config:  https://syzkaller.appspot.com/x/.config?x=568d41fe4341ed0f
> >>> dashboard link: https://syzkaller.appspot.com/bug?extid=cdcbdc0bd42e559b52b9
> >>> compiler:       gcc (GCC) 10.1.0-syz 20200507
> >>>
> >>> Unfortunately, I don't have any reproducer for this issue yet.
> >>>
> >>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >>> Reported-by: syzbot+cdcbdc0bd42e559b52b9@syzkaller.appspotmail.com
> >>
> >> Already pushed out a fix for this, it's really an xarray issue where it just
> >> assumes that destroy can irq grab the lock.
> > 
> > ... nice of you to report the issue to the XArray maintainer.
> 
> This is from not even 12h ago, 10h of which I was offline. It wasn't on
> the top of my list of priority items to tackle this morning, but it
> is/was on the list.

How's this?

diff --git a/lib/xarray.c b/lib/xarray.c
index 1e4ed5bce5dc..d84cb98d5485 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1999,21 +1999,32 @@ EXPORT_SYMBOL_GPL(xa_delete_node);	/* For the benefit of the test suite */
  * xa_destroy() - Free all internal data structures.
  * @xa: XArray.
  *
- * After calling this function, the XArray is empty and has freed all memory
- * allocated for its internal data structures.  You are responsible for
- * freeing the objects referenced by the XArray.
- *
- * Context: Any context.  Takes and releases the xa_lock, interrupt-safe.
+ * After calling this function, the XArray is empty and has freed all
+ * memory allocated for its internal data structures.  You are responsible
+ * for freeing the objects referenced by the XArray.
+ *
+ * You do not need to call xa_destroy() if you know the XArray is
+ * already empty.  The IDR used to require this, so you may see some
+ * old code calling idr_destroy() or xa_destroy() on arrays which we
+ * know to be empty, but new code should not do this.
+ *
+ * Context: If the XArray is protected by an IRQ-safe lock, this function
+ * must not be called from interrupt context or with interrupts disabled.
+ * Otherwise it may be called from any context.  It will take and release
+ * the xa_lock with the appropriate disabling & enabling of softirqs
+ * or interrupts.
  */
 void xa_destroy(struct xarray *xa)
 {
 	XA_STATE(xas, xa, 0);
-	unsigned long flags;
+	unsigned int lock_type = xa_lock_type(xa);
 	void *entry;
 
 	xas.xa_node = NULL;
-	xas_lock_irqsave(&xas, flags);
+	xas_lock_type(&xas, lock_type);
 	entry = xa_head_locked(xa);
+	if (!entry)
+		goto out;
 	RCU_INIT_POINTER(xa->xa_head, NULL);
 	xas_init_marks(&xas);
 	if (xa_zero_busy(xa))
@@ -2021,7 +2032,8 @@ void xa_destroy(struct xarray *xa)
 	/* lockdep checks we're still holding the lock in xas_free_nodes() */
 	if (xa_is_node(entry))
 		xas_free_nodes(&xas, xa_to_node(entry));
-	xas_unlock_irqrestore(&xas, flags);
+out:
+	xas_unlock_type(&xas, lock_type);
 }
 EXPORT_SYMBOL(xa_destroy);
 
