Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A2E5278E5
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 19:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237461AbiEORYM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 13:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiEORYM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 13:24:12 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FDC13CFD
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 10:24:10 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so11266076pjb.1
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 10:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=0fvo1YgcKhOfk3j11RAl4411QS0RkBgDiAsJ6y1nC+0=;
        b=pkHp+NuaoeQFbuDz/XhpsqT+F5o4rF2wD+vlHpiM9YHjUh4XmYJmD14J/JMSUEVAM1
         TwE1RaqcUG3EcvOvMFjCgPPlzBCVlSRmLQaqsVH/L+naVSk0UY1D1fOrA3Fxb8umM63s
         V2QrOupq6yPYCuBTWcfQafQAtsoY8NtqsbiDqtnkAnnzfyJWccsyYzDZ6aEGEHSvSq2g
         SXDtPPy8a1p4xSCTzqo0WjiqmAVw3fESIi/tChBDiH7dPOBxRMqlqr05MdEGOcBY8BAM
         AfJd4YpyMN7Y5jr8cgi8nzE5R76YTgyaZrgdFWgGxYCLPsUJGAWSi2yOPVsEmmQ/Kkiv
         E76A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=0fvo1YgcKhOfk3j11RAl4411QS0RkBgDiAsJ6y1nC+0=;
        b=qSdp2TZHgU41fJJC9SQXgVarYl22bDNcp4tvDNYoOuSgY8gk0IAqQMxA2lbbTaFS61
         dtHoC2EAavypCmj4dlz+fvYEbijj5qQYkVaXZmxQui+b9nPHNNGzavmgu2Zz09QESjvZ
         RQM62BszMJUN9k/ys/Jbmvl+xxDnQSMCcxTZKhAPJMk1sM9VmSBtjNwMWWtbfSJPvfQ/
         NUJxSHcz4mtwTANZTjg3Xf2TXsUDR9iOy5sp5l95QZFmfV8+jo5P3uNpHMaSY7R8mXhL
         5CGpAASagDa5ge4sAjQz3XrNrrxeViNhgoiAzdA3pf2apjqCfdc2jqHOAxegzJ1b28BU
         BHhQ==
X-Gm-Message-State: AOAM531VWxlua8dXoESE0PSl+srnfQJ7zgZciqtsqBJ2mDNh5+yRN8pd
        HVz33rLw4JmSa0TZhy4Oy1e0Hi0sWSMHQg==
X-Google-Smtp-Source: ABdhPJyuDgSnrABOTETleRLlPwyrMBW9QiHamSVP01TvFrlXzVVMMoKgRRyuEEOEA49Ay+FyGHnPlg==
X-Received: by 2002:a17:90a:dd46:b0:1b8:8:7303 with SMTP id u6-20020a17090add4600b001b800087303mr26607984pjv.197.1652635449961;
        Sun, 15 May 2022 10:24:09 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f14-20020a17090a9b0e00b001d26c7d5aacsm4950712pjp.13.2022.05.15.10.24.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 May 2022 10:24:09 -0700 (PDT)
Message-ID: <6a55698b-42e7-7f0b-e09d-468d7673c68c@kernel.dk>
Date:   Sun, 15 May 2022 11:24:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix locking state for empty buffer group
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_provided_buffer_select() must drop the submit lock, if needed, even
in the error handling case. Failure to do so will leave us with the
ctx->uring_lock held, causing spew like:

====================================
WARNING: iou-wrk-366/368 still has locks held!
5.18.0-rc6-00294-gdf8dc7004331 #994 Not tainted
------------------------------------
1 lock held by iou-wrk-366/368:
 #0: ffff0000c72598a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_ring_submit_lock+0x20/0x48

stack backtrace:
CPU: 4 PID: 368 Comm: iou-wrk-366 Not tainted 5.18.0-rc6-00294-gdf8dc7004331 #994
Hardware name: linux,dummy-virt (DT)
Call trace:
 dump_backtrace.part.0+0xa4/0xd4
 show_stack+0x14/0x5c
 dump_stack_lvl+0x88/0xb0
 dump_stack+0x14/0x2c
 debug_check_no_locks_held+0x84/0x90
 try_to_freeze.isra.0+0x18/0x44
 get_signal+0x94/0x6ec
 io_wqe_worker+0x1d8/0x2b4
 ret_from_fork+0x10/0x20

and triggering later hangs off get_signal() because we attempt to
re-grab the lock.

Reported-by: syzbot+987d7bb19195ae45208c@syzkaller.appspotmail.com
Fixes: 149c69b04a90 ("io_uring: abstract out provided buffer list selection")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3c39f5413c1b..64450af959ff 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3467,20 +3467,23 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 					      struct io_buffer_list *bl,
 					      unsigned int issue_flags)
 {
-	struct io_buffer *kbuf;
+	void __user *ret = ERR_PTR(-ENOBUFS);
 
-	if (list_empty(&bl->buf_list))
-		return ERR_PTR(-ENOBUFS);
+	if (!list_empty(&bl->buf_list)) {
+		struct io_buffer *kbuf;
+
+		kbuf = list_first_entry(&bl->buf_list, struct io_buffer, list);
+		list_del(&kbuf->list);
+		if (*len > kbuf->len)
+			*len = kbuf->len;
+		req->flags |= REQ_F_BUFFER_SELECTED;
+		req->kbuf = kbuf;
+		req->buf_index = kbuf->bid;
+		ret = u64_to_user_ptr(kbuf->addr);
+	}
 
-	kbuf = list_first_entry(&bl->buf_list, struct io_buffer, list);
-	list_del(&kbuf->list);
-	if (*len > kbuf->len)
-		*len = kbuf->len;
-	req->flags |= REQ_F_BUFFER_SELECTED;
-	req->kbuf = kbuf;
-	req->buf_index = kbuf->bid;
 	io_ring_submit_unlock(req->ctx, issue_flags);
-	return u64_to_user_ptr(kbuf->addr);
+	return ret;
 }
 
 static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
-- 
Jens Axboe

